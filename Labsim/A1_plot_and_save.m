load data_manual.mat

time = tanks(1,:);
gamma1 = tanks(2,:);
gamma2 = tanks(3,:);
pump1 = tanks(4,:);
pump2 = tanks(5,:);
level1 = tanks(6,:);
level2 = tanks(7,:);

figure(2)
hold off

subplot(3,1,1)
plot(time,gamma1,'k:')
hold on
plot(time,gamma2,'g.-')
legend('\gamma_1','\gamma_2');

subplot(3,1,2)
plot(time,pump1,'r--')
hold on
plot(time,pump2,'b-')
legend('Pump_1','Pump_2')

subplot(3,1,3)
plot(time,level1,'k:')
hold on
plot(time,level2,'g-.')
legend('Level_1','Level_2')

% save data to text file
data = tanks';

save -ascii 'data_manual.txt' data