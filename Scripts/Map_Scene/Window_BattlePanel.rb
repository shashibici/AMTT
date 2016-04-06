##==========================================================================
# ■ Window_BattleBack
#---------------------------------------------------------------------------
#   This window sits as a background of battle field.
#   Size: 640*480
#===========================================================================
class Window_BattleBack < Window_Base
	
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
	attr_accessor 	:final_x 		# X 最终位置
	attr_accessor 	:final_y 		# Y 最终位置
	attr_accessor 	:dx				
	attr_accessor 	:dy
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
		@dx = dx
		@dy = dy
	end
	#--------------------------------------------------------------------------
	# ● 更新画面
	#--------------------------------------------------------------------------
	def update
		super
		if self.visible == true and self.active == true
			if self.x<@final_x-1 or self.x>@final_x+1
				oldX = self.x
				self.x += (@final_x+0.0 - self.x) * @dx
				if (oldX - self.x).abs < 0.01
					self.x = @final_x
				end
			end
			if self.y<@final_y-1 or self.y>@final_y+1
				oldY = self.y
				self.y += (@final_y+0.0 - self.y) * @dy
				if (oldY - self.y).abs < 0.01
					self.y = @final_y
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
	#--------------------------------------------------------------------------
	# ● 初始化对象
	#--------------------------------------------------------------------------
	def initialize(x,y)
		super(x,y,320,300,xi=-300,yi=80,dx=0.2,dy=0)
		@player = $game_battle_players[0]
		@monster = $game_battle_monsters[0]
		setup(@player, @monster)
		refresh
	end
	#--------------------------------------------------------------------------
	# ● 设置显示参数
	#--------------------------------------------------------------------------
	def setup(p, m)
		@player = p
		@monster = m
		@matk = @monster.final_atk
		@mdef = @monster.final_def
		@mstrength = @monster.final_strength
		@mhpcover = @monster.final_hpcover
		@mcelerity = @monster.final_celerity
		@mdestroy = @monster.final_destroy
		@matkspeed = @monster.final_atkspeed
		@mhit = @monster.final_hit
		@meva = @monster.final_eva
		@patk = @player.final_atk
		@pdef = @player.final_def
		@pstrength = @player.final_strength
		@pcelerity = @player.final_celerity
		@pdestroy = @player.final_destroy
		@phpcover = @plyaer.final_hpcover
		@patkspeed = @player.final_atkspeed
		@phit = @player.final_hit
		@peva = @player.final_eva
	end
	#--------------------------------------------------------------------------
	# ● 判断是否需要更新，比较费时
	#--------------------------------------------------------------------------
	def need_refresh?
		# 保存旧属性
		@old_matk = @matk
		@old_patk = @patk
		@old_mdef = @mdef
		@old_pdef = @pdef
		@old_mhpcover = @mhpcover
		@old_phpcover = @phpcover
		@old_mdestroy = @mdestroy
		@old_pdestroy = @pdestroy
		@old_matkspeed = @matkspeed
		@old_patkspeed = @patkspeed
		@old_mhit = @mhit
		@old_phit = @phit
		@old_meva = @meva
		@old_peva = @peva
		@old_mstrength = @mstrength
		@old_pstrength = @pstrength
		# 这一部分很费时,尽量少执行
		@matk = @monster.final_atk
		@mdef = @monster.final_def
		@mstrength = @monster.final_strength
		@mhpcover = @monster.final_hpcover
		@mcelerity = @monster.final_celerity
		@mdestroy = @monster.final_destroy
		@matkspeed = @monster.final_atkspeed
		@mhit = @monster.final_hit
		@meva = @monster.final_eva
		@patk = @player.final_atk
		@pdef = @player.final_def
		@pstrength = @player.final_strength
		@pcelerity = @player.final_celerity
		@pdestroy = @player.final_destroy
		@phpcover = @plyaer.final_hpcover
		@patkspeed = @player.final_atkspeed
		@phit = @player.final_hit
		@peva = @player.final_eva
		# 判断是否需要重新绘制
		if @old_matk != @matk or @old_patk != @patk
			return true
		end
		if @old_mdef != @mdef or @old_pdef != @player.final_def
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
	# ● 判断是否需要更新，比较费时
	#--------------------------------------------------------------------------
	def update
		if need_refresh?
			refresh
		end
		super
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
	w_1 = 140 - 16 					# 属性列宽度
	sw_1 = 0 						# 属性到左边框的距离
	w_2 = 300 - 32 - w_1			# 技能列表宽度
	sw_2 = sw_1 + w_1				# 技能到左边框的距离
	sw_3 = sw_2						# 名字高度
	w_3 = w2						# 名字宽度
	sw_4 = sw_1 + w_1 + 48 			# 图片左边到左边框的距离
	w_4 = 64 						# 图片宽度
	h_1 = 24 + 8 					# 属性每行高度
	sh_1 = 0						# 属性第一行位置
	h_2 = 96 						# 图片高度
	sh_2 = 96 - 16 					# 图片上沿到窗口上边框的距离
	h_3 = 32 						# 名字高度
	sh_3 = sh_2 + h_2				# 名字上沿
	h_4 = 320 - sh_2 - sh_3 - 32	# 技能列表高度
	sh_4 = sh_3 + h_3 				# 技能列表上沿
	#--------------------------------------------------------------------------
	# ● 初始化对象
	#--------------------------------------------------------------------------
	def initialize(x,y)
		super(x,y)
	end
	#--------------------------------------------------------------------------
	# ● 刷新窗口界面，数据变化的时候才需要调用
	#--------------------------------------------------------------------------
	def refresh
		color = getColor("green")
		draw_a_line(color, sw_1,   sh_1, w_1, h_1, "攻击：",  0)
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
	def initialize(x,y)
		super(x,y)
	end
	#--------------------------------------------------------------------------
	# ● 刷新窗口界面，数据变化的时候才需要调用
	#--------------------------------------------------------------------------
	def refresh
		
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

