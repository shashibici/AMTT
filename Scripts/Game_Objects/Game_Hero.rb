#==============================================================================
# ■ Game_Hero
#------------------------------------------------------------------------------
# 　处理角色的类。本类在 Game_Actors 类 ($game_actors)
# 的内部使用、Game_Party 类请参考 ($game_party) 。
#==============================================================================

class Game_Hero < Game_Actor
  include GAME_CONF
  #--------------------------------------------------------------------------
  # ● 定义实例变量
  #    这些变量，应该在初始化的时候设置，因为英雄并不是很多，通常就一两个
  #--------------------------------------------------------------------------
  
  attr_accessor   :point          # 记录英雄可用的加点数
  attr_accessor   :trea_num       # 英雄可以使用几个宝物格子,在换装备时限制
  attr_accessor   :weapon_num     # 英雄可以使用几个武器，在换装备时限制
  

  #--------------------------------------------------------------------------
  # ● 初始化对象               重写
  #     actor_id : 角色 ID
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    super(actor_id)
    @last_skill_id = 0
  end
  
  #--------------------------------------------------------------------------
  # ● 设置                    重写
  #     actor_id : 角色 ID
  #--------------------------------------------------------------------------
  def setup(actor_id)
    
    # 获得角色对象
    actor = $data_actors[actor_id]
    # 设置角色id
    @actor_id = actor_id
    # 设置角色名字
    @name = actor.name
    # 设置角色位置名字（前锋等等）
    @character_name = actor.character_name
    # 设置角色位置编号
    @character_index = actor.character_index
    # 设置角色脸部名字
    @face_name = actor.face_name
    # 设置角色脸部索引
    @face_index = actor.face_index
    # 设置角色职业id
    @class_id = actor.class_id
    
    # 设置角色初始等级
    @level = actor.initial_level
    # 初始化角色经验表
    @exp_list = Array.new(1200)
    # 生成角色经验表
    make_exp_list
    # 由经验表获得当前经验
    @exp = @exp_list[@level]
    # 初始化技能列表
    @skills = []
    # 设置技能列表
    for i in self.class.learnings
      learn_skill(i.skill_id) if i.level <= @level
    end
    
