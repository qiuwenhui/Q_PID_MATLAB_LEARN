%PD tuning control based on DE
clear all;
close all;
global yd y timef

F=1.20;      % �������ӣ�[1,2]
cr=0.6;      % ��������

Size=30;     % ��������
CodeL=2;     % 
MinX=[0 0];
MaxX=[20 1];  %

for i=1:1:CodeL
    kxi(:,i)=MinX(i)+(MaxX(i)-MinX(i))*rand(Size,1);
end

BestS=kxi(1,:); %ȫ�����Ÿ���
BsJ=0;
for i=2:Size
    if chap10_3plant(kxi(i,:),BsJ)<chap10_3plant(BestS,BsJ)        
        BestS=kxi(i,:);
    end
end
BsJ=chap10_3plant(BestS,BsJ);


%������Ҫѭ����ֱ�����㾫��Ҫ��
G=50; %���������� 
for kg=1:1:G
     time(kg)=kg;
%����
    for i=1:Size
        kx=kxi(i,:);
        r1 = 1;r2=1;r3=1;r4=1;
        while(r1 == r2|| r1 ==r3 || r2 == r3 || r1 == i|| r2 ==i || r3 == i||r4==i ||r1==r4||r2==r4||r3==r4 )
            r1 = ceil(Size * rand(1));
            r2 = ceil(Size * rand(1));
            r3 = ceil(Size * rand(1));
            r4 = ceil(Size * rand(1));
        end
        h(i,:)=BestS+F*(kxi(r1,:)-kxi(r2,:));
        %h(i,:)=X(r1,:)+F*(X(r2,:)-X(r3,:));

        for j=1:CodeL  %���ֵ�Ƿ�Խ��
            if h(i,j)<MinX(j)
                h(i,j)=MinX(j);
            elseif h(i,j)>MaxX(j)
                h(i,j)=MaxX(j);
            end
        end        
%����
        for j = 1:1:CodeL
              tempr = rand(1);
              if(tempr<cr)
                  v(i,j) = h(i,j);
               else
                  v(i,j) = kxi(i,j);
               end
        end
%ѡ��        
        if(chap10_3plant(v(i,:),BsJ)<chap10_3plant(kxi(i,:),BsJ))
            kxi(i,:)=v(i,:);
        end
%�жϺ͸���       
       if chap10_3plant(kxi(i,:),BsJ)<BsJ %�жϵ���ʱ��ָ���Ƿ�Ϊ���ŵ����
          BsJ=chap10_3plant(kxi(i,:),BsJ);
          BestS=kxi(i,:);
        end
    end
    BestS
    kp(kg)=BestS(1);
    kd(kg)=BestS(2);
    
    BsJ
    
BsJ_kg(kg)=chap10_3plant(BestS,BsJ);
end
display('kp,kd');
BestS
 
figure(1);
plot(timef,yd,'r',timef,y,'k:','linewidth',2);
xlabel('Time(s)');ylabel('yd,y');
legend('Ideal position signal','Position tracking');
figure(2);
plot(time,BsJ_kg,'r','linewidth',2);
xlabel('Times');ylabel('Best J');

figure(3);
plot(time,kp,'r',time,kd,'k','linewidth',2);
xlabel('Time(s)');ylabel('kp,kd');
legend('kp','kd');