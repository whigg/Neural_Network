 % send output
%     network1_outputs=cell2mat(network1_outputs);
%     network1_errors=cell2mat(network1_errors);
%     T=[X2, Y2, output_f' error_f']; 
    T=[X2, Y2, results.output' results.error'];
    
    cHeader = {'LON' 'LAT' 'SC' 'error'}; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    
    
    filename='E:\STORAGE_COEFF\SCC_Grace\output\RL06_2\a1\sim_out1.csv';
    
    %write header to file
    fid = fopen(filename,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
    %Now append the data
    dlmwrite(filename,T,'-append');
    