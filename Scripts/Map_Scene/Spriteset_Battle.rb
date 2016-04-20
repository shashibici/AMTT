#==============================================================================
# ■ Spriteset_Battle
#------------------------------------------------------------------------------
# 　处理战斗画面的活动块的类。本类在 Scene_Battle 类
# 的内部使用。
#
#
#   此处重新定义，完全覆盖前面定义
#
#
#==============================================================================

class Spriteset_Battle
	attr_accessor       :active
	attr_accessor       :visible
	attr_accessor       :actor_sprites
	attr_accessor		  :enemy_sprites
	#--------------------------------------------------------------------------
	# ● 初始化对象
	#--------------------------------------------------------------------------
	def initialize(players, monsters)
		@monsters = monsters
		@players = players
		@active = true
		@visible = true
		setup(@players, @monsters)
	end
	#--------------------------------------------------------------------------
	# ● 便于随时调用
	#--------------------------------------------------------------------------
	def setup(players, monsters)
		@players = players
		@monsters = monsters
		if @enemy_sprites != nil
			dispose_enemies
		end
		if @actor_sprites != nil
			dispose_actors
		end
		if @viewport1 != nil
			dispose_viewports
		end
		create_viewports
		create_enemies
		create_actors
		update
	end
	#--------------------------------------------------------------------------
	# ● 生成视区
	#--------------------------------------------------------------------------
	def create_viewports
		@viewport1 = Viewport.new(0, 0, 640, 480)
		@viewport1.z = 1000
	end
	#--------------------------------------------------------------------------
	# ● 生成敌方角色活动快
	#--------------------------------------------------------------------------
	def create_enemies
		@enemy_sprites = []
		for enemy in @monsters
			@enemy_sprites.push(Sprite_Battler.new(@viewport1, enemy))
		end
	end
	#--------------------------------------------------------------------------
	# ● 生成角色活动块
	#    默认不显示我方角色的活动块、为了方便、敌人与我方角色同时
	# 生成活动块。
	#--------------------------------------------------------------------------
	def create_actors
		@actor_sprites = []
		for player in @players
			@actor_sprites.push(Sprite_Battler.new(@viewport1, player))
		end
	end
	#--------------------------------------------------------------------------
	# ● 出于兼容性考虑使用该函数
	#   对外暴露访问一个 actor sprite 的接口
	#	如果以后需要修改成为访问多个acotr sprites, 增加新的接口
	#--------------------------------------------------------------------------
	def actor
		return @actor_sprites[0]
	end
	#--------------------------------------------------------------------------
	# ● 出于兼容性考虑使用该函数
	#   对外暴露访问一个 enemy sprite 的接口
	#	如果以后需要修改成为访问多个enemy sprites, 增加新的接口
	#--------------------------------------------------------------------------
	def enemy
		return @enemy_sprites[0]
	end
	#--------------------------------------------------------------------------
	# ● 释放
	#--------------------------------------------------------------------------
	def dispose
		dispose_enemies
		dispose_actors
		dispose_viewports
	end
	#--------------------------------------------------------------------------
		# ● 释放敌方角色活动块
	#--------------------------------------------------------------------------
	def dispose_enemies
		for sprite in @enemy_sprites
		sprite.dispose
	end
	end
	#--------------------------------------------------------------------------
		# ● 释放角色活动块
	#--------------------------------------------------------------------------
	def dispose_actors
		for sprite in @actor_sprites
			sprite.dispose
		end
	end
	#--------------------------------------------------------------------------
		# ● 释放视区
	#--------------------------------------------------------------------------
	def dispose_viewports
		@viewport1.dispose
	end
	#--------------------------------------------------------------------------
		# ● 更新画面
	#--------------------------------------------------------------------------
	def update
		# 判断是否可见
		if true == @visible
			@viewport1.z = 1000
			for enemy_sprit in @enemy_sprites
				enemy_sprit.opacity = 255
			end
			for player_sprit in @actor_sprites
				player_sprit.opacity = 255
			end
			else
			@viewport1.z = 0
			for enemy_sprit in @enemy_sprites
				enemy_sprit.opacity = 0
			end
			for player_sprit in @actor_sprites
				player_sprit.opacity = 0
			end
		end
		# 判断是否停止更新
			#~     if false == @active
			#~       for enemy_sprit in @enemy_sprites
			#~         enemy_sprit.battler = nil
			#~       end
			#~       for player_sprit in @actor_sprites
			#~         player_sprit.battler = nil
			#~       end
			#~     else
			#~       for i in 0...@enemy_sprites.size
			#~         @enemy_sprites[i].battler = @monsters[i]
			#~       end
			#~       for i in 0...@actor_sprites.size
			#~         @actor_sprites[i].battler = @players[i]
			#~       end
		#~     end
		update_enemies
		update_actors
		update_viewports
	end
	#--------------------------------------------------------------------------
		# ● 更新敌方角色活动块
	#--------------------------------------------------------------------------
	def update_enemies
		for sprite in @enemy_sprites
			sprite.update
		end
	end
	#--------------------------------------------------------------------------
		# ● 更新角色活动块
	#--------------------------------------------------------------------------
	def update_actors
		for sprite in @actor_sprites
			sprite.update
		end
	end
	#--------------------------------------------------------------------------
		# ● 更新视区
	#--------------------------------------------------------------------------
	def update_viewports
		#~     @viewport1.tone = $game_troop.screen.tone
		#~     @viewport1.ox = $game_troop.screen.shake
		@viewport1.update
	end
	#--------------------------------------------------------------------------
		# ● 判断是否正在显示动画
	#--------------------------------------------------------------------------
	def animation?
		for sprite in @enemy_sprites + @actor_sprites
			return true if sprite.animation?
		end
		return false
	end
end
