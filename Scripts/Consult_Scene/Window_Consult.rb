#==========================================================================
# ■ Window_Consult_Status1
#---------------------------------------------------------------------------
# 	本窗口用来显示角色头像、角色名字
#===========================================================================
class Window_Consult_Status1 < Window_Base
	include GAME_CONF
	WLH = 28      # 每行字的高度
	RW = 16
	#--------------------------------------------------------------------------
		# ● 初始化对象
	#--------------------------------------------------------------------------
	def initialize(x,y,actor)
		super(x, y, 384, 264) # x, y, 384, 264
		self.contents.font.size = 24
		self.contents.font.name = "华文细黑"
		self.opacity = 0
		@face_width = 128
		@face_height = 192
		@pic_size = 192
		@edge = 16
		setup(actor)
		@isInit = true
	end
	#--------------------------------------------------------------------------
	# ● 配置
	#   actor  : 角色(hero对象)
	#  	flag   : 0 defualt all, 3 only refresh actor
	#--------------------------------------------------------------------------
	def setup(actor, flag = 0)
		# 获得角色
		@actor = actor
		if 0 != flag
			return
		end
		# 头像
		#@actor_monstor_face = @actor.character_name
		@battler_name = @actor.battler_name
		@battler_hue = @actor.battler_hue
		# 名字
		@name = @actor.name
		# 属性
		@atk = @actor.atk
		@ddef = @actor.def
		@strength = @actor.final_strength
		@celerity = @actor.final_celerity
	end
	#--------------------------------------------------------------------------
	# ● 重新绘制该窗口
	#
	#--------------------------------------------------------------------------
	def refresh
		self.contents.clear
		# 重新获取数据
		setup(@actor)
		#-------------描绘角色--------------------------
		# 描绘脸部 (64*64)
		dst_rect = Rect.new((@pic_size-@face_width)/2,(@pic_size-@face_height)/2,@face_width,@face_height)
		#bitmap = FrameFactory.getBitmap("Graphics/battlers/", @actor_monstor_face)
		bitmap = FrameFactory.getBitmapWithSize(@face_width,@face_height,"Graphics/Battlers/", @battler_name, @battler_hue)
		src_rect = Rect.new(0, 0, @face_width, @face_height) 
		self.contents.stretch_blt(dst_rect, bitmap, src_rect)
		#bitmap.dispose
		# 描绘名字(72+108=180)
		self.contents.font.size = 20
		self.contents.font.name = "黑体"
		color = Color.new(255, 255, 255)
		draw_a_line(color, 0, @pic_size + RW, @pic_size, WLH, @name, 1) 
		# 描绘攻、防、力、敏
		self.contents.font.size = 24
		color = getColor("light purple")
		draw_a_line(color, @pic_size + RW, 0, 56, WLH, "攻: ", 0)
		draw_a_line(color, @pic_size + RW+56, 0, self.width-32-@pic_size-RW-32, WLH, @atk.ceil.to_s, 0)
		color = getColor("light blue")
		draw_a_line(color, @pic_size + RW, @edge+WLH, 56, WLH, "防: ", 0)
		draw_a_line(color, @pic_size + RW+56, @edge+WLH, self.width-32-@pic_size-RW-32, WLH, @ddef.ceil.to_s, 0)
		color = getColor("red")
		draw_a_line(color, @pic_size + RW, (@edge+WLH)*2, 56, WLH, "力: ", 0)
		draw_a_line(color, @pic_size + RW+56, (@edge+WLH)*2, self.width-32-@pic_size-RW-32, WLH, @strength.ceil.to_s, 0)
		color = getColor("light green")
		draw_a_line(color, @pic_size + RW, (@edge+WLH)*3, 56, WLH, "敏: ", 0)
		draw_a_line(color, @pic_size + RW+56, (@edge+WLH)*3, self.width-32-@pic_size-RW-32, WLH, @celerity.ceil.to_s, 0)
	end    
	#--------------------------------------------------------------------------
		# ● 判断是否需要重新获取数据
	#--------------------------------------------------------------------------
	def need_refresh?
		return true if @isInit
		return true if @name != @actor.name
		return true if @battler_name != @actor.battler_name 
		return true if @battler_hue != @actor.battler_hue
		return true if @actor.atk != @atk
		return true if @actor.def != @ddef
		return true if @actor.final_strength != @strength
		return true if @actor.final_celerity != @celerity
		return false
	end  
	#--------------------------------------------------------------------------
		# ● 更新画面
	#--------------------------------------------------------------------------
	def update
		if self.visible
			# 更新内容
			refresh if need_refresh?
			@isInit = false
		end
	end
