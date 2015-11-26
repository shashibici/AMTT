#==============================================================================
# ■ Scene_Upgrade
#------------------------------------------------------------------------------
# 　二楼的商店
#
#==============================================================================

class Scene_Upgrade1 < Scene_Base
  include GAME_CONF
  #--------------------------------------------------------------------------
  # ● 开始处理
  #
  #      重定义
  #
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    create_shop_window
  end
  #--------------------------------------------------------------------------
  # ● 开始后处理
  #--------------------------------------------------------------------------
  def post_start
    super
  end
  #--------------------------------------------------------------------------
  # ● 更新画面
  #--------------------------------------------------------------------------
  def update  
    super
    @shop1_window.update
    update_select
  end
  #--------------------------------------------------------------------------
  # ● Create Shop Window
  #-------------------------------------------------------------------------
  def create_shop_window
    lvl = $game_variables[97]
    
    commands = [
    
    s1 = "力量+1（价格："+[(lvl*10-100),10].max.to_s+"，购买次数+1）",
    s2 = "敏捷+1（价格："+[(lvl*10-100),10].max.to_s+"，购买次数+1）",
    
    ]
    
    
    @shop1_window = Window_Command.new(280, commands)
    @shop1_window.x = 182
    @shop1_window.y = 270 - @shop1_window.height/2
  end
 
  #--------------------------------------------------------------------------
  # ● Update Select
  #-------------------------------------------------------------------------
  def update_select
    lvl = $game_variables[97]
    if Input.trigger?(Input::B)
      # Cancel
      Sound.play_cancel
      return_scene
    elsif  Input.trigger?(Input::C)
      # Decision
      case @shop1_window.index
      # strength
      when 0  
        # judge gold
        if $game_party.gold >= [(lvl*10-100),10].max
          # enought
          Sound.play_decision
          $game_party.active.strength += 1
          $game_party.active.onEquipChanges
          $game_player.talk("力量+1")
          $game_player.animation_id = 103
          # lose gold
          $game_party.gold -= [(lvl*10-100),10].max
          $game_variables[97] += 1
          return_scene
          
          # lack
        else
          Sound.play_buzzer
        end
      # celerity
      when 1
        # judge gold
        if $game_party.gold >= [(lvl*10-100),10].max
          # enought
          Sound.play_decision
          $game_party.active.celerity += 1
          $game_party.active.onEquipChanges
          $game_player.talk("敏捷+1")
          $game_player.animation_id = 103
          # lose gold
          $game_party.gold -= [(lvl*10-100),10].max
          $game_variables[97] += 1
          return_scene
          # lack
        else
          Sound.play_buzzer
        end
      end # end of 'when'
    end # end of 'if'
  end  

  #--------------------------------------------------------------------------
  # ● 返回
  #-------------------------------------------------------------------------
  def return_scene
    $scene = Scene_Map.new
  end  
  
  #--------------------------------------------------------------------------
  # ● 结束处理
  #
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    @shop1_window.dispose
  end 
  
end

#==============================================================================
# ■ Scene_Shop2
#------------------------------------------------------------------------------
# 　六楼的商店
#
#==============================================================================

class Scene_Upgrade2 < Scene_Base
  include GAME_CONF
  #--------------------------------------------------------------------------
  # ● 开始处理
  #
  #      重定义
  #
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    create_shop_window
  end
  #--------------------------------------------------------------------------
  # ● 开始后处理
  #--------------------------------------------------------------------------
  def post_start
    super
  end
  #--------------------------------------------------------------------------
  # ● 更新画面
  #--------------------------------------------------------------------------
  def update  
    super
    @shop1_window.update
    update_select
  end
  #--------------------------------------------------------------------------
  # ● Create Shop Window
  #-------------------------------------------------------------------------
  def create_shop_window
    lvl = $game_variables[133]+1
    
    commands = [
    
    s1 = "力量+20（价格："+(lvl*800).to_s+"，购买次数+1）",
    s2 = "敏捷+20（价格："+(lvl*800).to_s+"，购买次数+1）",
    
    ]
    
    
    @shop1_window = Window_Command.new(280, commands)
    @shop1_window.x = 182
    @shop1_window.y = 270 - @shop1_window.height/2
  end
  #--------------------------------------------------------------------------
  # ● Update Select
  #-------------------------------------------------------------------------
  def update_select
    lvl = $game_variables[133]+1
    
    if Input.trigger?(Input::B)
      # Cancel
      Sound.play_cancel
      return_scene
    elsif  Input.trigger?(Input::C)
      # Decision
      case @shop1_window.index
      # strength
      when 0  
        # judge gold
        if $game_party.gold >= lvl*800
          # enought
          Sound.play_decision
          $game_party.active.strength += 20
          $game_party.active.onEquipChanges
          $game_player.talk("力量+20")
          $game_player.animation_id = 103
          # lose gold
          $game_party.gold -= lvl*800
          $game_variables[133] += 1
          return_scene
          
          # lack
        else
          Sound.play_buzzer
        end
      # celerity
      when 2
        # judge gold
        if $game_party.gold >= lvl*800
          # enought
          Sound.play_decision
          $game_party.active.celerity += 20
          $game_party.active.onEquipChanges
          $game_player.talk("敏捷+20")
          $game_player.animation_id = 103
          # lose gold
          $game_party.gold -= lvl*800
          $game_variables[133] += 1
          return_scene
          # lack
        else
          Sound.play_buzzer
        end
      end
    end 
  end  
  #--------------------------------------------------------------------------
  # ● 返回
  #-------------------------------------------------------------------------
  def return_scene
    $scene = Scene_Map.new
  end
  #--------------------------------------------------------------------------
  # ● 结束处理
  #
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    @shop1_window.dispose
  end 
end




