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
    super(x, y, 64+8, 96+8)
    self.contents.font.size = 20
    @face_size = 96
	@edge = 1
    setup(actor)
    @isInit = true
  end 
  #--------------------------------------------------------------------------
  # ● 配置
  #     actor  : 角色(hero对象)
  #     actor2 : 怪物(monstor对象)
  #--------------------------------------------------------------------------
  def setup(actor)
    # 获得角色
    @actor = actor
    # 头像索引
    @actor_face = actor.face_name 
    @actor_face_index = actor.face_index
    # 名字
    @name = @actor.name
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
    bitmap = Cache.face(@actor_face)
    rect = Rect.new(0, 0, 0, 0)
    rect.x = @actor_face_index % 4 * 96 + (96 - @face_size) / 2
    rect.y = @actor_face_index / 4 * 96 + (96 - @face_size) / 2
    rect.width = @face_size
    rect.height = @face_size
    self.contents.blt(-8, -8, bitmap, rect)
    bitmap.dispose
    # 描绘名字(72+108=180)
    color = Color.new(255, 255, 255)
    draw_a_line(color, @face_size + RW, @edge, 64, WLH, @name, 1)  
  end    
  #--------------------------------------------------------------------------
  # ● 判断是否需要重新获取数据
  #--------------------------------------------------------------------------
  def need_refresh?
    return true if @isInit
    return true if @name != @actor.name
    return true if @actor_face != @actor.face_name 
    return true if @actor_face_index != @actor.face_index
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
# 	显示角色 攻击、防御、力量、敏捷
#===========================================================================
class Window_EquipStatus2 < Window_Base
  WLH = 19      # 每行字的高度
  RW = 8        # 每一个项目之间的间隔
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #--------------------------------------------------------------------------
  def initialize(x,y,actor)
    super(x, y, 380, 80)
    self.opacity = 0
    self.contents.font.size = 18
    @edge = 0
    @face_size = 64
    @isInit = true
    setup(actor)
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
    

    # 描绘HP槽-------------------------------------
    rate = @hp / @maxhp
    gw = Integer(340 * rate)
    if rate > 0.5
      gc1 = Color.new(Integer(255*(1-rate*2)),255,0)
    else
      gc1 = Color.new(255,Integer(255*rate*2),0)
    end
    gc2 = Color.new(0,0,0)
    
    # 填满指定的颜色
    self.contents.fill_rect(0, WLH - 8, 230, 6, gc2)
    self.contents.fill_rect(0, WLH - 8, gw, 6, gc1)
    
    # 绘制文字
    self.contents.font.color = system_color
    self.contents.draw_text(0, 0, 30, WLH, "生命")
    xr = 340
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
      self.contents.draw_text(xr - 10*(bk1+bk2+1), 0, bk1*10, WLH, Fround(@hp,2), 2)
      self.contents.draw_text(xr - 10*(bk2+1),     0, 10, WLH, "/", 2)
      self.contents.draw_text(xr - 10*bk2,         0, bk2*10, WLH, Fround(@maxhp,2), 2)
    end
    
    
    # 描绘MP槽----------------------------------------
    rate = @mp / @maxmp
    gw = Integer(340 * rate)
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
    xr = 340
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
      self.contents.draw_text(xr - 10*(bk1+bk2+1), WLH, bk1*10, WLH, Fround(@mp,2), 2)
      self.contents.draw_text(xr - 10*(bk2+1),     WLH, 10, WLH, "/", 2)
      self.contents.draw_text(xr - 10*bk2,         WLH, bk2*10, WLH, Fround(@maxmp,2), 2)
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



