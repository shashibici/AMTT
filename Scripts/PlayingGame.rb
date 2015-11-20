#==============================================================================
# ■ PlayingGame
#------------------------------------------------------------------------------
#   处理赌博的模块
#==============================================================================

module PlayingGame
	
	def self.playing_500
		res = rand(1000)
		if res < 800
			c = res % 73
			case c
				when 0
				$game_player.talk("遇到强盗，把东西抢走了！")
				when 1
				$game_party.gain_item($data_weapons[3], 1)
				$game_player.talk("获得"+$data_weapons[3].name)
				when 2
				$game_party.gain_item($data_weapons[4], 1)
				$game_player.talk("获得"+$data_weapons[4].name)
				when 3
				$game_party.gain_item($data_weapons[5], 1)
				$game_player.talk("获得"+$data_weapons[5].name)
				when 4
				$game_party.gain_item($data_weapons[6], 1)
				$game_player.talk("获得"+$data_weapons[6].name)
				when 5
				$game_party.gain_item($data_weapons[7], 1)
				$game_player.talk("获得"+$data_weapons[7].name)
				when 6
				$game_party.gain_item($data_weapons[8], 1)
				$game_player.talk("获得"+$data_weapons[8].name)
				when 7
				$game_party.gain_item($data_weapons[20], 1)
				$game_player.talk("获得"+$data_weapons[20].name)
				when 8
				$game_party.gain_item($data_weapons[21], 1)
				$game_player.talk("获得"+$data_weapons[21].name)
				when 9
				$game_party.gain_item($data_weapons[22], 1)
				$game_player.talk("获得"+$data_weapons[22].name)
				when 10
				$game_party.gain_item($data_weapons[23], 1)
				$game_player.talk("获得"+$data_weapons[23].name)
				when 11
				$game_party.gain_item($data_weapons[24], 1)
				$game_player.talk("获得"+$data_weapons[24].name)
				when 12
				$game_party.gain_item($data_weapons[25], 1)
				$game_player.talk("获得"+$data_weapons[25].name)
				
				when 13
				$game_party.gain_item($data_armors[21], 1)
				$game_player.talk("获得"+$data_armors[21].name)
				when 14
				$game_party.gain_item($data_armors[22], 1)
				$game_player.talk("获得"+$data_armors[22].name)
				when 15
				$game_party.gain_item($data_armors[23], 1)
				$game_player.talk("获得"+$data_armors[23].name)
				when 16
				$game_party.gain_item($data_armors[24], 1)
				$game_player.talk("获得"+$data_armors[24].name)
				when 17
				$game_party.gain_item($data_armors[25], 1)
				$game_player.talk("获得"+$data_armors[25].name)
				when 18
				$game_party.gain_item($data_armors[26], 1)
				$game_player.talk("获得"+$data_armors[26].name)
				when 19
				$game_party.gain_item($data_armors[27], 1)
				$game_player.talk("获得"+$data_armors[27].name)
				when 20
				$game_party.gain_item($data_armors[41], 1)
				$game_player.talk("获得"+$data_armors[41].name)
				when 21
				$game_party.gain_item($data_armors[42], 1)
				$game_player.talk("获得"+$data_armors[42].name)
				when 22
				$game_party.gain_item($data_armors[43], 1)
				$game_player.talk("获得"+$data_armors[43].name)
				when 23
				$game_party.gain_item($data_armors[44], 1)
				$game_player.talk("获得"+$data_armors[44].name)
				when 24
				$game_party.gain_item($data_armors[45], 1)
				$game_player.talk("获得"+$data_armors[45].name)
				when 25
				$game_party.gain_item($data_armors[46], 1)
				$game_player.talk("获得"+$data_armors[46].name)
				when 26
				$game_party.gain_item($data_armors[51], 1)
				$game_player.talk("获得"+$data_armors[51].name)
				when 27
				$game_party.gain_item($data_armors[52], 1)
				$game_player.talk("获得"+$data_armors[52].name)
				when 28
				$game_party.gain_item($data_armors[53], 1)
				$game_player.talk("获得"+$data_armors[53].name)
				when 29
				$game_party.gain_item($data_armors[54], 1)
				$game_player.talk("获得"+$data_armors[54].name)
				when 30
				$game_party.gain_item($data_armors[55], 1)
				$game_player.talk("获得"+$data_armors[55].name)
				when 31
				$game_party.gain_item($data_armors[56], 1)
				$game_player.talk("获得"+$data_armors[56].name)
				when 32
				$game_party.gain_item($data_armors[71], 1)
				$game_player.talk("获得"+$data_armors[71].name)
				when 33
				$game_party.gain_item($data_armors[72], 1)
				$game_player.talk("获得"+$data_armors[72].name)
				when 34
				$game_party.gain_item($data_armors[73], 1)
				$game_player.talk("获得"+$data_armors[73].name)
				when 35
				$game_party.gain_item($data_armors[74], 1)
				$game_player.talk("获得"+$data_armors[74].name)
				when 36
				$game_party.gain_item($data_armors[75], 1)
				$game_player.talk("获得"+$data_armors[75].name)
				when 37
				$game_party.gain_item($data_armors[76], 1)
				$game_player.talk("获得"+$data_armors[76].name)
				when 38
				$game_party.gain_item($data_armors[91], 1)
				$game_player.talk("获得"+$data_armors[91].name)
				when 39
				$game_party.gain_item($data_armors[92], 1)
				$game_player.talk("获得"+$data_armors[92].name)
				when 40
				$game_party.gain_item($data_armors[93], 1)
				$game_player.talk("获得"+$data_armors[93].name)
				when 41
				$game_party.gain_item($data_armors[94], 1)
				$game_player.talk("获得"+$data_armors[94].name)
				when 42
				$game_party.gain_item($data_armors[95], 1)
				$game_player.talk("获得"+$data_armors[95].name)
				when 43
				$game_party.gain_item($data_armors[96], 1)
				$game_player.talk("获得"+$data_armors[96].name)
				when 44
				$game_party.gain_item($data_armors[97], 1)
				$game_player.talk("获得"+$data_armors[97].name)
				when 45
				$game_party.gain_item($data_armors[98], 1)
				$game_player.talk("获得"+$data_armors[98].name)
				when 46
				$game_party.gain_item($data_armors[107], 1)
				$game_player.talk("获得"+$data_armors[107].name)
				when 47
				$game_party.gain_item($data_armors[108], 1)
				$game_player.talk("获得"+$data_armors[108].name)
				when 48
				$game_party.gain_item($data_armors[109], 1)
				$game_player.talk("获得"+$data_armors[109].name)
				when 49
				$game_party.gain_item($data_armors[110], 1)
				$game_player.talk("获得"+$data_armors[110].name)
				when 50
				$game_party.gain_item($data_armors[111], 1)
				$game_player.talk("获得"+$data_armors[111].name)
				when 51
				$game_party.gain_item($data_armors[112], 1)
				$game_player.talk("获得"+$data_armors[112].name)	
				when 52
				$game_party.gain_item($data_armors[113], 1)
				$game_player.talk("获得"+$data_armors[113].name)
				
				when 53
				$game_party.gain_item($data_items[10], 1)
				$game_player.talk("获得"+$data_items[10].name)
				when 54
				$game_party.gain_item($data_items[11], 1)
				$game_player.talk("获得"+$data_items[11].name)
				when 55
				$game_party.gain_item($data_items[20], 1)
				$game_player.talk("获得"+$data_items[20].name)
				when 56
				$game_party.gain_item($data_items[25], 1)
				$game_player.talk("获得"+$data_items[25].name)
				when 57
				$game_party.gain_item($data_items[29], 1)
				$game_player.talk("获得"+$data_items[29].name)
				when 58
				$game_party.gain_item($data_items[34], 1)
				$game_player.talk("获得"+$data_items[34].name)
				when 59
				$game_party.gain_item($data_items[38], 1)
				$game_player.talk("获得"+$data_items[38].name)
				when 60
				$game_party.gain_item($data_items[53], 1)
				$game_player.talk("获得"+$data_items[53].name)
				when 61
				$game_party.gain_item($data_items[57], 1)
				$game_player.talk("获得"+$data_items[57].name)
				when 62
				$game_party.gain_item($data_items[61], 1)
				$game_player.talk("获得"+$data_items[61].name)
				when 63
				$game_party.gain_item($data_items[66], 1)
				$game_player.talk("获得"+$data_items[66].name)
				when 64
				$game_party.gain_item($data_items[66], 1)
				$game_player.talk("获得"+$data_items[66].name)
				when 65
				$game_party.gain_item($data_items[66], 1)
				$game_player.talk("获得"+$data_items[66].name)
				when 66
				$game_party.gain_item($data_items[66], 1)
				$game_player.talk("获得"+$data_items[66].name)
				when 67
				$game_party.gain_item($data_items[42], 1)
				$game_player.talk("获得"+$data_items[42].name)
				when 68
				$game_party.gain_item($data_items[42], 1)
				$game_player.talk("获得"+$data_items[42].name)
				when 69
				$game_party.gain_item($data_items[42], 1)
				$game_player.talk("获得"+$data_items[42].name)
				when 70
				$game_party.gain_item($data_items[42], 1)
				$game_player.talk("获得"+$data_items[42].name)
				when 71
				$game_party.gain_item($data_items[43], 1)
				$game_player.talk("获得"+$data_items[43].name)
				when 72
				$game_party.gain_item($data_items[43], 1)
				$game_player.talk("获得"+$data_items[43].name)
				when 73
				$game_party.gain_item($data_items[44], 1)
				$game_player.talk("获得"+$data_items[44].name)
			end
		else
			$game_player.talk("赌输了!!!!")
		end	
	end
	
	
	
end
