#load_script("Scripts/Map_Scene/Window_BattlePanel.rb")
##==========================================================================
# ■ Window_BattleBack
#---------------------------------------------------------------------------
#   This window sits as a background of battle field.
#   Size: 640*480
#===========================================================================
class Window_BattleBack < Window_Base
	def initialize(x, y, h, w)
		super(x, y, h, w)
		self.contents.fill_rect(self.contents.width/2-1, 80, 3, self.contents.height-160, Color.new(255, 255, 255))
	end
end

##==========================================================================
# ■ Window_Animated
#---------------------------------------------------------------------------
#  Animated window is an abstraction of windows that can 
#  move itself.
#  This kind of windows consumes more CPU, but they provide users
#  a better experience of display.
#
#===========================================================================
class Window_Animated < Window_Base
	attr_accessor 	:final_x 			# X 最终位置
	attr_accessor 	:final_y 			# Y 最终位置
	attr_accessor 	:dx				
	attr_accessor 	:dy
	attr_accessor 	:init_x 			# X 初始位置
	attr_accessor 	:init_y 			# Y 初始位置
	attr_accessor 	:xmoving 			# X 方向是否还在移动
	attr_accessor 	:ymoving			# Y 方向是否还在移动

	#--------------------------------------------------------------------------
	# ● 初始化对象
	#
	# 	x 	: 	final place of X
	# 	y 	: 	final place of Y
	# 	dx 	: 	speed of X (0~1)
	# 	dy 	: 	speed of Y (0~1)
	# 	h	: 	height of the window
	# 	w	: 	width of the window
	#   xi	: 	initial position of X
	#   yi	:	initial position of Y
	#--------------------------------------------------------------------------
	def initialize(x,y,h,w,xi=0,yi=0,dx=0,dy=0)
		super(xi, yi, h, w)
		@final_x = x
		@final_y = y
		@init_x = xi
		@init_y = yi
		@dx = dx
		@dy = dy
		@appearing = false
		@disappearing = false
		@xmoving = false
		@ymoving = false
	end
	#--------------------------------------------------------------------------
	# ● 更新画面
	#--------------------------------------------------------------------------
	def update
		super
		if self.visible == true and self.active == true
			if self.x != @final_x
				@xmoving = true
				oldX = self.x
				delta = @final_x - @init_x
				if delta > 0
					self.x += (delta + (self.x - @init_x).abs**1.4) * @dx
				elsif delta < 0
					self.x += (delta - (self.x - @init_x).abs**1.4) * @dx
				end
				if (@final_x - self.x) * (@final_x - oldX) < 0
					self.x = @final_x
					@xmoving = false
				end
			end
			if self.y != @final_y
				@ymoving = true
				oldY = self.y
				delta = @final_y - @init_y
				if delta > 0
					self.y += (delta + (self.y - @init_y).abs**1.4) * @dy
				elsif delta < 0
					self.y += (delta - (self.y - @init_y).abs**1.4) * @dy
				end
				if (@final_y - self.y) * (@final_y - oldY) < 0
					self.y = @final_y
					@ymoving = false
				end
			end
		end

	end

end

