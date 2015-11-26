#==============================================================================
# ■ Scene_ShopHunYuan_Equip
#------------------------------------------------------------------------------
# 　处理使用混元币的商店
#==============================================================================

class Scene_ShopHunYuan_Equip < Scene_Shop
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
    
    # 以混元作为交易货币
    @gold_window = Window_HunYuan.new(480, 100)
    @dummy_window = Window_Base.new(0, 156, 640, 304)
    
    # 以混元窗口进行购买
    @buy_window = Window_ShopBuyHunYuan.new(0, 156)
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
      @sell_window = Window_ShopSellHunYuan.new(0, 156, 640, 304)
      @sell_window.active = false
      @sell_window.visible = false
      @sell_window.help_window = @help_window 
    # 物品
    when 1
      @sell_window = Window_ShopSell_ItemItemHunYuan.new(0, 156, 640, 304)
      @sell_window.active = false
      @sell_window.visible = false
      @sell_window.help_window = @help_window   
    # 武器防具
    when 2
      @sell_window = Window_ShopSell_WeaponArmorHunYuan.new(0, 156, 640, 304)
      @sell_window.active = false
      @sell_window.visible = false
      @sell_window.help_window = @help_window
    # 宝物
    when 3
      @sell_window = Window_ShopSell_TreasureHunYuan.new(0, 156, 640, 304)
      @sell_window.active = false
      @sell_window.visible = false
      @sell_window.help_window = @help_window
    end
    
    @number_window = Window_ShopNumberHunYuan.new(0, 156)
    @number_window.active = false
    @number_window.visible = false
    @status_window = Window_ShopStatus.new(400, 156)
    @status_window.visible = false
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
        # 计算混元价
        hunyuan = @item.read_note('hunyuan')
        hunyuan = 0  if hunyuan == nil
        # 计算价格
        @number_window.set(@item, max, hunyuan / ($game_variables[103] == 0 ? 999999999 : $game_variables[103]) )
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
      # 计算混元价
      hunyuan = @item.read_note('hunyuan')
      hunyuan = 0 if hunyuan == nil
      # 计算价格
      number = $game_party.item_number(@item)
      if @item == nil or hunyuan * ($game_variables[102] / 100.0) > $game_party.hunyuan or number == 99
        Sound.play_buzzer
      else
        Sound.play_decision
        max = hunyuan == 0 ? 99 : Integer($game_party.hunyuan / (hunyuan * ($game_variables[102] / 100.0)))
        max = [max, 99 - number].min
        @buy_window.active = false
        @buy_window.visible = false
        @number_window.set(@item, max, hunyuan * ($game_variables[102] / 100.0))
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
    # 获得混元价
    hunyuan = @item.read_note('hunyuan')
    hunyuan = 0 if hunyuan == nil
    # 计算价格
    case @command_window.index
    when 0  # 购买
      $game_party.hunyuan -= @number_window.number * hunyuan * ($game_variables[102] / 100.0)
      $game_party.gain_item(@item, @number_window.number)
      @gold_window.refresh
      @buy_window.refresh
      @status_window.refresh
      @buy_window.active = true
      @buy_window.visible = true
    when 1  # 卖出
      $game_party.hunyuan += @number_window.number * (hunyuan / ($game_variables[103] == 0 ? 999999999 : $game_variables[103]) )
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
