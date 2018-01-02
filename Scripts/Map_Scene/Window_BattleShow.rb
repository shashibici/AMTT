#
#   本文件貌似已经废弃
#
##==========================================================================
# ■ Window_BattleShow1
#---------------------------------------------------------------------------
#     专门显示头像、名字、等级三个项目 
#     两个角色，共计6项目　
#
#===========================================================================
class Window_BattleShow1 < Window_Base
  include GAME_CONF
  WLH = 24      # 每行字的高度
  RW = 8        # 每一个项目之间的间隔
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #--------------------------------------------------------------------------
  def initialize(x,y)
    super(x, y, 644, 100)
    self.opacity = 0
    self.z = GAME_CONF::BATTLE_WINDOW1
    self.contents.font.size = 20
    @edge = 0
    @face_size = 64
    @isInit = true
  end 
  #--------------------------------------------------------------------------
  # ● 配置
  #     actor  : 角色(hero对象)
  #     actor2 : 怪物(monstor对象)
  #--------------------------------------------------------------------------
  def setup(actor, actor2)
    
    # 获得角色
    @actor = actor
    @actor2 = actor2
    
    # 头像索引
    @actor_face = actor.face_name 
    @actor_face_index = actor.face_index
    @actor_monstor_face = actor2.battler_name 
    
    # 名字
    @name = @actor.name
    @name2 = @actor2.name
    
    # 等级
    @lvl = @actor.level
    @lvl2 = @actor2.level
  end  
  #--------------------------------------------------------------------------
  # ● 重新绘制该窗口
  #
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear

    # 重新获取数据
    
    # 头像索引
    @actor_face = @actor.face_name 
    @actor_face_index = @actor.face_index
    @actor_monstor_face = @actor2.character_name 
    
    # 名字
    @name = @actor.name
    @name2 = @actor2.name
    # 等级
    @lvl  = @actor.level
    @lvl2 = @actor2.level
    

    #-------------描绘角色--------------------------
    # 描绘脸部
    bitmap = Cache.face(@actor_face)
    rect = Rect.new(0, 0, 0, 0)
    rect.x = @actor_face_index % 4 * 96 + (96 - @face_size) / 2
    rect.y = @actor_face_index / 4 * 96 + (96 - @face_size) / 2
    rect.width = @face_size
    rect.height = @face_size
    self.contents.blt(self.width / 2-15, @edge, bitmap, rect)
    bitmap.dispose
    
    # 描绘名字
    color = Color.new(255, 255, 255)
    draw_a_line(color, self.width / 2-15 + @face_size + RW, @edge, 108, WLH, @name, 1)
    
    # 描绘等级，名字右边
    color = system_color
    draw_a_line(color, self.width / 2-15 + @face_size + 108 + RW , @edge, 40, WLH, "等级", 1)
    color = Color.new(255,255,255)
    draw_a_line(color, self.width / 2-15 + @face_size + 108 + 40 + RW, @edge, 60, WLH, @lvl, 1)
    
    #--------------描绘怪物-------------------------
    # 描绘脸部
    bitmap = Cache.battler(@actor_monstor_face, 0)
    rect = Rect.new(0, 0, 0, 0)
    rect.x = 0
    rect.y = 0
    rect.width = 32
    rect.height = 32
    self.contents.blt(16, @edge+16, bitmap, rect)
    bitmap.dispose
    
    # 描绘名字
    color = Color.new(255, 255, 255)
    draw_a_line(color, @face_size, @edge, 108, WLH, @name2, 1)
    
    # 描绘等级，名字右边
    color = system_color
    draw_a_line(color,  @face_size + 108, @edge, 40, WLH, "等级", 1)
    color = Color.new(255,255,255)
    draw_a_line(color,  @face_size + 108 + 40, @edge, 60, WLH, @lvl2, 1)
  end  
  
  #--------------------------------------------------------------------------
  # ● 判断是否需要重新获取数据
  #--------------------------------------------------------------------------
  def need_refresh?
    return true if @isInit
    return true if @lvl  != @actor.level
    return true if @lvl2 != @actor2.level
    return true if @name != @actor.name
    return true if @name2 != @actor2.name
    return true if @actor_face != @actor.face_name 
    return true if @actor_face_index != @actor.face_index
    return true if @actor_monstor_face != @actor2.character_name 
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
      @isInit = false
    end
  end  
  
end
##==============================================================================
# ■ Window_BattleShow2
#------------------------------------------------------------------------------
#     专门显示生命、魔法值
#==============================================================================