##==========================================================================
# ■ Window_BattleStatusEnemy
#---------------------------------------------------------------------------
# 	Display the status of enemy.  
#   Display HP.
# 	Display the name and show the face.
#===========================================================================
class Window_BattleStatusEnemy < Window_Animated
	#--------------------------------------------------------------------------
	# ● 初始化对象
	#--------------------------------------------------------------------------
	def initialize(x=20,y=-8,w=600,h=64+32,xi=20,yi=-(64+32),dx=0,dy=0.04)
		super(x,y,w,h,xi,yi,dx,dy)
		@ymoving = true
		@wlh = 20
		@still_timer = 0
	end
	#--------------------------------------------------------------------------
	# ● 设置显示参数
	#--------------------------------------------------------------------------
	def setup(m)
		@monster = m
		@new_values = [
			@maxhp = @monster.maxhp,
			@hp = @monster.hp,
			@name = @monster.name,
			@face_name = @monster.character_name,
		]
		refresh
	end
	#--------------------------------------------------------------------------
	# ● 是否需要刷新
	#--------------------------------------------------------------------------
	def need_refresh?
		if @maxhp != @monster.maxhp
			return true
		end
		if @hp != @monster.hp
			return true
		end
		if @name != @monster.name
			return true
		end
		if @face_name != @monster.character_name
			return true
		end
	end
	#--------------------------------------------------------------------------
	# ● 刷新画面
	#--------------------------------------------------------------------------
	def refresh
		self.contents.clear
		@new_values = [
			@maxhp = @monster.maxhp,
			@hp = @monster.hp,
			@name = @monster.name,
			@face_name = @monster.character_name,
		]
		# 绘制头像
		@face_bitmap = FrameFactory.getBitmapWithSize(40,40,"Graphics/Battlers/", @face_name, 0)
		rect = Rect.new(0, 0, @face_bitmap.width, @face_bitmap.height)
		self.contents.blt(12, 12, @face_bitmap, rect)
		# 绘制名字
		color = Color.new(255, 255, 255)
		draw_a_line(color, 64, self.contents.height-@wlh, 200, @wlh, @name, 0)
		# 绘制HP槽
		rate = @hp / @maxhp
		gw = Integer((self.contents.width-(64+16)) * rate)
		if rate < 0.5
			gc1 = Color.new(255,Integer(255*rate*2),0)
		else
			gc1 = Color.new(0, 255, 0)
		end
		gc2 = Color.new(0,0,0)
		# 填满指定的颜色
		self.contents.fill_rect(64+16, self.contents.height - 2.5*@wlh, self.contents.width-(64+16), @wlh, gc2)
		self.contents.fill_rect(64+16, self.contents.height - 2.5*@wlh, gw, @wlh, gc1)
		draw_a_line(color, 64+16, self.contents.height - 2.5*@wlh, self.contents.width-(64+16), @wlh, @hp.ceil.to_s+"/"+@maxhp.ceil.to_s, 1)
		
	end
	#--------------------------------------------------------------------------
	# ● 跟新窗口
	#--------------------------------------------------------------------------
	def update
		super
		if @xmoving == false and @still_timer <= 1.0
			@disappearing = false
			# still for 0.4 second
			@still_timer += (1.0/0.5) / Graphics.frame_rate.to_f
			if @still_timer >= 1.0
				@disappearing = true
			end
		end
		if @disappearing == true
			self.opacity -= 15
			if self.opacity <= 0
				@disappearing = false
			end
		end
		# 判断是否需要刷新
		if need_refresh?
			refresh
		end
	end
end

