{
=begin
	注意：调用Sence_Battle之前，一定要保证传入的players 和 enemies 所代表的 uniq_id 有怪物，不能为nil
	所以调用前一点要先创造好相应的battler，并且将这些battler的uniq_id都保存好
=end
}

#-----------------------------------------------------------------------------
#	基础框架
#-----------------------------------------------------------------------------
class Sence_Battle < Sence_Base
	attr_accessor	:actor_uniq_ids
	attr_accessor	:enemy_uniq_ids
	
	
	#--------------------------------------------------------------------------
	# ●	Given the players' ids and the enemies's ids 
	#--------------------------------------------------------------------------
	def initialize(players, enemies)
		@actor_uniq_ids = players
		@enemy_uniq_ids = enemies
		setupSprites
	end
	
	#--------------------------------------------------------------------------
	# ● 
	#--------------------------------------------------------------------------
	def start
	
	
	end
	#--------------------------------------------------------------------------
	# ● 
	#--------------------------------------------------------------------------
	def post_start
	
	
	end
	
	#--------------------------------------------------------------------------
	# ● 
	#--------------------------------------------------------------------------
	def terminate
	
	
	end

	#--------------------------------------------------------------------------
	# ● 
	#--------------------------------------------------------------------------
	def update
	
	
	
	
	
	
	end
	
	
	
	
	
	

end

#-----------------------------------------------------------------------------
#	动画显示相关
#-----------------------------------------------------------------------------
class Sence_Battle < Sence_Base

	def	setupSprites
		@pSprites = []
		for i in 0..players.size()
			s = Sprite.new
			b = FrameFactory.icon(players[i].icon_file_name,0)
			s.bitmap = FrameFactory.extractBitmap(b, b.rect, 32, 32)
			# magic numbers
			s.x = i * 32
			s.y = 300
			@pSprites.push(s)
		end
		@eSprites = []
		for i in 0..enemies.size()
			s = Sprite.new
			b = FrameFactory.icon(enemies[i].portrait_file_name,0)
			s.bitmap = FrameFactory.extractBitmap(b, b.rect, 96, 96)
			# magic numbers
			s.x = i * 96
			s.y = 32
			@eSprites.push(s)
		end
	end

end

#-----------------------------------------------------------------------------
#	战斗逻辑相关
#-----------------------------------------------------------------------------
class Sence_Battle < Sence_Base

	def players
		result = []
		for p in actor_uniq_ids
			result.push($game_actors[p])
		end
		return result
	end
	
	def enemies
		result = []
		for e in enemy_uniq_ids
			result.push($game_enemies[e])
		end
		return result
	end
	
end



