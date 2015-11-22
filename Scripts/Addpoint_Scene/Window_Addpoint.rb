##==========================================================================
# ■ Window_Addpoint1
#---------------------------------------------------------------------------
#     本窗口用来显示英雄的详细信息 
#
#===========================================================================
class Window_Addpoint1 < Window_Base
  include GAME_CONF
  WLH = 24
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #--------------------------------------------------------------------------
  def initialize(x,y)
    super(x, y, 410, 370)
    self.opacity = 255
    self.contents.font.size = 20
    @isInit = true
  end
  
  #--------------------------------------------------------------------------
  # ● 配置
  #     actor : 角色(monstor或hero)
  #--------------------------------------------------------------------------
  def setup(actor)
      @hero = actor
      @type = actor.type                   # 英雄的主属性
  #=======以下是描述英雄能力的各个属性====================
      @hmaxhp = Fround(actor.self_maxhp,2)       # 生命
      @hmaxmp = Fround(actor.self_maxmp,2)       # 魔法
      @hatk = Fround(actor.self_atk,2)         # 攻击
      @hdef = Fround(actor.self_def,2)         # 护甲
  
      @strength = Fround(actor.self_strength,2)     # 力量
      @celerity = Fround(actor.self_celerity,2)     # 敏捷
      @wisdom = Fround(actor.self_wisdom,2)       # 智力
  
      @destroy = Fround(actor.self_destroy,2)      # 物理破坏力因子
  
      @mdestroy = Fround(actor.self_mdestroy,2)     # 魔法破坏力因子

      @atkspeed = Fround(actor.self_atkspeed,2)     # 攻速因子
  
      @eva = Fround(actor.self_eva, 2)  # 闪避因子
  
      @hit = Fround(actor.self_hit,2)  # 命中因子
  
      @hpcover = Fround(actor.self_hpcover,2)      # 生命恢复因子
      
      @mpcover = Fround(actor.self_mpcover,2)      # 魔法恢复因子
  

  end 
  #--------------------------------------------------------------------------
  # ● 重新绘制该窗口
  #
  #--------------------------------------------------------------------------
  def refresh
    # 重新配置
    setup(@hero)

    color1 = system_color
    color2 = getColor("white")
    
    draw_a_line(color1, 0,   WLH*0, 90, WLH, "生命:", 0)
    draw_a_line(color2, 90,  WLH*0, 100, WLH, @hmaxhp, 0)
    
    draw_a_line(color1, 0,   WLH*1, 90, WLH, "魔法:",  0)
    draw_a_line(color2, 90,  WLH*1, 100, WLH, @hmaxmp, 0)
    
    draw_a_line(color1, 0,   WLH*2, 90, WLH, "HP恢复:", 0)
    draw_a_line(color2, 90,  WLH*2, 100, WLH, @hpcover, 0)
    
    draw_a_line(color1, 0,   WLH*3, 90, WLH, "MP恢复:",  0)
    draw_a_line(color2, 90,  WLH*3, 100, WLH, @mpcover, 0)
    
    draw_a_line(color1, 0,   WLH*4, 90, WLH, "攻击:", 0)
    draw_a_line(color2, 90,  WLH*4, 100, WLH, @hatk   , 0)
    
    draw_a_line(color1, 0,   WLH*5, 90, WLH, "防御:",  0)
    draw_a_line(color2, 90,  WLH*5, 100, WLH, @hdef, 0)
    
    draw_a_line(color1, 0,   WLH*6, 90, WLH, "力量:",  0)
    draw_a_line(color2, 90,  WLH*6, 100, WLH, @strength, 0)
    
    draw_a_line(color1, 0,   WLH*7, 90, WLH, "智力:",  0)
    draw_a_line(color2, 90,  WLH*7, 100, WLH, @wisdom, 0)
    
    draw_a_line(color1, 0,   WLH*8, 90, WLH, "敏捷:",  0)
    draw_a_line(color2, 90,  WLH*8, 100, WLH, @celerity, 0)

    
    draw_a_line(color1, 0,   WLH*9, 90, WLH, "物理伤害：",  0)
    draw_a_line(color2, 90,  WLH*9, 100, WLH, @destroy, 0) 
        
    draw_a_line(color1, 0,   WLH*10, 90, WLH, "魔法伤害：",  0)
    draw_a_line(color2, 90,  WLH*10, 100, WLH, @mdestroy, 0)

    draw_a_line(color1, 0,   WLH*11, 90, WLH, "攻击速度：",  0)
    draw_a_line(color2, 90,  WLH*11, 100, WLH, @atkspeed, 0)    
    
    draw_a_line(color1, 0,   WLH*12, 90, WLH, "命中技巧：", 0)
    draw_a_line(color2, 90,  WLH*12, 100, WLH, @hit   , 0)
    
    draw_a_line(color1, 0,   WLH*13, 90, WLH, "闪避技巧：",  0)
    draw_a_line(color2, 90,  WLH*13, 100, WLH, @eva, 0)
    
    i = 0
    while i < 14
      draw_a_line(color2, 195,  WLH*i, 10,  WLH, "→", 1)
      i += 1
    end
    
  end
  
  #--------------------------------------------------------------------------
  # ● 更新画面
  #--------------------------------------------------------------------------
  def update
    refresh if @isInit == true
    @isInit = false
  end    
  
end
  
#==============================================================================
# ■ Window_Addpoint2
#------------------------------------------------------------------------------
# 　左边显示加点选项的窗口
#==============================================================================

class Window_Addpoint2 < Window_Command
  
  include GAME_CONF
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #--------------------------------------------------------------------------
  def initialize(width, commands)
    super(width, commands)
    refresh
  end  
  
  #--------------------------------------------------------------------------
  # ● 刷新
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.font.size = 22
    for i in 0...@item_max
      draw_item(i)
    end
  end  
  
end
  
