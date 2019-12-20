function ANN_GWL_simplified

%% This script allows to prepare and process the ANN/ Deep Learning inputs for further processing in
%% MATLAB/ Python/R.

%% Author: Dr. VIBHOR AGARWAL

% Note: Please update the MASCON GRACE filename (CSR/JPL/GSFC)

% month=['Jan'; 'Feb'; 'Mar'; 'Apr'; 'May'; 'Jun'; 'Jul'; 'Aug'; 'Sep'; 'Oct'; 'Nov'; 'Dec'];

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

F=scatteredInterpolant(lon_perm,lat_perm, data_perm);

%% Check the number of solution in the GRACE MASCON/ L2
GRACE_path='E:\STORAGE_COEFF\MASCON\CSR\EWH\ewh_csr.mat'; %only CSR/JPL solution path
load(GRACE_path);
AA=(datestr(date_f));
time=decyear(date_f);
year_f=str2num(AA(:,8:11));
month_f=AA(:,4:6); %For finding the missing month name
I=find(year_f >= 2003 & year_f <= 2015);

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

clear A GWL GWL_path

%% Soil Moisture for Central Valley, 36 file

file='E:\STORAGE_COEFF\SOIL_MOISTURE\SOIL_2006_08.mat';
load(file);

F8=scatteredInterpolant((LON),(LAT), RZSM_f1(:,i)); % Interpolate the GRID for all teh values
SOIL_M=F8(lon_GWL,lat_GWL);

SOIL_M_F=[SOIL_M_F;SOIL_M];

%% Permeability, 1 file

% Finding permeability at GW well locations

PERM=F(lon_GWL,lat_GWL);

PERM_f=[PERM_f;PERM];

clear I_inf data_perm data1 info1 X1 Y1 x1 y1

%% PRISM- PPT (36 files, 2006-2008). PPT FILE HAS been preprocessed before
ppt_path='C:\PROJECT_FILES\INPUT_DATA\PPT\average_ppt_mat\';
[PPTT,~]=fx_dir(ppt_path,'.mat');

load(strcat(ppt_path,PPTT(i).name)); %loads lat, lon, mean_ppt
lat_ppt=lat;
lon_ppt=lon;
PPT=mean_ppt';

F2=scatteredInterpolant(lon_ppt,lat_ppt, PPT);
PPTT=F2(lon_GWL,lat_GWL);

PPT_f=[PPT_f;PPTT];

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
TEMP=F3(lon_GWL,lat_GWL);

TEMP_f=[TEMP_f;TEMP];

clear lat1 lon1 data mean_data lat_temp lon_temp TEMPT temp_path
%% MODIS_ET (36 files, 2006-2008)
modis_path='E:\STORAGE_COEFF\ET\MODIS\MOSIS_MAT\';
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
MODIS=F4(lon_GWL,lat_GWL);
MODIS_f=[MODIS_f;MODIS];

    clear lat1 lon1 data_MODIS lat_MODIS lon_MODIS MOD modis_path scale_factor
%% GRACE SOLUTIONS- (CSR, JPL, GSFC)
GRACE_path='E:\STORAGE_COEFF\CALIFORNIA\GRACE_RL06_CentralValley\monthly_GRACE.mat';
load(GRACE_path);
% m_GRACE=monthly_GRACE(:,i);
%m_GRACE=double(EWH_f(:,i)); %Monthly GRACE data solutions
m_GRACE=double(monthly_GRACE(:,i)); %Monthly GRACE data solutions
% Convert from 360 to -180 - 180 system
lon_GRACE1=rem((lon_GRACE+180),360)-180;
F5=scatteredInterpolant(lon_GRACE1,lat_GRACE, m_GRACE);
GRACE=F5(lon_GWL,lat_GWL); %Subsetting it as the 
GRACE_f=[GRACE_f;GRACE];

end

%Finally create the ANN variables
ANN_IN=[GRACE_f,PERM_f, SOIL_M_F, SLOPE_f,TEMP_f,PPT_f, MODIS_f];
%ANN_IN=[-GRACE_f,PERM_f, SOIL_M_F, TEMP_f, PPT_f, MODIS_f];
ANN_OUT=gwl_GWL_f;

ANN_IN=ANN_IN';                                                                                                             
ANN_OUT=ANN_OUT';
save('E:\STORAGE_COEFF\GW_ANN\WITH_SOIL_M\CSR_RL06\ANN_IP_pos_GRACE`.mat','ANN_IN', 'ANN_OUT');

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