end

#==========================================================================
# ■ Window_Consult_Status2
#---------------------------------------------------------------------------
# 	主要显示生命， 和其他不经常更新的东西，分开更新
#===========================================================================
class Window_Consult_Status2 < Window_Base
	WLH = 32      # 每行字的高度
	RW = 8        # 每一个项目之间的间隔
	#--------------------------------------------------------------------------
		# ● 初始化对象
	#--------------------------------------------------------------------------
	def initialize(x,y,actor, w = 384, h = $screen_height-y)
		super(x, y, w, h)
		self.opacity = 0
		self.contents.font.size = 30
		self.contents.font.name = "黑体" 
		@gw_width = w - 32
		@edge = 0
		@isInit = true
		@info_sprite = Sprite.new
		@info_sprite.bitmap = Bitmap.new(w - 16, h - 32 - WLH*2)
		@info_sprite.x = self.x + 16
		@info_sprite.y = self.y + 16 + WLH*1.2
		@info_sprite.bitmap.font.size = 24
		@info_sprite.bitmap.font.name = "黑体" #"华文细黑"
		setup(actor)
	end
	#--------------------------------------------------------------------------
		# ● 配置
		#     actor  : 角色(hero对象)
		#     flag   : 0 defualt all, 1 hp only, 2 other parameters, 3 only refresh actor.
		#
	#--------------------------------------------------------------------------
	def setup(actor, flag = 0)
		# 获得角色
		@actor = actor
		if 3 == flag
			return
		end
		if 2 != flag
			# 最大值
			@maxhp = actor.maxhp
			@maxmp = actor.maxmp
			# 当前值
			@hp = @actor.hp
			@mp = @actor.mp
		end
		if 1 != flag
			# 生命回复率
			@hpcover = @actor.final_hpcover
			# 物理伤害
			@destroy = @actor.base_destroy              # 物理破坏力因子
			@destroyrate = @actor.final_destroyrate     # 物理破坏额外倍数（%）
			# 攻击速度
			@atkspeed = @actor.base_atkspeed            # 攻速因子
			@atkrate = @actor.final_atkrate             # 攻速率
			# 暴击技巧
			@bom = @actor.final_bom                     # 暴击因子
			@bomatk = @actor.final_bomatk               # 暴击扩张倍数（%）
			# 命中技巧
			@hit = @actor.final_hit                     # 命中因子
			# 闪避技巧
			@eva = @actor.final_eva                     # 闪避因子
		end
	end   
	#--------------------------------------------------------------------------
	# ● 重新绘制other参数
	#
	#--------------------------------------------------------------------------
	def refresh
		setup(@actor, 2)
		
		@info_sprite.bitmap.clear
		tmp_content = @info_sprite.bitmap
		title_width = 108
		tmp_content.font.color = getColor("light gray")
		@info_sprite.bitmap.draw_text(0, 0, title_width, WLH, "生命恢复:")
		@info_sprite.bitmap.draw_text(title_width, 0, tmp_content.width-title_width, WLH, @hpcover.ceil.to_s, 0)
		tmp_content.font.color = getColor("heavy orange")
		@info_sprite.bitmap.draw_text(0, WLH, title_width, WLH, "物理伤害:")
		@info_sprite.bitmap.draw_text(title_width, WLH, tmp_content.width-title_width, WLH, @destroy.ceil.to_s, 0)
		@info_sprite.bitmap.draw_text(0, WLH*2, title_width, WLH, "物伤威力:")
		@info_sprite.bitmap.draw_text(title_width, WLH*2, tmp_content.width-title_width, WLH, Fround(@destroyrate,1).to_s+"%", 0)
		
		tmp_content.font.color = getColor("light yellow")
		@info_sprite.bitmap.draw_text(0, WLH*3, title_width, WLH, "暴击技巧:")
		@info_sprite.bitmap.draw_text(title_width, WLH*3, tmp_content.width-title_width, WLH, @bom.ceil.to_s, 0)
		@info_sprite.bitmap.draw_text(0, WLH*4, title_width, WLH, "暴击威力:")
		@info_sprite.bitmap.draw_text(title_width, WLH*4, tmp_content.width-title_width, WLH, Fround(@bomatk,1).to_s+"%", 0)
		
		tmp_content.font.color = getColor("light purple")
		@info_sprite.bitmap.draw_text(0, WLH*5, title_width, WLH, "攻击速度:")
		@info_sprite.bitmap.draw_text(title_width, WLH*5, tmp_content.width-title_width, WLH, @atkspeed.ceil.to_s, 0)
		@info_sprite.bitmap.draw_text(0, WLH*6, title_width, WLH, "攻击频率:")
		@info_sprite.bitmap.draw_text(title_width, WLH*6, tmp_content.width-title_width, WLH, Fround(@atkrate,1).to_s+"%", 0)
		
		tmp_content.font.color = getColor("light blue")
		@info_sprite.bitmap.draw_text(0, WLH*7, title_width, WLH, "命中技巧:")
		@info_sprite.bitmap.draw_text(title_width, WLH*7, tmp_content.width-title_width, WLH, @hit.ceil.to_s, 0)
		@info_sprite.bitmap.draw_text(0, WLH*8, title_width, WLH, "闪避技巧:")
		@info_sprite.bitmap.draw_text(title_width, WLH*8, tmp_content.width-title_width, WLH, @eva.ceil.to_s, 0)
	end
	#--------------------------------------------------------------------------
		# ● 是否需要更新其他数据
	#--------------------------------------------------------------------------
	def need_refresh?
		return true if @isInit
		return true if @hpcover != @actor.final_hpcover
		return true if @destroy != @actor.base_destroy
		return true if @destroyrate != @actor.final_destroyrate
		return true if @atkspeed != @actor.base_atkspeed
		return true if @atkrate != @actor.final_atkrate
		return true if @bom != @actor.final_bom
		return true if @bomatk != @actor.final_bomatk
		return true if @hit != @actor.final_hit
		return true if @eva != @actor.final_eva
		return false
	end
	#--------------------------------------------------------------------------
	# ● 重新绘制该窗口
	#
	#--------------------------------------------------------------------------
	def refresh_hp
		setup(@actor, 1)
		self.contents.clear
		# 重新获取数据
		# 最大值
		@maxhp = @actor.maxhp
		@maxmp = @actor.maxmp
		# 当前值
		@hp = @actor.hp
		@mp = @actor.mp
		
		# 描绘HP槽-------------------------------------
		rate = @hp / @maxhp
		gw = Integer(@gw_width * rate)
		if rate > 0.5
			gc1 = Color.new(Integer(255*(1-rate*2)),255,0)
		else
			gc1 = Color.new(255,Integer(255*rate*2),0)
		end
		gc2 = Color.new(0,0,0)
		
		# 填满指定的颜色
		self.contents.fill_rect(0, WLH - 10, @gw_width, 8, gc2)
		self.contents.fill_rect(0, WLH - 10, gw, 8, gc1)
		
		# 绘制文字
		self.contents.font.color = getColor("red")
		self.contents.draw_text(0, 0, 32, WLH, "HP")
		self.contents.draw_text(32, 0, @gw_width-32, WLH, @hp.ceil.to_s+"/"+@maxhp.ceil.to_s, 2)
		
	end 
	
	#--------------------------------------------------------------------------
		# ● 是否需要更新 HP 显示
	#--------------------------------------------------------------------------
	def need_refresh_hp?
		return true if @isInit
		return true if @hp  != @actor.hp
		return true if @mp != @actor.mp
		return true if @maxhp != @actor.maxhp 
		return true if @maxmp != @actor.maxmp 
		return false
	end
	#--------------------------------------------------------------------------
		# ● 更新画面
	#--------------------------------------------------------------------------
	def update
		if self.visible
			# 更新画面效果
			self.contents_opacity = 255
			# 更新内容
			refresh if need_refresh?
			refresh_hp if need_refresh_hp?
			@isInit = false
		end
	end
	#--------------------------------------------------------------------------
		# ● 释放
	#--------------------------------------------------------------------------
	def dispose
		@info_sprite.dispose unless @info_sprite.disposed?
		super
	end
	
