#==============================================================================
# ■ 系统配置
#------------------------------------------------------------------------------
# 　配置系统的各种表现。
#   这里的设置一般是适合大多数作者的，只需修改少数即可。
#==============================================================================

module GAME_CONF
  #--------------------------------------------------------------------------
  # 技能发动的时机常数
  #--------------------------------------------------------------------------
  TIMES = [
	# 判断死亡之后立即执行
	$TIME_PRE_ATTACK						= 	0,	# excuteBattle 一开始执行
	# preattack 用来计算命中的，影响命中的技能
	# 都应该在这个时候执行
	$TIME_PRE_PRE_ATTACK					=	1,	# preattack 执行之前
	# 计算命中之后需要修改命中的技能
	# 应该在这个时候执行
	$TIME_POST_PRE_ATTACK					=	2,	# preattack 执行之后
	# doattack 用来计算产生的伤害倍数，
	# 一切影响伤害倍数声称的技能在这时候调用
	$TIME_PRE_DO_ATTACK						=	3,  # doattack 执行之前
	# 产生伤害倍数之后，一切需要利用“产生伤害”
	# 的技能都在这时候调用，获得所产生的伤害
	$TIME_POST_DO_ATTACK					=	4,	# doattack 执行之后
	# predamage 用来计算出“有效伤害”并返回
	# 有效伤害就是考虑护甲。护甲相关技能在这里添加
	$TIME_PRE_PRE_DAMGE						=	5,	# predamage 执行之前
	# 最后伤害已经计算出来。
	# 需要修改最后伤害、利用最后伤害的技能需要在这里获得
	# 最后伤害。纯粹伤害在这里添加。吸血、反弹在这里计算
	$TIME_POST_PRE_DAMAGE					=	6,	# predamage 执行之后
	# dodamage 直接
	$TIME_PRE_DO_DAMAGE						=	7,	# dodamage 执行之前
	$TIME_POST_DO_DAMAGE					=	8, 	# dodamage 执行之前
	$TIME_PRE_POST_DAMAGE					=	9,	# postdamage 执行之前
	$TIME_POST_POST_DAMAGE					=	10	# postdamage 执行之后
  ]
  #--------------------------------------------------------------------------
  # 合成套装的物品的id们 通常就是合成石
  #--------------------------------------------------------------------------
  ANCILLARY = [66, 67, 68, 69]
  
  #--------------------------------------------------------------------------
  # 设置是否能够无限复活
  #   true ：能够无限复活       false：不能无限复活
  #--------------------------------------------------------------------------
  ATHANASY      =   true
  
  #--------------------------------------------------------------------------
  # 设置每次逃跑需要消耗的魔法值
  # 设置每次探测需要消耗的魔法值
  #--------------------------------------------------------------------------
  MP_ESCAPE      =   0  
  MP_DETECT      =   0
  
  #-------------------------------------------------------------------------
  # 系统参数请勿修改
  #
  #   这是三种战斗窗口的z 值
  #-------------------------------------------------------------------------
  BATTLE_WINDOW1  =  1000
  BATTLE_WINDOW2  =  1001
  BATTLE_WINDOW3  =  1002
  
  #--------------------------------------------------------------------------
  # HERO_BASE_HP                     : 英雄初始hp
  # HERO_BASE_MP                     : 英雄初始mp
  #--------------------------------------------------------------------------
  HERO_BASE_HP = 500
  HERO_BASE_MP = 500
  
  #--------------------------------------------------------------------------
  # BONUS_STRENGTH_ATTACK                : 力量英雄每点力量增加的攻击力
  # BONUS_CELERITY_ATTACK                : 敏捷英雄每点敏捷增加的攻击力
  # BONUS_WISDOM_ATTACK                  : 智力英雄每点智力增加的攻击力
  # BONUS_CELERITY_DEF                   : 每点敏捷增加的防御力
  # BONUS_STRENGTH_HPCOVER               : 每点力量增加的生命恢复量
  #
  #  ……                                     ……
  #--------------------------------------------------------------------------
  BONUS_STRENGTH_ATTACK = 0.7
  BONUS_CELERITY_ATTACK = 0.7
  BONUS_WISDOM_ATTACK = 0.7
  
  # 每点敏捷增加的防御力
  BONUS_CELERITY_DEF = 0.2
  # 每点敏捷增加的攻击速度
  BONUS_CELERITY_ATKSPEED = 0.2
  # 每点敏捷增加的命中技巧
  BONUS_CELERITY_HIT = 0.3
  # 每点敏捷增加的闪避技巧
  BONUS_CELERITY_EVA = 0.22
  
  
  # 每点力量增加的生命恢复量
  BONUS_STRENGTH_HPCOVER = 0.36
  # 每点力量增加的生命量
  BONUS_STRENGTH_MAXHP = 14.0
  # 每点力量增加的物理破坏
  BONUS_STRENGTH_DESTROY = 0.38
  # 每点力量增加暴击技巧
  BONUS_STRENGTH_BOM = 0.15
  
  # 每点智力增加的魔法恢复量
  BONUS_WISDOM_MPCOVER = 0.18  
  # 每点智力增加的魔法量
  BONUS_WISDOM_MAXMP = 14
  # 每点智力增加的魔法破坏
  BONUS_WISDOM_MDESTROY = 0.38
  

  
  #---------------------------------------------------------------------------
  #  这里设置的是游戏平衡性、游戏速度的一些参数
  #
  #   其中，后面三对参数，base就是基数，max就是rand的范围，作为分母
  #   例如 a = CONST_BASE_EVA +(@eva+@xeva)*(@evarate+@xevarate)
  #        b = rand(CONST_MAX_EVA)
  #        if a >= b ……
  #---------------------------------------------------------------------------
  # 基础物理破坏值
  CONST_BASE_DESTROY         = 0#20
  # 基础魔法破坏值
  CONST_BASE_MDESTROY        = 10
  
  # 基础攻击速度
  # 初始攻速 = 每秒 CONST_BASE_ATKSPEED * 60/CONST_MAX_ATKSPEED 次攻击
  # --- 已经重新定义 ---
  CONST_BASE_ATKSPEED        = 0#10    # 1次
  
  # 系统攻速基数
  # 就是每一点攻速每秒增加 60/CONST_MAX_ATKSPEED  次攻击
  # --- 没有使用 ---
  CONST_MAX_ATKSPEED         = 12000   # 0.05次
  
  # 基础闪避率
  CONST_BASE_EVA             = 70     # 7%
  CONST_MAX_EVA              = 1000   # 每一点闪避技巧增加0.1个百分点闪避
  
  # 基础暴击率 1%
  CONST_BASE_BOM             = 100     # 1%
  CONST_MAX_BOM              = 4000   # 每一点增加0.025个百分点暴击
  
  # 基础命中率
  CONST_BASE_HIT             = 1600    # 80%
  CONST_MAX_HIT              = 2000   
  
  # 基础伤害的比例
  CONST_BASE_DAMAGE_RATE     = 1.0
  
  # 没点技能点添加个属性的值
  HP_ASCEND 				=	70
  MP_ASCEND					=	70
  HPCOVER_ASCEND			=	2
  MPCOVER_ASCEND			=	2
  ATK_ASCEND				=	3
  DEF_ASCEND				=	1.5
  STRENGTH_ASCEND			=	1
  WISDOM_ASCEND				=	1
  CELERITY_ASCEND			=	1
  DESTROY_ASCEND			=	1.1
  MDESTROY_ASCEND			=	1.1
  ATKSPEED_ASCEND			=	0.75
  HIT_ASCEND				=	1.2
  EVA_ASCEND				=	0.8
  
  
  #-------------------------------------------------------------------------
  #   这是记录各个地图和魔塔号、层数号相对应的数组  
  #
  #    Tower_Layer[i]               表示第i 座塔
  #    Tower_Layer[i][j]            表示第i 做塔第j层的map_id
  #
  #    另外，变量41记录当前塔号，   变量42记录当前层号
  #
  #    if i >= Tower_Layer.size     那么就是没有定义的塔
  #    if j >= Tower_Layer[i].size  那么就是没有定义的层
  #
  #    if Tower_Layer.size == 0     那么没有定义塔
  #    if Tower_Layer[i].size == 0  那么该塔没有定义层
  #
  #-----------------------------------------------------------------------
  
  Tower_Layer = [
  #----------------------------------------------------------------------
  # 第一个塔
  #----------------------------------------------------------------------
  [ 5,7,4,8,9,10,11,12,13,14
  
  ],
  
  #----------------------------------------------------------------------
  # 第二个塔
  #-----------------------------------------------------------------------
  [
  
  ],
  
  #----------------------------------------------------------------------
  # 第三个塔
  #-----------------------------------------------------------------------
  [
  
  ]  
  
  
  ]
  #-------------------------------------------------------------------------
  #   这是记录各个地图和魔塔号、层数号相对应的数组  
  #
  #    Tower_Upstairs[i]               表示第i 座塔
  #    Tower_Upstairs[i][j]            表示第i 做塔第j层的上楼事件号
  #
  #    变量110记录当前层上楼事件号
  #
  #-----------------------------------------------------------------------
  
  Tower_Upstairs = [
  #----------------------------------------------------------------------
  # 第一个塔
  #----------------------------------------------------------------------
  [ 29, 2,  19,  2,  2,  18, 2, 2, 2, 2
  
  ],
  
  #----------------------------------------------------------------------
  # 第二个塔
  #-----------------------------------------------------------------------
  [
  
  ],
  
  #----------------------------------------------------------------------
  # 第三个塔
  #-----------------------------------------------------------------------
  [
  
  ]  
  
  
  ]
  
  #-------------------------------------------------------------------------
  #   这是记录各个地图和魔塔号、层数号相对应的数组  
  #
  #    Tower_Downstairs[i]               表示第i 座塔
  #    Tower_Downstairs[i][j]            表示第i 做塔第j层的下楼事件号
  #
  #    变量111记录当前层下楼事件号
  #
  #-----------------------------------------------------------------------
  
  Tower_Downstairs = [
  #----------------------------------------------------------------------
  # 第一个塔
  #----------------------------------------------------------------------
  [ 29,  1,   1,   1,   1,  1, 1, 1, 1, 1
  
  ],
  
  #----------------------------------------------------------------------
  # 第二个塔
  #-----------------------------------------------------------------------
  [
  
  ],
  
  #----------------------------------------------------------------------
  # 第三个塔
  #-----------------------------------------------------------------------
  [
  
  ]  
  
  
  ]
  
end