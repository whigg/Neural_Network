%% This function reads the PPT/ TEMP DATA in a.asc format and converts to MAT format
path='E:\STORAGE_COEFF\AUX_MODEL_DATA\prism\PPT_ASC\YEARS\';
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
       I=~isnan(data);
       data=data(I);
       %[x,y] = pix2map(R, 1, 1);
       %mkdir 'E:\STORAGE_COEFF\AUX_MODEL_DATA\prism\PPT_ASC\TIF_ALL_YEARS\str2num(filename(24:27))'
       tif_filepath='E:\STORAGE_COEFF\AUX_MODEL_DATA\prism\PPT_ASC\TIF_ALL_YEARS\'; %path for storage of PPT TIF TO 
       %tif_filename=strcat(filepath,'a',num2str(a),'.tif');
       tif_filename=strcat(tif_filepath,'PPT',filename(24:29),'.tif');
        geotiffwrite(tif_filename,im3,R);
        %info=geotiffinfo('a2.tif')
        I1=GEOTIFF_READ2(tif_filename);
        %[lat,lon] = projinv(info, x,y);  
        [x1,y1]=meshgrid(I1.x, I1.y);
        lon1=x1(:);
        lon1=lon1(I);
        lat1=y1(:);
        lat1=lat1(I);
%         mat_filepath='E:\STORAGE_COEFF\AUX_MODEL_DATA\prism\PPT_ASC\MAT_ALL_YEARS\';
%         save(strcat(mat_filepath,'PPT',filename(24:29),'.mat'),'lon1','lat1','data');
        
        mat_filepath='E:\STORAGE_COEFF\AUX_MODEL_DATA\prism\PPT_ASC\MAT_ALL_YEARS\';
        save(strcat(mat_filepath,'PPT',filename(24:29),'.mat'),'lon1','lat1','data');
        %a=a+1;
    end
end
