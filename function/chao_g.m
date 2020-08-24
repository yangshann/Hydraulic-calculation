function [e, Rp] =  chao_g(sk, K, g, m, P, W, D, H, Hm, beta, Kdelta)
# 用于计算波浪爬高,参考《碾压土石坝设计规范SL274-2001》
# 输入参数含义请参考"安全超高.m"
# e:风雍水面高;Rp:累计频率下波浪爬高



%%风雍水面高度计算
e = K*W^2*D/(2*g*Hm)*cos(beta);  %风雍水面高度



%%平均波高hm(m)、平均波周期Tm(s)、平均波长Lm(m)
# 采用莆田试验站公式
if sk == 1
    temp = 0.13*tanh(0.7*(g*Hm/W^2)^0.7);
    hm = ((temp*tanh(0.0018*(g*D/W^2)^0.45/temp)) * (W^2/g));
    Tm = 4.438*hm^0.5;
#     Lm = g*Tm^2/(2*pi)*tanh(2*pi*H/Lm);
    Lm = g*Tm^2/(2*pi);


# 采用鹤地水库公式
# 当hm/Hm > 0.2时超过计算范围,建议选择莆田实验站公式(下同)
elseif sk == 2
    # h2(m):累计频率为2%的波高
    h2 = 0.00625*W^(1/6)*(g*D/W^2)^(1/3) * (W^2)/g;
    # 表 A.1.8仅有hm/Hm <=0.2 范围内的比值,且定义域内hm值有重合,重合处采取hm较大值,下同
    if h2 < 0.1*2.12*Hm
        hm = h2/2.23;
    elseif h2 > 0.1*2.12*Hm && h2 < 0.2*2.12*Hm
        hm = h2/2.12;
    else
        error('hm is error, please select other sk')
    end
    Lm = 0.0386*(g*D/W^2)^(1/2) * (W^2/g);
    
    
# 采用官厅水库公式
# 当gD/W^2<20或>1000时不应采用此公式
elseif sk == 3
    hx = 0.0076*W^(-1/12)*(g*D/W^2)^(1/3) * (W^2/g);
    if g*D/W^2 >= 20 && g*D/W^2 <= 250
         if hx < 0.1*1.87*Hm
            hm = hx/1.87;
        elseif hx > 0.1*1.87*Hm && hx < 0.2*1.87*Hm
            hm = hx/1.96;
        else
            error('hm is error, please select other sk')
        end
    elseif g*D/W^2 >= 250 && g*D/W^2 <= 1000
        if hx < 0.1*1.64*Hm
            hm = hx/1.64;
        elseif hx > 0.1*1.64*Hm && hx < 0.2*1.64*Hm
            hm = h2/1.71;
        else
            error('hm is error, please select other sk')
        end
    else
        error('hm is error, please select other sk');
    end
    Lm = 0.331*W^(-1/2.15)*(g*D/W^2)^(1/3.75) * (W^2/g);
end



%%查表得Kw（经验系数）
if W/(g*H)^0.5 <= 1
	Kw = 1;
elseif W/(g*H)^0.5 >= 5
	Kw = 1.3;
else
	%表格数据
	x = [1,1.5,2,2.5,3,3.5,4,5];  %W/(g*H)^0.5
	y = [1,1.02,1.08,1.16,1.22,1.25,1.28,1.3];  %Kw
	Kw = interp1(x,y,W/(g*H)^0.5,'linear');
end

# 斜向来波折减系数Kbeta
x = [0 10 20 30 40 50 60];
y = [1 0.98 0.96 0.92 0.87 0.82 0.76];
Kbeta = interp1(x,y,beta/pi*180,'linear');




%%平均波浪爬高:Rm
# m = 1.5~5
if m>=1.5 && m<=5
	%%平均波浪爬高Rm
	Rm = Kdelta*Kw*(hm*Lm)^0.5/(1+m^2)^0.5;


# m <= 1.25
elseif m <= 1.25
    %%表格数据:R0
	x = [0,0.5,1,1.25];  %m
	y = [1.24,1.45,2.2,2.5];  %R0
	R0 = interp1(x,y,m,'linear');  %无风情况下，平均波高hm=1m时，光滑不透水护面的爬高值
	
	%%平均波浪爬高:Rm
	Rm = Kdelta*Kw*R0*hm;
	
	
# m > 1.25 && m < 1.5,由m = 1.25和m = 1.5的平局波浪爬高值内插得到
elseif m > 1.25 && m < 1.5
	%%m=1.25时的波浪爬高
	R0 = 2.5;  %m = 1.25，查表得
	Rm1 = Kdelta*Kw*R0*hm;  %平均波浪爬高
	
	%%m=1.5时的波浪爬高
	Rm2 = Kdelta*Kw*(hm*Lm)^0.5/(1+1.5^2)^0.5;  %平均波浪爬高
	
	%%平均波浪爬高计算
	x = [1.25,1.5];  %坝坡插值范围
	y = [Rm1,Rm2];  %插值上下限平均波浪爬高
	
	Rm = interp1(x,y,m,'linear');  %平均波浪爬高
end



%%不同累计频率下的爬高Rp(m)
%% 不同累积频率下的爬高与平均爬高比值
pe = [0.1 1 2 4 5 10 14 20 30 50];  %P(%)，累计频率
sce = [2.66 2.23 2.07 1.9 1.84 1.64 1.53 1.39 1.22 0.96;
2.44 2.08 1.94 1.8 1.75 1.57 1.48 1.36 1.21 0.97;
2.13 1.86 1.76 1.65 1.61 1.48 1.39 1.31 1.19 0.99];  %不同累计频率下爬高爬高与平均爬高的比值

%%不同累计频率下爬高与平均爬高比值
if hm/H < 0.1
	sc = interp1(pe,sce(1,:),P,'linear');
elseif hm/H >= 0.1 && hm/H <= 0.3
	sc = interp1(pe,sce(2,:),P,'linear');
else
	sc = interp1(pe,sce(3,:),P,'linear');
end


# 对应累计频率下的波浪爬高Rp(m)
Rp = Kbeta*sc*Rm;
 
end
