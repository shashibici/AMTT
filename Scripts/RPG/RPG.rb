module RPG
	class BaseItem
		attr_reader    :attrs_all    # 递归计算的属性
		attr_reader    :attrs_self   # 自身的属性
		attr_reader    :colstr   	 # name colors: e.g. "light green"
		attr_accessor  :is_virtual   # 指示是否为virtual装备
		#--------------------------------------------------------------------------
		# ●  返回	： 	string, e.g., "linght green"
		#
		#--------------------------------------------------------------------------
		def getColor
			return @colstr
		end
		#--------------------------------------------------------------------------
		# ●  newColor 	: 	string, e.g., "light green"
		#
		#--------------------------------------------------------------------------
		def setColor(newColor)
			@colstr = newColor
		end
		#--------------------------------------------------------------------------
		# ●  用来初始化增强装备的属性，在游戏开始前运行
		#
		#--------------------------------------------------------------------------
		def initMe
			@is_virtual = false
			# 递归属性
			@attrs_all = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
			# 自身属性
			@attrs_self = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
			# 初始化递归属性和自身属性
			read_suit_all
			@colstr = read_note('color')
			@colstr = "white" if nil == @colstr
			# 仅仅处理武器、防具
			if self.is_a?(RPG::Armor) || self.is_a?(RPG::Weapon)
				if self.is_a?(RPG::Weapon)
					tid = self.id + 1000
					locate = 0
				else
					locate = read_note('locate')
					# 为空则用额外的空间存储
					locate = 8 if nil == locate
					tid = self.id + 2000
				end
				# 写入数据结构
				GAME_INIT::Equip_Descriptions[locate][self.id.to_s] = GAME_INIT.getSuitAttr(tid, "", @colstr) 
			end
		end
		#--------------------------------------------------------------------------
		# ● 返回一个装备的属性数据
		#    flag = true 将此装备的组件属性也计算在内，一同返回
		#    flag = false 紧紧返回次装备的属性。
		#
		#--------------------------------------------------------------------------\
		def attrs
			if true ==  @is_virtual 
				return @attrs_self
			else 
				return @attrs_all
			end
		end
		#--------------------------------------------------------------------------
		# ● 递归获取一个装备的所有组件,包括自己的id
		#
		#     equip          : 装备对象,使用的时候传入自己就能获得自己的ID。
		#     recursive     : 如果为true则递归返回所有组件和自己的ID，否则返回自己ID 
		#
		#     如果装备是套装，就返回它的所有子套装及其组件，否则返回自己
		#
		#
		#    
		#
		#--------------------------------------------------------------------------
		def getAllComponentId(equip, recursive = true)
			# 为空，直接返回空
			return nil if nil == equip
			# 不递归，直接返回自己。
			
			# 层序遍历
			queue = []
			result = []
			if equip.is_a?(RPG::Item)
				return equip.id if recursive ==  false
				queue.push(equip.id)
			elsif equip.is_a?(RPG::Weapon)
				return equip.id+1000 if recursive ==  false
				queue.push(equip.id+1000)
			else
				return equip.id+2000 if recursive ==  false
				queue.push(equip.id+2000)
			end
			while queue.size > 0
				tid = queue.pop
				result.push(tid)
				if tid >= 1 and tid <= 999
					# item类型的
					item = $data_items[tid]
				elsif tid >= 1001 and tid <= 1999
					# weapons类型的
					item = $data_weapons[tid-1000]
				elsif tid >= 2001 and tid <= 2999
					# weapons类型的
					item = $data_armors[tid-2000]
				else
					# 没有这个id的物品
					item = nil
				end
				if nil != item
					list = item.read_note('suit_component')
					# 如果有组件，则插入队头
					if list != nil
						queue = list + queue
					end
				end
			end
			# 最后返回一个装备对象列表
			return result
		end
		#-----------------------------------------------------------------------
		# ● 获得一个套装指定的属性
		#     
		#   input   : 属性的名字 e.g. "strength"
		#   return  : 该属性在数据库中对应的值
		#
		#-----------------------------------------------------------------------
		def read_suit_attr(session, recursive = true)
			res = 0	
			# 获得所有套装组件id，包括自己！
			suit_component = getAllComponentId(self, recursive)
			return nil if suit_component == nil
			for sc in suit_component 
				# 如果不是一个合法id 直接跳过
				next if sc <= 1000 or sc >= 3000 or sc == 2000
				if sc > 2000
					item = $data_armors[sc - 2000]
				elsif sc < 2000
					item = $data_weapons[sc - 1000]
				else
					item = nil
				end
				# 如果item 存在
				if nil != item
					val = item.read_note(session)
					if nil != val
						res += val
					end
				end
			end
			if 0 == res 
				return nil
			else
				return res
			end
		end
		#-----------------------------------------------------------------------
		# ● 获得一个装备的所有属性值
		#
		#
		#     [maxhp, maxhpr, maxmp, maxmpr, atk, atkr, def, defr,
		#      strength, strengthr, celerity, celerityr, wisdom, wsidomr,
		#      destroy, destroyr(%), mdestroy, mdestroyr(%), atkspeed, 
		#      atkspeedr(%),
		#      eva, evar(%), bom, bomrate(%), bomatk, hit, hitrate(%), 
		#      hpcover, hprate(%),
		#      mpcover, mprate(%)]
		#
		#     input: 是否需要清空 @attrs
		#
		#-----------------------------------------------------------------------
		def read_suit_all(needclear = false)
			if true == needclear
				@attrs_all = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
				@attrs_self = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
			end
				e = self
				# 如果item 存在
				if nil != e
					## maxhp
					if (tmp=e.read_note('maxhp')) != nil
						@attrs_self[0] += tmp
					end
					if (tmp=e.read_note('maxhprate')) != nil
						@attrs_self[1] += tmp 
					end
					
					### maxmp
					if (tmp=e.read_note('maxmp')) != nil
						@attrs_self[2] += tmp
					end
					if (tmp=e.read_note('maxmprate')) != nil
						@attrs_self[3] += tmp 
					end
					
					### atk
					if (tmp=e.read_note('atk')) != nil
						@attrs_self[4] += tmp
					end         
					if (tmp=e.read_note('atkrate')) != nil
						@attrs_self[5] += tmp
					end
					
					# def
					if (tmp=e.read_note('ddef')) != nil
						@attrs_self[6] += tmp
					end
					if (tmp=e.read_note('defrate')) != nil
						@attrs_self[7] += tmp
					end
					
					# strength
					if (tmp=e.read_note('strength')) != nil
						@attrs_self[8] += tmp
					end
					if (tmp=e.read_note('strengthrate')) != nil
						@attrs_self[9] += tmp
					end
					
					# celerity
					if (tmp=e.read_note('celerity')) != nil
						@attrs_self[10] += tmp
					end
					if (tmp=e.read_note('celerityrate')) != nil
						@attrs_self[11] += tmp
					end
					
					# wisdom
					if (tmp=e.read_note('wisdom')) != nil
						@attrs_self[12] += tmp 
					end
					if (tmp=e.read_note('wisdomrate')) != nil      
						@attrs_self[13] += tmp
					end
					
					# destroy
					if (tmp=e.read_note('destroy')) != nil
						@attrs_self[14] += tmp
					end
					if (tmp=e.read_note('destroyr')) != nil
						@attrs_self[15] += tmp
					end
					
					# mdestroy
					if (tmp=e.read_note('mdestroy')) != nil
						@attrs_self[16] += tmp
					end
					if (tmp=e.read_note('mdestroyr')) != nil
						@attrs_self[17] += tmp
					end
					
					# atkspeed
					if (tmp=e.read_note('atkspeed')) != nil
						@attrs_self[18] += tmp
					end
					if (tmp=e.read_note('atkspeedrate')) != nil
						@attrs_self[19] += tmp
					end
					
					#eva
					if (tmp=e.read_note('eva')) != nil
						@attrs_self[20] += tmp
					end
					if (tmp=e.read_note('evarate')) != nil
						@attrs_self[21] += tmp
					end
					
					# bom
					if (tmp=e.read_note('bom')) != nil
						@attrs_self[22] += tmp
					end
					if (tmp=e.read_note('bomrate')) != nil
						@attrs_self[23] += tmp
					end
					if (tmp=e.read_note('bomatk')) != nil
						@attrs_self[24] += tmp
					end
					
					#hit
					if (tmp=e.read_note('hit')) != nil
						@attrs_self[25] += tmp
					end
					if (tmp=e.read_note('hitrate')) != nil
						@attrs_self[26] += tmp
					end
					
					# hpcover
					if (tmp=e.read_note('hpcover')) != nil
						@attrs_self[27] += tmp
					end
					if (tmp=e.read_note('hprate')) != nil
						@attrs_self[28] += tmp
					end
					
					# mpcover
					if (tmp=e.read_note('mpcover')) != nil
						@attrs_self[29] += tmp
					end
					if (tmp=e.read_note('mprate')) != nil 
						@attrs_self[30] += tmp
					end
				end # end of e!=nil
			# 获得所有套装组件id，包括自己！
			suit_component = getAllComponentId(self, true)
			for sc in suit_component 
				# 如果不是一个合法id 直接跳过
				next if sc <= 1000 or sc >= 3000 or sc == 2000
				if sc > 2000
					e = $data_armors[sc - 2000]
				elsif sc < 2000
					e = $data_weapons[sc - 1000]
				else
					e = nil
				end
				# 如果item 存在
				if nil != e
					## maxhp
					if (tmp=e.read_note('maxhp')) != nil
						@attrs_all[0] += tmp
					end
					if (tmp=e.read_note('maxhprate')) != nil
						@attrs_all[1] += tmp 
					end
					
					### maxmp
					if (tmp=e.read_note('maxmp')) != nil
						@attrs_all[2] += tmp
					end
					if (tmp=e.read_note('maxmprate')) != nil
						@attrs_all[3] += tmp 
					end
					
					### atk
					if (tmp=e.read_note('atk')) != nil
						@attrs_all[4] += tmp
					end         
					if (tmp=e.read_note('atkrate')) != nil
						@attrs_all[5] += tmp
					end
					
					# def
					if (tmp=e.read_note('ddef')) != nil
						@attrs_all[6] += tmp
					end
					if (tmp=e.read_note('defrate')) != nil
						@attrs_all[7] += tmp
					end
					
					# strength
					if (tmp=e.read_note('strength')) != nil
						@attrs_all[8] += tmp
					end
					if (tmp=e.read_note('strengthrate')) != nil
						@attrs_all[9] += tmp
					end
					
					# celerity
					if (tmp=e.read_note('celerity')) != nil
						@attrs_all[10] += tmp
					end
					if (tmp=e.read_note('celerityrate')) != nil
						@attrs_all[11] += tmp
					end
					
					# wisdom
					if (tmp=e.read_note('wisdom')) != nil
						@attrs_all[12] += tmp 
					end
					if (tmp=e.read_note('wisdomrate')) != nil      
						@attrs_all[13] += tmp
					end
					
					# destroy
					if (tmp=e.read_note('destroy')) != nil
						@attrs_all[14] += tmp
					end
					if (tmp=e.read_note('destroyr')) != nil
						@attrs_all[15] += tmp
					end
					
					# mdestroy
					if (tmp=e.read_note('mdestroy')) != nil
						@attrs_all[16] += tmp
					end
					if (tmp=e.read_note('mdestroyr')) != nil
						@attrs_all[17] += tmp
					end
					
					# atkspeed
					if (tmp=e.read_note('atkspeed')) != nil
						@attrs_all[18] += tmp
					end
					if (tmp=e.read_note('atkspeedrate')) != nil
						@attrs_all[19] += tmp
					end
					
					#eva
					if (tmp=e.read_note('eva')) != nil
						@attrs_all[20] += tmp
					end
					if (tmp=e.read_note('evarate')) != nil
						@attrs_all[21] += tmp
					end
					
					# bom
					if (tmp=e.read_note('bom')) != nil
						@attrs_all[22] += tmp
					end
					if (tmp=e.read_note('bomrate')) != nil
						@attrs_all[23] += tmp
					end
					if (tmp=e.read_note('bomatk')) != nil
						@attrs_all[24] += tmp
					end
					
					#hit
					if (tmp=e.read_note('hit')) != nil
						@attrs_all[25] += tmp
					end
					if (tmp=e.read_note('hitrate')) != nil
						@attrs_all[26] += tmp
					end
					
					# hpcover
					if (tmp=e.read_note('hpcover')) != nil
						@attrs_all[27] += tmp
					end
					if (tmp=e.read_note('hprate')) != nil
						@attrs_all[28] += tmp
					end
					
					# mpcover
					if (tmp=e.read_note('mpcover')) != nil
						@attrs_all[29] += tmp
					end
					if (tmp=e.read_note('mprate')) != nil 
						@attrs_all[30] += tmp
					end
				end # end of e!=nil
			end  # end of for
		end # end of read_suit_all function
	end # end of class
end # end of module
