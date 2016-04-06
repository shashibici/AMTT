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
		#@player = $game_battle_players[0]
		#@monster = $game_battle_monsters[0]
		#setup(@player, @monster)
		#refresh
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
		refresh
	end
	#--------------------------------------------------------------------------
	# ● 刷新窗口内容
	#--------------------------------------------------------------------------	
	def refresh
		# 基类首先清除内容
		self.contents.clear
	end
	#--------------------------------------------------------------------------
	# ● 判断是否需要更新，比较费时
	#--------------------------------------------------------------------------
	def need_refresh?
		# 保存旧属性
		@old_monstor_attributs = [
			@old_matk = @matk,
			@old_mdef = @mdef,
			@old_mstrength = @mstrength,
			@old_mcelerity = @mcelerity,
			@old_mhpcover = @mhpcover,
			@old_mdestroy = @mdestroy,
			@old_matkspeed = @matkspeed,
			@old_mhit = @mhit,
			@old_meva = @meva,
		]
		@old_player_attributs = [
			@old_patk = @patk,
			@old_pdef = @pdef,
			@old_pstrength = @pstrength,
			@old_pcelerity = @pcelerity,
			@old_phpcover = @phpcover,
			@old_pdestroy = @pdestroy,
			@old_patkspeed = @patkspeed,
			@old_phit = @phit,
			@old_peva = @peva,
		]
		# 这一部分很费时,尽量少执行
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
		
		# 判断是否需要重新绘制
		if @old_matk != @matk or @old_patk != @patk
			return true
		end
		if @old_mdef != @mdef or @old_pdef != @pdef
			return true
		end
		if @old_mhpcover != @mhpcover or @old_phpcover != @phpcover
			return true
		end
		if @old_mdestroy != @mdestroy or @old_pdestroy != @pdestroy
			return true
		end
		if @old_matkspeed != @matkspeed or @old_patkspeed != @patkspeed
			return true
		end
		if @old_mhit != @mhit or @old_phit != @phit
			return true
		end
		if @old_meva != @meva or @old_peva != @peva
			return true
		end
		if @old_mstrength != @mstrength or @old_pstrength != @pstrength
			return true
		end
		if @old_mcelerity != @mcelerity or @old_pcelerity != @pcelerity
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

	#--------------------------------------------------------------------------
	# ● 初始化对象
	#--------------------------------------------------------------------------
	def initialize(x,y,w=300, h=320, xi=-300, yi=80, dx=0.07, dy=0)
		super(x,y,w,h,xi,yi,dx,dy)
		@w_1 = 140 - 16 						# 属性列宽度
		@sw_1 = 0 								# 属性到左边框的距离
		@w_2 = 300 - 32 - @w_1					# 技能列表宽度
		@sw_2 = @sw_1 + @w_1					# 技能到左边框的距离
		@sw_3 = @sw_2							# 名字高度
		@w_3 = @w_2								# 名字宽度
		@sw_4 = @sw_1 + @w_1 + 48 				# 图片左边到左边框的距离
		@w_4 = 64 								# 图片宽度
		@h_1 = 24 + 8 							# 属性每行高度
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
			draw_a_line(getColor(@attributes_string_color[i]), @sw_1, @sh_1+i*(24+8), @w_1, @h_1, @attributes_string[i],  0)
			draw_a_line(getColor(@attributes_color[i]), @sw_1+40, @sh_1+i*(24+8), @w_1-40, @h_1, @monster_attributes[i].ceil.to_s,  2)
		end
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

		@h_1 = 24 + 8 							# 属性每行高度
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
			draw_a_line(getColor(@attributes_string_color[i]), @sw_1, @sh_1+i*(24+8), @w_1, @h_1, @attributes_string[i],  0)
			draw_a_line(getColor(@attributes_color[i]), @sw_1+40, @sh_1+i*(24+8), @w_1-40, @h_1, @player_attributes[i].ceil.to_s,  2)
		end
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

