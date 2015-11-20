=begin
	每个怪物最多可以携带16件装备。 4件武器， 6件防具， 6件宝物。
	依据档次不同，每个怪物能够携带的武器不同。能够携带的宝物数量也不同。
	
	怪物的属性分为几个级别：
	1） 自身属性(self)这是在定义怪物的时候直接指定的值
	2） 基本属性(basic)这是在计算了力量、敏捷、智力之后的属性值；有些装备也会在self阶段增加属性，于是在basic上体现出来
	3） 真实属性(real)这是计算了大多数装备之后的属性值，装备影响力量、敏捷、智力，这些影响在这个阶段会加到攻击等属性上
	4） 最终属性(final)这是在战斗的时候最终计算的属性值；由真实属性加上一个额外的修正值(extra)计算得来，修正值代表了属性暂时变化的大小
		如果暂时性减少，则修正值是负的，否则是正的
	
	


=end
#################################
# 	This part defines the basic attributes
#################################
class Game_Battler

	attr_accessor :
	#-------------------------------------------------
	#	Give the id in $data_enemies
	#	Give the level this battler will be at.
	#	Give the flag indicating wheather it's an enemy.
	#-------------------------------------------------
	def initialize(battler_id, level)
		@id = battler_id
		@level = level
	
	end
	
	def icon_file_name
		return getStr(@id, "icon")
	end
	def protrait_file_name
		return getStr(@id, "name")
	end
	
	#-----------------------
	#	Self Attributes:
	#	strength affects hp, rehp and destroy
	#	celerity affects defence, speed and atk
	#	wisdom affects mp, remp and mdestroy
	#	The eva and hit are almost  constants.
	#
	#
	#
	#
	#
	#-----------------------
	##################
	def self_strength
		return @strength
	end
	def self_hp
		return @hp
	end
	def self_rehp
		return @rehp
	end
	def self_destroy
		return @destroy
	end
	#####################
	def self_celerity
		return @celerity
	end
	def self_atk
		return @atk
	end
	def self_defence
		return @defence
	end
	def self_speed
		return @speed
	end
	######################
	def self_wisdom
		return @wisdom
	end
	def self_mp
		return @mp
	end
	def self_remp
		return @remp
	end
	def self_mdestroy
		return @mdestroy
	end
	#####################
	def self_hit
		return @eva
	end
	def self_eva
		return @eva
	end
	#---------------------------------------------
	#	Base Attributes
	#	The Base Attributes are counted with out any equipment or debuf
	#	some special skills may affect this velue.
	#
	#---------------------------------------------
	def base_strength
		return self_strength + skill_bonus_strength_self + equip_bonus_strength_self
	end
	def base_hp
		return self_hp + self_strength*STR_HP + skill_bonus_hp_self + equip_bonus_hp_self
	end
	def base_rehp
		return self_rehp + self_strength*STR_REHP + skill_bonus_rehp_self + equip_bonus_rehp_self
	end
	def base_destroy
		return self_destroy + self_strength*STR_DESTR + skill_bonus_destroy_self + equip_bonus_destroy_self
	end
	
	######################
	def base_celerity
		return self_celerity + skill_bonus_celerity_self + equip_bonus_celerity_self
	end
	def base_atk
		return self_atk + self_celerity*CEL_ATK + skill_bonus_atk_self + equip_bonus_atk_self
	end
	def base_defence
		return self_defence + self_celerity*CEL_DEF + skill_bonus_defence_self + equip_bonus_defence_self
	end
	def base_speed
		return self_speed + self_celerity*CEL_SPEED + skill_bonus_defence_self + equip_bonus_speed_self
	end
	
	########################
	def base_wisdom
		return self_wisdom + skill_bonus_wisdom_self + equip_bonus_wisdom_self
	end
	def base_mp
		return self_mp + self_wisdom*WIS_MP + skill_bonus_mp_self + equip_bonus_mp_self
	end
	def base_remp
		return self_remp + self_wisdom*WIS_MP + skill_bonus_remp_self + equip_bonus_remp_self
	end
	def base_mdestroy
		return self_mdestroy + self_wisdom*WIS_MDES + skill_bonus_mdestroy_self + equip_bonus_mdestory_self
	end
	############################
	def base_hit
		return self_hit + skill_bonus_hit_self + equip_bonus_hit_self
	end
	def base_eva
		return self_eva + skill_bonus_eva_self + equip_bonus_eva_self
	end
	#----------------------------------------------
	#  	Real Attributes:
	#	These attributes are affected by equipments, debuffs
	#-----------------------------------------------
	def real_strength
		return base_strength + skill_bonus_strength_base + equip_bonus_strength_base
		
	end
	def real_hp
		tmp = base_hp + skill_bonus_hp_base + equip_bonus_hp_base
		return tmp + (skill_bonus_strength_base + equip_bonus_strength_base) * STR_HP
	end
	def real_rehp
		tmp = base_rehp + skill_bonus_rehp_base + equip_bonus_rehp_base
		return tmp + (skill_bonus_strength_base + equip_bonus_strength_base) * STR_REHP
	end
	def real_destroy
		tmp = base_destroy + skill_bonus_destroy_base + equip_bonus_destroy_base
		return tmp + (skill_bonus_strength_base + equip_bonus_strength_base) * STR_DESTR
	end
	
	#######################
	def real_celerity
		return base_celerity + skill_bonus_celerity_base + equip_bonus_celeiry_base
	end
	def real_atk
		tmp = base_atk + skill_bonus_atk_base + equip_bonus_atk_base
		return tmp + (skill_bonus_celerity_base + equip_bonus_celerity_base) * CEL_ATK
	end
	def real_defence
		tmp = base_defence + skill_bonus_defence_base + equip_bonus_defence_base
		return tmp + (skill_bonus_celerity_base + equip_bonus_celerity_base) * CEL_DEF
	end
	def real_speed
		tmp = base_speed + skill_bonus_speed_base + equip_bonus_speed_base
		return tmp + (skill_bonus_celerity_base + equip_bonus_celerity_base) * CEL_SPEED
	end
	
	######################
	def real_wisdom
		return base_wisdom + skill_bonus_wisdom_base + equip_bonus_wisdom_base
	end
	def real_mp
		tmp = base_mp + skill_bonus_mp_base + equip_bonus_mp_base
		return tmp + (skill_bonus_wisdom_base + equip_bonus_wisdom_base) * WIS_MP
	end
	def real_remp
		tmp = base_remp + skill_bonus_remp_base + equip_bonus_remp_base
		return tmp + (skill_bonus_wisdom_base + equip_bonus_wisdom_base) * WIS_REMP
	end
	def real_mdestroy
		tmp = base_mdestroy + skill_bonus_mdestroy_base + equip_bonus_mdestroy_base
		return tmp + (skill_bonus_wisdom_base + equip_bonus_wisdom_base) * WIS_MDES
	end
	########################
	def real_hit
		return base_hit + skill_bonus_hit_base + equip_bonus_hit_base
	end
	def real_eva
		return base_eva + skill_bonus_eva_base + equip_bonus_eva_base
	end
	#-----------------------------------------------------
	# 	Final Attributes:
	#	The final attributes will be employed in a battle.
	#	The extra_XX can be eithter positive or negitive, so that we can chage
	#   the final parameters dynamically without changing the real_xx parameters.
	#
	#	The extra_xx parameters usually works within a battle. On usual situations,
	#   These parameters do not take any effects. So they are hardly seen by the player.
	#-------------------------------------------------
	#########################################
	def final_strength
		return real_strength + extra_strength
	end
	def final_hp
		return real_hp + extra_hp
	end
	def final_rehp
		return real_rehp + extra_rehp
	end
	def final_destroy
		return real_destroy + extra_destroy
	end
	#################################################
	def final_celerity
		return real_celerity + extra_celerity
	end
	def final_atk
		return real_atk + extra_atk
	end
	def final_defence
		return real_defence + extra_defence
	end
	def final_speed
		return real_speed + extra_speed
	end
	#################################################
	def final_wisdom
		return real_wisdom + extra_wisdom
	end
	def final_mp
		return real_mp + extra_mp
	end
	def final_remp
		return real_remp + extra_remp
	end
	def final_mdestroy
		return real_mdestroy + extra_mdestroy
	end
	################################################
	def final_hit
		return real_hit + extra_hit
	end
	def final_eva
		return real_eva + extra_eva
	end
	
	#-------------------------------------------------------------
	#	Get current hp, mp and extra_xx.
	#   The extra_xx should be set in a battle and be cleared after a battle.
	#   So we need a flag to indecate wheather we are in a battle.
	#	Define the lossHp, lossMp
	#-------------------------------------------------------------
	def extra_strength
		return 0 if @isBattle == 0
		return @xstrength
	end
	def extra_hp
		return 0 if @isBattle == 0
		return @xhp
	end
	def extra_rehp
		return 0 if @isBattle == 0
		return @xrehp
	end
	def extra_destroy
		return 0 if @isBattle == 0
		return @xdestroy
	end
	#################################
	def extra_celerity
		return 0 if @isBattle == 0
		return @xcelerity
	end
	def extra_atk
		return 0 if @isBattle == 0
		return @xatk
	end
	def extra_defence
		return 0 if @isBattle == 0
		return @xdefence
	end
	def extra_speed
		return 0 if @isBattle == 0
		return @xspeed
	end
	###################################
	def extra_wisdom
		return 0 if @isBattle == 0
		return @xwisdom
	end
	def extra_mp
		return 0 if @isBattle == 0
		return @xmp
	end
	def extra_remp
		return 0 if @isBattle == 0
		return @xremp
	end
	def extra_mdestroy
		return 0 if @isBattle == 0
		return @xmdestroy
	end
	######################################
	def extra_hit
		return 0 if @isBattle == 0
		return @xhit
	end
	def extra_eva
		return 0 if @isBattle == 0
		return @xeva
	end
	#######################################
	def hp
		return final_hp - @lossHp
	end
	def hp(nhp)
		@lossHp = final_hp - nhp
		@lossHp = 0 if @lossHp < 0
	end
	def mp
		return final_hp - @lossMp
	end
	def mp(nmp)
		@lossMp = final_mp - nmp
		@lossMp = 0 if @lossMp < 0
	end
	def lossHp
		return @lossHp
	end
	def lossMp
		return @lossMp
	end
	
	
