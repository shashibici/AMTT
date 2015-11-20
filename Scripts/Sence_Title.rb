	
class Sence_Title < Sence_Base	
	
	#--------------------------------------------------------------------------
	# ● 载入数据库
	#--------------------------------------------------------------------------
	def load_database
		$data_actors        = load_data("Data/Actors.rvdata")
		$data_classes       = load_data("Data/Classes.rvdata")
		$data_skills        = load_data("Data/Skills.rvdata")
		$data_items         = load_data("Data/Items.rvdata")
		$data_weapons       = load_data("Data/Weapons.rvdata")
		$data_armors        = load_data("Data/Armors.rvdata")
		$data_enemies       = load_data("Data/Enemies.rvdata")
		$data_troops        = load_data("Data/Troops.rvdata")
		$data_states        = load_data("Data/States.rvdata")
		$data_animations    = load_data("Data/Animations.rvdata")
		$data_common_events = load_data("Data/CommonEvents.rvdata")
		$data_system        = load_data("Data/System.rvdata")
		$data_areas         = load_data("Data/Areas.rvdata")
		$data_mapname       = load_data("Data/MapInfos.rvdata")
		data_Modification
	end
	
	#--------------------------------------------------------------------------
	# ● 载入数据库
	#--------------------------------------------------------------------------
	def data_Modification
		# $data_actors may be only used in a map sence, not in a battle sence.
		
		# $data_classes not changed
		
		# TODO: need some changes to $data_skills
		
		# TODO: need some changes to $data_items
		
		# We don't need to make any changes to $data_weapons, since all the attributes of
		# a weapon will be read from a previously defined data-structure.
		
		# We don't need to make any changes to $data_armors, since all the attributes of
		# an armor will be read from a previously defined data-structure.

		# $data_enemies may be only used in a map sence, not in a battle sence.
		
		# $data_troops may be only used in a map sence, not in a battle sence.
		
	end
	
	
	
	
	
end