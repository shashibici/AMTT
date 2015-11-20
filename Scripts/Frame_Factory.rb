#==============================================================================
# ■ FrameFactory   V1.0
#
# by: shashibici 2014/12/17
#
#------------------------------------------------------------------------------
#  本模组载入所有图像，建立并保存Bitmap物件。为加快载入速度并节省内存，
#  本模组将以建立的bitmap物件保存在内部哈希表中，使得程序在需求已存在
#  的图像时能快速读取bitmap物件。
#==============================================================================

module FrameFactory
  
  #--------------------------------------------------------------------------
  # * Load bitmap
  #--------------------------------------------------------------------------
  def self.getBitmap(folder_name, filename, hue = 0)
    @cache = {} if @cache == nil
    # create path    
    path = folder_name + filename
    # if no bitmap, then create one.
    if not @cache.include?(path) or @cache[path].disposed?
      if filename.empty?
        @cache[path] = Bitmap.new(32, 32)
      else
        @cache[path] = Bitmap.new(path)
      end
    end
    # if hue is 0, then just return it.
    if hue == 0
      return @cache[path]
    else
      key = [path, hue]
      if not @cache.include?(key) or @cache[key].disposed?
        @cache[key] = @cache[path].clone
        # change a bitmap's hue with a given hue.
        @cache[key].hue_change(hue)
      end
      return @cache[key]
    end
  end

  #--------------------------------------------------------------------------
  # * Load bitmap with size
  # w:  width
  # h:  height
  #--------------------------------------------------------------------------
  def self.getBitmapWithSize(w, h, folder_name, filename, hue = 0)
    @sizedCache = {} if @sizedCache == nil
    path = folder_name + filename
    if not @sizedCache.include?([w.to_s(10), h.to_s(10), path]) or 
      @sizedCache[[w.to_s(10), h.to_s(10), path]].disposed?
      if filename.empty?
        width = 32
        height = 32
        @sizedCache[[width.to_s(10), height.to_s(10), path]] = Bitmap.new(width, height)
      else
        tmpBitmap = getBitmap(folder_name, filename, hue)
        tmpBitmap2 = extractBitmap(tmpBitmap, tmpBitmap.rect, w, h)
        @sizedCache[[w.to_s(10), h.to_s(10), path]] = tmpBitmap2
      end
    end
      
    # if hue is 0, then just return it.
    if hue == 0
      return @sizedCache[[w.to_s(10), h.to_s(10), path]]
    else
      key = [w.to_s(10), h.to_s(10), path, hue]
      if not @sizedCache.include?(key) or @sizedCache[key].disposed?
        @sizedCache[key] = @sizedCache[[w.to_s(10), h.to_s(10), path]].clone
        # change a bitmap's hue with a given hue.
        @sizedCache[key].hue_change(hue)
      end
      return @sizedCache[key]
    end  
  end
  
  #--------------------------------------------------------------------------
  # * Extract from a bitmap.
  #
  #   Given a src_bitmap to extract from.
  #   Given a rect describing the extracted rectangle
  #   Given w and h as width and height of the resulting bitmap rect. 
  #
  #   Return a extracted bitmap, its rect should excactly be like rectangle
  #   that is given.
  #--------------------------------------------------------------------------
  def self.extractBitmap(src_bitmap, rect, w, h)
    b1 = Bitmap.new(w, h)
    b1.stretch_blt(b1.rect, src_bitmap, rect)
    return b1
  end
  #--------------------------------------------------------------------------
  # * 获取icon图片,battler的小图标也是通过这个函数获得
  #     filename : 文件名
  #     hue      : 色调
  #--------------------------------------------------------------------------
  def self.icon(filename, hue)
    load_bitmap("Graphics/Icons/", filename, hue)
  end
end
