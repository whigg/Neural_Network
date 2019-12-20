function plot_GWL

%% This script allows to visualize the data prior to ANN processing
%% MATLAB/ Python/R.

%% Author: Dr. VIBHOR AGARWAL

% Note: Please update the MASCON GRACE filename (CSR/JPL/GSFC)

month=['Jan'; 'Feb'; 'Mar'; 'Apr'; 'May'; 'Jun'; 'Jul'; 'Aug'; 'Sep'; 'Oct'; 'Nov'; 'Dec'];

clear
%Looping through for each month
gwl_GWL_f=[];
GRACE_f=[];
PERM_f=[];
SLOPE_f=[];
TEMP_f=[];
PPT_f=[];
MODIS_f=[];
lat_GWL_f=[];
lon_GWL_f=[];
SOIL_M_F=[];

%Reading Permeability data
[data1, ~]=geotiffread('E:\STORAGE_COEFF\CALIFORNIA\ann_in\CentralV2_PolygonToRaster_Pr1.tif');
info1 = geotiffinfo('E:\STORAGE_COEFF\CALIFORNIA\ann_in\CentralV2_PolygonToRaster_Pr1.tif');
[x1,y1]=pixcenters(info1);
[X1,Y1]=meshgrid(x1,y1);
x1=X1(:);
y1=Y1(:);
%x3=x3';
lat_perm=y1;
lon_perm=x1;
data_perm=double(data1(:));
F=scatteredInterpolant(lon_perm,lat_perm, data_perm);

%Filtering out the irrelevant data
I_inf=find(data_perm~=data_perm(1));
data_perm=data_perm(I_inf);
lat_perm=lat_perm(I_inf);
lon_perm=lon_perm(I_inf);
%Defining the extent of Central Valley

max_lat_perm=max(lat_perm);
min_lat_perm=min(lat_perm);

max_lon_perm=max(lon_perm);
min_lon_perm=min(lon_perm);

%% Check the number of solution in the GRACE MASCON/ L2
GRACE_path='E:\STORAGE_COEFF\MASCON\CSR\EWH\ewh_csr.mat'; %only CSR/JPL solution path
load(GRACE_path);
AA=(datestr(date_f));
time=decyear(date_f);
year_f=str2num(AA(:,8:11));
month_f=AA(:,4:6); %For finding the missing month name
I=find(year_f >= 2006 & year_f <= 2008);

YEAR=year_f(I);
MONTH=month_f(I,:); %Finding the number of months covered by GRACE during the time frame

for i=1:numel(YEAR) %for the period 2006-2008, however we need to skip couple of months for LACK of GRACE data

%% GROUNDWATER WELL DATA- MONTHLY
GWL_path='E:\STORAGE_COEFF\CALIFORNIA\California_well_data\MAT\WELL_READ_MAT\';
[GWL,~]=fx_dir(GWL_path,'.asc');
A=load(strcat(GWL_path,GWL(i).name));
lat_GWL=A(:,6);
lon_GWL=-A(:,7);
gwl_GWL=A(:,9);
sp_y=0.1; % Specific yield of Central Valley

gwl_GWL=gwl_GWL*sp_y;

% filter out the GWL data only in Central  valley based on permeabilty data
I3=find(lat_GWL < max_lat_perm & lat_GWL> min_lat_perm & lon_GWL < max_lon_perm & lon_GWL> min_lon_perm);

lat_GWL= lat_GWL(I3);
lon_GWL= lon_GWL(I3);
gwl_GWL= gwl_GWL(I3);

gwl_mean(i)=mean(gwl_GWL);

% FINAL FIELD DATA FOR THE CENTRAL VALLEY (CUMULATIVE)
% gwl_GWL_f=[gwl_GWL_f;gwl_GWL];
% lat_GWL_f=[lat_GWL_f;lat_GWL];
% lon_GWL_f=[lon_GWL_f;lon_GWL];

clear A GWL GWL_path

%% Soil Moisture for Central Valley, 36 file

file='E:\STORAGE_COEFF\SOIL_MOISTURE\SOIL_2006_08.mat';
load(file);

F8=scatteredInterpolant((LON),(LAT), RZSM_f1(:,i)); % Interpolate the GRID for all teh values
SOIL_M=F8(lon_GWL,lat_GWL);
SOIL_mean(i)=mean(SOIL_M);
SOIL_M_F=[SOIL_M_F;SOIL_M];


