clear all 
close all 
clc
%%
% pid controller genetic algorithm
clear all 
close all 
clc

load ga_pid_sim.mat

figure()
plot(time, ga_pid_q_sim, 'k');
grid
title('Control signal')
xlabel('Cultivation time, [h]'), ylabel('Feed rate, [l/h]')

figure()
plot(time, ga_pid_y_sim(:,1), 'k');
grid
title('Biomass concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')

figure()
plot(time, ga_pid_y_sim(:,2), 'k');
grid
title('Glucose concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')

figure()
plot(time, ga_pid_y_sim(:,3), 'k');
grid
title('Bioreactor volume')
xlabel('Cultivation time, [h]'), ylabel('Bioreactor volume, [l]')

%%
% pid controller linear optimization
clear all 
close all 
clc

load pid_sim.mat

figure()
plot(time, pid_q_sim, 'k');
grid
title('Control signal')
xlabel('Cultivation time, [h]'), ylabel('Feed rate, [l/h]')

figure()
plot(time, pid_y_sim(:,1), 'k');
grid
title('Biomass concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')

figure()
plot(time, pid_y_sim(:,2), 'k');
grid
title('Glucose concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')

figure()
plot(time, pid_y_sim(:,3), 'k');
grid
title('Bioreactor volume')
xlabel('Cultivation time, [h]'), ylabel('Bioreactor volume, [l]')

%% 
% lqr controller
clear all 
close all 
clc

load lqr_sim.mat

figure()
plot(time, lqr_q_sim, 'k');
grid
title('Control signal')
xlabel('Cultivation time, [h]'), ylabel('Feed rate, [l/h]')

figure()
plot(time, lqr_y_sim(:,1), 'k');
grid
title('Biomass concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')

figure()
plot(time, lqr_y_sim(:,2), 'k');
grid
title('Glucose concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')

figure()
plot(time, lqr_y_sim(:,3), 'k');
grid
title('Bioreactor volume')
xlabel('Cultivation time, [h]'), ylabel('Bioreactor volume, [l]')

%y and y est
figure()
plot(time, lqr_y_sim(:,1), 'k'); hold on
plot(time, lqr_y__sim_est(:,1), 'k--'); hold off
grid
title('Biomass concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')
legend('Original', 'Estimated')

figure()
plot(time, lqr_y_sim(:,2), 'k'); hold on
plot(time, lqr_y__sim_est(:,2), 'k--'); hold off
grid
title('Glucose concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')
legend('Original', 'Estimated')

figure()
plot(time, lqr_y_sim(:,3), 'k'); hold on
plot(time, lqr_y__sim_est(:,3), 'k--'); hold off
grid
title('Bioreactor volume')
xlabel('Cultivation time, [h]'), ylabel('Bioreactor volume, [l]')
legend('Original', 'Estimated')

%%
clear all
close all
clc
%compare simulation with different controllers
load ga_pid_sim.mat
load pid_sim.mat
load lqr_sim.mat

figure()
plot(time, ga_pid_q_sim, 'b'); hold on
plot(time, pid_q_sim, 'r');
plot(time, lqr_q_sim, 'g'); hold off
grid
title('Control signal')
xlabel('Cultivation time, [h]'), ylabel('Feed rate, [l/h]')
legend('ga pid', 'pid', 'lqr')

figure()
plot(time, ga_pid_y_sim(:,1), 'b'); hold on
plot(time, pid_y_sim(:,1), 'r');
plot(time, lqr_y_sim(:,1), 'g'); hold off
grid
title('Biomass concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')
legend('ga pid', 'pid', 'lqr')

figure()
plot(time, ga_pid_y_sim(:,2), 'b'); hold on
plot(time, pid_y_sim(:,2), 'r');
plot(time, lqr_y_sim(:,2), 'g'); hold off
grid
title('Glucose concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')
legend('ga pid', 'pid', 'lqr')

