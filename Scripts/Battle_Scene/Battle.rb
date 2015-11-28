#==============================================================================
# ■ Battle
#------------------------------------------------------------------------------
# 　处理战斗的模块，包含战斗是用到的常用内容
#==============================================================================

module Battle
	# 调用次函数的时候，$game_monstor_battle 已经准备就绪
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


end