#==============================================================================
# ■ Scene_Skill
#------------------------------------------------------------------------------
#	重定义覆盖之前定义
#
# 	显示角色学会了那些特技
#==============================================================================

class Scene_Skill < Scene_Base
	#--------------------------------------------------------------------------
	# ● 初始化对象
	#     actor_index : 角色索引
	#--------------------------------------------------------------------------
	def initialize(actor_index = 0)
		@actor_index = actor_index
	end
	#--------------------------------------------------------------------------
	# ● 开始处理
	#--------------------------------------------------------------------------
	def start
		super
		@actor = $game_party.members[@actor_index]
		create_windows
		@skill = nil
		@skill_to_switch = 0
		@adjustment = false
	end
	#--------------------------------------------------------------------------
	# ● 创建窗口
	#--------------------------------------------------------------------------
	def create_windows
		@skill_window = Window_Skill.new(0, 0, 106, 480, @actor)
		@skill_window.refresh_skill_items
		@options_window = Window_Command.new(172, ["调整", "删除"])
		@confirmation_window = Window_Command.new(172, ["否", "是"])
		@options_window.x = (Graphics.width - @options_window.width) / 2.0
		@options_window.y = (Graphics.height - @options_window.height) / 2.0
		@confirmation_window.x = (Graphics.width - @options_window.width) / 2.0
		@confirmation_window.y = @options_window.y + @options_window.height + 8
		@options_window.active = @options_window.visible = false
		@confirmation_window.active = @confirmation_window.visible = false
		@des_window = Window_SkillDescription.new(106, 0, 640-106, 480)
		@des_window.item = @skill_window.skill
		@des_window.active = true
		@des_window.visible = true
	end
	#--------------------------------------------------------------------------
	# ● 结束处理
	#--------------------------------------------------------------------------
	def terminate
		super
		@skill_window.dispose
		@options_window.dispose
		@confirmation_window.dispose
		@des_window.dispose
	end
	#--------------------------------------------------------------------------
	# ● 还原至原来的画面
	#
	#    重新定义
	#
	#--------------------------------------------------------------------------
	def return_scene
		$scene = Scene_Menu2.new(1)
	end
	#--------------------------------------------------------------------------
	# ● 更新画面
	#--------------------------------------------------------------------------
	def update
		super
		@skill_window.update
		@options_window.update
		@confirmation_window.update
		if @skill_window.active
			update_skill_selection
			@des_window.item = @skill_window.skill
			@des_window.update
		elsif @options_window.active
			update_options
		elsif @confirmation_window.active
			update_confirmation
		end	
	end
	#--------------------------------------------------------------------------
	# ● 更新选择特技
	#--------------------------------------------------------------------------
	def update_skill_selection
		if Input.trigger?(Input::B)
			if @adjustment == true
				MySound.play_decision
				@adjustment = false
			else
				Sound.play_cancel
				return_scene
			end
		# 如果选择确定使用技能
		elsif Input.trigger?(Input::C)
			if true == @adjustment
				MySound.play_decision
				@adjustment = false
			else
				@skill = @skill_window.skill
				# 播放确定音
				Sound.play_decision
				# 技能不为空，显示-需要删除技能还是修改优先级
				if @skill != nil
					display_options
				end
			end
		elsif Input.trigger?(Input::DOWN) or Input.trigger?(Input::UP)
			if @skill_window.skill_max > 1 and true == @adjustment
				@skill_to_switch = @skill_window.skill
				@actor.delete_skill(@skill)
				@actor.delete_skill(@skill_to_switch)
				priority = @skill_to_switch.priority
				@skill_to_switch.priority = @skill.priority
				@skill.priority = priority
				@actor.add_skill(@skill)
				@actor.add_skill(@skill_to_switch)
				@skill_window.refresh_skill_items
			end
		end
	end
	#--------------------------------------------------------------------------
	# ● 显示技能窗口
	#--------------------------------------------------------------------------
	def display_skills
		@skill_window.active = true
		@options_window.visible = false
		@options_window.active = false
		@confirmation_window.active = false
		@confirmation_window.visible = false
	end
	#--------------------------------------------------------------------------
	# ● 更新选择窗口
	#--------------------------------------------------------------------------
	def update_options
		if Input.trigger?(Input::B)
			Sound.play_cancel
			@adjustment = false
			display_skills
		elsif Input.trigger?(Input::C)
			Sound.play_decision
			# 调整
			if 0 == @options_window.index
				@adjustment = true
				display_skills
			# 删除
			else
				@adjustment = false
				display_confirmation
			end
		end
	end
	#--------------------------------------------------------------------------
	# ● 显示选择窗口
	#--------------------------------------------------------------------------
	def display_options
		@options_window.visible = true
		@options_window.active = true
		@confirmation_window.active = false
		@confirmation_window.visible = false
		@skill_window.active = false
	end
	#--------------------------------------------------------------------------
	# ● 更新确定窗口
	#--------------------------------------------------------------------------
	def update_confirmation
		if Input.trigger?(Input::B)
			Sound.play_cancel
			display_options
		elsif Input.trigger?(Input::C)
			if 1 ==  @confirmation_window.index
				MySound.play_decision
				@actor.delete_skill(@skill)
				@skill = nil
				@skill_window.refresh_skill_items
				display_skills
			else
				Sound.play_cancel
				display_options
			end
		end
	end
	#--------------------------------------------------------------------------
	# ● 显示确定窗口
	#--------------------------------------------------------------------------
	def display_confirmation
		@confirmation_window.active = true
		@confirmation_window.visible = true
		@options_window.active = false
		@skill_window.active = false
	end
end
