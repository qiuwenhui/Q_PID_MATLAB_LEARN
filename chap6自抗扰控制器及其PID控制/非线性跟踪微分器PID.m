
if mod(k,100)==1|mod(k,100)==2
    yp(k)=p(k)+d(k);     %Practical signal      
else
    yp(k)=p(k);
end

M=2;
if M==1         %By Difference
    y(k)=yp(k);
    dy(k)=(yp(k)-yp_1)/h;  %差分求导  导出速度
elseif M==2     %By TD
    delta=1000;
    y(k)=y_1+h*dy_1;
    dy(k)=dy_1+h*fst(y_1-yp(k),dy_1,delta,h);  %非线性微分器   距离导出速度
end    
kp=10;kd=0.5;
u(k)=kp*(yd(k)-y(k))+kd*(dyd(k)-dy(k));  %PD控制

y_1=y(k);
yp_1=yp(k);
dy_1=dy(k);

u_2=u_1;u_1=u(k);
p_2=p_1;p_1=p(k);
end	
figure(1);
plot(time,p,'k',time,yp,'r:',time,y,'b:','linewidth',2);
xlabel('time(s)');ylabel('position tracking');
legend('ideal position signal','position signal with noise','position signal by TD');
figure(2);
plot(time,yd,'k',time,p,'r:','linewidth',2);
xlabel('time(s)');ylabel('Position tracking');
legend('ideal position signal','tracking signal');