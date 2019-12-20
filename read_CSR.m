function read_CSR

path='E:\STORAGE_COEFF\MASCON\CSR\CSR_GRACE_RL06_Mascons_all-corrections_v01.nc';
%path2='E:\STORAGE_COEFF\MASCON\JPL\CLM4.SCALE_FACTOR.JPL.MSCNv01CRIv01.nc';

lat= ncread(path,'lat');
lon= ncread(path,'lon');

[LON, LAT]=meshgrid(lon,lat);

lon_GRACE=LON(:);
lat_GRACE=LAT(:);

lwe_thickness= ncread(path,'lwe_thickness');
time= ncread(path,'time'); % contains number of days after 01 January, 2002
% uncertainty=ncread(path,'uncertainty'); %uncertainity for each year
% scale=ncread(path2,'scale_factor'); %read scale factor
% scale_factor=scale(:);
% I=find(isnan(scale_factor));
% scale_factor(I)=1; % Don't apply any scale factor for locations where you dn't have scale factpr defined
date_f=datenum(datetime('01-Jan-2002') + caldays(int16(time))); %
%Stores all the monthly values
EWH_f=[];
% uncertain_f=[];

for i=1:numel(time)
    
    lwe=lwe_thickness(:,:,i); %EWH for a particular month
%     uncert=uncertainty(:,:,i);
    EWH=lwe(:);
%     uncert=uncert(:);
%     EWH_scaled=EWH.*scale_factor;
%     uncertainty_scaled=uncert.*scale_factor;
    EWH_f=[EWH_f,EWH]; %store all monthly EWHs
%     uncertain_f=[uncertain_f,uncertainty_scaled];
%     EWH
end
save('E:\STORAGE_COEFF\MASCON\CSR\EWH\ewh_csr.mat','lat_GRACE','lon_GRACE','lon', 'lat', 'date_f','EWH_f');
