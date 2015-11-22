#==============================================================================
# ■ Scene_Consult
#------------------------------------------------------------------------------
# 　处理怪物参考信息的类
#==============================================================================

class Scene_Consult < Scene_Base
  
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #     actor_index : 角色索引
  #--------------------------------------------------------------------------
  def initialize(monstor)
    @monstor = monstor
    # 指出当前是哪一个装备
    @equip_index = 0
  end
  #--------------------------------------------------------------------------
  # ● 开始处理
  #--------------------------------------------------------------------------
  def start
    super
    @consult_window1 = Window_Consult_Status1.new(0,0,@monstor)
    @consult_window2 = Window_Consult_Status2.new(0,128-24,@monstor)
	@consult_window3 = Window_Consult_Status3.new(160+32, 0, @monstor)
	# 生成装备窗口
    @equip_window = Window_Consult_Equip.new(168, 96, @monstor)
    @equip_window.opacity = 0
	@equip_window.index = @equip_index
    # 详细信息窗口
	@help_detail = Window_HelpDetail.new(0,72+32,224,358)
	@help_detail.opacity = 0
    @help_detail.visible = true
	@equip_window.window_detail = @help_detail
  end
  #--------------------------------------------------------------------------
  # ● 结束处理
  #--------------------------------------------------------------------------
  def terminate
    super
    @consult_window1.dispose
    @consult_window2.dispose
	@consult_window3.dispose
    @help_detail.dispose
	@equip_window.dispose
	# 在这里设置，返回Scene_Map 后才被刷新执行
	# common event 100,  清除侦查后的怪物变量。
	$game_temp.common_event_id = 100
  end

  #--------------------------------------------------------------------------
  # ● 更新画面
  #--------------------------------------------------------------------------
  def update
    @consult_window1.update
    @consult_window2.update
	@equip_window.update
    update_equip_selection
  end
  
  #--------------------------------------------------------------------------
  # ● 返回
  #--------------------------------------------------------------------------
  def return_secene
    # 清理变量
    # 从45~88变量全部清零
    for i in 45..88 do
      $game_variables[i] = 0
    end
	# 宝物5，6
	for i in 158..159 do
		$game_variables[i] = 0
	end
    # 金钱数、经验数清零
    $game_variables[90] = 0
    $game_variables[91] = 0
    
    # 返回
    $scene = Scene_Map.new()
  end  
  #--------------------------------------------------------------------------
  # ● 更新选择装备部位
  #--------------------------------------------------------------------------
  def update_equip_selection
    # 取消
    if Input.trigger?(Input::B)
      Sound.play_cancel
      return_secene
    # 方向键
    elsif Input.trigger?(Input::UP)
      @equip_window.type = getEuipType
      @equip_window.call_update_detail
    elsif Input.trigger?(Input::DOWN)
      @equip_window.type = getEuipType
      @equip_window.call_update_detail
    end 
  end
  #--------------------------------------------------------------------------
  # ● 获得当前装备类型
  #
  #     武器：0  头：1 颈部：2 盾：3 衣服：4 戒指：5 鞋子：6 宝物：7
  #
  #--------------------------------------------------------------------------
  def getEuipType
    if @equip_window.index < 2
      return 0
    elsif @equip_window.index <= 7
      return @equip_window.index - 1
    elsif @equip_window.index >7
      return 7
    else
      return 0
    end
  end
end

