#~     @my_skills = {
#~                   # skill_id = 1
#~                     1 => {
#~                         "level" => 1
#~                     },
#~                   # skill_id = 2
#~                     2 => {
#~                         "level" => 1
#~                     }
#~                   }
    
    
    #== 下面是Hero的初始化=============================
    
    # 这个数组在开始的时候会加载脚本中手动填写的一个角色配置表
    h = $data_heros[actor_id]
    
    # 填充各个属性
    @hmaxhp                = h[0]
    @hmaxmp                = h[1]
    @hatk                  = h[2]
    @hdef                  = h[3]
    @strength              = h[4]
    @celerity              = h[5]
    @wisdom                = h[6]
    @destroy               = h[7]
    @destroyrate           = h[8]
    @mdestroy              = h[9]
    @mdestroyrate          = h[10]
    @atkspeed              = h[11]
    @atkrate               = h[12]
    @eva                   = h[13]
    @evarate               = h[14]
    @bom                   = h[15]
    @bomrate               = h[16]
    @bomatk                = h[17]
    @hit                   = h[18]
    @hitrate               = h[19]
    @hpcover               = h[20]
    @hprate                = h[21]
    @mpcover               = h[22]
    @mprate                = h[23]
    @type                  = h[24]
    
    # 初始化装备属性
	# 装备增加最大生命
    @xhmaxhp                = 0
	# 装备增加最大魔法
    @xhmaxmp                = 0
	# 装备增加攻击
    @xhatk                  = 0
	# 装备增加防御
    @xhdef                  = 0
	# 装备增加力量
    @xstrength              = 0
	# 装备增加敏捷
    @xcelerity              = 0
	# 装备增加智力
    @xwisdom                = 0
	# 装备增加物理伤害
    @xdestroy               = 0
	# 装备增加物伤威力
    @xdestroyrate           = 0
	# 装备增加魔法伤害
    @xmdestroy              = 0
	# 装备增加魔伤威力
    @xmdestroyrate          = 0
	# 装备增加攻击速度
    @xatkspeed              = 0
	# 装备按比例增加攻击
    @xatkrate               = 0
	# 装备增加闪避技巧
    @xeva                   = 0
	# 装备按比例增加闪避
    @xevarate               = 0
	# 装备增加暴击技巧
    @xbom                   = 0
	# 装备按比例增加暴击技巧
    @xbomrate               = 0
	# 装备增加暴击威力
    @xbomatk                = 0
	# 装备增加命中
    @xhit                   = 0
	# 装备按比例增加命中
    @xhitrate               = 0
	# 装备增加生命恢复
    @xhpcover               = 0
	# 装备按比例生命恢复
    @xhprate                = 0
	# 装备增加魔法恢复
    @xmpcover               = 0
	# 装备按比例魔法恢复
    @xmprate                = 0
	# 装备按比例增加最大生命
	@xmaxhprate				= 0
	# 装备按比例增加最大魔法
	@xmaxmprate				= 0
	# 装备按比例增加攻击 - 影响平衡不推荐使用
	@xmaxatkrate			= 0
	# 装备按比例增加攻击 - 不推荐使用
	@xmaxdefrate			= 0
	# 装备按比例增加力量 - 不推荐使用
	@xmaxstrengthrate		= 0
	# 装备按比例增加敏捷 - 不推荐使用
	@xmaxcelerityrate		= 0
	# 装备按比例增加智力 - 不推荐使用
	@xmaxwisdomrate			= 0
	
	
    
    # 填充装备
    @weapon_num  = 1      	# 刚开始只能使用一把武器
    @trea_num    = 1      	# 刚开始只能使用1个宝物格子
    @class_id    = h[25]
    @weapon1_id  = h[26]
    @weapon2_id  = h[27]
    @armor1_id   = h[28]
    @armor2_id   = h[29]
    @armor3_id   = h[30]
    @armor4_id   = h[31]
    @armor5_id   = h[32]
    @armor6_id   = h[33]
    @armor7_id   = h[34]
    @armor8_id   = h[35]
    @armor9_id   = h[36]
    @armor10_id  = h[37]
    @armor11_id  = h[38]
    @armor12_id  = h[39]
    
    # 马上更新套装变化情况
    set_suits
    
    # 剩余变量初始化
    initOthers
    
    # 清除多余数值
    clear_extra_values
    
    # 初始化生命值等等
    recover_all
    
    # 初始化恢复速度
    recover_change
    
  end
  #--------------------------------------------------------------------------
  # ● 剩余变量初始化
  #
  #--------------------------------------------------------------------------
  def initOthers
    @fcounthp = @fcountmp = Graphics.frame_count
    @bomflag = false
    @hitflag = false
    @point = 20
    onEquipChanges(true)
  end
  
  #--------------------------------------------------------------------------
  # ● 剩余变量初始化
  #
  #    这里主要就是对装备产生的影响做了修改，每次更换装备都要调用此函数
  #
  #		flag 	: true - 有装备变更，找出变更装备并且修改属性，可以加速
  #				: false - 没有装备变更，仅仅是刷行属性，或者是其他原因
  #
  #---------------------------------------------------------------------------
  #    注意：
  #
  #    1、maxhp maxmp atk def strength celerity wisdom 这七个只有一个出口
  #       @xhmaxhp @xhmaxmp @xhatk @xhdef @xstrength @xcelerity @xwisdom
  #       这七个变量就直接代表了角色因为装备俄提升的相应的参数量
  #
  #    2、另一些的参 @xhpcover @xhprate @xmpcover @xmprate,
  #       例如@xhpcover @xhprate这两个是独立的，代表了相应参数
  #       因为分别因为两个原因所导致的数值的增加量。
  #       @xhpcover表示因直接指定而增加的值； @xhprate表示按比例增加的值
  #
  #    3、其余的参数 destroy mdestroy destroyrate mdestroyrate atkspeed
  #       atkrate eva evarate bom bomrate bomatk hit hitrate
  #       这13个参数，因子是可以显示出来的；比率则根据不同情况，或者是因子
  #       +基本值 之后乘以比率，或者是因子乘以比率之后 +基本值。
  #       所以这13个参数的最终值在使用的时候需要计算，不能直接得出。
  #
  #--------------------------------------------------------------------------
  def onEquipChanges(flag = false)
    