%% Permeability
% Finding permeability at GW well locations

% PERM=F(lon_GWL,lat_GWL);
% 
% PERM_f=[PERM_f;PERM];
% 
% clear I_inf data_perm data1 info1 X1 Y1 x1 y1

%% DEM-SLOPE, 1 file
% [data2, ~]=geotiffread('E:\STORAGE_COEFF\CALIFORNIA\ann_in\Slope_NOSAIC31.tif');
% info2 = geotiffinfo('E:\STORAGE_COEFF\CALIFORNIA\ann_in\Slope_NOSAIC31.tif');
% [x2,y2]=pixcenters(info2);
% [X2,Y2]=meshgrid(x2,y2);
% x2=X2(:);
% y2=Y2(:);
% lat_slope=y2;
% lon_slope=x2;
% data_slope=double(data2(:)); %putting double format 
% 
% %Filtering out the irrelevant data
% I_inf=find(data_slope~=data_slope(1));
% data_slope=data_slope(I_inf);
% lat_slope=lat_slope(I_inf);
% lon_slope=lon_slope(I_inf);
% 
% F1=scatteredInterpolant(lon_slope,lat_slope, data_slope);
% SLOPE=F1(lon_GWL,lat_GWL);
% SLOPE_f=[SLOPE_f;SLOPE];
% 
% clear lat_slope lon_slope I_inf data_slope x2 y2 X2 Y2 data2 info2
%% PRISM- PPT (36 files, 2006-2008). PPT FILE HAS been preprocessed before
ppt_path='E:\STORAGE_COEFF\prism\PPT_ASC\PPT_FINAL\';
[PPTT,~]=fx_dir(ppt_path,'.mat');

load(strcat(ppt_path,PPTT(i).name)); %loads lat, lon, mean_ppt
lat_ppt=lat;
lon_ppt=lon;
mean_ppt=mean_ppt';

F2=scatteredInterpolant(lon_ppt,lat_ppt, mean_ppt);
PPT=F2(lon_perm,lat_perm);
PPT_mean(i)=mean(PPT);

PPT_f=[PPT_f,PPT]; %for all months in 3 year

%clearing repeetive variables
clear lat lon data lat_ppt lon_ppt ppt_path PPTT
%% PRISM- TEMP (48 files, 2005-2008)
temp_path='E:\STORAGE_COEFF\prism\tmean_asc\DATA\RESULTS\';
[TEMPT,~]=fx_dir(temp_path,'.mat');

load(strcat(temp_path,TEMPT(i+12).name)); %load lat lon and mean temp
lat_temp=lat1;
lon_temp=lon1;
mean_temp=data;

F3=scatteredInterpolant(lon_temp,lat_temp, mean_temp); 
TEMP=F3(lon_perm,lat_perm);
TEMP_mean(i)=mean(TEMP);

TEMP_f=[TEMP_f,TEMP];

clear lat1 lon1 data mean_data lat_temp lon_temp TEMPT temp_path
%% MODIS_ET (36 files, 2006-2008) -500 m resolution
modis_path='E:\STORAGE_COEFF\ET\MODIS\MODIS_MAT_2006-2008\';
scale_factor=0.1;
[MOD,~]=fx_dir(modis_path,'.mat');
load(strcat(modis_path,MOD(i).name));
%multiply by the scale factor

lat_MODIS=y5;
lon_MODIS=x5;
%lon_MODIS=rem((lon_MODIS+180),360)-180;
data_MODIS=data5'*scale_factor;
data_MODIS=double(data_MODIS);

I_MOD = find(lat_MODIS < max(lat_perm) & lat_MODIS > min(lat_perm) & lon_MODIS < max(lon_perm) & lon_MODIS > min(lon_perm));
lat_MODIS=lat_MODIS(I_MOD);
lon_MODIS=lon_MODIS(I_MOD);
data_MODIS=data_MODIS(I_MOD);

F4=scatteredInterpolant(lon_MODIS,lat_MODIS, data_MODIS);
MODIS=F4(lon_perm,lat_perm);

MODIS_mean(i)=mean(MODIS);
MODIS_f=[MODIS_f,MODIS];

