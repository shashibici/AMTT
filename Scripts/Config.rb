{
=begin
	Usage:
	$XX_DB[battler_id]["attribute_name"]
	
	Then it will return the value.
-------------------------------------------------
	e.g.
	$enemy_atk = $BATTLER_DB[3]["atk"]

--------------------------------------------------
	注意：battler的名字与大图名字相同；icon与小图名字相同;
		中等图片通过缩放功能实现。战斗的时候会显示中等图片。
		浏览信息的时候会显示大图。
	

=end
}
$BATTLER_DB = {

	#----------------------------------------------------
	#	Parameters for No.1 enemy.
	#----------------------------------------------------
	1 => {
		"name"             	=>  "Monstor1",
		"icon"      		=>	"001.png",
		"atk"              	=> 	100,
		"w1"				=>	1,
		"a4"				=>	3,
		"t1"				=>	900,
		"t2"				=>	901,
	},
	#----------------------------------------------------
	#	Parameters for No.2 enemy.
	#----------------------------------------------------
	2 => {
		"name"     			=>	"Monstor2",
		"icon"				=>	"002.png"
		"atk"      			=>	200,
	},


}

$BATTLER_NOTE = {
	1 => {
		"describ1"		=>	"经常生活在草丛中"
	}

}


$EQUIP_DB = {
	"weapon" => 	{
		#---------------------------------------------------
		0	=>	{
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
		#---------------------------------------------------
		1	=>	{
			"atk"			=>	100,
			"defence"		=>	200,
			"maxhp"			=>	500,
		},
	
	
	},
	
	"armor"	=>		{
		#---------------------------------------------------
		0	=>	{
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
	
	},
	
	"trea"	=>		{
		#---------------------------------------------------
		0	=>	{
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
		
	}	
	

}


$SKILL_DB = {

}




