#==============================================================================
# 脚本作者:shashibici,  使用和转载请保留此信息
#============================================================================== 
#自定义功能：
#
#    可以增加的属性：
#    maxhp  maxmp  strength  celerity  wisdom  destroy  mdestroy atkspeed  
#    hit  eva
#    
#    
#    不能增加的属性：
#    atk  def  destroyrate  mdestroyrate atkrate  hitrate evarate
#    bom bomrate bomatk
#
#=============================================================================
# 脚本使用设定：

LEVEL_UP_POINT = 20    # 每提升一级能够获得的点数

#==============================================================================
# ■ Game_Actor
#------------------------------------------------------------------------------
# 　处理角色的类。（再定义）
#
#  
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● 提升一级
  #
  #       重定义覆盖
  #
  #--------------------------------------------------------------------------  
  def level_up
    @level += 1
    @point += LEVEL_UP_POINT + @level
    
    # 显示动画
    $game_player.animation_id = 99
    
  end
end



#==============================================================================
# ■ Scene_Addpoint
#------------------------------------------------------------------------------
# 　处理升级画面的类。
#==============================================================================
class Scene_Addpoint < Scene_Base
  include GAME_CONF
  WLH = 18             # 帮助窗口每行的高度

  #--------------------------------------------------------------------------
  # ● 初始化对像
  #     actor_index : 角色索引
  #     menu_index : 选项起始位置
  #--------------------------------------------------------------------------
  def initialize(actor_index = 0 , menu_index = 0)
    # 初始化变量
    @actor_index = actor_index
    @menu_index = menu_index
    @menu_index = 0
    @hero = $game_party.members[actor_index]
    
    # 产生副本——用来估计能力值的提升
    @chero = @hero.clone
    @clone_attr = []
    getClone_attr
    
    @point_consume           = 1
    
    # 获取当前最新的能力值
    @current_attr = []
    getCurrent_attr

    # 初始化属性增量    
    @each_ascend = [
    
    @hp_ascend               = HP_ASCEND,
    @mp_ascend               = MP_ASCEND,
    @hpcover_ascend          = HPCOVER_ASCEND,
    @mpcover_ascend          = MPCOVER_ASCEND,
    @atk_ascend              = ATK_ASCEND,
    @def_ascend              = DEF_ASCEND,
    @strength_ascend         = STRENGTH_ASCEND,
    @wisdom_ascend           = WISDOM_ASCEND,
    @celerity_ascend         = CELERITY_ASCEND,
    @destroy_ascend          = DESTROY_ASCEND,
    @mdestroy_ascend         = MDESTROY_ASCEND,
    @atkspeed_ascend         = ATKSPEED_ASCEND,
    @hit_ascend              = HIT_ASCEND,
    @eva_ascend              = EVA_ASCEND
    
    ]
    
    # 初始化记录每种属性总共增加了多少
    @totally_ascend = [
    
    @thp_ascend               = 0,
    @tmp_ascend               = 0,
    @thpcover_ascend          = 0,
    @tmpcover_ascend          = 0,
    @tatk_ascend              = 0,
    @tdef_ascend              = 0,
    @tstrength_ascend         = 0,
    @twisdom_ascend           = 0,
    @tcelerity_ascend         = 0,
    @tdestroy_ascend          = 0,
    @tmdestroy_ascend         = 0,
    @tatkspeed_ascend         = 0,
    @thit_ascend              = 0,
    @teva_ascend              = 0 
    
    ]
    
    # 初始化描述信息
    @abstracts = [
    # hp
    ["增加生命力，能够提高最大生命力。",
    "",
    "每次消耗"+@point_consume.to_s+"技能点",
    "每次增加"+@hp_ascend.to_s+"生命力"],
    
    # mp
    ["增加魔法，能够提高最大魔法值。",
    "",
    "每次消耗"+@point_consume.to_s+"技能点",
    "每次增加"+@mp_ascend.to_s+"魔法值"],
    
    # hpcover
    ["增加每秒生命恢复量。",
    "",
    "每次消耗"+@point_consume.to_s+"技能点",
    "每次增加"+@hpcover_ascend.to_s+"生命恢复量"],
    
    # mpcover
    ["增加每秒魔法恢复量。",
    "",
    "每次消耗"+@point_consume.to_s+"技能点",
    "每次增加"+@mpcover_ascend.to_s+"魔法恢复量"],
    
    # atk
    ["增加攻击力，攻击力越高破坏加成越多",
    "",
    "每次消耗"+@point_consume.to_s+"技能点",
    "每次增加"+@atk_ascend.to_s+"攻击力"],
    
    # def
    ["增加防御，防御越高能抵消越多的破坏",
    "",
    "每次消耗"+@point_consume.to_s+"技能点",
    "每次增加"+@def_ascend.to_s+"防御"],
    
    # strength
    ["增加力量，每点力量增加"+BONUS_STRENGTH_MAXHP.to_s+"点最大生命，"+BONUS_STRENGTH_HPCOVER.to_s+"点每秒",
    "生命恢复量,"+BONUS_STRENGTH_DESTROY.to_s+"点物理伤害,"+BONUS_STRENGTH_BOM.to_s+"点暴击技巧",
    "每次消耗"+@point_consume.to_s+"技能点",
    "每次增加"+@strength_ascend.to_s+"力量"],
    
    # wisdom
    ["增加智力，每点智力增加"+BONUS_WISDOM_MAXMP.to_s+"点最大魔法，"+BONUS_WISDOM_MPCOVER.to_s+"点每秒",
    "魔法恢复量，"+BONUS_WISDOM_MDESTROY.to_s+"点魔法伤害。",
    "每次消耗"+@point_consume.to_s+"技能点",
    "每次增加"+@wisdom_ascend.to_s+"智力"],
    
    # celerity
    ["增加敏捷，每点敏捷增加"+BONUS_CELERITY_DEF.to_s+"防御，"+BONUS_CELERITY_ATKSPEED.to_s+"点攻击速度；",
    "每点敏捷增加"+BONUS_CELERITY_HIT.to_s+"命中技巧，"+ BONUS_CELERITY_EVA.to_s+"闪避技巧。",
    "每次消耗"+@point_consume.to_s+"技能点",
    "每次增加"+@celerity_ascend.to_s+"敏捷"],
    
    # destroy
    ["增加物理破坏力，物理破坏力直接影响能每次",
    "攻击造成的伤害。",
    "每次消耗"+@point_consume.to_s+"技能点",
    "每次增加"+@destroy_ascend.to_s+"物理破坏力"],
    
    # mdestroy
    ["增加魔法破坏力，魔法破坏力直接影响能每次",
    "释放技能造成的伤害。",
    "每次消耗"+@point_consume.to_s+"技能点",
    "每次增加"+@mdestroy_ascend.to_s+"魔法破坏力"],
    
    # atkspeed
    ["增加攻击速度，攻击速度攻击速度越高两次攻击",
    "之间的间隔越小。",
    "每次消耗"+@point_consume.to_s+"技能点",
    "每次增加"+@atkspeed_ascend.to_s+"攻击速度"],
    
    # hit
    ["增加命中技巧，命中技巧越高攻击命中的可能越大。",
    "",
    "每次消耗"+@point_consume.to_s+"技能点",
    "每次增加"+@hit_ascend.to_s+"命中技巧"],
    
    # eva
    ["增加闪避技巧，闪避技巧越高躲避攻击的可能越大。",
    "",
    "每次消耗"+@point_consume.to_s+"技能点",
    "每次增加"+@eva_ascend.to_s+"闪避技巧"],
        
    # 重置
    [""],
    
    # 确定
    [""]
    
    ]
  end
  
  #--------------------------------------------------------------------------
  # ● 获得当前最新的能力值
  #--------------------------------------------------------------------------
  def getCurrent_attr
    # 初始化当前能力
    @current_attr.clear if @current_attr.size > 0
    
    # 重新获取属性
    @current_attr = [
    
          Fround(@hero.self_maxhp,2),
          Fround(@hero.self_maxmp,2),
          Fround(@hero.self_hpcover,3),
          Fround(@hero.self_mpcover,3),
          Fround(@hero.self_atk,2),
          Fround(@hero.self_def,2),
          @hero.self_strength,
          @hero.self_wisdom,
          @hero.self_celerity,
          Fround(@hero.self_destroy,2),
          Fround(@hero.self_mdestroy,2),
          Fround(@hero.self_atkspeed,2),
          Fround(@hero.self_hit,2),
          Fround(@hero.self_eva,2)

    ]    
  end

  #--------------------------------------------------------------------------
  # ● 获得副本英雄的能力值
  #--------------------------------------------------------------------------
  def getClone_attr
    # 初始化当前能力
    @clone_attr.clear if @clone_attr.size > 0
    
    # 重新获取属性
    @clone_attr = [
    
          Fround(@chero.self_maxhp,2),
          Fround(@chero.self_maxmp,2),
          Fround(@chero.self_hpcover,3),
          Fround(@chero.self_mpcover,3),
          Fround(@chero.self_atk,2),
          Fround(@chero.self_def,2),
          @chero.self_strength,
          @chero.self_wisdom,
          @chero.self_celerity,
          Fround(@chero.self_destroy,2),
          Fround(@chero.self_mdestroy,2),
          Fround(@chero.self_atkspeed,2),
          Fround(@chero.self_hit,2),
          Fround(@chero.self_eva,2)

    ]    
  end
  
  #--------------------------------------------------------------------------
  # ● 设置副本英雄的能力值
  #--------------------------------------------------------------------------
  def setClone_attr
        @chero = @hero.clone
    
        @chero.hmaxhp += @totally_ascend[0]
        @chero.hmaxmp += @totally_ascend[1]
        @chero.hpcover += @totally_ascend[2]
        @chero.mpcover += @totally_ascend[3]
        @chero.hatk += @totally_ascend[4]
        @chero.hdef += @totally_ascend[5]
        @chero.strength += @totally_ascend[6]
        @chero.wisdom += @totally_ascend[7]
        @chero.celerity += @totally_ascend[8]
        
        @chero.destroy += @totally_ascend[9]
        @chero.mdestroy += @totally_ascend[10]
        @chero.atkspeed += @totally_ascend[11]
        @chero.hit += @totally_ascend[12]
        @chero.eva += @totally_ascend[13]    
  end  
  
  #--------------------------------------------------------------------------
  # ● 开始处理
  #--------------------------------------------------------------------------
  def start
    super
    # 创建右边的属性窗口
    @lvup_window1 = Window_Addpoint1.new(230,0)
    @lvup_window1.setup(@hero)
    @lvup_window1.refresh
    
    # 创建左边的项目选择窗口
    create_command_window
    
    # 创建最下方的点数显示窗口
    @point_window = Window_Base.new(0,415,230, 65)
    refresh_point
    
    # 创建右下方的说明窗口
    @abstract_window = Window_Base.new(230,370,410,110)
    refresh_abstract


  end
  #--------------------------------------------------------------------------
  # ● 创建左边的指令窗口
  #--------------------------------------------------------------------------
  def create_command_window
    
    texts = [
    
    s1 = "增加生命",
    s2 = "增加魔法",
    s3 = "增加生命恢复",
    s4 = "增加魔法恢复" ,  
    s5 = "增加攻击" ,
    s6 = "增加防御",
    s7 = "增加力量",
    s8 = "增加智力" ,
    s9 = "增加敏捷",
    
    s10 = "增加物理伤害",
    s11 = "增加魔法伤害",
    s12 = "增加攻击速度" ,
    s13 = "增加命中技巧",
    s14 = "增加闪避技巧",
    
    s15 = "点数重置",
    s16 = "确定加点"
    
    ]
     
    # 创建指令窗口
    @command_window = Window_Addpoint2.new(230, texts)
    @command_window.index = @menu_index
    
  end  
  
  #--------------------------------------------------------------------------
  # ● 重绘信息窗口
  #--------------------------------------------------------------------------
  def refresh_lvup
    # 首先清除原来信息
    @lvup_window1.contents.clear
    
    # 首先画出基本部分
    @lvup_window1.refresh
    
    # 设置副本英雄的能力值
    setClone_attr
    # 获取副本英雄的能力值
    getClone_attr
    
    # 画出增值的部分
    for i in 0...@totally_ascend.size do
      
      if Fround(@clone_attr[i],2) > Fround(@current_attr[i],2) 
        # 浅绿色
        color = getColor("green")
        @lvup_window1.draw_a_line(color, 205, 24*i, 100, 24, Fround(@clone_attr[i],2), 2)
        
      elsif Fround(@clone_attr[i],2) < Fround(@current_attr[i],2) 
        # 深绿色
        color = getColor("red")
        @lvup_window1.draw_a_line(color, 205, 24*i, 100, 24, Fround(@clone_attr[i],2), 2)
        
      else
        # 不作绘画
      end
      
    end
    
  end
  #--------------------------------------------------------------------------
  # ● 重绘点数窗口
  #--------------------------------------------------------------------------
  def refresh_point
    # 描绘“剩余点数”
    @point_window.contents.clear
    @point_window.contents.font.size = 26
    color = Color.new(255,255,255)
    @point_window.draw_a_line(color, 0, 0, 80, 26, "剩余点数", 0)
    
    # 描绘剩余的点数，采用粗体描绘技术
    color = Color.new(0,0,0)
    @point_window.draw_a_line(color, 80+1, 0-1, 100, 26, @hero.point, 2)
    @point_window.draw_a_line(color, 80+1, 0+1, 100, 26, @hero.point, 2)
    @point_window.draw_a_line(color, 80-2, 0-1, 100, 26, @hero.point, 2)
    @point_window.draw_a_line(color, 80-1, 0+1, 100, 26, @hero.point, 2)
    color = @point_window.system_color
    @point_window.draw_a_line(color, 80, 0, 100, 26, @hero.point, 2)
    
  end  
  
  #--------------------------------------------------------------------------
  # ● 重绘说明窗口
  #--------------------------------------------------------------------------
  def refresh_abstract
    # 清除原来内容
    @abstract_window.contents.clear
    
    # 字体设置
    @abstract_window.contents.font.name = "黑体"
    @abstract_window.contents.font.size = 17
    color = Color.new(255,255,255)
    
    # 根据当前选项进行显示
    texts = @abstracts[@menu_index]
    for i in 0...texts.size do
      if i == 3
        color = getColor("light blue")
      elsif i == 2
        color = getColor("light red")
      else
        color = getColor("orange")
      end
      # 描绘一行
      @abstract_window.draw_a_line(color, 0, WLH*i, 410, 26, texts[i], 0)
    end
    
  end  
  
  #--------------------------------------------------------------------------
  # ● 刷新画面
  #--------------------------------------------------------------------------
  def update
    # 更新指令窗口
    @command_window.update
    update_command_window
  end 
  #--------------------------------------------------------------------------
  # ● 刷新画面
  #--------------------------------------------------------------------------
  def update_command_window
    # 取消------------------------------------
    if Input.trigger?(Input::B)
      
      # 归还没有确定的点数
      for i in 0...@totally_ascend.size do
        # 英雄获得点数
        @hero.point += Integer(@totally_ascend[i] / @each_ascend[i])
        # 英雄增加的值清零
        @totally_ascend[i] = 0
      end      
      
      # 播放音效
      Sound.play_cancel
      $scene = Scene_Menu2.new(3)
      
    # 确定------------------------------------
    elsif Input.trigger?(Input::C)
      # 确定加点或者重置
      @menu_index = @command_window.index
      
      # 如果是重置
      if @menu_index == 14
        
        # 对所有属性都执行
        for i in 0...@totally_ascend.size do
          # 英雄获得点数
          @hero.point += Integer(@totally_ascend[i] / @each_ascend[i])
          # 英雄增加的值清零
          @totally_ascend[i] = 0
        end
        
        # 播放声音
        MySound.play_cancel
        # 重绘点数
        refresh_point
        # 重绘信息 
        refresh_lvup
          
      # 如果是确定    
      elsif @menu_index == 15
        # 生命、魔法的变更
        hpr = 1.0 * @hero.hp / @hero.maxhp
        mpr = 1.0 * @hero.mp / @hero.maxmp
        
        # 对所有属性都执行
        @hero.hmaxhp += @totally_ascend[0]
        @hero.hmaxmp += @totally_ascend[1]
        @hero.hpcover += @totally_ascend[2]
        @hero.mpcover += @totally_ascend[3]
        @hero.hatk += @totally_ascend[4]
        @hero.hdef += @totally_ascend[5]
        @hero.strength += @totally_ascend[6]
        @hero.wisdom += @totally_ascend[7]
        @hero.celerity += @totally_ascend[8]

        @hero.destroy += @totally_ascend[9]
        @hero.mdestroy += @totally_ascend[10]
        @hero.atkspeed += @totally_ascend[11]
        @hero.hit += @totally_ascend[12]
        @hero.eva += @totally_ascend[13]
        # 更新恢复率
        @hero.onEquipChanges
        
        # 生命魔法的变更
        @hero.hp = @hero.maxhp * hpr
        @hero.mp = @hero.maxmp * mpr
        
        # 重新获取属性值
        getCurrent_attr

        # 属性清零
        for i in 0...@totally_ascend.size do
          @totally_ascend[i] = 0
        end
        
        # 播放声音
        MySound.play_decision
        # 重绘点数
        refresh_point
        # 重绘信息 
        refresh_lvup    
        
      # 如果是其他项目，什么都不做
      else
        # 什么也不做
      end
      
    # 向上--------------------------------------------------
    elsif Input.trigger?(Input::UP)
      # 更新说明
      @menu_index = @command_window.index
      Sound.play_decision
      
      
    # 向下-------------------------------------------------  
    elsif Input.trigger?(Input::DOWN)
      # 更新说明
      @menu_index = @command_window.index
      Sound.play_decision

      
    # 向左--------------------------------------------------
    elsif Input.trigger?(Input::LEFT)
      # 减小加的点
      @menu_index = @command_window.index
      return if @menu_index >= 14
      
      # 如果该属性被添加过至少一次
      if @totally_ascend[@menu_index].abs >= @each_ascend[@menu_index].abs
        # 减少
        @totally_ascend[@menu_index] -= @each_ascend[@menu_index]
        # 获得一点技能点
        @hero.point += @point_consume
        Sound.play_cursor
      else
        MySound.play_buzzer
      end
      
      # 更新信息窗口
      refresh_lvup
      # 更新点数窗口
      refresh_point
      
    
    # 向右-------------------------------------------------------
    elsif Input.trigger?(Input::RIGHT)
      # 增加加的点
      @menu_index = @command_window.index
      return if @menu_index >= 14
      
      # 如果还有剩余点数
      if @hero.point >= @point_consume
        # 增加
        @totally_ascend[@menu_index] += @each_ascend[@menu_index]
        # 失去一点技能点
        @hero.point -= @point_consume  
        Sound.play_cursor
        
      else
        MySound.play_buzzer
      end
      
      # 更新信息窗口
      refresh_lvup
      # 更新点数窗口
      refresh_point

    # 其他所有情况------------------------------------------------  
    else
      @menu_index = @command_window.index
    end
    
    refresh_abstract

  end   
  
  
  
  
  #--------------------------------------------------------------------------
  # ● 结束处理
  #--------------------------------------------------------------------------
  def terminate
    super

    @lvup_window1.dispose
    @command_window.dispose
    @point_window.dispose
    @abstract_window.dispose

  end
  
end
