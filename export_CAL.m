DATA=(network_sim_outputs)';
DATA1=(network1_outputs)';
%DATA1=output';
ERROR1=(network1_errors)';
%ERROR1=error';
lon1=X1;
lat1=Y1;

I= find(DATA1>0);
lon1=lon1(I);
lat1=lat1(I);
DATA1=DATA1(I);
ERROR1=ERROR1(I);
DATA=DATA(I);
% X1=X1(I);
% Y1=Y1(I);

T=[lon1 lat1 DATA1 DATA ERROR1];
    
    cHeader = {'LON' 'LAT' 'SC' 'SC_SIM' 'error'}; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    
    
    filename='E:\STORAGE_COEFF\CALIFORNIA\output\a10\final\sim_out1.csv';
    
    %write header to file
    fid = fopen(filename,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
    %Now append the data
    dlmwrite(filename,T,'-append');
    



