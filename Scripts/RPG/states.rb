module RPG	
	#==============================================================================
	# ■ 巨化 - （必暴击在技能中实现）
	#		-- 测试通过
	#------------------------------------------------------------------------------	
	#	效果：攻速-50%，二级+100%生命恢复，三级+100%生命最大值， 不可叠加
	#	
	#==============================================================================
	class Juhua_State < State_Base
		#--------------------------------------------------------------------------
		# ● 能否叠加
		#--------------------------------------------------------------------------
		def can_accumulate?
			return false
		end
		#--------------------------------------------------------------------------
		# ● 最大叠加数 - 1重
		#--------------------------------------------------------------------------
		def max_accumulate
			return 1
		end
		#--------------------------------------------------------------------------
		# ● 按百分比减速
		#--------------------------------------------------------------------------
		def atkspeed_rate
			case @level 
			when 1
				-10
			when 2
				-15
			when 3
				-20
			end
		end
		#--------------------------------------------------------------------------
		# ● 该state从百分比上加成battler的hpcover
		#--------------------------------------------------------------------------
		def hpcover_boost_rate
			if @level > 1
				return 100
			else 
				return 0
			end
		end
		#--------------------------------------------------------------------------
		# ● 该state从百分比上加成battler的maxhp
		#--------------------------------------------------------------------------
		def maxhp_rate
			if @level > 2
				return 100
			else 
				return 0
			end
		end
	end
	#==============================================================================
	# ■ 改变速度 - 同名称的状态不能叠加，不同名称可以并存
	#		-- 测试通过
	#------------------------------------------------------------------------------	
	#	例子。
	#	名字：Single_Speed_Change_State
	#	效果：按百分比或者数值减慢攻速, 不可叠加
	#	
	#==============================================================================
	class Single_Speed_Change_State < State_Base
		attr_accessor 		:speed_rate
		attr_accessor		:speed
		#--------------------------------------------------------------------------
		# ● 能否叠加
		#--------------------------------------------------------------------------
		def can_accumulate?
			return false
		end
		#--------------------------------------------------------------------------
		# ● 最大叠加数 - 1重
		#--------------------------------------------------------------------------
		def max_accumulate
			return 1
		end
		#--------------------------------------------------------------------------
		# ● 按百分比减速
		#--------------------------------------------------------------------------
		def atkspeed_rate
			if @speed_rate != nil
				return @speed_rate
			else
				return 0
			end
		end
		#--------------------------------------------------------------------------
		# ● 按数值减速
		#--------------------------------------------------------------------------
		def atkspeed
			if @speed != nil
				return @speed
			else
				return 0
			end
		end
	end
	#==============================================================================
	# ■ 按百分比改变最生命恢复 - 对应技能"顽强"，同名称的状态不能叠加，
	#   不同名称可以并存
	#		-- 测试通过
	#------------------------------------------------------------------------------		
	#	Wanqiang_State
	#	效果：按生命百分比增加生命恢复
	#	
	#==============================================================================
	class Wanqiang_State < State_Base
		#--------------------------------------------------------------------------
		# ● 能否叠加
		#--------------------------------------------------------------------------
		def can_accumulate?
			return true
		end
		#--------------------------------------------------------------------------
		# ● 最大叠加数 - 99重
		#--------------------------------------------------------------------------
		def max_accumulate
			return 1
		end
		#--------------------------------------------------------------------------
		# ● 该state按照当前生命恢复量从百分比上加成battler的hpcover
		#--------------------------------------------------------------------------
		def hpcover_boost_rate
			case @level
			when 1
				return (1.0 - @battler.hp.to_f / @battler.maxhp.to_f) * 150
			when 2
				return (1.0 - @battler.hp.to_f / @battler.maxhp.to_f) * 300
			when 3
				return (1.0 - @battler.hp.to_f / @battler.maxhp.to_f) * 600
			end
			return 0
		end
	end
	#==============================================================================
	# ■ 按百分比改变最防御 - 对应技能"坚守"，同名称的状态不能叠加，不同名称可以并存
	#		-- 通过测试
	#------------------------------------------------------------------------------		
	#	JianShou_State
	#	效果：按生命百分比增加防御
	#	
	#==============================================================================
	class JianShou_State < State_Base
		attr_accessor 			:ratio
		#--------------------------------------------------------------------------
		# ● 能否叠加
		#--------------------------------------------------------------------------
		def can_accumulate?
			return true
		end
		#--------------------------------------------------------------------------
		# ● 最大叠加数 - 99重
		#--------------------------------------------------------------------------
		def max_accumulate
			return 1
		end
		#--------------------------------------------------------------------------
		# ● 按百分比
		#--------------------------------------------------------------------------
		def def_rate
			if nil == @ratio
				return (1.0 - @battler.hp.to_f / @battler.maxhp.to_f) * 100
			else
				ret = (1.0 - @battler.hp.to_f / @battler.maxhp.to_f) * @ratio
				return ret
			end
		end
	end
	#==============================================================================
	# ■ 按百分比改变最防御 - 对应技能"疾风"
	#		-- 测试通过
	#------------------------------------------------------------------------------		
	#	Jifeng_State
	#	效果：一定时间内提升攻速、命中
	#	参数：等级。提升攻速、命中百分比、持续时间与参数等级相关
	#==============================================================================
	class Jifeng_State < State_Base
		#--------------------------------------------------------------------------
		# ● 设置参数
		#	battler 		:	状态拥有者
		# 	name 			: 	状态实例显示的名字、图标名称
		# 	priority		:	状态结算优先级 - 越小越优先 - 系统默认为65536
		# 	timer 			:	状态持续时间 - 单位，秒
		#
		#
		#   调用此函数之前必须设置技能等级@level
		#--------------------------------------------------------------------------
		def setup(battler, name, priority = 65535, timer = 7200)
			@battler = battler
			@priority = priority
			@name = name
			@timer = (10 * Graphics.frame_rate).ceil
			case @level 
			when 1
				@timer = (5 * Graphics.frame_rate).ceil
			when 2
				@timer = (10 * Graphics.frame_rate).ceil
			when 3
				@timer = (20 * Graphics.frame_rate).ceil
			end
		end
		#--------------------------------------------------------------------------
		# ● 能否叠加
		#--------------------------------------------------------------------------
		def can_accumulate?
			return false
		end
		#--------------------------------------------------------------------------
		# ● 最大叠加数 - 1重
		#--------------------------------------------------------------------------
		def max_accumulate
			return 1
		end
		#--------------------------------------------------------------------------
		# ● 该state从百分比上加成battler的atkspeed
		#--------------------------------------------------------------------------
		def atkspeed_rate
			case @level
			when 1
				return 20
			when 2
				return 40
			when 3
				return 80
			end
			return 0
		end
		#--------------------------------------------------------------------------
		# ● 该state从百分比上加成battler的hit
		#--------------------------------------------------------------------------
		def hit_rate
			case @level
			when 1
				return 100
			when 2
				return 200
			when 3
				return 300
			end
			return 0
		end
	end
	#==============================================================================
	# ■ 按百分比改变攻速和物理伤害 
	#		-- 
	#------------------------------------------------------------------------------		
	#	Shixue_State
	#	效果：按失去生命百分比增加攻速和伤害
	#	
	#==============================================================================
	class Shixue_State < State_Base
		#--------------------------------------------------------------------------
		# ● 能否叠加
		#--------------------------------------------------------------------------
		def can_accumulate?
			return true
		end
		#--------------------------------------------------------------------------
		# ● 最大叠加数 - 1重
		#--------------------------------------------------------------------------
		def max_accumulate
			return 1
		end
		#--------------------------------------------------------------------------
		# ● 该state从百分比上加成battler的atkspeed
		#--------------------------------------------------------------------------
		def atkspeed_rate
			return (1.0 - @battler.hp.to_f / @battler.maxhp.to_f) * 100
		end
		#--------------------------------------------------------------------------
		# ● 该state从百分比上加成battler的destroy
		#--------------------------------------------------------------------------
		def destroy_rate
			return (1.0 - @battler.hp.to_f / @battler.maxhp.to_f) * 50
		end
	end
	#==============================================================================
	# ■ 按百分比改变攻击和物理伤害 
	#		-- 
	#------------------------------------------------------------------------------		
	#	Shixue_State
	#	效果：按百分比增加攻击和物理伤害
	#	
	#==============================================================================
	class YongMeng_State < State_Base
		#--------------------------------------------------------------------------
		# ● 设置参数
		#	battler 		:	状态拥有者
		# 	name 			: 	状态实例显示的名字、图标名称
		# 	priority		:	状态结算优先级 - 越小越优先 - 系统默认为65536
		# 	timer 			:	状态持续时间 - 单位，秒
		#
		#
		#   调用此函数之前必须设置技能等级@level
		#--------------------------------------------------------------------------
		def setup(battler, name, priority = 65535, timer = 7200)
			@battler = battler
			@priority = priority
			@name = name
			@timer = (10 * Graphics.frame_rate).ceil
			case @level 
			when 1
				@timer = (5 * Graphics.frame_rate).ceil
			when 2
				@timer = (10 * Graphics.frame_rate).ceil
			when 3
				@timer = (20 * Graphics.frame_rate).ceil
			end
		end
		#--------------------------------------------------------------------------
		# ● 能否叠加
		#--------------------------------------------------------------------------
		def can_accumulate?
			return false
		end
		#--------------------------------------------------------------------------
		# ● 最大叠加数 - 1重
		#--------------------------------------------------------------------------
		def max_accumulate
			return 1
		end
		#--------------------------------------------------------------------------
		# ● 该state从百分比上加成battler的atk
		#--------------------------------------------------------------------------
		def atk_rate
			case @level
			when 1
				return 25
			when 2
				return 50
			when 3
				return 100
			end
			return 0
		end
		#--------------------------------------------------------------------------
		# ● 该state从百分比上加成battler的destroy
		#--------------------------------------------------------------------------
		def destroy_rate
			case @level 
			when 1
				return 25
			when 2
				return 50
			when 3
				return 100
			end 
			return 0
		end
	end
end