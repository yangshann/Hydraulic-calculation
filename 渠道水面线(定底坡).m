%%参照溢洪道设计规范SL253-2018
%%适用定底坡情况下特定断面的水力参数及水面线

clc
clear

%%基础参数
Q = 26;  %%流量
n = 0.0017;  %%糙率
b = 8.3;  %%底宽
hmax = 0.92;  %%起算水深
hmin = 0.1;  %%止算水深
Ld = 59.64;  %%所求断面位置

i = 0.35;  %%底坡

xi = 1.1;  %%掺气水深修正系数，1.0~1.4，流速大者取大值

filename = "save_data.txt";  %%输出文件名

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

%%计算结果输出到文件%%

fid = fopen(filename,'w+');  %打开文件（覆盖原文件内容，若文件不存在则创建）

%%确定断面水深值
x = l;  %%断面位置
y1 = h;  %水深
y2 = v;  %%流速
hd = interp1(x,y1,Ld,'linear');  %%断面水深
vd = interp1(x,y2,Ld,'linear');  %%断面流速
hb = (1+xi*vd/100)*hd;  %%掺气后水深

fprintf(fid,'l = %d , h = %d , v = %d , hb = %d.\t',Ld,hd,vd,hb);
fprintf(fid,'\r\n\r\n');  %空一行

%%试算过程输出
fprintf(fid,'The trial process as follow:\t \r\n');
fprintf(fid,'l,h\t \r\n');
for k = 1:length(h)
	fprintf(fid,'%d \t',l(k));
	fprintf(fid,'%d \t',h(k));
	fprintf(fid,'\r\n');  %换行
end

fclose(fid);  %关闭文件

%%计算结果输出到命令窗口
Ld,hd,vd,hb
