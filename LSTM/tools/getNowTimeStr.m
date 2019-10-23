%获取当前时间时间戳
function nowtimestr = getNowTimeStr()
    nowtime = fix(clock);
    nowtimestr = sprintf('%d-%d-%d %d:%d:%d',nowtime(1),nowtime(2),nowtime(3),nowtime(4),nowtime(5),nowtime(6));
end