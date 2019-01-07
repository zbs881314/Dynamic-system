
function v = control(u)

persistent icount
persistent s
persistent a

if (isempty(icount)),
    % -------------------------------------------
    %    Setting up the NLC in APMonitor
    %    For any questions see http://apmonitor.com/wiki/index.php/Main/MATLAB
    % -------------------------------------------
    
    % Add path to APM libraries
    addpath('apm');
    
    % Select server
    %s = 'http://xps.apmonitor.com';
    s = 'http://byu.apmonitor.com';
    %s = 'http://localhost';
    %s = 'http://apm.byu.edu';
    
    % Application name
    a = ['4tank_' int2str(1000*rand())];
    
    % Clear previous application
    apm(s,a,'clear all');
    
    % load model variables and equations
    apm_load(s,a,'4tank.apm');
    
    % load data
    csv_load(s,a,'control.csv');
    
    % Set up variable classifications for data flow
    
    % Feedforwards - measured process disturbances
    apm_info(s,a,'FV','gamma[1]');
    apm_info(s,a,'FV','gamma[2]');
    % Manipulated variables (for controller design)
    apm_info(s,a,'MV','v1');
    apm_info(s,a,'MV','v2');
    % State variables (for display only)
    
    apm_meas(s,a,'h[1]',0);
    apm_meas(s,a,'h[2]',0);
    
    apm_info(s,a,'SV','h[1]');
    apm_info(s,a,'SV','h[2]');
    % Controlled variables (for controller design)
    apm_info(s,a,'CV','h[3]');
    apm_info(s,a,'CV','h[4]');
    
    % solve here for steady state initialization
    % imode = 3, steady state mode
    %apm_option(s,a,'nlc.imode',3);
    %apm(s,a,'solve')
    
    % imode = 6, switch to dynamic control
    apm_option(s,a,'nlc.imode',6);
    % nodes = 3, internal nodes in the collocation structure (2-6)
    apm_option(s,a,'nlc.nodes',2);
    % time units
    apm_option(s,a,'nlc.ctrl_units',1);
    apm_option(s,a,'nlc.hist_units',2);
    % read csv file
    apm_option(s,a,'nlc.csv_read',1);
    % cv type (1=l1-norm, 2=l2-norm)
    apm_option(s,a,'nlc.cv_type',1);
    % maximum iterations
    apm_option(s,a,'nlc.max_iter',200);
    
    % Manipulated variables
    apm_option(s,a,'v1.status',1);
    apm_option(s,a,'v1.fstatus',0);
    apm_option(s,a,'v1.upper',1);
    apm_option(s,a,'v1.lower',0.01);
    apm_option(s,a,'v1.dmax',1);
    apm_option(s,a,'v1.dcost',0.001);
    
    apm_option(s,a,'v2.status',1);
    apm_option(s,a,'v2.fstatus',0);
    apm_option(s,a,'v2.upper',1);
    apm_option(s,a,'v2.lower',0.01);
    apm_option(s,a,'v2.dmax',1);
    apm_option(s,a,'v2.dcost',0.001);
    
    % Controlled variables
    apm_option(s,a,'h[3].status',1);
    apm_option(s,a,'h[3].fstatus',1);
    apm_option(s,a,'h[3].sphi',10.1);
    apm_option(s,a,'h[3].splo',9.9);
    apm_option(s,a,'h[3].tau',5);
    
    apm_option(s,a,'h[4].status',1);
    apm_option(s,a,'h[4].fstatus',1);
    apm_option(s,a,'h[4].sphi',15.1);
    apm_option(s,a,'h[4].splo',14.9);
    apm_option(s,a,'h[4].tau',5);
    
    apm_meas(s,a,'gamma[1]',.5);
    apm_meas(s,a,'gamma[2]',.5);
    
    % Set controller mode
    apm_option(s,a,'nlc.reqctrlmode',1);
    
    % Adjust plot frequency
    apm_option(s,a,'nlc.web_plot_freq',3);
    
    icount = 0;
end

icount = icount + 1;

h1 = u(1);
h2 = u(2);
h3 = u(3);
h4 = u(4);
g1 = u(7);
g2 = u(8);

h3_sp = u(5);
h4_sp = u(6);

deadband = 0.01;

h3_upper = h3_sp + deadband;
h3_lower = h3_sp - deadband;

h4_upper = h4_sp + deadband;
h4_lower = h4_sp - deadband;

% Add in functionality to change the height set point

% Gamma values
apm_meas(s,a,'gamma[1]',g1);
apm_meas(s,a,'gamma[2]',g2);

% State variables
apm_meas(s,a,'h[1]',h1);
apm_meas(s,a,'h[2]',h2);

% Controlled variables
apm_meas(s,a,'h[3]',h3);
apm_meas(s,a,'h[4]',h4);

apm_option(s,a,'h[3].sp',h3_sp);
apm_option(s,a,'h[4].sp',h4_sp);

apm_option(s,a,'h[3].sphi',h3_upper);
apm_option(s,a,'h[3].splo',h3_lower);

apm_option(s,a,'h[4].sphi',h4_upper);
apm_option(s,a,'h[4].splo',h4_lower);

% Run APMonitor
apm(s,a,'solve')

% Retrieve manipulated variables
v(1) = apm_tag(s,a,'v1.newval');
v(2) = apm_tag(s,a,'v2.newval');

if (icount==1),
    % Set to control mode after first cycle
    apm_option(s,a,'nlc.reqctrlmode',3);

    % Open web-viewer after first cycle
    apm_web(s,a);
end

end
