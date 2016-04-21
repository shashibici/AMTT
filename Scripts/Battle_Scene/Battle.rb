#==============================================================================
# ■ Battle
#------------------------------------------------------------------------------
# 　处理战斗的模块，包含战斗是用到的常用内容
#==============================================================================
module Battle
	#--------------------------------------------------------------------------
	# ●  初始化战斗参数
	#    调用此函数的时候，$game_monstor_battle 已经准备就绪
	#--------------------------------------------------------------------------
	def self.Battle_init
		# 如果强制掉宝
		if $game_switches[160]
			$game_switches[159] = true
			for i in (Array (59..68)) + (Array (168..177)) do
				# 宝物类型,都是防具，后面改武器
				$game_variables[i] = 3
				# 掉宝概率, 100%
				$game_variables[i+20] = 1
			end
			$game_variables[59] = 2
			$game_variables[60] = 2
			$game_variables[69] = $game_monstor_battle.weapon1_id
			$game_variables[70] = $game_monstor_battle.weapon2_id
			$game_variables[71] = $game_monstor_battle.armor1_id
			$game_variables[72] = $game_monstor_battle.armor2_id
			$game_variables[73] = $game_monstor_battle.armor3_id
			$game_variables[74] = $game_monstor_battle.armor4_id
			$game_variables[75] = $game_monstor_battle.armor5_id
			$game_variables[76] = $game_monstor_battle.armor6_id
			$game_variables[77] = $game_monstor_battle.armor7_id
			$game_variables[78] = $game_monstor_battle.armor8_id
			$game_variables[178] = $game_monstor_battle.armor9_id
			$game_variables[179] = $game_monstor_battle.armor10_id
			$game_variables[180] = $game_monstor_battle.armor11_id
			$game_variables[181] = $game_monstor_battle.armor12_id
		end
		$game_switches[160] = false
	end
	#--------------------------------------------------------------------------
	# ●  一个战斗回合 （攻击一次）
	#
	#    可能不会使用
	#
	#
	#    怪物攻击回合，只要怪物攻击剩余时间<=0就会执行一次这个函数
	#	 如果返回值为true,则说明战斗结束，调用者需要执行公共事件
	#	 如果返回值为false,则说明战斗继续，调用者不需要执行公共事件
	#--------------------------------------------------------------------------
	def self.Battle_turn_enemy
		# 阶段计数器
		$attack_phase_enemy = 0
		# 攻击初始化
		attack_pre_start_enemy
		attack_start_enemy
		attack_post_start_enemy
		
		# 执行攻击
		attack_pre_enemy
		attack_enemy
		attack_post_enemy
		
		# 播放动画
		animation_pre_enemy
		animation_enemy
		animation_post_enemy
		
		# 判断战斗是否结束
		attack_pre_judge_enemy
		# 判断是否结束,true结束 false 没结束
		ret = attack_judge_enemy
		attack_post_judge_enemy
		
		# 本回合最后一个阶段
		attack_pre_end_enemy
		attack_end_enemy
		attack_post_end_enemy
		
		return ret
	end
	#--------------------------------------------------------------------------
	# ●  攻击开始前
	#--------------------------------------------------------------------------
	def self.attack_pre_start_enemy
		$attack_phase_enemy = 1
	end
	#--------------------------------------------------------------------------
	# ●  攻击开始
	#--------------------------------------------------------------------------
	def self.attack_start_enemy
		$attack_phase_enemy = 2
		# 修改怪物攻击间隔
		$game_variables[33] += $max_speed * (Graphics.frame_rate + 1)
		$game_switches[106] = false
		$game_variables[34] = 0
		$game_variables[35] = 0
	end
	#--------------------------------------------------------------------------
	# ●  攻击开始后
	#--------------------------------------------------------------------------
	def self.attack_post_start_enemy
		$attack_phase_enemy = 3
	end
	#--------------------------------------------------------------------------
	# ●  攻击前
	#--------------------------------------------------------------------------
	def self.attack_pre_enemy
		$attack_phase_enemy = 4
	end
	#--------------------------------------------------------------------------
	# ●  攻击
	#--------------------------------------------------------------------------
	def self.attack_enemy
		$attack_phase_enemy = 5
		# 执行攻击
		$game_monstor_battle.excuteBattle($game_party.active)
	end
	#--------------------------------------------------------------------------
	# ●  攻击后
	#--------------------------------------------------------------------------
	def self.attack_post_enemy
		$attack_phase_enemy = 6
	end
	#--------------------------------------------------------------------------
	# ●  动画开始前
	#--------------------------------------------------------------------------
	def self.animation_pre_enemy
		$attack_phase_enemy = 7
	end
	#--------------------------------------------------------------------------
	# ●  动画开始
	#--------------------------------------------------------------------------
	def self.animation_enemy
		$attack_phase_enemy = 8
		# 判断怪物是否丢失
		if true == $game_switches[106]
			# 播放闪避音效
			# MySound.play_evasion
			# 显示丢失
			$Spriteset_Battle.enemy.set_talk_text("miss", Color.new(255,255,255))
		# 如果没有丢失
		else
			# 判断怪物是否暴击
			if true == $game_switches[110]
				$game_switches[110] = false
				# 显示暴击
				# $Spriteset_Battle.actor.set_talk_text($game_variables[34].to_i, Color.new(255,255,0))
				$Spriteset_Battle.enemy.set_talk_text($game_variables[34].to_i.to_s+"!", Color.new(255,0,0),1)
				# 播放怪物暴击声音
				# MySound.play_bom($game_variables[45])
				$Spriteset_Battle.actor.battler.animation_id=$game_variables[45]
			# 如果没有暴击
			else
				# 显示伤害
				$Spriteset_Battle.actor.set_talk_text($game_variables[34].to_i, Color.new(255,255,0))
				# 播放伤害动画 - 自带音效
				$Spriteset_Battle.actor.battler.animation_id=107
			end
		end
	end
	#--------------------------------------------------------------------------
	# ●  动画开始后
	#--------------------------------------------------------------------------
	def self.animation_post_enemy
		$attack_phase_enemy = 9
	end
	#--------------------------------------------------------------------------
	# ●  判断战斗结束前
	#--------------------------------------------------------------------------
	def self.attack_pre_judge_enemy
		$attack_phase_enemy = 10
	end
	#--------------------------------------------------------------------------
	# ●  判断战斗结束
	#--------------------------------------------------------------------------
	def self.attack_judge_enemy
		$attack_phase_enemy = 11
		# 如果战斗结束
		if true == $game_switches[104]
			$game_switches[107] = false
			$game_switches[103] = false
			$game_switches[108] = false
			# return true - 战斗结束
			return true
		else
			return false
		end
	end
	#--------------------------------------------------------------------------
	# ●  判断战斗结束后
	#--------------------------------------------------------------------------
	def self.attack_post_judge_enemy
		$attack_phase_enemy = 12
	end
	#--------------------------------------------------------------------------
	# ●  攻击结束前
	#--------------------------------------------------------------------------
	def self.attack_pre_end_enemy
		$attack_phase_enemy = 13
	end
	#--------------------------------------------------------------------------
	# ●  攻击结束
	#--------------------------------------------------------------------------
	def self.attack_end_enemy
		$attack_phase_enemy = 14
	end
	#--------------------------------------------------------------------------
	# ●  攻击结束后
	#--------------------------------------------------------------------------
	def self.attack_post_end_enemy
		$attack_phase_enemy = 15
	end
	#--------------------------------------------------------------------------
	# ●  一个战斗回合 （攻击一次）
	#
	#    可能不会使用
	#
	#
	#    玩家攻击回合，只要玩家攻击剩余时间<=0就会执行一次这个函数
	#	 如果返回值为true,则说明战斗结束，调用者需要执行公共事件
	#	 如果返回值为false,则说明战斗继续，调用者不需要执行公共事件
	#--------------------------------------------------------------------------
	def self.Battle_turn_player
		# 阶段计数器
		$attack_phase_player = 0
		# 攻击初始化
		attack_pre_start_player
		attack_start_player
		attack_post_start_player
		
		# 执行攻击
		attack_pre_player
		attack_player
		attack_post_player
		
		# 播放动画
		animation_pre_player
		animation_player
		animation_post_player
		
		# 判断战斗是否结束
		attack_pre_judge_player
		# 判断是否结束,true结束 false 没结束
		ret = attack_judge_player
		attack_post_judge_player
		
		# 本回合最后一个阶段
		attack_pre_end_player
		attack_end_player
		attack_post_end_player
		
		return ret
	end
	#--------------------------------------------------------------------------
	# ●  攻击开始前
	#--------------------------------------------------------------------------
	def self.attack_pre_start_player
		$attack_phase_player = 1
	end
	#--------------------------------------------------------------------------
	# ●  攻击开始
	#--------------------------------------------------------------------------
	def self.attack_start_player
		$attack_phase_player = 2
		# 修改玩家攻击间隔
		$game_variables[32] += $max_speed * (Graphics.frame_rate + 1)
	end
	#--------------------------------------------------------------------------
	# ●  攻击开始后
	#--------------------------------------------------------------------------
	def self.attack_post_start_player
		$attack_phase_player = 3
	end
	#--------------------------------------------------------------------------
	# ●  攻击前
	#--------------------------------------------------------------------------
	def self.attack_pre_player
		$attack_phase_player = 4
	end
	#--------------------------------------------------------------------------
	# ●  攻击
	#--------------------------------------------------------------------------
	def self.attack_player
		$attack_phase_player = 5
		# 清空伤害变量，次伤害变量在显示伤害的时候有用
		$game_switches[105] = false
		$game_variables[34] = 0
		$game_variables[35] = 0
		# 执行攻击
		$game_party.active.excuteBattle($game_monstor_battle)
	end
	#--------------------------------------------------------------------------
	# ●  攻击后
	#--------------------------------------------------------------------------
	def self.attack_post_player
		$attack_phase_player = 6
	end
	#--------------------------------------------------------------------------
	# ●  动画开始前
	#--------------------------------------------------------------------------
	def self.animation_pre_player
		$attack_phase_player = 7
	end
	#--------------------------------------------------------------------------
	# ●  动画开始
	#--------------------------------------------------------------------------
	def self.animation_player
		$attack_phase_player = 8
		# 判断玩家是否丢失
		if true == $game_switches[105]
			# 播放闪避音效
			# MySound.play_evasion
			# 显示丢失
			$Spriteset_Battle.actor.set_talk_text("miss", Color.new(255,255,255))
		# 如果没有丢失
		else
			# 判断玩家是否暴击
			if true == $game_switches[109]
				$game_switches[109] = false
				# 显示暴击
				# $Spriteset_Battle.enemy.set_talk_text($game_variables[35].to_i, Color.new(255,0,0))
				$Spriteset_Battle.actor.set_talk_text($game_variables[35].to_i.to_s+"!", Color.new(255,0,0),1)
				# 播放玩家暴击声音
				# MySound.play_bom(3)
				$Spriteset_Battle.enemy.battler.animation_id = 111
			# 如果没有暴击
			else
				# 显示伤害
				$Spriteset_Battle.enemy.set_talk_text($game_variables[35].to_i, Color.new(255,255,0))
				$Spriteset_Battle.enemy.battler.animation_id = 110
			end
			
		end
	end
	#--------------------------------------------------------------------------
	# ●  动画开始后
	#--------------------------------------------------------------------------
	def self.animation_post_player
		$attack_phase_player = 9
	end
	#--------------------------------------------------------------------------
	# ●  判断战斗结束前
	#--------------------------------------------------------------------------
	def self.attack_pre_judge_player
		$attack_phase_player = 10
	end
	#--------------------------------------------------------------------------
	# ●  判断战斗结束
	#--------------------------------------------------------------------------
	def self.attack_judge_player
		$attack_phase_player = 11
		# 如果战斗结束
		if true == $game_switches[104]
			$game_switches[108] = false
			$game_switches[107] = false
			$game_switches[103] = false
			# return true - 战斗结束
			return true
		else
			return false
		end
	end
	#--------------------------------------------------------------------------
	# ●  判断战斗结束后
	#--------------------------------------------------------------------------
	def self.attack_post_judge_player
		$attack_phase_player = 12
	end
	#--------------------------------------------------------------------------
	# ●  攻击结束前
	#--------------------------------------------------------------------------
	def self.attack_pre_end_player
		$attack_phase_player = 13
	end
	#--------------------------------------------------------------------------
	# ●  攻击结束
	#--------------------------------------------------------------------------
	def self.attack_end_player
		$attack_phase_player = 14
	end
	#--------------------------------------------------------------------------
	# ●  攻击结束后
	#--------------------------------------------------------------------------
	def self.attack_post_end_player
		$attack_phase_player = 15
	end
end