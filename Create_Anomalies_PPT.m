Combine the multiple '.MAT' files and Create the anomalies
PPT_path='C:\PROJECT_FILES\INPUT_DATA\ppt\average_ppt_mat\';
PPT_path_save='C:\PROJECT_FILES\INPUT_DATA\ppt\ppt_anomaly\PPT_ANOMALY.mat';
lat_extent=[34.3125,40.5625];
lon_extent=[-123.0625,-118.0625];

% Dummy variables
mean_ppt_acc=[];
month_ppt_acc=[];
time_acc=[];
I_track=[];

[nam_files, nfiles]=fx_dir(PPT_path,'.mat');
%Loop for number of files in the PPT
for i=124:nfiles
    file_read=nam_files(i).name;
    load(strcat(PPT_path,file_read));
    mean_ppt=mean_ppt';
    %%  FInd the PPT points within the Central VAlley
        I=find(LAT <= max(lat_extent) & LAT >= min(lat_extent) & LON <= max(lon_extent) & LON >= min(lon_extent));
        I_track=[I_track;numel(I)]; % Some months have missing values
        I_max=max(I_track);
    %% 
    
    if i==1
        LAT_c=round(LAT(I),4);
        LON_c=round(LON(I),4);
    end
    
    %For the messy case!!
    if (numel(I)>14788)
        
        LAT       = LAT(I);
        LON       = LON(I);
        mean_ppt  = mean_ppt(I);
        month_ppt = month_ppt(I);
   
        
        % Clearing the mess with Few PPT values
                A_mat = (round(LAT,4) == LAT_c') & (round(LON,4) == LON_c');
                sz=1; %counter variable for storing the 
                for k=1:size(LAT,1)
                    if isempty(LAT(k)) & isempty(LON(k))
                        continue;
                    end
                  
                   LATT(sz) = LAT(k,:);
                   LONN(sz) = LON(k,:);
                   mean_pptt(sz)  = mean_ppt(k,:);
                   month_pptt(sz) = month_ppt(k,:);
                    sz=sz+1;
                end
                LAT = LATT;
                LON = LONN;
                mean_ppt = mean_pptt;
                month_ppt = month_pptt;
    end
       
    if (numel(I) ==14788)
        LAT       = LAT(I);
        LON       = LON(I);
        mean_ppt  = mean_ppt(I);
        month_ppt = month_ppt(I);
    end
    
 
    %time 
    time_T    = str2num(file_read(4:9)); %of the form 200210
    year      = idivide(int32(time_T), 100);
    month     = time_T-(year*100);
    time      = datenum(double(year),double(month),15);
    
    mean_ppt_acc  = [mean_ppt_acc,mean_ppt]; %accumulate ppt from the year
    month_ppt_acc = [month_ppt_acc,month_ppt];
    time_acc      = [time_acc;time]; %its of the month
    
    
 end


This section deals with anomaly removal


year_read=idivide(int32(time_acc),100);
%%
I=find(time_acc<=2009 & time_acc>=2004);
%%
%Mean precipitation from 2004- 2009
ppt_0409=mean_ppt_acc(I);

mean_ppt_0409=nanmean(ppt_0409,2); %averaging along the rows

PPT_ANOMALY=mean_ppt_acc-mean_ppt_0409; % MATH: vector- constant

TIME      = time_acc;
MEAN_PPT  = mean_ppt_acc;
MONTH_PPT = month_ppt_acc;


save(PPT_path_save,'LAT','LON','TIME', 'MONTH_PPT', 'MEAN_PPT', 'PPT_ANOMALY');