clear lat1 lon1 data_MODIS lat_MODIS lon_MODIS MOD modis_path scale_factor
%% GRACE SOLUTIONS- (CSR, JPL, GSFC)
% GRACE_path='E:\STORAGE_COEFF\CALIFORNIA\GRACE_RL06_CentralValley\monthly_GRACE.mat';
% load(GRACE_path);
% % m_GRACE=monthly_GRACE(:,i);
% %m_GRACE=double(EWH_f(:,i)); %Monthly GRACE data solutions
% m_GRACE=double(monthly_GRACE(:,i)); %Monthly GRACE data solutions
% % Convert from 360 to -180 - 180 system
% lon_GRACE1=rem((lon_GRACE+180),360)-180;
% F5=scatteredInterpolant(lon_GRACE1,lat_GRACE, m_GRACE);
% GRACE=F5(lon_GWL,lat_GWL); %Subsetting it as the 
% GRACE_f=[GRACE_f;GRACE];

end %end of monthly loop

% %Finally create the ANN variables
% ANN_IN=[GRACE_f,PERM_f, SOIL_M_F, SLOPE_f,TEMP_f,PPT_f, MODIS_f];
% %ANN_IN=[-GRACE_f,PERM_f, SOIL_M_F, TEMP_f, PPT_f, MODIS_f];
% ANN_OUT=gwl_GWL_f;

I_time=find(time>=2006 & time <= 2008);
times=time(I_time);
figure
yyaxis left
title('Variation of Groundwater Level (GWL) with Precipitation (PPT)');
% plot(x,y);
plot(times,PPT_mean');
ylabel('PPT (in mm)')
yyaxis right
% plot(x,r);
plot(times,movmean((-gwl_mean*10),3)); %Using GWL as for now
ylabel('GWL (in m below ground)')

figure
yyaxis left
title('Variation of Groundwater Level (GWL) with Temperature');
% plot(x,y);
plot(times,TEMP_mean');
ylabel('TEMPERATURE')
yyaxis right
% plot(x,r);
plot(times,movmean((-gwl_mean*10),3)); %Using GWL as for now
ylabel('GWL')

figure
yyaxis left
title('Variation of Groundwater Level (GWL) with Evapotranspiration (ET)');
% plot(x,y);
plot(times,MODIS_mean');
ylabel('ET (mm)')
yyaxis right
% plot(x,r);
plot(times,movmean((-gwl_mean*10),3)); %Using GWL as for now
ylabel('GWL')


st.dh_x=timef;                      %x axis: Time
    st.dh_y=dhf;                        %y axis: Elevation difference
    st.dh_mx=mtime;                    %x axis: Median Time
    st.dh_my=mdh;                      %y axis: Median Elevation difference
    st.dh_myy=b(1)+st.dh_mx*b(2); %trend
    st.dh_tr=b(2); %trend rate??
    st.dh_se=stats.se(2); % Standard error of coefficient estimates
    st.dh_p=stats.p(2); % p-values for t
    st.dh_sigma=sqrt(st.dh_se^2+0.06^2+0.06^2+0.06^2+0.06^2);

end
% save('E:\STORAGE_COEFF\GW_ANN\WITH_SOIL_M\CSR_RL06\ANN_IP_pos_GRACE`.mat','ANN_IN', 'ANN_OUT');

% Export for Feeding into the Python
%  T=[lon_GWL_f, lat_GWL_f, gwl_GWL_f, GRACE_f, PERM_f,SOIL_M_F, TEMP_f, PPT_f, MODIS_f, SLOPE_f];
%     
%     cHeader = {'LON' 'LAT' 'GWL' 'WELL_GWL' 'GRACE' 'PERMEABILITY' 'SOIL_MOISTURE' 'TEMPERATURE' 'PRECIPITATION' 'EVAPOTRANSPIRATION' 'SLOPE'}; %dummy header
%     commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
%     commaHeader = commaHeader(:)';
%     textHeader = cell2mat(commaHeader); %cHeader in text with commas
%     
%     
%     filename='E:\STORAGE_COEFF\Training_Data.csv';
%     
%     write header to file
%     fid = fopen(filename,'w'); 
%     fprintf(fid,'%s\n',textHeader);
%     fclose(fid);
%     Now append the data
%     dlmwrite(filename,T,'-append');
%     