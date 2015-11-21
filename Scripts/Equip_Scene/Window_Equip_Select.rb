#===========================================================================
	# ■ Window_Consult2
	#---------------------------------------------------------------------------
	#     本窗口用来显示怪物的装备信息
	#
#===========================================================================
class Window_Equip_Select < Window_Selectable 
	include Kernel
	WLH = 24
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
		super(x, y, 288, WLH * 14 + 36)
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
			self.contents.draw_text(4, WLH*i+@edge*i, 72, WLH, NAMES[i])
			draw_item_name(@data[i], 67, WLH*i+@edge*i)
		end
		# 画不能使用的武器槽位
		for i in @actor.weapon_num...2
			self.contents.font.color = getColor("gray")
			self.contents.draw_text(4, WLH*i+@edge*i, 72, WLH, NAMES[i])
			draw_item_name(@data[i], 67, WLH*i+@edge*i)
		end
		# 只绘画能够使用的宝物数量(6-@actor.trea_num)
		for i in 2...@data.size-(6-@actor.trea_num)
			self.contents.font.color = system_color
			self.contents.draw_text(4, WLH*i+@edge*i, 72, WLH, NAMES[i])
			draw_item_name(@data[i], 67, WLH*i+@edge*i)
		end
		for i in @data.size-(6-@actor.trea_num)...@data.size
			self.contents.font.color = getColor("gray")
			self.contents.draw_text(4, WLH*i+@edge*i, 72, WLH, NAMES[i])
			draw_item_name(@data[i], 67, WLH*i+@edge*i)
		end

		# self.contents.draw_text(4, WLH * 0,       72, WLH, "武器1")
		# self.contents.draw_text(4, WLH * 1+@edge*1, 72, WLH, "武器2")
		# self.contents.draw_text(4, WLH * 2+@edge*2, 72, WLH, "头部")
		# self.contents.draw_text(4, WLH * 3+@edge*3, 72, WLH, "颈部")
		# self.contents.draw_text(4, WLH * 4+@edge*4, 72, WLH, "盾")
		# self.contents.draw_text(4, WLH * 5+@edge*5, 72, WLH, "衣服")
		# self.contents.draw_text(4, WLH * 6+@edge*6, 72, WLH, "戒指")
		# self.contents.draw_text(4, WLH * 7+@edge*7, 72, WLH, "鞋子")
		# self.contents.draw_text(4, WLH * 8+@edge*8, 72, WLH, "宝物1")
		# self.contents.draw_text(4, WLH * 9+@edge*9, 72, WLH, "宝物2")
		# self.contents.draw_text(4, WLH * 10+@edge*10, 72, WLH, "宝物3")
		# self.contents.draw_text(4, WLH * 11+@edge*11, 72, WLH, "宝物4")
		
		
		# draw_item_name(@data[0], 67, WLH * 0)
		# draw_item_name(@data[1], 67, WLH * 1+@edge*1)
		# draw_item_name(@data[2], 67, WLH * 2+@edge*2)
		# draw_item_name(@data[3], 67, WLH * 3+@edge*3)
		# draw_item_name(@data[4], 67, WLH * 4+@edge*4)
		# draw_item_name(@data[5], 67, WLH * 5+@edge*5)
		# draw_item_name(@data[6], 67, WLH * 6+@edge*6)
		# draw_item_name(@data[7], 67, WLH * 7+@edge*7)
		# draw_item_name(@data[8], 67, WLH * 8+@edge*8)
		# draw_item_name(@data[9], 67, WLH * 9+@edge*9)
		# draw_item_name(@data[10], 67, WLH * 10+@edge*10)
		# draw_item_name(@data[11], 67, WLH * 11+@edge*11)
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
			self.contents.draw_text(x + 24, y, 157+16, WLH, item.name)
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
		@window_detail.x = self.x + self.width - 24
		@window_detail.y = 4
	end   
end