end

##################################
#	This part defines the equipments
##################################
class Game_Battler
	attr_accessor :  uniq_id
	#------------------------------------------------------
	#	Please Note that all battler comes from the enemy. 
	#   The actor class is no longer exists.
	#   In order to create a battler, this function needs a battler_id indecating
	#	an object in $data_enemies array.
	#
	#   There are two important data structures in the game:
	#	1) $data_enemies.   2) $game_battlers. 
	#   The first one stores the data in the database. The second one stores the battlers
	#   in the game. It just like a object pool. A battler objet will never destroied untill
	#   we don't need it any more, say, this battler is consumed and will no longer appear.
	#   
	#   So there is an auto-increment ID identifying each unique battler. The $game_battlers
	#   is a hash map. The unique ID is the key for each battler, each a new battler object is created
	#   the ID increases. When we create a new battler object, we must do "$UNIQ_ID += 1".
	#	$UNIQ_ID is initialized as 0.
	#
	#	At other parts of the game, all battlers should be referenced by their "uniq_id".
	#
	#------------------------------------------------------
	def setup(battler_id, level)
		@uniq_id = @UNIQ_ID
		
		monstor = $data_enemies[battler_id]
		@level = level
		
		@skills = []
		
		
		@name               = monstor.name
		@character_name     = monstor.battler_name
		# get self attributes from data base.
		@strength           = ReadBattler(battler_id, "strenght")
		@hp                 = ReadBattler(battler_id, "maxhp")
		@rehp				= ReadBattler(battler_id, "rehp")
		@destroy			= ReadBattler(battler_id, "destroy")
		@celerity			= ReadBattler(battler_id, "celerity")
		@atk				= ReadBattler(battler_id, "atk")
		@defence			= ReadBattler(battler_id, "defence")
		@speed				= ReadBattler(battler_id, "speed")
		@wisdom				= ReadBattler(battler_id, "wisdom")
		@mp					= ReadBattler(battler_id, "mp")
		@remp				= ReadBattler(battler_id, "remp")
		@mdestroy			= ReadBattler(battler_id, "mdestory")
		@hit				= ReadBattler(battler_id, "hit")
		@eva				= ReadBattler(battler_id, "eva")
		
		# Modified the self attributes according to the level.
		@weapon = []
		@armor = []
		@trea = []
		# suits的每一个元素是一个二元组[type, id] type=1，武器；type=2，防具
		@suits = []
		# There are 7 elements, [0] elements will be returned when an
		# unaccessable elements is being accessed.
		@waapon.push 0, 0, 0, 0, 0, 0,0
		@armor.push 0, 0, 0, 0, 0, 0,0
		@trea.push 0, 0, 0, 0, 0, 0,0
		
		# Weapons from 1~6
		@weapon[1]			= ReadBattler(battler_id, "w1")
		@weapon[2]			= ReadBattler(battler_id, "w2")
		@weapon[3]			= ReadBattler(battler_id, "w3")
		@weapon[4]			= ReadBattler(battler_id, "w4")	
		@weapon[5]			= ReadBattler(battler_id, "w5")
		@weapon[6]			= ReadBattler(battler_id, "w6")
		# 1-head, 2-neck, 3-armor, 4-clothe, 5-ring, 6-shoes
		@armor[1]			= ReadBattler(battler_id, "a1")
		@armor[2]			= ReadBattler(battler_id, "a2")
		@armor[3]			= ReadBattler(battler_id, "a3")
		@armor[4]			= ReadBattler(battler_id, "a4")
		@armor[5]			= ReadBattler(battler_id, "a5")
		@armor[6]			= ReadBattler(battler_id, "a6")
		# tresures from 1~6
		@trea[1]			= ReadBattler(battler_id, "t1")
		@trea[2]			= ReadBattler(battler_id, "t2")
		@trea[3]			= ReadBattler(battler_id, "t3")
		@trea[4]			= ReadBattler(battler_id, "t4")
		@trea[5]			= ReadBattler(battler_id, "t5")
		@trea[6]			= ReadBattler(battler_id, "t6")
		
		
		
	end
	#--------------------------------------------------------------------------
	#
	#--------------------------------------------------------------------------
	def weapons
		results = []
		for i in 1..@maxWeaponNo
			if 0 != @weapon[i]
				results.push($data_weapons[@weapon[i]])
			end
		end
		return results
	end
	#--------------------------------------------------------------------------
	#
	#--------------------------------------------------------------------------
	def armors
		results = []
		for i in 1..@maxArmorNo
			if 0 != @armor[i]
				results.push($data_armors[@armor[i]])
			end
		end
		return results
	end
	#--------------------------------------------------------------------------
	#
	#--------------------------------------------------------------------------
	def treas
		results = []
		for i in 1..@maxTreaNo
			if 0 != @trea[i]
				results.push($data_weapons[@trea[i]])
			end
		end
		return results
	end
	#--------------------------------------------------------------------------
	#	suits对用户是不可见的，它们相当于套装的额外添加技能。例如
	#	青龙套装，在收集齐之后，会有额外的套装奖励，这个“套装奖励”其实就是一件特殊的“武器”。
	#	它能够提供额外的属性加成，或者是效果。
	#	注意：套装一定是一件“武器”。
	#
	#	不要和融合后的套装混淆。如果用户收集了足够的套装部件，以及融合需要的材料，那么玩家
	#	就可以将多个部件融合成一个新的装备——可能是一件武器，或者防具或者宝物。新的装备已经
	#	包含了老部件的所有效果，同时还包含了“套装奖励”效果。所以对应的“套装”就可以从suits里删除了。
	#--------------------------------------------------------------------------
	def suits
		results = []
		for suit in @suits
			if suit[0] == 0
				results.push($data_weapons[suit[1]])
			else
				results.push($data_armors[suit[1]])
			end
		end
		return results
	end
	#--------------------------------------------------------------------------
	#
	#--------------------------------------------------------------------------
	def equips
		return weapons + armors + treas + suits
	end
	#--------------------------------------------------------------------------
	#	每次戴上或者取下一件装备后，都需要调用次函数一次。
	#--------------------------------------------------------------------------
	def onEquipChange
		# 判断套装条件
		# 调整套装信息
	end
	#--------------------------------------------------------------------------
	#	装备改变属性-self级别
	#--------------------------------------------------------------------------
	def equip_bonus_strength_self
		tmp = 0
		for e in equips
			tmp += e.str__s
		end
		for e in equips
			tmp += e.str__sr * self_strength
		end
		return tmp
	end
	def equip_bonus_hp_self
		tmp = 0
		for e in equips
			tmp += e.hp__s
		end
		for e in equips
			tmp += e.hp__sr * self_hp
		end
		return tmp
	end
	def equip_bonus_rehp_self
		tmp = 0
		for e in equips
			tmp += e.rehp__s
		end
		for e in equips
			tmp += e.rehp__sr * self_rehp
		end
		return tmp
	end
	def equip_bonus_destroy_self
		tmp = 0
		for e in equips
			tmp += e.des__s
		end
		for e in equips
			tmp += e.des__sr * self_destroy
		end
		return tmp
	end
	def equip_bonus_celerity_self
		tmp = 0
		for e in equips
			tmp += e.cel__s
		end
		for e in equips
			tmp += e.cle__sr * self_celerity
		end
		return tmp
	end
	def equip_bonus_atk_self
		tmp = 0
		for e in equips
			tmp += e.atk__s
		end
		for e in equips
			tmp += e.atk__sr * self_atk
		end
		return tmp
	end
	def equip_bonus_defence_self
		tmp = 0
		for e in equips
			tmp += e.def__s
		end
		for e in equips
			tmp += e.def__sr * self_defence
		end
		return tmp
	end
	def equip_bonus_speed_self
		tmp = 0
		for e in equips
			tmp += e.speed__s
		end
		for e in equips
			tmp += e.speed__sr * self_speed
		end
		return tmp
	end
	def equip_bonus_wisdom_self
		tmp = 0
		for e in equips
			tmp += e.wis__s
		end
		for e in equips
			tmp += e.wis__sr * self_wisdom
		end
		return tmp
	end
	def equip_bonus_mp_self
		tmp = 0
		for e in equips
			tmp += e.mp__s
		end
		for e in equips
			tmp += e.mp__sr * self_mp
		end
		return tmp
	end
	def equip_bonus_remp_self
		tmp = 0
		for e in equips
			tmp += e.remp__s
		end
		for e in equips
			tmp += e.remp__sr * self_remp
		end
		return tmp
	end
	def equip_bonus_mdestroy_self
		tmp = 0
		for e in equips
			tmp += e.mdes__s
		end
		for e in equips
			tmp += e.mdes__sr * self_mdestroy
		end
		return tmp
	end
	def equip_bonus_hit_self
		tmp = 0
		for e in equips
			tmp += e.hit__s
		end
		for e in equips
			tmp += e.hit__sr * self_hit
		end
		return tmp
	end
	def equip_bonus_eva_self
		tmp = 0
		for e in equips
			tmp += e.eva__s
		end
		for e in equips
			tmp += e.eva__sr * self_eva
		end
		return tmp
	end
	#--------------------------------------------------------------------------
	#	装备改变属性-base级别
	#--------------------------------------------------------------------------
	def equip_bonus_strength_base
		tmp = 0
		for e in equips
			tmp += e.str__b
		end
		for e in equips
			tmp += e.str__br * base_strength
		end
		return tmp
	end
	def equip_bonus_hp_base
		tmp = 0
		for e in equips
			tmp += e.hp__b
		end
		for e in equips
			tmp += e.hp__br * base_hp
		end
		return tmp
	end
	def equip_bonus_rehp_base
		tmp = 0
		for e in equips
			tmp += e.rehp__b
		end
		for e in equips
			tmp += e.rehp__br * base_rehp
		end
		return tmp
	end
	def equip_bonus_destroy_base
		tmp = 0
		for e in equips
			tmp += e.des__b
		end
		for e in equips
			tmp += e.des__br * base_destroy
		end
		return tmp
	end
	def equip_bonus_celerity_base
		tmp = 0
		for e in equips
			tmp += e.cel__b
		end
		for e in equips
			tmp += e.cel__br * base_celerity
		end
		return tmp
	end
	def equip_bonus_atk_base
		tmp = 0
		for e in equips
			tmp += e.atk__b
		end
		for e in equips
			tmp += e.atk__br * base_atk
		end
		return tmp
	end
	def equip_bonus_defence_base
		tmp = 0
		for e in equips
			tmp += e.def__b
		end
		for e in equips
			tmp += e.def__br * base_defence
		end
		return tmp
	end
	def equip_bonus_speed_base
		tmp = 0
		for e in equips
			tmp += e.speed__b
		end
		for e in equips
			tmp += e.speed__br * base_speed
		end
		return tmp
	end
	def equip_bonus_wisdom_base
		tmp = 0
		for e in equips
			tmp += e.wis__b
		end
		for e in equips
			tmp += e.wis__br * base_wisdom
		end
		return tmp
	end
	def equip_bonus_mp_base
		tmp = 0
		for e in equips
			tmp += e.mp__b
		end
		for e in equips
			tmp += e.mp__br * base_mp
		end
		return tmp
	end
	def equip_bonus_remp_base
		tmp = 0
		for e in equips
			tmp += e.remp__b
		end
		for e in equips
			tmp += e.remp__br * base_remp
		end
		return tmp
	end
	def equip_bonus_mdestroy_base
		tmp = 0
		for e in equips
			tmp += e.mdes__b
		end
		for e in equips
			tmp += e.mdes__br * base_mdestroy
		end
		return tmp
	end
	def equip_bonus_hit_base
		tmp = 0
		for e in equips
			tmp += e.hit__b
		end
		for e in equips
			tmp += e.hit__br * base_hit
		end
		return tmp
	end
	def equip_bonus_eva_base
		tmp = 0
		for e in equips
			tmp += e.eva__b
		end
		for e in equips
			tmp += e.eva__br * base_eva
		end
		return tmp
	end

