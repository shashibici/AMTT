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
				if super(args)
					if $TIME_POST_PRE_DAMAGE == $NOW_TIME
						return true
					end
				end
			end
			return false
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现effect_func触发效果
		#--------------------------------------------------------------------------
		def effect_func(args)
			if (args["target"].hp > 0) and (args["source"].hp > 0)
				if rand(100) < 100
					damage = args["damage"]
					bounce = @level * 0.05 * damage
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
	end
	#==============================================================================
	# ■ 反击 -- 测试通过
	#------------------------------------------------------------------------------
	# 	触发技，角色每次受到攻击有20%几率进行一次反击，不能触发效果
	#==============================================================================
	class FanJi_Skill < Skill_Base
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
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
				if super(args)
					if $TIME_POST_DO_DAMAGE == $NOW_TIME
						return true
					end
				end
			end
			return false
		end
		#--------------------------------------------------------------------------
		# ● 这是一个触发技能，需要实现effect_func触发效果
		#--------------------------------------------------------------------------
		def effect_func(args)
			if (args["target"].hp > 0) and (args["source"].hp > 0)
				if rand(20) < 100
					if args["target"].hero?
						Battle.Battle_strike_back_player
					else
						Battle.Battle_strike_back_enemy
					end
				end
			end
		end
	end
	#==============================================================================
	# ■ 冰冻 - 测试通过
	#------------------------------------------------------------------------------
	# 	触发技，角色每次攻击会造成冷冻效果；对方攻速减少50%，持续5秒，不可叠加
	#==============================================================================
	class BinDong_Skill < Skill_Base
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
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
				if super(args)
					if $TIME_POST_DO_ATTACK == $NOW_TIME
						return true
					end
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
				state.setup(args["target"], "冰冻", 1, 5)
				state.speed_rate = -50
				if args["target"].state_num(state) > 0
					return
				else
					args["target"].add_state(state)
					animation_func(args)
				end
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
	end
end