function fx_copyfile (srcc_folder,ext, start_ind, end_ind, destination)
[nam_dir,~]=fx_dir(srcc_folder,ext);
for i=start_ind:end_ind
  file_source = strcat(srcc_folder,nam_dir(i).name);
  copyfile (file_source, destination)
end
end