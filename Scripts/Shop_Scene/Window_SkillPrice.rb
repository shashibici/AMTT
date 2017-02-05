#==============================================================================
# ■ Window_SkillPrice
#------------------------------------------------------------------------------
# 　显示金钱的窗口。
#==============================================================================

class Window_SkillPrice < Window_Base
	attr_accessor 		:item    	#需要绘制价格的物品对象
	attr_reader 		:last_item  #记录之前一个item
	attr_accessor  		:scalar
	#--------------------------------------------------------------------------
	# ● 初始化对象
	#     x : 窗口的 X 坐标
	#     y : 窗口的 Y 坐标
	#     scalar: 扩张系数
	#--------------------------------------------------------------------------
	def initialize(x, y, width, height, scalar = 1)
		super(x, y, width, height)
		self.z = 200
		@item = nil
		@last_item = nil
		@scalar = scalar
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
		if nil != item
			# draw item price. 
			self.contents.font.size = 24
			self.contents.draw_text(0,0, self.contents.width, self.contents.height, "价格："+item.price(@scalar).to_s)
		end
	end
	#--------------------------------------------------------------------------
	# ● 更新
	#--------------------------------------------------------------------------
	def update
		refresh
	end
end