#==============================================================================
# ■ Game_Battler
#------------------------------------------------------------------------------
# 　处理战斗者的类。这个类作为 Game_Actor 类与 Game_Enemy 类的
# 超级类来使用。
#
#  这个类被重写，添加了新的函数，用来执行战斗功能主要添加的函数有：
#   preattack—— 准备攻击
#   doattack——  攻击
#   predamage—— 准备伤害
#   dodamage —— 执行伤害
#
#  另外重写了其他的属性获取
#
#==============================================================================

class Game_Battler
	include GAME_CONF
	attr_accessor   	:bomflag           	# 是否暴击
	attr_accessor   	:hitflag           	# 是否命中 
	attr_accessor   	:maxhp_plus
	attr_accessor   	:maxmp_plus
	attr_accessor   	:fcounthp          	# 记录帧数，计算恢复HP
	attr_accessor   	:fcountmp          	# 记录帧数，计算恢复MP
	attr_accessor		:screen_x 			# 战斗sprite 的位置 
	attr_accessor 		:screen_y			# 战斗sprite 的位置 
	attr_accessor 		:screen_z			# 战斗sprite 的位置 
	attr_accessor		:animation_id		# 记录即将执行的动画{播放顺序如果同时生效 => [距离生效时间,动画编号]}
	attr_accessor 		:my_skills 			# 战斗者的技能列表{priority => {[name, level] => skill}}
	attr_accessor       :skill_limit		# 可以学习的技能的上限，只能通过函数can_add_skill生效
	#-------------------------------------------------------------
	#--------------------------------------------------------------------------
	# ● 初始化对像
	#
	#     已經重新定義
	#--------------------------------------------------------------------------
	alias new_battler_initialize initialize
	def initialize
		new_battler_initialize
		animation_id = {}
		@states = {}
		@my_skills = {}
		@skill_limit = 6
	end
	#--------------------------------------------------------------------------
	# ● 清理能力值增加值
	#
	#--------------------------------------------------------------------------
	def clear_extra_values
		@maxhp_plus = 0
		@maxmp_plus = 0
		@atk_plus = 0
		@def_plus = 0
		@spi_plus = 0
		@agi_plus = 0
	end
	#--------------------------------------------------------------------------
	# ● 清理与活动块做通信用的变量
	#--------------------------------------------------------------------------
	def clear_sprite_effects
		@animation_id = {}
		@animation_mirror = false
		@white_flash = false
		@blink = false
		@collapse = false
	end
	#--------------------------------------------------------------------------
	# ● 清理保持行动效果的变量
	#--------------------------------------------------------------------------
	def clear_action_results
		@skipped = false
		@missed = false
		@evaded = false
		@critical = false
		@absorbed = false
		@hp_damage = 0
		@mp_damage = 0
		@added_states = []              # 附加状态 (ID 顺序)
		@removed_states = []            # 解除状态 (ID 顺序)
		@remained_states = []           # 没有变化的状态 (ID 顺序)
	end
	#--------------------------------------------------------------------------
	# ● 全回复
	#--------------------------------------------------------------------------
	def recover_all
		@hp = maxhp
		@mp = maxmp
		self.clear_states
	end
	#--------------------------------------------------------------------------
	# ● 获取现在状态对象
	#--------------------------------------------------------------------------
	def states
		result = []
		for key in @states.keys
			result.concat(@states[key])
		end
		return result
	end
	#--------------------------------------------------------------------------
	# ● 添加状态
	#	@states = {priority => [state, state, ...]}
	#
	#  	state 	: 		需要添加的状态
	# 	uniq 	:		是否按名字保持唯一性。true-是，false-否，如果是则不可叠加
	#	most	:		true-最高等级覆盖，false-最低等级覆盖 		
	#
	#--------------------------------------------------------------------------
	def add_state(state, uniq = false, most = true)
		# 保证该优先级的状态不为空
		if nil == @states[state.priority]
			@states[state.priority] = []
		end
		# 名字唯一性
		if true == uniq
			# 尝试找同名、捅优先级的技能
			for s in @states[state.priority]
				if s.name == state.name and s.instance_of?(state.class)
					# 找到可以覆盖的，则删除，然后继续
					if (true == most and state.level > s.level) or (false == most and state.level < s.level)
						@states[state.priority].delete(s)
						break 
					# 否则找到比自己等级高的同类，直接返回
					elsif (true == most and state.level <= s.level) or (false == most and state.level >= s.level)
						return 
					end
				end
			end	
		end
		# 根据可叠加性质添加
		num = state_num(state)
		if (!state.can_accumulate? and 0 == num) or (state.can_accumulate? and num < state.max_accumulate)
			@states[state.priority].push(state)
		end
		
		
	end
	#--------------------------------------------------------------------------
	# ● 返回角色包含该state的重数，没有改state则返回0
	#   技能名字与等级唯一确定一个技能。
	#--------------------------------------------------------------------------
	def state_num(state)
		ret = 0
		for key in @states.keys
			if @states[key] != nil
				for s in @states[key]
					if s.name == state.name and s.level == state.level and s.instance_of?(state.class)
						ret += 1
					end
				end
			end
		end
		return ret
	end
	#--------------------------------------------------------------------------
	# ● 移除所有状态
	#--------------------------------------------------------------------------
	def clear_states
		for key in @states.keys
			@states.delete(key)
		end
	end
	#--------------------------------------------------------------------------
	# ● 刷新所有状态
	#--------------------------------------------------------------------------
	def refresh_states
		for key in @states.keys
			array_size = @states[key].size - 1
			# 从后往前删，这一点很关键
			for i in 0...@states[key].size
				@states[key][array_size-i].timer -= 1
				if @states[key][array_size-i].timer <= 0
					@states[key].delete_at(array_size-i)
				end
			end
		end
	end
	#--------------------------------------------------------------------------
	# ● 重置所有技能
	#--------------------------------------------------------------------------
	def reset_skills
		for priority in @my_skills.keys
			for key in @my_skills[priority].keys
				@my_skills[priority][key].reset
			end
		end
	end
	#--------------------------------------------------------------------------
	# ● 获得技能列表 - 按优先级从小到大排列
	#--------------------------------------------------------------------------
	def get_skills
		ret = []
		for priority in @my_skills.keys.sort
			for key in @my_skills[priority].keys
				ret.push(@my_skills[priority][key])
			end
		end
		return ret
	end
	#--------------------------------------------------------------------------
	# ● 返回技能列表中最大优先级数字最大的技能的优先级。
	#	在创建新技能的时候会用到；新加入的技能优先级数字依次增大。
	#--------------------------------------------------------------------------
	def max_skill_priority
		priorities = @my_skills.keys.sort
		if priorities.size > 0
			return priorities[priorities.size-1]
		else
			return 0
		end
	end
	#--------------------------------------------------------------------------
	# ● 判断技能是否存在 -- 名字、等级相同则是同一个技能；优先级不算
	#--------------------------------------------------------------------------
	def skill_exist?(skill)
		for s in self.get_skills
			if skill.name == s.name and skill.level == s.level
				return true
			end
		end
		return false
	end
	#--------------------------------------------------------------------------
	# ● 添加技能
	#--------------------------------------------------------------------------
	def add_skill(skill)
		if skill_exist?(skill)
			return false
		end
		if @my_skills[skill.priority] != nil
			if not (@my_skills[skill.priority].keys.include?([skill.name, skill.level]))
				@my_skills[skill.priority][[skill.name, skill.level]] = skill
			end
		else
			@my_skills[skill.priority] = {}
			@my_skills[skill.priority][[skill.name, skill.level]] = skill
		end
		return true
	end
	#--------------------------------------------------------------------------
	# ● 判断是否能添加技能添加技能
	#    目前只考虑数量，以及重复问题。以后可以考虑其他。
	#--------------------------------------------------------------------------
	def can_add_skill?(skill)
		return false if nil == skill
		return false if skill_exist?(skill)
		return (get_skills.size < @skill_limit)
	end
	#--------------------------------------------------------------------------
	# ● 移除所有名字与所给名字相同的技能
	#--------------------------------------------------------------------------	
	def delete_skill_by_name(name)
		for priority in @my_skills.keys
			for key in @my_skills[priority]
				if key.include?(name)
					return @my_skills[priority].delete(key)
				end
			end
		end
		return nil
	end
	#--------------------------------------------------------------------------
	# ● 移除所有名字与所给等级相同的技能
	#--------------------------------------------------------------------------	
	def delete_skill_by_level(level)
		for priority in @my_skills.keys
			for key in @my_skills[priority]
				if key.include?(level)
					return @my_skills[priority].delete(key)
				end
			end
		end
		return nil
	end
	#--------------------------------------------------------------------------
	# ● 移除所有指定优先级的技能
	#--------------------------------------------------------------------------	
	def delete_skill_by_priority(priority)
		return @my_skills.delete(priority)
	end
	#--------------------------------------------------------------------------
	# ● 移除给定名字和等级的技能,返回被删除的技能
	#--------------------------------------------------------------------------	
	def delete_skill_by_name_level(name, level)
		for priority in @my_skills.keys
			if nil != (value = @my_skills[priority].delete([name, level]))
				return value
			end
		end
		return nil
	end
	#--------------------------------------------------------------------------
	# ● 移除给技能,成功返回true,失败返回false
	#--------------------------------------------------------------------------	
	def delete_skill(skill)
		return (nil != delete_skill_by_name_level(skill.name, skill.level))
	end
	#=========================================================================
	#  self 系列的参数，是自身条件产生的，没有依靠任何装备  
	#=========================================================================  
	#--------------------------------------------------------------------------
	# ● 获得自身maxhp
	#--------------------------------------------------------------------------
	def self_maxhp
		n = @hmaxhp
		n += base_strength * GAME_CONF::BONUS_STRENGTH_MAXHP
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获得自身maxmp
	#--------------------------------------------------------------------------
	def self_maxmp
		n = @hmaxmp
		n += base_wisdom * GAME_CONF::BONUS_WISDOM_MAXMP
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获得自身atk
	#--------------------------------------------------------------------------
	def self_atk
		n = @hatk
		# 主属性加成
		case @type
		when 1    # 力量
			n += base_strength * GAME_CONF::BONUS_STRENGTH_ATTACK
		when 2    # 敏捷
			n += base_celerity * GAME_CONF::BONUS_CELERITY_ATTACK
		when 3    # 智力
			n += base_wisdom * GAME_CONF::BONUS_WISDOM_ATTACK
		end
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获得自身def
	#
	#    防御+敏捷奖励
	#
	#--------------------------------------------------------------------------
	def self_def
		n = @hdef
		# 每一点敏捷增加0.33点防御力
		n += base_celerity * GAME_CONF::BONUS_CELERITY_DEF
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获得自身力量
	#
	#      力量
	#
	#--------------------------------------------------------------------------
	def self_strength
		n = @strength
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获得自身敏捷
	#
	#      敏捷
	#
	#--------------------------------------------------------------------------
	def self_celerity
		n = @celerity
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获得自身智力
	#
	#      智力
	#
	#--------------------------------------------------------------------------
	def self_wisdom
		n = @wisdom
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获得自身物理破坏因子
	#
	#      物理伤害+系统初始值+带装备力量奖励
	#
	#--------------------------------------------------------------------------
	def self_destroy
		n = @destroy + GAME_CONF::CONST_BASE_DESTROY
		n += base_strength * BONUS_STRENGTH_DESTROY
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获得自身魔法破坏因子
	#
	#       魔法伤害+系统初始值+带装备智力奖励
	#
	#--------------------------------------------------------------------------
	def self_mdestroy
		n = @mdestroy + GAME_CONF::CONST_BASE_MDESTROY
		n += base_wisdom * BONUS_WISDOM_MDESTROY
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获得自身攻速因子
	#
	#       攻速因子+带装备敏捷奖励
	#
	#--------------------------------------------------------------------------
	def self_atkspeed
		n = @atkspeed
		n += base_celerity * GAME_CONF::BONUS_CELERITY_ATKSPEED
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获得自身闪避因子
	#
	#    (闪避因子+敏捷奖励)*扩张率 -- 扩张率目前没有定义任何武器装备会导致该值上涨
	#		不排除一些技能会暂时改变@evarate的值
	#
	#--------------------------------------------------------------------------
	def self_eva
		n = (@eva + base_celerity * BONUS_CELERITY_EVA) * (1 + @evarate/100.0)
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获得自身命中因子
	#
	#    (命中因子+敏捷奖励)*扩张率 -- 扩张率目前没有任何武器能够增加
	# 	不排除一些技能会暂时改变@hitrate的值
	#
	#--------------------------------------------------------------------------
	def self_hit
		n = (@hit + base_celerity * BONUS_CELERITY_HIT) * (1 + @hitrate/100.0)
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获得自身暴击因子
	#
	#        (暴击因子+力量奖励)*扩张率 -- 扩张率目前没有任何武器能够增加
	#			不排除一些技能会暂时改变@bomrate的值
	#
	#--------------------------------------------------------------------------
	def self_bom
		n = (@bom + base_strength * BONUS_STRENGTH_BOM) * (1 + @bomrate/100.0)
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获得自身暴击威力
	#
	#        暴击威力 -- 非常直接的暴击威力值，一般都是100(%)
	# 		不排除有些技能可以暂时改变@bomatk的值
	#
	#--------------------------------------------------------------------------
	def self_bomatk
		n = @bomatk
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获得自身生命恢复
	#
	#      生命恢复+力量奖励+生命百分比恢复 -- self_maxhp 受到躶体maxhp 和 带装备力量的影响
	#
	#--------------------------------------------------------------------------
	def self_hpcover
		# 自身hpcover -- 通过加点获得
		n = @hpcover
		# 带装备力量奖励
		n += base_strength * GAME_CONF::BONUS_STRENGTH_HPCOVER
		# 自身maxhp按百分比恢复， hprate 通常为0，表示一般都不会按比例增加
		# 这个hprate主要是给monster用的，可以通过数据库指定某个BOSS的hprate,从而该BOSS生命恢复很快。
		n += self_maxhp * @hprate / 100.0
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获得自身魔法恢复
	#
	#    魔法恢复+智力奖励+魔法百分比恢复 -- self_maxmp 受到躶体maxmp 和 带装备智力的影响
	#
	#--------------------------------------------------------------------------
	def self_mpcover
		n = @mpcover
		n += base_wisdom * GAME_CONF::BONUS_WISDOM_MPCOVER
		n += self_maxmp * @mprate / 100.0
		return n
	end  
	#=========================================================================
	#  base 系列的参数，有了装备之后的参数，不考虑技能、实战的影响。
	#
	#=========================================================================  
	#--------------------------------------------------------------------------
	# ● 获取基本 MaxHP
	#
	#     重写覆盖  
	#     类型加成     :例如力量型英雄，生命值会再次加成
	#
	#     其实最后到battler类中还有一个状态加成，例如“攻击力上升”状态
	#--------------------------------------------------------------------------
	def base_maxhp
		# self_maxhp 只受躶体maxhp和带装备力量影响
		n = self_maxhp
		# 装备百分比加成 -- 装备按照百分比扩张,例如2个150%的装备,xmaxhprate=50
		n *= (@xmaxhprate + 100.0) / 100.0
		# 装备加成
		n += @xhmaxhp
		# 状态加成，被动技能加成通过附加状态来实现 -- 这里的按比例加成较厉害，按数字加成效果较小
		delta = 0
		for state in states
			delta += n * state.maxhp_rate / 100.0
			delta += state.maxhp
		end
		n += delta
		# 类型加成 -- 暂时不实现
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获取基本 MaxMP
	#
	#    重写覆盖
	#
	#--------------------------------------------------------------------------
	def base_maxmp
		# n初始为自身maxhp
		n = self_maxmp
		# 装备百分比加成
		n *= (@xmaxmprate + 100.0) / 100.0
		# 装备加成
		n += @xhmaxmp
		# 状态加成，被动技能加成通过附加状态来实现 -- 这里的按比例加成较厉害，按数字加成效果较小
		delta = 0
		for state in states
			delta += n * state.maxmp_rate / 100.0
			delta += state.maxmp
		end
		n += delta
		# 类型加成 -- 暂时不实现
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获取基本攻击力
	# 
	#     重写覆盖 
	#
	#--------------------------------------------------------------------------
	def base_atk
		# self_atk为裸体atk + 带装备主属性加成
		n = self_atk
		# 装备百分比加成
		n *= (@xmaxatkrate + 100.0) / 100.0
		# 装备加成
		n += @xhatk
		# 状态加成，被动技能加成通过附加状态来实现 -- 这里的按比例加成较厉害，按数字加成效果较小
		delta = 0
		for state in states
			delta += n * state.atk_rate / 100.0
			delta += state.atk
		end
		n += delta
		# 类型加成 -- 暂时不实现
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获取基本防御力
	#
	#    重写覆盖
	#
	#--------------------------------------------------------------------------
	def base_def
		# self_def为裸体def + 带装备敏捷加成
		n = self_def
		# 装备百分比加成
		n *= (@xmaxdefrate + 100.0) / 100.0
		# 每一件装备增加的防御力
		n += @xhdef
		# 状态加成，被动技能加成通过附加状态来实现 -- 这里的按比例加成较厉害，按数字加成效果较小
		delta = 0
		for state in states
			delta += n * state.def_rate / 100.0
			delta += state.def
		end
		n += delta
		# 类型加成 -- 暂时不实现
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获取基本力量
	#
	#     新加
	#
	#--------------------------------------------------------------------------
	def base_strength
		n = self_strength
		# 装备百分比加成
		n *= (@xmaxstrengthrate + 100.0) / 100.0
		# 装备加成的力量
		n += @xstrength
		# 状态加成，被动技能加成通过附加状态来实现 -- 这里的按比例加成较厉害，按数字加成效果较小
		delta = 0
		for state in states
			delta += n * state.strength_rate / 100.0
			delta += state.strength
		end
		n += delta
		return n
	end  
	#--------------------------------------------------------------------------
	# ● 获取基本智力
	#
	#     新加
	#
	#--------------------------------------------------------------------------
	def base_wisdom
		n = self_wisdom
		# 装备百分比加成
		n *= (@xmaxwisdomrate + 100.0) / 100.0
		# 装备加成的智力
		n += @xwisdom
		# 状态加成，被动技能加成通过附加状态来实现 -- 这里的按比例加成较厉害，按数字加成效果较小
		delta = 0
		for state in states
			delta += n * state.wisdom_rate / 100.0
			delta += state.wisdom
		end
		n += delta
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获取基本敏捷
	#
	#     新加
	#
	#--------------------------------------------------------------------------
	def base_celerity
		n = self_celerity
		# 装备百分比加成
		n *= (@xmaxcelerityrate + 100.0) / 100.0
		# 装备加成的敏捷
		n += @xcelerity
		# 状态加成，被动技能加成通过附加状态来实现 -- 这里的按比例加成较厉害，按数字加成效果较小
		delta = 0
		for state in states
			delta += n * state.celerity_rate / 100.0
			delta += state.celerity
		end
		n += delta
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获取基本物理伤害
	#
	#     新加
	#
	#--------------------------------------------------------------------------
	def base_destroy
		# self_destroy为裸体destroy + 带装备力量奖励
		n = self_destroy + @xdestroy
		# 状态加成，被动技能加成通过附加状态来实现 -- 这里的按比例加成较厉害，按数字加成效果较小
		delta = 0
		for state in states
			delta += n * state.destroy_rate / 100.0
			delta += state.destroy
		end
		n += delta
		return n
	end  
	#--------------------------------------------------------------------------
	# ● 获取基本魔法伤害
	#
	#     新加
	#
	#--------------------------------------------------------------------------
	def base_mdestroy
		n = self_mdestroy + @xmdestroy
		# 状态加成，被动技能加成通过附加状态来实现 -- 这里的按比例加成较厉害，按数字加成效果较小
		delta = 0
		for state in states
			delta += n * state.mdestroy_rate / 100.0
			delta += state.mdestroy
		end
		n += delta
		return n
	end  
	#--------------------------------------------------------------------------
	# ● 获取基本攻速因子
	#
	#     新加
	#
	#--------------------------------------------------------------------------
	def base_atkspeed
		# self_atkspeed为裸体攻速 + 带装备敏捷奖励
		n = self_atkspeed + @xatkspeed
		# 状态加成，被动技能加成通过附加状态来实现 -- 这里的按比例加成较厉害，按数字加成效果较小
		delta = 0
		for state in states
			delta += n * state.atkspeed_rate / 100.0
			delta += state.atkspeed
		end
		n += delta
		return n    
	end   
	#--------------------------------------------------------------------------
	# ● 获取基本闪避技巧
	#
	#     新加
	#
	#--------------------------------------------------------------------------
	def base_eva
		# self_eva为裸体闪避 + 带装备敏捷奖励
		n = self_eva
		# 扩张
		n *= (100.0 + @xevarate) / 100.0
		# 装备加成
		n += @xeva
		# 状态加成，被动技能加成通过附加状态来实现 -- 这里的按比例加成较厉害，按数字加成效果较小
		delta = 0
		for state in states
			delta += n * state.eva_rate / 100.0
			delta += state.eva
		end
		n += delta
		return n    
	end
	#--------------------------------------------------------------------------
	# ● 获取基本闪避技巧
	#
	#     新加
	#
	#--------------------------------------------------------------------------
	def base_hit
		# self_hit为躶体命中 + 带装备敏捷奖励
		n = self_hit
		n *= (100.0 + @xhitrate) / 100.0
		n += @xhit
		# 状态加成，被动技能加成通过附加状态来实现 -- 这里的按比例加成较厉害，按数字加成效果较小
		# 此加成包括装备加成
		delta = 0
		for state in states
			delta += n * state.hit_rate / 100.0
			delta += state.hit
		end
		n += delta
		return n    
	end
	#--------------------------------------------------------------------------
	# ● 获取基本暴击技巧
	#
	#     新加
	#
	#--------------------------------------------------------------------------
	def base_bom
		# self_bom为躶体暴击技巧 + 带装备力量奖励
		n = self_bom
		n = n * (100.0 + @xbomrate) / 100.0 + @xbom
		# 状态加成，被动技能加成通过附加状态来实现 -- 这里的按比例加成较厉害，按数字加成效果较小
		delta = 0
		for state in states
			delta += n * state.bom_rate / 100.0
			delta += state.bom
		end
		n += delta
		return n    
	end
	#--------------------------------------------------------------------------
	# ● 获得基本暴击威力
	#
	#      新加 
	#
	#--------------------------------------------------------------------------
	def base_bomatk
		# self_bomatk为躶体暴击威力，通常为100%，只有技能或者状态能够改变这个值
		n = self_bomatk + @xbomatk
		# 状态加成，被动技能加成通过附加状态来实现 -- 这里的按比例加成较厉害，按数字加成效果较小
		delta = 0
		for state in states
			delta += n * state.bomatk_rate / 100.0
			delta += state.bomatk
		end
		n += delta
		return n
	end  
	#--------------------------------------------------------------------------
	# ● 获得自身生命恢复
	#
	#      生命恢复+力量奖励+生命百分比恢复
	#
	#--------------------------------------------------------------------------
	def base_hpcover
		# self_hpcover为躶体hpcover + 带装备力量奖励 + self_hp*hprate -- 通常hprate就是0
		n = self_hpcover
		# 装备增加
		n += @xhpcover 
		# 按百分比回复 -- 有些装备能够按照百分比回血，是算上装备的百分比
		n += base_maxhp * @xhprate / 100.0
		# 按照最大生命比例加血的状态
		delta = 0
		for state in states
			delta += base_maxhp * state.hpcover_rate / 100.0
			delta += state.hpcover
		end
		n += delta
		# 按照当前恢复量比例加血的状态
		delta = 0
		for state in states
			delta += n * state.hpcover_boost_rate / 100.0
		end
		n += delta
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获得自身魔法恢复
	#
	#    魔法恢复+智力奖励+魔法百分比恢复
	#
	#--------------------------------------------------------------------------
	def base_mpcover
		n = self_mpcover
		n += @xmpcover
		# 按百分比回复
		n += base_maxmp * @xmprate / 100.0
		# 状态加成，被动技能加成通过附加状态来实现 -- 这里的按比例加成较厉害，按数字加成效果较小
		delta = 0
		for state in states
			delta += base_maxmp * state.mpcover_rate / 100.0
			delta += state.mpcover
		end
		n += delta
		return n
	end
	#=========================================================================
	#  final 系列的参数，最终战斗的时候表现出来的参数
	#
	#========================================================================= 
	#--------------------------------------------------------------------------
	# ● 获取 MaxHP 的限制值
	#--------------------------------------------------------------------------
	def maxhp_limit
		return 999999999
	end
	#--------------------------------------------------------------------------
	# ● 获取 MaxHP
	#--------------------------------------------------------------------------
	def maxhp
		# @maxhp_plus为状态对maxhp的影响提供了可能
		return [[base_maxhp + @maxhp_plus, 1].max, maxhp_limit].min
	end
	#--------------------------------------------------------------------------
	# ● 获取 MaxMP
	#--------------------------------------------------------------------------
	def maxmp
		return [[base_maxmp + @maxmp_plus, 0].max, 99999999].min
	end
	#--------------------------------------------------------------------------
	# ● 更改 HP
	#     hp : 新的 HP
	#--------------------------------------------------------------------------
	def hp=(hp)
		@hp = [[hp, maxhp].min, 0].max
	end
	#--------------------------------------------------------------------------
	# ● 更改 MP
	#     mp : 新的 MP
	#--------------------------------------------------------------------------
	def mp=(mp)
		@mp = [[mp, maxmp].min, 0].max
	end
	#--------------------------------------------------------------------------
	# ● 获取生命值
	#
	#    屏蔽Game_Battler的hp属性，为了每次获取的时候能够修改
	#
	#--------------------------------------------------------------------------
	def hp
		return @hp if @hp <= 0
		# 间隔设为0.1秒
		hpcover_interval = Graphics.frame_rate / 30.0
		# 每次超过间隔都会更新一下
		if (temp = Graphics.frame_count - @fcounthp) >= hpcover_interval
			# 更新fcounthp
			@fcounthp = Graphics.frame_count
			# 过了超过一秒
			temp /= Graphics.frame_rate.to_f
			# 非战斗状态，回血快
			if $game_switches[103] == false
				@hp = [@hp + temp * self.maxhp * 0.1 * 1.0 / hpcover_interval, self.maxhp].min
				# 战斗状态，回血慢
			else
				@hp = [@hp + temp * self.final_hpcover, self.maxhp].min
			end
				# 返回新的hp
				return @hp
				# 否则直接返回
		else
			return @hp
		end
	end  
	#--------------------------------------------------------------------------
	# ● 获取生命值
	#
	#    屏蔽Game_Battler的mp属性，为了每次获取的时候能够修改
	#	   暂时不管MP恢复问题	
	#--------------------------------------------------------------------------
	def mp
		return @mp if @mp <= 0
		if (temp = Graphics.frame_count - @fcountmp) >= 60
			# 更新fcountmp
			@fcountmp = Graphics.frame_count
			# 过了超过一秒
			temp /= 60.0
			@mp = [@mp + temp * self.final_mpcover, self.maxmp].min
			# 返回新的hp
			return @mp
		# 否则直接返回
		else
			return @mp
		end
	end
	#--------------------------------------------------------------------------
	# ● 获取攻击力
	#
	#    重写覆盖，支持浮点数
	#
	#--------------------------------------------------------------------------
	def atk
		n = [[base_atk + @atk_plus, 1].max, 9999999].min
		n = [[n, 1].max, 9999999].min
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获取防御力
	#
	#     重新覆盖，支持浮点数
	#
	#--------------------------------------------------------------------------
	def def
		n = [[base_def + @def_plus, 1].max, 9999999].min
		n = [[n, 1].max, 9999999].min
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获取力量
	#--------------------------------------------------------------------------
	def final_strength
		return base_strength
	end
	#--------------------------------------------------------------------------
	# ● 获取敏捷
	#--------------------------------------------------------------------------
	def final_celerity
		return base_celerity
	end
	#--------------------------------------------------------------------------
	# ● 获取智力
	#--------------------------------------------------------------------------
	def final_wisdom
		return base_wisdom
	end
	#--------------------------------------------------------------------------
	# ● 获取最终物理伤害量
	#--------------------------------------------------------------------------
	def final_destroy
		n = base_destroy
		n *= final_destroyrate / 100.0
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获取最终物理伤害比率 
	#    
	#    通常，物理伤害比率 % 可以为200%、150%、50% 等等
	#    刚开始的时候是100%，通过装备等等措施可以提高此参数  
	#
	#--------------------------------------------------------------------------
	def final_destroyrate
		# @destroyrate=100,可以通过吃药提升;通过装备提升的直接提升
		return @destroyrate + @xdestroyrate
	end
	#--------------------------------------------------------------------------
	# ● 获取最终魔法伤害量
	#--------------------------------------------------------------------------
	def final_mdestroy
		n = base_mdestroy
		n *= final_mdestroyrate / 100.0
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获取最终魔法伤害比率 
	#    
	#    通常，魔法伤害比率 % 可以为200%、150%、50% 等等
	#    刚开始的时候是1%，通过装备等等措施可以提高此参数  
	#
	#--------------------------------------------------------------------------
	def final_mdestroyrate
		return @mdestroyrate + @xmdestroyrate
	end
	#--------------------------------------------------------------------------
	# ● 获取最终攻击速度因子
	#--------------------------------------------------------------------------
	def final_atkspeed
		n = base_atkspeed
		n *= final_atkrate / 100.0
		n += CONST_BASE_ATKSPEED
		return n 
	end
	#--------------------------------------------------------------------------
	# ● 获取最终攻击速度率
	#
	#    类似于物理伤害比率，可以为50%、150%、300%等等
	#
	#--------------------------------------------------------------------------
	def final_atkrate
		# @atkrate=100,可通过药物提升; @xatkrate=0,可通过装备提升
		return (@atkrate + @xatkrate)
	end
	#--------------------------------------------------------------------------
	# ● 获取最终闪避因子
	#
	#    
	#
	#--------------------------------------------------------------------------
	def final_eva
		n = base_eva
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获取最终闪避增加率
	#
	#   是额外增加率，例如20则增加20%，变为120%
	#   没有被调用，留作以后扩展 -- 例如有能够增加闪避率的药物...
	#--------------------------------------------------------------------------
	def final_evarate
		return (self.evarate + self.xevarate)
	end
	#--------------------------------------------------------------------------
	# ● 获取最终命中因子
	#
	#
	#--------------------------------------------------------------------------
	def final_hit
		n = base_hit
		return n
	end
	#--------------------------------------------------------------------------
	# ● 获取最终命中增加率
	#
	#     是额外增加率，例如20则增加20%，变为120%
	# 	没有被调用，留作以后扩展 -- 例如有能够增加命中率的药物...
	#
	#--------------------------------------------------------------------------
	def final_hitrate
		return (self.hitrate + self.xhitrate)
	end  
	#--------------------------------------------------------------------------
	# ● 获取最终暴击因子（暴击技巧）
	#
	#    注：这个因子要和GAME_CONF::CONST_MAX_BOM比较，得出暴击率
	#        如果这个值大于 ONST_MAX_BOM，在比较后会自动修正
	#
	#--------------------------------------------------------------------------
	def final_bom
		bom_val = base_bom
		# 0~400 * 1
		# 401~800 * 0.8
		# 801~1200 * 0.6
		# 1201~1600 * 0.4
		# 1601~2000 * 0.2
		# > 2000 * 0.1
		rate_list = [0, 1.0, 0.8, 0.6, 0.4, 0.2]
		bom_list = [0, 400, 800, 1200, 1600, 2000]
		n = 0
		for index in 1...bom_list.size
			if bom_val > bom_list[index]
				n += (bom_list[index] - bom_list[index-1]) * rate_list[index]
			else
				n += (bom_val - bom_list[index-1]) * rate_list[index]
				break
			end
		end
		if bom_val > 2000
			n += (bom_val - 2000) * 0.1
		end
		return n 
	end
	#--------------------------------------------------------------------------
	# ● 获取最终暴击因子增加率
	#--------------------------------------------------------------------------
	def final_bomrate
		return (self.bomrate + self.xbomrate)
	end
	#--------------------------------------------------------------------------
	# ● 获取最终暴击扩张倍数
	#
	#    获得之后要加百分号，例如1000是 1000% 即10倍
	#
	#    分段，2.0倍以下则是实打实的
	#          2.0-2.5 则是*0.8
	#          2.5-3.0 则是*0.6
	#          3.0-3.5 则是*0.4
	#          3.5-4.0 则是*0.2
	#          4.0-无穷 则是*0.1
	#          最高10.0
	#--------------------------------------------------------------------------
	def final_bomatk
		n = base_bomatk
		extend_list = [1.0, 0.8, 0.6, 0.4, 0.2]
		scale_list = [0, 200, 250, 300, 350, 400]
		tmp = scale_list[0]
		res = 0
		for index in 0...extend_list.size
			tmp = scale_list[index+1]
			if tmp <= n
				res += extend_list[index] * (scale_list[index+1]-scale_list[index])
			else # n > tmp (tmp上一次 < n < tmp这一次)
				res += extend_list[index] * (n - scale_list[index])
				break
			end
		end
		# 如果n 很大 
		if n > 400
			res += (n - 400) * 0.1
		end    
		res = [res, 1000].min
		return res
	end
	#--------------------------------------------------------------------------
	# ● 最终每秒生命恢复量
	#
	# 	 为了提高速度，用一个专门的变量来存储hpcover.
	# 	 这在可扩展性上产生了问题 -- 只要修改了maxhp, hpcover, 等等
	# 	 就要调用 recover_change从新计算real_hpcover.
	#
	#--------------------------------------------------------------------------
	def final_hpcover
		return base_hpcover
	end
	#--------------------------------------------------------------------------
	# ● 获取最终魔法恢复量
	#
	#      会根据状态动态的修改real_hpcover这个变量
	#      修改real_hpcover时用到 base_hpcover
	#
	#--------------------------------------------------------------------------
	def final_mpcover
		return base_mpcover
	end
	#--------------------------------------------------------------------------
	# ● 当恢复信息变更的时候
	#    
	#     升级、更换装备、状态改变，等等都需要调用此函数。
	#
	# 	 -- 已经废弃 --
	#
	#--------------------------------------------------------------------------  
	def recover_change
    
		# 先获得结算了装备之后的恢复率
		@real_hpcover          = self.base_hpcover
		@real_mpcover          = self.base_mpcover
    
		# 再获得结算了状态之后的恢复率
		# 如果没有状态附加，那么下面不会改变恢复率
		# 状态附加恢复率<0也是可以的，例如中毒
		recover_change_by_state
    
	end
	#--------------------------------------------------------------------------
	# ● 因为状态改变而改变恢复值
	#
	#   	-- 已经废弃 --
	#--------------------------------------------------------------------------
	def recover_change_by_state
		# 记录恢复率的修正值
		hpr = 0
		mpr = 0
		# 遍历状态
		# for state in states do
			# next if state == nil
			# hpr += state.read_note('add_hpcover') if state.read_note('add_hpcover') != nil
			# hpr += state.read_note('add_hprate')*maxhp/100.0 if state.read_note('add_hprate') != nil
			# mpr += state.read_note('add_mpcover') if state.read_note('add_mpcover') != nil
			# mpr += state.read_note('add_mprate')*maxmp/100.0 if state.read_note('add_mprate') != nil
		# end
		# hpr 可以 <0 例如中毒
		@real_hpcover += hpr
		@real_mpcover += mpr
	end 
	#========================================================================
	#  下面是各个参数在实战中最终的应用。
	#
	#  各个参数进行计算后，得出一次攻击的结果。
	#=========================================================================
	#--------------------------------------------------------------------------
	# ● 控制战斗流程  (一次攻击的入口)
	#    
	#    preattack  
	#    doattack 
	#    predamage
	#    dodamage
	#    postdamage
	# 
	#    flag   :身份标识，0英雄或者怪物，1怪物分身1，2怪物分身2，3怪物分身3
	#
	#--------------------------------------------------------------------------
	def excuteBattle(target, flag = 0)   
		# 判断死亡 首先判断自己是否死亡
		if self.hp <= 0
			self.doDead(flag)
			return 
		end
		# 自己没死 再判断对方是否死亡
		if target.hp <= 0
			target.doDead(flag)
			return 
		end
		
		args = {}
		args["brate"] = 0
		args["pre_dmg"] = 0
		args["damage"] = 0
		args["source"] = self
		args["target"] = target
		args["hitflag"] = @hitflag
		args["bomflag"] = @bomflag
		
		$NOW_TIME = $TIME_PRE_PRE_ATTACK
		## ---- 回调所有技能
		update_skill_callback(self, args)
		update_skill_callback(target, args)
		@hitflag = args["hitflag"]
		@bomflag = args["bomflag"]
		
		$NOW_TIME = $TIME_PRE_ATTACK
		## ---- 回调所有技能
		update_skill_callback(self, args)
		update_skill_callback(target, args)
		@hitflag = args["hitflag"]
		@bomflag = args["bomflag"]
		
		# 计算是否命中、是否暴击、暴击倍率
		brate = preattack(target)
		args["brate"] = brate
		args["hitflag"] = @hitflag
		args["bomflag"] = @bomflag
		
		$NOW_TIME = $TIME_POST_PRE_ATTACK
		## ---- 回调所有技能
		update_skill_callback(self, args)
		update_skill_callback(target, args)
		@hitflag = args["hitflag"]
		@bomflag = args["bomflag"]
		brate = args["brate"]
		
		$NOW_TIME = $TIME_PRE_DO_ATTACK
		## ---- 回调所有技能
		update_skill_callback(self, args)
		update_skill_callback(target, args)
		@hitflag = args["hitflag"]
		@bomflag = args["bomflag"]
		brate = args["brate"]
		
		# 获得攻击伤害 -- 物理伤害+攻击/4
		pre_dmg =  doattack(target)
		args["pre_dmg"] = pre_dmg
		@hitflag = args["hitflag"]
		@bomflag = args["bomflag"]
		brate = args["brate"]
		
		$NOW_TIME = $TIME_POST_DO_ATTACK
		## ---- 回调所有技能
		update_skill_callback(self, args)
		update_skill_callback(target, args)
		@hitflag = args["hitflag"]
		@bomflag = args["bomflag"]
		brate = args["brate"]
		pre_dmg = args["pre_dmg"]
		
		$NOW_TIME = $TIME_PRE_PRE_DAMGE
		## ---- 回调所有技能
		update_skill_callback(self, args)
		update_skill_callback(target, args)
		@hitflag = args["hitflag"]
		@bomflag = args["bomflag"]
		brate = args["brate"]
		pre_dmg = args["pre_dmg"]
		
		# 调整伤害 -- 运用攻防、将暴击效果添加到伤害上
		dmg = predamage(brate, pre_dmg, target)
		args["damage"] = dmg
		@hitflag = args["hitflag"]
		@bomflag = args["bomflag"]
		brate = args["brate"]
		pre_dmg = args["pre_dmg"]
		
		$NOW_TIME = $TIME_POST_PRE_DAMAGE
		## ---- 回调所有技能
		update_skill_callback(self, args)
		update_skill_callback(target, args)
		@hitflag = args["hitflag"]
		@bomflag = args["bomflag"]
		brate = args["brate"]
		pre_dmg = args["pre_dmg"]
		dmg = args["damage"]
		
		$NOW_TIME = $TIME_PRE_DO_DAMAGE
		## ---- 回调所有技能
		update_skill_callback(self, args)
		update_skill_callback(target, args)
		@hitflag = args["hitflag"]
		@bomflag = args["bomflag"]
		brate = args["brate"]
		pre_dmg = args["pre_dmg"]
		dmg = args["damage"]
		
		# 执行伤害（包括反弹——反弹的话需要修改上面两个变量）
		final_dmg = dodamage(target, dmg, brate, flag)
		# 如果是怪物受伤
		if !target.hero?
			$game_variables[35] = final_dmg
		# 否则是英雄受伤
		else
			$game_variables[34] = final_dmg
		end
		args["final_dmg"] = final_dmg
		@hitflag = args["hitflag"]
		@bomflag = args["bomflag"]
		brate = args["brate"]
		pre_dmg = args["pre_dmg"]
		dmg = args["damage"]
    
		$NOW_TIME = $TIME_POST_DO_DAMAGE
		## ---- 回调所有技能
		update_skill_callback(self, args)
		update_skill_callback(target, args)
		@hitflag = args["hitflag"]
		@bomflag = args["bomflag"]
		brate = args["brate"]
		pre_dmg = args["pre_dmg"]
		dmg = args["damage"]
		final_dmg = args["final_dmg"]
	
		$NOW_TIME = $TIME_PRE_POST_DAMAGE
		## ---- 回调所有技能
		update_skill_callback(self, args)
		update_skill_callback(target, args)
		@hitflag = args["hitflag"]
		@bomflag = args["bomflag"]
		brate = args["brate"]
		pre_dmg = args["pre_dmg"]
		dmg = args["damage"]
		final_dmg = args["final_dmg"]
	
		# 修改命中状况
		if @hitflag == false and self.hero?
			# 如果是hero并且丢失，修改hero命中开关
			$game_switches[105] = true
		elsif @hitflag == false and  !self.hero?
			# 如果不是英雄并且丢失，修改怪物命中开关
			$game_switches[106] = true
		end
		# 记录暴击状况
		if @bomflag == true and self.hero?
			# 英雄暴击
			$game_switches[109] = true
		elsif @bomflag == true and !self.hero?
			# 怪物暴击
			$game_switches[110] = true
		end
		# 伤害之后的处理——判断胜负
		postdamage(target, flag)
		@hitflag = args["hitflag"]
		@bomflag = args["bomflag"]
		brate = args["brate"]
		pre_dmg = args["pre_dmg"]
		dmg = args["damage"]
		final_dmg = args["final_dmg"]
		
		$NOW_TIME = $TIME_POST_POST_DAMAGE
		## ---- 回调所有技能
		update_skill_callback(self, args)
		update_skill_callback(target, args)
		@hitflag = args["hitflag"]
		@bomflag = args["bomflag"]
		brate = args["brate"]
		pre_dmg = args["pre_dmg"]
		dmg = args["damage"]
		final_dmg = args["final_dmg"]
		
	end
	#--------------------------------------------------------------------------
	# ● 控制战斗流程  (一次反击的入口)
	#    
	#    preattack  
	#    doattack 
	#    predamage
	#    dodamage
	#    postdamage
	# 
	#    flag   :身份标识，0英雄或者怪物，1怪物分身1，2怪物分身2，3怪物分身3
	#
	#--------------------------------------------------------------------------
	def strikeBack(target, flag = 0)   
		# 判断死亡 首先判断自己是否死亡
		if self.hp <= 0
			self.doDead(flag)
			return 
		end
		# 自己没死 再判断对方是否死亡
		if target.hp <= 0
			target.doDead(flag)
			return 
		end
    
		# 计算是否命中、是否暴击、暴击倍率
		brate = preattack(target)
		
		# 获得攻击伤害 -- 物理伤害+攻击/4
		pre_dmg =  doattack(target)
		
		# 调整伤害 -- 运用攻防、将暴击效果添加到伤害上
		dmg = predamage(brate, pre_dmg, target)
		

		# 执行伤害（包括反弹——反弹的话需要修改上面两个变量）
		final_dmg = dodamage(target, dmg, brate, flag)
		# 如果是怪物受伤
		if !target.hero?
			$game_variables[157] = final_dmg
		# 否则是英雄受伤
		else
			$game_variables[156] = final_dmg
		end
		
		
		# 修改命中状况
		if @hitflag == false and self.hero?
			# 如果是hero并且丢失，修改hero命中开关
			$game_switches[119] = true
		elsif @hitflag == false and  !self.hero?
			# 如果不是英雄并且丢失，修改怪物命中开关
			$game_switches[120] = true
		end
		# 记录暴击状况
		if @bomflag == true and self.hero?
			# 英雄暴击
			$game_switches[121] = true
		elsif @bomflag == true and !self.hero?
			# 怪物暴击
			$game_switches[122] = true
		end
		# 伤害之后的处理——判断胜负
		postdamage(target, flag)
		
	end
	#------------------------------------------------------------------------
	# ● 下面开始准备战斗函数
	#
	#--------------------------------------------------------------------------
	# ● 准备攻击
	#
	#    只要是对目标角色进行攻击前的准备包括：
	#      命中率的计算
	#      闪避率的计算
	#      暴击是否成功的计算
	#
	#      函数设置bomflag hitflag 返回暴击威力atkrate（为0则不暴击）
	#
	#--------------------------------------------------------------------------
	def preattack(target)
		# 计算暴击技巧产生的暴击率
		n = self.final_bom + 0.0
		# 默认，CONST_MAX_BOM = 4000，每点暴击技巧增加0.025个百分点
		# 暴击技巧 = 20 则 暴击概率为 20*0.025% = 0.5% 暴击概率
		# 暴击技巧 = 1000 则 暴击概率为 1000*0.025% = 25% 暴击概率
		n = n / CONST_MAX_BOM
    
		# 命中影响暴击率
		# 正常情况下命中技巧应该是闪避技巧的1.5倍。 
		# 自身命中技巧 - 目标闪避技巧的1.5倍 = 0 - 此时不受影响
		# 如果命中 = 2倍闪避，则暴击可能为：
		# (0.5/2.0) * 1.2 = 0.3 = 30% 会有30% 暴击可能
		bom_hit = 1.2*(self.final_hit - target.final_eva*1.5) / self.final_hit
	
		# 修正，正常提供的暴击不能大于36%，
		# 拖后腿也不会小于 -100% 
		# 只要保持自身命中 > 对方闪避1.5倍 则不会出现拖后腿现象。
		# 闪避高可以暴击 - 保护敏捷英雄
		if bom_hit > 0
			bom_hit = [bom_hit, 0.36].min
		else
			bom_hit = [bom_hit, -1.0].max
		end
    
		# 防御影响暴击率
		# 防御高可以防暴击 - 保护敏捷英雄
		bom_def = (self.def-target.def) / self.def
		if bom_def > 0
			bom_def = [bom_def, 0.3].min
		else
			bom_def = [bom_def, -0.8].max
		end
    
		# 力量影响暴击 - 加强力量英雄
		# 只要自身力量 > 对方力量则可以防止拖后腿现象
		# 此因素普通 （<15%）
		bom_str = 1.5*(self.final_strength - target.final_strength) / self.final_strength
		if bom_str > 0
			bom_str = [bom_str, 0.45].min
		else
			bom_str = [bom_str, -0.4].max
		end
    
		# 计算最终百分比数值，不超过80%
		# 最后计算处 0~100 之间的一个数字
		final_bom_percent = (bom_hit + bom_def + bom_str + n) * 100.0
		if final_bom_percent > 0
			final_bom_percent = [final_bom_percent, 80].min
		else
			final_bom_percent = 0
		end
    
		# 扩大100倍进行比较
		# 例如70， 70*100 = 7000，最后和 10000 比较
		# 如果暴击则直接返回暴击伤害倍数，例如200% 则返回2.0
		if final_bom_percent * 100 > rand(10001)
			@bomflag = true
			@hitflag = true
			return self.final_bomatk / 100.0
		else
			@bomflag = false
			@hitflag = false
		end
    
		# ---- 否则不暴击，计算命中率--------
		# 闪避率由三个分量组成
		# 正常情况下，(命中-闪避) / 命中 = 0.5
		# 0.5 * 3.0 = 1.5; 最大不超过150% 拖后腿不小于-50%
		# 一般而言只要命中 > 闪避
		hit_hit_eva = [3.0*(self.final_hit - target.final_eva) / self.final_hit, -0.5].max
		# 加强敏捷英雄
		# 最大拖后腿能够达到-60% (保护敏捷英雄)
		hit_cel_cel = [2.0*(self.final_celerity - target.final_celerity) / self.final_celerity, -0.6].max
		# 防御起很小作用 略微加强敏捷
		hit_def_def = [0.6*(self.def-target.def) / self.def, -0.4].max
		# 命中最低不小于40%(防止敏捷太变态) 最高不超过200% 
		hit_final = [[hit_hit_eva + hit_cel_cel + hit_def_def, 0.4].max, 2].min
		# 最后计算命中概率
		@hitflag = (hit_final * 100 >= rand(101));
		# 返回暴击伤害倍率
		return self.final_bomatk / 100.0
	end
	#--------------------------------------------------------------------------
	# ● 执行攻击
	#
	#    得出产生的伤害这个伤害大概是 物理伤害+部分攻击力
	#
	#--------------------------------------------------------------------------
	def doattack(target)
		# 如果miss直接不会产生任何伤害
		return 0 if @hitflag == false
		# 初步计算伤害，表示攻击行为，后期会进行修正
		dmg = final_destroy + self.atk / 4.0
		return dmg
	end
	#--------------------------------------------------------------------------
	# ● 准备伤害
	#
	#    	计算出最终的伤害
	#    	计算过程需要考虑双方的状态，也就是有技能的因素在
	#    	实现反弹、吸血等等
	#
	#		brate 	:	暴击比例
	# 		dmg 	: 	产生的伤害
	# 		target	:	目标
	#--------------------------------------------------------------------------
	def predamage(brate, dmg, target)
		# 如果没有命中直接返回伤害值为0
		return 0 if false == @hitflag
		# 进行攻击、防御的修正
		rate = self.atk / target.def
		final_dmg = dmg * rate
		final_dmg += (self.atk - target.def) / 4.0
		# 计算等级带来的伤害影响
		# 自身等级与对方等级差带来的伤害修正
		if self.hero?
			diff = @level - (target.level * 2)
		else
			diff = (@level * 2) - target.level
		end
		diff = [[diff, 4].min, -4].max
		effect = GAME_CONF::LEVEL_EFFECT[diff+4]
		final_dmg *= effect
		return final_dmg
	end  
	#--------------------------------------------------------------------------
	# ● 执行伤害
	# 	target		:	目标
	# 	dmg			:	伤害
	# 	brate 		:	暴击倍率
	#--------------------------------------------------------------------------
	def dodamage(target, dmg, brate, flag = 0)
		return 0 if dmg == 0
		# 制造随机伤害
		final_dmg = dmg * (90 + rand(21)) / 100.00
		# 如果暴击
		if @bomflag == true and brate > 0
			final_dmg = final_dmg *  brate 
		end
		# 首先是反弹——这里没有实现
		# 然后是减少伤害——这里没有实现
		# 然后是抵消伤害（格挡）——这里没有实现
		# 然后是吸血(吸血之前应该判定自己是否死亡)——这里没有实现
		# 修改hp
		target.hp -= final_dmg
		return final_dmg
	end
	#--------------------------------------------------------------------------
	# ● 伤害之后
	#    
	#     清除标志
	#     判断死亡
	#
	#      本函数，默认怪物始终不会攻击怪物，英雄始终不会攻击英雄
	#
	#--------------------------------------------------------------------------
	def postdamage(target, flag = 0)
		# 首先判断是否分身攻击
		if flag != 0
			# 如果自己不是英雄，是怪物（分身）
			if !self.hero?
				# 如果自身死亡
				if self.hp <= 0
					doVictory(flag)
				# 如果是英雄死亡
				elsif target.hp <= 0
					doGameOver
				end
			# 如果目标和自己都没有死亡，什么也不做
			# 否则如果自己是英雄
			else
				# 留作以后英雄分身扩展
			end
			# 清除标志。
			@bomflag = false
			@hitflag = false
			# 分身判断完毕，不用执行下面内容
			return 
		end
		# 首先判断死亡
		if self.hp <= 0 or target.hp <= 0
			# 退出战斗状态
			$game_switches[103] = false
			$game_switches[104] = true
			$game_map.refresh
			# 如果自己死亡——多是是反弹死的
			if self.hp <= 0       
				# 如果自己是英雄，并且死亡
				if hero?
					# 对手是怪物,并且没有死亡，那么对手直接恢复
					if target.hp > 0 
						# 英雄死
						self.doGameOver
					# 否则对手也死了
					else
						# 怪物先死
						target.doVictory
						# 英雄再死
						self.doGameOver
					end
				# 如果自己是怪物，并且死亡
				else
					# 如果对手(英雄)也死了
					if target.hp <= 0
						# 怪物先死掉
						self.doVictory
						# 英雄再死
						target.doGameOver
					# 如果对手没有死亡
					else
						# 仅仅怪物死亡
						self.doVictory
					end
				end
			# 否则一定是target.hp <= 0,自己没有死
			else
				target.doDead
			end
		end
		# 清除标志，如果死了再清除标记也没有什么影响
		@bomflag = false
		@hitflag = false
	end
	#--------------------------------------------------------------------------
	# ● 执行死亡
	#
	#    doGameOver 在 Game_Hero中
	#    doVictory  在 Game_Monstor中
	#
	#--------------------------------------------------------------------------
	def doDead(flag = 0)
		# 首先判断是否玩家
		# 如果是玩家，则结束
		if hero?
			doGameOver
			return 
		# 否则是怪物
		else
			doVictory(flag)
			return 
		end
	end
	#--------------------------------------------------------------------------
	# ● 给target施加一个伤害damage
	#--------------------------------------------------------------------------
	def pureDamage(target, damage)
		dodamage(target, damage)
	end
	#--------------------------------------------------------------------------
	# ● 添加动画
	#	animation["value"] = [time_to_start, id_of_animation_in_database]
	#		e.g., [2, 125]  means 
	#           Animation with "id=125", 两帧之后开始
	#		
	#--------------------------------------------------------------------------
	def add_animations(animations)
		for animation in animations
			self.animation_id[animation["seq"]] = animation["value"]
		end
	end
	#--------------------------------------------------------------------------
	# ● 回调技能函数
	#		回调battler的所有技能
	#--------------------------------------------------------------------------
	def update_skill_callback(battler, args)
		callback_skill = battler.my_skills
		for priority in callback_skill.keys.sort
			for key in callback_skill[priority].keys
				callback_skill[priority][key].trigger_func(args)
			end
		end
	end
end