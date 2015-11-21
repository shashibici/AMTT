#==============================================================================
# ■ Scene_Equip
#------------------------------------------------------------------------------
# 　处理装备画面
#==============================================================================

class Scene_Equip2 < Scene_Base
  #--------------------------------------------------------------------------
  # ● 常量
  #--------------------------------------------------------------------------
  #   0：武器  1：头部  2：项链  3：盾  4：衣服  5：戒指  6：鞋子  7：宝物
  #
  #--------------------------------------------------------------------------
  EQUIP_TYPE_MAX = 8                      # 装备部位种类
  WLH = 24
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #     actor_index : 角色索引
  #     equip_index : 装备索引
  #--------------------------------------------------------------------------
  def initialize(old_menu_index, actor_index = 0, equip_index = 0)
    @time = Graphics.frame_count
    @actor_index = actor_index
    @equip_index = equip_index
    
    # 帮助窗口的文字、颜色
    @help_text = []
    @help_colors = []
  end
  #--------------------------------------------------------------------------
  # ● 开始处理
  #--------------------------------------------------------------------------
  def start
    super
    # 设置背景
    
    # 设置角色索引
    @actor = $game_party.members[@actor_index]
    
    # 创建状态窗口
    # 头像
    @status_window1 = Window_EquipStatus1.new(0,0,@actor)
    # 生命槽
    @status_window2 = Window_EquipStatus2.new(0,128-16,@actor)

    # 生成物品窗口
    create_item_windows

    # 生成装备窗口
    @equip_window = Window_Equip_Select.new(168, 0, @actor)
    @equip_window.opacity = 0
    
    # 刚开始，设置装备窗口的索引，以后不用这种方法设置
    @equip_window.index = @equip_index
    
    
    # 生成详细信息窗口
    @help_detail = Window_HelpDetail.new(0,0,224,358)
	@help_detail.opacity = 0
    update_detail_window
    @help_detail.visible = true
    
  end
  #--------------------------------------------------------------------------
  # ● 结束处理
  #--------------------------------------------------------------------------
  def terminate
    super
    @equip_window.dispose
    @status_window1.dispose
    @status_window2.dispose
    dispose_item_windows
    @help_detail.dispose
  end
  #--------------------------------------------------------------------------
  # ● 返回原来的画面
  #--------------------------------------------------------------------------
  def return_scene
    $scene = Scene_Menu2.new(2)
  end
  #--------------------------------------------------------------------------
  # ● 切换至下一名角色的画面
  #--------------------------------------------------------------------------
  def next_actor
    @actor_index += 1
    @actor_index %= $game_party.members.size
    # 创建新角色的装备窗口
    $scene = Scene_Equip.new(@actor_index, @equip_window.index)
  end
  #--------------------------------------------------------------------------
  # ● 切换至上一名角色的画面
  #--------------------------------------------------------------------------
  def prev_actor
    @actor_index += $game_party.members.size - 1
    @actor_index %= $game_party.members.size
    $scene = Scene_Equip.new(@actor_index, @equip_window.index)
  end
  #--------------------------------------------------------------------------
  # ● 根据@equip_index设置@equip_window.index
  #
  #  	从物品选择返回的时候需要用到
  #
  #--------------------------------------------------------------------------
  def set_equip_window_index
    case @equip_index
    when 0
      @equip_window.index = 0
    when 1
      @equip_window.index = 2
    when 2
      @equip_window.index = 3
    when 3
      @equip_window.index = 4
    when 4
      @equip_window.index = 5
    when 5
      @equip_window.index = 6
    when 6
      @equip_window.index = 7
    when 7
      @equip_window.index = 8
    end
  end  
  #--------------------------------------------------------------------------
  # ● 根据@equip_window.index设置@equip_index
  #--------------------------------------------------------------------------
  def set_equip_index
    case @equip_window.index
    when 0
      @equip_index = 0
    when 1
      @equip_index = 0
    when 2
      @equip_index = 1
    when 3
      @equip_index = 2
    when 4
      @equip_index = 3
    when 5
      @equip_index = 4
    when 6
      @equip_index = 5
    when 7
      @equip_index = 6
    when 8
      @equip_index = 7
    when 9
      @equip_index = 7
    when 10
      @equip_index = 7
    when 11
      @equip_index = 7
    end
  end   
  #--------------------------------------------------------------------------
  # ● 更新画面
  #--------------------------------------------------------------------------
  def update
    super
    # 更新背景
    update_menu_background
    # 更新头像窗口
    @status_window1.update
    # 更新血条窗口
    @status_window2.update
    # 更新装备窗口
    update_equip_window
    # 更新@equip_index变量
    set_equip_index
    # 更新物品窗口
    update_item_windows
    
    # 如果装备窗口活跃
    if @equip_window.active
      # 更新装备选择
      update_equip_selection
      
    # 否则如果物品窗口活跃
    elsif @item_window.active
      # 更新物品选择
      update_item_selection
    end
  end
  #--------------------------------------------------------------------------
  # ● 生成物品窗口
  #--------------------------------------------------------------------------
  def create_item_windows
    @item_windows = []
    # 0：武器  1：头部  2：项链  3：盾  4：衣服  5：戒指  6：鞋子  7：宝物
    for i in 0...EQUIP_TYPE_MAX
      # 创建物品窗口
      @item_windows[i] = Window_EquipItem.new(0, 280, 640, 200, @actor, i)
      # 选择哪一类装备，哪一类物品窗口设为可见
      @item_windows[i].visible = (@equip_index == i)
      # 坐标
      @item_windows[i].y = 350
      @item_windows[i].height = 128
      # 只是可见，没有被激活
      @item_windows[i].active = false
      # 索引也没有
      @item_windows[i].index = -1
    end
  end
  #--------------------------------------------------------------------------
  # ● 释放物品窗口
  #--------------------------------------------------------------------------
  def dispose_item_windows
    for window in @item_windows
      window.dispose
    end
  end
  #--------------------------------------------------------------------------
  # ● 更新物品窗口
  #--------------------------------------------------------------------------
  def update_item_windows
    
    # 每一类窗口都要更新
    for i in 0...EQUIP_TYPE_MAX
      # 设置窗口可见性
      @item_windows[i].visible = (@equip_index == i)
      # 对该类窗口进行更新，如果可见
      @item_windows[i].update if @item_windows[i].visible == true
    end
    @item_window = @item_windows[@equip_index]
  end
  #--------------------------------------------------------------------------
  # ● 更新装备窗口
  #--------------------------------------------------------------------------
  def update_equip_window
    @equip_window.update
  end
  #--------------------------------------------------------------------------
  # ● 更新状态窗口
  #--------------------------------------------------------------------------
  def update_status_window
    # 如果装备窗口出于激活状态，那么就是在选择装备种类，并不是选择新装备
    # 所以不用填写状态窗口右边属性的变化
    if @equip_window.active
      @status_window1.setup(@actor, 3)
      @status_window2.setup(@actor, 3)
    # 否则是在选择物品
    elsif @item_window.active
      # 首先克隆一个临时角色
      temp_actor = @actor.clone
      # 临时角色更换装备
      # 装备类型号：@equip_window.index,物品：@item_window.item
      temp_actor.change_equip(@equip_window.index, @item_window.item, true)
	  @status_window1.setup(temp_actor, 3)
	  @status_window2.setup(temp_actor, 3)
    end

  end
  #--------------------------------------------------------------------------
  # ● 更新选择装备部位
  #
  #    本函数中，更新帮助窗口
  #
  #--------------------------------------------------------------------------
  def update_equip_selection
    if Input.trigger?(Input::X)
      @help_detail.visible = !@help_detail.visible
      MySound.play_quest
    elsif Input.trigger?(Input::B)
      Sound.play_cancel
      return_scene
    elsif Input.trigger?(Input::R)
      Sound.play_cursor
      update_detail_window
    elsif Input.trigger?(Input::L)
      Sound.play_cursor
      update_detail_window
    elsif Input.trigger?(Input::C)
	  # 判断能否使用这个槽位	
	  if @equip_window.index < 2 and @equip_window.index > @equip_window.max_weapon_index
		# 超过最大可用武器槽位
		Sound.play_buzzer
		return
	  elsif @equip_window.index > @equip_window.max_trea_index
		# 超过最大可用宝物槽位
		Sound.play_buzzer
		return
	  end
      Sound.play_decision
      @equip_window.active = false
      @item_window.active = true
      @item_window.index = 0
      update_detail_window
      # 由装备选择进入物品选择，立即更新状态窗口
      update_status_window
    elsif Input.trigger?(Input::UP)
      update_detail_window
    elsif Input.trigger?(Input::DOWN)
      update_detail_window
    end
  end
  #--------------------------------------------------------------------------
  # ● 更新选择物品
  #--------------------------------------------------------------------------
  def update_item_selection
    if Input.trigger?(Input::X)
      @help_detail.visible = !@help_detail.visible
      MySound.play_quest
    elsif Input.trigger?(Input::B)
      Sound.play_cancel
      @equip_window.active = true
      @item_window.active = false
      @item_window.index = -1
	  update_status_window
      update_detail_window
    elsif Input.trigger?(Input::C)
      Sound.play_equip
      # 换装备
      @actor.change_equip(@equip_window.index, @item_window.item)
      # 变更窗口活跃性
      @equip_window.active = true
      @item_window.active = false
      # 更新状态，此时是@equip_window.active = true
      update_status_window
      @item_window.index = -1
      # 更新装备窗口
      @equip_window.refresh
      # 更新物品窗口
      for item_window in @item_windows
        item_window.refresh if item_window.visible == true
      end
      update_detail_window
    # 如果是按上下左右键，那么就更新状态窗口
    elsif Input.trigger?(Input::UP)   
      update_status_window
      update_detail_window("up")
    elsif Input.trigger?(Input::DOWN)
      update_status_window
      update_detail_window("down")
    elsif Input.trigger?(Input::LEFT)
      update_status_window
      update_detail_window("left")
    elsif Input.trigger?(Input::RIGHT)
      update_status_window
      update_detail_window("right")
    end
  end
  #--------------------------------------------------------------------------
  # ● 更新帮助窗口
  #--------------------------------------------------------------------------
  def update_detail_window(direction = nil)
    # 如果装备窗口激活
    if @equip_window.active == true
      @equip_window.type = @equip_index
      @equip_window.window_detail = @help_detail
      @equip_window.call_update_detail
    # 否则物品窗口激活  
    elsif @item_window.active == true
      @item_window.type = @equip_index
      @item_window.window_detail = @help_detail
      @item_window.call_update_detail
    end
  end
end




















