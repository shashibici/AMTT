#==============================================================================
# ■ Window_EquipItem
#------------------------------------------------------------------------------
# 　装备画面、显示变更装备时候补物品列表的窗口。
#==============================================================================

class Window_EquipItem < Window_Item
  attr_accessor        :type   # 记录该物品窗口的类型
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #     x          : 窗口的 X 坐标
  #     y          : 窗口的 Y 坐标
  #     width      : 窗口的宽
  #     height     : 窗口的高
  #     actor      : 角色
  #     equip_type : 装备部位 (0～7)
  #       0:武器； 1：头部； 2：项链； 3盾； 4：衣服； 5：戒指； 6：鞋子；
  #       7：宝物
  #
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor, equip_type)
    @actor = actor
    @equip_type = equip_type
    super(x, y, width, height)
  end
  #--------------------------------------------------------------------------
  # ● 列表中包含的物品
  #     item : 物品
  #--------------------------------------------------------------------------
  def include?(item)
    return true if item == nil
    # 如果当前是武器
    if @equip_type == 0
      return false unless item.is_a?(RPG::Weapon)
    # 如果当前不是武器
    else
      return false unless item.read_note("locate") == @equip_type
    end
    # 已经修改修改
    return @actor.equippable?(item)
  end
  #--------------------------------------------------------------------------
  # ● 是否可以使用物品
  #     item : 物品
  #--------------------------------------------------------------------------
  def enable?(item)
    return true
  end  
  #--------------------------------------------------------------------------
  # ● 调用详细窗口刷新函数
  #--------------------------------------------------------------------------
  def call_update_detail
    if (self.active and self.visible) and @window_detail != nil
      @window_detail.visible = true
      update_detail
    elsif @window_detail != nil
      @window_detail.visible = false
    end
  end    
  #--------------------------------------------------------------------------
  # ● 更新详细信息窗口 (继承内容)
  #--------------------------------------------------------------------------
  def update_detail
    
    # 修改内容
    if self.item == nil
      text = []
      colors = []
    elsif nil == (temp=GAME_INIT.getEquipDes(@type, item.id))
      p "type="+@type.to_s
      p "id="+item.id.to_s
      p GAME_INIT::Equip_Descriptions[@type][item.id.to_s]
      text = []
      colors = []
    else
      text = temp[0]
      colors = temp[1]
    end
    
    @window_detail.set_text(text, 0, colors)
    
    # 设置位置
    @window_detail.x = self.x + self.width/4 + index % @column_max * self.width/2 
    @window_detail.y = self.y + 24 + (index / @column_max - top_row) * WLH

    # 修改位置
    if @window_detail.y + @window_detail.height >= 500
      @window_detail.y -= @window_detail.height
    end
    if @window_detail.x + @window_detail.width >= 640
      @window_detail.x -= @window_detail.width
    end
    
  end 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
end
