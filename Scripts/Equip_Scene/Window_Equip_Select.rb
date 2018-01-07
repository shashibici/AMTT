#===========================================================================
	# ■ Window_Consult2
	#---------------------------------------------------------------------------
	#     本窗口用来显示怪物的装备信息
	#
#===========================================================================
class Window_Equip_Select < Window_Selectable 
	include Kernel
	# 推荐使用偶数并且大于28（一个图标的高度还大一点点）
	WLH = 32
	# NAMES --> 0~13
	NAMES = ["武器1","武器2","头部","颈部","盾","衣服","戒指","鞋子","宝物1","宝物2","宝物3","宝物4","宝物5","宝物6"]
	attr_accessor   :index
	attr_accessor   :type
	#--------------------------------------------------------------------------
		# ● 初始化对象
		#     x     : 窗口的 X 坐标
		#     y     : 窗口的 Y 坐标
		#     actor : 角色
	#--------------------------------------------------------------------------
	def initialize(x, y, actor)
		super(x, y, 480, WLH * 14 + 36)
		self.opacity = 0
		@actor = actor
		self.contents.font.size = 28
		self.contents.font.name = "华文细黑"
		@edge = 0
		refresh
		@index = 0
	end
	#--------------------------------------------------------------------------
	# ● 获取项目要描画的矩形
	#     index : 项目编号
	#--------------------------------------------------------------------------
	def item_rect(index)
		rect = Rect.new(0, 0, 0, 0)
		rect.width = (contents.width + @spacing) / @column_max - @spacing
		rect.height = WLH
		rect.x = index % @column_max * (rect.width + @spacing)
		rect.y = index / @column_max * WLH
		return rect
	end
	#--------------------------------------------------------------------------
	# ● 获取物品
	#--------------------------------------------------------------------------
	def item
		return @data[self.index]
	end
	#--------------------------------------------------------------------------
	# ● 获取可用宝物最大槽位
	#--------------------------------------------------------------------------
	def max_weapon_index
		return @actor.weapon_num-1
	end
	#--------------------------------------------------------------------------
	# ● 获取可用宝物最大槽位
	#--------------------------------------------------------------------------
	def max_trea_index
		return @data.size-1-(6-@actor.trea_num)
	end
	#--------------------------------------------------------------------------
	# ● 刷新
	#--------------------------------------------------------------------------
	def refresh
		self.contents.clear
		@data = []
		
		for item in @actor.equips(false) do @data.push(item) end
		
		@item_max = @data.size
		
		# 画能够使用的武器槽位
		for i in 0...@actor.weapon_num
			self.contents.font.color = system_color
			self.contents.draw_text(4, WLH*i+@edge*i, 96, WLH, NAMES[i])
			draw_item_name(@data[i], 96, WLH*i+@edge*i)
		end
		# 画不能使用的武器槽位
		for i in @actor.weapon_num...2
			self.contents.font.color = getColor("gray")
			self.contents.draw_text(4, WLH*i+@edge*i, 96, WLH, NAMES[i])
			draw_item_name(@data[i], 96, WLH*i+@edge*i)
		end
		# 只绘画能够使用的宝物数量(6-@actor.trea_num)
		for i in 2...@data.size-(6-@actor.trea_num)
			self.contents.font.color = system_color
			self.contents.draw_text(4, WLH*i+@edge*i, 96, WLH, NAMES[i])
			draw_item_name(@data[i], 96, WLH*i+@edge*i)
		end
		for i in @data.size-(6-@actor.trea_num)...@data.size
			self.contents.font.color = getColor("gray")
			self.contents.draw_text(4, WLH*i+@edge*i, 96, WLH, NAMES[i])
			draw_item_name(@data[i], 96, WLH*i+@edge*i)
		end
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
			self.contents.draw_text(x+32, y, self.width-16-(x+32), WLH, item.name)
		end
	end
	
	#--------------------------------------------------------------------------
	# ● 描绘图标
	#
	#     重载父类中的函数
	#
	#     icon_index : 图标编号
	#     x          : 描绘目标 X 坐标
	#     y          : 描绘目标 Y 坐标
	#     enabled    : 有效标志。false 为半透明显示
	#--------------------------------------------------------------------------
	def draw_icon(icon_index, x, y, enabled = true)
		bitmap = Cache.system("Iconset")
		src_rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
		dst_rect = Rect.new(x, y+(WLH-28)/2, 28, 28)
		self.contents.stretch_blt(dst_rect, bitmap, src_rect, enabled ? 255 : 128)
		#self.contents.blt(x, y, bitmap, rect, enabled ? 255 : 128)
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
			text = temp[0]
			colors = temp[1]
		end
		@window_detail.set_text(text, 0, colors)
		# 设置位置
		@window_detail.x = self.x + self.width - 24
		@window_detail.y = 4
	end   
end