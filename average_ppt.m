%% Reads three months PPT (anomaly data) data from PRISM and averages them
path='E:\STORAGE_COEFF\prism\PPT_ASC\MAT\'; %input file path
[fname,nfile]=fx_dir(path,'.mat');
for i=10:nfile %Start from Oct 2002
    %Read past 3 consective months
    file=fname(i).name;
    file1=fname(i-1).name;
    file2=fname(i-2).name;
    path_file=strcat(path,file);
    path_file1=strcat(path,file1);
    path_file2=strcat(path,file2);
    %Load the files
    A=load(path_file);
    lon=A.lon1; %coordibates of all the points are the same
    lat=A.lat1;
    B=load(path_file1);
    C=load(path_file2);
    mean_ppt=[];
    for j=1:length(A.data) %For all the points in the file A
         mean_ppt(j)=nanmean([A.data(j),B.data(j),C.data(j)]);
    end
%     mean_ppt;
%  save(strcat('E:\STORAGE_COEFF\prism\PPT_ASC\PPT_FINAL\PPT',num2str(i-12),'.mat'),'lon','lat','mean_ppt');
 
        if (i-12) <10
             %save the final PPT file as MAT file
             save(strcat('E:\STORAGE_COEFF\prism\PPT_ASC\PPT_FINAL\',file,'.mat'),'lon','lat','mean_ppt');
         else
             save(strcat('E:\STORAGE_COEFF\prism\PPT_ASC\PPT_FINAL\PPT',num2str(i-12),'.mat'),'lon','lat','mean_ppt');
         end
 %a=a+1;
end