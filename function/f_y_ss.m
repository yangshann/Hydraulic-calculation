function [hd, vd, hb] = f_y_ss(Q, n, b, hmin, hmax, Ld, i, xi)
%%计算指定断面水深，适用于溢洪道泄槽段
%%输入数据数据意义请查看:溢洪道水面线(变底坡)

%%分段长度计算%%

h = hmin:0.001:hmax;  %%水深变量
h = fliplr(h);

%%平均水力坡降
R = b.*h./(b+2*h);  %%水力半径
v = Q./(b.*h);  %%流速

for ii = 1:(length(h)-1)
	vr = (v(ii)+v(ii+1))/2;  %%流速平均值，第i段
	Rr = (R(ii)+R(ii+1))/2;  %%水力半径平均值，第i段
	Jr(ii) = n^2*vr^2/Rr^(4/3);  %%平均水力坡降，第i段
end

tcos = (1-i^2)^0.5;  %%临时参数，cos

for ii = 1:(length(h)-1)
	Betal(ii) = ((h(ii+1)*tcos+1.05*v(ii+1)^2) - (h(ii)*tcos+1.05*v(ii)^2))./(i-Jr(ii));  %%各分段长度
end

%%对应高度位置的长度
l(1) = 0;
for ii = 2:length(h)
	l(ii) = sum(Betal(1:ii-1));
end

%%计算结果%%

%%确定断面水深值
x = l;  %%断面位置
y1 = h;  %水深
y2 = v;  %%流速
hd = interp1(x,y1,Ld,'linear');  %%断面水深
vd = interp1(x,y2,Ld,'linear');  %%断面流速
hb = (1+xi*vd/100)*hd;  %%掺气后水深

end
