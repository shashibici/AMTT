
  #--------------------------------------------------------------------------
  # ● 刷新
  #--------------------------------------------------------------------------
  def update
    super
    call_update_detail
  end  
  #--------------------------------------------------------------------------
  # ● 调用详细窗口刷新函数
  #--------------------------------------------------------------------------
  def call_update_detail
    if (self.active and self.visible) and @detail_window != nil
      update_detail
    elsif @detail_window != nil
      @detail_window.visible = false
    end
  end    
  #--------------------------------------------------------------------------
  # ● 更新详细信息窗口 (继承内容)
  #--------------------------------------------------------------------------
  def update_detail
    # 修改位置
    @window_detail.x = self.x + index % @column_max * (rect.width + @spacing)
    @window_detail.y = self.y + index / @column_max * WLH
    
    # 修改内容
    if self.item == nil
      text = []
      colors = []
    elsif nil == (temp = GAME_INI.getEquipDes(@type, item.id))
      text = []
      colors = []
    else
      text = temp[0]
      colors = temp[1]
    end
    
    @window_detail.set_text(text, 0, colors)
    
  end  