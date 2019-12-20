% Function to move around files
path='C:\PROJECT_FILES\MODIS\ET_tif\';
a=1;
[nyear, n1]=fx_dir(path);
start_ind=[1,5,9,13,16,20,24,28,31,35,39,43];
end_ind=[4,8,12,15,19,23,27,30,34,38,42,46];
%for year
for i=6:n1
    name_year=nyear(i).name;
    src_folder=strcat(path,name_year,'\');
%     cd (src_folder)
    [nam,numb]=fx_dir(src_folder,'.tif'); 
    for month=1:12
        if month<10
            destination=strcat(src_folder,'0',num2str(month),'\');
        else
            destination=strcat(src_folder,num2str(month),'\');
        end
        fx_mkdir(destination);
               
        fx_copyfile(src_folder,'.tif',start_ind(month),end_ind(month),destination);
        fx_copyfile(src_folder,'.met',start_ind(month),end_ind(month),destination);
%         delete *.tif
%         delete .met
    end
end