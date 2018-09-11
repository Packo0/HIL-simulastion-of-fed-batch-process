close all
clear all
clc

%%
% 
load datae
load datav
  
% figure(1),plot(datae,'r',datav,'b'),grid

m=armax(datae,[3 3 3 1]);
sys_ss = ss(m,'augmented');

A = sys_ss.A;
B = sys_ss.B(:,1);
C = sys_ss.C;
D = sys_ss.D(1);
T0=0.0056;

A1=[1 -T0*C;
    zeros(3,1) A];
B1=[0;
    B];

Q = [1000 0 0 0;0 0 0 0;0 0 0 0;0 0 0 0.01*0.25];
R =1;

[K1, S, e] = dlqr(A1, B1, Q, R);

Kal=kalman(sys_ss,m.NoiseVariance,0.1);

Kp=K1(2:4);
Ki=-K1(1);

%sensitivity functions
integratord = c2d(tf([1],[1 0]),0.0056);
systemnames = 'sys_ss Kal Kp Ki integratord';
inputvar = '[ref;noise]';
outputvar = '[sys_ss;Ki-Kp;ref-sys_ss]'; 
input_to_sys_ss = '[Ki-Kp;noise]';
input_to_Kal = '[Ki-Kp;sys_ss]';
input_to_Kp = '[Kal(2:4)]';
input_to_Ki = '[integratord]';
input_to_integratord = '[ref-sys_ss]';
clpLQR = sysic; 

%sensitivity function
figure()
sigma(clpLQR(3,1), 'k'),grid

%complementary sensitivity function
figure()
sigma(clpLQR(1,1), 'k'),grid

%output sensitivity function
figure()
sigma(clpLQR(2,1), 'k'),grid
