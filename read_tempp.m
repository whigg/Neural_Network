%This function reads the PPT/ TEMP DATA and converts to MAT format
path='C:\PROJECT_FILES\MODIS\tmean_RAW\';
%a=1;
[nfolder, nf]=fx_dir(path);
for i=1:nf   %loop for years
    nfold_name=nfolder(i).name;
    nn=strcat(path,nfold_name,'\');
    [nam_file, nfile]=fx_dir(nn,'.asc');
    
    for j=1:nfile
       filename=nam_file(j).name; %the name of the file
       %tfile= filename% time of the file
       filename_path=strcat(nn,filename);
       [im3,R] = arcgridread(filename_path,'auto');
       data=im3(:);
       I=~isnan(data); % Clean up the NANs 
       TEMP=data(I);
       tif_filepath='C:\PROJECT_FILES\MODIS\tmean_TIF\'; %path for storage of PPT TIF TO 
       tif_filename=strcat(tif_filepath,'PPT',filename(24:29),'.tif');
        geotiffwrite(tif_filename,im3,R);
        %info=geotiffinfo('a2.tif')
        I1=GEOTIFF_READ2(tif_filename);
        %[lat,lon] = projinv(info, x,y);  
        [x1,y1]=meshgrid(I1.x, I1.y);
        LON=x1(:);
        LON=LON(I);
        LAT=y1(:);
        LAT=LAT(I);       
        mat_filepath='C:\PROJECT_FILES\MODIS\tmean_MAT\';
        save(strcat(mat_filepath,'PPT',filename(24:29),'.mat'),'LON','LAT','TEMP');
        %a=a+1;
    end
end

