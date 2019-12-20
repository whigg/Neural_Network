% SIMULATES THE RESULTS FOR CENTRAL VALLEY FOR STORAGE VARIATIONS
clear
%Looping through for each month
% gwl_GWL_f=[];
GRACE_f=[];
PERM_f=[];
% SLOPE_f=[];
% TEMP_f=[];
PPT_f=[];
% MODIS_f=[];

lat_perm_f=[];
lon_perm_f=[];

for i=1:36
 
%% Permeability, 1 file
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

data_perm_simulated=data_perm; %see explanation and description of thsi variable later on
data_perm=data_perm(I_inf);
lat_perm=lat_perm(I_inf);
lon_perm=lon_perm(I_inf);

PERM=data_perm;

PERM_f(:,i)=PERM;


clear X1 Y1 x1 y1

%% PRISM- PPT (36 files, 2006-2008)
ppt_path='E:\STORAGE_COEFF\prism\PPT_ASC\PPT_FINAL\';
[PPTT,~]=fx_dir(ppt_path,'.mat');

load(strcat(ppt_path,PPTT(i).name)); %loads lat, lon, mean_ppt
lat_ppt=lat;
lon_ppt=lon;
mean_ppt=mean_ppt';

F2=scatteredInterpolant(lon_ppt,lat_ppt, mean_ppt);
PPT=F2(lon_perm,lat_perm);

PPT_f(:,i)=PPT;

%clearing repeetive variables
clear lat lon data lat_ppt lon_ppt ppt_path PPTT

%% GRACE SOLUTIONS
GRACE_path='E:\STORAGE_COEFF\CALIFORNIA\GRACE_RL06_CentralValley\monthly_GRACE.mat';
load(GRACE_path);
m_GRACE=monthly_GRACE(:,i);
% Convert from 360 to -180 - 180 system
lon_GRACE1=rem((lon_GRACE+180),360)-180;
F5=scatteredInterpolant(lon_GRACE1,lat_GRACE, m_GRACE);
GRACE=F5(lon_perm,lat_perm);
GRACE_f(:,i)=GRACE;

ANN_IN_SIM=[GRACE,PERM, PPT];
% SIMULATED INPUT
ANN_IN_SIM=ANN_IN_SIM';

% SIMULATED OUTPUT
SIM_ANN_OUT=SIM_ANN_GWL(ANN_IN_SIM);
SIM_ANN_OUT_f(:,i)=-SIM_ANN_OUT; %MADE THE STORAGE OPPOSITE IN SIGN. WHERE WATER IS LOW< IT IS LOW

%Finally prepare to save the results

%     T=[X2, Y2, SIM_ANN_OUT];
%     
%     cHeader = {'LON' 'LAT' 'SC' 'error'}; %dummy header
%     commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
%     commaHeader = commaHeader(:)';
%     textHeader = cell2mat(commaHeader); %cHeader in text with commas
%    
    %Save the results in .tif'
   if i < 10
      filename=strcat('E:\STORAGE_COEFF\GW_ANN\FOR_SIMULATION\MONTHLY\SIM0',num2str(i),'.tif');
   else
       filename=strcat('E:\STORAGE_COEFF\GW_ANN\FOR_SIMULATION\MONTHLY\SIM',num2str(i),'.tif');
   end
   
   I_rep=find(data_perm_simulated~=data_perm_simulated(1));
   I_rep2=find(data_perm_simulated==data_perm_simulated(1));
   No_data=repmat(-9999,length(I_rep2),1);
   data_perm_simulated(I_rep2)= No_data;
   data_perm_simulated(I_rep)= SIM_ANN_OUT;
   
   [m,n]=size(data1);
   GWL=reshape(data_perm_simulated,[m,n]);
   imagefile='E:\STORAGE_COEFF\CALIFORNIA\ann_in\CentralV2_PolygonToRaster_Pr1.tif';
   RGB = imread(imagefile);
   worldfile = getworldfilename(imagefile);
   % Spatial reference object
   R = worldfileread(worldfile, 'geographic', size(RGB));
   
   geotiffwrite(filename, GWL, R)
   
   %write header to file
%    fid = fopen(filename,'w'); 
%    fprintf(fid,'%s\n',textHeader);
%    fclose(fid);
%    %Now append the data
%    dlmwrite(filename,T,'-append');
   
end

% For yearly modeling
%Finally create the ANN variables
ANN_IN_SIM=[GRACE_f,PERM_f, PPT_f];
%ANN_OUT=gwl_GWL_f;
ANN_IN_SIM=ANN_IN_SIM';
%ANN_OUT=ANN_OUT';
%save('E:\STORAGE_COEFF\GW_ANN\FOR_SIMULATION\MONTHLY\ANN_IP_SIM.mat','ANN_IN_SIM');
save('E:\STORAGE_COEFF\GW_ANN\FOR_SIMULATION\MONTHLY\ANN_IP_SIM_loc.mat','lat_perm','lon_perm', 'SIM_ANN_OUT_f');   