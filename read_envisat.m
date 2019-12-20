function read_envisat
curr_folder_path='E:\STORAGE_COEFF\CALIFORNIA\To_Vihbor\';
[file,nfile]=fx_dir(curr_folder_path,'.mat');
for i=1:nfile
    filename=file(i).name;
    load(strcat(curr_folder_path,filename));
    lat=Cor(:,2);
    lon=Cor(:,1);
    [m,n]=size(Threshold);
    % Run loop for each point
    for j=1:n
        height=Threshold(:,j);
    end
end

end
        
    