##==========================================================================
# ■ Window_BattleStatusEnemy
#---------------------------------------------------------------------------
# 	Display the status of enemy.  
#   Display HP.
# 	Display the name and show the face.
#===========================================================================
class Window_BattleStatusPlayer < Window_Animated
	#--------------------------------------------------------------------------
	# ● 初始化对象
	#--------------------------------------------------------------------------
	def initialize(x=20,y=400-8,w=600,h=64+32,xi=20,yi=480+8,dx=0,dy=0.04)
		super(x,y,w,h,xi,yi,dx,dy)
		@ymoving = true
		@wlh = 20
		@still_timer = 0
	end
	#--------------------------------------------------------------------------
	# ● 设置显示参数
	#--------------------------------------------------------------------------
	def setup(m)
		@player = m
		# 设置角色脸部名字
		@face_name = @player.face_name
		# 设置角色脸部索引
		@face_index = @player.face_index
		@new_values = [
			@maxhp = @player.maxhp,
			@hp = @player.hp,
			@name = @player.name,
		]
		refresh
	end
	#--------------------------------------------------------------------------
	# ● 是否需要刷新
	#--------------------------------------------------------------------------
	def need_refresh?
		if @maxhp != @player.maxhp
			return true
		end
		if @hp != @player.hp
			return true
		end
		if @name != @player.name
			return true
		end
		if @face_name != @player.character_name
			return true
		end
	end
	#--------------------------------------------------------------------------
	# ● 刷新界面
	#--------------------------------------------------------------------------	
	def refresh
		self.contents.clear		
		# 设置角色脸部名字
		@face_name = @player.face_name
		# 设置角色脸部索引
		@face_index = @player.face_index
		@new_values = [
			@maxhp = @player.maxhp,
			@hp = @player.hp,
			@name = @player.name,
		]
		# 绘制脸部
		bitmap = Cache.face(@face_name)
		rect = Rect.new(0, 0, 0, 0)
		rect.x = @face_index % 4 * 96 + (96 - 64) / 2
		rect.y = @face_index / 4 * 96 + (96 - 64) / 2
		rect.width = 64
		rect.height = 64
		self.contents.blt(self.contents.width - 64, 0, bitmap, rect)
		# 绘制名字
		color = Color.new(255, 255, 255)
		draw_a_line(color, self.contents.width-(64+16)-200, self.contents.height-@wlh, 200, @wlh, @name, 2)
		# 绘制HP槽
		rate = @hp / @maxhp
		gw = Integer((self.contents.width-(64+16)) * rate)
		if rate < 0.5
			gc1 = Color.new(255,Integer(255*rate*2),0)
		else
			gc1 = Color.new(0, 255, 0)
		end
		gc2 = Color.new(0,0,0)
		# 填满指定的颜色
		self.contents.fill_rect(0, self.contents.height - 2.5*@wlh, self.contents.width-(64+16), @wlh, gc2)
		self.contents.fill_rect(self.contents.width-(64+16)-gw, self.contents.height - 2.5*@wlh, gw, @wlh, gc1)
		draw_a_line(color, 0, self.contents.height - 2.5*@wlh, self.contents.width-(64+16), @wlh, @hp.ceil.to_s+"/"+@maxhp.ceil.to_s, 1)
		
	end
	#--------------------------------------------------------------------------
	# ● 跟新窗口
	#--------------------------------------------------------------------------
	def update
		super
		if @xmoving == false and @still_timer <= 1.0
			@disappearing = false
			# still for 0.4 second
			@still_timer += (1.0/0.5) / Graphics.frame_rate.to_f
			if @still_timer >= 1.0
				@disappearing = true
			end
		end
		if @disappearing == true
			self.opacity -= 15
			if self.opacity <= 0
				@disappearing = false
			end
		end
		# 判断是否需要刷新
		if need_refresh?
			refresh
		end
	end
end