#==========================================================================
# ■ Window_EquipStatus3
#---------------------------------------------------------------------------
#     本窗口用来显示角色更换装备后的信息，修改自Window_Consult1
#
#   显示角色：maxhp maxmp hpcover mpcover atk def strength wisdom celerity
#             destroy destroyrate mdestroy mdestroyrate 13项
#
#===========================================================================
class Window_EquipStatus3 < Window_Base
  include GAME_CONF
  WLH = 22
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #--------------------------------------------------------------------------
  def initialize(x,y,actor)
    super(x, y, 410, 580)
    self.opacity = 0
    self.contents.font.size = 18
    @isInit = true
    setup(actor)
  end
  
  #--------------------------------------------------------------------------
  # ● 配置
  #     actor : 角色(monstor或hero)
  #--------------------------------------------------------------------------
  def setup(actor)
  
      @actor = actor
  #=======以下是描述英雄能力的各个属性====================
  
      @hmaxhp = actor.maxhp       # 生命
      @hmaxmp = actor.maxmp       # 魔法
      @hpcover = actor.final_hpcover      # 生命恢复因子
      @mpcover = actor.final_mpcover      # 魔法恢复因子
      
      @hatk = actor.atk         # 攻击
      @hdef = actor.def         # 护甲
  
      @strength = actor.final_strength     # 力量
      @wisdom = actor.final_wisdom       # 智力
      @celerity = actor.final_celerity     # 敏捷  
 

      
     
      
      # 配置好了之后还要配置参数
      set_new_parameters(nil,nil,nil,nil,nil,nil,nil,nil,nil)
      
      

  end 
  #--------------------------------------------------------------------------
  # ● 设置新的参数
  #
  #--------------------------------------------------------------------------
  def set_new_parameters(\
            hmaxhp,\
            hmaxmp,\
            hpcover,\
            mpcover,\
            hatk,\
            hdef,\
            strength,\
            wisdom,\
            celerity)

          @hmaxhpn = hmaxhp
          @hmaxmpn =   hmaxmp
          @hpcovern = hpcover
          @mpcovern = mpcover
          
          @hatkn =   hatk
          @hdefn =   hdef
          @strengthn =   strength
          @wisdomn =   wisdom
          @celerityn = celerity

          refresh  
    
  end  
  #--------------------------------------------------------------------------
  # ● 重新绘制该窗口
  #
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    
      @hmaxhp = @actor.maxhp       # 生命
      @hmaxmp = @actor.maxmp       # 魔法
      @hpcover = @actor.final_hpcover      # 生命恢复因子
      @mpcover = @actor.final_mpcover      # 魔法恢复因子
      
      @hatk = @actor.atk         # 攻击
      @hdef = @actor.def         # 护甲
  
      @strength = @actor.final_strength     # 力量
      @celerity = @actor.final_celerity     # 敏捷
      @wisdom = @actor.final_wisdom       # 智力
  

    
    
    
    color1 = system_color
    color2 = Color.new(255,255,255)
    

    draw_a_line(color1, 0,   WLH*1, 90, WLH, "生命：", 0)
    draw_a_line(color2, 90,  WLH*1, 100, WLH, Fround(@hmaxhp,2)   , 0)
    
    draw_a_line(color1, 0,   WLH*2, 90, WLH, "魔法：",  0)
    draw_a_line(color2, 90,  WLH*2, 100, WLH, Fround(@hmaxmp,2), 0)
    
    draw_a_line(color1, 0,   WLH*3, 90, WLH, "生命恢复：", 0)
    draw_a_line(color2, 90,  WLH*3, 100, WLH, Fround(@hpcover,3)   , 0)
    
    draw_a_line(color1, 0,   WLH*4, 90, WLH, "魔法恢复：",  0)
    draw_a_line(color2, 90,  WLH*4, 100, WLH, Fround(@mpcover,3), 0)
    
    draw_a_line(color1, 0,   WLH*5, 90, WLH, "攻击：", 0)
    draw_a_line(color2, 90,  WLH*5, 100, WLH, Fround(@hatk,2)   , 0)
    
    draw_a_line(color1, 0,   WLH*6, 90, WLH, "防御：",  0)
    draw_a_line(color2, 90,  WLH*6, 100, WLH, Fround(@hdef,2), 0)
    
    draw_a_line(color1, 0,   WLH*7, 90, WLH, "力量：",  0)
    draw_a_line(color2, 90,  WLH*7, 100, WLH, Fround(@strength,2), 0)
    
    draw_a_line(color1, 0,   WLH*8, 90, WLH, "智力：",  0)
    draw_a_line(color2, 90,  WLH*8, 100, WLH, Fround(@wisdom,2), 0)
    
    draw_a_line(color1, 0,   WLH*9, 90, WLH, "敏捷：",  0)
    draw_a_line(color2, 90,  WLH*9, 100, WLH, Fround(@celerity,2), 0)
    
    i = 1
    while i <= 9
      draw_a_line(color2, 195,  WLH*i, 10,  WLH, "→", 1)
      i += 1
    end
    
    draw_extra_paramater(205, WLH, 100, WLH, 2)
  end

  #--------------------------------------------------------------------------
  # ● 清除额外窗口的数值
  #
  #--------------------------------------------------------------------------
  def clearextras
          @hmaxhpn = nil
          @hmaxmpn =   nil
          @hpcovern = nil
          @mpcovern = nil
          @hatkn =   nil
          @hdefn =   nil
          @strengthn =   nil
          @wisdomn =   nil
          @celerityn = nil

          refresh
  end
  
  #--------------------------------------------------------------------------
  # ● 获取装备变更后的能力值描绘色
  #
  #--------------------------------------------------------------------------
  def draw_extra_paramater(x, y, width, height, align = 2)
    if @hmaxhpn != nil
      self.contents.font.color = new_parameter_color(@hmaxhp, @hmaxhpn)
      self.contents.draw_text(x, y, width, height, Fround(@hmaxhpn,2), 2)
    end
    
    if @hmaxmpn  != nil
      self.contents.font.color = new_parameter_color(@hmaxmp, @hmaxmpn )
      self.contents.draw_text(x, y+WLH, width, height,  Fround(@hmaxmpn,2) , 2)
    end
    
    if @hpcovern != nil
      self.contents.font.color = new_parameter_color(@hpcover, @hpcovern)
      self.contents.draw_text(x, y+WLH*2, width, height, Fround(@hpcovern,3), 2)
    end
    
    if @mpcovern  != nil
      self.contents.font.color = new_parameter_color(@mpcover, @mpcovern )
      self.contents.draw_text(x, y+WLH*3, width, height,  Fround(@mpcovern,3) , 2)
    end
    
    if @hatkn  != nil
      self.contents.font.color = new_parameter_color(@hatk, @hatkn )
      self.contents.draw_text(x, y+WLH*4, width, height,  Fround(@hatkn,2) , 2)
    end
    
    if @hdefn  != nil
      self.contents.font.color = new_parameter_color(@hdef, @hdefn )
      self.contents.draw_text(x, y+WLH*5, width, height,  Fround(@hdefn,2) , 2)
    end
    
    if @strengthn  != nil
      self.contents.font.color = new_parameter_color(@strength, @strengthn )
      self.contents.draw_text(x, y+WLH*6, width, height,  Fround(@strengthn,2) , 2)
    end
    
    if @wisdomn  != nil
      self.contents.font.color = new_parameter_color(@wisdom, @wisdomn )
      self.contents.draw_text(x, y+WLH*7, width, height, Fround(@wisdomn,2) , 2)
    end
    
    if @celerityn  != nil
      self.contents.font.color = new_parameter_color(@celerity, @celerityn )
      self.contents.draw_text(x, y+WLH*8, width, height,  Fround(@celerityn,2) , 2)
    end
    

    
    
  end
  #--------------------------------------------------------------------------
  # ● 获取装备变更后的能力值描绘色
  #     old_value : 装備変更前の能力値
  #     new_value : 装備変更後の能力値
  #
  #       重定义
  #
  #--------------------------------------------------------------------------
  def new_parameter_color(old_value, new_value)
    if new_value > old_value      # 变强
      return Color.new(0,255,0)
    elsif new_value == old_value  # 没有变化
      return Color.new(255,255,255)
    else                          # 变弱
      return Color.new(255,0,0)
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



