clear all 
close all
clc
%%
%model param
global Ks Ysx GAMAin MUmax T0 
Ks = 0.012;
Ysx = 0.5;
GAMAin = 100;
MUmax = 0.55;

block_sample_time = 0.1;
%C = H
%PID
%pid linear model optimization
% Kp = 1.0703;
% Ti=0.0242;
% Td=0.4397;
%pid genetic algorithm
Kp = 0.6502;
Ti=0.0556;
Td=0.5184;
b=0.2352;
c=0.7181;
N = 0.4832;
T0=0.0056;
bi1=Kp*T0/Ti;
bi2 = 0;
ad = Td/(Td + N*T0);
bd = Kp*Td*N/(Td + N*T0);
%%
%PID sensitivity
load datae
z = tf('z', T0);

upr = Kp * b;
uir = (bi1 + bi2 * z^-1) / (1 - z^-1);
udr = (bd * (1 - z^-1) * c) / (1 - ad*z^-1);
Ur = upr + uir + udr;

upy = Kp;
uiy = uir;
udy = (bd * (1 - z^-1)) / (1 - ad * z^-1);
Uy = upy + uiy + udy;

m=armax(datae,[3 3 3 1]);
sys_ss = ss(m, 'augmented'); 

systemnames = 'sys_ss Ur Uy';
inputvar = '[ref;noise]';
outputvar = '[Ur+Uy;sys_ss;ref-sys_ss]'; 
input_to_sys_ss = '[Ur+Uy;noise]';
input_to_Ur = '[ref]';
input_to_Uy = '[-sys_ss]';
clpPID = sysic; 

%sensitivity function
w=logspace(-3,3,1000);
figure()
sigma(clpPID(3,1), w, 'k'), grid
xlim([0.001 pi/0.0056])

%complementary sensitivity function
w=logspace(-3,3,1000);
figure()
sigma(clpPID(2,1), w, 'k'), grid
xlim([0.001 pi/0.0056])
%output sensitivity function
figure()
sigma(clpPID(1,1), w, 'k'), grid
