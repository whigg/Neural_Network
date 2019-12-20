% This snippet reads the GWL from 2003- 2016
base='E:\STORAGE_COEFF\CALIFORNIA\California_well_data\';
[dir, ndir]=fx_dir(base);
well_id=[];
GWL=[];
      date=[];
lat=[];
lon=[];

counter=1;
year=2003:1:2016;
for i=1:ndir
      dir_name=strcat(base,dir(i).name,'\');
      [file, nfile]=fx_dir(dir_name,'.asc');
      
      % The belpow loop reads for a month
      % Reads such that only the .rmv is read
      for j=2:2:nfile
         filename=strcat(dir_name,file(j).name);
         Q1=dlmread(filename);
         well_id=[well_id;Q1(:,1)];
         dat=[Q1(:,2),Q1(:,3), Q1(:,4)];
         date=[date;mean(decyear(dat))];
%          lat=[lat;Q1(:,6)];
%          lon=[lon;-Q1(:,7)];
         GWL=[GWL;mean(Q1(:,9))]; 
      end
%       GWL_MEAN(counter)=mean(GWL);
%       TIME_MEAN(counter)=mean(date);
      
%       counter = counter +1;   
end

   
%     T=[lon, lat, well_id date GWL];
%     
%     cHeader = {'LON' 'LAT' 'Well_ID' 'date' 'GWL'}; %dummy header
%     commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
%     commaHeader = commaHeader(:)';
%     textHeader = cell2mat(commaHeader); %cHeader in text with commas
%     
%     
%     filename=strcat('E:\STORAGE_COEFF\CALIFORNIA\California_well_data\WELL\wells','_final','.csv');
%     
%     %write header to file
%     fid = fopen(filename,'w'); 
%     fprintf(fid,'%s\n',textHeader);
%     fclose(fid);
%     %Now append the data
%     dlmwrite(filename,T,'-append');     
plot(date,movmean(-GWL,3))
hold on 

scatter(date,-GWL)
          
    


