TIME_ANN2 = datetime(TIME_ANN, 'ConvertFrom', 'datenum');

d1 = datenum('10/01/2005');
d2 = datenum('09/30/2007');
idx = TIME_ANN>d1 & TIME_ANN<d2;

t= TIME_ANN2(idx);

ANN_OUT_F = ANN_OUT(1,idx);

ANN_IN_F = ANN_IN(:,idx);

net = fitnet(10);
view(net);
net = train(net,ANN_IN_F,ANN_OUT_F);
ANN_OUT_SIM = net(ANN_IN_F);
perf = perform(net,ANN_OUT_SIM,ANN_OUT_F);

net = fitnet(10,'trainbr');
net = train(net,ANN_IN_F,ANN_OUT_F);
ANN_OUT_SIM = net(ANN_IN_F);
perf = perform(net,ANN_OUT_SIMy,ANN_OUT_F);
% TIME_f2 = TIME_f (Year2 > 2006 & Month2 > 1 & Year2 < 2008 & Month2 < 12);


    
    