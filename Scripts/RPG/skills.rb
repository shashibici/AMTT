module RPG	
	#==============================================================================
	# ■ 示例1  反弹
	#------------------------------------------------------------------------------
	# 	有20%几率将对方造成的伤害的 技能等级 X 5% 以纯粹伤害反弹
	#==============================================================================
	class Fantan_Skill < Skill_Base
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
			# 触发技
			@type = 2
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	name		:	技能名字
		#	level		:	技能等级
		# 	battler		:	技能拥有者
		# 	priority	:	优先级 - 越低越优先
		#--------------------------------------------------------------------------
		def setup(name, level, battler, priority = 0)
			super(name, level, battler, priority)
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现can_trigger?
		#--------------------------------------------------------------------------
		def can_trigger?(args)
			if self.battler.hero? == args["target"].hero?
				if $TIME_POST_PRE_DAMAGE == $NOW_TIME
					return true
				end
			end
			return false
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现effect_func触发效果
		#--------------------------------------------------------------------------
		def effect_func(args)
			if (args["target"].hp > 0) and (args["source"].hp > 0)
				if rand(100) < 20
					final_damage = args["final_damage"]
					bounce = @level *0.05 * final_damage
					args["target"].pureDamage(args["source"], bounce)
					animation_func(args)
				end
				#例如，需要给对方增加一个变速效果,持续2秒，结算顺序为1
				state = Single_Speed_Change_State.new
				# 状态施加对象为source, 结算顺序为1， 持续2秒
				state.setup(args["source"], "加速", 1, 2)
				# 速度+100%
				state.speed_rate = 100
				args["source"].add_state(state)
			end
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现effect_func触发效果
		#--------------------------------------------------------------------------
		def animation_func(args)
			super(args)
			animations = []
			animation = {}
			if args["target"].hero?
				animation["seq"] = $Battle_animation_counter_player
				animation["value"] = [1, 124]
				$Battle_animation_counter_player += 1
				animations.push(animation)
			else
				animation["seq"] = $Battle_animation_counter_enemy
				animation["value"] = [1, 124]
				$Battle_animation_counter_enemy += 1
				animations.push(animation)
			end
			args["target"].add_animations(animations)
			
		end
		#--------------------------------------------------------------------------
		# ● 技能描述
		# 		返回一个字符串数组，推荐每行<15字
		#--------------------------------------------------------------------------
		def description
			return ["反弹：",
					"【触发技】",
					"这是一个样板，",]
		end
		#--------------------------------------------------------------------------
		# ● 价格函数
		# 	此函数返回该技能的价格
		#
		#   scalar:   	金钱扩张倍数
		#
		#--------------------------------------------------------------------------
		def price(scalar = 1)
			return Fround(1280.0*scalar,1)
		end
	end
	#==============================================================================
	# ■ 反击 -- 测试通过
	#------------------------------------------------------------------------------
	# 	触发技，角色每次受到攻击有30%/60%/100%几率进行一次反击，忽视敌我双方技能
	#==============================================================================
	class FanJi_Skill < Skill_Base
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
			# 触发技
			@type = 2
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	name		:	技能名字
		#	level		:	技能等级
		# 	battler		:	技能拥有者
		# 	priority	:	优先级 - 越低越优先
		#--------------------------------------------------------------------------
		def setup(name, level, battler, priority = 0)
			super(name, level, battler, priority)
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现can_trigger?
		#--------------------------------------------------------------------------
		def can_trigger?(args)
			if self.battler.hero? == args["target"].hero?
				if $TIME_POST_DO_DAMAGE == $NOW_TIME
					return (args["hitflag"] == true or args["bomflag"] == true)
				end
			end
			return false
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现effect_func触发效果
		#--------------------------------------------------------------------------
		def effect_func(args)
			if (args["target"].hp > 0) and (args["source"].hp > 0)
				threshold = 30
				case @level
				when 2
					threshold = 60
				when 3
					threshold = 101
				end
				if rand(100) < threshold
					if args["target"].hero?
						Battle.Battle_strike_back_player
					else
						Battle.Battle_strike_back_enemy
					end
				end
			end
		end
		#--------------------------------------------------------------------------
		# ● 技能描述
		# 		返回一个字符串数组
		#--------------------------------------------------------------------------
		def description
			return ["反击：",
					"【触发技】",
					"角色每次受到攻击，根据技能等级，",
					"有30%/60%/100%几率进行一次反击。",
					"忽视敌我双方技能",]
		end
		#--------------------------------------------------------------------------
		# ● 价格函数
		# 	此函数返回该技能的价格
		#
		#   scalar:   	金钱扩张倍数
		#
		#--------------------------------------------------------------------------
		def price(scalar = 1)
			case @level
			when 1
				return Fround(20000.0*scalar,1)
			when 2
				return Fround(200000.0*scalar,1)
			when 3
				return Fround(2000000.0*scalar,1)
			end
		end
	end
	#==============================================================================
	# ■ 冰冻 - 测试通过
	#------------------------------------------------------------------------------
	# 	触发技，角色每次攻击命中会造成冷冻效果；
	# 			对方攻速减少40%/60%/80%，持续5/7/10秒，冰冻效果不可叠加
	#==============================================================================
	class BinDong_Skill < Skill_Base
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
			# 触发技
			@type = 2
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	name		:	技能名字
		#	level		:	技能等级
		# 	battler		:	技能拥有者
		# 	priority	:	优先级 - 越低越优先
		#--------------------------------------------------------------------------
		def setup(name, level, battler, priority = 0)
			super(name, level, battler, priority)
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现can_trigger?
		#--------------------------------------------------------------------------
		def can_trigger?(args)
			if self.battler.hero? != args["target"].hero?
				if $TIME_POST_DO_ATTACK == $NOW_TIME
					return true
				end
			end
			return false
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现effect_func触发效果
		#--------------------------------------------------------------------------
		def effect_func(args)
			if (args["source"].hp > 0)
				state = Single_Speed_Change_State.new
				state.level = @level
				case @level
				when 1
					state.speed_rate = -30
					state.setup(args["target"], "冰冻", 65536, 5)
				when 2
					state.speed_rate = -50
					state.setup(args["target"], "冰冻", 65536, 7)
				when 3
					state.speed_rate = -70
					state.setup(args["target"], "冰冻", 65536, 10)
				end
				args["target"].add_state(state, true, true)
				animation_func(args)
			end
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现effect_func触发效果
		#--------------------------------------------------------------------------
		def animation_func(args)
			super(args)
			animations = []
			animation = {}
			if args["target"].hero?
				animation["seq"] = $Battle_animation_counter_player
				animation["value"] = [1, 125]
				$Battle_animation_counter_player += 1
				animations.push(animation)
			else
				animation["seq"] = $Battle_animation_counter_enemy
				animation["value"] = [1, 125]
				$Battle_animation_counter_enemy += 1
				animations.push(animation)
			end
			args["target"].add_animations(animations)
		end
		#--------------------------------------------------------------------------
		# ● 技能描述
		# 		返回一个字符串数组
		#--------------------------------------------------------------------------
		def description
			return ["冰冻：",
					"【触发技】",
					"角色每次攻击命中会给对方添加冷",
					"冻状态，根据技能等级使攻速减少",
					"30%/50%/70%，持续5/7/10秒，",
					"冰冻效果不可叠加",]
		end
		#--------------------------------------------------------------------------
		# ● 价格函数
		# 	此函数返回该技能的价格
		#
		#   scalar:   	金钱扩张倍数
		#
		#--------------------------------------------------------------------------
		def price(scalar = 1)
			case @level
			when 1
				return Fround(20000.0*scalar,1)
			when 2
				return Fround(200000.0*scalar,1)
			when 3
				return Fround(2000000.0*scalar,1)
			end
		end
	end
	#==============================================================================
	# ■ 坚守  -- 通过测试
	#------------------------------------------------------------------------------
	# 	锁定技，提升防御力，防御提升百分比为角色失去生命百分比的100%/200%/400%
	#==============================================================================
	class JianShou_Skill < Skill_Base
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
			# 锁定技
			@type = 1
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	name		:	技能名字
		#	level		:	技能等级
		# 	battler		:	技能拥有者
		# 	priority	:	优先级 - 越低越优先
		#--------------------------------------------------------------------------
		def setup(name, level, battler, priority = 0)
			super(name, level, battler, priority)
		end
		#--------------------------------------------------------------------------
		# ● 锁定技函数
		# 		在技能被添加的时候或者战斗开始的时候被调用，一般是添加状态
		#--------------------------------------------------------------------------
		def compulsory_func
			state = JianShou_State.new
			state.level = @level
			case @level
			when 1
				state.ratio = 100
				state.setup(@battler, "坚守", 32768, 72000)
			when 2
				state.ratio = 200
				state.setup(@battler, "坚守", 32768, 72000)
			when 3
				state.ratio = 400
				state.setup(@battler, "坚守", 32768, 72000)
			end
			@battler.add_state(state, true, true)
		end
		#--------------------------------------------------------------------------
		# ● 技能描述
		# 		返回一个字符串数组
		#--------------------------------------------------------------------------
		def description
			return ["坚守：",
					"【锁定技】",
					"根据技能等级防御提升百分比为",
					"失去生命百分比的100%/200%/400%",]
		end
		#--------------------------------------------------------------------------
		# ● 价格函数
		# 	此函数返回该技能的价格
		#
		#   scalar:   	金钱扩张倍数
		#
		#--------------------------------------------------------------------------
		def price(scalar = 1)
			case @level
			when 1
				return Fround(40000.0*scalar,1)
			when 2
				return Fround(400000.0*scalar,1)
			when 3
				return Fround(4000000.0*scalar,1)
			end
		end
	end
	#==============================================================================
	# ■ 疾风  -- 测试通过
	#------------------------------------------------------------------------------
	# 	触发技， 角色每次攻击被闪避时攻速提升20%/40%/80%，命中提升100%/200%/300%，持续10/15/30秒，不可叠加
	#==============================================================================
	class JiFeng_Skill < Skill_Base
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
			# 触发技
			@type = 2
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	name		:	技能名字
		#	level		:	技能等级
		# 	battler		:	技能拥有者
		# 	priority	:	优先级 - 越低越优先
		#--------------------------------------------------------------------------
		def setup(name, level, battler, priority = 0)
			super(name, level, battler, priority)
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现can_trigger?
		#--------------------------------------------------------------------------
		def can_trigger?(args)
			if self.battler.hero? == args["source"].hero?
				if $TIME_POST_PRE_DAMAGE == $NOW_TIME 
					return true
				end
			end
			return false
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现effect_func触发效果
		#--------------------------------------------------------------------------
		def effect_func(args)
			return if true == args["hitflag"]
			if (args["source"].hp > 0)
				state = Jifeng_State.new
				state.level = @level
				state.setup(args["source"], "疾风", 32768)
				args["source"].add_state(state, true, true)
				animation_func(args)
			end
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现effect_func触发效果
		#--------------------------------------------------------------------------
		def animation_func(args)
			super(args)
			animations = []
			animation = {}
			if args["source"].hero?
				animation["seq"] = $Battle_animation_counter_player
				animation["value"] = [1, 126]
				$Battle_animation_counter_player += 1
				animations.push(animation)
			else
				animation["seq"] = $Battle_animation_counter_enemy
				animation["value"] = [1, 126]
				$Battle_animation_counter_enemy += 1
				animations.push(animation)
			end
			args["source"].add_animations(animations)
		end
		#--------------------------------------------------------------------------
		# ● 技能描述
		#--------------------------------------------------------------------------
		def description
			return ["疾风：",
					"【触发技】",
					"角色每次攻击被闪避时，根据技能",
					"等级，攻速提升20%/40%/80%，",
					"命中提升100%/200%/300%，",
					"持续5/10/20秒，不可叠加。",]
		end
		#--------------------------------------------------------------------------
		# ● 价格函数
		#--------------------------------------------------------------------------
		def price(scalar = 1)
			case @level
			when 1
				return Fround(30000.0*scalar,1)
			when 2
				return Fround(300000.0*scalar,1)
			when 3
				return Fround(3000000.0*scalar,1)
			end
		end
	end
	#==============================================================================
	# ■ 复仇  -- 测试通过
	#------------------------------------------------------------------------------
	# 	触发技，角色受到暴击之后立即发动下一次攻击
	#==============================================================================
	class Fuchou_Skill < Skill_Base
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
			# 触发技
			@type = 2
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	name		:	技能名字
		#	level		:	技能等级
		# 	battler		:	技能拥有者
		# 	priority	:	优先级 - 越低越优先
		#--------------------------------------------------------------------------
		def setup(name, level, battler, priority = 0)
			super(name, level, battler, priority)
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现can_trigger?
		#--------------------------------------------------------------------------
		def can_trigger?(args)
			if self.battler.hero? == args["target"].hero?
				if $TIME_PRE_POST_DAMAGE == $NOW_TIME 
					return args["source"].bomflag
				end
			end
			return false
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现effect_func触发效果
		#--------------------------------------------------------------------------
		def effect_func(args)
			if (args["target"].hp > 0)
				if args["target"].hero?
					$game_variables[32] -= $max_speed * (Graphics.frame_rate + 1)
				else
					$game_variables[33] -= $max_speed * (Graphics.frame_rate + 1)
				end
				animation_func(args)
			end
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现effect_func触发效果
		#--------------------------------------------------------------------------
		def animation_func(args)
			super(args)
			animations = []
			animation = {}
			if args["target"].hero?
				animation["seq"] = $Battle_animation_counter_player
				animation["value"] = [1, 128]
				$Battle_animation_counter_player += 1
				animations.push(animation)
			else
				animation["seq"] = $Battle_animation_counter_enemy
				animation["value"] = [1, 129]
				$Battle_animation_counter_enemy += 1
				animations.push(animation)
			end
			args["target"].add_animations(animations)
		end
		#--------------------------------------------------------------------------
		# ● 技能描述
		#--------------------------------------------------------------------------
		def description
			return ["复仇：",
					"【触发技】",
					"角色受到暴击之后，下一刻立即",
					"发动下一次攻击",]
		end
		#--------------------------------------------------------------------------
		# ● 价格函数
		#--------------------------------------------------------------------------
		def price(scalar = 1)
			return Fround(400000.0*scalar,1)
		end
	end
	#==============================================================================
	# ■ 巨化  -- 测试通过
	#------------------------------------------------------------------------------
	# 	锁定技，每次攻击必暴击
	#   一级攻速-10%，
	#   二级攻速-15%，生命恢复+100%
	#   三级攻速-20%，生命恢复+100%，最大生命+100%
	#==============================================================================
	class Juhua_Skill < Skill_Base
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
			# 锁定技
			@type = 1
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	name		:	技能名字
		#	level		:	技能等级
		# 	battler		:	技能拥有者
		# 	priority	:	优先级 - 越低越优先
		#--------------------------------------------------------------------------
		def setup(name, level, battler, priority = 0)
			super(name, level, battler, priority)
		end
		#--------------------------------------------------------------------------
		# ● 锁定技函数
		# 		在战斗开始的时候被调用，一般是添加状态
		#--------------------------------------------------------------------------
		def compulsory_func
			state = Juhua_State.new
			state.level = @level
			case @level
			when 1
				state.setup(@battler, "巨化", 8192, 72000)
			when 2
				state.setup(@battler, "巨化", 8192, 72000)
			when 3
				state.setup(@battler, "巨化", 8192, 72000)
			end
			# 按名字添加，以最高等级覆盖之
			@battler.add_state(state, true, true)
			# 调整血量
			@battler.hp = battler.maxhp
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现can_trigger?
		#--------------------------------------------------------------------------
		def can_trigger?(args)
			if self.battler.hero? == args["source"].hero?
				if $TIME_PRE_DO_DAMAGE == $NOW_TIME
					return true
				end
			end
			return false
		end
		#--------------------------------------------------------------------------
		# ● 需要实现effect_func触发效果
		#--------------------------------------------------------------------------
		def effect_func(args)
			if (args["source"].hp > 0)
				# 如果命中则一定暴击
				args["bomflag"] = args["hitflag"]
			end
		end
		#--------------------------------------------------------------------------
		# ● 技能描述
		#--------------------------------------------------------------------------
		def description
			return ["巨化：",
					"【锁定技】",
					"角色每次攻击如果命中必定暴击；",
					"1级-10%攻速；",
					"2级-15%攻速，+100%生命恢复；",
					"3级-20%攻速，+100%生命恢复，",
					"+100%最大生命",]
		end
		#--------------------------------------------------------------------------
		# ● 价格函数
		#--------------------------------------------------------------------------
		def price(scalar = 1)
			case @level 
			when 1
				return Fround(20000.0*scalar,1)
			when 2
				return Fround(200000.0*scalar,1)
			when 3
				return Fround(2000000.0*scalar,1)
			end
		end
	end
	#==============================================================================
	# ■ 铜头  -- 测试通过
	#------------------------------------------------------------------------------
	# 	锁定技，角色所受暴击伤害等同于普通伤害值
	#
	#==============================================================================
	class Tongtou_Skill < Skill_Base
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
			# 锁定技
			@type = 1
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	name		:	技能名字
		#	level		:	技能等级
		# 	battler		:	技能拥有者
		# 	priority	:	优先级 - 越低越优先
		#--------------------------------------------------------------------------
		def setup(name, level, battler, priority = 0)
			super(name, level, battler, priority)
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现can_trigger?
		#--------------------------------------------------------------------------
		def can_trigger?(args)
			if self.battler.hero? == args["target"].hero?
				if $TIME_PRE_DO_DAMAGE == $NOW_TIME
					return true
				end
			end
			return false
		end
		#--------------------------------------------------------------------------
		# ● 需要实现effect_func触发效果
		#--------------------------------------------------------------------------
		def effect_func(args)
			if (args["target"].hp > 0)
				# 如果暴击则伤害为0
				if true == args["bomflag"] and args["brate"] > 0
					args["brate"] = 1.0
				end
			end
		end
		#--------------------------------------------------------------------------
		# ● 技能描述
		#--------------------------------------------------------------------------
		def description
			return ["铜头：",
					"【锁定技】",
					"角色所受暴击伤害等同于普通伤",
					"害值。",]
		end
		#--------------------------------------------------------------------------
		# ● 价格函数
		#--------------------------------------------------------------------------
		def price(scalar = 1)
			return Fround(200000.0*scalar,1)
		end
	end
	
	#==============================================================================
	# ■ 必中  -- 测试通过
	#------------------------------------------------------------------------------
	# 	锁定技，每次攻击必定命中
	#
	#==============================================================================
	class BiZhong_Skill < Skill_Base
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
			# 锁定技
			@type = 1
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	name		:	技能名字
		#	level		:	技能等级
		# 	battler		:	技能拥有者
		# 	priority	:	优先级 - 越低越优先
		#--------------------------------------------------------------------------
		def setup(name, level, battler, priority = 0)
			super(name, level, battler, priority)
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现can_trigger?
		#--------------------------------------------------------------------------
		def can_trigger?(args)
			if self.battler.hero? == args["source"].hero?
				if $TIME_POST_PRE_ATTACK == $NOW_TIME
					return true
				end
			end
			return false
		end
		#--------------------------------------------------------------------------
		# ● 需要实现effect_func触发效果
		#--------------------------------------------------------------------------
		def effect_func(args)
			if (args["source"].hp > 0)
				# 必中
				args["hitflag"] = true
			end
		end
		#--------------------------------------------------------------------------
		# ● 技能描述
		#--------------------------------------------------------------------------
		def description
			return ["必中：",
					"【锁定技】",
					"每次攻击必定命中",]
		end
		#--------------------------------------------------------------------------
		# ● 价格函数
		#--------------------------------------------------------------------------
		def price(scalar = 1)
			return Fround(300000.0*scalar,1)
		end
	end
	#==============================================================================
	# ■ 降龙  -- 测试通过
	#------------------------------------------------------------------------------
	# 	特殊技，敌我双方所有触发技无效
	#
	#==============================================================================
	class XiangLong_Skill < Skill_Base
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
			# 特殊技
			@type = 0
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	name		:	技能名字
		#	level		:	技能等级
		# 	battler		:	技能拥有者
		# 	priority	:	优先级 - 越低越优先
		#--------------------------------------------------------------------------
		def setup(name, level, battler, priority = 0)
			super(name, level, battler, priority)
		end
		#--------------------------------------------------------------------------
		# ● 特殊技函数
		# 		战斗开始时优先于锁定技被调用
		#       任何需要影响“锁定技”的操纵必须在这个函数里定义。
		#       如果没有则不需要定义。
		#--------------------------------------------------------------------------
		def special_func
			skills = $game_party.active.my_skills
			for priority in skills.keys.sort
				for key in skills[priority].keys
					# 触发技无效
					if skills[priority][key].type == 2
						p locked
						skills[priority][key].locked = true
					end
				end
			end
			skills = $game_monstor_battle.my_skills
			for priority in skills.keys.sort
				for key in skills[priority].keys
					# 触发技无效
					if skills[priority][key].type == 2
						skills[priority][key].locked = true
					end
				end
			end
		end
		#--------------------------------------------------------------------------
		# ● 技能描述
		#--------------------------------------------------------------------------
		def description
			return ["降龙：",
					"【特殊技】",
					"敌我双方所有触发技无效",]
		end
		#--------------------------------------------------------------------------
		# ● 价格函数
		#--------------------------------------------------------------------------
		def price(scalar = 1)
			return Fround(2000000.0*scalar,1)
		end
	end
	#==============================================================================
	# ■ 伏虎  -- 测试通过
	#------------------------------------------------------------------------------
	# 	特殊技，敌我双方所有锁定技无效
	#
	#==============================================================================
	class Fuhu_Skill < Skill_Base
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
			# 特殊技
			@type = 0
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	name		:	技能名字
		#	level		:	技能等级
		# 	battler		:	技能拥有者
		# 	priority	:	优先级 - 越低越优先
		#--------------------------------------------------------------------------
		def setup(name, level, battler, priority = 0)
			super(name, level, battler, priority)
		end
		#--------------------------------------------------------------------------
		# ● 特殊技函数
		# 		战斗开始时优先于锁定技被调用
		#       任何需要影响“锁定技”的操纵必须在这个函数里定义。
		#       如果没有则不需要定义。
		#--------------------------------------------------------------------------
		def special_func
			skills = $game_party.active.my_skills
			for priority in skills.keys.sort
				for key in skills[priority].keys
					# 锁定技无效
					if skills[priority][key].type == 1
						skills[priority][key].locked = true
					end
				end
			end
			skills = $game_monstor_battle.my_skills
			for priority in skills.keys.sort
				for key in skills[priority].keys
					# 锁定技无效
					if skills[priority][key].type == 1
						skills[priority][key].locked = true
					end
				end
			end
		end
		#--------------------------------------------------------------------------
		# ● 技能描述
		#--------------------------------------------------------------------------
		def description
			return ["伏虎：",
					"【特殊技】",
					"敌我双方所有锁定技无效",]
		end
		#--------------------------------------------------------------------------
		# ● 价格函数
		#--------------------------------------------------------------------------
		def price(scalar = 1)
			return Fround(2000000.0*scalar,1)
		end
	end
	#==============================================================================
	# ■ 顽强  -- 测试通过
	#------------------------------------------------------------------------------
	# 	锁定技，生命恢复速度提升百分比为失去生命百分比的150%/300%/600%
	#
	#==============================================================================
	class Wanqiang_Skill < Skill_Base
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
			# 锁定技
			@type = 1
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	name		:	技能名字
		#	level		:	技能等级
		# 	battler		:	技能拥有者
		# 	priority	:	优先级 - 越低越优先
		#--------------------------------------------------------------------------
		def setup(name, level, battler, priority = 0)
			super(name, level, battler, priority)
		end
		#--------------------------------------------------------------------------
		# ● 锁定技函数
		# 		在技能被添加的时候或者战斗开始的时候被调用，一般是添加状态
		#--------------------------------------------------------------------------
		def compulsory_func
			state = Wanqiang_State.new
			state.level = @level
			state.setup(@battler, "顽强", 32768, 72000)
			@battler.add_state(state, true, true)
		end
		#--------------------------------------------------------------------------
		# ● 技能描述
		# 		返回一个字符串数组
		#--------------------------------------------------------------------------
		def description
			return ["顽强：",
					"【锁定技】",
					"据技能等级生命恢复提升百分比为",
					"失去生命百分比的150%/300%/600%",]
		end
		#--------------------------------------------------------------------------
		# ● 价格函数
		# 	此函数返回该技能的价格
		#
		#   scalar:   	金钱扩张倍数
		#
		#--------------------------------------------------------------------------
		def price(scalar = 1)
			case @level
			when 1
				return Fround(30000.0*scalar,1)
			when 2
				return Fround(300000.0*scalar,1)
			when 3
				return Fround(3000000.0*scalar,1)
			end
		end
	end
	#==============================================================================
	# ■ 嗜血  -- 
	#------------------------------------------------------------------------------
	# 	锁定技，攻击速度提升百分比为失去生命的100%，物理伤害提升百分比为失去生命百分比的50%
	#
	#==============================================================================
	class ShiXue_Skill < Skill_Base
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
			# 锁定技
			@type = 1
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	name		:	技能名字
		#	level		:	技能等级
		# 	battler		:	技能拥有者
		# 	priority	:	优先级 - 越低越优先
		#--------------------------------------------------------------------------
		def setup(name, level, battler, priority = 0)
			super(name, level, battler, priority)
		end
		#--------------------------------------------------------------------------
		# ● 锁定技函数
		# 		在技能被添加的时候或者战斗开始的时候被调用，一般是添加状态
		#--------------------------------------------------------------------------
		def compulsory_func
			state = Shixue_State.new
			state.level = @level
			state.setup(@battler, "嗜血", 32768, 72000)
			@battler.add_state(state, true, true)
		end
		#--------------------------------------------------------------------------
		# ● 技能描述
		# 		返回一个字符串数组
		#--------------------------------------------------------------------------
		def description
			return ["嗜血：",
					"【锁定技】",
					"攻击速度提升百分比为",
					"失去生命百分比的100%",
					"物理伤害提升百分比为",
					"失去生命百分比的50%",]
		end
		#--------------------------------------------------------------------------
		# ● 价格函数
		# 	此函数返回该技能的价格
		#
		#   scalar:   	金钱扩张倍数
		#
		#--------------------------------------------------------------------------
		def price(scalar = 1)
			return Fround(200000.0*scalar,1)
		end
	end
	#==============================================================================
	# ■ 勇猛  -- 
	#------------------------------------------------------------------------------
	# 	触发技，被暴击后，攻击+25/50/100%，物理伤害+25/50/100%，持续5/10/20秒
	#
	#==============================================================================
	class YongMeng_Skill < Skill_Base
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
			# 触发技
			@type = 2
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	name		:	技能名字
		#	level		:	技能等级
		# 	battler		:	技能拥有者
		# 	priority	:	优先级 - 越低越优先
		#--------------------------------------------------------------------------
		def setup(name, level, battler, priority = 0)
			super(name, level, battler, priority)
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现can_trigger?
		#--------------------------------------------------------------------------
		def can_trigger?(args)
			if self.battler.hero? == args["target"].hero?
				if $TIME_PRE_POST_DAMAGE == $NOW_TIME 
					return args["source"].bomflag
				end
			end
			return false
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现effect_func触发效果
		#--------------------------------------------------------------------------
		def effect_func(args)
			if (args["target"].hp > 0)
				state = YongMeng_State.new
				state.level = @level
				state.setup(args["target"], "勇猛", 32766)
				args["target"].add_state(state, true, true)
			end
		end
		#--------------------------------------------------------------------------
		# ● 技能描述
		# 		返回一个字符串数组
		#--------------------------------------------------------------------------
		def description
			return ["勇猛：",
					"【触发技】",
					"攻击+25/50/100%",
					"物理伤害+25/50/100%",
					"持续5/10/20秒",]
		end
		#--------------------------------------------------------------------------
		# ● 价格函数
		# 	此函数返回该技能的价格
		#
		#   scalar:   	金钱扩张倍数
		#
		#--------------------------------------------------------------------------
		def price(scalar = 1)
			case @level
			when 1
				return Fround(20000.0*scalar,1)
			when 2
				return Fround(200000.0*scalar,1)
			when 3
				return Fround(2000000.0*scalar,1)
			end
		end
	end
	#==============================================================================
	# ■ 吸血  -- 
	#------------------------------------------------------------------------------
	# 	锁定技，攻击造成伤害后将15%/30%/60%转化为自己生命
	#
	#==============================================================================
	class JiXue_Skill < Skill_Base
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
			# 锁定技
			@type = 1
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	name		:	技能名字
		#	level		:	技能等级
		# 	battler		:	技能拥有者
		# 	priority	:	优先级 - 越低越优先
		#--------------------------------------------------------------------------
		def setup(name, level, battler, priority = 0)
			super(name, level, battler, priority)
		end
		#--------------------------------------------------------------------------
		# ● 锁定技函数
		# 		在技能被添加的时候或者战斗开始的时候被调用，一般是添加状态
		#       这里是给角色添加了吸血光环
		#       吸血光环不可叠加，以高等级覆盖低等级
		#--------------------------------------------------------------------------
		def compulsory_func
			state = JiXue_State.new
			state.level = @level
			state.setup(@battler, "汲血", 32765, 72000)
			@battler.add_state(state, true, true)
		end
		#--------------------------------------------------------------------------
		# ● post-do-damage 阶段处罚
		#   满足条件为角色必须是进攻者，并且角色并没有死亡（例如被反击技能击中）
		#--------------------------------------------------------------------------
		def can_trigger?(args)
			if self.battler.hero? != args["target"].hero?
				if $TIME_POST_DO_DAMAGE == $NOW_TIME 
					b = self.battler
					return (b.state_num_by_name_level("汲血", @level) > 0 and b.hp > 0)
				end
			end
			return false
		end
		#--------------------------------------------------------------------------
		# ● 这是一个锁定技，需要实现effect_func完成吸血效果
		#--------------------------------------------------------------------------
		def effect_func(args)
		p @level
			if rand(100) < 30
				case @level 
				when 1
					self.battler.hp += args["final_dmg"] * 0.5
				when 2
					self.battler.hp += args["final_dmg"] * 0.8
				when 3
					self.battler.hp += args["final_dmg"] * 1.25
				end
			end
		end
		#--------------------------------------------------------------------------
		# ● 技能描述
		# 		返回一个字符串数组
		#--------------------------------------------------------------------------
		def description
			return ["汲血：",
					"【锁定技】",
					"攻击造成伤害后有30%几率",
					"将伤害的50%/80%/125%",
					"转化为自己生命",]
		end
		#--------------------------------------------------------------------------
		# ● 价格函数
		# 	此函数返回该技能的价格
		#
		#   scalar:   	金钱扩张倍数
		#
		#--------------------------------------------------------------------------
		def price(scalar = 1)
			return Fround(200000.0*scalar,1)
		end
	end
end