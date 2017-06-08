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
		# 玩家信息窗口=========================================
		@message_window = Window_Message.new
		# 右边的玩家信息窗口
		@pinfo_window = Window_PlayerInfo.new(1024,0)
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
		$game_map.update                  # 更新地图绘制
		$game_system.update               # 更新计时器
		@message_window.update            # 更新消息窗口
		@spriteset.update                 # 更新活动块元件
		update_player_info                # 更新玩家信息
		#-----------------------------------------------
		#----- 显示战斗面板 battle panel --------------
		update_battle_panel
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
	# ● 切换至菜单画面
	#
	#     重新定义 - 考虑窗口可持续性
	#--------------------------------------------------------------------------
	def call_menu
		$game_temp.next_scene = nil
		Audio.se_play("Audio/SE/AMTT_Cancel")
		$scene = Scene_End.new
		if $battle_back_window != nil
			$battle_back_window.visible = $battle_back_window.active = false
		end
		if $battle_panel_enemy_window != nil
			$battle_panel_enemy_window.visible = $battle_panel_enemy_window.active = false
		end
		if $battle_panel_player_window != nil
			$battle_panel_player_window.visible = $battle_panel_player_window.active = false
		end
		if $battle_status_enemy_window != nil
			$battle_status_enemy_window.visible = $battle_status_enemy_window.active = false
		end
		if $battle_status_player_window != nil
			$battle_status_player_window.visible = $battle_status_player_window.active = false
		end
		if $Spriteset_Battle != nil
			$Spriteset_Battle.visible = $Spriteset_Battle.active = false
			$Spriteset_Battle.update
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
		@pinfo_window.x = 1024.0
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
		if $scene.is_a?(Scene_Battle)       # 正在切换战斗画面的情况下
			perform_battle_transition       # 执行战斗前变换
		end
	end
	
	#--------------------------------------------------------------------------
	# ● 更新战斗信息
	#
	#         新加
	#
	#--------------------------------------------------------------------------
	def update_battle_panel
		# 如果是战斗状态,且是刚刚开始
		if $game_switches[103] == true and $battle_panel_enemy_window == nil
			# 创建背景
			$battle_back_window = Window_BattleBack.new(-32, -32, 1024+64, 768+64)
			$battle_back_window.visible = true
			# 不再更新玩家信息窗口
			@pinfo_window.visible = false
			@pinfo_window.x = 1024
			# 创建新窗口
			#$battle_panel_enemy_window = Window_BattlePanel_Enemy.new(20, 80, 300, 320, -300, 80, 0.05, 0)
			#$battle_panel_enemy_window = Window_BattlePanel_Enemy.new(0, 64, 328, 352, -300, 80, 0.05, 0)
			$battle_panel_enemy_window = Window_BattlePanel_Enemy.new(0, 96, 520, 576, -512, 80, 0.05, 0)
			$battle_panel_enemy_window.setup($game_party.active, $game_monstor_battle)
			#$battle_panel_player_window = Window_BattlePanel_Player.new(320, 80, 300, 320, 640, 80, 0.05, 0)
			#$battle_panel_player_window = Window_BattlePanel_Player.new(320, 64, 328, 352, 640, 80, 0.05, 0)
			$battle_panel_player_window = Window_BattlePanel_Player.new(512, 96, 520, 576, 1024, 80, 0.05, 0)
			$battle_panel_player_window.setup($game_party.active, $game_monstor_battle)
			
			$battle_status_enemy_window = Window_BattleStatusEnemy.new(20,0,1024-40,64+32,20,-(64+32),0,0.04)
			$battle_status_enemy_window.setup($game_monstor_battle)
			$battle_status_player_window = Window_BattleStatusPlayer.new(20,768-96-32,1024-40,96+32,20,768+96+32,0,0.04)
			$battle_status_player_window.setup($game_party.active)
			
			# 设置战斗图显示的位置
			# sprite 的x = 窗口左侧坐标 + sprite左边界到窗口左边界距离(sw_4)
			$game_party.active.screen_x = $battle_panel_player_window.final_x + $battle_panel_player_window.sw_4 + 16
			# sprite 的y = 窗口上侧坐标 + sprite上边界到窗口上边界距离(sh_2)
			$game_party.active.screen_y = $battle_panel_player_window.final_y + $battle_panel_player_window.sh_2 + 16
			$game_party.active.screen_z = 1000
			# sprite 的x = 窗口左侧坐标 + sprite左边界到窗口左边界距离(sw_4)
			$game_monstor_battle.screen_x = $battle_panel_enemy_window.final_x + $battle_panel_enemy_window.sw_4 + 16
			# sprite 的y = 窗口上侧坐标 + sprite上边界到窗口上边界距离(sh_2)
			$game_monstor_battle.screen_y = $battle_panel_enemy_window.final_y + $battle_panel_enemy_window.sh_2 + 16
			$game_monstor_battle.screen_z = 1000
			# 创建sprite 显示战斗图
			$Spriteset_Battle = Spriteset_Battle.new([$game_party.active], [$game_monstor_battle])
			
		# 否则战斗状态已经开始,只需要更新
		elsif $game_switches[103] == true
			if $battle_panel_enemy_window.visible == false or $battle_panel_enemy_window.active == false
				$battle_panel_enemy_window.visible = true
				$battle_panel_enemy_window.active = true
			end
			if $battle_panel_player_window.visible == false or $battle_panel_player_window.active == false
				$battle_panel_player_window.visible = true
				$battle_panel_player_window.active = true
			end
			if $battle_back_window.visible == false or $battle_back_window.active == false
				$battle_back_window.visible = true
				$battle_back_window.active = true
			end
			if $battle_status_enemy_window.visible == false or $battle_status_enemy_window.active == false
				$battle_status_enemy_window.visible = true
				$battle_status_enemy_window.active = true
			end
			if $battle_status_player_window.visible == false or $battle_status_player_window.active == false
				$battle_status_player_window.visible = true
				$battle_status_player_window.active = true
			end
			if $Spriteset_Battle.visible == false or $Spriteset_Battle.active == false
				$Spriteset_Battle.visible = true
				$Spriteset_Battle.active = true
			end
			$battle_panel_enemy_window.update
			$battle_panel_player_window.update
			$battle_status_enemy_window.update
			$battle_status_player_window.update
			# 刷新战斗图，显示动画等等都在这里面完成
			$Spriteset_Battle.update
			# 不再更新玩家信息窗口
			@pinfo_window.visible = false
			@pinfo_window.x = 1024
		else
			# 显示玩家信息
			@pinfo_window.visible = !$game_switches[112]
			# 如果有战斗信息窗口，则释放
			if $battle_panel_enemy_window != nil
				$battle_panel_enemy_window.dispose
				$battle_panel_enemy_window = nil
			end
			if $battle_panel_player_window != nil
				$battle_panel_player_window.dispose
				$battle_panel_player_window = nil
			end
			# 释放背景
			if $battle_back_window != nil
				$battle_back_window.dispose
				$battle_back_window = nil
			end
			# 释放敌人头像窗口
			if $battle_status_enemy_window != nil
				$battle_status_enemy_window.dispose
				$battle_status_enemy_window = nil
			end
			# 释放玩家头像窗口
			if $battle_status_player_window != nil
				$battle_status_player_window.dispose
				$battle_status_player_window = nil
			end
			# 释放sprite
			if $Spriteset_Battle != nil
				$Spriteset_Battle.dispose
				$Spriteset_Battle = nil
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


