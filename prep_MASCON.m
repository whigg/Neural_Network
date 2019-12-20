source='C:\PROJECT_FILES\INPUT_DATA\GRACE_RESULTS\MASCON\CSR\CSR_GRACE_RL06_Mascons_all-corrections_v01.nc';
dest_path = 'C:\PROJECT_FILES\INPUT_DATA\GRACE_RESULTS\MASCON\CSR\GRACE_RL06_MASCON.mat';

lwe_thickness=ncread(source,'lwe_thickness');

time = ncread(source,'time'); %number of days from a set 
% time_bounds=ncread(source,'time_bounds');

%Reading the coordinates 
lon=ncread(source,'lon');  % lon : 1440 x 1
lat=ncread(source,'lat');  % lat : 720 x 1
lon_GRACE = lon(col)';

lon_GRACE=rem((lon_GRACE+180),360)-180;
lat_GRACE = flip(lat)';

for i = 1: size(lwe_thickness, 3)
    EWH = lwe_thickness(:,:,i)';
    for j=1:size(lwe_thickness,2)
        EWH_f(:,j) = flip(EWH(:,j));
    end
end


save(dest_path, 'lat_GRACE', 'lon_GRACE', 'time', 'EWH_f')
