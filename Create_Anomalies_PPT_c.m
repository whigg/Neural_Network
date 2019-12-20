% Combine the multiple '.MAT' files and Create the anomalies
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
for i=1:123:124
    file_read=nam_files(i).name;
    load(strcat(PPT_path,file_read));
    mean_ppt=mean_ppt';
    %%  FInd the PPT points within the Central VAlley
        I=find(LAT<=max(lat_extent) & LAT>= min(lat_extent) & LON<=max(lon_extent) & LON>= min(lon_extent));
%         I_track=[I_track;numel(I)]; % Some months have missing values
%         I_max=max(I_track);
    %% 
    if i==1
        LAT_c=num2str(round(LAT(I),4));
        LON_c=num2str(round(LON(I),4));
     end
    A=string(LAT_c)+string(LON_c);
    
    %For the messy case!!
    
    if (i==124)
        
        LAT       = num2str(round(LAT(I),4));
        LON       = num2str(round(LON(I),4));
%         mean_ppt  = mean_ppt(I);
%         month_ppt = month_ppt(I);
     
    end
    B=string(LAT)+string(LON);
end
  [o,p]=setdiff(A,B);   % values in A not in B
  [o1,p1]=setdiff(B,A);
  
  %Now A and B give the same result
  A(p)=[];              %Removing teh values in A not in B
  B(p1)=[];
  
  %%Values of LAT and LON for precipitation dataset (consolidated)
  LAT1=extractBetween(A,repmat(8,numel(A),1),repmat(16,numel(A),1));
  LON1=extractBetween(A,repmat(8,numel(A),1),repmat(16,numel(A),1));
  %%
  for i=1:nfiles
    file_read=nam_files(i).name;
    load(strcat(PPT_path,file_read));
    mean_ppt=mean_ppt';
    %%  FInd the PPT points within the Central VAlley
        I=find(LAT<=max(lat_extent) & LAT>= min(lat_extent) & LON<=max(lon_extent) & LON>= min(lon_extent));
%         I_track=[I_track;numel(I)]; % Some months have missing values
%         I_max=max(I_track);
    %% 
    % Putting it in the coordinate extent
      mean_ppt  = mean_ppt(I);
      month_ppt = month_ppt(I);
      
    % Using the appropriate cases
    if i<=123
        
        mean_ppt(p)  = [];
        month_ppt(p) = [];
    end
    A=string(LAT_c)+string(LON_c);
    
    %For the messy case!!
        if (i>=124)
        mean_ppt(p1)  = [];
        month_ppt(p1) = [];
    end
  
          
    %time 
    time_T    = str2num(file_read(4:9)); %of the form 200210
    year      = idivide(int32(time_T), 100); %Get the year
    month     = time_T-(year*100); %Get the month
    time      = datenum(double(year),double(month),15); %Get the datenum vector of the values
    
    mean_ppt_acc  = [mean_ppt_acc,mean_ppt]; %accumulate ppt from the year
    month_ppt_acc = [month_ppt_acc,month_ppt];
    time_acc      = [time_acc;time]; %its of the month
  end
%     
%     
% 
% 
% 
% %This section deals with anomaly removal
% 
% 
% year_read=idivide(int32(time_acc),100);
% %%
% I=find(time_acc<=2009 & time_acc>=2004);
% %%
% %Mean precipitation from 2004- 2009
% ppt_0409=mean_ppt_acc(I);
% 
% mean_ppt_0409=nanmean(ppt_0409,2); %averaging along the rows
% 
% PPT_ANOMALY=mean_ppt_acc-mean_ppt_0409; % MATH: vector- constant
% 
% TIME      = time_acc;
% MEAN_PPT  = mean_ppt_acc;
% MONTH_PPT = month_ppt_acc;
% 
% 
% save(PPT_path_save,'LAT','LON','TIME', 'MONTH_PPT', 'MEAN_PPT', 'PPT_ANOMALY');

