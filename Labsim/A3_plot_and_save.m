load data_MPC.mat

time = tanks(1,:);
gamma1 = tanks(2,:);
gamma2 = tanks(3,:);
pump1 = tanks(4,:);
pump2 = tanks(5,:);
level3_sp = tanks(6,:);
level4_sp = tanks(7,:);
level1 = tanks(8,:);
level2 = tanks(9,:);
level3 = tanks(10,:);
level4 = tanks(11,:);

figure(2)
hold off
subplot(3,2,1)
hold off
plot(time,gamma1,'b:')
hold on
legend('\gamma_1');

subplot(3,2,2)
hold off
plot(time,gamma2,'r:')
hold on
legend('\gamma_2');

subplot(3,2,3)
hold off
plot(time,pump1,'b--')
hold on
legend('Pump_1')

subplot(3,2,4)
hold off
plot(time,pump2,'r--')
legend('Pump_2')

subplot(3,2,5)
hold off
plot(time,level3,'k:')
hold on
plot(time,level3_sp,'b-')
legend('Level_3','Level_3 SP')

subplot(3,2,6)
hold off
plot(time,level4,'k:')
hold on
plot(time,level4_sp,'r-')
legend('Level_4','Level_4 SP')

% save data to text file
data = tanks';

save -ascii 'data_MPC.txt' data