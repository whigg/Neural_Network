% SC from Ojha
SC_in_f=[];
SC_el_f=[];
lat=[];
lon=[];
county_f=[];
for i=1:numel(county)
    lon=[lon,county(i).lon];
    lat=[lat,county(i).lat];
    countyy=repmat(i,1,numel(county(i).lon));
    county_f=[county_f, countyy];
    SC_in=repmat(county(i).inelasCoef,1,numel(county(i).lon));
    SC_in_f=[SC_in_f, SC_in];
    SC_el=repmat(county(i).elasCoef,1,numel(county(i).lon));
    SC_el_f=[SC_el_f, SC_el];
end
X5=lon';
Y5=lat';
D5=SC_in_f';
D5_1=SC_el_f';
nCounty=county_f';

    T=[X5, Y5, D5 nCounty];
    
    cHeader = {'LON' 'LAT' 'INEL_sc' 'county'}; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    
    
    filename='E:\STORAGE_COEFF\CALIFORNIA\ojha\INEL_sc3.csv';
    
    %write header to file
    fid = fopen(filename,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
    %Now append the data
    dlmwrite(filename,T,'-append'); 
    
    T=[X5, Y5, D5_1 nCounty];
    
    cHeader = {'LON' 'LAT' 'EL_sc' 'county'}; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    
    
    filename='E:\STORAGE_COEFF\CALIFORNIA\ojha\EL_sc3.csv';
    
    %write header to file
    fid = fopen(filename,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
    %Now append the data
    dlmwrite(filename,T,'-append');
