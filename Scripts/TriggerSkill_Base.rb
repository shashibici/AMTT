{
=begin
	按回合进行游戏。每个角色的回合行动顺序由角色的敏捷属性决定的。
	每个回合内只有该角色能够行动。回合分为若干个阶段：
	--	回合开始阶段	MGT.Phase_Round_Start
	--	回合准备阶段	MGT.Event_Round_Prepare
	--	主动技能选择阶段（暂不实现）
	--	目标选择阶段（暂不实现）
	--	行动准备阶段	MGT.Phase_Round_Action_Pre
	--	行动执行阶段	MGT.Phase_Round_Action_Exc
	--	行动结算阶段	MGT.Phase_Round_Action_Fin
	--	行动结束阶段	MGT.Phase_Round_Action_End
	--	回合结束阶段	MGT.Phase_Round_Finish
	----------------------------------------------------------------------
	
	1）	回合开始阶段：
		这个阶段，是最先被触发的阶段。在这个阶段里面一般不会进行任何的动作，
	唯一要做的就是判断该角色是否满足条件进入它的回合。如果条件不满足，则
	该角色的回合直接跳过。（类似触发技能：【封印】。当对方一名角色进入回合
	开始阶段时，有50%的几率跳过其回合）
	
	2）	回合准备阶段：
		这个阶段里，角色一般会进行属性能力的提升或者减少。（类似触发技能：
	【狂暴】。准备阶段里，你可提升自己攻击力为200%）
		
	3）	主动技能选择阶段：（暂不实现）
		在进行技能选择的时候，会触发这个条件。（类似触发技能：【沉默】。
	你可指定一名地方角色，该角色下回合不能使用全体攻击技能）。
	简单的实现机制是：A角色对B角色发动【沉默】技能，则B角色获得一个
	标记。在主动技能选择阶段，如果有角色（这里是A角色）拥有技能【沉默】，
	则会对当前将要发动技能的角色进行标记检查。此时如果恰好是B角色要选择
	发动主动技能，则会因为检查到B角色包含标记，于是禁止B角色选择技能。
	注：如果是普通攻击，则跳过此阶段。
	
	4）	目标选择阶段：（暂不实现）
		这个阶段是攻击目标的选择。（类似触发技能：【逃避】。如果对方的敏捷
	比你高，则你不能成为对方攻击的目标）。目标选择阶段不仅仅是在发动技能的
	时候有效，在普通攻击时也是有效的。
	
	5）	行动准备阶段：
		选择目标之后，在执行参数计算之前会触发这个条件。
	
	6）	行动执行阶段：
		参数计算完毕之后，执行最终扣血结算，状态改变，标记设置之前触发
	这个条件。
		
	7）	行动结算阶段：
		造成扣血，状态改变，标记设置后，会触发这个条件。
	
	8）	行动结束阶段：
		在一个角色的以上行动阶段都完成之后会被触发。这个阶段的任务就是决定
	后面是否还需要有角色需要行动——也就是是否有其他角色紧接着进行一个新的
	行动阶段。（类似触发技：【反击】。当你受到一次攻击后，你可立即执行一次
	行动）
		
	9）	回合结束阶段：
		在一个角色的回合即将结束时会被触发。这个阶段的主要任务就是进行扫尾
	工作，并且决定下一个角色的回合。（类似触发技：【不死】。回合结束阶段，
	你可以增加10%的HP，若如此做，其他己方角色各减少2%HP）
	----------------------------------------------------------------------
	
	总的来说，每个角色回合分为：
		1）回合开始；2）回合准备；3）行动阶段；4）回合结束
	一共四个阶段。其中行动阶段分为（1）行动准备；（2）行动执行；
	（3）行动结算；（4）行动结束 一共四个阶段。
	
=end
}
#=========================================================================
#	定义事件常量 MGT.Event_XX_XX
#=========================================================================
module	MGT
	#---------------------------------------------------------------------
	#	回合开始：进行是否能够进入回合的条件判断之前会是这个值
	#---------------------------------------------------------------------
	def Phase_Round_Start
		return 1
	end
	#---------------------------------------------------------------------
	#	回合准备：一旦角色进入了回合，阶段会变成这个值
	#---------------------------------------------------------------------
	def Event_Round_Prepare
		return 2
	end
	#---------------------------------------------------------------------
	#	行动准备：一旦目标选择完毕，阶段会边成这个值。此时还没有进行参数
	#			  计算，所以可以对各种参数进行修改。
	#---------------------------------------------------------------------
	def Phase_Round_Action_Pre
		return 3
	end
	#---------------------------------------------------------------------
	#	行动执行：在经过参数计算，准备执行扣血、状态变化、标记，阶段
	#			  会变成这个值。这个阶段可以在最终参数上进行修改。
	#---------------------------------------------------------------------
	def Phase_Round_Action_Exc
		return 4
	end
	#---------------------------------------------------------------------
	#	行动结算：在执行了扣血、状态变化、标记之后，阶段会变成这个值。
	#			  在判断死亡，结束等条件之前会可以对生命、状态、标记
	#			  进行调整。例如可以恢复生命等等。进行挽救。
	#---------------------------------------------------------------------
	def Phase_Round_Action_Fin
		return 5
	end
	#---------------------------------------------------------------------
	#	行动结束：在执行了胜负判断之后，这一轮行动执行就算是结束了。
	#			  这个阶段将进行所有行动后的行为处理。例如吸血，反弹伤害
	#			  等等。
	#---------------------------------------------------------------------
	def Phase_Round_Action_End
		return 6
	end
	#---------------------------------------------------------------------
	#	回合结束：执行阶段已经完全结束，可以开始另一个执行阶段了。在这个阶段
	#			  如果满足条件。会触发一个或者多个额外的“执行阶段”。这些执行
	#			  阶段可以是“反击”行为。某些“反击”效果的技能会在这个时候被
	#			  触发。但是反击者并不是执行一个额外的“回合”，所以不存在无限
	#			  反击的现象。“反击”的要求是，不在自己的回合内被攻击。所以被
	#			  反击者，不能再一次进行反击。
	#---------------------------------------------------------------------
	def Phase_Round_Finish
		return 7
	end

end


#=========================================================================
#	技能的基类，所有玩家自定义技能都需要继承自这个技能基类
#=========================================================================
module RPG
	class Skill_Base < BaseItem
		attr_accessor	:scope
		attr_accessor	:occasion
	
		def initialize(id)
			@id = id
			@scope = {}
			@occasion = 0
		end
	end
end
#=========================================================================
#	技能注册表，所有玩家定义的技能都需要在这里注册才能生效,
#	前面的数字是这个技能的id号，所有的角色如果需要引用这个技能，则需要
#	引用这个技能的id号就行了。
#=========================================================================
$MGT_Game_Skills = {
	#---------------------------------------------------------------------
	#	这是1号技能，后面玩家可以自定义新的技能。
	#---------------------------------------------------------------------
	1	=>	{EG_Absorb_Hp_Atk_Mp.new(1)},
}