#==========================================================================
# ■ Window_EquipStatus4
#---------------------------------------------------------------------------
#     本窗口用来显示角色更换装备后的信息，修改自Window_Consult1
#
#   显示角色：atkspeed atkrate bom bomrate bomatk hit hitrate eva evarate 9项
# 
#
#===========================================================================
class Window_EquipStatus4 < Window_Base
  include GAME_CONF
  WLH = 20
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #--------------------------------------------------------------------------
  def initialize(x,y,actor)
    super(x, y, 410, 580)
    self.opacity = 0
    self.contents.font.size = 18
    @isInit = true
    setup(actor)
  end
  
  #--------------------------------------------------------------------------
  # ● 配置
  #     actor : 角色(monstor或hero)
  #--------------------------------------------------------------------------
  def setup(actor)
  
      @actor = actor
  #=======以下是描述英雄能力的各个属性====================
      @destroy = actor.base_destroy              # 物理破坏力因子
      @destroyrate = actor.final_destroyrate     # 物理破坏额外倍数（%）
  
      @mdestroy = actor.base_mdestroy            # 魔法破坏力因子
      @mdestroyrate = actor.final_mdestroyrate   # 魔法破坏额外倍数（%）
  
      @atkspeed = actor.base_atkspeed           # 攻速因子
      @atkrate = actor.final_atkrate             # 攻速率
  
      @eva = actor.final_eva                     # 闪避因子
      @evarate = actor.final_evarate             # 闪避率
  
      @bom = actor.final_bom                     # 暴击因子
      @bomrate = actor.final_bomrate             # 暴击率
      @bomatk = actor.final_bomatk               # 暴击扩张倍数（%）
  
      @hit = actor.final_hit                     # 命中因子
      @hitrate = actor.final_hitrate             # 命中率


      
      # 配置好了之后还要配置参数
      set_new_parameters(nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil)

  end 
  #--------------------------------------------------------------------------
  # ● 设置新的参数
  #
  #--------------------------------------------------------------------------
  def set_new_parameters(\
            destroyrate,\
            destroy,\
            mdestroyrate,\
            mdestroy,\
            atkrate,\
            atkspeed,\
            hit,\
            hitrate,\
            eva,\
            evarate,\
            bom, bomrate, bomatk)

          @destroyn = destroy
          @destroyraten = destroyrate
          @mdestroyn = mdestroy
          @mdestroyraten = mdestroyrate
          @atkraten  = atkrate
          @atkspeedn = atkspeed
          @hitn = hit
          @hitraten = hitrate
          @evan = eva
          @evaraten = evarate
          @bomn = bom
          @bomraten = bomrate
          @bomatkn = bomatk
            
          refresh  
    
  end  
  #--------------------------------------------------------------------------
  # ● 重新绘制该窗口
  #
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    
  #=======以下是描述英雄能力的各个属性====================
      @destroy = @actor.base_destroy              # 物理破坏力因子
      @destroyrate = @actor.final_destroyrate     # 物理破坏额外倍数（%）
  
      @mdestroy = @actor.base_mdestroy            # 魔法破坏力因子
      @mdestroyrate = @actor.final_mdestroyrate   # 魔法破坏额外倍数（%）
  
      @atkspeed = @actor.base_atkspeed           # 攻速因子
      @atkrate = @actor.final_atkrate             # 攻速率
  
      @eva = @actor.final_eva                     # 闪避因子
      @evarate = @actor.final_evarate             # 闪避率
  
      @bom = @actor.final_bom                     # 暴击因子
      @bomrate = @actor.final_bomrate             # 暴击率
      @bomatk = @actor.final_bomatk               # 暴击扩张倍数（%）
  
      @hit = @actor.final_hit                     # 命中因子
      @hitrate = @actor.final_hitrate             # 命中率

      
    color1 = system_color#Color.new(255,255,0)
    color2 = Color.new(255,255,255)
    
    draw_a_line(color1, 0,   WLH*1, 90, WLH, "物伤威力：", 0)
    draw_a_line(color2, 90,  WLH*1, 100, WLH, Fround(@destroyrate,2).to_s+"﹪", 0)
    
    draw_a_line(color1, 0,   WLH*2, 90, WLH, "物理伤害：",  0)
    draw_a_line(color2, 90,  WLH*2, 100, WLH, Fround(@destroy,2), 0) 
    
    draw_a_line(color1, 0,   WLH*3, 90, WLH, "魔伤威力：", 0)
    draw_a_line(color2, 90,  WLH*3, 100, WLH, Fround(@mdestroyrate,2).to_s+"﹪", 0)
    
    draw_a_line(color1, 0,   WLH*4, 90, WLH, "魔法伤害：",  0)
    draw_a_line(color2, 90,  WLH*4, 100, WLH, Fround(@mdestroy,2), 0) 
    
    draw_a_line(color1, 0,   WLH*5, 90, WLH, "攻击频率：", 0)
    draw_a_line(color2, 90,  WLH*5, 100, WLH, Fround(@atkrate,2).to_s+"﹪", 0)
    
    draw_a_line(color1, 0,   WLH*6, 90, WLH, "攻击速度：",  0)
    draw_a_line(color2, 90,  WLH*6, 100, WLH, Fround(@atkspeed,2), 0)    
    
    draw_a_line(color1, 0,   WLH*7, 90, WLH, "命中技巧：", 0)
    draw_a_line(color2, 90,  WLH*7, 100, WLH, Fround(@hit,2)  , 0)
    
    draw_a_line(color1, 0,   WLH*8, 90, WLH, "命中加成：", 0)
    draw_a_line(color2, 90,  WLH*8, 100, WLH, Fround(@hitrate,2).to_s+"﹪"   , 0)    
    
    draw_a_line(color1, 0,   WLH*9, 90, WLH, "闪避技巧：",  0)
    draw_a_line(color2, 90,  WLH*9, 100, WLH, Fround(@eva,2), 0)

    draw_a_line(color1, 0,   WLH*10, 90, WLH, "闪避加成：",  0)
    draw_a_line(color2, 90,  WLH*10, 100, WLH, Fround(@evarate,2).to_s+"﹪", 0)
    

    draw_a_line(color1, 0,   WLH*11, 90, WLH, "暴击技巧：",  0)
    draw_a_line(color2, 90,  WLH*11, 100, WLH, Fround(@bom,2), 0)
    
    draw_a_line(color1, 0,   WLH*12, 90, WLH, "暴击加成：",  0)
    draw_a_line(color2, 90,  WLH*12, 100, WLH, Fround(@bomrate,2).to_s+"﹪", 0)
    
    draw_a_line(color1, 0,   WLH*13, 90, WLH, "暴击威力：",  0)
    draw_a_line(color2, 90,  WLH*13, 100, WLH, Fround(@bomatk,2).to_s+"﹪", 0)
    
    
    
    i = 1
    while i <= 13
      draw_a_line(color2, 195,  WLH*i, 10,  WLH, "→", 1)
      i += 1
    end
    
    draw_extra_paramater(205, WLH, 100, WLH, 2)
  end

  #--------------------------------------------------------------------------
  # ● 清除额外窗口的数值
  #
  #--------------------------------------------------------------------------
  def clearextras
          @destroyn = nil
          @destroyraten = nil
          @mdestroyn = nil
          @mdestroyraten = nil
          @atkraten  = nil
          @atkspeedn = nil
          @hitn = nil
          @hitraten = nil
          @evan = nil 
          @evaraten = nil
          @bomn = nil
          @bomraten = nil
          @bomatkn = nil
          
          refresh
  end
  
  #--------------------------------------------------------------------------
  # ● 获取装备变更后的能力值描绘色
  #
  #--------------------------------------------------------------------------
  def draw_extra_paramater(x, y, width, height, align = 2)
    
    if @destroyraten  != nil
      self.contents.font.color = new_parameter_color(@destroyrate, @destroyraten )
      self.contents.draw_text(x, y, width, height,  Fround(@destroyraten,2).to_s + "﹪" , 2)
    end
    
    if @destroyn  != nil
      self.contents.font.color = new_parameter_color(@destroy, @destroyn )
      self.contents.draw_text(x, y+WLH*1, width, height,  Fround(@destroyn,2) , 2)
    end
    
    if @mdestroyraten  != nil
      self.contents.font.color = new_parameter_color(@mdestroyrate, @mdestroyraten )
      self.contents.draw_text(x, y+WLH*2, width, height,  Fround(@mdestroyraten,2).to_s+"﹪" , 2)
    end
    
    if @mdestroyn  != nil
      self.contents.font.color = new_parameter_color(@mdestroy, @mdestroyn )
      self.contents.draw_text(x, y+WLH*3, width, height,  Fround(@mdestroyn,2) , 2)
    end
    
    if @atkraten   != nil
      self.contents.font.color = new_parameter_color(@atkrate, @atkraten  )
      self.contents.draw_text(x, y+WLH*4, width, height,  Fround(@atkraten,2).to_s+"﹪", 2)
    end
    
    if @atkspeedn  != nil
      self.contents.font.color = new_parameter_color(@atkspeed, @atkspeedn )
      self.contents.draw_text(x, y+WLH*5, width, height,  Fround(@atkspeedn,2) , 2)
    end
    
    if @hitn  != nil
      self.contents.font.color = new_parameter_color(@hit, @hitn )
      self.contents.draw_text(x, y+WLH*6, width, height,  Fround(@hitn,2) , 2)
    end
    
    if @hitraten  != nil
      self.contents.font.color = new_parameter_color(@hitrate, @hitraten )
      self.contents.draw_text(x, y+WLH*7, width, height,  Fround(@hitraten,2).to_s+"﹪", 2)
    end    

    if @evan  != nil
      self.contents.font.color = new_parameter_color(@eva, @evan )
      self.contents.draw_text(x, y+WLH*8, width, height,  Fround(@evan,2) , 2)
    end
    
    if @evaraten  != nil
      self.contents.font.color = new_parameter_color(@evarate, @evaraten )
      self.contents.draw_text(x, y+WLH*9, width, height,  Fround(@evaraten,2).to_s+"﹪" , 2)
    end

    
    if @bomn  != nil
      self.contents.font.color = new_parameter_color(@bom, @bomn )
      self.contents.draw_text(x, y+WLH*10, width, height,  Fround(@bomn,2) , 2)
    end
    
    if @bomraten  != nil
      self.contents.font.color = new_parameter_color(@bomrate, @bomraten )
      self.contents.draw_text(x, y+WLH*11, width, height,  Fround(@bomraten,2).to_s+"﹪" , 2)
    end
    
    if @bomatkn  != nil
      self.contents.font.color = new_parameter_color(@bomatk, @bomatkn )
      self.contents.draw_text(x, y+WLH*12, width, height,  Fround(@bomatkn,2).to_s+"﹪" , 2)
    end
    
    
    
  end
  #--------------------------------------------------------------------------
  # ● 获取装备变更后的能力值描绘色
  #     old_value : 装備変更前の能力値
  #     new_value : 装備変更後の能力値
  #
  #       重定义
  #
  #--------------------------------------------------------------------------
  def new_parameter_color(old_value, new_value)
    if new_value > old_value      # 变强
      return Color.new(0,255,0)
    elsif new_value == old_value  # 没有变化
      return Color.new(255,255,255)
    else                          # 变弱
      return Color.new(255,0,0)
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