% Function to compute monthly GRACE values of EWH
function monthly_EWH_val
load('\\private\units\ses\agarwal282\Documents\fengweiigg-GRACE_Matlab_Toolbox-57ec72c\vibhor\EWH_CSR_RL06\EWH_RL06.mat');
[~,~, ndim]=size(grid_data_grace);
lat=90:-0.25:-90;
lon=0:0.25:359.75;
[lon1, lat1]=meshgrid(lon,lat);

lon_vct=lon1(:);
lat_vct=lat1(:);

for i=1:ndim
     c=grid_data_grace(:,:, ndim);
     grid_GRACE(:,i)=c(:);
     
end

fname='E:\STORAGE_COEFF\CALIFORNIA\CA_State\CA_STATE_WGS\CA_TIGER_WGS';

c=cell(1,1);
idx=1;

M=m_shaperead(fname);
field=fieldnames(M); 
% names = fieldnames(s) returns a cell array of character vectors 
% containing the names of the fields in structure s.
CAL=cell(1,1);
polygon=M.ncst{1,1};
bound_x=M.MBRx;
bound_x=mod(bound_x,360);
bound_y=M.MBRy;
lon_ST=polygon(:,1);
lat_ST=polygon(:,2);
lon_ST=mod(lon_ST,360);

I=find(lat_vct < bound_y(2,1) & lat_vct > bound_y(1,1) & lon_vct < bound_x(2,1) & lon_vct > bound_x(1,1));
%I2=inpolygon(lon_vct, lat_vct, lon_ST, lat_ST); 

monthly_GRACE=grid_GRACE(I,:);
lat_GRACE=lat_vct(I);
lon_GRACE=lon_vct(I);

save('E:\STORAGE_COEFF\CALIFORNIA\GRACE_RL06_CentralValley\monthly_GRACE.mat','lat_GRACE','lon_GRACE','monthly_GRACE');
end

