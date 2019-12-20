GRACE_path = 'C:\PROJECT_FILES\INPUT_DATA\GRACE_RESULTS\CentralValley_CSR_200204_201706.mat';
dest_path = 'C:\PROJECT_FILES\INPUT_DATA\GRACE_RESULTS\SEASONAL\GRACE_seasonal.mat';

load(GRACE_path);
time_GRACE  = ConvertSerialYearToDate(t1); %t1 is for left out months too
time_GRACE2 = ConvertSerialYearToDate(t2);

I_GRACE  = find(time_GRACE> 731490 & time_GRACE < 736634); %Between October 2002 and October 2016
% I_GRACE2 = find(time_GRACE2> 731490 & time_GRACE2 < 736634); %Between October 2002 and October 2016

time_GRACE = time_GRACE(I_GRACE);
% time_GRACE2 = time_GRACE2(I_GRACE2);

% [A, I_interp]=setdiff(time_GRACE2,time_GRACE); %The months which have been interpolated (to be re,oved later from the seasonal components)

 I=find(lg_msk_CentralValley==1);

% %Filter out only the months needed
% GRACE_grid_scaled = csr_grid_CentralValley_G300_Chen_scale(:,:,I_GRACE);
% GRACE_grid        = csr_grid_CentralValley_G300_Chen(:,:,I_GRACE);

%% Coordinate selection
[row, col]=find(lg_msk_CentralValley==1);
% Following variables are for creating the Grid for coordinates 
lon_grid= 0.125:0.25:359.875;
lat_grid = 89.875:-0.25:-89.875;
lon_grid=rem((lon_grid+180),360)-180;

lat_GRACE = lat_grid(row);
lon_GRACE  = lon_grid(col); 


GRACE_grid_scaled2 = csr_grid_CentralValley_G300_Chen_scale_interp(:,:,I_GRACE);
GRACE_grid2        = csr_grid_CentralValley_G300_Chen_interp(:,:,I_GRACE);

% 
% GRACE_grid2(:,:,I_interp)=[];
% GRACE_grid_scaled2(:,:,I_interp)=[];



for i=1:size(GRACE_grid_scaled2,3)
    GRACE_grid_scaled_t= GRACE_grid_scaled2(:,:,i);
    GRACE_vec_scaled(:,i) = GRACE_grid_scaled_t(I); %inside the Central Valley mask
    GRACE_grid_t= GRACE_grid2(:,:,i);
    GRACE_vec(:,i) = GRACE_grid_t(I);    %inside the Central Valley mask
end

for i=1:size(GRACE_vec)
    y5= GRACE_vec_scaled(i,:); %For a particular point, all time period included
    [~,~,~,~,~,GRACE_Ir]=seasonality2(y5, time_GRACE2, 'GRACE', 'N');
    GRACE_Irr(i,:)=GRACE_Ir(1,:);
end

% GRACE_Irr(I_interp) = []; %Just need the months which are not interpolated

save(dest_path, 'lat_GRACE', 'lon_GRACE', 'time_GRACE', 'GRACE_vec_scaled', 'GRACE_vec', 'GRACE_Irr');
