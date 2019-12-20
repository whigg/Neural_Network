    % Script To read EWH Mascon file and get yearly solutions from them
function read_GSFC
clear;
% Read information from HDF5 file
h5filename = 'E:\STORAGE_COEFF\MASCON\GSFC\GSFC.glb.200301_201607_v02.4-ICE6G.h5';

size_group.N_mascon_times = h5read(h5filename,'/size/N_mascon_times');
time_group = h5read(h5filename,'/time/yyyy_doy_yrplot_middle');

date_f=doy2date(time_group(:,2),time_group(:,1)); %in vecrtor format


time_group2 = h5read(h5filename,'/time/n_ref_days_solution'); %if needed
time_year=time_group(:,1);

mascon_group.lat_cent=h5read(h5filename,'/mascon/lat_center');
mascon_group.lat_span=h5read(h5filename,'/mascon/lat_span');
mascon_group.lon_cent=h5read(h5filename,'/mascon/lon_center');
mascon_group.lon_span=h5read(h5filename,'/mascon/lon_span');

uncertainty_group.leakage_trend		=	h5read(h5filename,'/uncertainty/leakage_trend');
uncertainty_group.leakage_2sigma	=	h5read(h5filename,'/uncertainty/leakage_2sigma');
uncertainty_group.noise_2sigma	    =	h5read(h5filename,'/uncertainty/noise_2sigma');

% Onky if you require to do it
% mwe2GT	=	repmat(mascon_group.area_km2(ind_region)'*1e-5,size_group.N_mascon_times,1);
% GT2cmwe	=	1/(sum(mascon_group.area_km2(ind_region))*1e-5);
% Gt	=	sum(solution_group.cmwe(:,ind_region).*cmwe2GT,2);


solution_group.cmwe = h5read(h5filename,'/solution/cmwe'); %cm w.eq
a=1;

% for i = 2003:2013
% I=find(time_year==i);
% EWH=solution_group.cmwe(I,:);
% [~,n] = size(EWH);

EWH=solution_group.cmwe;

% end
%	Get	uncertainty (Refer to the PDF)
% N	=	length(ind_region); %These parameters only required for basin scale
% Z	=	22;                 % uncertainities
% leakage_trend		=	abs(sum(uncertainty_group.leakage_trend(:,ind_region).*cmwe2GT,2));
leakage_trend		= abs(uncertainty_group.leakage_trend);
leakage_2sigma	    = uncertainty_group.leakage_2sigma;
noise_2sigma		= uncertainty_group.noise_2sigma;
% total_uncertainty	=	leakage_trend	+	(leakage_2sigma	+	noise_2sigma)/sqrt(N/Z);
total_uncertainty	=	leakage_trend	+	(leakage_2sigma	+	noise_2sigma);
% 
% for j=1:n %loop that computes average for all pixel values 
%     ff=EWH(1:numel(I),j);
%     aa=ff.*time_group2(I); % weighted average based on time
%     ave=sum(aa)/sum(time_group2(I)); % weighted average based on time
%     average_EWH(a,j)=ave; %average for a particular year for particular pixel 2D array
% end
%    a=a+1;

%read the MASCONS in a 1 degree grid
% lon_GRACE=0.5:359.5;
lon=0.5:359.5;
% lat_GRACE=89.5:-1:-89.5;
lat=89.5:-1:-89.5;

lon=lon';
lat=lat';

[LON, LAT]=meshgrid(lon,lat);

lon_GRACE=LON(:);
lat_GRACE=LAT(:);

% for j=1:numel(2003:2013)
 for j=1:148
    F=scatteredInterpolant(mascon_group.lon_cent, mascon_group.lat_cent,EWH(j,:)');
    F1=scatteredInterpolant(mascon_group.lon_cent, mascon_group.lat_cent,total_uncertainty(j,:)');
    ewh_temp=F({lon, lat});
     EWH_f(:,j)=ewh_temp(:);
%     EWH_f(:,:,j)=F({lon, lat})';
    unc_temp=F1({lon, lat});
     UNC_f(:,j)=unc_temp(:);
%     UNC(:,:,j)=F1({lon, lat})';
 end
save('E:\STORAGE_COEFF\MASCON\GSFC\ICE6G\ewh.mat','lon_GRACE','lat_GRACE','lon','lat', 'date_f','EWH_f','UNC_f')
end