figure()
plot(time, ga_pid_y_sim(:,3), 'b'); hold on
plot(time, pid_y_sim(:,3), 'r');
plot(time, lqr_y_sim(:,3), 'g'); hold off
grid
title('Bioreactor volume')
xlabel('Cultivation time, [h]'), ylabel('Bioreactor volume, [l]')
legend('ga pid', 'pid', 'lqr')

%%
clear all
close all
clc
%compare simulation with different controllers without noise
load ga_pid_sim_no_noise.mat
load pid_sim_no_noise.mat
load lqr_sim_no_noise.mat

figure()
plot(time, ga_pid_q_sim_no_noise, 'b'); hold on
plot(time, pid_q_sim_no_noise, 'r');
plot(time, lqr_q_sim_no_noise, 'g'); hold off
grid
title('Control signal')
xlabel('Cultivation time, [h]'), ylabel('Feed rate, [l/h]')
legend('ga pid', 'pid', 'lqr')

figure()
plot(time, ga_pid_y_sim_no_noise(:,1), 'b'); hold on
plot(time, pid_y_sim_no_noise(:,1), 'r');
plot(time, lqr_y_sim_no_noise(:,1), 'g'); hold off
grid
title('Biomass concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')
legend('ga pid', 'pid', 'lqr')

figure()
plot(time, ga_pid_y_sim_no_noise(:,2), 'b'); hold on
plot(time, pid_y_sim_no_noise(:,2), 'r');
plot(time, lqr_y_sim_no_noise(:,2), 'g'); hold off
grid
title('Glucose concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')
legend('ga pid', 'pid', 'lqr')

figure()
plot(time, ga_pid_y_sim_no_noise(:,3), 'b'); hold on
plot(time, pid_y_sim_no_noise(:,3), 'r');
plot(time, lqr_y_sim_no_noise(:,3), 'g'); hold off
grid
title('Bioreactor volume')
xlabel('Cultivation time, [h]'), ylabel('Bioreactor volume, [l]')
legend('ga pid', 'pid', 'lqr')

%%
% arduino experiments



%%
clear all
close all
clc
%compare arduino ga pid and ga pid simulation
load ga_pid_sim.mat
load arduino_data.mat

figure()
plot(time, ga_pid_q_sim, 'b'); hold on
plot(time, ga_pid_arduino(:,4), 'r'); hold off
grid
title('Control signal')
xlabel('Cultivation time, [h]'), ylabel('Feed rate, [l/h]')
legend('ga pid simulation', 'ga pid arduino')

figure()
plot(time, ga_pid_y_sim(:,1), 'b'); hold on
plot(time, ga_pid_arduino(:,1), 'r'); hold off
grid
title('Biomass concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')
legend('ga pid simulation', 'ga pid arduino')

figure()
plot(time, ga_pid_y_sim(:,2), 'b'); hold on
plot(time, ga_pid_arduino(:,2), 'r'); hold off
grid
title('Glucose concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')
legend('ga pid simulation', 'ga pid arduino')

figure()
plot(time, ga_pid_y_sim(:,3), 'b'); hold on
plot(time, ga_pid_arduino(:,3), 'r'); hold off
grid
title('Bioreactor volume')
xlabel('Cultivation time, [h]'), ylabel('Bioreactor volume, [l]')
legend('ga pid simulation', 'ga pid arduino')

%%
clear all
close all
clc
%compare arduino pid and pid simulation
load pid_sim.mat
load arduino_data.mat

figure()
plot(time, pid_q_sim, 'b'); hold on
plot(time, pid_arduino(:,4), 'r'); hold off
grid
title('Control signal')
xlabel('Cultivation time, [h]'), ylabel('Feed rate, [l/h]')
legend('pid simulation', 'pid arduino')

figure()
plot(time, pid_y_sim(:,1), 'b'); hold on
plot(time, pid_arduino(:,1), 'r'); hold off
grid
title('Biomass concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')
legend('pid simulation', 'pid arduino')

figure()
plot(time, pid_y_sim(:,2), 'b'); hold on
plot(time, pid_arduino(:,2), 'r'); hold off
grid
title('Glucose concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')
legend('pid simulation', 'pid arduino')