##==========================================================================
# ■ Window_BattlePanel_Enemy
#---------------------------------------------------------------------------
#  Battle Panel shows the status of the enemy.
#  Size: 300(W) * 320*(H)
#  On the left hand side. Onece is colided with the other window, which is of 
#  the player, the background disappear. 
#
#===========================================================================
class Window_BattlePanel < Window_Animated
	include GAME_CONF
	WLH = 24
	RW = 8
	
	attr_accessor		:player
	attr_accessor 		:monster
	attr_accessor 		:appearing 			# 是否正在打开
	attr_accessor 		:disappearing 		# 是否正在关闭
	attr_accessor 		:still_timer 		# 碰撞之后等待的时间，然后开始隐去背景
	#--------------------------------------------------------------------------
	# ● 初始化对象
	#--------------------------------------------------------------------------
	def initialize(x,y,w,h,xi,yi,dx,dy)
		super(x,y,w,h,xi,yi,dx,dy)
		@xmoving = true
		# 计时器清零,然后才能进行背景隐去
		@still_timer = 0.0
		# 记录属性颜色的数组
		@attributes_color = []
		# 记录属性字段
		@attributes_string = [
			"攻击:","防御:","力量:","敏捷:","恢复:",
			"伤害:","攻速:","命中:","闪避:",
		]
		# 属性字颜色
		@attributes_string_color = [
			"light purple", "light blue", "red", "light green", "white", 
			"heavy orange", "light purple", "light blue", "light blue"
		]
	end
	#--------------------------------------------------------------------------
	# ● 设置显示参数
	#--------------------------------------------------------------------------
	def setup(p, m)
		@player = p
		@monster = m
		@pname = @player.name
		@mname = @monster.name
		@monster_attributes = [
			@matk = @monster.atk,
			@mdef = @monster.def,
			@mstrength = @monster.final_strength,
			@mcelerity = @monster.final_celerity,
			@mhpcover = @monster.final_hpcover,
			@mdestroy = @monster.final_destroy,
			@matkspeed = @monster.final_atkspeed,
			@mhit = @monster.final_hit,
			@meva = @monster.final_eva,
		]
		@player_attributes = [
			@patk = @player.atk,
			@pdef = @player.def,
			@pstrength = @player.final_strength,
			@pcelerity = @player.final_celerity,
			@phpcover = @player.final_hpcover,
			@pdestroy = @player.final_destroy,
			@patkspeed = @player.final_atkspeed,
			@phit = @player.final_hit,
			@peva = @player.final_eva,
		]
		@monster_skills = @monster.get_skills
		@player_skills = @player.get_skills
		refresh
	end
	#--------------------------------------------------------------------------
	# ● 刷新窗口内容
	#--------------------------------------------------------------------------	
	def refresh
		# 基类首先清除内容
		self.contents.clear
		# 赋予新值
		@monster_attributes = [
			@matk = @monster.atk,
			@mdef = @monster.def,
			@mstrength = @monster.final_strength,
			@mcelerity = @monster.final_celerity,
			@mhpcover = @monster.final_hpcover,
			@mdestroy = @monster.final_destroy,
			@matkspeed = @monster.final_atkspeed,
			@mhit = @monster.final_hit,
			@meva = @monster.final_eva,
		]
		@player_attributes = [
			@patk = @player.atk,
			@pdef = @player.def,
			@pstrength = @player.final_strength,
			@pcelerity = @player.final_celerity,
			@phpcover = @player.final_hpcover,
			@pdestroy = @player.final_destroy,
			@patkspeed = @player.final_atkspeed,
			@phit = @player.final_hit,
			@peva = @player.final_eva,
		]
		@mname = @monster.name
		@pname = @player.name
	end
	#--------------------------------------------------------------------------
	# ● 判断是否需要更新，比较费时
	#--------------------------------------------------------------------------
	def need_refresh?		
		# 判断是否需要重新绘制
		if @monster.atk != @matk or @player.atk != @patk
			return true
		end
		if @monster.def != @mdef or @player.def != @pdef
			return true
		end
		if @monster.final_hpcover != @mhpcover or @player.final_hpcover != @phpcover
			return true
		end
		if @monster.final_destroy != @mdestroy or @player.final_destroy != @pdestroy
			return true
		end
		if @monster.final_atkspeed != @matkspeed or @player.final_atkspeed != @patkspeed
			return true
		end
		if @monster.final_hit != @mhit or @player.final_hit != @phit
			return true
		end
		if @monster.final_eva != @meva or @player.final_eva != @peva
			return true
		end
		if @monster.final_strength != @mstrength or @player.final_strength != @pstrength
			return true
		end
		if @monster.final_celerity != @mcelerity or @player.final_celerity != @pcelerity
			return true
		end
		if @mname != @monster.name or @pname != @player.name
			return true
		end
		return false
	end
	#--------------------------------------------------------------------------
	# ● 判断是否需要更新.
	#--------------------------------------------------------------------------
	def update
		super
		if @xmoving == false and @still_timer <= 1.0
			@disappearing = false
			# still for 0.4 second
			@still_timer += (1.0/0.4) / Graphics.frame_rate.to_f
			if @still_timer >= 1.0
				@disappearing = true
			end
		end
		if @disappearing == true
			self.opacity -= 15
			if self.opacity <= 0
				@disappearing = false
			end
		end
		# 判断是否需要刷新
		if need_refresh?
			refresh
		end
	end
end

