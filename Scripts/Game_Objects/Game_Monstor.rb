=begin

这是怪物类，该类继承于Game_Actor，开始的时候，会生成一个空的actor。
然后拿着这个壳进行数据填充，把数据库中enemy的数值填入其中。

如此设计是为了能够使游戏内部的对象统一，最后能够调用一个战斗函数实现战斗。

=end


#==============================================================================
# ■ Game_Monstor
#------------------------------------------------------------------------------
# 　处理敌人的类。本类在 Game_Troop 类 ($game_troop) 的
# 内部使用。
#==============================================================================
class Game_Monstor < Game_Actor
  include GAME_CONF
  #--------------------------------------------------------------------------
  # ● 定义实例变量
  #    这些变量，应该在初始化的时候设置，因为英雄并不是很多，通常就一两个
  #--------------------------------------------------------------------------
  attr_accessor   :intension      # 怪物的强度比例
  attr_accessor   :real_hpcover   # 记录英雄每秒回血
  attr_accessor   :real_mpcover   # 记录英雄每秒回魔  
  attr_accessor   :type           # 英雄的主属性
  attr_accessor   :money          # 怪物的钱
  attr_accessor   :monstor_exp    # 怪物的经验
  attr_accessor   :thing1         # 第一样物品
  attr_accessor   :thing2         # 第二样物品
  attr_accessor   :thingrate1     # 分母
  attr_accessor   :thingrate2     # 分母
  attr_accessor   :weapon1_id
  
  
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
  
  #--------------------------------------------------------------------------
  # ● 初始化对象               重写
  #     monstor_id : 怪物 ID
  #--------------------------------------------------------------------------
  def initialize(monstor_id)
    super(monstor_id) 
    
  end
  
  #--------------------------------------------------------------------------
  # ● 设置                    重写
  #     monstor_id : 怪物 ID
  #--------------------------------------------------------------------------
  def setup(monstor_id)
    
    #===========================================================
    #       下面是Monstor的预设置                                
    #===========================================================
    # 获得怪物对象
    monstor = $data_enemies[monstor_id]
    # 设置怪物初始等级
    @level = monstor.read_note('lv')
    @level = @level == nil ? 2 : @level
    # 设置怪物主属性
    @type = monstor.read_note('type') != nil ? monstor.read_note('type') : 1
 
    # 初始化技能列表
    @skills = []
    # 设置技能列表
    #  ………………………………
    
    #===========================================================
    #       下面是Monstor的设置                               
    #===========================================================
    # 杂项设置--------------------------------------------
    # 怪物名字
    @name                  =  monstor.name
    # 怪物战斗图
    @character_name        =  monstor.battler_name
    
    # 设置正常金钱、经验
    @money = get_money
    @monstor_exp = @money * 5
    # 金钱扩展
    # @money *= @level ** 1.21
    # @money /= 12.0
    # @money = (@money+ 6*(@level**2.2)).round
	@money *= @level ** 1.03
    @money /= 12.0
    @money = (@money+ 13*(@level**1.3)).round
    
    
    # 设置扩张金钱、经验
    @money          +=  $game_variables[90]
    @monstor_exp    +=  $game_variables[91]
    
    # 没有使用
    @thing1                =  monstor.drop_item1
    @thing2                =  monstor.drop_item2
    @thingrate1            =  @thing1.denominator 
    @thingrate2            =  @thing2.denominator 
    
  
    # 属性设置---------------------------------------------
    # 自动计算属性
    makeattrbutes
    
    
    # 补充附加属性
    @hmaxhp                += monstor.read_note('maxhp') == nil ? 0 : monstor.read_note('maxhp')
    @hmaxmp                += monstor.read_note('maxmp') == nil ? 0 : monstor.read_note('maxmp')
    @hatk                  += monstor.read_note('atk') == nil ? 0 : monstor.read_note('atk')
    @hdef                  += monstor.read_note('ddef') == nil ? 0 : monstor.read_note('ddef')
    @strength              += monstor.read_note('strength') == nil ? 0 : monstor.read_note('strength')
    @celerity              += monstor.read_note('celerity') == nil ? 0 : monstor.read_note('celerity')
    @wisdom                += monstor.read_note('wisdom') == nil ? 0 : monstor.read_note('wisdom')
    @destroy               += monstor.read_note('destroy') == nil ? 0 : monstor.read_note('destroy')
    @destroyrate           += monstor.read_note('destroyr') == nil ? 0 : monstor.read_note('destroyr')
    @mdestroy              += monstor.read_note('mdestroy') == nil ? 0 : monstor.read_note('mdestroy')
    @mdestroyrate          += monstor.read_note('mdestroyr') == nil ? 0 : monstor.read_note('mdestroyr')
    @atkspeed              += monstor.read_note('atkspeed') == nil ? 0 : monstor.read_note('atkspeed')
    @atkrate               += monstor.read_note('atkspeedrate') == nil ? 0 : monstor.read_note('atkspeedrate')
    @eva                   += monstor.read_note('eva') == nil ? 0 : monstor.read_note('eva')
    @evarate               += monstor.read_note('evarate') == nil ? 0 : monstor.read_note('evarate')
    @bom                   += monstor.read_note('bom') == nil ? 0 : monstor.read_note('bom')
    @bomrate               += monstor.read_note('bomrate') == nil ? 0 : monstor.read_note('bomrate')
    @bomatk                += monstor.read_note('bomatk') == nil ? 0 : monstor.read_note('bomatk')
    @hit                   += monstor.read_note('hit') == nil ? 0 : monstor.read_note('hit')
    @hitrate               += monstor.read_note('hitrate') == nil ? 0 : monstor.read_note('hitrate')
    @hpcover               += monstor.read_note('hpcover') == nil ? 0 : monstor.read_note('hpcover')
    @hprate                += monstor.read_note('hprate') == nil ? 0 : monstor.read_note('hprate')
    @mpcover               += monstor.read_note('mpcover') == nil ? 0 : monstor.read_note('mpcover')
    @mprate                += monstor.read_note('mprate') == nil ? 0 : monstor.read_note('mprate')
    
    # 应用强度扩张
    if $game_variables[92] == 0 or $game_variables[92] == 1000
      # 不做任何事
    else
      # 进行扩张
      doAttrExtesion
    end
    
    
    
    # 装备设置---------------------------------------------
    # 填充装备
    @class_id    = monstor.read_note('class_id') != nil ? monstor.read_note('class_id') : 1
    @weapon1_id  = $game_variables[46]
    @weapon2_id  = $game_variables[47]
    @armor1_id   = $game_variables[48]
    @armor2_id   = $game_variables[49]
    @armor3_id   = $game_variables[50]
    @armor4_id   = $game_variables[51]
    @armor5_id   = $game_variables[52]
    @armor6_id   = $game_variables[53]
    @armor7_id   = $game_variables[54]
    @armor8_id   = $game_variables[55]
    @armor9_id   = $game_variables[56]
    @armor10_id  = $game_variables[57]
    @armor11_id  = $game_variables[158]
    @armor12_id  = $game_variables[159]
    

    #===========================================================
    #       下面是Monstor的初始化                                
    #===========================================================
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
  # ● 生成属性值
  #
  #--------------------------------------------------------------------------
  def makeattrbutes
    x = @level


    @evarate               = @level**([1.2, ((x-1)*0.01)+1.0].min) * 1.85
    @bom                   = 0
    @bomrate               = 0
    @bomatk                = 100 + @level**([1.2, ((x-1)*0.01)+1.0].min) * 2.15
    @hitrate               = 0
    @hprate                = 0
    @mprate                = 0
    #-----------------------
    # 设置hp
    #------------------------
    delta = 0
    n = 400
    for i in 2..x do
      delta = 200 + ((i-1)**([1.2, ((i-1)*0.01)+1.0].min) * 50)
      n += delta
    end
    @hmaxhp = n
    #-----------------------
    # 设置mp
    #------------------------
    delta = 0
    n = 350
    for i in 2..x do
      delta = 200 + ((i-1)**([1.2, ((i-1)*0.01)+1.0].min) * 55)
      n += delta
    end
    @hmaxmp = n
      
    #-----------------------
    # 设置atk
    #------------------------
    delta = 16
    n = 0
    for i in 2..x do
      delta = 15 + (1+(i-2)**([1.2, ((i-1)*0.01)+1.0].min)*2.0)
      n += delta
    end
    @hatk = n
    #-----------------------
    # 设置def
    #------------------------
    @hdef = @hatk / 2.0
    #-----------------------
    # 设置力量 智力 敏捷 (基本符合)
    #------------------------
    delta = 0
    n = 10
    for i in 2..x do
      delta = 16 + (1+0.5*(i-2)**([1.2, ((i-1)*0.01)+1.0].min))
      n += delta
    end
    
    @strength = n
    @celerity = n
    @wisdom = n
    
    #-----------------------
    # 设置恢复
    #------------------------
    @hpcover = 1.8 * x**([1.2, ((x-1)*0.01)+1.0].min)
    @mpcover = 1.8 * x**([1.2, ((x-1)*0.01)+1.0].min)
    
    #-----------------------
    # 设置物理伤害 魔法伤害
    #------------------------
    @destroy = 3.2 * x**([1.2, ((x-1)*0.01)+1.0].min)
    @mdestroy = 3.2 * x**([1.2, ((x-1)*0.01)+1.0].min)
    
    #-----------------------
    # 设置攻速 命中 闪避 
    #------------------------
    @atkspeed = 3 * x**([1.2, ((x-1)*0.01)+1.0].min)
    @hit = 4.8 * x**([1.2, ((x-1)*0.01)+1.0].min)
    @eva = 3 * x**([1.2, ((x-1)*0.01)+1.0].min)
    
    case @type
    when 1  # 力量
      @strength *= 1.5
      @celerity *= 1.2
      @wisdom   *= 1.2
      @hmaxhp *= 1.75
      @destroy *= 1.1
      @hpcover *= 1.5
    when 2  # 敏捷
      @strength *= 1.2
      @celerity *= 1.5 
      @wisdom   *= 1.2
      @hdef *= 1.75
      @atkspeed *= 1.25
      @hit *= 1.25
    when 3  # 智力
      @strength *= 1.2
      @celerity *= 1.2
      @wisdom *= 1.5
      @bom *= 1.75
      @mdestroy *= 1.25
      @hmaxmp *= 1.25
    end
    
    case @type
    when 1   # 力量
      @destroyrate           = 100 + @level * 2.85
      @mdestroyrate          = 100 + @level * 1.25
      @atkrate               = 100 + @level * 1.45
    when 2   # 敏捷
      @destroyrate           = 100 + @level * 1.35
      @mdestroyrate          = 100 + @level * 1.25
      @atkrate               = 100 + @level * 2.95
    when 3   # 智力
      @destroyrate           = 100 + @level * 1.25
      @mdestroyrate          = 100 + @level * 2.75
      @atkrate               = 100 + @level * 1.45
    end    
    
    
  end  
  
  #--------------------------------------------------------------------------
  # ● 对属性进行扩张
  #
  #--------------------------------------------------------------------------
  def doAttrExtesion
    
    @money                 *=  $game_variables[92] / 1000.0
    @monstor_exp           *=  $game_variables[92] / 1000.0
    @money                 =   Integer(@money)
    @monstor_exp           =   Integer(@monstor_exp)
    
    
    @hmaxhp                *= $game_variables[92] / 1000.0
    @hmaxmp                *= $game_variables[92] / 1000.0
    @hatk                  *= $game_variables[92] / 1000.0
    @hdef                  *= $game_variables[92] / 1000.0
    @strength              *= $game_variables[92] / 1000.0
    @celerity              *= $game_variables[92] / 1000.0
    @wisdom                *= $game_variables[92] / 1000.0
    @destroyrate           *= $game_variables[92] / 1000.0
    @destroy               *= $game_variables[92] / 1000.0
    @mdestroyrate          *= $game_variables[92] / 1000.0
    @mdestroy              *= $game_variables[92] / 1000.0
    
    @atkspeed              *= $game_variables[92] / 1000.0
    @atkrate               *= $game_variables[92] / 1000.0
    @eva                   *= $game_variables[92] / 1000.0
    
    # 暴击技巧不受影响