figure()
plot(time, pid_y_sim(:,3), 'b'); hold on
plot(time, pid_arduino(:,3), 'r'); hold off
grid
title('Bioreactor volume')
xlabel('Cultivation time, [h]'), ylabel('Bioreactor volume, [l]')
legend('pid simulation', 'pid arduino')

%%
clear all
close all
clc
%compare arduino lqr and lqr simulation
load lqr_sim.mat
load arduino_data.mat

figure()
plot(time, lqr_q_sim, 'b'); hold on
plot(time, lqr_arduino(:,4), 'r'); hold off
grid
title('Control signal')
xlabel('Cultivation time, [h]'), ylabel('Feed rate, [l/h]')
legend('lqr simulation', 'lqr arduino')

figure()
plot(time, lqr_y_sim(:,1), 'b'); hold on
plot(time, lqr_arduino(:,1), 'r'); hold off
grid
title('Biomass concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')
legend('lqr simulation', 'lqr arduino')

figure()
plot(time, lqr_y_sim(:,2), 'b'); hold on
plot(time, lqr_arduino(:,2), 'r'); hold off
grid
title('Glucose concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')
legend('lqr simulation', 'lqr arduino')

figure()
plot(time, lqr_y_sim(:,3), 'b'); hold on
plot(time, lqr_arduino(:,3), 'r'); hold off
grid
title('Bioreactor volume')
xlabel('Cultivation time, [h]'), ylabel('Bioreactor volume, [l]')
legend('lqr simulation', 'lqr arduino')

%%
clear all
close all
clc
%compare arduino plots with different controllers
load arduino_data.mat

figure()
plot(time, ga_pid_arduino(:,4), 'b'); hold on
plot(time, pid_arduino(:,4), 'r');
plot(time, lqr_arduino(:,4), 'g'); hold off
grid
title('Control signal')
xlabel('Cultivation time, [h]'), ylabel('Feed rate, [l/h]')
legend('ga pid arduino', 'pid arduino', 'lqr arduino')

figure()
plot(time, ga_pid_arduino(:,1), 'b'); hold on
plot(time, pid_arduino(:,1), 'r');
plot(time, lqr_arduino(:,1), 'g'); hold off
grid
title('Biomass concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')
legend('ga pid arduino', 'pid arduino', 'lqr arduino')

figure()
plot(time, ga_pid_arduino(:,2), 'b'); hold on
plot(time, pid_arduino(:,2), 'r');
plot(time, lqr_arduino(:,2), 'g'); hold off
grid
title('Glucose concentration')
xlabel('Cultivation time, [h]'), ylabel('Biomass concentration, [g/l]')
legend('ga pid arduino', 'pid arduino', 'lqr arduino')

figure()
plot(time, ga_pid_arduino(:,3), 'b'); hold on
plot(time, pid_arduino(:,3), 'r');
plot(time, lqr_arduino(:,3), 'g'); hold off
grid
title('Bioreactor volume')
xlabel('Cultivation time, [h]'), ylabel('Bioreactor volume, [l]')
legend('ga pid arduino', 'pid arduino', 'lqr arduino')

%%
clear all
close all
clc
% sensitivity
load sensitivity.mat

w=logspace(-3,3,1000);

%sensitivity
figure()
sigma(clpPID_ga(3,1), 'b', clpPID(3,1), 'r', clpLQR(3,1), w, 'g'),grid
xlim([0.001 pi/0.0056])
legend('genetic PID', 'PID', 'LQR');

%complementary sensitivity
figure()
sigma(clpPID_ga(2,1), 'b', clpPID(2,1), 'r', clpLQR(1,1), w, 'g'),grid
xlim([0.001 pi/0.0056])
legend('genetic PID', 'PID', 'LQR');

%output sensitivity function
figure()
sigma(clpPID_ga(1,1), 'b', clpPID(1,1), 'r', clpLQR(2,1), w, 'g'),grid
xlim([0.001 pi/0.0056])
legend('genetic PID', 'PID', 'LQR');

%3 regulator simulink and arduino
    %pid simulink and pid arduino
    %lqr simulink and lqr arduino
%3 regulators simulink
%3 regulator arduino

