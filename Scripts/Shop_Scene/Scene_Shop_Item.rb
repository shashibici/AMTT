#==============================================================================
# ■ Scene_Shop_Item
#------------------------------------------------------------------------------
# 　处理商店画面的类。
#==============================================================================

class Scene_Shop_Item < Scene_Base
  #--------------------------------------------------------------------------
  # ● 开始处理
  #
  #     重定义
  #
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    create_command_window
    @help_window = Window_Help.new
    @gold_window = Window_Gold.new(480, 100)
    @dummy_window = Window_Base.new(0, 156, 640, 304)
    
    @buy_window = Window_ShopBuy.new(0, 156)
    @buy_window.active = false
    @buy_window.visible = false
    @buy_window.help_window = @help_window      
    
    # 设置信息窗口
    @detail_window = Window_HelpDetail.new(100,200,200,258)
    @detail_window.visible = false
    @buy_window.window_detail = @detail_window
    
    # 更具变量决定商店类型
    # 0所有 1物品 2武器防具 3宝物
    
    case $game_variables[101]
    # 所有
    when 0
      @sell_window = Window_ShopSell.new(0, 156, 640, 304)
      @sell_window.active = false
      @sell_window.visible = false
      @sell_window.help_window = @help_window 
    # 物品
    when 1
      @sell_window = Window_ShopSell_ItemItem.new(0, 156, 640, 304)
      @sell_window.active = false
      @sell_window.visible = false
      @sell_window.help_window = @help_window
    end
    
    @number_window = Window_ShopNumber.new(0, 156)
    @number_window.active = false
    @number_window.visible = false
    @status_window = Window_ShopStatus.new(400, 156)
    @status_window.visible = false
  end  
  #--------------------------------------------------------------------------
  # ● 生成指令窗口
  #--------------------------------------------------------------------------
  def create_command_window
    s1 = Vocab::ShopBuy
    s2 = Vocab::ShopSell
    s3 = Vocab::ShopCancel
    @command_window = Window_Command.new(480, [s1, s2, s3], 3)
    @command_window.y = 100
    if $game_temp.shop_purchase_only
      @command_window.draw_item(1, false)
    end
  end
  #--------------------------------------------------------------------------
  # ● 释放指令窗口
  #
  # 	重定义
  #
  #--------------------------------------------------------------------------
  def dispose_command_window
    @command_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● 结束处理
  #
  #     重新定义
  #
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    dispose_command_window
    @help_window.dispose
    @gold_window.dispose
    @dummy_window.dispose
    @buy_window.dispose
    @sell_window.dispose
    @number_window.dispose
    @status_window.dispose
    @detail_window.dispose
  end 
  #--------------------------------------------------------------------------
  # ● 更新画面
  #
  #    重定义
  #
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background
    @help_window.update
    @command_window.update
    @gold_window.update
    @dummy_window.update
    @buy_window.update
    @detail_window.visible = @buy_window.visible
    @detail_window.active = @buy_window.active
    
    if @buy_window.active and @buy_window.visible
      # 获取物品
      item = @buy_window.item
      # 获取物品类型
      if item != nil
        # 判断物品类型
        case item
        when RPG::Item
          type = -1
        when RPG::Weapon
          type = 0
        when RPG::Armor
          type = item.read_note('locate')
        end
      end
      # 更新细节窗口
      @buy_window.call_update_detail(type)
    end

    @sell_window.update
    @number_window.update
    @status_window.update
    if @command_window.active
      update_command_selection
    elsif @buy_window.active
      update_buy_selection
    elsif @sell_window.active
      update_sell_selection
    elsif @number_window.active
      update_number_input
    end
  end  
  #--------------------------------------------------------------------------
  # ● 更新输入个数
  #--------------------------------------------------------------------------
  def update_number_input
    if Input.trigger?(Input::B)
      cancel_number_input
    elsif Input.trigger?(Input::C)
      decide_number_input
    end
  end
  #--------------------------------------------------------------------------
  # ● 取消输入个数
  #--------------------------------------------------------------------------
  def cancel_number_input
    Sound.play_cancel
    @number_window.active = false
    @number_window.visible = false
    case @command_window.index
    when 0  # 购买
      @buy_window.active = true
      @buy_window.visible = true
      # @buy_window.window_detail.visible = true
    when 1  # 卖出
      @sell_window.active = true
      @sell_window.visible = true
      # @sell_window.window_detail.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 更新指令窗口
  #
  #   已经重定义
  #--------------------------------------------------------------------------
  def update_command_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      $scene = Scene_Map.new
    elsif Input.trigger?(Input::C)
      case @command_window.index
      when 0  # 购买
        Sound.play_decision
        @command_window.active = false
        @dummy_window.visible = false
        @buy_window.active = true
        @buy_window.visible = true
        @buy_window.refresh
        @status_window.visible = true
      when 1  # 卖出
        if $game_temp.shop_purchase_only
          Sound.play_buzzer
        else
          Sound.play_decision
          @command_window.active = false
          @dummy_window.visible = false
          @sell_window.active = true
          @sell_window.visible = true
          @sell_window.refresh
        end
      when 2  # 取消
        Sound.play_decision
        $scene = Scene_Map.new
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 更新选择卖出物品
  #
  #      重定义
  #
  #--------------------------------------------------------------------------
  def update_sell_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      @command_window.active = true
      @dummy_window.visible = true
      @sell_window.active = false
      @sell_window.visible = false
      @status_window.item = nil
      @help_window.set_text("")
    elsif Input.trigger?(Input::C)
      @item = @sell_window.item
      @status_window.item = @item
      if @item == nil or @item.price == 0
        Sound.play_buzzer
      else
        Sound.play_decision
        max = $game_party.item_number(@item)
        @sell_window.active = false
        @sell_window.visible = false
        @number_window.set(@item, max, @item.price / ($game_variables[103] == 0 ? 999999999 : $game_variables[103]) )
        @number_window.active = true
        @number_window.visible = true
        @status_window.visible = true
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 更新选择购买物品
  #
  #     重定义
  #
  #--------------------------------------------------------------------------
  def update_buy_selection
    @status_window.item = @buy_window.item
    if Input.trigger?(Input::B)
      Sound.play_cancel
      @command_window.active = true
      @dummy_window.visible = true
      @buy_window.active = false
      @buy_window.visible = false
      @status_window.visible = false
      @status_window.item = nil
      @help_window.set_text("")
      return
    end
    if Input.trigger?(Input::C)
      @item = @buy_window.item
      number = $game_party.item_number(@item)
      if @item == nil or @item.price * ($game_variables[102] / 100.0) > $game_party.gold or number == 99
        Sound.play_buzzer
      else
        Sound.play_decision
        max = @item.price == 0 ? 99 : Integer($game_party.gold / (@item.price * ($game_variables[102] / 100.0)))
        max = [max, 99 - number].min
        @buy_window.active = false
        @buy_window.visible = false
        @number_window.set(@item, max, @item.price * ($game_variables[102] / 100.0))
        @number_window.active = true
        @number_window.visible = true
      end
    end
  end  
  #--------------------------------------------------------------------------
  # ● 确定输入个数
  #
  #       重定义
  #
  #--------------------------------------------------------------------------
  def decide_number_input
    Sound.play_shop
    @number_window.active = false
    @number_window.visible = false
    case @command_window.index
    when 0  # 购买
      $game_party.lose_gold(@number_window.number * @item.price * ($game_variables[102] / 100.0))
      $game_party.gain_item(@item, @number_window.number)
      @gold_window.refresh
      @buy_window.refresh
      @status_window.refresh
      @buy_window.active = true
      @buy_window.visible = true
    when 1  # 卖出
      $game_party.gain_gold(@number_window.number * (@item.price / ($game_variables[103] == 0 ? 999999999 : $game_variables[103]) ))
      $game_party.lose_item(@item, @number_window.number)
      @gold_window.refresh
      @sell_window.refresh
      @status_window.refresh
      @sell_window.active = true
      @sell_window.visible = true
      @status_window.visible = false
    end
  end
  
end




  




