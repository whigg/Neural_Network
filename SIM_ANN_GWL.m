function ANN_SIM_OUT=SIM_ANN_GWL(ANN_SIM_IN)
% Load the trained network
net_path='E:\STORAGE_COEFF\GW_ANN\WITH_3_PARAMTERS\ANN_NET.mat';
load(net_path);
net_gwl=results.net;
ANN_SIM_OUT = sim(net_gwl,ANN_SIM_IN);


end


