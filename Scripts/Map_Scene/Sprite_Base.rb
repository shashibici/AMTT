#==============================================================================
# ■ Sprite_Base
#------------------------------------------------------------------------------
# 　添加显示动画处理的活动块类。
#==============================================================================
class Sprite_Base < Sprite
	#--------------------------------------------------------------------------
	# ● 类变量
	#--------------------------------------------------------------------------
	@@animations = []
	@@_reference_count = {}
	attr_accessor		:animation_counter		# 记录同时有多少个动画在播放
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
		@animation = {}					# 记录一个动画对象
		@animation_duration = {}		# 记录动画剩余时间
		@animation_mirror = {}			# value是bool值，记录动画是否镜像
		@animation_sprites = {}			# value是一个数组，记录动画的所有sprites
		@animation_ox = {}				# value是一个实数，记录动画相对位置
		@animation_oy = {}				# value是一个实数，记录动画相对位置
		@animation_bitmap1 = {}			# value是一个bitmap对象，记录动画引用的bitmap
		@animation_bitmap2 = {}			# value是一个bitmap对象，记录动画引用的bitmap
		@animation_counter = 0			# 累加器，用作动画的key
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
		for i in @animation.keys
			if @animation[i] != nil
				# 每次向前推进一帧的时间
				@animation_duration[i] -= 1
				# 没四帧更新一次动画（动画向前推进一帧）
				if @animation_duration[i] % 4 == 0
					update_animation(i)
				end
			end
		end
		@@animations.clear
		# 更新对话动画
		update_damage
	end
	#--------------------------------------------------------------------------
	# ● 判断动画是否正在显示
	#--------------------------------------------------------------------------
	def animation?
		for i in @animation.keys
			if @animation[i] != nil 
				return true
			end
		end
		return false
	end
	#--------------------------------------------------------------------------
	# ● 开始播放动画
	#--------------------------------------------------------------------------
	def start_animation(animation, mirror = false)
		# dispose_animation
		if nil == animation
			return 
		end
		@animation_counter += 1
		@animation[@animation_counter] = animation
		@animation_mirror[@animation_counter] = mirror
		@animation_duration[@animation_counter] = @animation[@animation_counter].frame_max * 4 + 1
		load_animation_bitmap
		@animation_sprites[@animation_counter] = []
		if @animation[@animation_counter].position != 3 or not @@animations.include?(animation)
			if @use_sprite
				for i in 0..15
					sprite = ::Sprite.new(viewport)
					sprite.visible = false
					@animation_sprites[@animation_counter].push(sprite)
				end
				unless @@animations.include?(animation)
					@@animations.push(animation)
				end
			end
		end
		if @animation[@animation_counter].position == 3
			if viewport == nil
				# 修改过
				@animation_ox[@animation_counter] = Graphics.width / 2
				@animation_oy[@animation_counter] = Graphics.height / 2
			else
				@animation_ox[@animation_counter] = viewport.rect.width / 2
				@animation_oy[@animation_counter] = viewport.rect.height / 2
			end
		else
			@animation_ox[@animation_counter] = x - ox + width / 2
			@animation_oy[@animation_counter] = y - oy + height / 2
			if @animation[@animation_counter].position == 0
				@animation_oy[@animation_counter] -= height / 2
			elsif @animation[@animation_counter].position == 2
				@animation_oy[@animation_counter] += height / 2
			end
		end
	end
	#--------------------------------------------------------------------------
	# ● 读取动画图像
	#--------------------------------------------------------------------------
	def load_animation_bitmap
		animation1_name = @animation[@animation_counter].animation1_name
		animation1_hue = @animation[@animation_counter].animation1_hue
		animation2_name = @animation[@animation_counter].animation2_name
		animation2_hue = @animation[@animation_counter].animation2_hue
		@animation_bitmap1[@animation_counter] = Cache.animation(animation1_name, animation1_hue)
		@animation_bitmap2[@animation_counter] = Cache.animation(animation2_name, animation2_hue)
		if @@_reference_count.include?(@animation_bitmap1[@animation_counter])
			@@_reference_count[@animation_bitmap1[@animation_counter]] += 1
		else
			@@_reference_count[@animation_bitmap1[@animation_counter]] = 1
		end
		if @@_reference_count.include?(@animation_bitmap2[@animation_counter])
			@@_reference_count[@animation_bitmap2[@animation_counter]] += 1
		else
			@@_reference_count[@animation_bitmap2[@animation_counter]] = 1
		end
		Graphics.frame_reset
	end
	#--------------------------------------------------------------------------
	# ● 释放动画
	#--------------------------------------------------------------------------
	def dispose_animation(key)
		if @animation_bitmap1[key] != nil
			@@_reference_count[@animation_bitmap1[key]] -= 1
			if @@_reference_count[@animation_bitmap1[key]] == 0
				@animation_bitmap1[key].dispose
			end
		end
		if @animation_bitmap2[key] != nil
			@@_reference_count[@animation_bitmap2[key]] -= 1
			if @@_reference_count[@animation_bitmap2[key]] == 0
				@animation_bitmap2[key].dispose
			end
		end
		if @animation_sprites[key] != nil
			for sprite in @animation_sprites[key]
				sprite.dispose
			end
			@animation_sprites.delete(key)
			@animation.delete(key)
			@animation_duration.delete(key)
			@animation_mirror.delete(key)
			@animation_ox.delete(key)
			@animation_oy.delete(key)
		end
	end
	#--------------------------------------------------------------------------
	# ● 更新动画
	#--------------------------------------------------------------------------
	def update_animation(key)
		if @animation_duration[key] > 0
			frame_index = @animation[key].frame_max - (@animation_duration[key] + 3) / 4
			animation_set_sprites(@animation[key].frames[frame_index], key)
			for timing in @animation[key].timings
				if timing.frame == frame_index
					animation_process_timing(timing)
				end
			end
		else
			dispose_animation(key)
		end
	end
	#--------------------------------------------------------------------------
	# ● 设置动画活动块
	#     frame : 画面数据 (RPG::Animation::Frame)
	#--------------------------------------------------------------------------
	def animation_set_sprites(frame, key)
		cell_data = frame.cell_data
		for i in 0..15
			sprite = @animation_sprites[key][i]
			next if sprite == nil
			pattern = cell_data[i, 0]
			if pattern == nil or pattern == -1
				sprite.visible = false
				next
			end
			if pattern < 100
				sprite.bitmap = @animation_bitmap1[key]
			else
				sprite.bitmap = @animation_bitmap2[key]
			end
			sprite.visible = true
			sprite.src_rect.set(pattern % 5 * 192,
			pattern % 100 / 5 * 192, 192, 192)
			if @animation_mirror[key]
				sprite.x = @animation_ox[key] - cell_data[i, 1]
				sprite.y = @animation_oy[key] - cell_data[i, 2]
				sprite.angle = (360 - cell_data[i, 4])
				sprite.mirror = (cell_data[i, 5] == 0)
			else
				sprite.x = @animation_ox[key] + cell_data[i, 1]
				sprite.y = @animation_oy[key] + cell_data[i, 2]
				sprite.angle = cell_data[i, 4]
				sprite.mirror = (cell_data[i, 5] == 1)
			end
			sprite.z = self.z + 300
			sprite.ox = 96
			sprite.oy = 96
			sprite.zoom_x = cell_data[i, 3] / 100.0
			sprite.zoom_y = cell_data[i, 3] / 100.0
			sprite.opacity = cell_data[i, 6] * self.opacity / 255.0
			sprite.blend_type = cell_data[i, 7]
		end
	end
	#--------------------------------------------------------------------------
	# ● SE 与闪烁时间处理
	#     timing : 时间数据 (RPG::Animation::Timing)
	#--------------------------------------------------------------------------
	def animation_process_timing(timing)
		timing.se.play
		case timing.flash_scope
		when 1
			self.flash(timing.flash_color, timing.flash_duration * 4)
		when 2
			if viewport != nil
				viewport.flash(timing.flash_color, timing.flash_duration * 4)
			end
		when 3
			self.flash(nil, timing.flash_duration * 4)
		end
	end
	#--------------------------------------------------------------------------
	# ● 释放
	#
	#      重定义
	#
	#--------------------------------------------------------------------------
	def dispose
		super
		for key in @animation.keys
			dispose_animation(key)
		end
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

