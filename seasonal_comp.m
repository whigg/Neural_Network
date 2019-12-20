%this function takes the seasonal component of the EWH

function seasonal_comp

clear;
% Read information from HDF5 file
h5filename = 'E:\STORAGE_COEFF\MASCON\GSFC.glb.200301_201607_v02.4-ICE6G.h5';

size_group.N_mascon_times = h5read(h5filename,'/size/N_mascon_times');
time_group = h5read(h5filename,'/time/yyyy_doy_yrplot_middle');
time_group2 = h5read(h5filename,'/time/n_ref_days_solution');
time_year=time_group(:,1);

mascon_group.lat_cent=h5read(h5filename,'/mascon/lat_center');
mascon_group.lat_span=h5read(h5filename,'/mascon/lat_span');
mascon_group.lon_cent=h5read(h5filename,'/mascon/lon_center');
mascon_group.lon_span=h5read(h5filename,'/mascon/lon_span');

solution_group.cmwe = h5read(h5filename,'/solution/cmwe'); %cm w.eq


% for i = 2003:2013
% I=find(time_year==i);
% EWH=solution_group.cmwe(I,:);
% [~,n] = size(EWH);
% end
%j=1; %from 1 to 41168
tim=time_group(:,3);
%Filling the data gaps for time variable
c= [tim(1:5); mean([tim(5),tim(6)]); tim(6:95); mean([tim(95),tim(96)]); tim(96:99); mean([tim(99),tim(100)]); tim(100:109); mean([tim(109),tim(110)]); tim(110:113); mean([tim(113),tim(114)]); tim(114:115)];
[m, n]=size(solution_group.cmwe);
% N IS THE COORDINATE
for j=1:n

y=solution_group.cmwe(:,j); %FOPR ALL TIME FOR A COORDINATE POINT
% Filling up the data gaps
b = [y(1:5); mean([y(5),y(6)]); y(6:95); mean([y(95),y(96)]); y(96:99); mean([y(99),y(100)]); y(100:109); mean([y(109),y(110)]); y(110:113); mean([y(113),y(114)]); y(114:115)]; 

T = length(b);

% 
% figure
% plot(c, b)
% h1 = gca;
% h1.XLim = [0,T];
% h1.XTick = 1:12:T;
% h1.XTickLabel = c;
% title 'Monthly EWH';
% ylabel 'EWH';
% hold on

sW13 = [1/22;repmat(1/12,6,1);1/10;1/20]; %year stuff
yS = conv(b,sW13,'same'); %To prevent observation loss, repeat the first and last smoothed values six times. 
                          %Subtract the smoothed series from the original series to detrend the data. Add the moving average trend estimate to the observed time series plot.
yS(1:6) = yS(7); yS(T-5:T) = yS(T-6);
xt = b-yS;

% h = plot(c, yS, 'r','LineWidth',2);
% legend(h,'12-Term Moving Average')
% hold off

%% Create seasonal indices.
s = 12; %The data is monthly, with periodicity 12
sidx = cell(s,1);
for i = 1:s
 sidx{i,1} = i:s:T;
end

%% Apply a stable seasonal filter
sst = cellfun(@(x) mean(xt(x)),sidx);

% Put smoothed values back into a vector of length N
nc = floor(T/s); % no. complete years
rm = mod(T,s); % no. extra months
sst = [repmat(sst,nc,1);sst(1:rm)];

% Center the seasonal estimate (additive)
sBar = mean(sst); % for centering
sst = sst-sBar;

% figure
% plot(c,sst)
% title 'Stable Seasonal Component';
% h2 = gca;
% h2.XLim = [0 T];
% ylabel 'EWH';
% h2.XTick = 1:12:T;
% h2.XTickLabel = datestr(dates(1:12:T),10);

%% Deseasonalize the series.
dt = b - sst;

SEASON(:,j)=sst; %FOR ALL TIME FOR A POINT
% figure
% plot(c, dt)
% title 'Deseasonalized Series';
% ylabel 'EWH';
% h3 = gca;
% h3.XLim = [0 T];
% h3.XTick = 1:12:T;
% h3.XTickLabel = datestr(dates(1:12:T),10);
end

lon=0.5:359.5;
lat=89.5:-1:-89.5;

average_EWH(1,:)=median(SEASON(1:12,:)); %converting from cm to m

F=scatteredInterpolant(mascon_group.lon_cent, mascon_group.lat_cent,average_EWH(1,:)');
EWH_f(:,:,1)=F({lon, lat})';


for j=2:10
    average_EWH(j,:)=median(SEASON(((j-1)*12+1):j*12)); %converting from cm to m
    F=scatteredInterpolant(mascon_group.lon_cent, mascon_group.lat_cent,average_EWH(j,:)');
    EWH_f(:,:,j)=F({lon, lat})';
end

save('E:\STORAGE_COEFF\MASCON\EWH_GSFC\ICE6G\ewh_seas.mat','EWH_f')