##==========================================================================
# ■ Window_BattlePanel_Enemy
#---------------------------------------------------------------------------
#  Battle Panel shows the status of the enemy.
#  Size: 300(W) * 320*(H)
#  On the left hand side. Onece is colided with the other window, which is of 
#  the player, the background disappear. 
#
#===========================================================================
class Window_BattlePanel_Enemy < Window_BattlePanel
	attr_accessor 			:w_1
	attr_accessor 			:w_2
	attr_accessor 			:w_3
	attr_accessor 			:w_4
	attr_accessor 			:sw_1
	attr_accessor 			:sw_2
	attr_accessor 			:sw_3
	attr_accessor 			:sw_4
	attr_accessor 			:h_1
	attr_accessor 			:h_2
	attr_accessor 			:h_3
	attr_accessor 			:h_4
	attr_accessor 			:sh_1
	attr_accessor 			:sh_2
	attr_accessor 			:sh_3
	attr_accessor 			:sh_4
	#--------------------------------------------------------------------------
	# ● 初始化对象
	#--------------------------------------------------------------------------
	def initialize(x,y,w=300, h=320, xi=-300, yi=80, dx=0.07, dy=0)
		super(x,y,w,h,xi,yi,dx,dy)
		@w_1 = 140 - 16 						# 属性列宽度
		@sw_1 = 0 								# 属性到左边框的距离
		@w_2 = 300 - 32 - @w_1					# 技能列表宽度
		@sw_2 = @sw_1 + @w_1					# 技能到左边框的距离
		@sw_3 = @sw_2							# 名字到左边框的距离
		@w_3 = @w_2								# 名字宽度
		@sw_4 = @sw_1 + @w_1 + 48 				# 图片左边到左边框的距离
		@w_4 = 64 								# 图片宽度
		@h_1 = 18 + 8 							# 属性每行高度
		@sh_1 = 0								# 属性第一行位置
		@h_2 = 96 								# 图片高度
		@sh_2 = 96 - 16 						# 图片上沿到窗口上边框的距离
		@h_3 = 32 								# 名字高度
		@sh_3 = @sh_2 + @h_2					# 名字上沿
		@h_4 = 320 - @sh_2 - @sh_3 - 32			# 技能列表高度
		@sh_4 = @sh_3 + @h_3 					# 技能列表上沿
		self.windowskin = Cache.system("Booky_Skin")
		
	end
	#--------------------------------------------------------------------------
	# ● 刷新窗口界面，数据变化的时候才需要调用
	#--------------------------------------------------------------------------
	def refresh
		super
		for i in 0...@monster_attributes.size
			if @monster_attributes[i].ceil > @player_attributes[i].ceil
				@attributes_color[i] = "green"
			elsif @monster_attributes[i].ceil < @player_attributes[i].ceil
				@attributes_color[i] = "light red"
			else
				@attributes_color[i] = "blue"
			end
		end
		for i in 0...@monster_attributes.size
			draw_a_line(getColor(@attributes_string_color[i]), @sw_1, @sh_1+i*(@h_1), @w_1, @h_1, @attributes_string[i],  0)
			draw_a_line(getColor(@attributes_color[i]), @sw_1+40, @sh_1+i*(@h_1), @w_1-40, @h_1, @monster_attributes[i].ceil.to_s,  2)
		end
		# 打印名字
		draw_a_line(getColor("white"), @sw_3, @sh_3, @w_3, @h_3, @mname,  1)
		old_font = self.contents.font.clone
		self.contents.font.size = 13
		# 绘制技能以及名字
		folder_name = "Graphics/System/"
		for i in 0...@monster_skills.size
			skill_name = @monster_skills[i].name
			disabled = @monster_skills[i].locked
			bitmap = FrameFactory.getBitmapWithSize(44, 44, folder_name, skill_name)
			self.contents.blt((49)*i, @sh_1+@monster_attributes.size*(@h_1)+8, bitmap, bitmap.rect, disabled ? 128 : 255)
			if true == disabled 
				draw_a_line(getColor("gray"), (49)*i, @sh_1+@monster_attributes.size*(@h_1)+8+44, 50, 24, skill_name, 1)
			else
				draw_a_line(getColor("white"), (49)*i, @sh_1+@monster_attributes.size*(@h_1)+8+44, 50, 24, skill_name, 1)
			end
		end
		self.contents.font = old_font
	end
end
##==========================================================================
	# ■ Window_BattlePanel_Player
