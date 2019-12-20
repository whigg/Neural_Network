%% This function can be used to read any file of the format netCDF4 (or adjusted to raed related formats).
%% This function computes the average of the daily SOIL_M values over a month tinme
%% Output is in the form of .MAT FILE GROUPED by YEARS
function read_SOIL_M
path_SOIL='C:\PROJECT_FILES\RAW_DATA\SOIL_MOISTURE_RAW\';  %path where the netcdf4 files lie
%[ndir,num]=fx_dir();
% Starting year
%year_read=2002; 
%Starting month
% month=1;
%Dummy variables
RZSM_d1=[];
RZSM_d2=[];
RZSM_d3=[];
RZSM_f=[];
time_f=[];

sum_file=0;

% lon_ext=-123.0625:0.125:-118.0625;  %the coordinate extent I have chooseen for Central valley
% lat_ext=34.3125:0.124:40.5625;

%Read the years 
%ndir is the number of years in the SOIL_MOISTURE package
[name_yr,ndir]=fx_dir(path_SOIL); 
for i=1:ndir
    year_read=name_yr(i).name; %string Format
    year=str2num(year_read);
    for month=1:12
      if month <10
        month_g=strcat('0',num2str(month)); %Reading the months properly
        %below line searches for all the files of a particular month from
        %the list
        %Reconstructs all the files of a given mpnth
        a=dir(strcat(path_SOIL,year_read,'\','NCALDAS_NOAH0125_D.A',year_read,month_g,'*'));
      else
        month_g=num2str(month);
        %checking how many files in a month
        a=dir(strcat(path_SOIL,year_read,'\','NCALDAS_NOAH0125_D.A',year_read,month_g,'*'));
      end
    %Stores the time corresponding to middle of the month
    t=strcat(year_read,'-',month_g,'-','15');
    time=datenum(datetime(t,'InputFormat','yyyy-MM-dd'));
    
    % Initializing the mean variables for amonth
    temp=[];
    LON_m=[];
    %LAT_m=NaN(6205,numel(a));
    LAT_m=[];
    
    SM_10_40_f=[];
    SM_40_100_f=[];
    SM_100_200_f=[];
  
    for j=1:numel(a)
       
        lat_SOIL=ncread(strcat(path_SOIL,name_yr(i).name,'\',a(j).name),'lat');
        lon_SOIL=ncread(strcat(path_SOIL,name_yr(i).name,'\',a(j).name),'lon');
        [LON, LAT]=meshgrid(lon_SOIL,lat_SOIL);
        lon_day=LON(:);
        lat_day=LAT(:);
        I=find((lon_day<=-118.0625 & lon_day>=-123.0625)&(lat_day<=40.5625 & lat_day >= 34.3125));
        if numel(I)<816
            continue;
        end
        LAT=lat_day(I);
        LON=lon_day(I);
        
        SM_10_40=ncread(strcat(path_SOIL,name_yr(i).name,'\',a(j).name),'SoilMoist10_40cm');
        %vectrorize
        SM_10_40=SM_10_40(:);
        %I=find(~isnan(SM_10_40)); %Find where soil moisture is not defined
        SM_10_40_f=[SM_10_40_f,SM_10_40(I)]; %accumulate Soil Moisture for all days in the month
        %SM_10_40_f=[SM_10_40_f,SM_10_40]; %accumulate Soil Moisture for all days in the month
        SM_40_100=ncread(strcat(path_SOIL,name_yr(i).name,'\',a(j).name),'SoilMoist40_100cm');
        SM_40_100=SM_40_100(:); %vectrorize
        SM_40_100_f=[SM_40_100_f,SM_40_100(I)]; %concating along colummns
        %SM_40_100_f=[SM_40_100_f,SM_40_100];
        SM_100_200=ncread(strcat(path_SOIL,name_yr(i).name,'\',a(j).name),'SoilMoist100_200cm');
        SM_100_200=SM_100_200(:); %vectrorize
        SM_100_200_f=[SM_100_200_f,SM_100_200(I)];
        %SM_100_200_f=[SM_100_200_f,SM_100_200];
%       
    end
    
        RZSM_1=nanmean(SM_10_40_f,2); %Mean along the rows rather than the column
        %Create timne vector for all locations in a month
        time_f=[time_f;repmat(time,numel(RZSM_1),1)];
        
        %Creating array for all the months
        RZSM_d1=[RZSM_d1,RZSM_1]; %Root Zone soil moisture for all months for depth 1
        RZSM_2=nanmean(SM_40_100_f,2);
        RZSM_d2=[RZSM_d2,RZSM_2];
        RZSM_3=nanmean(SM_100_200_f,2);
        RZSM_d3=[RZSM_d3,RZSM_3];
        RZSM_all=[RZSM_1, RZSM_2, RZSM_3]; %arranging the RSZM column wise
        RZSM=nanmean(RZSM_all,2);
        RZSM_f=[RZSM_f,RZSM]; %Final Root Zone Soil Moisture for all months over all the months
        
    %updating the variables
    sum_file=sum_file+numel(a); %Sum of all the files read, Counter Variables
   
    
    end    
end

%Removing the mean and the other stuff
I=(~isnan(RZSM_d1(:,:)));
I_1=I(:,1);
LAT=LAT(I_1);
LON=LON(I_1);
RZSM_d1=RZSM_d1(I_1,:);
RZSM_d2=RZSM_d2(I_1,:);
RZSM_d3=RZSM_d3(I_1,:);
RZSM_f=RZSM_f(I_1,:);
I_2=I(:);
time_f=time_f(I_2);
times=resize(time_f,276,180);
%  disp("We are done");
 
save('C:\PROJECT_FILES\INPUT_DATA\SOIL_MOISTURE_MAT\SOIL_2002_16_corrected2.mat','LON', 'LAT', 'time_f', 'times 'RZSM_f', 'RZSM_d1', 'RZSM_d2', 'RZSM_d3');

end

