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
				"bitmap_width" 		=>	160,
				"bitmap_height" 	=> 	64,
				"font_name"			=>	"黑体",
				"font_size"			=>	24,
				"font_color"		=> 	Color.new(0,0,0),
				"text_x"			=> 	0,
				"text_y"			=> 	12,
				"text_width"		=> 	160,
				"text_height"		=> 	52,
				"text_align"		=> 	1,
				"movement" 			=> 	{
					75..80	=>	[0,-3],
					60..74	=> 	[0,-1],
				},
				"fade_out"			=>	{
					"base" 	=>	51,
					"speed"	=> 	5,
				}
			},
			# 暴击
			# type = 1
			1 => {},
			# 技能
			# type = 2
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
		bitmap = Bitmap.new(160, 64)
		# 设置字体
		bitmap.font.name = "黑体"#"Tahoma"#"Arial Black"
		# 设置字号
		bitmap.font.size = 24
		# 设置颜色为黑
		bitmap.font.color.set(0, 0, 0)
		# 判断是否暴击
		if type == 1
			bitmap.font.name = "Tahoma"
			bitmap.font.size = 28
			damage_string += "!!"
		end
		
		case type
			# 一般的
			when 0         
			# 绘制粗体效果
			# 这是函数签名：draw_text(x, y, width, height, str[, align])
			bitmap.draw_text(-1, 12-1, 160, 52, damage_string, 1)
			bitmap.draw_text(+1, 12-1, 160, 52, damage_string, 1)
			bitmap.draw_text(-1, 12+1, 160, 52, damage_string, 1)
			bitmap.draw_text(+1, 12+1, 160, 52, damage_string, 1)
			bitmap.font.color = color
			bitmap.draw_text(0, 12, 160, 52, damage_string, 1)
			# 暴击  
			when 1         
			bitmap.draw_text(-1, -1, 160, 52, damage_string, 1)
			bitmap.draw_text(+1, -1, 160, 52, damage_string, 1)
			bitmap.draw_text(-1, +1, 160, 52, damage_string, 1)
			bitmap.draw_text(+1, +1, 160, 52, damage_string, 1)
			bitmap.font.color = color
			bitmap.draw_text(0, 0, 160, 52, damage_string, 1)
		end
		
		# 将文字真正贴上去，并实现上浮效果
		@_damage_sprite1 = Sprite.new(self.viewport)
		@_damage_sprite1.bitmap = bitmap
		@_damage_sprite1.ox = bitmap.width / 2
		@_damage_sprite1.oy = bitmap.height / 2
		@_damage_sprite1.x = self.x + self.width / 2
		@_damage_sprite1.y = self.y
		@_damage_sprite1.z = 3000
		@_damage_sprite1.opacity = 0
		@_damage_sprite.push(@_damage_sprite1)
		@_damage_duration.push(80)
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
			
				# case @_damage_type[i]
				#伤害
				# when 0
					# @_damage_duration[i] -= 1
					# case @_damage_duration[i]
						# when 75..80               # 38 39 40
						# @_damage_sprite[i].y -= 3
						# when 60..74              # 36 37
						# @_damage_sprite[i].y -= 1
					# end
					#渐渐退去
					# @_damage_sprite[i].opacity = 256 - (51 - @_damage_duration[i])*5
				# 暴击
				# when 1
					# @_damage_duration[i] -= 1
					# 刚开始不可见
					# @_damage_sprite[i].opacity = 0
					# if @bom_x[i] > 0
						# @bom_x[i] = 1
					# elsif @bom_x[i] < 0
						# @bom_x[i] = -1
					# else
						# @bom_x[i] = rand(3) - 1
					# end
					
					# case @_damage_duration[i]
						# when 73..79                
						# @_damage_sprite[i].y -= 4
						# return
						# when 62..73               
						# @_damage_sprite[i].y -= 2
						# @_damage_sprite[i].x -= @bom_x[i] if @_damage_duration[i]%3 == 0
						# when 30..61
						# @_damage_sprite[i].y -= 1
						# @_damage_sprite[i].x -= @bom_x[i] if @_damage_duration[i]%4 == 0
						# when 0..30 
						# @_damage_sprite[i].y -= 1
						# @_damage_sprite[i].x -= @bom_x[i] if @_damage_duration[i]%2 == 0
					# end
					#渐渐退去
					# @_damage_sprite[i].opacity = 256 - (44 - @_damage_duration[i])*6
				# end
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