end

##################################
#	This part defines the useful utilities
##################################
class Game_Battler
	#---------------------------------------------------------------
	#	This part give the parameters of the moster.
	#---------------------------------------------------------------
	def ReadBattler(b_id, session)
		battler = $BATTLER_DB[b_id]
		if battler == nil
			p "You have not defined something in $BATTLER_DB yet. battler_id is: "
			p b_id
			return 0
		end
		return 0 if battler[session] == nil
		return  battler[session]
	end
	#---------------------------------------------------------------
	#	This part gives the description of the moster
	#	or gives the file name of the moster.
	#---------------------------------------------------------------
	def getStr(b_id, session)
		battler = $BATTLER_NOTE[b_id]
		if battler == nil
			p "You have not defined something in $BATTLER_NOTE yet. battler_id is: "
			p b_id
			return ""
		end
		return "" if battler[session] == nil
		return battler[session]
	end
	
end


##################################
#	This part defines the actor and enemy's methods
##################################
class Actor < Game_Battler
	
	def isEnemy
		return false
	end
	
	def getAliveFriends
		result = []
		# $game_party.members里面存的是obj的指针不是id
		for f in $game_party.members
			result.push(f) unless f.isDead?
		end
		return result
	end
	
	def getAllFriends
		return $game_party.members
	end
	
	def getAliveOppent
		result = []
		# $game_troop 在即将进入battle_sence 的时候会进行初始化
		for o in $game_troop.members
			result.push(o) unless o.isDead?
		end
		return result
	end
	
	def getAllOppent
		return $game_troop.members
	end
	
end

class Enemy < Game_Battler
	
	def isEnemy
		return true
	end
	
	def getAliveFriends
		result = []
		# $game_party.members里面存的是obj的指针不是id
		for f in $game_troop.members
			result.push(f) unless f.isDead?
		end
		return result
	end
	
	def getAllFriends
		return $game_troop.members
	end
	
	def getAliveOppent
		result = []
		# $game_troop 在即将进入battle_sence 的时候会进行初始化
		for o in $game_party.members
			result.push(o) unless o.isDead?
		end
		return result
	end
	
	def getAllOppent
		return $game_party.members
	end
	
end








