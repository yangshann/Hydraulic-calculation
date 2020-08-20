function [h1] = f_x_ssdm(q, E0, phi, g)
%%计算收缩断面水深

%%1.试算结果
hc = 0.001:0.001:10;
E = hc + q^2./(2*g*phi^2*hc.^2);

%%2.最小差值
beta = abs(E-E0);  %差值
[y,x] = min(beta);  %x：最小差值位置，y：最小差值

h1 = hc(x);

end
