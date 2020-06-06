
clear;
clc;
newline = sprintf('\n');

disp('This is an F-16 Simulation.');
disp('The simulation will begin by asking you for the flight ');
disp('conditions for which the simulation will be performed.');
disp(newline);
disp('Accpetable values for flight condition parameters are:');
disp(newline);
disp('                                  Model');
disp('              Units   Min     Max     ');
disp('  Altitude:   ft      5000    40000  ');
disp('  AOA         deg    -10      45     ');
disp('  Thrust      lbs     1000    19000   ');
disp('  Elevator    deg    -25.0    25.0   ');
disp('  Aileron     deg    -21.5    21.5   ');
disp('  Rudder      deg    -30      30     ');
disp('  Velocity    ft/s    300     900    0');
disp(newline);
disp(newline);
disp('The flight condition you choose will be used to trim the F16.');
disp('Note:  The trim routine will trim to the desired');
disp('altitude and velocity.  All other parameters');
disp('will be varied until level flight is achieved.  ');
disp('You may need to view the results of the simulation');
disp(' and retrim accordingly.');
disp(newline);
disp(newline);

%% Trim aircraft to desired altitude and velocity
%%
disp('Which condition would you like to trim the aircraft:')
disp('  1. default')
disp('  2. user-defined')
trimflag = input('Your Selection:  ' );

if trimflag == 1;
  altitude=22000;
  velocity=600;
elseif trimflag == 2;
  altitude = input('Enter the altitude for the simulation (ft)  :  ');
  velocity = input('Enter the velocity for the simulation (ft/s):  ');
else
  disp('Invalid selection');
end


%% Initial Conditions for trim routine.
%% Change these values.
thrust = 3000;          % thrust, lbs
elevator = 0 ;       % elevator, degrees
alpha = 0;      % AOA, rad
rudder = 0;         % rudder angle, degrees
aileron = 0;         % aileron, degrees
mass=636.94;
Inertia=[9496,0,982;
        0,55814,0;
        982,0,63100];
TrimParam.SimModel = 'Aircraft';
X0=[velocity,alpha,0,0,0,0,0,0,0,0,0,altitude]';%初始 飞机状态量
U0=[elevator,aileron,rudder,thrust]'; %初始 U=[de da dr p] 
Y0=[velocity,alpha,0,0,0,0,0,0,0,0,0,altitude]';
IX=[1,3,4,6,7,9,11,12]; %alpha q theta x可变化；[Va,alpha,beta,p,q,r,phi,theta,psi,x,y,z]
IU=[2,3];%  de T 可变化

IY=[1,3,4,6,7,9,11,12];%输出量：alpha  theta  xg q可变化
DX=[0 ,0, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,velocity,0 ,0]';%定直平飞，指定状态里变化率
IDX=[1 2 3 4 5 6 7 8 9 10 11 12];%定直平飞，状态里变化率均 不变
[X,U,Y,DX]=trim('Aircraft',X0,U0,Y0,IX,IU,IY,DX,IDX);
formatSpec = 'Trim result: \n altitude:%.3f ft\n velocity:%.3f ft/s\n alpha:%.3f deg \n elev:%.3f deg \n ail:%.3f deg \n rud:%.3f deg \n thrust:%.3f lb\n';
fprintf(formatSpec,X(12),X(1),X(2)*57.3,U(1),U(2),U(3),U(4));
%% 线性化
[A,B,C,D]=linmod(TrimParam.SimModel,X,U);
fprintf('\n');
fprintf('\n*****************Longitudinal dynamics****************');
Alon=sel(A,[1 2 8 5],[1 2 8 5]) %Alon: x=[v,alpha,theta,q] 纵向状态变量 ；[Va,alpha,beta,p,q,r,phi,theta,psi,x,y,z]
Blon=sel(B,[1 2 8 5],[4 1]) % U=[thrust ele]
Clon=sel(C,[1 2 8 5],[1 2 8 5])
Dlon=sel(D,[1 2 8 5],[4 1])
damp(Alon)

fprintf('\n');
fprintf('\n*************Lateral-directional dynamics****************');
Alat=sel(A,[3 7 4 6],[3 7 4 6])%Al:x=[beta,phi,p,r] 
Blat=sel(B,[3 7 4 6],[2 3])% U=[ail rud] 
Clat=sel(C,[3 7 4 6],[3 7 4 6])
Dlat=sel(D,[3 7 4 6],[2 3])
damp(Alat)
%% 非线性模型验证
sim nonlinmodel;
plot3(north,east,high);
xlabel('north/ft');ylabel('east/ft');zlabel('altitude/ft');
figure;subplot(1,2,1);plot(alph);subplot(1,2,2);plot(beta);
figure;subplot(2,3,1);plot(phi);subplot(2,3,2);plot(theta);subplot(2,3,3);plot(psi);
subplot(2,3,4);plot(p);subplot(2,3,5);plot(q);subplot(2,3,6);plot(r);