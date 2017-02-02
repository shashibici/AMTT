#==============================================================================
# ■ Scene_Shop_Equip
#------------------------------------------------------------------------------
# 　处理装备的商店画面的类。
#==============================================================================
$Skill_included = []
class Scene_Shop_Skill < Scene_Base
	#--------------------------------------------------------------------------
	# ● 开始处理
	#
	#--------------------------------------------------------------------------
	def start
		super
		create_menu_background
		create_command_window
		@gold_window = Window_Gold.new(480, 0)
		@dummy_window = Window_Base.new(0, 56, 640, 424)
		@buy_window = Window_SkillBuy.new(0, 56)
		@buy_window.active = false
		@buy_window.visible = false
		@sell_window = Window_SkillSell.new(0, 56, 400, 424)
		@sell_window.active = false
		@sell_window.visible = false
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
		@dummy_window.dispose
		@buy_window.dispose
		@sell_window.dispose
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
		@dummy_window.update
		@buy_window.update
		@sell_window.update
		if @command_window.active
			update_command_selection
		elsif @buy_window.active
			update_buy_selection
		elsif @sell_window.active
			update_sell_selection
		end
	end
	#--------------------------------------------------------------------------
	# ● 生成指令窗口
	#--------------------------------------------------------------------------
	def create_command_window
		
	end
	#--------------------------------------------------------------------------
	# ● 更新选择卖出技能
	#
	#--------------------------------------------------------------------------
	def update_sell_selection
	end
	#--------------------------------------------------------------------------
	# ● 更新选择购买技能
	#
	#--------------------------------------------------------------------------
	def update_buy_selection
	end
	#--------------------------------------------------------------------------
	# ● 更新指令窗口
	#--------------------------------------------------------------------------
	def update_command_selection
	end
end