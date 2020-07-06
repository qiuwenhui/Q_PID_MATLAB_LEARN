clear all;
close all;
global TE G ts
Size=50;  %��������
D=4;      %ÿ�������У����̶���,���ֳ�4��
F=0.5;    %��������
CR=0.9;   %��������

Nmax=30;  %DE�Ż�����

TE=1;     %�ο��켣����TE
thd=0.50;
aim=[TE;thd];%����·���յ�

start=[0;0];%·�����
tmax=3*TE;  %����ʱ��

ts=0.001;  %Sampling time
G=tmax/ts;  %����ʱ��ΪG=3000
%***************���߲ο��켣*************%
th0=0;
dT=TE/1000; %��TE��Ϊ1000���㣬ÿ�γ���(����)ΪdT
     
for k=1:1:G
t(k)=k*dT;  %t(1)=0.001;t(2)=0.002;.....
if t(k)<TE
    thr(k)=(thd-th0)*(t(k)/TE-1/(2*pi)*sin(2*pi*t(k)/TE))+th0;   %����ԭ��Ĳο��켣(1)
else 
    thr(k)=thd;
end
end
%***************��ʼ��·��**************%
for i=1:Size
    for j=1:D
    Path(i,j)=rand*(thd-th0)+th0;
    end
end

%**********��ֽ�������***************%
for N=1:Nmax
%**************����**************%
    for i=1:Size
        r1=ceil(Size*rand);
        r2=ceil(Size*rand);
        r3=ceil(Size*rand);
        while(r1==r2||r1==r3||r2==r3||r1==i||r2==i||r3==i)%ѡȡ��ͬ��r1,r2,r3���Ҳ�����i
              r1=ceil(Size*rand);
              r2=ceil(Size*rand);
              r3=ceil(Size*rand);
        end
        for j=1:D
            mutate_Path(i,j)=Path(r1,j)+F.*(Path(r2,j)-Path(r3,j));%ѡ��ǰ�벿�ֲ����������
        end
%****************����****************%
        for j=1:D
            if rand<=CR
                cross_Path(i,j)=mutate_Path(i,j);
            else
                cross_Path(i,j)=Path(i,j);
            end
        end
%�Ƚ�������������ֵ����ΪD=4ʱ���������%
        XX(1)=0;XX(2)=200*dT;XX(3)=400*dT;XX(4)=600*dT;XX(5)=800*dT;XX(6)=1000*dT;
        YY(1)=th0;YY(2)=cross_Path(i,1);YY(3)=cross_Path(i,2);YY(4)=cross_Path(i,3);YY(5)=cross_Path(i,4);YY(6)=thd;
        dY=[0 0];
        cross_Path_spline=spline(XX,YY,linspace(0,1,1000));%�����ֵ��Ϻ�����ߣ�ע�ⲽ��nt��һ��,��ʱ���1000����
        YY(2)=Path(i,1);YY(3)=Path(i,2);YY(4)=Path(i,3);YY(5)=Path(i,4);
        Path_spline=spline(XX,YY,linspace(0,1,1000));
%***   ����ָ�겢�Ƚ�***%
        for k=1:1000        
            distance_cross(i,k)=abs(cross_Path_spline(k)-thr(k));          %���㽻���Ĺ켣��ο��켣�ľ���ֵ
            distance_Path(i,k)=abs(Path_spline(k)-thr(k));                 %�����ֵ��Ĺ켣��ο��켣�ľ���ֵ
        end
        new_object    = chap10_6obj(cross_Path_spline,distance_cross(i,:),0);   %���㽻��������������ͼ�·���ƽ����ֵ�ĺ�
        formal_object = chap10_6obj(Path_spline,distance_Path(i,:),0);          %�����ֵ�������������ͼ�·���ƽ����ֵ�ĺ�

%%%%%%%%%%  ѡ���㷨  %%%%%%%%%%%
        if new_object<=formal_object
            Fitness(i)=new_object;
            Path(i,:)=cross_Path(i,:);
        else
            Fitness(i)=formal_object;
            Path(i,:)=Path(i,:);
        end
    end
    [iteraion_fitness(N),flag]=min(Fitness);%���µ�NC�ε�������С��ֵ����ά��
    
    lujing(N,:)=Path(flag,:)               %��NC�ε��������·��
    fprintf('N=%d Jmin=%g\n',N,iteraion_fitness(N));    
end
[Best_fitness,flag1]=min(iteraion_fitness);
Best_solution=lujing(flag1,:);
YY(2)=Best_solution(1);YY(3)=Best_solution(2);YY(4)=Best_solution(3);YY(5)=Best_solution(4);

Finally_spline=spline(XX,YY,linspace(0,1,1000));
chap10_6obj(Finally_spline,distance_Path(Size,:),1);

figure(3);
plot((0:0.001:1),[0,thr(1:1:1000)],'k','linewidth',2);
xlabel('Time (s)');ylabel('Ideal Path');
hold on;
plot((0:0.2:1), YY,'ko','linewidth',2);
hold on;
plot((0:0.001:1),[0,Finally_spline],'k-.','linewidth',2);
xlabel('Time (s)');ylabel('Optimized Path');
legend('Ideal Path','Interpolation points','Optimized Path');

figure(4);
plot((1:Nmax),iteraion_fitness,'k','linewidth',2);
xlabel('Time (s)');ylabel('Fitness Change');