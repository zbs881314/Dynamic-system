clear all; close all; clc     % clear variables, close plots, clear screen

%% Lift functions for two different valve trim types
f_lin = @(x) x;               % linear valve trim
f_ep  = @(x) 20.^(x-1);       % equal percentage valve trim

lift = linspace(0,1);         % 100 equally spaced points between 0 and 1

figure(1)                     % create new figure
title('Valve Performance - Not Installed')
subplot(2,1,1)                % 2,1 subplot with 1st window
plot(lift,f_lin(lift),'b-')   % plot linear valve
hold on                       % use "hold on" to not erase additional items
plot(lift,f_ep(lift),'r--')   % plot equal percentage valve
ylabel('f(l)')
legend('Linear Valve Trim','Equal Percentage Valve Trim')

g_s = 1.1;                    % specific gravity of fluid
q = @(x,f,Cv,DPv) Cv * f(x) * sqrt(DPv/g_s);   % flow through a valve

%% Intrinsic valve performance
% no process equipment - all pressure drop is across valve
DPt = 200; % Total pressure generated by pump (constant)
Cv = 2;    % Valve Cv
flow_lin = q(lift,f_lin,Cv,DPt);  % flow through linear valve
flow_ep  = q(lift,f_ep,Cv,DPt);   % flow through equal percentage valve

subplot(2,1,2)                    % 2,1 subplot with 2nd window
plot(lift,flow_lin,'b-')          % plot linear valve response
hold on
plot(lift,flow_ep,'r--')          % plot equal percentage valve response
ylabel('Flow')
legend('Linear Valve Trim','Equal Percentage Valve Trim')
xlabel('Fractional Valve Lift')

%% Installed valve performance
% pressure drop across valve and process equipment

% pressure drop across other equipment
c1 = 2;
DPe = @(q) c1 * q.^2;

% combined valve and process equipment flow with 100 bar pressure drop
qi = @(x,f,Cv) sqrt((Cv.*f(x)).^2.*DPt ./ (g_s + (Cv.*f(x)).^2 .* c1));

% Process equipment + Valve performance
flow_lin = qi(lift,f_lin,Cv);  % flow through linear valve
flow_ep  = qi(lift,f_ep,Cv);   % flow through equal percentage valve

figure(2)
title('Valve Performance - Installed')
subplot(3,1,1)
plot(lift,flow_lin,'b-')
hold on
plot(lift,flow_ep,'r--')
plot([0 1],[0 9.4],'k-','LineWidth',2)
legend('Linear Valve','Equal Percentage Valve','Desired Profile')
ylabel('Flow')

subplot(3,1,2)
plot(lift,DPt-DPe(flow_lin),'k:','LineWidth',3)
hold on
plot(lift,DPe(flow_lin),'g:','LineWidth',3)
legend('Linear Valve','Process Equipment')
ylabel('\Delta P')

subplot(3,1,3)
plot(lift,DPt-DPe(flow_ep),'k:','LineWidth',3)
hold on
plot(lift,DPe(flow_ep),'g:','LineWidth',3)
legend('Equal Percentage Valve','Process Equipment')
ylabel('\Delta P')
xlabel('Lift')
