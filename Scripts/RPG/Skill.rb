module RPG
	class Skill < UsableItem
		include GAME_CONF
		attr_accessor :attacker			# 攻击者
		attr_accessor :target 			# 目标
		attr_accessor :time 			# 攻击时机
		attr_accessor :priority			# 优先级
		attr_accessor :level			# 等级
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	attacker	: 	使用者 (影响调用者)
		# 	target 		: 	目标者 (影响调用者)
		# 	time 		: 	攻击时机，在GAME_CONF中定义
		#--------------------------------------------------------------------------
		def setup(attacker, target, time, priority = 0)
			@attacker = attacker
			@target = target
			@time = time
			@priority = priority
		end
		#--------------------------------------------------------------------------
		# ● 设置 time 
		# 		不同技能关心的time不一样
		#--------------------------------------------------------------------------
		def set_time(time)
			
		end
		#--------------------------------------------------------------------------
		# ● 从数据库中读取 time 比较费时间 
		# 		不同技能关心的time不一样
		#--------------------------------------------------------------------------
		def read_time
			t = self.ReadNote("time")
			if nil == t
				return 
			end
			return t
		end
		#--------------------------------------------------------------------------
		# ● 被触发,必须在每个技能中都有实现
		# 	
		# 	brate	: 	暴击倍数， 0-没暴击
		#	pre_dmg	:	计算护甲之前。 攻击者产生的伤害
		#	dmg 	: 	计算护甲之后。实际作用伤害
		# 	pure	: 	纯粹伤害，如果有
		#	hitflg	:	是否命中
		# 	bomflg	:	是否暴击
		#--------------------------------------------------------------------------
		def triggered(brate = 0, pre_dmg = 0, dmg = 0, pure = 0, hitflag = true, bomflag = false)
			return [brate, pre_dmg, dmg, pure]
		end
	end
	#==============================================================================
	# ■ 示例1  反弹
	#------------------------------------------------------------------------------
	# 	有20%几率将对方造成的伤害的 技能等级 X 5% 以纯粹伤害反弹
	#===============================================================
	class Fantan < Skill
		include GAME_CONF
		#--------------------------------------------------------------------------
		# ● 初始化
		#--------------------------------------------------------------------------
		def initialize
			super
		end
		#--------------------------------------------------------------------------
		# ● 设置对象	
		#	attacker	: 	使用者 (影响调用者)
		# 	target 		: 	目标者 (影响调用者)
		# 	time 		: 	默认为 $TIME_POST_PRE_DAMAGE （最终伤害已经出来）
		# 	priority	: 	默认为1，一般就不修改了
		#--------------------------------------------------------------------------
		def setup(attacker, target, time = $TIME_POST_PRE_DAMAGE, priority = 1)
			@attacker = attacker
			@target = target
			@time = time
			@priority = priority
		end
		#--------------------------------------------------------------------------
		# ● 被触发,必须在每个技能中都有实现
		#	
		#	
		#
		#
		#
		#--------------------------------------------------------------------------
		def triggered(brate = 0, drate = 0, dmg = 0, pure = 0, hitflag = true, bomflag = false)
			if hitflag == false
				return [brate, drate, dmg, pure]
			end
			if $TIME_POST_PRE_DAMAGE != $NOW_TIME or !@target.has_skill?(self.id)
				return [brate, drate, dmg, pure]
			end
			if 20 < rand(101) 
				return [brate, drate, dmg, pure]
			end
			# 获得反弹伤害
			d = dmg * (@target.my_skills)[self.id]["level"] * 0.05
			# 实施纯粹伤害
			@target.dodamage(@attacker, d)
			if @target.hero?
				# 显示伤害 - 目标是英雄，被反弹的是怪物
				$game_map.events[$game_variables[37]].damage_talk(d.to_i)
				$game_map.events[$game_variables[37]].animation_id = 110
			else
				# 显示伤害
				$game_player.damage_talk(d.to_i)
				# 显示动画-纯粹伤害
				$game_player.animation_id = 110
			end
			
			return [brate, drate, dmg, pure]
		end
	end
	
	
end
