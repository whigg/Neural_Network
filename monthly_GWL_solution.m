%plot_monthly_GWL for period 2002-2016
% This function is used to visualize the monthly GW variations from the Groundwells
% You can also optionally compare it to modeled ANN GW observations
%Degree of fir parameters.
GWL_path='E:\STORAGE_COEFF\CALIFORNIA\California_well_data\WELL_OBS_ORIG\ALL_RMV_ASC\'; % Files are in .asc format
[GWL,n]=fx_dir(GWL_path,'.asc'); %Read the files in .asc format
YEAR_GWL=[];
lat_GWL=[];
lon_GWL=[];
gwl_GWL=[];
station_GWL=[];
month_GWL=[];
for i=1:n  % n is the total number of filews we have to consider
    A=load(strcat(GWL_path,GWL(i).name));
    station_GWL=[station_GWL;A(:,1)]; % Store all the station IDs
    year=A(:,2);
    month=A(:,3);
    date=A(:,4);
    dyear=decyear(year,month,date);
    YEAR_GWL=[YEAR_GWL;dyear];
    month_GWL=[month_GWL;month];
    lat_GWL=[lat_GWL;A(:,6)]; %Find all the data
    
    if A(:,7)>0
       lon_GWL=[lon_GWL;-A(:,7)]; %The wells are in Western Hemisphere
    else 
        lon_GWL=[lon_GWL;A(:,7)];
    end
    %GWLL=0.1*A(:,9); % Finding the  storage changes, optional
%     med_GWL=median(GWLL);
%     med_GWL=GWLL;
     gwl_GWL=[gwl_GWL;A(:,9)]; %Represent the GWL
end

[in1,on1] = inpolygon(lon_GWL,lat_GWL,lg_msk{1,1}.lon,lg_msk{1,1}.lat);


%Varibales to be neeeded for GW well segregarion
GW_out=NaN(750,1153); % there are exactly 1153 wells with max 723 observaytions for a siungle well
%ANN_GWL=NaN(1000,500);
times=NaN(750,1153);
%ANN_out=results.output';    
% Now we find all the unique wells
[Y,c]=unique(station_GWL); % all the unique station IDs (A) and their locations (c)
lat_well=lat_GWL(c); %coordinates of unique well
lon_well=lon_GWL(c);
% sum0=0;
sum1=[];
for z=1:length(Y)  %z represent the index of each unique well
    I= find(station_GWL==Y(z));  %here I is the index of obs of each station
    sum1=[sum1;numel(I)]; %find how many onservations for each Station ID Y(z), ie numel(I), 
    %sum1(z)=numel(I);
    GW_out(1:numel(I),z)=gwl_GWL(I); % Find out the GWL of each well z over time
%     ANN_GWL(1:numel(I),z)=ANN_out(I);
   times(1:numel(I),z)=YEAR_GWL(I);  %Find out the times at which wells have made observations.
end

load('E:\STORAGE_COEFF\CALIFORNIA\CA_State\Central_Valley.mat')
% Plotting if neccesary
figure
plot(lg_msk{1,1}.lon,lg_msk{1,1}.lat) % polygon
%index of the points inside and outside the polygon
%[in,on] = inpolygon(lon_well,lat_well,lg_msk{1,1}.lon,lg_msk{1,1}.lat);   
   %All the points inside/ outside the 
INDEXX=sum1(in);

gwl_GWL(in1)

lon_GWL(in1),lat_GWL(in1),gwl_GWL(in1), YEAR_GWL(in1),
%Also no. of observations for each well
%max(INDEXX)

%Save all the observations in the wells in a .MAT format
%save('E:\STORAGE_COEFF\CALIFORNIA\California_well_data\PROCESSED\MAT\GW_WELL.mat','GW_out','times','lat_well','lon_well');

% Save the coordinaates in excel format
% Export for Feeding into the Python
 T=[Y, lon_well, lat_well, sum1]; %Sum 1 is the number of observations
    
    cHeader = {'Station_ID' 'LON' 'LAT' 'NO_OBS'}; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    
    
    filename='E:\STORAGE_COEFF\CALIFORNIA\California_well_data\GIS_FILE\WELL_LOCATIONS.csv'; %location for storage
    
    % write header to file
    fid = fopen(filename,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
    % Now append the data
    dlmwrite(filename,T,'-append');
    

%Studying wells which have good temporal study historty
[val_max, ind_max]=max(sum1); % Find which wells (ie Station ID) (ind_max) have maximum observations (val_max)
GWL_well_max=-GW_out(1:val_max,ind_max);
% ANN_well_max=-ANN_GWL(1:val_max,ind_max);
%M=movmean(ANN_well_max,3);
TIME_well_max=times(1:val_max,ind_max);
%% save 
filename_plot1='GWL_Well_1.jpg'; %filename same as whhat was read .tif
path_file_plot1=fullfile('E:\STORAGE_COEFF\GW_ANN\INTERNAL CONSISTENCY\', filename_plot1); %path where file will be plotted



h=figure('visible', 'off');
set(h, 'Position', [1 1 600 300]);
    
set(gca,'FontSize',8);

plot(TIME_well_max,GWL_well_max);
M=movmean(ANN_well_max,3);
hold on
plot(TIME_well_max,M);

xlabel('Year');
ylabel('Groundwater Storage (m)');

legend ('Well', 'Model', 'Location', 'southwest', 'FontSize',8)

title('Groundwater Storage Variations', 'FontSize',14);
set(gca,'FontSize',14)
box on;
print(h, '-dtiff', '-r300', path_file_plot1);
%% 

r1=find(sum1>12 & sum1<=36);
val_sum=sum1(r1);
yy=1;
for t=1:length(r1)
    GWL_well_other=-GW_out(1:val_sum,r1(t));
    ANN_well_other=-ANN_GWL(1:val_sum,r1(t));
    TIME_well_other=times(1:val_sum,r1(t));
    filename_plot1=strcat('GWL_Well_other',num2str(t),'.jpg'); %filename same as whhat was read .tif
    path_file_plot1=fullfile('E:\STORAGE_COEFF\GW_ANN\INTERNAL CONSISTENCY\', filename_plot1); %path where file will be plotted
    
    h=figure('visible', 'off');
    set(h, 'Position', [1 1 600 300]);
    
    set(gca,'FontSize',8);

    plot(TIME_well_other,GWL_well_other);
    M=movmean(ANN_well_other,3);
    hold on
    plot(TIME_well_other,M);
    
    xlabel('Year');
    ylabel('Groundwater Storage (m)');

    legend ('Well', 'Model', 'Location', 'southwest', 'FontSize',8)
    
    title('Groundwater Storage Variations', 'FontSize',14);
    set(gca,'FontSize',14)
    box on;
    print(h, '-dtiff', '-r300', path_file_plot1);
    
end

