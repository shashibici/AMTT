#==========================================================================
# ■ Window_EquipStatus1
#---------------------------------------------------------------------------
# 	本窗口用来显示角色头像、角色名字
#===========================================================================
class Window_EquipStatus1 < Window_Base
  include GAME_CONF
  WLH = 24      # 每行字的高度
  RW = 8
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #--------------------------------------------------------------------------
  def initialize(x,y,actor)
    super(x, y, 160+32, 96+32) # x, y, 192, 128
    self.contents.font.size = 20
	self.contents.font.name = "华文细黑"
	self.opacity = 0
    @face_size = 96
	@pic_size = 64
	@edge = 0
    setup(actor)
    @isInit = true
  end
  #--------------------------------------------------------------------------
  # ● 配置
  #     actor  : 角色(hero对象)
  #  	flag   : 0 defualt all, 3 only refresh actor
  #--------------------------------------------------------------------------
  def setup(actor, flag = 0)
	  # 获得角色
    @actor = actor
	if 0 != flag
		return
	end
    # 头像索引
    @actor_face = actor.face_name 
    @actor_face_index = actor.face_index
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
	dst_rect = Rect.new(0,0,@pic_size,@pic_size)
    bitmap = Cache.face(@actor_face)
    rect = Rect.new(0, 0, 0, 0)
    rect.x = @actor_face_index % 4 * 96 + (96 - @face_size) / 2
    rect.y = @actor_face_index / 4 * 96 + (96 - @face_size) / 2
    rect.width = @face_size
    rect.height = @face_size
	# dst_src, src_bitmap, src_rect of src_bitmap. 
	self.contents.stretch_blt(dst_rect, bitmap, rect)
    bitmap.dispose
    # 描绘名字(72+108=180)
	self.contents.font.size = 24
	self.contents.font.name = "黑体"
    color = Color.new(255, 255, 255)
    draw_a_line(color, @edge, @pic_size + RW, 64, WLH, @name, 1) 
	# 描绘攻、防、力、敏
	self.contents.font.size = 18
	color = getColor("light purple")
	draw_a_line(color, @pic_size + RW, @edge, 32, WLH, "攻: ", 0)
	draw_a_line(color, @pic_size + RW+32, @edge, self.width-32-@pic_size-RW-32, WLH, @atk.ceil.to_s, 0)
	color = getColor("light blue")
	draw_a_line(color, @pic_size + RW, @edge+WLH, 32, WLH, "防: ", 0)
	draw_a_line(color, @pic_size + RW+32, @edge+WLH, self.width-32-@pic_size-RW-32, WLH, @ddef.ceil.to_s, 0)
	color = getColor("red")
	draw_a_line(color, @pic_size + RW, @edge+WLH*2, 32, WLH, "力: ", 0)
	draw_a_line(color, @pic_size + RW+32, @edge+WLH*2, self.width-32-@pic_size-RW-32, WLH, @strength.ceil.to_s, 0)
	color = getColor("light green")
	draw_a_line(color, @pic_size + RW, @edge+WLH*3, 32, WLH, "敏: ", 0)
	draw_a_line(color, @pic_size + RW+32, @edge+WLH*3, self.width-32-@pic_size-RW-32, WLH, @celerity.ceil.to_s, 0)
  end    
  #--------------------------------------------------------------------------
  # ● 判断是否需要重新获取数据
  #--------------------------------------------------------------------------
  def need_refresh?
    return true if @isInit
    return true if @name != @actor.name
    return true if @actor_face != @actor.face_name 
    return true if @actor_face_index != @actor.face_index
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
# ■ Window_EquipStatus2
#---------------------------------------------------------------------------
# 	主要显示生命， 和其他不经常更新的东西，分开更新
#===========================================================================
class Window_EquipStatus2 < Window_Base
  WLH = 22      # 每行字的高度
  RW = 8        # 每一个项目之间的间隔
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #--------------------------------------------------------------------------
  def initialize(x,y,actor, w = 160+32, h = 256+32)
    super(x, y, w, h)
    self.opacity = 0
    self.contents.font.size = 19
	self.contents.font.name = "黑体" 
	@gw_width = w - 32
    @edge = 0
    @isInit = true
	@info_sprite = Sprite.new
	@info_sprite.bitmap = Bitmap.new(w - 16, h - 32 - WLH*2)
	@info_sprite.x = self.x + 16
	@info_sprite.y = self.y + 16 + WLH*2
	@info_sprite.bitmap.font.size = 18
	@info_sprite.bitmap.font.name = "华文细黑"
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
	tmp_content.font.color = getColor("light gray")
	@info_sprite.bitmap.draw_text(0, 0, 80, WLH, "生命恢复:")
	@info_sprite.bitmap.draw_text(80, 0, tmp_content.width-80, WLH, @hpcover.ceil.to_s, 0)
	tmp_content.font.color = getColor("heavy orange")
	@info_sprite.bitmap.draw_text(0, WLH, 80, WLH, "物理伤害:")
	@info_sprite.bitmap.draw_text(80, WLH, tmp_content.width-80, WLH, @destroy.ceil.to_s, 0)
	@info_sprite.bitmap.draw_text(0, WLH*2, 80, WLH, "物伤威力:")
	@info_sprite.bitmap.draw_text(80, WLH*2, tmp_content.width-80, WLH, Fround(@destroyrate,1).to_s+"%", 0)
	
	tmp_content.font.color = getColor("light yellow")
	@info_sprite.bitmap.draw_text(0, WLH*3, 80, WLH, "暴击技巧:")
	@info_sprite.bitmap.draw_text(80, WLH*3, tmp_content.width-80, WLH, @bom.ceil.to_s, 0)
	@info_sprite.bitmap.draw_text(0, WLH*4, 80, WLH, "暴击威力:")
	@info_sprite.bitmap.draw_text(80, WLH*4, tmp_content.width-80, WLH, Fround(@bomatk,1).to_s+"%", 0)
	
	tmp_content.font.color = getColor("light purple")
	@info_sprite.bitmap.draw_text(0, WLH*5, 80, WLH, "攻击速度:")
	@info_sprite.bitmap.draw_text(80, WLH*5, tmp_content.width-80, WLH, @atkspeed.ceil.to_s, 0)
	@info_sprite.bitmap.draw_text(0, WLH*6, 80, WLH, "攻击频率:")
	@info_sprite.bitmap.draw_text(80, WLH*6, tmp_content.width-80, WLH, Fround(@atkrate,1).to_s+"%", 0)
	
	tmp_content.font.color = getColor("light blue")
	@info_sprite.bitmap.draw_text(0, WLH*7, 80, WLH, "命中技巧:")
	@info_sprite.bitmap.draw_text(80, WLH*7, tmp_content.width-80, WLH, @hit.ceil.to_s, 0)
	@info_sprite.bitmap.draw_text(0, WLH*8, 80, WLH, "闪避技巧:")
	@info_sprite.bitmap.draw_text(80, WLH*8, tmp_content.width-80, WLH, @eva.ceil.to_s, 0)
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
    self.contents.fill_rect(0, WLH - 8, @gw_width, 6, gc2)
    self.contents.fill_rect(0, WLH - 8, gw, 6, gc1)
    
    # 绘制文字
    self.contents.font.color = getColor("red")
    self.contents.draw_text(0, 0, 20, WLH, "HP")
	self.contents.draw_text(15, 0, @gw_width-15, WLH, @hp.ceil.to_s+"/"+@maxhp.ceil.to_s, 2)

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
