%% This function can be used to read any file of the format netCDF4 (or adjusted to raed related formats).
%% This function computes the average of the daily SOIL_M values over a month tinme
%% Output is in the form of .MAT FILE GROUPED by YEARS
function read_SOIL_M_simplified
path_SOIL = 'C:\PROJECT_FILES\RAW_DATA\SOIL_MOISTURE_RAW\';  %path where the netcdf4 files lie
path_save = 'C:\PROJECT_FILES\INPUT_DATA\SOIL_MOISTURE\MAT\';
%[ndir,num]=fx_dir();
% Starting year
%year_read=2002; 
%Starting month
% month=1;
%Dummy variables

% lon_ext=-123.0625:0.125:-118.0625;  %the coordinate extent I have chooseen for Central valley
% lat_ext=34.3125:0.124:40.5625;

%Read the years 
%ndir is the number of years in the SOIL_MOISTURE package
[name_yr,ndir]=fx_dir(path_SOIL); 
for i=1:ndir
    year_read=name_yr(i).name; %string Format
    year=str2num(year_read);
    for month=1:12
        RZSM_f = [];
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
    

    
    SM_10_40_f  = [];
    SM_40_100_f = [];
    SM_100_200_f= [];
    time_f = [];
    
    for j=1:numel(a)
       
        lat_SOIL=ncread(strcat(path_SOIL,name_yr(i).name,'\',a(j).name),'lat');
        lon_SOIL=ncread(strcat(path_SOIL,name_yr(i).name,'\',a(j).name),'lon');
        [LON, LAT]=meshgrid(lon_SOIL,lat_SOIL);
        lon_day=LON(:);
        lat_day=LAT(:);
        %Clipping over Central Valley
        I_clip=find((lon_day<=-118.0625 & lon_day>=-123.0625)&(lat_day<=40.5625 & lat_day >= 34.3125));
        
        if numel(I_clip)<816
            continue;
        end
        
        LAT=lat_day(I_clip);
        LON=lon_day(I_clip);
        
        SM_10_40=ncread(strcat(path_SOIL,name_yr(i).name,'\',a(j).name),'SoilMoist10_40cm');
        SM_10_40=SM_10_40(:); %vectrorize
        %I=find(~isnan(SM_10_40)); %Find where soil moisture is not defined
        SM_10_40_f=[SM_10_40_f,SM_10_40(I_clip)]; %accumulate Soil Moisture for all days in the month
        %SM_10_40_f=[SM_10_40_f,SM_10_40]; %accumulate Soil Moisture for all days in the month
        SM_40_100=ncread(strcat(path_SOIL,name_yr(i).name,'\',a(j).name),'SoilMoist40_100cm');
        SM_40_100=SM_40_100(:); %vectrorize
        SM_40_100_f=[SM_40_100_f,SM_40_100(I_clip)]; %concating along colummns
        %SM_40_100_f=[SM_40_100_f,SM_40_100];
        SM_100_200=ncread(strcat(path_SOIL,name_yr(i).name,'\',a(j).name),'SoilMoist100_200cm');
        SM_100_200=SM_100_200(:); %vectrorize
        SM_100_200_f=[SM_100_200_f,SM_100_200(I_clip)];
        %SM_100_200_f=[SM_100_200_f,SM_100_200];
%       
    end
    
        RZSM_1=nanmean(SM_10_40_f,2); %Mean along the rows rather than the column, nx1 
        RZSM_2=nanmean(SM_40_100_f,2);
        RZSM_3=nanmean(SM_100_200_f,2);
        
        LAT(isnan(RZSM_1)) = [];
        LON(isnan(RZSM_1)) = [];
        RZSM_1(isnan(RZSM_1))=[];
        RZSM_2(isnan(RZSM_2))=[];
        RZSM_3(isnan(RZSM_3))=[];
        RZSM_f = (RZSM_1 + RZSM_2+ RZSM_3)/ 3;       
        
        time_f=[time_f;repmat(time,numel(RZSM_1),1)]; %Create timne vector for all locations in a month
        
    filesave = strcat(path_save,'SM',year_read, month_g,'.mat');
    save(filesave,'LON', 'LAT', 'time_f', 'RZSM_f', 'RZSM_1', 'RZSM_2', 'RZSM_3');

    end
    end
end