end

class Window_Consult_Status3 < Window_Base
	WLH = 28      # 每行字的高度
	RW = 8        # 每一个项目之间的间隔
	#--------------------------------------------------------------------------
	# ● 初始化对象
	#--------------------------------------------------------------------------
	def initialize(x,y,actor, w = $screen_width-x, h = 128+32)
		super(x, y, w, h)
		self.opacity = 0
		self.contents.font.size = 24
		self.contents.font.name = "黑体" 
		@edge = 16
		setup(actor)
		refresh
	end
	#--------------------------------------------------------------------------
	# ● 设置 actor 是一个monstor
	#
	# 	flag 	: 	0 - defualt, 1 - reset actor only. 
	#
	#--------------------------------------------------------------------------
	def setup(actor, flag = 0)
		# 获得角色
		@actor = actor
		if 1 == flag
			return
		end
		# 设置各个属性
		@lvl = @actor.level
		@money = @actor.money
		@exp = @actor.monstor_exp
	end
	#--------------------------------------------------------------------------
	# ● 重绘
	#--------------------------------------------------------------------------
	def refresh
		# 清除所有窗口内容
		self.contents.clear
		color = getColor("white")
		title_width = 108
		# 等级
		draw_a_line(color, 0, 0, title_width, WLH, "等级: ", 0)
		draw_a_line(color, title_width, 0, self.contents.width/2-title_width, WLH, @lvl.ceil, 0)
		# 金钱
		color = getColor("yellow")
		draw_a_line(color, 0, @edge+WLH, title_width, WLH, "金钱: ", 0)
		draw_a_line(color, title_width, @edge+WLH, self.contents.width/2-title_width, WLH, @money.ceil, 0)
		# 经验
		color = getColor("light red")
		draw_a_line(color, 0, (@edge+WLH)*2, title_width, WLH, "经验: ", 0)
		draw_a_line(color, title_width, (@edge+WLH)*2, self.contents.width/2-title_width, WLH, @exp.ceil, 0)
	end
	#--------------------------------------------------------------------------
	# ● 是否需要重绘?
	#--------------------------------------------------------------------------
	def need_refresh?
		return true if @lvl != @actor.level
		return true if @money != @actor.money
		return true if @exp != @actor.monstro.exp
		return false
	end
	#--------------------------------------------------------------------------
	# ● 刷新
	#--------------------------------------------------------------------------
	def update
		if need_refresh?
			refresh
		end
	end
