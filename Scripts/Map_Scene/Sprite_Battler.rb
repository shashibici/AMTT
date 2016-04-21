#==============================================================================
# ■ Sprite_Battler
#------------------------------------------------------------------------------
# 　战斗显示用活动块。Game_Battler 类的实例监视、
# 活动块的状态的监视、活动块状态自动变化。
#
#   此处重新定义覆盖前面定义
#
#
#==============================================================================

class Sprite_Battler < Sprite_Base
	#--------------------------------------------------------------------------
	# ● 常量
	#--------------------------------------------------------------------------
	WHITEN    = 1                      # 白色闪烁 (开始行动)
	BLINK     = 2                      # 闪烁 (伤害)
	APPEAR    = 3                      # 出现 (出现、复活)
	DISAPPEAR = 4                      # 消失 (逃走)
	COLLAPSE  = 5                      # 崩溃 (不能战斗)
	#--------------------------------------------------------------------------
	# ● 定义实例变量
	#--------------------------------------------------------------------------
	attr_accessor :battler
	#--------------------------------------------------------------------------
	# ● 初始化对象
	#     viewport : 视区
	#     battler  : 战斗者 (Game_Battler)
	#--------------------------------------------------------------------------
	def initialize(viewport, battler = nil)
		super(viewport)
		@battler = battler
		@battler_visible = false
		@effect_type = 0            # 效果种类
		@effect_duration = 0        # 效果剩余时间
	end
	#--------------------------------------------------------------------------
	# ● 释放
	#--------------------------------------------------------------------------
	def dispose
		if self.bitmap != nil
			self.bitmap.dispose
		end
		super
	end
	#--------------------------------------------------------------------------
	# ● 更新画面
	#--------------------------------------------------------------------------
	def update
		super
		if @battler == nil
			self.bitmap = nil
		else
			@use_sprite = @battler.use_sprite?
			if @use_sprite
				self.x = @battler.screen_x
				self.y = @battler.screen_y
				self.z = @battler.screen_z
				update_battler_bitmap
			end
			setup_new_effect
			update_effect
		end
	end
	#--------------------------------------------------------------------------
	# ● 更新传送源位图
	#
	#     着重修改！
	#
	#--------------------------------------------------------------------------
	def update_battler_bitmap
		if @battler.battler_name != @battler_name or
			@battler.battler_hue != @battler_hue
			# 战斗图名字
			@battler_name = "girl"#@battler.battler_name
			@battler_hue = 0
			self.bitmap = FrameFactory.getBitmapWithSize(64,92,"Graphics/Battlers/", @battler_name, @battler_hue)
			@width = bitmap.width
			@height = bitmap.height
			self.ox = 0#@width / 2
			self.oy = 0#@height
			if @battler.dead? or @battler.hidden
				self.opacity = 0
			end
		end
	end
	#--------------------------------------------------------------------------
	# ● 设置新的效果
	#--------------------------------------------------------------------------
	def setup_new_effect
		if @battler.white_flash
			@effect_type = WHITEN
			@effect_duration = 16
			@battler.white_flash = false
		end
		if @battler.blink
			@effect_type = BLINK
			@effect_duration = 20
			@battler.blink = false
		end
		if not @battler_visible and @battler.exist?
			@effect_type = APPEAR
			@effect_duration = 16
			@battler_visible = true
		end
		if @battler_visible and @battler.hidden
			@effect_type = DISAPPEAR
			@effect_duration = 32
			@battler_visible = false
		end
		if @battler.collapse
			@effect_type = COLLAPSE
			@effect_duration = 48
			@battler.collapse = false
			@battler_visible = false
		end
		# 第一次刷新动画
		keys = @battler.animation_id.keys.sort
		for key in keys
			if @battler.animation_id[key][0] <= 0
				# 获得动画
				animation = $data_animations[@battler.animation_id[key][1]]
				mirror = @battler.animation_mirror
				# 开始显示动画
				start_animation(animation, mirror)
				@battler.animation_id.delete(key)
			else
				# 继续倒计时
				@battler.animation_id[key][0] -= 1
			end
		end
	end
	#--------------------------------------------------------------------------
	# ● 更新效果
	#--------------------------------------------------------------------------
	def update_effect
		if @effect_duration > 0
			@effect_duration -= 1
			case @effect_type
				when WHITEN
				update_whiten
				when BLINK
				update_blink
				when APPEAR
				update_appear
				when DISAPPEAR
				update_disappear
				when COLLAPSE
				update_collapse
			end
		end
	end
	#--------------------------------------------------------------------------
	# ● 更新白色闪烁效果
	#--------------------------------------------------------------------------
	def update_whiten
		self.blend_type = 0
		self.color.set(255, 255, 255, 128)
		self.opacity = 255
		self.color.alpha = 128 - (16 - @effect_duration) * 10
	end
	#--------------------------------------------------------------------------
	# ● 更新闪烁效果
	#--------------------------------------------------------------------------
	def update_blink
		self.blend_type = 0
		self.color.set(0, 0, 0, 0)
		self.opacity = 255
		self.visible = (@effect_duration % 10 < 5)
	end
	#--------------------------------------------------------------------------
	# ● 更新出现效果
	#--------------------------------------------------------------------------
	def update_appear
		self.blend_type = 0
		self.color.set(0, 0, 0, 0)
		self.opacity = (16 - @effect_duration) * 16
	end
	#--------------------------------------------------------------------------
	# ● 更新消失效果
	#--------------------------------------------------------------------------
	def update_disappear
		self.blend_type = 0
		self.color.set(0, 0, 0, 0)
		self.opacity = 256 - (32 - @effect_duration) * 10
	end
	#--------------------------------------------------------------------------
	# ● 更新崩溃效果
	#--------------------------------------------------------------------------
	def update_collapse
		self.blend_type = 1
		self.color.set(255, 128, 128, 128)
		self.opacity = 256 - (48 - @effect_duration) * 6
	end
end
