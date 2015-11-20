{
=begin
	装备定义示意：
	1	=>	{
			"strength"		=>	0,
			"strength_r"	=>	0,	#(%)
			"strength_s"	=>	0,
			"strength_sr"	=>	0,	#(%)
			"hp"			=>	0,
			"hp_r"			=>	0,	#(%)
			"hp_s"			=>	0,
			"hp_sr"			=>	0,	#(%)
			"rehp"			=>	0
			"rehp_r"		=>	0, 	#(%)
			"rehp_s"		=> 	0,
			"rehp_sr"		=>	0,	#(%)
			"destroy"		=>	0,
			"destroy_r"		=>	0,	#(%)
			"destroy_s"		=>	0,
			"destroy_sr"	=>	0,	#(%)
			"celerity"		=>	0,
			"celerity_r"	=>	0,	#(%)
			"celerity_s"	=>	0,	
			"celerity_sr"	=>	0,	#(%)
			"atk"			=>	0,
			"atk_r"			=>	0,	#(%)
			"atk_s"			=>	0,	
			"atk_sr"		=>	0,	#(%)
			"defence"		=>	0,
			"defence_r"		=>	0,	#(%)
			"defence_s"		=>	0,	
			"defence_sr"	=>	0,	#(%)
			"speed"			=>	0,
			"speed_r"		=>	0,	#(%)
			"speed_s"		=>	0,
			"speed_sr"		=>	0,	#(%)
			"wisdom"		=>	0,
			"wisdom_r"		=>	0,	#(%)
			"wisdom_s"		=>	0,
			"wisdom_sr"		=>	0,	#(%)
			"mp"			=>	0,
			"mp_r"			=>	0,	#(%)
			"mp_s"			=>	0,
			"mp_sr"			=>	0,	#(%)
			"remp"			=>	0,
			"remp_r"		=>	0,	#(%)
			"remp_s"		=>	0,
			"remp_sr"		=>	0,	#(%)
			"mdestroy"		=>	0,
			"mdestroy_r"	=>	0,	#(%)
			"mdestroy_s"	=>	0,
			"mdestroy_sr"	=>	0,	#(%)
			"hit"			=>	0,
			"hit_r"			=>	0,	#(%)
			"hit_s"			=>	0,
			"hit_sr"		=>	0,	#(%)
			"eva"			=>	0,
			"eva_r"			=>	0,	#(%)
			"eva_s"			=>	0,
			"eva_sr"		=>	0,	#(%)
		},

=end
}
Moudule RPG

	class BaseItem
		def price__b
			return getInt("price")
		end
		#----------------------------------------------------------------------
		#	加载base之上的，对real有影响
		#----------------------------------------------------------------------
		def str__b
			return getInt("strength")
		end
		def hp__b
			return getInt("hp")
		end
		def rehp__b
			return getInt("rehp")
		end
		def des__b
			return getInt("destroy")
		end
		def cel__b
			return getInt("celerity")
		end
		def	atk__b
			return getInt("atk")
		end
		def def__b
			return getInt("def")
		end
		def speed__b
			return getInt("speed")
		end
		def wis__b
			return getInt("wisdom")
		end
		def mp__b
			return getInt("mp")
		end
		def remp__b
			return getInt("remp")
		end
		def mdes__b
			return getInt("mdes")
		end
		def hit__b
			return getInt("hit")
		end
		def eva__b
			return getInt("eva")
		end
		# 暴击百分比
		def bom__b
			return getInt("bom")
		end
		#----------------------------------------------------------------------
		#	加在self之上的，对base有影响
		#----------------------------------------------------------------------
		def str__s
			return getInt("strength_s")
		end
		def hp__s
			return getInt("hp_s")
		end
		def rehp__s
			return getInt("rehp_s")
		end
		def des__s
			return getInt("destroy_s")
		end
		def cel__s
			return getInt("celerity_s")
		end
		def	atk__s
			return getInt("atk_s")
		end
		def def__s
			return getInt("def_s")
		end
		def speed__s
			return getInt("speed_s")
		end
		def wis__s
			return getInt("wisdom_s")
		end
		def mp__s
			return getInt("mp_s")
		end
		def remp__s
			return getInt("remp_s")
		end
		def mdes__s
			return getInt("mdes_s")
		end
		def hit__s
			return getInt("hit_s")
		end
		def eva__s
			return getInt("eva_s")
		end
		# 暴击百分比
		def bom__s
			return getInt("bom_s")
		end
		#----------------------------------------------------------------------
		#	加载base之上的，对real有影响
		#----------------------------------------------------------------------
		def str__br
			return getInt("strength_r")
		end
		def hp__br
			return getInt("hp_r")
		end
		def rehp__br
			return getInt("rehp_r")
		end
		def des__br
			return getInt("destroy_r")
		end
		def cel__br
			return getInt("celerity_r")
		end
		def	atk__br
			return getInt("atk_r")
		end
		def def__br
			return getInt("def_r")
		end
		def speed__br
			return getInt("speed_r")
		end
		def wis__br
			return getInt("wisdom_r")
		end
		def mp__br
			return getInt("mp_r")
		end
		def remp__br
			return getInt("remp_r")
		end
		def mdes__br
			return getInt("mdes_r")
		end
		def hit__br
			return getInt("hit_r")
		end
		def eva__br
			return getInt("eva_r")
		end
		# 暴击百分比
		def bom__br
			return getInt("bom_r")
		end
		#----------------------------------------------------------------------
		#	加在self之上的，对base有影响
		#----------------------------------------------------------------------
		def str__sr
			return getInt("strength_sr")
		end
		def hp__sr
			return getInt("hp_sr")
		end
		def rehp__sr
			return getInt("rehp_sr")
		end
		def des__sr
			return getInt("destroy_sr")
		end
		def cel__sr
			return getInt("celerity_sr")
		end
		def	atk__sr
			return getInt("atk_sr")
		end
		def def__sr
			return getInt("def_sr")
		end
		def speed__sr
			return getInt("speed_sr")
		end
		def wis__sr
			return getInt("wisdom_sr")
		end
		def mp__sr
			return getInt("mp_sr")
		end
		def remp__sr
			return getInt("remp_sr")
		end
		def mdes__sr
			return getInt("mdes_sr")
		end
		def hit__sr
			return getInt("hit_sr")
		end
		def eva__sr
			return getInt("eva_sr")
		end
		# 暴击百分比
		def bom__sr
			return getInt("bom_sr")
		end
		
	end

	class Weapon < BaseItem
		#----------------------------------------------------------------------
		#
		#----------------------------------------------------------------------
		def getInt(session)
			w = $EQUIP_DB[1][@id]
			# if no such a weapon
			return 0 if w == nil
			# if no such a session
			return 0 if w[session] == nil
			return w[session]
		end
		#----------------------------------------------------------------------
		#
		#----------------------------------------------------------------------
		def getStr(session)
			w = $EQUIP_DB[1][@id]
			# if no such a weapon
			return "" if w == nil
			# if no such a session
			return  "" if w[session] == nil
			return w[session]
		end

	end
	
	class Armor < BaseItem
		#----------------------------------------------------------------------
		#
		#----------------------------------------------------------------------
		def getInt(session)
			a = $EQUIP_DB[2][@id]
			# if no such a armor
			return 0 if a == nil
			# if no such a session
			return 0 if a[session] == nil
			return a[session]
		end
		#----------------------------------------------------------------------
		#
		#----------------------------------------------------------------------
		def getStr(session)
			a = $EQUIP_DB[2][@id]
			# if no such a armor
			return "" if a == nil
			# if no such a session
			return  "" if a[session] == nil
			return a[session]
		end
	end


	
	

end