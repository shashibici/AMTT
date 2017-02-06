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
			return Fround(100.0*scalar,1)
		end
	end
	#==============================================================================
	# ■ 反击 -- 测试通过
	#------------------------------------------------------------------------------
	# 	触发技，角色每次受到攻击有30%/60%/100%几率进行一次反击，不能触发效果
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
				if $TIME_POST_DO_DAMAGE == $NOW_TIME
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
					"角色每次受到攻击有30%/60%/100%",
					"几率进行一次反击。",
					"不能触发效果",]
		end
		#--------------------------------------------------------------------------
		# ● 价格函数
		# 	此函数返回该技能的价格
		#
		#   scalar:   	金钱扩张倍数
		#
		#--------------------------------------------------------------------------
		def price(scalar = 1)
			return Fround(100.0*scalar,1)
		end
	end
	#==============================================================================
	# ■ 冰冻 - 测试通过
	#------------------------------------------------------------------------------
	# 	触发技，角色每次攻击命中会造成冷冻效果；
	# 			对方攻速减少20%/40%/80%，持续5/7/10秒，冰冻效果不可叠加
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
				case @level
				when 1
					state.speed_rate = -20
					state.setup(args["target"], "冰冻", 65536, 5)
				when 2
					state.speed_rate = -40
					state.setup(args["target"], "冰冻", 65536, 7)
				when 3
					state.speed_rate = -80
					state.setup(args["target"], "冰冻", 65536, 10)
				end
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
		#--------------------------------------------------------------------------
		# ● 技能描述
		# 		返回一个字符串数组
		#--------------------------------------------------------------------------
		def description
			return ["冰冻：",
					"【触发技】",
					"角色每次攻击命中会给对方添加冷",
					"冻状态；冰冻状态使攻速减少",
					"20%/40%/80%，持续5/7/10秒，",
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
			return Fround(1000.0*scalar,1)
		end
	end
	#==============================================================================
	# ■ 坚守  -- 通过测试
	#------------------------------------------------------------------------------
	# 	锁定技，提升防御力，防御提升百分比为角色失去生命百分比的50%/100%/200%
	#==============================================================================
	class JianShou_Skill < Skill_Base
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
		# ● 锁定技函数
		# 		在技能被添加的时候或者战斗开始的时候被调用，一般是添加状态
		#--------------------------------------------------------------------------
		def compulsory_func
			state = JianShou_State.new
			case @level
			when 1
				state.ratio = 50
				state.setup(@battler, "坚守I", 32768, 72000)
			when 2
				state.ratio = 100
				state.setup(@battler, "坚守II", 32768, 72000)
			when 3
				state.ratio = 200
				state.setup(@battler, "坚守III", 32768, 72000)
			end
			@battler.add_state(state)
		end
		#--------------------------------------------------------------------------
		# ● 技能描述
		# 		返回一个字符串数组
		#--------------------------------------------------------------------------
		def description
			return ["坚守：",
					"【锁定技】",
					"防御提升百分比为失去生命百分比",
					"的50%/100%/200%",]
		end
		#--------------------------------------------------------------------------
		# ● 价格函数
		# 	此函数返回该技能的价格
		#
		#   scalar:   	金钱扩张倍数
		#
		#--------------------------------------------------------------------------
		def price(scalar = 1)
			return Fround(900.0*scalar,1)
		end
	end
	#==============================================================================
	# ■ 疾风  -- 测试通过
	#------------------------------------------------------------------------------
	# 	角色每次攻击被闪避时攻速提升20%/40%/80%，命中提升100%/200%/300%，持续10/15/30秒，不可叠加
	#==============================================================================
	class JiFeng_Skill < Skill_Base
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
			if (args["source"].hp > 0)
				state = Jifeng_State.new
				state.level = @level
				state.setup(args["source"], "疾风", 32768)
				if args["source"].state_num(state) > 0
					return
				else
					args["source"].add_state(state)
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
				return Fround(1000.0*scalar,1)
			when 2
				return Fround(10000.0*scalar,1)
			when 3
				return Fround(100000.0*scalar,1)
			end
		end
	end
	#==============================================================================
	# ■ 复仇  -- 测试通过
	#------------------------------------------------------------------------------
	# 	角色受到暴击之后立即发动下一次攻击
	#==============================================================================
	class Fuchou_Skill < Skill_Base
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
			return Fround(1000.0*scalar,1)
		end
	end
end