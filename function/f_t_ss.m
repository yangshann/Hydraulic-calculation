function [Q, m, epsilon] = f_t_ss(H,xs,K,g,P1,B,b,B1,v)
%%用于计算指定水深下驼峰堰的流量
%%参考溢洪道设计规范SL253-2018

H0 = H + v^2/(2*g);  %%堰上行近水头

%%计算流量系数
temp1 = P1/H0;  %%临时参数1：P1/H0

if xs == 1
    if temp1 <= 0.24
	    m = 0.385+0.171*(temp1)^0.657;
    else
	    m = 0.414*temp1^(-0.0652);
    end
elseif xs == 2
    if temp1 <= 0.34
	    m = 0.385 + 0.224*temp1^0.934;
    else
	    m = 0.452*temp1^(-0.032);
    end
end

%%计算侧收缩系数
if b/B1 < 0.2  %%临时参数2：b/B1
	temp2 = 0.2;
else
	temp2 = b/B1;
end

if P1/H0 > 0.3  %%临时参数3：P1/H0
	temp3 = 0.3;
else
	temp3 = P1/H0;
end

epsilon = 1 - K*(1-temp2)*(temp2)^(1/4)/(0.2+temp3)^(1/3);  %%单孔宽顶堰，多孔请参照规范

%%计算流量%%

Q = m*epsilon*B*(2*g)^0.5*H0^(3/2);
end
