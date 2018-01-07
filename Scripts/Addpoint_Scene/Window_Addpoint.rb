##==========================================================================
# ■ Window_Addpoint1
#---------------------------------------------------------------------------
#     本窗口用来显示英雄的详细信息 
#
#===========================================================================
class Window_Addpoint1 < Window_Base
  include GAME_CONF
  WLH = 32
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #--------------------------------------------------------------------------
  def initialize(x,y)
    @title_width = 128
	@data_width = 200
	@arrow_width = 128
    super(x, y, $screen_width-x, WLH*14+32)
    self.opacity = 255
    self.contents.font.size = 22
    @isInit = true
  end
  
  #--------------------------------------------------------------------------
  # ● 配置
  #     actor : 角色(monstor或hero)
  #--------------------------------------------------------------------------
  def setup(actor)
      @hero = actor
      @type = actor.type                   # 英雄的主属性
  #=======以下是描述英雄能力的各个属性====================
      @hmaxhp = Fround(actor.self_maxhp,2)       # 生命
      @hmaxmp = Fround(actor.self_maxmp,2)       # 魔法
      @hatk = Fround(actor.self_atk,2)         # 攻击
      @hdef = Fround(actor.self_def,2)         # 护甲
  
      @strength = Fround(actor.self_strength,2)     # 力量
      @celerity = Fround(actor.self_celerity,2)     # 敏捷
      @wisdom = Fround(actor.self_wisdom,2)       # 智力
  
      @destroy = Fround(actor.self_destroy,2)      # 物理破坏力因子
  
      @mdestroy = Fround(actor.self_mdestroy,2)     # 魔法破坏力因子

      @atkspeed = Fround(actor.self_atkspeed,2)     # 攻速因子
  
      @eva = Fround(actor.self_eva, 2)  # 闪避因子
  
      @hit = Fround(actor.self_hit,2)  # 命中因子
  
      @hpcover = Fround(actor.self_hpcover,2)      # 生命恢复因子
      
      @mpcover = Fround(actor.self_mpcover,2)      # 魔法恢复因子
  

  end 
  #--------------------------------------------------------------------------
  # ● 重新绘制该窗口
  #
  #--------------------------------------------------------------------------
  def refresh
    # 重新配置
    setup(@hero)

    color1 = system_color
    color2 = getColor("white")

    draw_a_line(color1, 0,   WLH*0, @title_width, WLH, "生命:", 0)
    draw_a_line(color2, @title_width,  WLH*0, @data_width, WLH, @hmaxhp, 0)
    
    draw_a_line(color1, 0,   WLH*1, @title_width, WLH, "魔法:",  0)
    draw_a_line(color2, @title_width,  WLH*1, @data_width, WLH, @hmaxmp, 0)
    
    draw_a_line(color1, 0,   WLH*2, @title_width, WLH, "HP恢复:", 0)
    draw_a_line(color2, @title_width,  WLH*2, @data_width, WLH, @hpcover, 0)
    
    draw_a_line(color1, 0,   WLH*3, @title_width, WLH, "MP恢复:",  0)
    draw_a_line(color2, @title_width,  WLH*3, @data_width, WLH, @mpcover, 0)
    
    draw_a_line(color1, 0,   WLH*4, @title_width, WLH, "攻击:", 0)
    draw_a_line(color2, @title_width,  WLH*4, @data_width, WLH, @hatk   , 0)
    
    draw_a_line(color1, 0,   WLH*5, @title_width, WLH, "防御:",  0)
    draw_a_line(color2, @title_width,  WLH*5, @data_width, WLH, @hdef, 0)
    
    draw_a_line(color1, 0,   WLH*6, @title_width, WLH, "力量:",  0)
    draw_a_line(color2, @title_width,  WLH*6, @data_width, WLH, @strength, 0)
    
    draw_a_line(color1, 0,   WLH*7, @title_width, WLH, "智力:",  0)
    draw_a_line(color2, @title_width,  WLH*7, @data_width, WLH, @wisdom, 0)
    
    draw_a_line(color1, 0,   WLH*8, @title_width, WLH, "敏捷:",  0)
    draw_a_line(color2, @title_width,  WLH*8, @data_width, WLH, @celerity, 0)

    
    draw_a_line(color1, 0,   WLH*9, @title_width, WLH, "物理伤害：",  0)
    draw_a_line(color2, @title_width,  WLH*9, @data_width, WLH, @destroy, 0) 
        
    draw_a_line(color1, 0,   WLH*10, @title_width, WLH, "魔法伤害：",  0)
    draw_a_line(color2, @title_width,  WLH*10, @data_width, WLH, @mdestroy, 0)

    draw_a_line(color1, 0,   WLH*11, @title_width, WLH, "攻击速度：",  0)
    draw_a_line(color2, @title_width,  WLH*11, @data_width, WLH, @atkspeed, 0)    
    
    draw_a_line(color1, 0,   WLH*12, @title_width, WLH, "命中技巧：", 0)
    draw_a_line(color2, @title_width,  WLH*12, @data_width, WLH, @hit   , 0)
    
    draw_a_line(color1, 0,   WLH*13, @title_width, WLH, "闪避技巧：",  0)
    draw_a_line(color2, @title_width,  WLH*13, @data_width, WLH, @eva, 0)
    
    i = 0
    while i < 14
      draw_a_line(color2, @title_width+@data_width,  WLH*i, @arrow_width,  WLH, "→", 1)
      i += 1
    end
    
  end
  #--------------------------------------------------------------------------
  # ● 跟新变动的部分
  #
  #  	size			：	需要绘制的行数
  # 	clone_attr		:	改变后的复制品的属性
  # 	current_attr	:	当前的属性
  #
  #--------------------------------------------------------------------------
  def refresh_improvements(size, clone_attr, current_attr)
      # 画出增值的部分
    for i in 0...size do
      if Fround(clone_attr[i],2) > Fround(current_attr[i],2) 
        # 浅绿色
        color = getColor("green")
        draw_a_line(color, @title_width+@data_width+@arrow_width, WLH*i, 
				self.contents.width-(@title_width+@data_width+@arrow_width), 
				WLH, Fround(clone_attr[i],2), 0) 
      elsif Fround(clone_attr[i],2) < Fround(current_attr[i],2) 
        # 红色
        color = getColor("red")
        draw_a_line(color, @title_width+@data_width+@arrow_width, WLH*i, 
				self.contents.width-(@title_width+@data_width+@arrow_width),  
				WLH, Fround(clone_attr[i],2), 0)
      else
        # 不作绘画
      end
      
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 更新画面
  #--------------------------------------------------------------------------
  def update
    refresh if @isInit == true
    @isInit = false
  end    
  
