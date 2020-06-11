function [sys,x0,str,ts] = spacemodel(t,x,u,flag)
    switch flag,
    case 0,
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 1,
        sys=mdlDerivatives(t,x,u);
    case 3,
        sys=mdlOutputs(t,x,u);
    case {1,2,4,9}
        sys=[];
    otherwise
        error(['Unhandled flag = ',num2str(flag)]);
    end
    function [sys,x0,str,ts]=mdlInitializeSizes
    global c bn
    sizes = simsizes;
    sizes.NumContStates  = 0;
    sizes.NumDiscStates  = 0;
    sizes.NumOutputs     = 1;
    sizes.NumInputs      = 4;
    sizes.DirFeedthrough = 1;
    sizes.NumSampleTimes = 0;
    sys = simsizes(sizes);
    x0  = [];
    str = [];
    ts  = [];
    function sys=mdlOutputs(t,x,u)
    xd=0.1*sin(t);
    dxd=0.1*cos(t);
    ddxd=-0.1*sin(t);
    
    e=u(1); %差值 输入信号 和反馈差值
    de=u(2); %差值求导
    fx=u(3); %控制对象的动态方程
    gx=u(4); %控制对象的 动态方程
    
    kp=25;
    kd=10;
    ut=1/gx*(-fx+ddxd+kp*e+kd*de);  % PD的控制律
    
    sys(1)=ut;