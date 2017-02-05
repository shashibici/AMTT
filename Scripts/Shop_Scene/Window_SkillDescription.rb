#==============================================================================
# ■ Window_SkillDescription
#------------------------------------------------------------------------------
# 　显示金钱的窗口。
#==============================================================================

class Window_SkillDescription < Window_Base
	attr_accessor 		:item    	#需要绘制价格的物品对象
	attr_reader 		:last_item  #记录之前一个item
	#--------------------------------------------------------------------------
	# ● 初始化对象
	#     x : 窗口的 X 坐标
	#     y : 窗口的 Y 坐标
	#--------------------------------------------------------------------------
	def initialize(x, y, width, height)
		super(x, y, width, height)
		self.z = 200
		@item = nil
		@last_item = nil
		refresh
	end
	#--------------------------------------------------------------------------
	# ● 刷新
	#--------------------------------------------------------------------------
	def refresh
		if @last_item == @item
			return
		else 
			@last_item = @item
		end
		self.contents.clear
		if nil != @item
			# draw item description 
			des = @item.description
			height = des.size * WLH
			for i in 0...des.size 
				self.contents.draw_text(0,i*WLH, self.contents.width, WLH, des[i])
			end
		end
	end
	#--------------------------------------------------------------------------
	# ● 更新
	#--------------------------------------------------------------------------
	def update
		refresh
	end
end