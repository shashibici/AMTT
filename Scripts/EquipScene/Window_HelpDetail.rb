#==============================================================================
# ■ Window_HelpDetail
#------------------------------------------------------------------------------
# 　物品的详尽说明窗口
#==============================================================================

class Window_HelpDetail < Window_Base
  #WLH = 16
  attr_accessor     :WLH
  #--------------------------------------------------------------------------
  # ● 初始化对象
  # 
  #    w    : 宽度
  #    h    : 高度
  #
  #--------------------------------------------------------------------------
  def initialize(x,y, w, h, size=16, wlh=16, opacity=255, bopacity=255)
    @WLH = wlh
    super(x, y, w, h)
    self.contents.font.size = size
    self.z = 3000
    self.windowskin = Cache.system("WindowDetail")
    @init_height = h
    self.opacity = opacity
    self.back_opacity = bopacity
  end
  #--------------------------------------------------------------------------
  # ● 文本设置
  #     text   : 是一个字符串数组，每一个元素显示一行
  #     colors : 是一个颜色数组，每一个元素是颜色名字“light red、heavy green”
  #     align  : 对齐方式 (0..左对齐、1..中间对齐、2..右对齐)
  #--------------------------------------------------------------------------
  def set_text(text, align = 0, colors = nil)
    self.contents.clear
    # 如果没有内容需要显示，则直接返回
    if text.size == 0
      self.height = 0
      return 
    end
    # 否则设置颜色、字体
    for i in 0...text.size
      # 设置颜色
      self.contents.font.color = getColor(colors == nil ? normal_color : (colors[i]==nil ? normal_color : colors[i])) 
      # 绘制字体
      self.contents.draw_text(0, @WLH * i, self.width - 40, @WLH, text[i], align)
    end
    # 设置窗口高度
    self.height = 32 + (text.size) * @WLH
  end
  
    
    
    
    
end
