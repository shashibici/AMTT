#==============================================================================
# ■ Window_Selectable
#------------------------------------------------------------------------------
#==============================================================================

class Window_Selectable < Window_Base
	#--------------------------------------------------------------------------
	# ● 描绘物品名
	#
	#     重载父类中的函数
	#
	#     item    : 物品 (可以是特技、武器、防具)
	#     x       : 描绘目标 X 坐标
	#     y       : 描绘目标 Y 坐标
	#     enabled : 有效标志。false 为描绘为半透明
	#--------------------------------------------------------------------------
	def draw_item_name(item, x, y, enabled = true)
		if item != nil
			draw_icon(item.icon_index, x, y, enabled)
			old_color = self.contents.font.color.clone
			self.contents.font.color = getColor(item.getColor)
			self.contents.font.color.alpha = enabled ? 255 : 128
			self.contents.draw_text(x + 24, y, 157+16, WLH, item.name)
			self.contents.font.color = old_color
		end
	end
end	