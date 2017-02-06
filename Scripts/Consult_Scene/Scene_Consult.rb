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
	@equip_window.active = false
    # 详细信息窗口
	@help_detail = Window_HelpDetail.new(0,72+32,224,358)
	@help_detail.opacity = 0
    @help_detail.visible = true
	@equip_window.window_detail = @help_detail
	# 生成技能窗口
	@skill_window = Window_Consult_Skill.new(168, 96, 106, 360, @monstor)
	@skill_window.opacity = 0
	@skill_window.active = false
	@skill_window.visible = false
	# 生成技能信息窗口
	@des_window = Window_SkillDescription.new(274, 96, 640-274, 480-96)
	@des_window.opacity = 0
	@des_window.item = nil
	@des_window.active = false
	@des_window.visible = false
	# 生成指令窗口
	create_commands
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
	@skill_window.dispose
	@des_window.dispose
	@command_window.dispose
	# 在这里设置，返回Scene_Map 后才被刷新执行
	# common event 100,  清除侦查后的怪物变量。
	$game_temp.common_event_id = 100
  end
  #--------------------------------------------------------------------------
  # ● 生成指令窗口
  #--------------------------------------------------------------------------
  def create_commands
	@command_window = Window_Command.new(280, ["查看装备", "查看技能"],2)
	@command_window.opacity = 0
	@command_window.x = 360
	@command_window.y = 32
	@command_window.active = true
  end
  #--------------------------------------------------------------------------
  # ● 更新画面
  #--------------------------------------------------------------------------
  def update
    @consult_window1.update
    @consult_window2.update
	@equip_window.update
	@skill_window.update
	@des_window.update
	if @command_window.active == true
		@command_window.update
		update_command_selection
	elsif @skill_window.active == true
		@des_window.item = @skill_window.skill
		@des_window.update
		update_skill_selection
	elsif @equip_window.active == true
		update_equip_selection
	end
    
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
  # ● 更新指令选择
  #--------------------------------------------------------------------------
  def update_command_selection
	if Input.trigger?(Input::B)
		Sound.play_cancel
		return_secene
	# 确定键
	elsif Input.trigger?(Input::C)
		if @command_window.index == 0
			# 装备
			@command_window.active = false
			@equip_window.active = true 
			@equip_window.visible = true 
			@skill_window.visible = false
			@des_window.visible = false
		elsif @command_window.index ==  1
			@command_window.active = false
			@skill_window.active = true
			@skill_window.visible = true
			@des_window.visible = true
			@equip_window.visible = false
		end
	end
  end
  #--------------------------------------------------------------------------
  # ● 更新选择技能
  #--------------------------------------------------------------------------
  def update_skill_selection
	# 取消
    if Input.trigger?(Input::B)
      Sound.play_cancel
	  @command_window.active = true
	  @skill_window.active = false
	  @des_window.visible = false
	end
  end
  #--------------------------------------------------------------------------
  # ● 更新选择装备部位
  #--------------------------------------------------------------------------
  def update_equip_selection
    # 取消
    if Input.trigger?(Input::B)
      Sound.play_cancel
	  @command_window.active = true
	  @equip_window.active = false
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

