#~     @bom                   *= $game_variables[92] / 1000.0
    
    # 暴击倍率不受影响
#~     @bomatk                *= $game_variables[92] / 1000.0
    @hit                   *= $game_variables[92] / 1000.0
    
    @hpcover               *= $game_variables[92] / 1000.0
    @hprate                *= $game_variables[92] / 1000.0
    @mpcover               *= $game_variables[92] / 1000.0
    @mprate                *= $game_variables[92] / 1000.0
    
  end
  
  #--------------------------------------------------------------------------
  # ● 剩余变量初始化
  #
  #--------------------------------------------------------------------------
  def initOthers
    @fcounthp = @fcountmp = Graphics.frame_count
    @bomflag = false
    @hitflag = false
    # 装备效果
    onEquipChanges
  end  
  #--------------------------------------------------------------------------
  # ● 剩余变量初始化
  #
  #    这里主要就是对装备产生的影响做了修改，每次更换装备都要调用此函数
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
  def onEquipChanges
    p0 = p1 = p2 = p3 = p4 = p5 = p6 = p7 = p8 = p9 = p10 = p11 = p12 = 0
    p13 = p14 = p15 = p16 = p17 = p18 = p19 = p20 = p21 = p22 = p23 = 0
    
    for e in equips do
      next if e == nil
      ## maxhp
      if e.read_note('maxhp') != nil
        p0 += e.read_note('maxhp')
      end
      if e.read_note('maxhprate') != nil
        p0 += e.read_note('maxhprate') * self_maxhp / 100.0
      end
      
      ### maxmp
      if e.read_note('maxmp') != nil
        p1 += e.read_note('maxmp')
      end      
      if e.read_note('maxmprate') != nil
        p1 += e.read_note('maxmprate') * self_maxmp / 100.0
      end
      
      ### atk
      if e.read_note('atk') != nil
        p2 += e.read_note('atk')
      end         
      if e.read_note('atkrate') != nil
        p2 += e.read_note('atkrate') * self_atk / 100.0
      end
      
      # def
      p3 += e.read_note('ddef') if e.read_note('ddef') != nil
      p3 += e.read_note('defrate') * self_def / 100.0 if e.read_note('defrate') != nil
      
      # strength
      p4 += e.read_note('strength') if e.read_note('strength') != nil
      p4 += e.read_note('strengthrate') * self_strength / 100.0 if e.read_note('strengthrate') != nil
      
      # celerity
      p5 += e.read_note('celerity') if e.read_note('celerity') != nil
      p5 += e.read_note('celerityrate') * self_celerity / 100.0 if e.read_note('celerityrate') != nil

      # wisdom
      p6 += e.read_note('wisdom') if e.read_note('wisdom') != nil
      p6 += e.read_note('wisdomrate') * self_wisdom / 100.0 if e.read_note('wisdomrate') != nil      
      
      # destroy
      p7 += e.read_note('destroy') if e.read_note('destroy') != nil
      p8 += e.read_note('destroyr') if e.read_note('destroyr') != nil
      
      # mdestroy
      p9 += e.read_note('mdestroy') if e.read_note('mdestroy') != nil
      p10 += e.read_note('mdestroyr') if e.read_note('mdestroyr') != nil
      
      # atkspeed
      p11 += e.read_note('atkspeed') if e.read_note('atkspeed') != nil
      p12 += e.read_note('atkspeedrate') if e.read_note('atkspeedrate') != nil
      
      #eva
      p13 += e.read_note('eva') if e.read_note('eva') != nil
      p14 += e.read_note('evarate') if e.read_note('evarate') != nil
      
      # bom
      p15 += e.read_note('bom') if e.read_note('bom') != nil
      p16 += e.read_note('bomrate') if e.read_note('bomrate') != nil
      p17 += e.read_note('bomatk') if e.read_note('bomatk') != nil
      
      #hit
	    p18 += e.read_note('hit') if e.read_note('hit') != nil
      p19 += e.read_note('hitrate') if e.read_note('hitrate') != nil
	  
      # hpcover
	    p20 += e.read_note('hpcover') if e.read_note('hpcover') != nil
      p21 += e.read_note('hprate') if e.read_note('hprate') != nil
	  
      # mpcover
	    p22 += e.read_note('mpcover') if e.read_note('mpcover') != nil
      p23 += e.read_note('mprate') if e.read_note('mprate') != nil
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
    return false
  end
  #--------------------------------------------------------------------------
  # ● 获取英雄对象
  #
  #    注意：如果$game_heros[@actor_id]还没有这个角色，那么它会创建一个新的
  #          所以这个函数获得的总是一个新的hero
  # 
  #--------------------------------------------------------------------------
  def monstor
    return $game_monstors[@actor_id]
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
  # ● 生成金钱
  #
  #    V2.0修改，为杀掉怪物掉落的金钱
  #
  #
  #    先沿用原来的，有空再重写
  #
  #--------------------------------------------------------------------------
  def get_money

    delta = 0
    n = 10
    for i in 2..@level do
      if i == 2
        delta = 10
      else
        delta = (i-1)*80-85
      end
      n += delta
    end
    
    return n
    
  end   
