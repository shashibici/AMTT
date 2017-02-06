#==============================================================================
# ■ Scene_Shop_Skill
#------------------------------------------------------------------------------
# 　处理技能的商店画面的类。
#==============================================================================
#  [[名字,等级],[名字,等级]...]
$Skill_included = []
$Skill_sell_scalar = 1.0
$Skill_buy_scalar = 1.0

class Scene_Shop_Skill < Scene_Base
	#--------------------------------------------------------------------------
	# ● 开始处理
	#
	#--------------------------------------------------------------------------
	def start
		super
		@sell_scalar = $Skill_sell_scalar
		@buy_scalar = $Skill_buy_scalar
		create_menu_background
		create_command_window
		@gold_window = Window_Gold.new(480, 0)
		@gold_window.x = 480
		@gold_window.y = 64
		@buy_window = Window_SkillBuy.new(0, 120, 106, 360, $Skill_included)
		@buy_window.active = false
		@buy_window.visible = false
		@buy_deal_window = Window_Command.new(172, ["确定", "取消"])
		@buy_deal_window.x = (Graphics.width - @buy_deal_window.width) / 2.0
		@buy_deal_window.y = (Graphics.height - @buy_deal_window.height) / 2.0
		@buy_deal_window.z = 3000
		@buy_deal_window.visible = false
		@buy_deal_window.active = false
		@sell_window = Window_SkillSell.new(0, 120, 106, 360, $game_party.active)
		@sell_window.active = false
		@sell_window.visible = false
		@sell_deal_window = Window_Command.new(172, ["确定", "取消"])
		@sell_deal_window.x = (Graphics.width - @sell_deal_window.width) / 2.0
		@sell_deal_window.y = (Graphics.height - @sell_deal_window.height) / 2.0
		@sell_deal_window.z = 3000
		@sell_deal_window.visible = false
		@sell_deal_window.active = false
		@price_window = Window_SkillPrice.new(0, 0, 640, 64, 1.0)
		@price_window.active = true
		@price_window.visible = true
		@price_window.item = nil
		@des_window = Window_SkillDescription.new(106, 120, 640-106, 360)
		@des_window.item = nil
		@des_window.active = false
		@des_window.visible = false
	end
	#--------------------------------------------------------------------------
	# ● 释放指令窗口
	#
	#--------------------------------------------------------------------------
	def dispose_command_window
		@command_window.dispose
	end
	#--------------------------------------------------------------------------
	# ● 结束处理
	#
	#--------------------------------------------------------------------------
	def terminate
		super
		dispose_menu_background
		dispose_command_window
		@gold_window.dispose
		@buy_window.dispose
		@sell_window.dispose
		@price_window.dispose
		@des_window.dispose
		@buy_deal_window.dispose
		@sell_deal_window.dispose
	end
	#--------------------------------------------------------------------------
	# ● 更新画面
	#
	#--------------------------------------------------------------------------
	def update
		super
		update_menu_background
		@command_window.update
		@gold_window.update
		@buy_window.update
		@sell_window.update
		@buy_deal_window.update
		@sell_deal_window.update
		if @command_window.active
			update_command_selection
		elsif @buy_window.active
			@price_window.item = @buy_window.skill
			@price_window.scalar = @buy_scalar
			@price_window.update
			@des_window.item = @buy_window.skill
			@des_window.update
			update_buy_selection
		elsif @sell_window.active
			@price_window.item = @sell_window.skill
			@price_window.scalar = @sell_scalar
			@price_window.update
			@des_window.item = @sell_window.skill
			@des_window.update
			update_sell_selection
		elsif @buy_deal_window.active or @sell_deal_window.active
			update_deal_window
		end
	end
	#--------------------------------------------------------------------------
	# ● 生成指令窗口
	#--------------------------------------------------------------------------
	def create_command_window
		s1 = "购买技能"
		s2 = "出售技能"
		s3 = "离开"
		@command_window = Window_Command.new(480, [s1, s2, s3], 3)
		@command_window.y = 64
	end
	#--------------------------------------------------------------------------
	# ● 更新选择卖出技能
	#
	#--------------------------------------------------------------------------
	def update_sell_selection
		if Input.trigger?(Input::B)
			Sound.play_cancel
			@sell_window.active = false
			@sell_window.visible = false
			@price_window.item = nil
			@price_window.update
			@des_window.item = nil
			@des_window.update
			@des_window.visible = false
			@command_window.active = true
		elsif Input.trigger?(Input::C)
			if nil == (skill = @sell_window.skill)
				return
			end
			if $game_party.active.skill_exist?(skill)
				Sound.play_decision
				@sell_deal_window.active = true
				@sell_deal_window.visible = true
				@sell_window.active = false
			end
		end
	end
	#--------------------------------------------------------------------------
	# ● 更新选择购买技能
	#
	#--------------------------------------------------------------------------
	def update_buy_selection
		if Input.trigger?(Input::B)
			Sound.play_cancel
			@buy_window.active = false
			@buy_window.visible = false
			@price_window.item = nil
			@price_window.update
			@des_window.item = nil
			@des_window.update
			@des_window.visible = false
			@command_window.active = true
		elsif Input.trigger?(Input::C)
			if nil == (skill = @buy_window.skill)
				return
			end
			if $game_party.gold > skill.price(@buy_scalar) and $game_party.active.can_add_skill?(skill)
				Sound.play_decision
				@buy_deal_window.active = true
				@buy_deal_window.visible = true
				@buy_window.active = false
			else
				Sound.play_buzzer
			end			
		end
	end
	#--------------------------------------------------------------------------
	# ● 更新决定选择
	#
	#--------------------------------------------------------------------------
	def update_deal_window
		if @buy_deal_window.active
			if Input.trigger?(Input::B)
				Sound.play_cancel
				@buy_deal_window.active = false
				@buy_deal_window.visible = false
				@buy_window.active = true
			elsif Input.trigger?(Input::C)
				if 0 == @buy_deal_window.index
					# buy
					Sound.play_decision
					skill = @buy_window.skill.clone
					skill.set_battler($game_party.active)
					skill.set_priority($game_party.active.max_skill_priority+1)
					$game_party.active.add_skill(skill)
					$game_party.lose_gold(skill.price(@buy_scalar))
					@sell_window.refresh
					@buy_window.refresh
					@gold_window.refresh
				else
					# cancel
					Sound.play_cancel
				end
				@buy_deal_window.active = false
				@buy_deal_window.visible = false
				@buy_window.active = true
			end
		elsif @sell_deal_window.active
			if Input.trigger?(Input::B)
				Sound.play_cancel
				@sell_deal_window.active = false
				@sell_deal_window.visible = false
				@sell_window.active = true
			elsif Input.trigger?(Input::C)
				if 0 == @sell_deal_window.index
					# sell
					Sound.play_decision
					skill = @sell_window.skill
					if nil != $game_party.active.delete_skill_by_name_level(skill.name, skill.level)
						$game_party.gain_gold(skill.price(@sell_scalar))
					end
					@sell_window.refresh
					@buy_window.refresh
					@gold_window.refresh
				else
					# cancel
					Sound.play_cancel
				end
				@sell_deal_window.active = false
				@sell_deal_window.visible = false
				@sell_window.active = true
			end
		end
	end
	#--------------------------------------------------------------------------
	# ● 更新指令窗口
	#--------------------------------------------------------------------------
	def update_command_selection
		if Input.trigger?(Input::B)
			Sound.play_cancel
			$scene = Scene_Map.new
		elsif Input.trigger?(Input::C)
			case @command_window.index
			when 0  # 购买
				Sound.play_decision
				@command_window.active = false
				@buy_window.active = true
				@buy_window.visible = true
				@des_window.active = true
				@des_window.visible = true
				@buy_window.refresh
			when 1  # 卖出
				Sound.play_decision
				@command_window.active = false
				@sell_window.active = true
				@sell_window.visible = true
				@des_window.active = true
				@des_window.visible = true
				@sell_window.refresh
			when 2  # 取消
				Sound.play_decision
				$scene = Scene_Map.new
			end
		end
	end
end