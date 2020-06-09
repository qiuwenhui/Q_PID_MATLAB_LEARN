clear all;
close all;
function y=fal(epec,alfa,delta)
    if abs(epec)>delta
        y=abs(epec)^alfa*sign(epec);
    else
        y=epec/(delta^(1-alfa));
end

h=0.001;  %Sampling time

beta1=150;beta2=1.0;
kp=beta1;kd=beta2;

alfa1=0.75;alfa2=1.5;
delta=2*h;

xk=zeros(2,1);
u_1=0;
for k=1:1:1000
time(k)=k*h;

p1=u_1;
p2=time(k);
tSpan=[0 h];
[tt,xx]=ode45('chap6_10plant',tSpan,xk,[],p1,p2);
xk=xx(length(xx),:);
y(k)=xk(1); 
dy(k)=xk(2); 

yd(k)=1.0;
dyd(k)=0;

e1(k)=yd(k)-y(k);
e2(k)=dyd(k)-dy(k);

M=2;
if M==1
    u(k)=kp*fal(e1(k),alfa1,delta)+kd*fal(e2(k),alfa2,delta);   % NPD   非线性PID 控制
elseif M==2
    u(k)=kp*e1(k)+kd*e2(k); % PD
end

u_1=u(k);
end
figure(1);
subplot(211);
plot(time,yd,'r',time,y,'k:','linewidth',2);
legend('ideal position signal','position tracking');
xlabel('time(s)');ylabel('position value');
subplot(212);
plot(time,yd-y,'r','linewidth',2);
xlabel('time(s)'),ylabel('position tracking error');