#============================================================================
#▼▼▼▼▼▼▼以下为Monstor独有，Hero没有▼▼▼▼▼▼▼▼▼▼▼▼▼▼
#----------------------------------------------------------------------------
  #--------------------------------------------------------------------------
  # ● 战斗胜利
  #     
  #     首先切换场景
  #     然后才是各种奖励
  #
  #     flag    :身份标识
  #     0本体， 1分身1， 2分身2， 3分身3
  #
  #--------------------------------------------------------------------------
  def doVictory(flag = 0)
    # 如果分身死了(目前只支持分身1，如果需要分身2则今后继续添加)
    if flag == 1
      # 开启“分身1是否结束”
      $game_switches[121] = true
      # 分身数据清除
      $game_switches[119] = false
      $game_switches[120] = false
      $game_variables[116] = 0
      $game_variables[117] = 0
      $game_variables[118] = 0
      $game_variables[119] = 0
      # 不会获得奖励
      return
    elsif flag == 2
      # 开启“分身2是否结束”
      $game_switches[124] = true
      # 分身数据清除
      $game_switches[122] = false
      $game_switches[123] = false
      $game_variables[120] = 0
      $game_variables[121] = 0
      $game_variables[122] = 0
      $game_variables[123] = 0
      # 不会获得奖励
      return      
    end
    
    
     # 否则执行真正的胜利
    
     # 初始化系统变量
     $game_vict_equips = []
    
     # 首先切换场景，本质是修改变量
     # 通过修改开关的值，达到控制事件的目的
     $game_switches[104] = true
     
     # 将被打败的事件添加到$monstor_switches里面
     if $monstor_switches[$game_variables[43]] == nil
       $monstor_switches[$game_variables[43]] = {}
     end
     map = $monstor_switches[$game_variables[43]]
     
     # 将怪物放入
     map[$game_variables[37]] = [] 
     
