%%需要f_t_ss.m文件

clc
clear
addpath(genpath(pwd))

%%数据%%

%%堰型
xs = 1;  %%1：a型驼峰堰，相对较缓；2：b型驼峰堰，相对较陡
K = 0.19;  %%闸墩形状影响系数（侧收缩系数），矩形取0.19，圆弧取0.10

%%数据
g = 9.81;

P1 = 0.6;  %%堰高，从底板计
B = 17;  %%总净宽，计算流量时用到
b = 17;  %%堰孔宽度，计算侧收缩系数时用到
B1 = 25;  %%堰上游引水渠宽度，计算侧收缩系数时用到

v = 0;  %%行近流速

hmin = 0.1;  %%起算水深
hmax = 5;  %%止算水深



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%以下计算过程请谨慎修改%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



h = hmin:0.1:hmax;
for i = 1:length(h)
	[Q(i), m(i), epsilon(i)] = f_t_ss(h(i),xs,K,g,P1,B,b,B1,v);
end

%%计算结果输出到文件%%

fid = fopen('save_date.txt','w+');  %打开文件（覆盖原文件内容，若文件不存在则创建）

fprintf(fid,'H \t m \t epsilon \t Q \t \t \r\n');  %抬头

for k = 1:length(h)
	fprintf(fid,'%d \t',h(k));
	fprintf(fid,'%d \t',m(k));
	fprintf(fid,'%d \t',epsilon(k));
	fprintf(fid,'%d \t',Q(k));
	fprintf(fid,'\r\n');  %换行
end

fclose(fid);  %关闭文件
