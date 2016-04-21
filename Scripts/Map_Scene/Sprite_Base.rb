#==============================================================================
# ■ Sprite_Base
#------------------------------------------------------------------------------
# 　添加显示动画处理的活动块类。
#==============================================================================
class Sprite_Base < Sprite
	#--------------------------------------------------------------------------
	# ● 初始化对象
	#
	#       重定义
	#
	#     viewport : 视区
	#--------------------------------------------------------------------------
	def initialize(viewport = nil)
		super(viewport) 
		@use_sprite = true           # 活动块使用的标志
		@animation_duration = 0      # 
		@_damage_duration = []       # 记录每一个动画的剩余时间
		@_damage_sprite = []         # 记录每一个动画
		@_damage_type = []           # 记录伤害类型，不同类型有不同显示方式
		@bom_x = []                  # 记录暴击的初试倾向
		# 如果需要支持新的显示效果，在这里添加
		@style = {
			# 普通字体
			# type = 0
			0 => {
				# 位图宽度，-32为实际显示宽度
				"bitmap_width" 		=>	160,
				# 位图高度，-32为实际显示高度
				"bitmap_height" 	=> 	64,
				# 位图x方向上的位置调整
				"sprite_x"			=> 	0,
				# 位图y方向上的位置调整
				"sprite_y"			=>	0,
				# 位图z方向上的位置调整,越大显示在越前面
				"sprite_z"			=>	2000,
				# 显示字体
				"font_name"			=>	"黑体",
				# 字体大小
				"font_size"			=>	24,
				# 底字体颜色，推荐黑色
				"font_color"		=> 	Color.new(0,0,0),
				# 字体显示框在位图中的相对位置x分量
				"text_x"			=> 	0,
				# 字体显示框在位图中的相对位置y分量 
				"text_y"			=> 	12,
				# 字体显示框宽度-推荐和位图一样宽
				"text_width"		=> 	160,
				# 字体显示框高度-推荐比位图小一些
				"text_height"		=> 	52,
				# 字体对齐方式，0-左对齐，1-居中，2-右对齐
				"text_align"		=> 	1,
				# 显示多少帧
				"duration"			=> 	80,
				# 每一帧在[x,y]上的移动量
				"movement" 			=> 	{
					75..80	=>	[0,-3],
					60..74	=> 	[0,-1],
				},
				# 消失效果
				"fade_out"			=>	{
					# 越大消失出现得越明显
					"base" 	=>	51,
					# 越大消失越快
					"speed"	=> 	5,
				}
			},
			# 暴击
			1 => {
				"bitmap_width" 		=>	240,
				"bitmap_height" 	=> 	96,
				"sprite_x"			=> 	0,
				"sprite_y"			=> 	-16,
				"sprite_z"			=>	2001,
				"font_name"			=>	"Tahoma",
				"font_size"			=>	28,
				"font_color"		=> 	Color.new(0,0,0),
				"text_x"			=> 	0,
				"text_y"			=> 	12,
				"text_width"		=> 	240,
				"text_height"		=> 	78,
				"text_align"		=> 	1,
				"duration"			=> 	Graphics.frame_rate,
				"movement" 			=> 	{
					[Graphics.frame_rate   , Graphics.frame_rate-2 , Graphics.frame_rate-4 ,
					 Graphics.frame_rate-6 , Graphics.frame_rate-8 , Graphics.frame_rate-10,
					 Graphics.frame_rate-12, Graphics.frame_rate-14, Graphics.frame_rate-16,
					 Graphics.frame_rate-18, Graphics.frame_rate-20, Graphics.frame_rate-22,
					 Graphics.frame_rate-22, Graphics.frame_rate-26, Graphics.frame_rate-28,
					 Graphics.frame_rate-30, Graphics.frame_rate-32, Graphics.frame_rate-34,
					 Graphics.frame_rate-36, Graphics.frame_rate-38, Graphics.frame_rate-40,]	=>	[0,-1],
				},
				"fade_out"			=>	{
					"base" 	=>	44,
					"speed"	=> 	6,
				}
			},
			# 技能
			2 => {}
		}
	end 
	#--------------------------------------------------------------------------
	# ● 更新画面
	#--------------------------------------------------------------------------
	def update
		super
		# 更新主动画
		if @animation != nil
			# 每次向前推进一帧的时间
			@animation_duration -= 1
			# 没四帧更新一次动画（动画向前推进一帧）
			if @animation_duration % 4 == 0
				update_animation
			end
		end
		@@animations.clear
		# 更新对话动画
		update_damage
	end
	#--------------------------------------------------------------------------
	# ● 释放
	#
	#      重定义
	#
	#--------------------------------------------------------------------------
	def dispose
		super
		dispose_animation
		dispose_damages
	end
	#--------------------------------------------------------------------------
	# ● 显示文字（移植自RPG Maker XP）
	#	参考damage，多了些参数
	#
	#     value        : 	需要显示的值 
	#     color	       : 	显示的颜色
	#     type         : 	0是正常，
	# 						1是暴击，
	# 						2是技能名称，还可以是其他，留作后面扩展
	#
	#--------------------------------------------------------------------------
	def set_talk_text(value, color, type = 0)
		# 判断是否有过时的消息
		if @_damage_duration.size >0 
			# 只需要判断第一个是否过期，如果第一个不过期那么后面不可能有过期的
			if @_damage_duration[0] <= 0
				#删除所有<=0的元素
				refresh_durations
			end
		end
		# 如果没有过期，或者数组是新的，那么继续
		# 修改类型
		if value.is_a?(Numeric)
			damage_string = value.abs.to_s
		else
			damage_string = value.to_s
		end
		# 新建一个画布，宽160高64
		bitmap = Bitmap.new(@style[type]["bitmap_width"], @style[type]["bitmap_height"])
		# 设置字体
		bitmap.font.name = @style[type]["font_name"]
		# 设置字号
		bitmap.font.size = @style[type]["font_size"]
		# 设置颜色为黑
		bitmap.font.color.set(0, 0, 0)
		
		bitmap.draw_text(@style[type]["text_x"]-1, @style[type]["text_y"]-1, @style[type]["text_width"], @style[type]["text_height"], damage_string, @style[type]["text_align"])
		bitmap.draw_text(@style[type]["text_x"]+1, @style[type]["text_y"]-1, @style[type]["text_width"], @style[type]["text_height"], damage_string, @style[type]["text_align"])
		bitmap.draw_text(@style[type]["text_x"]-1, @style[type]["text_y"]+1, @style[type]["text_width"], @style[type]["text_height"], damage_string, @style[type]["text_align"])
		bitmap.draw_text(@style[type]["text_x"]+1, @style[type]["text_y"]+1, @style[type]["text_width"], @style[type]["text_height"], damage_string, @style[type]["text_align"])
		bitmap.font.color = color
		bitmap.draw_text(@style[type]["text_x"], @style[type]["text_y"], @style[type]["text_width"], @style[type]["text_height"], damage_string, @style[type]["text_align"])
		
		# 将文字真正贴上去，并实现上浮效果
		@_damage_sprite1 = Sprite.new(self.viewport)
		@_damage_sprite1.bitmap = bitmap
		@_damage_sprite1.ox = bitmap.width / 2
		@_damage_sprite1.oy = bitmap.height / 2
		@_damage_sprite1.x = self.x + self.width / 2 + @style[type]["sprite_x"]
		@_damage_sprite1.y = self.y + @style[type]["sprite_y"]
		@_damage_sprite1.z = @style[type]["sprite_z"]
		@_damage_sprite1.opacity = 0
		@_damage_sprite.push(@_damage_sprite1)
		@_damage_duration.push(@style[type]["duration"])
		@_damage_type.push(type)
		@bom_x.push(0)
	end
	#--------------------------------------------------------------------------
	# ● 更新文字
	#
	#        显示文字的又一核心函数
	#
	#           重定义
	#        
	#
	#--------------------------------------------------------------------------
	def update_damage
		if 0 == @_damage_duration.size
			return
		end
		# 否则所有的精灵都要平移一个距离
		for i in 0...@_damage_type.size
			# 对应的伤害精灵剩余时间>0则继续更新
			if @_damage_duration[i] > 0
				@_damage_duration[i] -= 1
				for key in @style[@_damage_type[i]]["movement"].keys
					if key.include?(@_damage_duration[i])
						@_damage_sprite[i].x += @style[@_damage_type[i]]["movement"][key][0]
						@_damage_sprite[i].y += @style[@_damage_type[i]]["movement"][key][1]
					end
				end
				@_damage_sprite[i].opacity = 256 - (@style[@_damage_type[i]]["fade_out"]["base"] - @_damage_duration[i])*@style[@_damage_type[i]]["fade_out"]["speed"]
			end
		end
		refresh_durations
	end
	#--------------------------------------------------------------------------
	# ● 递归调用删除所有<0的元素
	#	此函数总是删除第一个遇到的 <=0 的元素
	#   递归调用，直到没有元素被删除。
	#--------------------------------------------------------------------------
	def refresh_durations
		flag = false
		for i in 0...@_damage_duration.size
			if @_damage_duration[i] <= 0
				flag = true
				# 删除当前找到的<0的元素，设置标志位
				dispose_damage(i)
				break
			end
		end
		# 如果没有需要删除的，则直接返回
		if flag == false
			return
		# 否则递归调用，继续删除剩余的数组中所有<0的元素
		else
			refresh_durations
		end
	end
	#--------------------------------------------------------------------------
	# ● 释放文字
	#
	#     重定义
	#
	#--------------------------------------------------------------------------
	def dispose_damage(i)
		if @_damage_sprite[i] != nil
			@_damage_sprite[i].bitmap.dispose
			@_damage_sprite[i].dispose
			@_damage_sprite.delete_at(i)
			@_damage_duration.delete_at(i)
			@_damage_type.delete_at(i)
			@bom_x.delete_at(i)
		end
	end
	#--------------------------------------------------------------------------
	# ● 释放所有文字
	#
	#    重定义
	#
	#--------------------------------------------------------------------------
	def dispose_damages
		if @_damage_sprite.size > 0
			for i in 0...@_damage_sprite.size
				# 连续删除第一个
				dispose_damage(0)
			end
		end
	end
end