# 默认分身不会自己死掉！！！     
=begin
     # 分身1放入
     p "113变量"
     p $game_variables[113]
     map[$game_variables[116]] = [] if $game_variables[113] != 0
     # 分身2放入
     map[$game_variables[117]] = [] if $game_variables[113] != 0 
     # 分身3放入
     map[$game_variables[118]] = [] if $game_variables[113] != 0
=end     
     $game_map.refresh
     
    
     # 生成经验——留作扩展
     
     # 生成金钱——留作扩展
     
     # 生成掉落物品——留作扩展
     
     # 队伍获得经验、金钱、掉落物品
     
     # 获得物品
     for i in 59..68 do
        # 如果掉落类型为空，则跳过
        next if (k = $game_variables[i]) == 0
        
        # 否则掉落类型不为空
        case k
        # 物品
        when 1
          # 如果id不为0
          if (j = $game_variables[i+10]) != 0
            # 如果掉宝
            if rand($game_variables[i+20]) == 0 
              $game_party.gain_item($data_items[j], 1)
              $game_vict_equips.push($data_items[j].name)
            end
          end
          
        # 武器
        when 2
          # 如果id不为0
          if (j = $game_variables[i+10]) != 0
            # 如果掉宝
            if rand($game_variables[i+20]) == 0 
              $game_party.gain_item($data_weapons[j], 1)
              $game_vict_equips.push($data_weapons[j].name)
            end
          end          
          
        # 防具
        when 3
          # 如果id不为0
          if (j = $game_variables[i+10]) != 0
            # 如果掉宝
            if rand($game_variables[i+20]) == 0 
              $game_party.gain_item($data_armors[j], 1)
              $game_vict_equips.push($data_armors[j].name)
            end
          end          
        end
     end
     
     # 获得金钱
     $game_party.gain_gold(self.money) 
     $game_variables[90] = self.money
     
     # 获得经验
     $game_party.active.gain_exp(self.monstor_exp,false)
     
     
     $game_temp.common_event_id = 21
   
  end
  #--------------------------------------------------------------------------
  # ● 
  #
  #     
  #
  #--------------------------------------------------------------------------
  
  
  

  
end