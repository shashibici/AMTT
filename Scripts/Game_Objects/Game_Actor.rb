
#==============================================================================
	# ■ Game_Actor
	#------------------------------------------------------------------------------
	# 　处理角色的类。本类在 Game_Actors 类 ($game_actors)
	# 的内部使用、Game_Party 类请参考 ($game_party) 。
#==============================================================================

class Game_Actor < Game_Battler
	include GAME_CONF
	include GAME_INIT
	
	attr_accessor   :suits
	attr_accessor   :kit_ids
	attr_accessor   :kit_components
	attr_accessor   :exp_list
	attr_accessor   :name
	attr_accessor   :is_equip_changed   # 装备， 0-没有变过，1-变过
	attr_accessor   :myequips           # 保存当前装备的实体
	# 实际上 @myequip_kits = @myequips + self.kits
	attr_accessor   :myequip_kits       # 保存包含套装的实体（包括虚拟套装）
	attr_accessor	:my_skills
	attr_accessor   :weapon1_id 
	attr_accessor   :weapon2_id  
	attr_accessor   :armor1_id   
	attr_accessor   :armor2_id   
	attr_accessor   :armor3_id   
	attr_accessor   :armor4_id   
	attr_accessor   :armor5_id  
	attr_accessor   :armor6_id  
	attr_accessor   :armor7_id   
	attr_accessor   :armor8_id  
	attr_accessor   :armor9_id  
	attr_accessor   :armor10_id  
	attr_accessor   :armor11_id  
	attr_accessor   :armor12_id 
	
	#---------------------------------------------------
	# 	能力属性值相关 - 装备相关
	#----------------------------------------------------
	attr_accessor   :real_hpcover   # 记录英雄每秒回血
	attr_accessor   :real_mpcover   # 记录英雄每秒回魔
	attr_accessor   :type           # 记录英雄的主属性：1力量2敏捷3智力
	attr_accessor   :level
	
	#=======以下是描述英雄能力的各个属性====================
  
	attr_accessor   :hmaxhp       # 生命
	attr_accessor   :hmaxmp       # 魔法
	attr_accessor   :hatk         # 攻击
	attr_accessor   :hdef         # 护甲
  
	attr_accessor   :strength     # 力量
	attr_accessor   :celerity     # 敏捷
	attr_accessor   :wisdom       # 智力
  
	attr_accessor   :destroy      # 物理破坏力因子
	attr_accessor   :destroyrate  # 物理破坏额外倍数（%）
  
	attr_accessor   :mdestroy     # 魔法破坏力因子
	attr_accessor   :mdestroyrate # 魔法破坏额外倍数（%）
  
	attr_accessor   :atkspeed     # 攻速因子
	attr_accessor   :atkrate      # 攻速率
  
	attr_accessor   :eva          # 闪避因子
	attr_accessor   :evarate      # 闪避率
  
	attr_accessor   :bom          # 暴击因子
	attr_accessor   :bomrate      # 暴击率
	attr_accessor   :bomatk       # 暴击扩张倍数（%）
  
	attr_accessor   :hit          # 命中因子
	attr_accessor   :hitrate      # 命中率
  
	attr_accessor   :hpcover      # 生命恢复因子
	attr_accessor   :hprate       # 生命恢复率
	attr_accessor   :mpcover      # 魔法恢复因子
	attr_accessor   :mprate       # 魔法恢复率
  
	#=======下为武器装备产生的额外增加（英雄的成长值）=========
  
	attr_accessor   :xhmaxhp       # 生命
	attr_accessor   :xhmaxmp       # 魔法
	attr_accessor   :xhatk         # 攻击
	attr_accessor   :xhdef         # 护甲
  
	attr_accessor   :xstrength     # 力量
	attr_accessor   :xcelerity     # 敏捷
	attr_accessor   :xwisdom       # 智力
  
	attr_accessor   :xdestroy      # 物理破坏力因子
	attr_accessor   :xdestroyrate  # 物理破坏额外倍数（%）
	
	attr_accessor   :xmdestroy     # 魔法破坏力因子
	attr_accessor   :xmdestroyrate # 魔法破坏额外倍数（%）
  
	attr_accessor   :xatkspeed     # 攻速因子
	attr_accessor   :xatkrate      # 攻速率
  
	attr_accessor   :xeva          # 闪避因子
	attr_accessor   :xevarate      # 闪避率
  
	attr_accessor   :xbom          # 暴击因子
	attr_accessor   :xbomrate      # 暴击率
	attr_accessor   :xbomatk       # 暴击扩张倍数（%）
  
	attr_accessor   :xhit          # 命中因子
	attr_accessor   :xhitrate      # 命中率
  
	attr_accessor   :xhpcover      # 生命恢复因子
	attr_accessor   :xhprate       # 生命恢复率
	attr_accessor   :xmpcover      # 魔法恢复因子
	attr_accessor   :xmprate       # 魔法恢复率
	
	# 按百分比加成的装备
	attr_accessor   :xmaxhprate				
	attr_accessor   :xmaxmprate				
	attr_accessor   :xmaxatkrate			
	attr_accessor   :xmaxdefrate			
	attr_accessor   :xmaxstrengthrate		
	attr_accessor   :xmaxcelerityrate		
	attr_accessor   :xmaxwisdomrate
	
	
	#--------------------------------------------------------------------------
	# ● 是否有这个技能
	#--------------------------------------------------------------------------
	def has_skill?(skill_id)
		return @my_skills.include?(skill_id)
	end
	#--------------------------------------------------------------------------
		# ● 初始化对象
		#     actor_id : 角色 ID
		#
		#     重定义
		#
	#--------------------------------------------------------------------------
	def initialize(actor_id)
		super() 
		# 创建一个空的套装hash表
		@suits = {}
		# 初始化套装表
		@kit_ids = []
		# 初始化装备指示器 (0表示上次以来都没改变过)
		@is_equip_changed = 1
		@myequip_kits = []
		@myequips = [] 
		@my_skills = {}
		# 设置角色
		setup(actor_id)
		@last_skill_id = 0
		# 因为修改，所以出了点问题，乱给一个参数就行了
		@activeskills = []
		@activeskills.push($data_skills[1])
	end  
	#--------------------------------------------------------------------------
	# ● 设置套装装备记录表
	# 
	#      调用此函数修改当前套装的收集情况
	#      此函数调用结束后，应该调用set_kits函数判断收集情况
	#      每当有装备变动时都应该调用此函数
	#
	#  		配合 set_kits 使用，套装部件不能有两个相同的
	# 		例如，不能有两个 A 装备，组成为一个 B 装备。 
	#		必须由 A 装备和 B 装备 组合成 C 装备
	#
	#--------------------------------------------------------------------------
	def set_suits
		
		# 首先清空原来的残留物
		@suits = {}
		# 此时不考虑套装,把所有实体装备拿出来
		for equip in (weapons + armors) do 
			next if equip == nil
			# 如果不是套装组件则跳过
			next if equip.read_note("makesuit") == nil 
			# 如果是套装组件
			suit_list = equip.read_note("makesuit")
			# 获得当前装备的id
			equip_id = equip.id   
			# 修正id
			if equip.is_a?(RPG::Weapon)    
				equip_id += 1000
			elsif equip.is_a?(RPG::Armor)
				equip_id += 2000
			end
			# 对该装备能够组成的所有套装逐一进行处理
			for id in suit_list do 
				# 查看该id的套装是否已经载入@suits哈希表
				if @suits.include?(id)
					# 如果已经装入，那么修改列表:
					componets = @suits[id]         # 获得当前组成
					componets.delete(equip_id)     # 删除当前装备的序号
					@suits[id] = componets         # 将修改后的列表写回(其实没必要)
				else
					# 如果没有装入那么先调入，必须克隆
					@suits[id] = Suits_Describe[id].clone
					# 再修改
					componets = @suits[id]         # 获得当前组成
					componets.delete(equip_id)     # 删除当前装备的序号
					@suits[id] = componets         # 将修改后的列表写回
				end
				# 对该装备能够组成的一件套装处理完毕    
			end
			# 对一件能够生成套装的装备处理完成  
		end
		# 调用set_kits判断是否集齐了套装
		# 无论以前如何，都已刚刚调整好的收集情况为基础
		# 即使以前收集齐了，现在不齐，也是不行的。
		# 即使以前没齐，现在齐了，也是可以的
		set_kits
	end
	#--------------------------------------------------------------------------
	# ● 设置套装成品表
	#    
	#    在调用完set_suits函数，修改套装收集情况之后，
	#    调用本函数，判断套装收集情况
	#    每当有装备变动都应该调用此函数
	#--------------------------------------------------------------------------
	def set_kits
		# 如果哈希表为空，则直接返回
		return if @suits.size == 0
		# 首先清空原来的内容
		@kit_ids = []
		# 对每一个元素遍历，检测是否满足要求
		@suits.each_pair{
			|key, value|
			if value == []
				# 说明该套装已经符合
				# 那么应该载入该装备的id，放到kit_ids中
				@kit_ids.push(key)
			end
		}
	end
	#--------------------------------------------------------------------------
	# ● 获取虚拟套装（将所有部件装在身上就能获得一个相应的‘虚拟套装'效果）
	#
	#    
	#--------------------------------------------------------------------------
	def kits
		result = []
		return result if @kit_ids.size == 0
		for i in 0...@kit_ids.size do
			id = @kit_ids[i]
			if id >= 1 and id <= 999
				# item类型的
				result.push($data_items[id])
			elsif id >= 1001 and id <= 1999
				# weapons类型的
				result.push($data_weapons[id-1000])
			elsif id >= 2001 and id <= 2999
				# weapons类型的
				result.push($data_armors[id-2000])
			end
			# for循环结束  
		end
		return result
	end
	#--------------------------------------------------------------------------
	# ● 获取各个套装的各个部件
	#
	#    >>>>>> 没有使用！ <<<<<<<
	#--------------------------------------------------------------------------
	def kit_components
		result = []
		# 将所有装备取出来方便操作
		all_equips = (weapons + armors).clone
		# 没有装备
		return result if all_equips.size == 0
		for kit_object in all_equips do
			# 如果空，直接跳过
			next if kit_object == nil
			# 如果不是套装，直接跳过
			next if (components_list = kit_object.read_note('suit_component')) == nil
			# 取出零件装备对象，加入结果
			for component_id in components_list do
				if component_id >= 1 and component_id <= 999
					# item类型的
					result += getAllComponents($data_items[component_id])
				elsif component_id >= 1001 and component_id <= 1999
					# weapons类型的
					result += getAllComponents($data_weapons[component_id-1000])
				elsif component_id >= 2001 and component_id <= 2999
					# weapons类型的
					result += getAllComponents($data_armors[component_id-2000])
				end
				# 将一件套装中的所有零件装备取出  
			end
			# 对所有套装，执行了遍历  
		end    
		return  result
	end
	#--------------------------------------------------------------------------
		# ● 层序遍历返回一个装备的所有组件（不包括自己！）
		#
		#     equip    : 装备对象。
		#
		#     如果装备是套装，就返回它的所有子套装及其组件，否则返回自己
		#
	#--------------------------------------------------------------------------
	def getAllComponents(equip)
		# 如果是空，直接返回空
		return [] if equip == nil
		
		# 否则查看套装表
		queue = []
		result = []
		e = equip
		loop do 
			list = e.read_note('suit_component')
			# 该装备有组件
			if nil != list
				# 将所有套件id 转成 object,存入queue
				for id in list do
					if id >= 1 and id <= 999
						# item类型的
						item = $data_items[id]
					elsif id >= 1001 and id <= 1999
						# weapons类型的
						item = $data_weapons[id-1000]
					elsif id >= 2001 and id <= 2999
						# weapons类型的
						item = $data_armors[id-2000]
					else
						# 没有这个id的物品
						item = nil
					end
					# 如果不是空，则入队列
					if nil != item
						queue.push(item)
					end
				end  # end of for
			end
			# 判断是否在队列中有待处理的装备
			if 0 == queue.size
				break
			end
			# 对队列进行操作
			e = queue.pop
			result.push(e)
		end
		# 最后返回一个装备对象列表
		return result
		end
	#--------------------------------------------------------------------------
	# ● 获取装备对象列表
	#
	#    参数  flag  ： 是否考虑套装，在还没初始化套装时，不考虑套装
	#                   其他情况下，考虑套装
	#
	#			flag  = flase, 不考虑所有虚拟装备（套装的子装备或者装备合成的虚拟套装）
	#			flag  = true, 考虑所有虚拟装备（套装的子装备，装备集齐后的虚拟套装）
	#
	# 	@myequips 		:	用来存放实体部件
	#	@myequip_kits 	：	存放实体部件+所有虚拟部件
	#
	#    重定义
	#  
	#--------------------------------------------------------------------------
	def equips(flag = true)
		# 如果并不是因为刚刚换过装备，那么不需要重新计算
		# 直接用原来的值就行了。
		if 0 == @is_equip_changed
			if flag == true
				return @myequip_kits
			else
				return @myequips
			end
		end
		@is_equip_changed = 0
		# 否则刚刚换过装备，需要重新计算
		res = weapons + armors
		# 清空原有缓存
		@myequips = res
		# 更新虚拟套装的缓存(集齐散装后获得的虚拟部件)
		@myequip_kits = @myequips + kits
		# 更新虚拟套装的缓存(通过实体部件获得虚拟散装部件)
		for e in @myequips
			next if nil == e
			@myequip_kits += getAllComponents(e)
		end
		# 如果需要考虑虚拟套装
		if flag == true
			return @myequip_kits
		else
			return @myequips
		end
	end
	
end
