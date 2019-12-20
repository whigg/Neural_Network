%function create_anaomaly

%Here we are assuming that all month data is available during 2002- 2017 

%% Stage 1:
%set up the refernce stage 2004-2009 and compute the average (mean)

function ANOMALY_REMOVAL(data)
filepath='E:\STORAGE_COEFF\AUX_MODEL_DATA\prism\PPT_ASC\MAT_ALL_YEARS\'; %precipitation data
[nam_file, nfile]=fx_dir(filepath);

load(strcat(filepath,nam_file(1).name));
sum=zeros(numel(data),1);
for i=25:96  %Starting from 2004 and ending in 2009 (6 years) 
    
    filename=nam_file(i).name;
    file_load=strcat(filepath,filename);
    load(file_load);
    sum=sum+data;
    
end

average_qty=sum/72; %create the anomaly with reference to 6 year period 