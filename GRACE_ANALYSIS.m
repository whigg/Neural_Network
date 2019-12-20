% GRACE ANALYSIS
% ANalyze different aspcets of GRACE 
load('E:\STORAGE_COEFF\GRACE_RESULTS\CentralValley_CSR_200204_201706.mat') %Resukt from Wei Chen
plot(csr_Timeseries_CentralValley_G3OO_Scale(5:156,1),movmean(csr_Timeseries_CentralValley_G3OO_Scale(5:156,4),12));
xlabel('Time')
ylabel('TWSC')
title('TWSC in Central Valley')