end
  
#==============================================================================
# ■ Window_Addpoint2
#------------------------------------------------------------------------------
# 　左边显示加点选项的窗口
#==============================================================================

class Window_Addpoint2 < Window_Command
  
	  include GAME_CONF
	  WLH = 32
	  #--------------------------------------------------------------------------
	  # ● 初始化对象
	  #--------------------------------------------------------------------------
	  def initialize(width, commands)
		column_max = 1
		row_max = (commands.size + column_max - 1) / column_max
		spacing = 32
		# width, commands, column_max, row_max, spacing, height
		super(width, commands, column_max, row_max, spacing, row_max * WLH + 32)
		refresh
	  end  
	#--------------------------------------------------------------------------
	# ● 生成窗口内容
	#--------------------------------------------------------------------------
	def create_contents
		self.contents.dispose
		self.contents = Bitmap.new(width - 32, [height - 32, row_max * WLH].max)
	end
	#--------------------------------------------------------------------------
	# ● 获取行头
	#
	#    本页第第一行的行数（从第0行开始计数）
	#
	#--------------------------------------------------------------------------
	def top_row
		return self.oy / WLH
	end
	  
	#--------------------------------------------------------------------------
	# ● 设置本页的第一行
	#     row : 需要显示为本页第一行的那个行（从0行计数）
	#
	#    例如：row=5 则直接将本页跳转至以第五行为首的那一页试图上。
	#
	#--------------------------------------------------------------------------
	def top_row=(row)
		row = 0 if row < 0
		row = row_max - 1 if row > row_max - 1
		self.oy = row * WLH
	end
	  
	#--------------------------------------------------------------------------
	# ● 获取一页显示的行数
	#--------------------------------------------------------------------------
	def page_row_max
		return (self.height - 32) / WLH
	end
	  
	#--------------------------------------------------------------------------
	# ● 获取项目要描画的矩形
	#     index : 项目编号
	#--------------------------------------------------------------------------
	def item_rect(index)
		rect = Rect.new(0, 0, 0, 0)
		rect.width = (contents.width + @spacing) / @column_max - @spacing
		rect.height = WLH
		rect.x = index % @column_max * (rect.width + @spacing)
		rect.y = index / @column_max * WLH
		return rect
	end
	#--------------------------------------------------------------------------
	# ● 刷新
	#--------------------------------------------------------------------------
	def refresh
		self.contents.clear
		self.contents.font.size = 22
		for i in 0...@item_max
		  draw_item(i)
		end
	end
end
  