class Window_BattleShow2 < Window_Base
  WLH = 20      # 每行字的高度
  RW = 8        # 每一个项目之间的间隔
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #--------------------------------------------------------------------------
  def initialize(x,y)
    super(x, y, 282, 80)
    self.opacity = 0
    self.z = GAME_CONF::BATTLE_WINDOW2
    self.contents.font.size = 18
    @edge = 0
    @face_size = 64
    @isInit = true
  end   
  #--------------------------------------------------------------------------
  # ● 配置
  #     actor  : 角色(hero对象)
  #--------------------------------------------------------------------------
  def setup(actor)
    
    # 获得角色
    @actor = actor
    
    # 最大值
    @maxhp = actor.maxhp
    @maxmp = actor.maxmp
    
    # 当前值
    @hp = @actor.hp
    @mp = @actor.mp
	
	# 血条效果
	@current_upper = @actor.current_upper
  end  
  #--------------------------------------------------------------------------
  # ● 重新绘制该窗口
  #
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear

    # 重新获取数据
    
    # 最大值
    @maxhp = @actor.maxhp
    @maxmp = @actor.maxmp
    
    # 当前值
    @hp = @actor.hp
    @mp = @actor.mp
	
	@current_upper = @actor.current_upper
    

    # 描绘HP槽-------------------------------------
    rate = @hp / @maxhp
    gw = Integer(230 * rate)
    if rate > 0.5
      gc1 = Color.new(Integer(255*(1-rate*2)),255,0)
    else
      gc1 = Color.new(255,Integer(255*rate*2),0)
    end
    gc2 = Color.new(0,0,0)
	# 绘制失血效果槽
	p @current_upper
	rate = @current_upper / @maxhp
	gc3 = Color.new(255,255,255)
	gw3 = Integer(230 * rate)
    
    # 填满指定的颜色
    self.contents.fill_rect(0, WLH - 8, 230, 6, gc2) # 黑色背景
	self.contents.fill_rect(0, WLH - 8, gw3, 6, gc3) # 白色失血效果
    self.contents.fill_rect(0, WLH - 8, gw, 6, gc1)  # 血条
    
    # 绘制文字
    self.contents.font.color = system_color
    self.contents.draw_text(0, 0, 30, WLH, "生命")
    xr = 230
    # 计算hp的长度
    if @hp > 9 and @hp <= 99
      bk1 = 5
    elsif @hp > 99 and @hp <= 999
      bk1 = 6
    elsif @hp > 999 and @hp <= 9999
      bk1 = 7
    elsif @hp > 9999 and @hp <= 99999
      bk1 = 8
    elsif @hp > 99999 and @hp <= 999999
      bk1 = 9
    elsif @hp > 999999 and @hp <= 9999999
      bk1 = 10
    elsif @hp > 9999999 
      bk1 = 11
    else 
      bk1 = 4
    end  
    # 计算maxhp的长度
    if @maxhp > 9 and @maxhp <= 99
      bk2 = 5
    elsif @maxhp > 99 and @maxhp <= 999
      bk2 = 6
    elsif @maxhp > 999 and @maxhp <= 9999
      bk2 = 7
    elsif @maxhp > 9999 and @maxhp <= 99999
      bk2 = 8
    elsif @maxhp > 99999 and @maxhp <= 999999
      bk2 = 9
    elsif @maxhp > 999999 and @maxhp <= 9999999
      bk2 = 10
    elsif @maxhp > 9999999
      bk2 = 11
    else 
      bak2 = 4
    end  
    
    if bk1 + bk2 + 1 >= 23
  	  self.contents.font.color = gc1
      self.contents.draw_text(xr - 190, 0, 90, WLH, "?????????", 2)
      self.contents.draw_text(xr - 100, 0, 10, WLH, "/", 2)
      self.contents.draw_text(xr - 90,  0, 90, WLH, "?????????", 2)
    else
    
      self.contents.font.color = gc1
      self.contents.draw_text(xr - 10*(bk1+bk2+1), 0, bk1*10, WLH, Fround(@hp,1), 2)
      self.contents.draw_text(xr - 10*(bk2+1),     0, 10, WLH, "/", 2)
      self.contents.draw_text(xr - 10*bk2,         0, bk2*10, WLH, Fround(@maxhp,1), 2)
    end
    
    
    # 描绘MP槽----------------------------------------
    rate = @mp / @maxmp
    gw = Integer(230 * rate)
    if rate > 0.5
      gc1 = Color.new(Integer(255*(1-rate*2)),255,0)
    else
      gc1 = Color.new(255,Integer(255*rate*2),0)
    end
    gc2 = Color.new(0,0,0)
    
    # 填满指定的颜色
    self.contents.fill_rect(0, WLH*2 - 8, 230, 6, gc2)
    self.contents.fill_rect(0, WLH*2 - 8, gw, 6, gc1) 
    
    # 绘制文字
    self.contents.font.color = system_color
    self.contents.draw_text(0, WLH, 30, WLH, "Pow")
    xr = 230
    # 计算mp的长度
    if @mp > 9 and @mp <= 99
      bk1 = 5
    elsif @mp > 99 and @mp <= 999
      bk1 = 6
    elsif @mp > 999 and @mp <= 9999
      bk1 = 7
    elsif @mp > 9999 and @mp <= 99999
      bk1 = 8
    elsif @mp > 99999 and @mp <= 999999
      bk1 = 9
    elsif @mp > 999999 and @mp <= 9999999
      bk1 = 10
    elsif @mp > 9999999 
      bk1 = 11
    else
      bk1 = 4
    end  
    # 计算maxhp的长度
    if @maxmp > 9 and @maxmp <= 99
      bk2 = 5
    elsif @maxmp > 99 and @maxmp <= 999
      bk2 = 6
    elsif @maxmp > 999 and @maxmp <= 9999
      bk2 = 7
    elsif @maxmp > 9999 and @maxmp <= 99999
      bk2 = 8
    elsif @maxmp > 99999 and @maxmp <= 999999
      bk2 = 9
    elsif @maxmp > 999999 and @maxmp <= 9999999
      bk2 = 10
    elsif @maxmp > 9999999 
      bk2 = 11
    else
      bk2 = 4
    end    
    
    
    if bk1 + bk2 + 1 >= 23
  	  self.contents.font.color = gc1
      self.contents.draw_text(xr - 190, 0, 90, WLH, "?????????", 2)
      self.contents.draw_text(xr - 100, 0, 10, WLH, "/", 2)
      self.contents.draw_text(xr - 90,  0, 90, WLH, "?????????", 2)
    else
      
      self.contents.font.color = gc1
      self.contents.draw_text(xr - 10*(bk1+bk2+1), WLH, bk1*10, WLH, Fround(@mp,1), 2)
      self.contents.draw_text(xr - 10*(bk2+1),     WLH, 10, WLH, "/", 2)
      self.contents.draw_text(xr - 10*bk2,         WLH, bk2*10, WLH, Fround(@maxmp,1), 2)
    end
  end    
  #--------------------------------------------------------------------------
  # ● 判断是否需要重新获取数据
  #--------------------------------------------------------------------------
  def need_refresh?
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
      @isInit = false
    end
  end   
