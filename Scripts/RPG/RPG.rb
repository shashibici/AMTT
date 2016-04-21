module RPG
	class BaseItem
		attr_reader    :attrs
		attr_reader    :colstr   # name colors: e.g. "light green"
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
			@attrs = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
		# ● 递归获取一个装备的所有组件,包括自己的id
		#
		#     equip    : 装备对象,使用的时候传入自己就能获得自己的。
		#
		#     如果装备是套装，就返回它的所有子套装及其组件，否则返回自己
		#
		#--------------------------------------------------------------------------
		def getAllComponentId(equip)
			# 为空，直接返回空
			return nil if nil == equip
			# 层序遍历
			queue = []
			result = []
			if equip.is_a?(RPG::Item)
				queue.push(equip.id)
			elsif equip.is_a?(RPG::Weapon)
				queue.push(equip.id+1000)
			else
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
		def read_suit_attr(session)
			res = 0	
			# 获得所有套装组件id，包括自己！
			suit_component = getAllComponentId(self)
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
				@attrs = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
			end
			# 获得所有套装组件id，包括自己！
			suit_component = getAllComponentId(self)
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
						attrs[0] += tmp
					end
					if (tmp=e.read_note('maxhprate')) != nil
						attrs[1] += tmp 
					end
					
					### maxmp
					if (tmp=e.read_note('maxmp')) != nil
						attrs[2] += tmp
					end
					if (tmp=e.read_note('maxmprate')) != nil
						attrs[3] += tmp 
					end
					
					### atk
					if (tmp=e.read_note('atk')) != nil
						attrs[4] += tmp
					end         
					if (tmp=e.read_note('atkrate')) != nil
						attrs[5] += tmp
					end
					
					# def
					if (tmp=e.read_note('ddef')) != nil
						attrs[6] += tmp
					end
					if (tmp=e.read_note('defrate')) != nil
						attrs[7] += tmp
					end
					
					# strength
					if (tmp=e.read_note('strength')) != nil
						attrs[8] += tmp
					end
					if (tmp=e.read_note('strengthrate')) != nil
						attrs[9] += tmp
					end
					
					# celerity
					if (tmp=e.read_note('celerity')) != nil
						attrs[10] += tmp
					end
					if (tmp=e.read_note('celerityrate')) != nil
						attrs[11] += tmp
					end
					
					# wisdom
					if (tmp=e.read_note('wisdom')) != nil
						attrs[12] += tmp 
					end
					if (tmp=e.read_note('wisdomrate')) != nil      
						attrs[13] += tmp
					end
					
					# destroy
					if (tmp=e.read_note('destroy')) != nil
						attrs[14] += tmp
					end
					if (tmp=e.read_note('destroyr')) != nil
						attrs[15] += tmp
					end
					
					# mdestroy
					if (tmp=e.read_note('mdestroy')) != nil
						attrs[16] += tmp
					end
					if (tmp=e.read_note('mdestroyr')) != nil
						attrs[17] += tmp
					end
					
					# atkspeed
					if (tmp=e.read_note('atkspeed')) != nil
						attrs[18] += tmp
					end
					if (tmp=e.read_note('atkspeedrate')) != nil
						attrs[19] += tmp
					end
					
					#eva
					if (tmp=e.read_note('eva')) != nil
						attrs[20] += tmp
					end
					if (tmp=e.read_note('evarate')) != nil
						attrs[21] += tmp
					end
					
					# bom
					if (tmp=e.read_note('bom')) != nil
						attrs[22] += tmp
					end
					if (tmp=e.read_note('bomrate')) != nil
						attrs[23] += tmp
					end
					if (tmp=e.read_note('bomatk')) != nil
						attrs[24] += tmp
					end
					
					#hit
					if (tmp=e.read_note('hit')) != nil
						attrs[25] += tmp
					end
					if (tmp=e.read_note('hitrate')) != nil
						attrs[26] += tmp
					end
					
					# hpcover
					if (tmp=e.read_note('hpcover')) != nil
						attrs[27] += tmp
					end
					if (tmp=e.read_note('hprate')) != nil
						attrs[28] += tmp
					end
					
					# mpcover
					if (tmp=e.read_note('mpcover')) != nil
						attrs[29] += tmp
					end
					if (tmp=e.read_note('mprate')) != nil 
						attrs[30] += tmp
					end
				end # end of e!=nil
			end  # end of for
		end # end of read_suit_all function
	end # end of class
end # end of module
