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
class Window_BattlePanel_Enemy < Window_Base
	include GAME_CONF
	WLH = 24
	RW = 8
	#--------------------------------------------------------------------------
	# ● 初始化对象
	#--------------------------------------------------------------------------
	def initialize(x,y)
		
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
class Window_BattlePanel_Player < Window_Base
	
end

##==========================================================================
# ■ Window_BattleHP_Enemy
#---------------------------------------------------------------------------
#     
#
#===========================================================================
class Window_BattleHP_Enemy < Window_Base
end



##==========================================================================
# ■ Window_BattleHP_Player
#---------------------------------------------------------------------------
#     
#
#===========================================================================
class Window_BattleHP_Player < Window_Base
end