#~     p0 = p1 = p2 = p3 = p4 = p5 = p6 = p7 = p8 = p9 = p10 = p11 = p12 = 0
#~     p13 = p14 = p15 = p16 = p17 = p18 = p19 = p20 = p21 = p22 = p23 = 0
    
    # 0
    p0 = @xhmaxhp
    p1 = @xhmaxmp                
    p2 = @xhatk                  
    p3 = @xhdef                  
    
    # 4
    p4 = @xstrength              
    p5 = @xcelerity              
    p6 = @xwisdom                
    
    # 7
    p7 = @xdestroy               
    p8 = @xdestroyrate           
    p9 = @xmdestroy             
    p10 = @xmdestroyrate          
    p11 = @xatkspeed             
    
    #12
    p12 = @xatkrate               
    p13 = @xeva                   
    p14 = @xevarate               
    p15 = @xbom                   
    
    #16
    p16 = @xbomrate              
    p17 = @xbomatk                
    p18 = @xhit                  
    p19 = @xhitrate               
    
    #20
    p20 = @xhpcover               
    p21 = @xhprate                
    p22 = @xmpcover              
    p23 = @xmprate  
	
	# 按比例增加的变量
	p24 = @xmaxhprate
	p25 = @xmaxmprate
	p26 = @xmaxatkrate
	p27 = @xmaxdefrate
	p28 = @xmaxstrengthrate
	p29 = @xmaxcelerityrate
	p30 = @xmaxwisdomrate

    if true == flag
	  # 设置装备变更指示器
      @is_equip_changed = 1
	  # 获得更换装备之前的就装备（包括虚拟装备）
      old_equips = @myequip_kits.clone
	  # 考虑虚拟套装，因为失去虚拟套装也是需要改变属性的
      new_equips = self.equips(true).clone
      # 删除nil
      old_equips.delete(nil)
      new_equips.delete(nil)
      # 失去那些装备
      lose_equips = []
      # 新增那些装备
      gain_equips = []
      # 复制一份
      c_old = old_equips.clone
      c_new = new_equips.clone
      for e in old_equips
        # index 一定不是nil
        index = c_old.index(e)
        c_old.delete_at(index)
        index = c_new.index(e)
        # c_new中没有e 这个元素，或者e元素比c_old少
        if nil == index
          lose_equips.push(e)
        else
          c_new.delete_at(index)
        end
      end
      # 复制一份
      c_old = old_equips.clone
      c_new = new_equips.clone
      for e in new_equips
        # index 一定不是nil
        index = c_new.index(e)
        c_new.delete_at(index)
        index = c_old.index(e)
        # c_old中没有e 这个元素，或者e元素比c_new少
        if nil == index
          gain_equips.push(e)
        else
          c_old.delete_at(index)
        end
      end
      
      # 属性增多
      for e in gain_equips
        next if e == nil
        val = e.attrs
        p0 += val[0]
        p1 += val[2]
        p2 += val[4]
        p3 += val[6]
        p4 += val[8] 
        p5 += val[10] 
        p6 += val[12]
        p7 += val[14]
        p8 += val[15]
        p9 += val[16]
        p10 += val[17]
        p11 += val[18]
        p12 += val[19]
        p13 += val[20]
        p14 += val[21]
        p15 += val[22]
        p16 += val[23]
        p17 += val[24]
        p18 += val[25]
        p19 += val[26]
        p20 += val[27]
        p21 += val[28]
        p22 += val[29]
        p23 += val[30]
		# 按比例增长maxhp
        p24 += val[1]
		p25 += val[3]
		# 不推荐出按比例增长攻击的装备，影响平衡性
        p26 += val[5]
		# 不推荐出按比例增长防御的装备，影响平衡性
        p27 += val[7]
		# 不推荐出按比例增长力量的装备，影响平衡性
        p28 += val[9]
		# 不推荐出按比例增长力量的装备，影响平衡性
        p29 += val[11]
		# 不推荐出按比例增长智力的装备，影响平衡性
        p30 += val[13]
      end
      # 属性减少
      for e in lose_equips
        next if e == nil
        val = e.attrs
		# 一般而言val[0]、val[1]至少有一个为0
        p0 -= val[0]
        p1 -= val[2]
        p2 -= val[4]
        p3 -= val[6]
        p4 -= val[8]
        p5 -= val[10]
        p6 -= val[12]
        p7 -= val[14]
        p8 -= val[15]
        p9 -= val[16]
        p10 -= val[17]
        p11 -= val[18]
        p12 -= val[19]
        p13 -= val[20]
        p14 -= val[21]
        p15 -= val[22]
        p16 -= val[23]
        p17 -= val[24]
        p18 -= val[25]
        p19 -= val[26]
        p20 -= val[27]
        p21 -= val[28]
        p22 -= val[29]
        p23 -= val[30]
		# 按比例增长maxhp
        p24 -= val[1]
		p25 -= val[3]
		# 不推荐出按比例增长攻击的装备，影响平衡性
        p26 -= val[5]
		# 不推荐出按比例增长防御的装备，影响平衡性
        p27 -= val[7]
		# 不推荐出按比例增长力量的装备，影响平衡性
        p28 -= val[9]
		# 不推荐出按比例增长力量的装备，影响平衡性
        p29 -= val[11]
		# 不推荐出按比例增长智力的装备，影响平衡性
        p30 -= val[13]
      end
      
    # 并没有真正换装备，只需要重新计算装备的影响效果.
    # 目前只对maxhp有影响,如果对其他有影响，用到的时候再添加
    else
      # 重新计算p0、p24 其它值不变
      p0 = 0
	  p24 = 0
      for e in equips
        next if e == nil
        val = e.attrs
        p0 += val[0]
        p24 += val[1]
      end
    end
    
    # 0
    @xhmaxhp                = p0
    @xhmaxmp                = p1
    @xhatk                  = p2
    @xhdef                  = p3
    
    # 4
    @xstrength              = p4
    @xcelerity              = p5
    @xwisdom                = p6
    
    # 7
    @xdestroy               = p7
    @xdestroyrate           = p8
    @xmdestroy              = p9
    @xmdestroyrate          = p10
    @xatkspeed              = p11
    
    #12
    @xatkrate               = p12
    @xeva                   = p13
    @xevarate               = p14
    @xbom                   = p15
    
    #16
    @xbomrate               = p16
    @xbomatk                = p17
    @xhit                   = p18
    @xhitrate               = p19
    
    #20
    @xhpcover               = p20
    @xhprate                = p21
    @xmpcover               = p22
    @xmprate                = p23
    
	# 按比例增长的部分
	@xmaxhprate				= p24
	@xmaxmprate				= p25
	@xmaxatkrate			= p26
	@xmaxdefrate			= p27
	@xmaxstrengthrate		= p28
	@xmaxcelerityrate		= p29
	@xmaxwisdomrate			= p30
    # 换了装备之后更新恢复率
    recover_change
  end  
   