#---------------------------------------------------------------------------
#  Battle Panel shows the status of the player.
#  Size: 300(W) * 320*(H)
#  On the right hand side. Onece is colided with the other window, which is of 
#  the enemy, the background disappear.
#  
#===========================================================================
class Window_BattlePanel_Player < Window_BattlePanel
	attr_accessor 			:w_1
	attr_accessor 			:w_2
	attr_accessor 			:w_3
	attr_accessor 			:w_4
	attr_accessor 			:sw_1
	attr_accessor 			:sw_2
	attr_accessor 			:sw_3
	attr_accessor 			:sw_4
	attr_accessor 			:h_1
	attr_accessor 			:h_2
	attr_accessor 			:h_3
	attr_accessor 			:h_4
	attr_accessor 			:sh_1
	attr_accessor 			:sh_2
	attr_accessor 			:sh_3
	attr_accessor 			:sh_4
	#--------------------------------------------------------------------------
	# ● 初始化对象
	#--------------------------------------------------------------------------
	def initialize(x,y,w=300, h=320, xi=640, yi=80, dx=0.07, dy=0)
		super(x,y,w,h,xi,yi,dx,dy)
		@sw_4 = 48 - 16			 				# 图片左边到左边框的距离
		@w_4 = 64 								# 图片宽度
		@w_1 = 140 - 16 						# 属性列宽度
		@w_2 = 300 - 32 - @w_1					# 技能列表宽度
		@sw_1 = @w_2							# 属性到左边框的距离
		@sw_2 = 0								# 技能到左边框的距离
		@sw_3 = @sw_2							# 名字左边界位置
		@w_3 = @w_2								# 名字宽度

		@h_1 = 18 + 8 							# 属性每行高度
		@sh_1 = 0								# 属性第一行位置
		@h_2 = 96 								# 图片高度
		@sh_2 = 96 - 16 						# 图片上沿到窗口上边框的距离
		@h_3 = 32 								# 名字高度
		@sh_3 = @sh_2 + @h_2					# 名字上沿
		@h_4 = 320 - @sh_2 - @sh_3 - 32			# 技能列表高度
		@sh_4 = @sh_3 + @h_3 					# 技能列表上沿
		self.windowskin = Cache.system("Booky_Skin")
	end
	#--------------------------------------------------------------------------
	# ● 刷新窗口界面，数据变化的时候才需要调用
	#--------------------------------------------------------------------------
	def refresh
		super
		for i in 0...@player_attributes.size
			if @monster_attributes[i].ceil < @player_attributes[i].ceil
				@attributes_color[i] = "green"
			elsif @monster_attributes[i].ceil > @player_attributes[i].ceil
				@attributes_color[i] = "light red"
			else
				@attributes_color[i] = "blue"
			end
		end
		for i in 0...@player_attributes.size
			draw_a_line(getColor(@attributes_string_color[i]), @sw_1, @sh_1+i*@h_1, @w_1, @h_1, @attributes_string[i],  0)
			draw_a_line(getColor(@attributes_color[i]), @sw_1+40, @sh_1+i*@h_1, @w_1-40, @h_1, @player_attributes[i].ceil.to_s,  2)
		end
		# 打印名字
		draw_a_line(getColor("white"), @sw_3, @sh_3, @w_3, @h_3, @pname,  1)
		old_font = self.contents.font.clone
		self.contents.font.size = 13
		# 绘制技能以及名字
		folder_name = "Graphics/System/"
		for i in 0...@player_skills.size
			skill_name = @player_skills[i].name
			disabled = @player_skills[i].locked
			bitmap = FrameFactory.getBitmapWithSize(48, 48, folder_name, skill_name)
			self.contents.blt((49)*i, @sh_1+@monster_attributes.size*(@h_1)+8, bitmap, bitmap.rect, disabled ? 128 : 255)
			if true == disabled
				draw_a_line(getColor("gray"), (49)*i, @sh_1+@monster_attributes.size*(@h_1)+8+48, 50, 24, skill_name, 1)
			else 
				draw_a_line(getColor("white"), (49)*i, @sh_1+@monster_attributes.size*(@h_1)+8+48, 50, 24, skill_name, 1)
			end
		end
		self.contents.font = old_font
	end
end

##==========================================================================
# ■ Window_BattleHP_Enemy
#---------------------------------------------------------------------------
#     
#
#===========================================================================
class Window_BattleHP_Enemy < Window_Animated
end



##==========================================================================
# ■ Window_BattleHP_Player
#---------------------------------------------------------------------------
#     
#
#===========================================================================
class Window_BattleHP_Player < Window_Animated
end

