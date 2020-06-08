%给出输入信号  求导数 

close all;
clear all;
T=0.001;
y_1=0;dy_1=0;
yv_1=0;
v_1=0;
for k=1:1:6000
t=k*T;
time(k)=t;

v(k)=sin(t);   % 输入的理想位置信号
dv(k)=cos(t);  % 理想速度的位置求导 

d(k)=0.01*rands(1);   %Noise  噪声
yv(k)=v(k)+d(k);      %Practical signal  叠加噪声的 位置信号
    
R=1/0.01;a0=0.1;b0=0.1;

y(k)=y_1+T*dy_1;   %  线性微分器输出 x1  求出的 信号值  的值

dy(k)=dy_1+T*R^2*(-a0*(y(k)-yv(k))-b0*dy_1/R);  %位置 求导的 x2

dyv(k)=(yv(k)-yv_1)/T;    %Speed by Difference  用差分方法求导的输出
    
y_1=y(k);
v_1=v(k);
yv_1=yv(k);
dy_1=dy(k);
end	
figure(1);
subplot(211);
plot(time,v,'r',time,yv,'k:','linewidth',2);
xlabel('time(s)');ylabel('sigal');
legend('ideal signal','signal with noise');  %理想输入信号  叠加噪声的输入信号

subplot(212);
plot(time,v,'r',time,y,'k:','linewidth',2);
xlabel('time(s)');ylabel('sigal');
legend('ideal signal','signal by TD');

figure(2);
subplot(211);
plot(time,dv,'r',time,dyv,'k:','linewidth',2);
xlabel('time(s)');ylabel('derivative signal');
legend('ideal derivative signal','derivative signal by Difference');  % 理想求导值    与 差分求导的值

subplot(212);
plot(time,dv,'r',time,dy,'k:','linewidth',2);
xlabel('time(s)');ylabel('derivative signal');
legend('ideal derivative signal','derivative signal by TD');  %  理想求导值  与  全程微分求导的值