#===========================================================================
	# ■ Window_Consult2
	#---------------------------------------------------------------------------
	#     本窗口用来显示怪物的装备信息
	#
#===========================================================================
class Window_Equip_Select < Window_Selectable 
	include Kernel
	WLH = 24
	attr_accessor   :index
	attr_accessor   :type
	#--------------------------------------------------------------------------
		# ● 初始化对象
		#     x     : 窗口的 X 坐标
		#     y     : 窗口的 Y 坐标
		#     actor : 角色
	#--------------------------------------------------------------------------
	def initialize(x, y, actor)
		super(x, y, 276, WLH * 12 + 36)
		self.opacity = 0
		@actor = actor
		self.contents.font.size = 20
		@edge = 0
		refresh
		@index = 0
	end
	#--------------------------------------------------------------------------
		# ● 获取物品
	#--------------------------------------------------------------------------
	def item
		return @data[self.index]
	end
	#--------------------------------------------------------------------------
		# ● 刷新
	#--------------------------------------------------------------------------
	def refresh
		self.contents.clear
		@data = []
		
		for item in @actor.equips(false) do @data.push(item) end
		
		@item_max = @data.size
		
		self.contents.font.color = system_color
		
		self.contents.draw_text(4, WLH * 0,       72, WLH, "武器1")
		self.contents.draw_text(4, WLH * 1+@edge*1, 72, WLH, "武器2")
		self.contents.draw_text(4, WLH * 2+@edge*2, 72, WLH, "头部")
		self.contents.draw_text(4, WLH * 3+@edge*3, 72, WLH, "颈部")
		self.contents.draw_text(4, WLH * 4+@edge*4, 72, WLH, "盾")
		self.contents.draw_text(4, WLH * 5+@edge*5, 72, WLH, "衣服")
		self.contents.draw_text(4, WLH * 6+@edge*6, 72, WLH, "戒指")
		self.contents.draw_text(4, WLH * 7+@edge*7, 72, WLH, "鞋子")
		self.contents.draw_text(4, WLH * 8+@edge*8, 72, WLH, "宝物1")
		self.contents.draw_text(4, WLH * 9+@edge*9, 72, WLH, "宝物2")
		self.contents.draw_text(4, WLH * 10+@edge*10, 72, WLH, "宝物3")
		self.contents.draw_text(4, WLH * 11+@edge*11, 72, WLH, "宝物4")
		
		
		draw_item_name(@data[0], 67, WLH * 0)
		draw_item_name(@data[1], 67, WLH * 1+@edge*1)
		draw_item_name(@data[2], 67, WLH * 2+@edge*2)
		draw_item_name(@data[3], 67, WLH * 3+@edge*3)
		draw_item_name(@data[4], 67, WLH * 4+@edge*4)
		draw_item_name(@data[5], 67, WLH * 5+@edge*5)
		draw_item_name(@data[6], 67, WLH * 6+@edge*6)
		draw_item_name(@data[7], 67, WLH * 7+@edge*7)
		draw_item_name(@data[8], 67, WLH * 8+@edge*8)
		draw_item_name(@data[9], 67, WLH * 9+@edge*9)
		draw_item_name(@data[10], 67, WLH * 10+@edge*10)
		draw_item_name(@data[11], 67, WLH * 11+@edge*11)
	end
	
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
			self.contents.font.color = getColor(item.getColor)
			self.contents.font.color.alpha = enabled ? 255 : 128
			self.contents.draw_text(x + 24, y, 145, WLH, item.name)
		end
	end
	#--------------------------------------------------------------------------
		# ● 更新帮助文本
	#--------------------------------------------------------------------------
	def update_help
		@help_window.set_text(item == nil ? "" : item.description)
	end
	
	
	#--------------------------------------------------------------------------
		# ● 调用详细窗口刷新函数
	#--------------------------------------------------------------------------
	def call_update_detail
		if (self.active and self.visible) and @window_detail != nil
			@window_detail.visible = true
			update_detail
		elsif @window_detail != nil
			@window_detail.visible = false
		end
	end    
	#--------------------------------------------------------------------------
		# ● 更新详细信息窗口 (继承内容)
	#--------------------------------------------------------------------------
	def update_detail
		# 修改内容
		if self.item == nil
			text = []
			colors = []
		elsif nil == (temp = GAME_INIT.getEquipDes(@type, item.id))
			text = []
			colors = []
		else
			# temp = GAME_INIT.getEquipDes(@type, item.id)
			text = temp[0]
			colors = temp[1]
		end
		@window_detail.set_text(text, 0, colors)
		# 设置位置
		@window_detail.x = self.x + self.width*3.0/4
		@window_detail.y = self.y + 24 + (index / @column_max - top_row) * WLH
		# 修改位置
		if @window_detail.y + @window_detail.height >= 500
			@window_detail.y -= @window_detail.height
		end
		if @window_detail.x + @window_detail.width >= 640
			@window_detail.x -= @window_detail.width
		end
		
	end   
end