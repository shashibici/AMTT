#==============================================================================
# ■ Scene_Map
#------------------------------------------------------------------------------
# 　处理地图画面的类。
#==============================================================================

class Scene_Map < Scene_Base

  #--------------------------------------------------------------------------
  # ● 开始处理
  #
  #       重定义
  #
  #--------------------------------------------------------------------------
  def start
    super
    # 玩家队伍刷新
    $game_map.refresh
    # 新建精灵
    @spriteset = Spriteset_Map.new
    # 创建一个新的战斗窗口
    @battle_show_window1 = nil
    @battle_show_window2 = nil
    @battle_show_window22 = nil
    @battle_show_window3 = nil
    @battle_show_window33 = nil
    
    #------------------------------------------------------
    # 如果地图技不为空
    if @mapskill
      if @mapskill_range
        set_range_effect(@mapskill_range,8)
      else
        set_range_effect(@mapskill_effectrange,8)
      end
      set_range_position($game_player.x, $game_player.y)
    end
    # 否则不是地图技，继续执行
    #-------------------------------------------------------
    
    
    # 玩家信息窗口=========================================
    @message_window = Window_Message.new
    # 右边的玩家信息窗口
    @pinfo_window = Window_PlayerInfo.new(448,0)
    # 默认战斗为false
    @territory_active = false
    
    # 先创建玩家信息窗口，避免到时候出问题
    @pinfo_window.setup($game_heros[$player_type])
    @pinfo_window.contents_opacity = 0
    
    # 根据系统要求显示或隐藏玩家信息
    if $game_system.show_info
      show_player_info
    else
      hide_player_info
    end
    
  end  
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #
  #      重定义
  #
  #--------------------------------------------------------------------------
  def update
    super
    $game_map.interpreter.update      # 更新解释器
    $game_map.update                  # 更新滴入
    $game_system.update               # 更新计时器
    @message_window.update            # 更新消息窗口
    @spriteset.update                 # 更新活动块元件
    

    update_player_info                # 更新玩家信息
    
    #---- 添加--更新战斗信息------------------------
    update_battle_show1
    update_battle_show2
    update_battle_show3
    #-----------------------------------------------
    
    
    unless $game_message.visible      # 正在显示消息以外的情况
            # 更新玩家
            $game_player.update               

            update_transfer_player
            
            # 侦测是否呼唤了菜单
            update_call_menu
            
            # 侦测是否跳跃楼层
            update_call_skip
            
            # 侦测是否调用调试，可以不用
            update_call_debug
            
            # 侦测是否切换了角色
            update_switch_player
            
            # 侦测是否场景转换
            update_scene_change 
    end
      
  end
  #--------------------------------------------------------------------------
  # ● 显示玩家信息
  #
  #    重写覆盖
  #
  #--------------------------------------------------------------------------
  def show_player_info
    # 首先更新信息更新
    @pinfo_window.refresh
    # 窗口的初试位置
    @pinfo_window.x = 640.0
    @pinfo_window.visible = true  
    $game_system.show_info = true
  end
  #--------------------------------------------------------------------------
  # ● 隐藏玩家信息
  #
  #        重定义
  #
  #--------------------------------------------------------------------------
  def hide_player_info
    @pinfo_window.visible = false
    $game_system.show_info = false
  end
  #--------------------------------------------------------------------------
  # ● 更新玩家信息
  #
  #        重定义写
  #
  #--------------------------------------------------------------------------
  def update_player_info  
    @pinfo_window.update
  end
  #--------------------------------------------------------------------------
  # ● 结束处理
  #
  #      重定义
  #
  #--------------------------------------------------------------------------
  def terminate
    super
    if $scene.is_a?(Scene_Battle)     # 正在切换战斗画面的情况下
      @spriteset.dispose_characters   # 为了生成背景隐藏角色
    end
    snapshot_for_background
    @spriteset.dispose
    @message_window.dispose
    @pinfo_window.dispose
    @target_sprite.dispose if @target_sprite
    
    @battle_show_window1.dispose if @battle_show_window1 != nil
    @battle_show_window2.dispose if @battle_show_window2 != nil
    @battle_show_window22.dispose if @battle_show_window22 != nil
    @battle_show_window3.dispose if @battle_show_window3 != nil
    @battle_show_window33.dispose if @battle_show_window33 != nil

    if $scene.is_a?(Scene_Battle)     # 正在切换战斗画面的情况下
      perform_battle_transition       # 执行战斗前变换
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 更新战斗信息
  #
  #         新加
  #
  #--------------------------------------------------------------------------
  def update_battle_show1
    # 如果是战斗状态,且是刚刚开始
    if $game_switches[103] == true and @battle_show_window1 == nil
      # 不再更新玩家信息窗口
      @pinfo_window.visible = false
      @pinfo_window.x = 640
      # 创建新窗口
      @battle_show_window1 = Window_BattleShow1.new(0,0)
      @battle_show_window1.setup($game_party.active, $game_monstor_battle)
      
      # 创建背景
      @battleshow_viewport = Viewport.new(0,0,644,200)
      @battleshow_back = Sprite.new(@battleshow_viewport)
      @battleshow_back.y = 0
      @battleshow_back.z = 0      
      @battleshow_back.bitmap = Cache.system("MessageBack")
      
    # 否则战斗状态已经开始,只需要更新
    elsif $game_switches[103] == true
      # 更新战斗信息窗口
      @battle_show_window1.update
      
    # 否则不是战斗状态  
    else
      # 显示玩家信息
      @pinfo_window.visible = !$game_switches[112]
      # 如果有战斗信息窗口，则释放
      if @battle_show_window1 != nil
        @battle_show_window1.dispose
        @battle_show_window1 = nil
      end
      
      # 释放背景窗口
      if @battleshow_viewport != nil
        @battleshow_viewport.dispose 
        @battleshow_viewport = nil
      end
      
      if @battleshow_back != nil
        @battleshow_back.dispose
        @battleshow_back = nil
      end
      
    end
  end
  #--------------------------------------------------------------------------
  # ● 更新战斗信息
  #
  #         新加
  #
  #--------------------------------------------------------------------------
  def update_battle_show2
    # 如果战斗开始且第一个血条窗没有初始化
    if $game_switches[103] == true and @battle_show_window2 == nil
      # 不再更新玩家信息窗口
      @pinfo_window.visible = false
      @pinfo_window.x = 640
      # 创建新窗口
      @battle_show_window2 = Window_BattleShow2.new(64,24)
      @battle_show_window2.setup($game_monstor_battle)
    end
    
    # 如果是战斗状态且第二个血条窗没有初始化
    if $game_switches[103] == true and @battle_show_window22 == nil
      # 不再更新玩家信息窗口
      @pinfo_window.visible = false
      @pinfo_window.x = 640
      # 创建新窗口
      @battle_show_window22 = Window_BattleShow2.new(64+320,24)
      @battle_show_window22.setup($game_party.active)
    end
      
    # 判断战斗是否开始
    if $game_switches[103] == true
      # 更新战斗信息窗口
      @battle_show_window2.update
      @battle_show_window22.update
    # 否则不是战斗状态  
    else
      # 显示玩家信息
      @pinfo_window.visible = !$game_switches[112]
      # 如果有战斗信息窗口，则释放
      if @battle_show_window2 != nil
        @battle_show_window2.dispose
        @battle_show_window2 = nil
      end
      if @battle_show_window22 != nil
        @battle_show_window22.dispose
        @battle_show_window22 = nil
      end
    end
  end 
  #--------------------------------------------------------------------------
  # ● 更新战斗信息
  #
  #         新加
  #
  #--------------------------------------------------------------------------
  def update_battle_show3
    # 如果战斗开始且第一个血条窗没有初始化
    if $game_switches[103] == true and @battle_show_window3 == nil
      # 不再更新玩家信息窗口
      @pinfo_window.visible = false
      @pinfo_window.x = 640
      # 创建新窗口
      @battle_show_window3 = Window_BattleShow3.new(0,64)
      @battle_show_window3.setup($game_monstor_battle)
    end
    
    # 如果是战斗状态且第二个血条窗没有初始化
    if $game_switches[103] == true and @battle_show_window33 == nil
      # 不再更新玩家信息窗口
      @pinfo_window.visible = false
      @pinfo_window.x = 640
      # 创建新窗口
      @battle_show_window33 = Window_BattleShow3.new(312,64)
      @battle_show_window33.setup($game_party.active)
    end
      
    # 判断战斗是否开始
    if $game_switches[103] == true
      # 更新战斗信息窗口
      @battle_show_window3.update
      @battle_show_window33.update
    # 否则不是战斗状态  
    else
      # 显示玩家信息
      @pinfo_window.visible = !$game_switches[112]
      # 如果有战斗信息窗口，则释放
      if @battle_show_window3 != nil
        @battle_show_window3.dispose
        @battle_show_window3 = nil
      end
      if @battle_show_window33 != nil
        @battle_show_window33.dispose
        @battle_show_window33 = nil
      end
    end
  end  
  #--------------------------------------------------------------------------
  # ● 判断调用怪物手册
  #
  #     重定义覆盖，废弃不用
  #
  #--------------------------------------------------------------------------
  def update_call_handbook
  end 
  
  #--------------------------------------------------------------------------
  # ● 判断是否按了跳跃键
  #--------------------------------------------------------------------------
  def update_call_skip
    # 下楼
    if Input.trigger?(Input::R)
      return if $game_map.interpreter.running?        # 正在执行事件？
      return if $game_switches[103] == true
      # 判断是否最低楼层
      if $game_variables[42] <= 0
        Sound.play_buzzer
        $game_temp.common_event_id = 40
        return
      end
      # 否则不是最低楼层,可以传送，直接激活当层的下楼事件
      $game_map.events[$game_variables[111]].start
      
    end
    
    # 上楼
    if Input.trigger?(Input::L)
      return if $game_map.interpreter.running?        # 正在执行事件？
      return if $game_switches[103] == true
      # 判断是否最高楼层
      if $game_variables[42] >= $game_variables[109]
        Sound.play_buzzer
        $game_temp.common_event_id = 40
        return
      end      
      # 否则不是最高楼层,可以传送，直接激活当层的上楼事件
      $game_map.events[$game_variables[110]].start    
    end    
  end  

end


