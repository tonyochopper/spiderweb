% learning pendulum equation
% helmut.hauser@bristol.ac.uk 
 
% load data
close all;
clear all;

for changedata = 1:9

for kvalue = 1:1
    mse = [];
for freehand = 1:10   %1+(kvalue-1)*10:5+(kvalue-1)*10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  making net 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if changedata == 1
    data = init_ms_sys_data_normal(8,6,0);
elseif changedata == 2
    data = init_ms_sys_data_normal(8,6,0.05);
elseif changedata == 3
    data = init_ms_sys_data_normal(8,6,0.1);
elseif changedata == 4
    data = init_ms_sys_data_normal(8,6,0.15);
elseif changedata == 5
    data = init_ms_sys_data_normal(8,6,0.2);
elseif changedata == 6
    data = init_ms_sys_data_normal(8,6,0.25);
elseif changedata == 7
    data = init_ms_sys_data_normal(8,6,0.3);
elseif changedata == 8
    data = init_ms_sys_data_normal(8,6,0.35);
elseif changedata == 9
    data = init_ms_sys_data_normal(8,6,0.4);
% elseif changedata == 10
%     data = init_ms_sys_data_sprial(8,5,0);
% if changedata == 7
%     data = init_ms_sys_data_normal2(8,5);
% elseif changedata == 5
%     data = init_ms_sys_data_normal4(8,5);
% elseif changedata == 6
%     data = init_ms_sys_data_normal5(8,5);
end
    

% data = spider_web_nodes_d(3,3);

% change parameters from default
% to ones that are appropiate for this task
% //data.num = 26; 		
data.show_steps = 1000;
%% 
data.w_in_range = [100 100];
% define ranges for the randomly intialized
% dynamic parameters of the springs
data.k_lim = [10 100;10 100];  
data.d_lim = [10 100;10 100];


data.show_plot = 1;
%  data.readout_type = 'POSITIONS';
data.readout_type = 'LENGTHS';

%% 

% initialize a random net with given values
net = init_ms_sys_net(data); 

%% 

file = ['0915noise\201900914_',num2str(changedata*1000+kvalue*100+freehand),'.mat'];
% data.k_lim = [0.001*(10^(freehand-1)) 0.01*(10^(freehand-1)) ;0.001*(10^(kvalue-1)) 0.01*(10^(kvalue-1))];  
% data.d_lim = [100 100 ;100 100];
% data.k_lim = [0.001*(10^(kvalue-1)) 0.01*(10^(kvalue-1));1 100];  
% data.d_lim = [0.001*(10^(kvalue-1)) 0.01*(10^(kvalue-1));1 100];
% data.k_lim = [10 100;10 100];  
% data.d_lim = [10 100;10 100];
% net.W.k1   = rand_in_range_exp(data.k_lim(2,:),data.w_idx); % random spring constants
% net.W.k3   = rand_in_range_exp(data.k_lim(1,:),data.w_idx); % random spring constants
% net.W.d1   = rand_in_range_exp(data.d_lim(2,:),data.w_idx); % random damping constants
% net.W.d3   = rand_in_range_exp(data.d_lim(1,:),data.w_idx); % random damping constants
%% loading data and trainning

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loading data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('data_Volterra/volterra.mat');
vtimes = 1;
% prepare learning data
wash_out = 60000;
start = 80000-wash_out; 
len = 200000+start;
len_test = 15000;
U = vtimes*dat.u(start:len,1);  
Y = vtimes*dat.yn(start:len,1); % using normalized data
Y = vtimes*dat.y(start:len,1);
un = (mapstd(U'))';
yn = (mapstd(Y'))';

% prepare testing data
U_test = vtimes*dat.u(len+1:len+len_test,1);  
Y_test = vtimes*dat.yn(len+1:len+len_test,1); % using normalized data
un_test = (mapstd(U_test'))';
yn_test = (mapstd(Y_test'))';

 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  simulating net 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[net2,sim_data] = simulate_ms_sys(net,U);
 
% learn output weights with linear regression
if (strcmp(net.readout_type,'LENGTHS'))
	X = sim_data.D(wash_out:end,:);  % throw first 100 steps away
else
	X = sim_data.Sx(wash_out:end,:);  % throw first 100 steps away
end

Yw = Y(wash_out:end,:);

W_out=X\Yw; % calculate optimal weights


net_test = net2;
net_test.W_out = W_out;
o = X*W_out;

% in case you want to test how good the weights 
% represent the learnign dat
% figure;plot(o); hold on;plot(Yw,'r')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[net_test_out,sim_data_test] = simulate_ms_sys(net_test,U_test);



% plot results
figure;plot(yn_test,'r','LineWidth',1);
hold on;plot((mapstd(sim_data_test.O'))','--','LineWidth',1);
f1=gcf;a1=gca;
set(a1,'FontSize',14);
xlabel('timestep [ ]');
ylabel('[ ]');
title('Performance comparison')
legend('target output','system output')


% caculate and print MSE
disp(['MSE: ',num2str(mean_squared_error(yn_test,(mapstd(sim_data_test.O'))'))])
mse=[mse;mean_squared_error(yn_test,(mapstd(sim_data_test.O'))')];

%plot_graph(net_test)
save(file)
end
file2 = ['0915noise\_MSE_',num2str(changedata*10+kvalue),'.mat'];
save(file2,'mse');

% plot the structure of the used network


end
end



