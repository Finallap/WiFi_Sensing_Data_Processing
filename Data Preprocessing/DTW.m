function dist=dtw(test,ref)
global x y_min y_max
global t r 
global D d 
global m n 
t=test; 
r =ref; 
n = size(t,1); 
m = size(r,1); 
d = zeros(m,1); 
D = ones(m,1) * realmax; 
D(1) = 0; 
%?如果两个模板长度相差过多，匹配失败?
 if (2*m-n<3)|(2*n-m<2) 
 dist = realmax; 
return 
end 
%?计算匹配区域??
xa = round((2*m-n)/3); 
xb = round((2*n-m)*2/3); 
if xb>xa 
 %xb>xa,?按下面三个区域匹配??
%1:xa
 %?xa+1:xb???
%?xb+1:N??
for x = 1:xa 
y_max = 2*x; 
 y_min = round(0.5*x); 
warp 
end 
for x = (xa+1):n 
 y_max = round(0.5*(x-n)+m); 
 y_min = round(0.5*(x-n)+m); 
 warp 
end 
elseif xa>xb 
 %xa>xb,?按下面三个区域匹配??
 %?0?:xb???
%?xb+1:xa???
%?xa+1:N
for x = 1:xb
 y_max = 2*x; 
 y_min = round(0.5*x); 
 warp 
end 
 for x = (xb+1):xa 
 y_max =2*x;
 y_min = round(2*(x-n)+m); 
warp 
 end 
 for x = (xa+1):n 
 y_max = round(0.5*(x-n)+m); 
y_min = round(2*(x-n)+m); 
warp 
end 
elseif xa==xb 
 %xa=xb,?按下面两个区域匹配??
 %?0?:xa???
%?xa+1:N???
for x = 1:xa 
y_max = 2*x; 
y_min = round(0.5*x); 
 warp 
end
end 
%返回匹配分数?
 dist = D(m);
 function warp 
global x y_min y_max 
global t r 
global D d 
global m n 
d = D; 
for y = y_min:y_max 
D1 = D(y); 
 if y>1 
D2 = D(y-1); 
 else 
D2 = realmax; 
 end 
 if y>2
 D3 = D(y-2); 
else 
D3 = realmax; 
 end 
d(y) = sum((t(x,:)-r(y,:)).^2) + min([D1,D2,D3]); 
end 
D = d;
