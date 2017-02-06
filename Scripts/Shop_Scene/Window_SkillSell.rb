#==============================================================================
# ■ Window_SkillSell
#------------------------------------------------------------------------------
#		重新定义覆盖之前定义
#
# 　拥有光标的移动以及滚动功能的窗口类。
#==============================================================================

class Window_SkillSell < Window_Base
	#--------------------------------------------------------------------------
	# ● 定义实例变量
	#--------------------------------------------------------------------------
	attr_reader   		:skill_max                 		# 项目数
	attr_reader   		:column_max               		# 行数
	attr_reader   		:index                    		# 光标位置
	attr_accessor		:wlh							# 每个项目高度
	attr_accessor		:actor							# 需要买技能的角色
	#--------------------------------------------------------------------------
	# ● 初始化对象
	#     x       : 窗口的 X 坐标
	#     y       : 窗口的 Y 坐标
	#     width   : 窗口的宽
	#     height  : 窗口的高
	#     spacing : 与项目横向并立的空间
	#--------------------------------------------------------------------------
	def initialize(x, y, width, height, actor)
		@column_max = 1
		@index = 0
		@spacing = 32
		@wlh = 90
		@actor = actor
		@skills = @actor.get_skills
		@skill_max = @skills.size
		super(x, y, width, height)
		refresh
	end
	#--------------------------------------------------------------------------
	# ● 刷新窗口内容
	#--------------------------------------------------------------------------
	def refresh
		refresh_skill_items
	end
	#--------------------------------------------------------------------------
	# ● 生成窗口内容
	#--------------------------------------------------------------------------
	def create_contents
		self.contents.dispose
		self.contents = Bitmap.new(width - 32, [height - 32, row_max * @wlh].max)
	end
	#--------------------------------------------------------------------------
	# ● 设置光标位置
	#     index : 新的光标位置
	#--------------------------------------------------------------------------
	def index=(index)
		@index = index
		update_cursor
	end
	#--------------------------------------------------------------------------
	# ● 获取行数
	#
	#   总行数
	#--------------------------------------------------------------------------
	def row_max
		return (@skill_max + @column_max - 1) / @column_max
	end
	#--------------------------------------------------------------------------
	# ● 获取行头
	#
	#    本页第第一行的行数（从第0行开始计数）
	#
	#--------------------------------------------------------------------------
	def top_row
		return self.oy / @wlh
	end
	#--------------------------------------------------------------------------
	# ● 设置本页的第一行
	#     row : 需要显示为本页第一行的那个行（从0行计数）
	#
	#    例如：row=5 则直接将本页跳转至以第五行为首的那一页试图上。
	#
	#--------------------------------------------------------------------------
	def top_row=(row)
		row = 0 if row < 0
		row = row_max - 1 if row > row_max - 1
		self.oy = row * @wlh
	end
	#--------------------------------------------------------------------------
	# ● 获取一页显示的行数
	#--------------------------------------------------------------------------
	def page_row_max
		return (self.height - 32) / @wlh
	end
	#--------------------------------------------------------------------------
	# ● 获取一页显示的项目数
	#--------------------------------------------------------------------------
	def page_item_max
		return page_row_max * @column_max
	end
	#--------------------------------------------------------------------------
	# ● 获取末尾行数
	#--------------------------------------------------------------------------
	def bottom_row
		return top_row + page_row_max - 1
	end
	#--------------------------------------------------------------------------
	# ● 设置末行
	#     row : 末尾显示的行
	#
	#      本质上是通过设置首行来实现的
	#
	#--------------------------------------------------------------------------
	def bottom_row=(row)
		self.top_row = row - (page_row_max - 1)
	end
	#--------------------------------------------------------------------------
	# ● 获取项目要描画的矩形
	#     index : 项目编号
	#--------------------------------------------------------------------------
	def item_rect(index)
		rect = Rect.new(0, 0, 0, 0)
		rect.width = (contents.width + @spacing) / @column_max - @spacing
		rect.height = @wlh
		rect.x = index % @column_max * (rect.width + @spacing)
		rect.y = index / @column_max * @wlh
		return rect
	end
	#--------------------------------------------------------------------------
	# ● 是否可以移动光标
	#--------------------------------------------------------------------------
	def cursor_movable?
		return false if (not visible or not active)
		return false if (index < 0 or index > @skill_max or @skill_max == 0)
		return false if (@opening or @closing)
		return true
	end
	#--------------------------------------------------------------------------
	# ● 光标向下移动
	#     wrap : 允许跳过
	#--------------------------------------------------------------------------
	def cursor_down(wrap = false)
		if (@index < @skill_max - @column_max) or (wrap and @column_max == 1)
			@index = (@index + @column_max) % @skill_max
		end
	end
	#--------------------------------------------------------------------------
	# ● 光标向上移动
	#     wrap : 允许跳过
	#--------------------------------------------------------------------------
	def cursor_up(wrap = false)
		if (@index >= @column_max) or (wrap and @column_max == 1)
			@index = (@index - @column_max + @skill_max) % @skill_max
		end
	end
	#--------------------------------------------------------------------------
	# ● 光标向右移动
	#     wrap : 允许跳过
	#--------------------------------------------------------------------------
	def cursor_right(wrap = false)
		if (@column_max >= 2) and (@index < @skill_max - 1 or (wrap and page_row_max == 1))
			@index = (@index + 1) % @skill_max
		end
	end
	#--------------------------------------------------------------------------
	# ● 光标向左移动
	#     wrap : 允许跳过
	#--------------------------------------------------------------------------
	def cursor_left(wrap = false)
		if (@column_max >= 2) and (@index > 0 or (wrap and page_row_max == 1))
			@index = (@index - 1 + @skill_max) % @skill_max
		end
	end
	#--------------------------------------------------------------------------
	# ● 光标向后一页移动
	#--------------------------------------------------------------------------
	def cursor_pagedown
		if top_row + page_row_max < row_max
			@index = [@index + page_item_max, @skill_max - 1].min
			self.top_row += page_row_max
		end
	end
	#--------------------------------------------------------------------------
	# ● 光标向前一页移动
	#--------------------------------------------------------------------------
	def cursor_pageup
		if top_row > 0
			@index = [@index - page_item_max, 0].max
			self.top_row -= page_row_max
		end
	end
	#--------------------------------------------------------------------------
	# ● 刷新画面
	#--------------------------------------------------------------------------
	def update
		super
		if cursor_movable?
			last_index = @index
			if Input.trigger?(Input::DOWN)
				cursor_down(false)
			end
			if Input.trigger?(Input::UP)
				cursor_up(false)
			end
			if @index != last_index
				Sound.play_cursor
			end
		end
		update_cursor
	end
	#--------------------------------------------------------------------------
	# ● 更新光标
	#--------------------------------------------------------------------------
	def update_cursor
		if @index < 0                   		# 光标的位置不满 0 的情况下
			self.cursor_rect.empty        		# 光标无效
		else                            		# 光标的位置为 0 以上的情况下
			row = @index / @column_max    		# 获取现在的行数
			if row < top_row              		# 如果显示的行在最顶行之前
				self.top_row = row          	# 则将最顶行向现在行滚动
			end
			if row > bottom_row           		# 如果显示的行在末尾行之后
				self.bottom_row = row       	# 则将末尾行向现在行滚动
			end
			rect = item_rect(@index)      		# 获取被选择项目的矩形
			rect.y -= self.oy             		# 如果矩形与滚动位置重合
			self.cursor_rect = rect       		# 则更新光标
		end	
	end
	#--------------------------------------------------------------------------
	# ● 刷新所有技能的显示 -- 重绘技能
	#--------------------------------------------------------------------------
	def refresh_skill_items
		@skills = @actor.get_skills
		@skill_max = @skills.size
		create_contents
		# ... 绘制所有项目 ...
		for i in 0...@skill_max
			draw_item(i)
		end
	end
	#--------------------------------------------------------------------------
	# ● 描绘项目
	#     index : 项目编号
	#--------------------------------------------------------------------------
	def draw_item(index)
		rect = item_rect(index)
		#self.contents.clear_rect(rect)
		item = @skills[index]
		if item != nil
			draw_icon(item.name, rect.x+3, rect.y+3, 64+3, 64+3, true)
			draw_item_name(item.name, rect.x+3, rect.y+64+3, 64+3+3, @wlh-64-3, 1)
		end
	end
	#--------------------------------------------------------------------------
	# ● 描绘技能图标 - 在一个小矩形中描绘
	#     icon_name		: 图片名字
	#     x          	: 描绘目标 X 坐标
	#     y          	: 描绘目标 Y 坐标
	# 	  width			: 描绘目标宽度
	# 	  height		: 描绘目标高度
	#     enabled    	: 有效标志。false 为半透明显示
	#--------------------------------------------------------------------------
	def draw_icon(icon_name, x, y, width, height, enabled = true)
		folder_name = "Graphics/System/"
		bitmap = FrameFactory.getBitmapWithSize(width, height, folder_name, icon_name)
		self.contents.blt(x, y, bitmap, bitmap.rect, enabled ? 255 : 128)
	end
	#--------------------------------------------------------------------------
	# ● 描绘技能名字 - 在一个小矩形中描绘
	#     item_name		: 技能名字
	#     x          	: 描绘目标 X 坐标
	#     y          	: 描绘目标 Y 坐标
	# 	  width			: 描绘目标宽度
	# 	  height		: 描绘目标高度
	#     enabled    	: 有效标志。false 为半透明显示
	#--------------------------------------------------------------------------
	def draw_item_name(item_name, x, y, width, height, align = 1)
		self.contents.draw_text(x, y, width, height, item_name, align)
	end
	#--------------------------------------------------------------------------
	# ● 返回当前光标所在的技能对象
	#--------------------------------------------------------------------------
	def skill
		return @skills[@index]
	end
	#--------------------------------------------------------------------------
	# ● 生成窗口内容
	#--------------------------------------------------------------------------
	def create_contents
		self.contents.dispose
		self.contents = Bitmap.new(width - 32, [height - 32, row_max * @wlh].max)
	end
end