#===========================================================================
# ▼▼▼▼▼▼▼▼▼▼▼属性计算▼▼▼▼▼▼▼▼▼▼▼
#---------------------------------------------------------------------------

    
#============================================================================
#▼▼▼▼▼▼▼▼▼▼▼其他辅助函数▼▼▼▼▼▼▼▼▼▼▼
#---------------------------------------------------------------------------
  #--------------------------------------------------------------------------
  # ● 判断是否为英雄
  #--------------------------------------------------------------------------
  def hero?
    return true
  end
  #--------------------------------------------------------------------------
  # ● 获取英雄对象
  #
  #    注意：如果$game_heros[@actor_id]还没有这个角色，那么它会创建一个新的
  #          所以这个函数获得的总是一个新的hero
  # 
  #--------------------------------------------------------------------------
  def hero
    return $game_heros[@actor_id]
  end 
  #--------------------------------------------------------------------------
  # ● 获取武器对象列表
  #
  #      重写覆盖         如果id为0 代表没有装备相应内容，对应位置可能为nil
  #
  #--------------------------------------------------------------------------
  def weapons
    result = []
    result.push($data_weapons[@weapon1_id]) 
    result.push($data_weapons[@weapon2_id]) 
    return result
  end  
  #--------------------------------------------------------------------------
  # ● 获取防具对象列表
  #
  #    重写覆盖         如果id为0 代表没有装备相应内容，对应位置可能为nil
  #  
  #--------------------------------------------------------------------------
  def armors
    result = []
    result.push($data_armors[@armor1_id])  
    result.push($data_armors[@armor2_id]) 
    result.push($data_armors[@armor3_id])  
    result.push($data_armors[@armor4_id])  
    result.push($data_armors[@armor5_id])  
    result.push($data_armors[@armor6_id])  
    result.push($data_armors[@armor7_id])  
    result.push($data_armors[@armor8_id])  
    result.push($data_armors[@armor9_id])  
    result.push($data_armors[@armor10_id]) 
    result.push($data_armors[@armor11_id]) 
    result.push($data_armors[@armor12_id]) 
    return result
  end  
  #--------------------------------------------------------------------------
  # ● 计算经验值
  #
  #     v2.0版本修改
  #
  #--------------------------------------------------------------------------
  def make_exp_list
    
    # 用来临时存放怪物和英雄经验值
    monstor_exp_list = Array.new(1200)
    
    delta = 0
    monstormoney = 10
    monstorexp = 0
    heroexp1 = 0
    heroexp2 = 0
    heroexptotal = 0
    monstor_exp_list[2] = 50
    
    
    # 首先制作一个怪物经验表
    # 一共999级
    for i in 2..999 do      
      if i == 2
        delta = 10  
      else
        delta = (i-1)*80-80
      end
        # 第i级怪物金钱
        monstormoney += delta
        # 第i级怪物经验
        monstorexp = monstormoney * 5
        # 放入临时列表
        monstor_exp_list[i+1] = monstorexp      
    end    

    
    # 然后根据怪物经验生成英雄经验
    # 第一级需要累积经验0
    @exp_list[1] = 0
    for i in 2..999 do
      # 第i级积累的经验 = i-1级积累的经验 + i-1级升级需要的经验
      
      # 计算i-1级对应怪物的等级
      if (i-1)%2 == 0
        j = (i-1) / 2 + 1
        @exp_list[i] = @exp_list[i-1] + monstor_exp_list[j]*6
      else
        j = (i) / 2 + 1
        @exp_list[i] = @exp_list[i-1] + monstor_exp_list[j]*4
      end
      
    end

  end   
