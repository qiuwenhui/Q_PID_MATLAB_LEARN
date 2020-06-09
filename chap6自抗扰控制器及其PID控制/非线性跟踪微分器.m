clear all;
close all;

h=0.001;  %Sampling time
delta=150;
r1_1=0;r2_1=0;
vn_1=0;
for k=1:1:10000
time(k)=k*h;

v(k)=sin(2*pi*k*h); %输入信号
n(k)=0.05*rands(1); %干扰0
vn(k)=v(k)+n(k); %叠加信号
dv(k)=2*pi*cos(2*pi*k*h); %理想 微分求导后的函数

r1(k)=r1_1+h*r2_1;   %
r2(k)=r2_1+h*fst(r1_1-v(k),r2_1,delta,h);  %非线线性跟踪

dvn(k)=(vn(k)-vn_1)/h;   %By difference  差分求导

vn_1=vn(k);

r1_1=r1(k);
r2_1=r2(k);
end
figure(1);
subplot(211);
plot(time,v,'k:',time,vn,'r:','linewidth',2);
xlabel('time(s)'),ylabel('signal');
legend('ideal signal','signal with noise');
subplot(212);
plot(time,v,'k:',time,r1,'r:','linewidth',2);
xlabel('time(s)'),ylabel('signal');
legend('ideal signal','signal by TD');

figure(2);
subplot(211);
plot(time,dv,'k:',time,dvn,'r:','linewidth',2);
xlabel('time(s)'),ylabel('derivative signal');
legend('ideal derivative signal','derivative signal by difference');
subplot(212);
plot(time,dv,'k:',time,r2,'r:','linewidth',2);
xlabel('time(s)'),ylabel('derivative signal');
legend('ideal derivative signal','derivative signal by TD');