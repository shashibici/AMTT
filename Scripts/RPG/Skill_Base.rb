module RPG
#==============================================================================
# ■ Skill_Base
#------------------------------------------------------------------------------
# 	Skill_Base 定义了所有技能的基类
# 	技能分为两类： 触发技和锁定技
#	触发函数是一个trigger_func，在Skill_Base中定义。
#   trigger_func 会调用效果函数effect_func、时机函数can_trigger?。不同技能效果函数不同
#	锁定技函数在技能被添加或者战斗开始的时候就调用。
#   锁定技函数通常是改变自身或者对方的states
#==============================================================================
	class Skill_Base < UsableItem
		#include GAME_CONF
		attr_accessor :battler			# 指向技能所属者
		attr_accessor :priority			# 优先级，所有技能的优先级不能够有重复
		attr_accessor :level			# 等级
		attr_accessor :name 			# 名字 -- 同一战斗者而言，名字+等级唯一识别一个技能
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	attacker		: 	使用者 
		# 	target 			: 	目标者 
		# 	subscriber 		: 	攻击时机列表，在GAME_CONF中定义
		#--------------------------------------------------------------------------
		def setup(name, level, battler, priority = 0)
			@name = name
			@level = level
			@battler = battler
			@priority = priority
		end
		#--------------------------------------------------------------------------
		# ●  动态修改优属于者
		#
		#  	此函数在角色学习技能的时候调用
		#--------------------------------------------------------------------------
		def set_battler(battler)
			@battler = battler
			compulsory_func
		end
		#--------------------------------------------------------------------------
		# ●  动态修改优先级
		#--------------------------------------------------------------------------
		def set_priority(p)
			@priority = p
		end	
		#--------------------------------------------------------------------------
		# ● 锁定技函数
		# 		在技能被添加的时候或者战斗开始的时候被调用，一般是添加状态
		#--------------------------------------------------------------------------
		def compulsory_func
		end
		#--------------------------------------------------------------------------
		# ● 触发技函数
		# 		在每个事件发生的时候都会调用一次
		# 		事件包括攻击事件和阶段切换事件
		# 		args 是一个 hash 结构，用来传递参数
		#--------------------------------------------------------------------------
		def trigger_func(args)
			if can_trigger?(args)
				effect_func(args)
			end
		end
		#--------------------------------------------------------------------------
		# ● 判断触发条件
		# 		此函数由子类具体实现
		#--------------------------------------------------------------------------
		def can_trigger?(args)
			return false
		end
		#--------------------------------------------------------------------------
		# ● 触发效果函数
		#		此函数由子类具体实现
		#--------------------------------------------------------------------------
		def effect_func
		end
		#--------------------------------------------------------------------------
		# ● 动画函数
		#		此函数由子类具体实现,必要的时候定义内部属性传参数
		# 		这个函数在播放动画的时候会调用 -- 依据技能优先级显示动画
		#--------------------------------------------------------------------------
		def animation_func(args)
		end
		#--------------------------------------------------------------------------
		# ● 技能描述
		# 		返回一个字符串数组
		# 		e.g., return ["反击：\n",
		# 					  "触发技，\n",
		# 					  "角色每次受到攻击有20%几率进行一次反击，\n",
		#                     "不能触发效果\n",]
		#--------------------------------------------------------------------------
		def description
			return []
		end
	end

end
