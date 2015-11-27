=begin
   这是右边的状态显示窗口，是游戏中十分重要的一个窗口
   这个窗口由Window_PlayerInfo 修改而来

=end


#==============================================================================
# ■ Window_PlayerInfo
#------------------------------------------------------------------------------
# 　地图侧面为方便查看而设立的状态窗口。
#==============================================================================

class Window_PlayerInfo < Window_Base
  include GAME_CONF
  WLH = 16
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #--------------------------------------------------------------------------
  def initialize(x,y)
    super(x, y, 192, 480)
    self.windowskin = Cache.system("Window3")
    self.opacity = 255
    self.back_opacity = 128
    self.contents.font.size = 16
  end
  #--------------------------------------------------------------------------
  # ● 配置
  #     actor : 角色(hero对象)
  #--------------------------------------------------------------------------
  def setup(actor)
    
    # 获得层数
    @layer = $game_variables[42]
    
    # 获得角色
    @actor = actor
    
    # 生命
    @hp = @actor.hp
    # 魔法
    @pow = @actor.mp
    
    # 攻击
    @atk = @actor.atk
    # 护甲
    @def = @actor.def
    
    # 攻速
    @atkspeed = @actor.base_atkspeed
    # 攻击频率
    @atkrate = @actor.final_atkrate
    
    # 生命恢复速度（每秒多少点）
    @hpcover = @actor.final_hpcover
    # 魔法恢复速度（每秒多少点）
    @mpcover = @actor.final_mpcover
   
    # 等级
    @lvl = @actor.level
    
    
  end
  #--------------------------------------------------------------------------
  # ● 刷新
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    
    # 获得层数
    @layer = $game_variables[42]
    
    # 重新获取数据
    # 生命
    @hp = @actor.hp
    # 魔法
    @pow = @actor.mp
    
    # 攻击
    @atk = @actor.atk
    # 护甲
    @def = @actor.def
    
    # 攻速
    @atkspeed = @actor.base_atkspeed
    # 攻击频率
    @atkrate = @actor.final_atkrate
    
    # 生命恢复速度（每秒多少点）
    @hpcover = @actor.final_hpcover
    # 魔法恢复速度（每秒多少点）
    @mpcover = @actor.final_mpcover
    
    # 等级
    @lvl = @actor.level
    
    # 钥匙
    @yellowkey = $game_party.item_number($data_items[1])
    @greenkey = $game_party.item_number($data_items[2])
    @bluekey = $game_party.item_number($data_items[3])
    @redkey = $game_party.item_number($data_items[4])
    
    
    #-------------修改这里--------------------------
    # 绘画名字
    draw_actor_name(@actor, 96, 0)
    
    # 描绘等级
    color = getColor("white")
    draw_a_line(color, 70, WLH*2,40, WLH, "等级", 1)
    draw_a_line(color, 110, WLH*2,40, WLH, @lvl , 2) 
    
    # 描绘层数
    draw_a_line(color, 70, WLH*3,40, WLH, "层数" , 1)  
    draw_a_line(color, 110, WLH*3,40, WLH, @layer , 2)  
    
    
    # 描绘信息
    draw_actor_face(@actor, 0, 0, 64)
    # 绘制角色数据
    draw_parameters(0, 72)
    
    # 描绘钥匙数量
    self.contents.font.size = 24
    # 如果有黄钥匙
    key = $data_items[1]
    if $game_party.has_item?(key)
      key_kind = "黄钥匙"
      bitmap = Cache.battler(key_kind, 0)
      rect = Rect.new(0, 0, 0, 0)
      rect.x = 0
      rect.y = 0
      rect.width = 32
      rect.height = 32
      self.contents.blt(0, 72+WLH*17, bitmap, rect)
      bitmap.dispose
      draw_a_line(getColor("white"), 32, 72+4+WLH*17, 35, 24,  @yellowkey) 
    end
    
    key = $data_items[2]
    # 如果有绿钥匙
    if $game_party.has_item?(key)
      key_kind = "绿钥匙"
      bitmap = Cache.battler(key_kind, 0)
      rect = Rect.new(0, 0, 0, 0)
      rect.x = 0
      rect.y = 0
      rect.width = 32
      rect.height = 32
      self.contents.blt(85, 72+WLH*17, bitmap, rect)
      bitmap.dispose
      draw_a_line(getColor("white"), 117, 72+4+WLH*17, 35, 24,  @greenkey)
    end
    
    key = $data_items[3]
    # 如果有蓝钥匙  
    if $game_party.has_item?(key)
      key_kind = "蓝钥匙"
      bitmap = Cache.battler(key_kind, 0)
      rect = Rect.new(0, 0, 0, 0)
      rect.x = 0
      rect.y = 0
      rect.width = 32
      rect.height = 32
      self.contents.blt(0, 104+WLH*17, bitmap, rect)
      bitmap.dispose
      draw_a_line(getColor("white"), 32, 104+4+WLH*17, 35, 24,  @bluekey)
    end
    
    key = $data_items[4]
    # 如果有红钥匙  
    if $game_party.has_item?(key)
      key_kind = "红钥匙"
      bitmap = Cache.battler(key_kind, 0)
      rect = Rect.new(0, 0, 0, 0)
      rect.x = 0
      rect.y = 0
      rect.width = 32
      rect.height = 32
      self.contents.blt(85, 104+WLH*17, bitmap, rect)
      bitmap.dispose
      draw_a_line(getColor("white"), 117, 104+4+WLH*17, 35, 24,  @redkey)
    end
    # 钥匙数量绘制完毕
    self.contents.font.size = 16 
      
    
    

    
    #-----------------------------------------------
    
  end
  #--------------------------------------------------------------------------
  # ● 描绘数值，任何数据都能画
  #     x : 描绘目标 X 坐标
  #     y : 描绘目标 Y 坐标
  #--------------------------------------------------------------------------
  def draw_parameter(x,y,name,value)
    # 设置内容颜色
    self.contents.font.color = system_color
    # 根据内容颜色写字
    self.contents.draw_text(x, y, 60, WLH, name)
    # 重新设置内容颜色
    self.contents.font.color = normal_color
    # 根据内容颜色写字
    self.contents.draw_text(x + 60, y, 96, WLH, value, 2)
  end

  #--------------------------------------------------------------------------
  # ● 描绘能力值
  #
  #     重定义
  #
  #     x : 描绘目标 X 坐标
  #     y : 描绘目标 Y 坐标
  #--------------------------------------------------------------------------
  def draw_parameters(x, y)
    color = getColor("white")
    
    draw_a_line(color, x, y, 180, WLH, "生命--------------", 0)
    draw_a_line(color, x, y+WLH*2,  180, WLH, "魔法--------------", 0)
    draw_a_line(color, x, y+WLH*4,  180, WLH, "攻击--------------", 0)
    draw_a_line(color, x, y+WLH*6,  180, WLH, "防御--------------", 0)
    draw_a_line(color, x, y+WLH*8,  180, WLH, "攻速速度----------", 0)
    draw_a_line(color, x, y+WLH*10, 180, WLH, "攻击频率----------", 0)
    draw_a_line(color, x, y+WLH*12, 180, WLH, "生命恢复/秒-------", 0)
    draw_a_line(color, x, y+WLH*14, 180, WLH, "魔法恢复/秒-------", 0)  
    
    
    color = Color.new(0, 255, 0)
    draw_a_line(color, 0, y+WLH, 150, WLH, Fround(@hp, 2), 2 )
    draw_a_line(color, 0, y+WLH*3, 150, WLH, Fround(@pow, 2), 2)
    draw_a_line(color, 0, y+WLH*5, 150, WLH, Fround(@atk, 1), 2)
    draw_a_line(color, 0, y+WLH*7, 150, WLH, Fround(@def, 1), 2)
    draw_a_line(color, 0, y+WLH*9, 150, WLH, Fround(@atkspeed, 1), 2)
    draw_a_line(color, 0, y+WLH*11, 150, WLH, Fround(@atkrate, 1).to_s+"﹪", 2)
    draw_a_line(color, 0, y+WLH*13,150, WLH, Fround(@hpcover, 2), 2)
    draw_a_line(color, 0, y+WLH*15,150, WLH, Fround(@mpcover, 2), 2)
    
    
  end
 
  #--------------------------------------------------------------------------
  # ● 更新画面
  #--------------------------------------------------------------------------
  def update
    if $game_system.show_info == true and self.visible == true
      # 更新画面效果
      self.contents_opacity = [self.contents_opacity + 4.25, 255.0].min
      # 本窗口一直保持在448处
      self.x += (448.0 - self.x)  if self.x<447 or self.x>449
      # 更新内容
      refresh if need_refresh?
    end
  end
  #--------------------------------------------------------------------------
  # ● 判断是否需要重新获取数据
  #--------------------------------------------------------------------------
  def need_refresh?
    return true if @hp != @actor.hp
    return true if @pow != @actor.mp
    return true if @atk != @actor.atk
    return true if @def != @actor.def
    return true if @atkspeed != @actor.base_atkspeed
    return true if @atkrate != @actor.final_atkrate
    return true if @hpcover != @actor.final_hpcover
    return true if @lvl != @actor.level
    return true if @mpcover != @actor.final_mpcover
    return true if @layer != $game_variables[42]
    return true if @yellowkey != $game_party.item_number($data_items[1])
    return true if @greenkey != $game_party.item_number($data_items[2])
    return true if @bluekey != $game_party.item_number($data_items[3])
    return true if @redkey != $game_party.item_number($data_items[4])
    return false
  end
end