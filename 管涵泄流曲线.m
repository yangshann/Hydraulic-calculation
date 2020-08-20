%%按明渠均匀流计算管涵流量曲线
%%输出参数:theta,水面与圆心夹角的一半;h,水深;Q,计算流量

clc
clear

%% 一、参数
i = 0.05;  %纵坡
n = 0.017;  %糙率

d = 2;  %直径



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%以下计算过程请谨慎修改%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



r = d/2;  %%半径

theta  = 0:0.01:pi;  %水面与圆心夹角的一半

h = r - r.*cos(theta);

Ad =  pi*r.^2; %管涵断面面积

A = 2*r.*theta - r.*cos(theta)*r.*sin(theta);  %过水断面面积
L = 2*r*theta;  %湿周
R = A./L;  %水力半径
C = R.^(1/6)/n;  %谢齐系数

%%计算流量
Q = A.*C.*(R*i).^0.5;

%%三、输出
fid = fopen('save_date.txt','w+');  %打开文件（覆盖原文件内容，若文件不存在则创建）

fprintf(fid,'theta \t h \t Q \t \r\n');  %标题

for k = 1:length(theta)
	fprintf(fid,'%.2f \t',theta(k));
  	fprintf(fid,'%.2f \t',h(k));
	fprintf(fid,'%.2f \t',Q(k));
	fprintf(fid,'\r\n');  %换行
end

fclose(fid);  %关闭文件