end

##==============================================================================
# ■ Window_BattleShow3
#------------------------------------------------------------------------------
#     专门显示 其余的属性
#==============================================================================

class Window_BattleShow3 < Window_Base
  include GAME_CONF
  WLH = 22
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #--------------------------------------------------------------------------
  def initialize(x,y)
    super(x, y, 322, 100)
    self.opacity = 0
    self.z = GAME_CONF::BATTLE_WINDOW2
    self.contents.font.size = 18
    @edge = 0
    @face_size = 64
    @isInit = true
  end
  #--------------------------------------------------------------------------
  # ● 配置
  #     actor  : 角色(hero对象)
  #--------------------------------------------------------------------------
  def setup(actor)
    
    # 获得角色
    @actor = actor
    
    # 攻击
    @atk = @actor.atk
    
    # 护甲
    @def = @actor.def
    
    # 伤害
    @destroy = @actor.final_destroy
    
    # 最终攻速
    @atkspeed = @actor.final_atkspeed
    
    # 命中——最终命中
    @hit = @actor.final_hit
    
    # 闪避——最终闪避
    @eva = @actor.final_eva
  end   
  #--------------------------------------------------------------------------
  # ● 重新绘制该窗口
  #
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear

    # 重新获取数据
    
    # 攻击
    @atk = @actor.atk
    # 护甲
    @def = @actor.def
    # 最终攻速
    @atkspeed = @actor.final_atkspeed
    # 命中——最终命中
    @hit = @actor.final_hit
    # 闪避——最终闪避
    @eva = @actor.final_eva
    
    
    color1 = Color.new(255, 255, 255)
    color2 = Color.new(0,   255, 0)
    #-------------描绘数据--------------------------
    # 描绘攻击
    draw_a_line(color1, 0,   0, 50, WLH, "攻击", 0)
    draw_a_line(color2, 50,  0, 50, WLH,  Fround(@atk,2), 2)
    
    # 描绘护甲
    draw_a_line(color1, 0,  WLH, 50, WLH, "防御", 0)
    draw_a_line(color2, 50, WLH, 50, WLH, Fround(@def,2), 2)
    
    # 描绘攻速
    draw_a_line(color1, 0,  WLH*2, 50, WLH, "攻速", 0)
    draw_a_line(color2, 50, WLH*2, 50, WLH, Fround(@atkspeed,2), 2)
    
    # 描绘伤害
    draw_a_line(color1, 160,   0, 50, WLH, "伤害", 0)
    draw_a_line(color2, 210,   0, 50, WLH,  Fround(@destroy,2), 2)    
    
    # 描绘命中
    draw_a_line(color1, 160,   WLH, 50, WLH, "命中", 0)
    draw_a_line(color2, 210,   WLH, 50, WLH,  Fround(@hit,2), 2)
    
    # 描绘闪避
    draw_a_line(color1, 160,  WLH*2, 50, WLH, "闪避", 0)
    draw_a_line(color2, 210,  WLH*2, 50, WLH, Fround(@eva,2), 2)
    

    
  end  
  #--------------------------------------------------------------------------
  # ● 判断是否需要重新获取数据
  #--------------------------------------------------------------------------
  def need_refresh?
    return true if @isInit
    return true if @atk  != @actor.atk
    return true if @def != @actor.def
    return true if @eva != @actor.final_eva
    return true if @hit != @actor.final_hit 
    return true if @atkspeed != @actor.final_atkspeed
    return true if @destroy != @actor.final_destroy
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
      @isInit = false
    end
  end 
  
end
