end


class Window_Consult_Command < Window_Command
  #--------------------------------------------------------------------------
  # ● 定义实例变量
  #--------------------------------------------------------------------------
  attr_reader   :commands                 # 命令
  attr_reader   :item_max
  WLH = 32
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #     width      : 窗口宽
  #     commands   : 命令字符串列表
  #     column_max : 行数 (2 以上横向选择)
  #     row_max    : 列数 (0:与命令数一致)
  #     spacing    : 项目横向的空白空间
  #--------------------------------------------------------------------------
  def initialize(width, commands, column_max = 1, row_max = 0, spacing = 32)
    if row_max == 0
      row_max = (commands.size + column_max - 1) / column_max
    end
    super(width, commands, column_max, row_max, spacing, row_max * WLH + 32)
	self.contents.font.size = 28
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 生成窗口内容
  #--------------------------------------------------------------------------
  def create_contents
    self.contents.dispose
    self.contents = Bitmap.new(width - 32, [height - 32, row_max * WLH].max)
  end
  #--------------------------------------------------------------------------
  # ● 获取行头
  #
  #    本页第第一行的行数（从第0行开始计数）
  #
  #--------------------------------------------------------------------------
  def top_row
    return self.oy / WLH
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
    self.oy = row * WLH
  end
  
  #--------------------------------------------------------------------------
  # ● 获取一页显示的行数
  #--------------------------------------------------------------------------
  def page_row_max
    return (self.height - 32) / WLH
  end
  
  #--------------------------------------------------------------------------
  # ● 获取项目要描画的矩形
  #     index : 项目编号
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new(0, 0, 0, 0)
    rect.width = (contents.width + @spacing) / @column_max - @spacing
    rect.height = WLH
    rect.x = index % @column_max * (rect.width + @spacing)
    rect.y = index / @column_max * WLH
    return rect
  end

end




