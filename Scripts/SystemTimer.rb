#==============================================================================
# 本脚本来自www.66RPG.com，使用和转载请保留此信息
# 需要测试脚本运行效率时候可以使用，在正式游戏里关闭
#============================================================================== 
# ------------------------------------------------------------------------
# 高精度计时器 by FantasyDR
# ------------------------------------------------------------------------
# E-mail: fnd@163.net
# ------------------------------------------------------------------------
# 2005.10.18
# ------------------------------------------------------------------------
# 该类已经被定义为全局变量 $sys_timer
# 如果只需要精确到毫秒，请设置初始化参数为true
# decimal属性设置返回时间值的小数位数。
# ------------------------------------------------------------------------
# 下面是一些有用的方法列表，调用时写：$sys_timer.方法名
# 例如 $sys_timer.clear()
# ------------------------------------------------------------------------
# clear() ：计时器清零
# now() ：获取当前经过的时间，单位毫秒
# now_s() ：获取当前经过的时间，单位秒
# ------------------------------------------------------------------------
class SystemTimer
	attr_accessor:decimal #小数位数设定，默认为3

def initialize(use_GetTime=false)
	# 初始化，根据系统选择不同精度计时器
	@qpFrequency = Win32API.new("kernel32","QueryPerformanceFrequency",'p','L')
	@qpCounter = Win32API.new("kernel32","QueryPerformanceCounter",'p','L')
	@tGetTime = Win32API.new("winmm","timeGetTime",'','L')

	@decimal=3
	@perf_cnt=" " * 8
	@time_start=" " * 8
	@time_now=" " * 8

	result = @qpFrequency.call(@perf_cnt)

	if use_GetTime
		result = 0
	end

	if result!=0
		@perf_flag=true
	else
		@perf_flag=false
		@perf_cnt=[1000,0].pack('LL')
	end

	#设置时间比例因数
	@time_scale=@perf_cnt.unpack('LL')
	@time_scale[0] /= 1000.0
	@time_scale[1] /= 1000.0

	#起始时间清零
	self.clear()
end

#-=====================-#
# 计时器清零
#-=====================-#
def clear()
	if @perf_flag
		@qpCounter.call(@time_start)
	else
		@time_start=[@tGetTime.call(),0].pack('LL')
	end
end

#-==============================-#
# 获取当前经过的时间，单位毫秒
#-==============================-#
def now()
	now_time = 0.0e1
	now_time += self.timer() - self.start()
	now_time /= self.scale()
	return self.debug(now_time)
end

#-==============================-#
# 获取当前经过的时间，单位秒
#-==============================-#
def now_s()
	now_time = 0.0e1
	now_time += self.timer() - self.start()
	now_time /= (self.scale()*1000) 
	return self.debug(now_time)
end

#-==============================-#
# 帧错...
#-==============================-#
def debug(now_time)
	if @decimal>0
		now_time = (now_time * (10**@decimal)).floor/(10.0**@decimal)
	else
		now_time = now_time.floor
	end
	return now_time

	#以下用于debug模式
	if now_time < 0
		p "Timer Wrong!! Clear...",now_time,\
		@perf_flag,@qpCounter,@tGetTime,
		@time_now.unpack('LL')[0],@time_now.unpack('LL')[1],
		@time_start.unpack('LL')[0],@time_start.unpack('LL')[1]
		self.clear()
		return 0.0
	else
		return now_time
	end
end

#-=====================-#
# 获取时间比例因数
#-=====================-#
def scale()
	return @time_scale[0]+\
	@time_scale[1]*0xffffffff
end

#-=====================-#
# 获取起始滴答数
#-=====================-#
def start()
	return @time_start.unpack('LL')[0]+\
	@time_start.unpack('LL')[1]*0xffffffff
end

#-=====================-#
# 获取当前的嘀哒数
#-=====================-#
def timer()
	if @perf_flag
		@qpCounter.call(@time_now)
	else
		@time_now=[@tGetTime.call(),0].pack('LL')
	end
	return @time_now.unpack('LL')[0]+\
	@time_now.unpack('LL')[1]*0xffffffff
end
end
#-------------------------------------#
# 初始化自身成一个全局变量
#-------------------------------------#
#$sys_timer=SystemTimer.new()
#-------------------------------------#


 

#==============================================================================
# 本脚本来自www.66RPG.com，使用和转载请保留此信息
#============================================================================== 
