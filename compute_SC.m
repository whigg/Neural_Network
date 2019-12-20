function compute_SC
% computes Storage coefficients
load('\\private\units\ses\agarwal282\Documents\fengweiigg-GRACE_Matlab_Toolbox-57ec72c\vibhor\res_f\RL06\deformation.mat')
load('E:\STORAGE_COEFF\MASCON\EWH_GSFC\ICE6G\ewh.mat');
[~,~,ndim]=size(ave_grid_f);
lon=0.5:1:359.5;
lat=89.5:-1:-89.5;
[LON, LAT]=meshgrid(lon, lat);

for i=1:ndim
    sc_y=abs((ave_grid_f(:,:,i))*100./EWH_f(:,:,i)); %computation of SC
    a=1;
    for j=1:180
        for k=1:360
            SC_y(a)=sc_y(j,k);
            if i==1
                LAT_f(a)=LAT(j,k);
                LON_f(a)=LON(j,k);
            end
            a=a+1;
        end
    end
%     table(LAT_f', LON_f', SC_y');
    T=[LAT_f', LON_f', SC_y']; 
    cHeader = {'LAT' 'LON' 'SC'}; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    
    filename=strcat('\\private\units\ses\agarwal282\Documents\fengweiigg-GRACE_Matlab_Toolbox-57ec72c\vibhor\res_f\RL06\SC\SC_compp', num2str(i),'.csv');
    
    %write header to file
    fid = fopen(filename,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
    %Now append the data
    dlmwrite(filename,T,'-append');
end
end