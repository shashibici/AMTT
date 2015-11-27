#==============================================================================
# ■ Window_Base
#------------------------------------------------------------------------------
# 　游戏中全部窗口的超级类。
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # ● 描绘一行
  #
  #     新增
  #
  #     color  : 颜色类 由Color.new(r,g,b)生成
  #     x      : 描绘目标 X 坐标
  #     y      : 描绘目标 Y 坐标
  #     width  : 宽度
  #     height : 高度
  #     value  : 值 如果为数字就自动转成str,如果为str则不用转了
  #     align  : 对其方式，0左对齐 1居中 2右对齐
  #
  #--------------------------------------------------------------------------
  def draw_a_line(color, x, y, width, height = WLH, value = "", align = 2)
    self.contents.font.color = color
    self.contents.draw_text(x, y, width, height, value, align)
  end
  
  #--------------------------------------------------------------------------
  # ● 描绘物品名
  #
  #         新增，使用新的大小
  #
  #     item    : 物品 (可以是特技、武器、防具)
  #     x       : 描绘目标 X 坐标
  #     y       : 描绘目标 Y 坐标
  #     enabled : 有效标志。false 为描绘为半透明
  #--------------------------------------------------------------------------
  def draw_a_item_name(item, x, y, enabled = true)
     
    if item != nil
      draw_icon(item.icon_index, x, y, enabled)
      self.contents.font.color = normal_color
      self.contents.font.color.alpha = enabled ? 255 : 128
      self.contents.draw_text(x + 24, y, 172, WLH, item.name)
    end
  end  
  #--------------------------------------------------------------------------
  # ● 描绘 HP
  #
  #     重新定义
  #
  #     actor : 角色
  #     x     : 描绘目标 X 坐标
  #     y     : 描绘目标 Y 坐标
  #     width : 宽
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, x, y, width = 120)
    hp = Fround(actor.hp, 1)
    draw_actor_hp_gauge(actor, x, y, width)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 30, WLH, Vocab::hp_a)
    self.contents.font.color = hp_color(actor)
    xr = x + width
    if width < 120
      self.contents.draw_text(xr - 40, y, 40, WLH, hp, 2)
    else
      self.contents.draw_text(xr - 90, y, 40, WLH, hp, 2)
      self.contents.font.color = normal_color
      self.contents.draw_text(xr - 50, y, 10, WLH, "/", 2)
      self.contents.draw_text(xr - 40, y, 40, WLH, actor.maxhp.to_i, 2)
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 描绘 MP
  #
  #      重定义
  #
  #     actor : 角色
  #     x     : 描绘目标 X 坐标
  #     y     : 描绘目标 Y 坐标
  #     width : 宽
  #--------------------------------------------------------------------------
  def draw_actor_mp(actor, x, y, width = 120)
    
    mp = Fround(actor.mp, 1)
    
    draw_actor_mp_gauge(actor, x, y, width)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 30, WLH, Vocab::mp_a)
    self.contents.font.color = mp_color(actor)
    xr = x + width
    if width < 120
      self.contents.draw_text(xr - 40, y, 40, WLH, mp, 2)
    else
      self.contents.draw_text(xr - 90, y, 40, WLH, mp, 2)
      self.contents.font.color = normal_color
      self.contents.draw_text(xr - 50, y, 10, WLH, "/", 2)
      self.contents.draw_text(xr - 40, y, 40, WLH, actor.maxmp.to_i, 2)
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 混元单位以及数值描绘
  #     value : 数值 (所混元)
  #     x     : 描绘目标 X 坐标
  #     y     : 描绘目标 Y 坐标
  #     width : 宽
  #--------------------------------------------------------------------------
  def draw_hunyuan_value(value, x, y, width)
    cx = contents.text_size("H").width
    self.contents.font.color = normal_color
    self.contents.draw_text(x, y, width-cx-2, WLH, value, 2)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, width, WLH, "H", 2)
  end
  
  
end