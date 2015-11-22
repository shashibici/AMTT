#==============================================================================
# ■ Game_Battler
#------------------------------------------------------------------------------
# 　处理战斗者的类。这个类作为 Game_Actor 类与 Game_Enemy 类的
# 超级类来使用。
#
#  这个类被重写，添加了新的函数，用来执行战斗功能主要添加的函数有：
#   preattack—— 准备攻击
#   doattack——  攻击
#   predamage—— 准备伤害
#   dodamage —— 执行伤害
#
#
#  另外重写了其他的属性获取
#
#==============================================================================

class Game_Battler
  include GAME_CONF
  
  attr_accessor   :bomflag           # 是否暴击
  attr_accessor   :hitflag           # 是否命中 
  attr_accessor   :maxhp_plus
  attr_accessor   :maxmp_plus
  attr_accessor   :fcounthp          # 记录帧数，计算恢复HP
  attr_accessor   :fcountmp          # 记录帧数，计算恢复MP
  
  #=========================================================================
  #  self 系列的参数，是自身条件产生的，没有依靠任何装备
  #
  #=========================================================================
  #--------------------------------------------------------------------------
  # ● 获得自身maxhp
  #--------------------------------------------------------------------------
  def self_maxhp
    n = @hmaxhp
    n += @strength * GAME_CONF::BONUS_STRENGTH_MAXHP
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获得自身maxmp
  #--------------------------------------------------------------------------
  def self_maxmp
    n = @hmaxmp
    n += @wisdom * GAME_CONF::BONUS_WISDOM_MAXMP
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获得自身atk
  #--------------------------------------------------------------------------
  def self_atk
    n = @hatk
    # 主属性加成
    case @type
    when 1    # 力量
      n += @strength * GAME_CONF::BONUS_STRENGTH_ATTACK
    when 2    # 敏捷
      n += @celerity * GAME_CONF::BONUS_CELERITY_ATTACK
    when 3    # 智力
      n += @wisdom * GAME_CONF::BONUS_WISDOM_ATTACK
    end
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获得自身def
  #
  #    防御+敏捷奖励
  #
  #--------------------------------------------------------------------------
  def self_def
    n = @hdef
    # 每一点敏捷增加0.33点防御力
    n += @celerity * GAME_CONF::BONUS_CELERITY_DEF
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获得自身力量
  #
  #      力量
  #
  #--------------------------------------------------------------------------
  def self_strength
    n = @strength
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获得自身敏捷
  #
  #      敏捷
  #
  #--------------------------------------------------------------------------
  def self_celerity
    n = @celerity
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获得自身智力
  #
  #      智力
  #
  #--------------------------------------------------------------------------
  def self_wisdom
    n = @wisdom
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获得自身物理破坏因子
  #
  #      物理伤害+系统初始值
  #
  #--------------------------------------------------------------------------
  def self_destroy
    n = @destroy + GAME_CONF::CONST_BASE_DESTROY
    n += self_strength * BONUS_STRENGTH_DESTROY
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获得自身魔法破坏因子
  #
  #       魔法伤害+系统初始值
  #
  #--------------------------------------------------------------------------
  def self_mdestroy
    n = @mdestroy + GAME_CONF::CONST_BASE_MDESTROY
    n += self_wisdom * BONUS_WISDOM_MDESTROY
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获得自身攻速因子
  #
  #       攻速因子+系统初始值+敏捷奖励
  #
  #--------------------------------------------------------------------------
  def self_atkspeed
    n = @atkspeed
    n += self_celerity * GAME_CONF::BONUS_CELERITY_ATKSPEED
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获得自身闪避因子
  #
  #    闪避因子+扩张率
  #
  #--------------------------------------------------------------------------
  def self_eva
    n = (@eva + self_celerity * BONUS_CELERITY_EVA) * (1 + @evarate/100.0)
    return n
  end
  #--------------------------------------------------------------------------
  # ● 获得自身命中因子
  #
  #    命中因子+扩张率
  #
  #--------------------------------------------------------------------------
  def self_hit
    n = (@hit + self_celerity * BONUS_CELERITY_HIT) * (1 + @hitrate/100.0)
    return n
  end
  #--------------------------------------------------------------------------
  # ● 获得自身暴击因子
  #
  #        暴击因子+扩张率
  #
  #--------------------------------------------------------------------------
  def self_bom
    n = (@bom + self_strength * BONUS_STRENGTH_BOM) * (1 + @bomrate/100.0)
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获得自身暴击威力
  #
  #        暴击威力  
  #
  #--------------------------------------------------------------------------
  def self_bomatk
    n = @bomatk
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获得自身生命恢复
  #
  #      生命恢复+力量奖励+生命百分比恢复
  #
  #--------------------------------------------------------------------------
  def self_hpcover
    n = @hpcover
    n += self_strength * GAME_CONF::BONUS_STRENGTH_HPCOVER
    n += self_maxhp * @hprate / 100.0
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获得自身魔法恢复
  #
  #    魔法恢复+智力奖励+魔法百分比恢复
  #
  #--------------------------------------------------------------------------
  def self_mpcover
    n = @mpcover
    n += self_wisdom * GAME_CONF::BONUS_WISDOM_MPCOVER
    n += self_maxmp * @mprate / 100.0
    return n
  end  
  
  #=========================================================================
  #  base 系列的参数，有了装备之后的参数，不考虑技能、实战的影响。
  #
  #=========================================================================  
  #--------------------------------------------------------------------------
  # ● 获取基本 MaxHP
  #
  #     重写覆盖
  #     基本maxhp = ((自身maxhp+属性加成) + 武器加成 + 额外属性加成)+类型加成
  #     自身maxhp    :@hmaxhp
  #     属性加成     :@strength 所带来的加成（例如每个力量加4血）
  #     武器加成     :@xhmaxhp
  #     额外属性加成 :@xstrength 所带来的加成
  #     类型加成     :例如力量型英雄，生命值会再次加成
  #
  #     其实最后到battler类中还有一个状态加成，例如“攻击力上升”状态
  #--------------------------------------------------------------------------
  def base_maxhp
    # n初始为自身maxhp
    n = self_maxhp
    # 装备加成
    n += @xhmaxhp
    # 额外属性加成
    n += @xstrength * BONUS_STRENGTH_MAXHP
    
    # 类型加成 -- 暂时不实现
    return n
  end
  #--------------------------------------------------------------------------
  # ● 获取基本 MaxMP
  #
  #    重写覆盖
  #
  #--------------------------------------------------------------------------
  def base_maxmp
    # n初始为自身maxhp
    n = self_maxmp
    # 装备加成
    n += @xhmaxmp
    # 额外属性加成
    n += @xwisdom * BONUS_WISDOM_MAXMP

    # 类型加成 -- 暂时不实现
    
    return n
  end
    
  #--------------------------------------------------------------------------
  # ● 获取基本攻击力
  # 
  #     重写覆盖 
  #
  #--------------------------------------------------------------------------
  def base_atk
    # n初始为自身hatk
    n = self_atk
    # 装备加成
    n += @xhatk
    
    # 额外属性加成
    case type
    when 1    # 力量
      n += @xstrength * GAME_CONF::BONUS_STRENGTH_ATTACK
    when 2    # 敏捷
      n += @xcelerity * GAME_CONF::BONUS_CELERITY_ATTACK
    when 3    # 智力
      n += @xwisdom * GAME_CONF::BONUS_WISDOM_ATTACK
    end
    
    # 类型加成 -- 暂时不实现
    
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获取基本防御力
  #
  #    重写覆盖
  #
  #--------------------------------------------------------------------------
  def base_def
    # n初始为自身hatk
    n = self_def
    # 每一件装备增加的防御力
    n += @xhdef
    # 额外属性加成
    n += @xcelerity * GAME_CONF::BONUS_CELERITY_DEF

    # 类型加成 -- 暂时不实现
    
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获取基本力量
  #
  #     新加
  #
  #--------------------------------------------------------------------------
  def base_strength
    n = self_strength
    n += @xstrength
    return n
  end  
  
  #--------------------------------------------------------------------------
  # ● 获取基本智力
  #
  #     新加
  #
  #--------------------------------------------------------------------------
  def base_wisdom
    n = self_wisdom
    n += @xwisdom
    return n
  end  
  
  #--------------------------------------------------------------------------
  # ● 获取基本敏捷
  #
  #     新加
  #
  #--------------------------------------------------------------------------
  def base_celerity
    n = self_celerity
    n += @xcelerity
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获取基本物理伤害
  #
  #     新加
  #
  #--------------------------------------------------------------------------
  def base_destroy
    n = self_destroy + @xdestroy
    # 额外属性加成
    n += @xstrength * BONUS_STRENGTH_DESTROY
    return n
  end  
  
  
  #--------------------------------------------------------------------------
  # ● 获取基本魔法伤害
  #
  #     新加
  #
  #--------------------------------------------------------------------------
  def base_mdestroy
    n = self_mdestroy + @xmdestroy
    n += @xwisdom * BONUS_WISDOM_MDESTROY
    return n    
    
  end  
  
  
  #--------------------------------------------------------------------------
  # ● 获取基本攻速因子
  #
  #     新加
  #
  #--------------------------------------------------------------------------
  def base_atkspeed
    n = self_atkspeed + @xatkspeed
    n += @xcelerity * BONUS_CELERITY_ATKSPEED
    return n    
  end   
  
  #--------------------------------------------------------------------------
  # ● 获取基本闪避技巧
  #
  #     新加
  #
  #--------------------------------------------------------------------------
  def base_eva
    # 额外属性加成
    n = self_eva + @xcelerity * BONUS_CELERITY_EVA
    # 扩张
    n *= (100.0 + @xevarate) / 100.0
    # 装备加成
    n += @xeva
    return n    
  end
  
  #--------------------------------------------------------------------------
  # ● 获取基本闪避技巧
  #
  #     新加
  #
  #--------------------------------------------------------------------------
  def base_hit
    n = self_hit + @xcelerity * BONUS_CELERITY_HIT
    n *= (100.0 + @xhitrate) / 100.0
    n += @xhit
    return n    
  end
  
  #--------------------------------------------------------------------------
  # ● 获取基本暴击技巧
  #
  #     新加
  #
  #--------------------------------------------------------------------------
  def base_bom
    n = self_bom + @xstrength * BONUS_STRENGTH_BOM
    n = n * (100.0 + @xbomrate) / 100.0 + @xbom
    return n    
  end  
  
  #--------------------------------------------------------------------------
  # ● 获得基本暴击威力
  #
  #      新加 
  #
  #--------------------------------------------------------------------------
  def base_bomatk
    n = self_bomatk + @xbomatk
    return n
  end  
  
  #--------------------------------------------------------------------------
  # ● 获得自身生命恢复
  #
  #      生命恢复+力量奖励+生命百分比恢复
  #
  #--------------------------------------------------------------------------
  def base_hpcover
    n = self_hpcover
    n += @xhpcover 
    n += @xstrength * GAME_CONF::BONUS_STRENGTH_HPCOVER
    n += self_maxhp * @xhprate / 100.0
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获得自身魔法恢复
  #
  #    魔法恢复+智力奖励+魔法百分比恢复
  #
  #--------------------------------------------------------------------------
  def base_mpcover
    n = self_mpcover
    n += @xmpcover
    n += @xwisdom * GAME_CONF::BONUS_WISDOM_MPCOVER
    n += self_maxmp * @xmprate / 100.0
    return n
  end 
  
  
  #=========================================================================
  #  final 系列的参数，最终战斗的时候表现出来的参数
  #
  #========================================================================= 
  
  #--------------------------------------------------------------------------
  # ● 获取生命值
  #
  #    屏蔽Game_Battler的hp属性，为了每次获取的时候能够修改
  #
  #--------------------------------------------------------------------------
  def hp
    return @hp if @hp <= 0
    # 如果过了至少1秒
    if (temp = Graphics.frame_count - @fcounthp) >= Graphics.frame_rate
      # 更新fcounthp
      @fcounthp = Graphics.frame_count
      # 过了超过一秒
      temp /= (Graphics.frame_rate+0.0)
      # 非战斗状态，回血快
      if $game_switches[103] == false
        @hp = [@hp + temp * self.maxhp * 0.03, self.maxhp].min
      # 战斗状态，回血慢
      else
        @hp = [@hp + temp * self.final_hpcover, self.maxhp].min
      end
      # 返回新的hp
      return @hp
    
    # 否则直接返回
    else
      return @hp
    end
  end  
  
  #--------------------------------------------------------------------------
  # ● 获取生命值
  #
  #    屏蔽Game_Battler的mp属性，为了每次获取的时候能够修改
  #
  #--------------------------------------------------------------------------
  def mp
    return @mp if @mp <= 0
    
    if (temp = Graphics.frame_count - @fcountmp) >= 60
      # 更新fcountmp
      @fcountmp = Graphics.frame_count
      # 过了超过一秒
      temp /= 60.0
      @mp = [@mp + temp * self.final_mpcover, self.maxmp].min
      # 返回新的hp
      return @mp
    
    # 否则直接返回
    else
      return @mp
    end
  end  
  
  #--------------------------------------------------------------------------
  # ● 获取攻击力
  #
  #    重写覆盖，支持浮点数
  #
  #--------------------------------------------------------------------------
  def atk
    n = [[base_atk + @atk_plus, 1].max, 9999999].min
    for state in states do n *= state.atk_rate / 100.0 end
    n = [[n, 1].max, 9999999].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 获取防御力
  #
  #     重新覆盖，支持浮点数
  #
  #--------------------------------------------------------------------------
  def def
    n = [[base_def + @def_plus, 1].max, 9999999].min
    for state in states do n *= state.def_rate / 100.0 end
    n = [[n, 1].max, 9999999].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 获取力量
  #--------------------------------------------------------------------------
  def final_strength
    return base_strength
  end
  
  #--------------------------------------------------------------------------
  # ● 获取敏捷
  #--------------------------------------------------------------------------
  def final_celerity
    return base_celerity
  end
  
  #--------------------------------------------------------------------------
  # ● 获取智力
  #--------------------------------------------------------------------------
  def final_wisdom
    return base_wisdom
  end
  #--------------------------------------------------------------------------
  # ● 获取最终物理伤害量
  #--------------------------------------------------------------------------
  def final_destroy
    n = base_destroy
    n *= final_destroyrate / 100.0
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获取最终物理伤害比率 
  #    
  #    通常，物理伤害比率 % 可以为200%、150%、50% 等等
  #    刚开始的时候是1%，通过装备等等措施可以提高此参数  
  #
  #--------------------------------------------------------------------------
  def final_destroyrate
    return @destroyrate + @xdestroyrate
  end
  
  #--------------------------------------------------------------------------
  # ● 获取最终魔法伤害量
  #--------------------------------------------------------------------------
  def final_mdestroy
    n = base_mdestroy
    n *= final_mdestroyrate / 100.0
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获取最终魔法伤害比率 
  #    
  #    通常，魔法伤害比率 % 可以为200%、150%、50% 等等
  #    刚开始的时候是1%，通过装备等等措施可以提高此参数  
  #
  #--------------------------------------------------------------------------
  def final_mdestroyrate
    return @mdestroyrate + @xmdestroyrate
  end
  
  #--------------------------------------------------------------------------
  # ● 获取最终攻击速度因子
  #--------------------------------------------------------------------------
  def final_atkspeed
    n = base_atkspeed
    n *= (@atkrate + @xatkrate ) / 100.0
    n += CONST_BASE_ATKSPEED
    return n 
  end
  
  #--------------------------------------------------------------------------
  # ● 获取最终攻击速度率
  #
  #    类似于物理伤害比率，可以为50%、150%、300%等等
  #
  #--------------------------------------------------------------------------
  def final_atkrate
    return (@atkrate + @xatkrate)
  end
  
  #--------------------------------------------------------------------------
  # ● 获取最终闪避因子
  #
  #    
  #
  #--------------------------------------------------------------------------
  def final_eva
    n = base_eva
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 获取最终闪避增加率
  #
  #   是额外增加率，例如20则增加20%，变为120%
  #
  #--------------------------------------------------------------------------
  def final_evarate
    return (self.evarate + self.xevarate)
  end
  
  #--------------------------------------------------------------------------
  # ● 获取最终命中因子
  #
  #
  #--------------------------------------------------------------------------
  def final_hit
    n = base_hit
    return n
  end
  #--------------------------------------------------------------------------
  # ● 获取最终命中增加率
  #
  #     是额外增加率，例如20则增加20%，变为120%
  #
  #--------------------------------------------------------------------------
  def final_hitrate
    return (self.hitrate + self.xhitrate)
  end  
  
  
  
  
  #--------------------------------------------------------------------------
  # ● 获取最终暴击因子
  #
  #    注：这个因子要和GAME_CONF::CONST_MAX_BOM比较，得出暴击率
  #        如果这个值大于 ONST_MAX_BOM，在比较后会自动修正
  #
  #--------------------------------------------------------------------------
  def final_bom
    bom_val = base_bom
    # 0~400 * 1
    # 401~800 * 0.75
    # 801~1200 * 0.5
    # 1201~1600 * 0.25
    # 1601~2000 * 0.125
    # > 2000 * 0.0625
    rate_list = [0, 1.0, 0.75, 0.5, 0.25, 0.125]
    bom_list = [0, 400, 800, 1200, 1600, 2000]
    n = 0
    for index in 1...bom_list.size
      if bom_val > bom_list[index]
        n += (bom_list[index] - bom_list[index-1]) * rate_list[index]
      else
        n += (bom_val - bom_list[index-1]) * rate_list[index]
        break
      end
    end
    if bom_val > 2000
      n += (bom_val - 2000) * 0.0625
    end
    return n 
  end
  #--------------------------------------------------------------------------
  # ● 获取最终暴击因子增加率
  #--------------------------------------------------------------------------
  def final_bomrate
    return (self.bomrate + self.xbomrate)
  end
  
  #--------------------------------------------------------------------------
  # ● 获取最终暴击扩张倍数
  #
  #    获得之后要加百分号，例如1000是 1000% 即10倍
  #
  #    分段，1.5倍以下则是实打实的
  #          1.5-2.0 则是*0.8
  #          2.0-2.5 则是*0.6
  #          2.5-3.0 则是*0.4
  #          3.0-3.5 则是*0.2
  #          3.5-无穷 则是*0.1
  #          最高5.0
  #--------------------------------------------------------------------------
  def final_bomatk
    n = base_bomatk
    extend_list = [1.0, 0.8, 0.6, 0.4, 0.2]
    scale_list = [0, 150, 200, 250, 300, 350]
    tmp = scale_list[0]
    res = 0
    for index in 0...extend_list.size
      tmp = scale_list[index+1]
      if tmp <= n
          res += extend_list[index] * (scale_list[index+1]-scale_list[index])
      else # n > tmp (tmp上一次 < n < tmp这一次)
          res += extend_list[index] * (n - scale_list[index])
          break
      end
    end
    # 如果n 很大 
    if n > 350
      res += (n - 350) * 0.1
    end    
    res = [res, 500].min
    return res
  end
  #--------------------------------------------------------------------------
  # ● 最终每秒生命恢复量
  #
  #      会根据状态动态的修改real_hpcover这个变量
  #      修改real_hpcover时用到 base_hpcover
  #
  #--------------------------------------------------------------------------
  def final_hpcover
    return self.real_hpcover
  end
  #--------------------------------------------------------------------------
  # ● 获取最终魔法恢复量
  #
  #      会根据状态动态的修改real_hpcover这个变量
  #      修改real_hpcover时用到 base_hpcover
  #
  #--------------------------------------------------------------------------
  def final_mpcover
    return self.real_mpcover
  end
  
  #--------------------------------------------------------------------------
  # ● 当恢复信息变更的时候
  #    
  #     升级、更换装备、状态改变，等等都需要调用此函数。
  #
  #--------------------------------------------------------------------------  
  def recover_change
    
    # 先获得结算了装备之后的恢复率
    @real_hpcover          = self.base_hpcover
    @real_mpcover          = self.base_mpcover
    
    # 再获得结算了状态之后的恢复率
    # 如果没有状态附加，那么下面不会改变恢复率
    # 状态附加恢复率<0也是可以的，例如中毒
    recover_change_by_state
    
  end
  #--------------------------------------------------------------------------
  # ● 因为状态改变而改变恢复值
  #--------------------------------------------------------------------------
  def recover_change_by_state
    # 记录恢复率的修正值
    hpr = 0
    mpr = 0
    
    # 遍历状态
    for state in states do
      next if state == nil
      hpr += state.read_note('add_hpcover') if state.read_note('add_hpcover') != nil
      hpr += state.read_note('add_hprate')*maxhp/100.0 if state.read_note('add_hprate') != nil
      mpr += state.read_note('add_mpcover') if state.read_note('add_mpcover') != nil
      mpr += state.read_note('add_mprate')*maxmp/100.0 if state.read_note('add_mprate') != nil
    end
    
    # hpr 可以 <0 例如中毒
    @real_hpcover += hpr
    @real_mpcover += mpr
  end 
  
  
  #========================================================================
  #  下面是各个参数在实战中最终的应用。
  #
  #  各个参数进行计算后，得出一次攻击的结果。
  #=========================================================================
  
  #------------------------------------------------------------------------
  # ● 下面开始准备战斗函数
  #
  #--------------------------------------------------------------------------
  # ● 准备攻击
  #
  #    只要是对目标角色进行攻击前的准备包括：
  #      命中率的计算
  #      闪避率的计算
  #      暴击是否成功的计算
  #
  #      函数设置bomflag hitflag 返回暴击威力atkrate（为0则不暴击）
  #
  #--------------------------------------------------------------------------
  def preattack(target)
    
    # 计算暴击技巧产生的暴击率
    n = self.final_bom + 0.0
    n = n / CONST_MAX_BOM
    
    # 命中影响暴击率
    bom_hit = 1.2*(self.final_hit - target.final_eva*1.5) / self.final_hit
    if bom_hit > 0
      bom_hit = [bom_hit, 0.36].min
    else
      bom_hit = [bom_hit, -0.5].max
    end
    
    # 防御影响暴击率
    bom_def = (self.def-target.def) / self.def
    if bom_def > 0
      bom_def = [bom_def, 0.3].min
    else
      bom_def = [bom_def, -0.4].max
    end
    
    # 力量影响暴击
    bom_str = 1.5*(self.final_strength - target.final_strength) / self.final_strength
    if bom_str > 0
      bom_str = [bom_str, 0.45].min
    else
      bom_str = [bom_str, -0.4].max
    end
    
    
    
    # 计算最终百分比数值，不超过70%
    final_bom_percent = (bom_hit + bom_def + bom_str + n) * 100.0
    if final_bom_percent > 0
      final_bom_percent = [final_bom_percent, 70].min
    else
      final_bom_percent = 0
    end
    
    # 扩大100倍进行比较
    if final_bom_percent * 100 > rand(10001)
      @bomflag = true
      @hitflag = true
      return self.final_bomatk / 100.0
    else
      @bomflag = false
      @hitflag = false
    end
    
    # ---- 否则不暴击，计算命中率--------
    # 闪避率由三个分量组成
    hit_hit_eva = [3.0*(self.final_hit - target.final_eva) / self.final_hit, -0.5].max
    hit_cel_cel = [1.0*(self.final_celerity - target.final_celerity) / self.final_celerity, -1].max
    hit_def_def = [0.4*(self.def-target.def) / self.def, 0.4].max
    hit_final = [[hit_hit_eva + hit_cel_cel + hit_def_def, 0.4].max, 2].min
    @hitflag = (hit_final * 100 >= rand(101));

    # 暴击率返回0
    return 0
    
  end
  #--------------------------------------------------------------------------
  # ● 执行攻击
  #    
  #    进行攻击、护甲的比较
  #    
  #    返回最后伤害作用的比率
  #
  #--------------------------------------------------------------------------
  def doattack(target)
    # 进行攻击、防御的修正
     rate = self.atk / target.def
     return rate
  end
  
  #--------------------------------------------------------------------------
  # ● 准备伤害
  #
  #    计算出最终的伤害
  #    
  #
  #
  #--------------------------------------------------------------------------
  def predamage(brate, damagerate, target)
    return 0 if @hitflag == false
    # 计算伤害
    dmg = final_destroy * damagerate
    
    # 制造随机伤害
    dmg = dmg * (180 + rand(41)) / 200.00
    
    # 攻击力造成的额外伤害
    dmg += [(self.atk - target.def) / 4.0 , 0].max
    dmg = [dmg, 0].max
    
    # 如果暴击
    dmg = dmg *  brate if bomflag == true and brate > 0
    
    return dmg
    
  end  
  #--------------------------------------------------------------------------
  # ● 执行伤害
  #    
  #     实现反弹、吸血等等
  #
  #
  #--------------------------------------------------------------------------
  def dodamage(target, dmg, flag = 0)
    return if dmg == 0
    
    # 首先是反弹——这里没有实现
    
    # 然后是减少伤害——这里没有实现
    
    # 然后是抵消伤害（格挡）——这里没有实现
    
    # 然后是吸血(吸血之前应该判定自己是否死亡)——这里没有实现
    
    # 修改hp
    target.hp -= dmg
    
  end
  
  #--------------------------------------------------------------------------
  # ● 伤害之后
  #    
  #     清除标志
  #     判断死亡
  #
  #      本函数，默认怪物始终不会攻击怪物，英雄始终不会攻击英雄
  #
  #--------------------------------------------------------------------------
  def postdamage(target, flag = 0)
    
    
    # 首先判断是否分身攻击
    if flag != 0
      
      # 如果自己不是英雄，是怪物（分身）
      if !self.hero?
        # 如果自身死亡
        if self.hp <= 0
          doVictory(flag)
        # 如果是英雄死亡
        elsif target.hp <= 0
          doGameOver
        end
        # 如果目标和自己都没有死亡，什么也不做
      # 否则如果自己是英雄
      else
        # 留作以后英雄分身扩展
      end
      
      # 清除标志。
      @bomflag = false
      @hitflag = false
      # 分身判断完毕，不用执行下面内容
      return 
      
    end

    
    # 首先判断死亡
    if self.hp <= 0 or target.hp <= 0
      # 退出战斗状态
      $game_switches[103] = false
      $game_switches[104] = true
      $game_map.refresh
      
      # 如果自己死亡——多是是反弹死的
      if self.hp <= 0       
          # 如果自己是英雄，并且死亡
          if hero?
              # 对手是怪物,并且没有死亡，那么对手直接恢复
              if target.hp > 0 
                  # 英雄死
                  self.doGameOver
              # 否则对手也死了
              else
                  # 怪物先死
                  target.doVictory
                  # 英雄再死
                  self.doGameOver
              end
          # 如果自己是怪物，并且死亡
          else
              # 如果对手(英雄)也死了
              if target.hp <= 0
                  # 怪物先死掉
                  self.doVictory
                  # 英雄再死
                  target.doGameOver
              # 如果对手没有死亡
              else
                  # 仅仅怪物死亡
                  self.doVictory
              end
          end
      # 否则一定是target.hp <= 0,自己没有死
      else
        
          target.doDead
          
      end
        
    end
    
    
    # 清除标志，如果死了再清除标记也没有什么影响
    @bomflag = false
    @hitflag = false
    
  end
  #--------------------------------------------------------------------------
  # ● 执行死亡
  #
  #    doGameOver 在 Game_Hero中
  #    doVictory  在 Game_Monstor中
  #
  #--------------------------------------------------------------------------
  def doDead(flag = 0)
    # 首先判断是否玩家
    # 如果是玩家，则结束
    if hero?
      doGameOver
      return 
    # 否则是怪物
    else
      doVictory(flag)
      return 
    end
  end
  #--------------------------------------------------------------------------
  # ● 控制战斗流程
  #    
  #    preattack  
  #    doattack 
  #    predamage
  #    dodamage
  #    postdamage
  # 
  #    flag   :身份标识，0英雄或者怪物，1怪物分身1，2怪物分身2，3怪物分身3
  #
  #--------------------------------------------------------------------------
  def excuteBattle(target, flag = 0)   
    
    # 判断死亡
    if self.hp <= 0 and target.hp <= 0
      doDead(flag)
      return 
    end
    if target.hp <= 0
      target.doDead(flag)
      return 
    end
    
    # 计算
    brate = preattack(target)
    drate =  doattack(target)
    dmg = predamage(brate, drate, target)
    
    
    # 如果是怪物受伤
    if !target.hero?
      # 判断是否分身
      case flag
      when 0
        # 设置本尊受到的伤害
        $game_variables[35] = dmg
      when 1
        # 设置分身1受到的伤害
      when 2
        # 设置分身2受到的伤害
      when 3
        # 设置分身3受到的伤害
      end
      
    # 否则是英雄受伤
    else
      # 判断是否分身
      case flag
      when 0
        # 设置本尊造成的伤害
        $game_variables[34] = dmg
      when 1
        # 设置分身1造成的伤害
        $game_variables[118] = dmg
      when 2
        # 设置分身2造成的伤害
        $game_variables[122] = dmg
      when 3
        # 设置分身3造成的伤害
      end
    # 受伤判断结束
    end
    
    # 执行伤害（包括反弹——反弹的话需要修改上面两个变量）
    dodamage(target, dmg, flag)
    
    
    # 修改命中状况
    if @hitflag == false and self.hero?
      # 如果是hero并且丢失，修改hero命中开关
      $game_switches[105] = true
    elsif @hitflag == false and  !self.hero?
      # 如果不是英雄并且丢失，修改怪物命中开关
      case flag
      when 0    
        # 本尊发动的攻击
        $game_switches[106] = true
      when 1    
        # 分身1发动的攻击
        $game_switches[120] = true
      when 2    
        # 分身2发动的攻击
        $game_switches[123] = true
      when 3    
        # 分身3发动的攻击
      end
    end
    
    
    # 记录暴击状况
    if @bomflag == true and self.hero?
      # 英雄暴击
      $game_switches[109] = true
    elsif @bomflag == true and !self.hero?
      # 怪物暴击
     case flag
      when 0    
        # 本尊发动的攻击
        $game_switches[110] = true
      when 1    
        # 分身1发动的攻击
        $game_switches[119] = true
      when 2    
        # 分身2发动的攻击
        $game_switches[122] = true
      when 3    
        # 分身3发动的攻击
      end
    end
    
    
    # 伤害之后的处理——判断胜负
    postdamage(target, flag)
    
  end  
  
end