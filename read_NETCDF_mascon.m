%% Read NetCDF MASCON file from CSR/ JPL etc
source='C:\PROJECT_FILES\INPUT_DATA\GRACE_RESULTS\MASCON\CSR\GRACE_RL06_MASCON.mat';
dest_path = 'C:\PROJECT_FILES\INPUT_DATA\GRACE_RESULTS\MASCON\CSR\GRACE_seasonal.mat';
% Original processed by Wrei Chen
GRACE_path = 'C:\PROJECT_FILES\INPUT_DATA\GRACE_RESULTS\CentralValley_CSR_200204_201706.mat';
load(source);
load(GRACE_path);

%Find The Central Valley Mask
% I_mask=find(lg_msk_CentralValley==1);
% [row, col]=find(lg_msk_CentralValley==1);

[LON, LAT]=meshgrid(lon_GRACE, lat_GRACE);

clear lon_GRACE lat_GRACE

I_mask=find (LAT < 41 & LAT > 34 & LON < -118 & LON > -124);

%Clippimng over Central Valley
lon_GRACE = LON(I_mask);
lat_GRACE = LAT(I_mask);

% time_GRACE  = ConvertSerialYearToDate(t1); %t1 is for left out months too
% I_GRACE  = find(time_GRACE> 731490 & time_GRACE < 736634); %Between October 2002 and October 2016
% time_GRACE = time_GRACE(I_GRACE);

for i=1:numel(time)
    [date,mont,month,year]=add_date(time(i)); %This function adds to a dte starting from Jan 1, 2002
    year = str2num(year);
    date = str2num(date);
    dec_time(i)= datenum(year, month, date);
%     datestr(strcat(date,'-',month, '-', year));
end

time_GRACE_temp = dec_time(5:156)'; %Only Oct 2002 to Sep 2016
EWH = EWH_f(:,:,5:156);   
a=1;
% Masking solutions with respect to time

% Some small corrections needed
% Special correction for some products might be needed

tm = datetime(time_GRACE_temp,'ConvertFrom','datenum');
year = tm.Year;
month = tm.Month;
day = tm.Day;
%Correcting small things
day(107) = day(107)-15; day(141) = day(141)-15;
month(107) = month(107)+1;  month(141) = month(141)+1;

time_GRACE = datenum(year, month, day);

for k=1:152
    EWH_t                 = EWH(:,:,k);
    GRACE_vec_scaled(:,k) = EWH_t(I_mask);
end

 % Now Seasonality
for i=1:size(GRACE_vec_scaled)
    y5= GRACE_vec_scaled(i,:); %For a particular point, all time period included
    [~,~,~,~,~,GRACE_Ir]=seasonality2(y5, time_GRACE, 'GRACE', 'N');
    GRACE_Irr(i,:)=GRACE_Ir(1,:);
end

save(dest_path, 'lat_GRACE', 'lon_GRACE', 'time_GRACE', 'GRACE_vec_scaled', 'GRACE_Irr');
    
    