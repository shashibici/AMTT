# 每秒钟最多刷新25下，对于所有的drawable来说。
# 这个值最多可以设为Graphics.frame_rate.
#Graphics.frame_rate = 120
Graphics.resize_screen(640,480)
$sys_timer=SystemTimer.new(true)
class Drawable
	
	attr_accessor	:sprite
	attr_accessor	:xSpeed
	attr_accessor	:ySpeed
	#---------------------------------------------------------------------
	#	sprite: 代表需要绘制的图像
	#	xSpeed:	x方向速度每秒钟移动的像素单位
	#	ySpeed:	y方向速度每秒钟移动的像素单位
	#---------------------------------------------------------------------
	def initialize(name, w, h, bitPath, bitName, xSpeed, ySpeed)
		@frames = {}
		@name = name
		@width = w
		@height = h
		@hue = 0
		@bitmapName = bitName
		@bitmapPath	= bitPath
		# Magic Numbers
		@frameN = 19
		@frameH = 192
		@frameW = 192
		@colN = 5
		@rowN = 4
		@currentFrame = 0
		@sprite = Sprite.new
		@sprite.x = @sprite.y = 0
		# 获取图片
		fillFrames
		@sprite.bitmap = @frames[@currentFrame]

		# 两次调用update的间隔不能低于@interval指定的毫秒数
		@xSpeed = (xSpeed + 0.0e1)
		@ySpeed	= (ySpeed + 0.0e1)
		# 毫秒为单位
		@lastTime = $sys_timer.now()
		@currTime = $sys_timer.now()
		@timeElapsed = 0.0e1
	end
	#------------------------------------------------------------------
	#	填充图片
	#------------------------------------------------------------------
	def fillFrames
		for i in 0...@frameN
			@frames[i] = FrameFactory.extractBitmap(FrameFactory.getBitmap(@bitmapPath, @bitmapName, 0),\
													Rect.new(i/@colN*@frameH, i%@colN*@frameW, @frameW, @frameH),\
													@width, @height)
		end
	end
	#-------------------------------------------------------------------
	#	更新sprite
	#-------------------------------------------------------------------
	def update
		@currTime = $sys_timer.now()
		@timeElapsed = @currTime - @lastTime
		incx = @xSpeed * @timeElapsed / 1000.0
		incy = @ySpeed * @timeElapsed / 1000.0
		@sprite.x = @sprite.x + incx.round
		@sprite.y = @sprite.y + incy.round
		# 边界检测
		if @sprite.x > Graphics.width - @width
			@xSpeed = -(@xSpeed.abs)
		end
		if @sprite.y > Graphics.height - @height
			@ySpeed = -(@ySpeed.abs)
		end
		if @sprite.x < 0
			@xSpeed = @xSpeed.abs
		end
		if @sprite.y < 0
			@ySpeed = @ySpeed.abs
		end

		@timeElapsed = 0
		@lastTime = @currTime
	end
end