#============================================================================
#▼▼▼▼▼▼▼以下为Hero独有，Monstor没有▼▼▼▼▼▼▼▼▼▼▼▼▼▼
#----------------------------------------------------------------------------
  #--------------------------------------------------------------------------
  # ● 判断是否存活
  #
  #    直接返回当前角色hp是否>0
  #
  #--------------------------------------------------------------------------
  def isalive?
    return self.hp > 0
  end   
  #--------------------------------------------------------------------------
  # ● 游戏失败
  #     
  #     清理现场，丢失一点金钱，并且传送到第一层
  #
  #--------------------------------------------------------------------------
  def doGameOver
    
    # 如果可以复活
    if $game_switches[114] == true
      # 清理现场
      $game_switches[104] = true
      $game_switches[103] = false
      $game_switches[107] = false
      $game_switches[108] = false
      $game_switches[112] = false
      
      # 减少金钱-- 调试的时候不使用此功能
      $game_party.lose_gold(Integer($game_party.gold * 0.1))
      
      # 更新状态
      # 清除多余数值
      clear_extra_values
      # 初始化生命值等等
      recover_all
      # 初始化恢复速度
      recover_change      
      
      # 设置传送到第一层的相应变量
      tower = GAME_CONF::Tower_Layer[0]
      # 塔号
      $game_variables[41] = 0
      # 层号
      $game_variables[42] = 0
      # 当前层Map-ID号
      $game_variables[43] = tower[0]
      # 修改上楼、下楼事件id
      $game_variables[110] = GAME_CONF::Tower_Upstairs[$game_variables[41]][$game_variables[42]]
      $game_variables[111] = GAME_CONF::Tower_Downstairs[$game_variables[41]][$game_variables[42]]
      
      # 执行传送事件
      $game_temp.common_event_id = 15
      
      return
    end
    
    # 否则不能复活，直接gameover
    $scene = Scene_Gameover.new
  end
  #--------------------------------------------------------------------------
  # ● 更改装备 (指定 ID)
  #     equip_type : 装备部位 (1..12)
  #     item_id    : 武器 ID or 防具 ID
  #     test       : 测试标志 (战斗测试、以及装备画面的临时装备)
  #    准备给事件指令以及战斗测试使用。
  #
  #           重载覆盖----------以后改
  #
  #     Not used !!
  #
  #--------------------------------------------------------------------------
  def change_equip_by_id(equip_type, item_id, test = false)
    if equip_type == 0 or (equip_type == 1 and two_swords_style)
      change_equip(equip_type, $data_weapons[item_id], test)
    else
      change_equip(equip_type, $data_armors[item_id], test)
    end
  end
  #--------------------------------------------------------------------------
  # ● 更改装备 (指定对象)
  #     equip_type : 装备部位 (0..11)
  #     item       : 武器 or 防具 (nil 为解除装备)
  #     test       : 测试标志 (战斗测试、以及装备画面的临时装备)
  #
  #            重载覆盖
  #
  #       说明，其实换装备的本质就是跟换装备的号码！
  #
  #--------------------------------------------------------------------------
  def change_equip(equip_type, item, test = false)
    old_hp_rate = 1.0 * hp / maxhp
    old_mp_rate = 1.0 * mp / maxmp
    
    # 获得刚才装在身上的那件装备
    last_item = equips(false)[equip_type]
    
    # 如果真的要换装备，那么换下来的装备，应该存在队伍背包中
    # 同时换上去的物品应该重背包中失去
    if test == false
      return if $game_party.item_number(item) == 0 if item != nil
      $game_party.gain_item(last_item, 1)
      $game_party.lose_item(item, 1)
    end
    
    # 如果给进来的物品为空，那么item_id = 0
    item_id = item == nil ? 0 : item.id
    
    case equip_type
    when 0  # 武器1
      @weapon1_id = item_id
    when 1  # 武器2
      @weapon2_id = item_id
    when 2  # 头
      @armor1_id = item_id
    when 3  # 项链
      @armor2_id = item_id
    when 4  # 盾
      @armor3_id = item_id
    when 5  # 衣服
      @armor4_id = item_id
    when 6  # 戒指
      @armor5_id = item_id
    when 7  # 鞋子
      @armor6_id = item_id
    when 8  # 宝物1
      @armor7_id = item_id
    when 9  # 宝物2
      @armor8_id = item_id
    when 10  # 宝物3
      @armor9_id = item_id
    when 11  # 宝物4
      @armor10_id = item_id
    when 12  # 宝物5
      @armor11_id = item_id
    when 13  # 宝物6
      @armor12_id = item_id
    end
    
    # 更新套装
    set_suits
    # 更新属性
    onEquipChanges(true)
    # 更新maxhp maxmp
    self.hp = maxhp * old_hp_rate
    self.mp = maxmp * old_mp_rate
    
  end
  #--------------------------------------------------------------------------
  # ● 废弃装备
  #     item : 废弃的武器 or 防具
  #    武器/防具的增减使用"包含装备品"。
  #
  #         重载覆盖————以后改,暂时没有用
  #
  #--------------------------------------------------------------------------
  def discard_equip(item)
    if item.is_a?(RPG::Weapon)
      if @weapon_id == item.id
        @weapon_id = 0
      elsif two_swords_style and @armor1_id == item.id
        @armor1_id = 0
      end
    elsif item.is_a?(RPG::Armor)
      if not two_swords_style and @armor1_id == item.id
        @armor1_id = 0
      elsif @armor2_id == item.id
        @armor2_id = 0
      elsif @armor3_id == item.id
        @armor3_id = 0
      elsif @armor4_id == item.id
        @armor4_id = 0
      end
    end
  end   
  #--------------------------------------------------------------------------
  # ● 判断是否可以装备
  #     item : 物品
  #
  #        重定义---------暂时所有的装备都能装
  #
  #--------------------------------------------------------------------------
  def equippable?(item)
    return true
  end
  #--------------------------------------------------------------------------
  # ● 更改经验值
  #     exp  : 新的经验值
  #     show : 显示升级标志
  #
  #            重定义
  #
  #--------------------------------------------------------------------------
  def change_exp(exp, show)
    @exp = [[exp, 99999999].min, 0].max
    # 升级
    while @exp >= @exp_list[@level+1] and @exp_list[@level+1] > 0
      level_up
    end
    # 降级
    while @exp < @exp_list[@level]
      level_down
    end
    # 修改hp mp
    @hp = [@hp, maxhp].min
    @mp = [@mp, maxmp].min
  end
  #--------------------------------------------------------------------------
  # ● 降级
  #
  #          重定义
  #
  #--------------------------------------------------------------------------
  def level_down
    @level -= 1
  end  
  #--------------------------------------------------------------------------
  # ● 获得经验值 
  #     exp  : 经验值增加量
  #     show : 显示升级标志
  #
  #     如果要实现经验翻倍功能，那么后期可以添加一个经验扩张属性
  #
  #        重载覆盖
  #
  #--------------------------------------------------------------------------
  def gain_exp(exp, show)
    change_exp(@exp + exp, show)
  end
  #--------------------------------------------------------------------------
  # ● 更改等级
  #     level : 新等级
  #     show  : 显示升级标志
  #
  #        重载覆盖
  #
  #--------------------------------------------------------------------------
  def change_level(level, show)
    level = [[level, 999].min, 1].max
    change_exp(@exp_list[level], show)
  end
  #--------------------------------------------------------------------------
  # ● 觉醒了新的特技
  #     skill_id : 特技 ID
  #
  #        重载覆盖
  #
  #      该函数不在升级时调用，而是在使用物品时调用，技能要用物品来学
  #
  #--------------------------------------------------------------------------
  def learn_skill(skill_id)
    unless skill_learn?($data_skills[skill_id])
      @skills.push(skill_id)
      @skills.sort!
    end
  end
  #--------------------------------------------------------------------------
  # ● 忘记特技
  #     skill_id : 特技 ID
  #
  #        重载覆盖
  #
  #--------------------------------------------------------------------------
  def forget_skill(skill_id)
    @skills.delete(skill_id)
  end  
end