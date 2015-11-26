#==============================================================================
	# ■ Scene_Instructor
	#------------------------------------------------------------------------------
	# 　处理帮助的类
#==============================================================================

class Scene_Instructor < Scene_Base
	WLH = 24
	#--------------------------------------------------------------------------
		# ● 初始化对象
		#     menu_index : 指令光标初期位置
	#--------------------------------------------------------------------------
	def initialize(menu_index = 0)
		@menu_index = menu_index
		
	end
	#--------------------------------------------------------------------------
		# ● 开始处理
	#--------------------------------------------------------------------------
	def start
		super
		create_menu_background
		# 创建指令窗口
		create_command_window
		
		# 创建背景窗
		@back_window = Window_Base.new(160, 0, 480, 580)
		draw_back_window
		
	end
	#-------------------------------------------------------------------------
		#    根据不同情况，绘制不同的帮助信息
	#--------------------------------------------------------------------------
	def draw_back_window
		
		@back_window.contents.clear
		
		color = getColor("white")
		
		# 否则继续执行
		case @command_window.index
		when 0
			@back_window.contents.font.size = 26
			@back_window.contents.font.bold = true
			text = "总体说明:"
			@back_window.draw_a_line(color, 0, 0, 480, WLH, text, 0)
			text = "========================================="
			@back_window.contents.font.size = 22
			@back_window.draw_a_line(color, 0, WLH, 480, WLH, text, 0)
			
			@back_window.contents.font.bold = false
			@back_window.contents.font.size = 18
			@back_window.contents.font.name = "楷体"
			text = "游戏中你将扮演一名勇士来到“冒险塔”，"
			@back_window.draw_a_line(color, 0, WLH*2, 480, WLH, text, 0)
			text = "探求塔中奥秘。游戏规则与“魔塔”类似，"
			@back_window.draw_a_line(color, 0, WLH*3, 480, WLH, text, 0)
			text = "当你靠近怪物后，按确定键与之战斗。如果"
			@back_window.draw_a_line(color, 0, WLH*4, 480, WLH, text, 0)
			text = "你的生命值小于0，那么被判为死亡，死亡"
			@back_window.draw_a_line(color, 0, WLH*5, 480, WLH, text, 0)
			text = "后能在第一层复活每次死亡都会损失10%的"
			@back_window.draw_a_line(color, 0, WLH*6, 480, WLH, text, 0)
			text = "金钱。冒险吧!记得多与塔中的其他人讲话，"
			@back_window.draw_a_line(color, 0, WLH*7, 480, WLH, text, 0)
			text = "或许会有很大收获。"
			@back_window.draw_a_line(color, 0, WLH*8, 480, WLH, text, 0)
			
		when 1  
			@back_window.contents.font.size = 26
			@back_window.contents.font.bold = true
			text = "按键说明:"
			@back_window.draw_a_line(color, 0, 0, 480, WLH, text, 0)
			text = "========================================="
			@back_window.contents.font.size = 22
			@back_window.draw_a_line(color, 0, WLH, 480, WLH, text, 0)
			
			@back_window.contents.font.bold = false
			@back_window.contents.font.size = 18
			@back_window.contents.font.name = "楷体"
			text = "▼按键盘上的方向键进行移动，同时按下"
			@back_window.draw_a_line(color, 0, WLH*2, 480, WLH, text, 0)
			text = "shift键可以加速。"
			@back_window.draw_a_line(color, 0, WLH*3, 480, WLH, text, 0)
			text = "▼确定键为空格，或者回车"
			@back_window.draw_a_line(color, 0, WLH*4, 480, WLH, text, 0)
			text = "▼在地图上按esc按键调出系统菜单。"
			@back_window.draw_a_line(color, 0, WLH*5, 480, WLH, text, 0)
			text = "▼在地图上按Q/W按键可以直接"
			@back_window.draw_a_line(color, 0, WLH*6, 480, WLH, text, 0)
			text = "上楼/下楼。"
			@back_window.draw_a_line(color, 0, WLH*7, 480, WLH, text, 0)
			
		when 2  
			@back_window.contents.font.size = 26
			@back_window.contents.font.bold = true
			text = "战斗说明:"
			@back_window.draw_a_line(color, 0, 0, 480, WLH, text, 0)
			text = "========================================="
			@back_window.contents.font.size = 22
			@back_window.draw_a_line(color, 0, WLH, 480, WLH, text, 0)
			
			@back_window.contents.font.bold = false
			@back_window.contents.font.size = 18
			@back_window.contents.font.name = "楷体"
			text = "战斗开始后每秒记为一个【回合】，根据攻速调整行动"
			@back_window.draw_a_line(color, 0, WLH*2, 480, WLH, text, 0)
			text = "回合顺序。每次攻击可以被躲避或造成伤害，当有一方"
			@back_window.draw_a_line(color, 0, WLH*3, 480, WLH, text, 0)
			text = "体力值小于0时战斗结束。"
			@back_window.draw_a_line(color, 0, WLH*4, 480, WLH, text, 0)
			text = "伤害由攻击、物理伤害、物伤威力、防御相互作用决定。"
			@back_window.draw_a_line(color, 0, WLH*5, 480, WLH, text, 0)
			text = "闪避由敏捷、防御、命中、闪避相互总用决定。"
			@back_window.draw_a_line(color, 0, WLH*6, 480, WLH, text, 0)
			text = "暴击概率由力量、暴击技巧、命中、防御决定。"
			@back_window.draw_a_line(color, 0, WLH*7, 480, WLH, text, 0)
			text = "暴击威力，其值越大时，提升越困难。"
			@back_window.draw_a_line(color, 0, WLH*8, 480, WLH, text, 0)
			text = "其他更多信息，请在“加点”的说明中查看。"
			@back_window.draw_a_line(color, 0, WLH*9, 480, WLH, text, 0)
		when 3 
			@back_window.contents.font.size = 26
			@back_window.contents.font.bold = true
			text = "套装合成:"
			@back_window.draw_a_line(color, 0, 0, 480, WLH, text, 0)
			@back_window.contents.font.size = 20
			text = "========================================="
			@back_window.draw_a_line(color, 0, WLH, 480, WLH, text, 0)
			@back_window.contents.font.size = 18
			@back_window.contents.font.bold = false
			@back_window.contents.font.name = "黑体"
			color = getColor("light yellow")
			text = "◆ 黄色套装："
			@back_window.draw_a_line(color, 0, WLH*2, 480, WLH, text, 0)
			
			@back_window.contents.font.name = "楷体"
			text = "嗜血套装"
			@back_window.contents.font.bold = true
			@back_window.draw_a_line(color, 0, WLH*3, 480, WLH, text, 0)
			text = "（+黄色合成石能够合成一个部件）="
			@back_window.contents.font.bold = false
			@back_window.draw_a_line(color, 80, WLH*3, 480, WLH, text, 0)
			text = "嗜血面具+嗜血指环+嗜血胸坠+嗜血履"
			@back_window.draw_a_line(color, 0, WLH*4, 480, WLH, text, 0)
			text = "极速套装"
			@back_window.contents.font.bold = true
			@back_window.draw_a_line(color, 0, WLH*5, 480, WLH, text, 0)
			text = "（+黄色合成石能够合成一个部件）="
			@back_window.contents.font.bold = false
			@back_window.draw_a_line(color, 80, WLH*5, 480, WLH, text, 0)
			text = "急速战衣+急速指环+急速胸坠+急速履"
			@back_window.draw_a_line(color, 0, WLH*6, 480, WLH, text, 0)
			
			color = getColor("light green")
			@back_window.contents.font.name = "黑体"
			text = "◆ 绿色套装："
			@back_window.draw_a_line(color, 0, WLH*7, 480, WLH, text, 0)
			
			@back_window.contents.font.name = "楷体"
			@back_window.contents.font.bold = true
			text = "青龙套装"
			@back_window.draw_a_line(color, 0, WLH*8, 480, WLH, text, 0)
			@back_window.contents.font.bold = false
			text = "（+绿色合成石能够合成一个部件）="
			@back_window.draw_a_line(color, 80, WLH*8, 480, WLH, text, 0)
			text = "青龙刀+斩月刀+青龙盔+青龙盾+青龙铠+青龙靴"
			@back_window.draw_a_line(color, 0, WLH*9, 480, WLH, text, 0)
			text = "白虎套装"
			@back_window.contents.font.bold = true
			@back_window.draw_a_line(color, 0, WLH*10, 480, WLH, text, 0)
			text = "（+绿色合成石能够合成一个部件）="
			@back_window.contents.font.bold = false
			@back_window.draw_a_line(color, 80, WLH*10, 480, WLH, text, 0)
			text = "白虎刃+白虎盔+白虎铠+白虎盾+白虎掌+白虎靴"
			@back_window.draw_a_line(color, 0, WLH*11, 480, WLH, text, 0)
			
			color = getColor("light blue")
			@back_window.contents.font.name = "黑体"
			text = "◆ 蓝色套装："
			@back_window.draw_a_line(color, 0, WLH*12, 480, WLH, text, 0)
			
			@back_window.contents.font.name = "楷体"
			text = "神力套装"
			@back_window.contents.font.bold = true
			@back_window.draw_a_line(color, 0, WLH*13, 480, WLH, text, 0)
			text = "（+蓝色合成石能够合成一个部件）="
			@back_window.contents.font.bold = false
			@back_window.draw_a_line(color, 80, WLH*13, 480, WLH, text, 0)
			text = "青龙套装+白虎套装+朱雀羽+玄武骨+战魔项圈+黯然指环"
			@back_window.draw_a_line(color, 0, WLH*14, 480, WLH, text, 0)
		end    
	end
	#--------------------------------------------------------------------------
		# ● 结束处理
	#--------------------------------------------------------------------------
	def terminate
		super
		dispose_menu_background
		@command_window.dispose
		@back_window.dispose
	end
	#--------------------------------------------------------------------------
		# ● 更新画面
	#--------------------------------------------------------------------------
	def update
		super
		update_menu_background
		@command_window.update
		update_command_selection
	end
	#--------------------------------------------------------------------------
		# ● 生成指令窗口
	#--------------------------------------------------------------------------
	def create_command_window
		strings = [
			s1 = "总体说明",       
			s2 = "按键说明",                    
			s3 = "战斗说明",
			s4 = "套装合成"
		]	
		@command_window = Window_Command.new(160, strings)
		@command_window.index = @menu_index
	end
	#--------------------------------------------------------------------------
		# ● 更新指令选择
	#--------------------------------------------------------------------------
	def update_command_selection
		# 如果取消
		if Input.trigger?(Input::B)
			Sound.play_cancel
			$scene = Scene_Menu2.new(4)    
		# 如果上
		elsif Input.trigger?(Input::UP)
			draw_back_window
		# 如果下
		elsif Input.trigger?(Input::DOWN)
			draw_back_window       
		end
	end
end
