year=[2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013];

i=7; %year for which modeling has to done

% Target: GW level data
[data, R]=geotiffread('E:\STORAGE_COEFF\CALIFORNIA\ESI_PROPOSAL\PRISM_ppt_stable_4kmM3_2009_1.tif');
I=GEOTIFF_READ2('E:\STORAGE_COEFF\CALIFORNIA\ESI_PROPOSAL\PRISM_ppt_stable_4kmM3_2009_1.tif');
[x, y]=meshgrid(I.x, I.y);
X=x(:);
Y=y(:);
D=data(:);


% %Finding GWL data for a fixed year
% I= find(date>= year(i) & date < year(i));
% 
% GWL=GWL(I);
% date=date(I);
% lat=lat(I);
% lon=lon(I);

% Input:
%IP1: Permeability- same for all years
[data3, R3]=geotiffread('E:\STORAGE_COEFF\CALIFORNIA\ann_in\CentralV2_PolygonToRaster_Pr1.tif');
I3=GEOTIFF_READ2('E:\STORAGE_COEFF\CALIFORNIA\ann_in\CentralV2_PolygonToRaster_Pr1.tif');
%[x3,y3]=conv_coord2(data3, info3);
% x3=I3.x;
% y3=I3.y;
[x3, y3]=meshgrid(I3.x, I3.y);
X3=x3(:);
Y3=y3(:);
D3=data3(:);

%IP2: EWH MASCON for year 2003-2013
load('E:\STORAGE_COEFF\MASCON\EWH_GSFC\ICE6G\ewh.mat');
Storage=EWH_f(:,:,i);
a=1;
i=1;
for j=1:180
        for k=1:360
            EWH(a)=Storage(j,k);
            if i==1
                LAT_f(a)=LAT(j,k);
                LON_f(a)=LON(j,k);
                i=i+1;
            end
            a=a+1;
        end
end

X4=LAT_f;
Y4=LON_f;
D4=EWH;

%IP3: PRISM- Precipitation
[data1, R1]=geotiffread('E:\STORAGE_COEFF\CALIFORNIA\ESI_PROPOSAL\PRISM_ppt_stable_4kmM3_2009_1.tif');
I1=GEOTIFF_READ2('E:\STORAGE_COEFF\CALIFORNIA\ESI_PROPOSAL\PRISM_ppt_stable_4kmM3_2009_1.tif');
%[x3,y3]=conv_coord2(data3, info3);
% x3=I3.x;
% y3=I3.y;
[x1, y1]=meshgrid(I1.x, I1.y);

X1=x1(:);
Y1=y1(:);
D1=data1(:);

%IP4: PRISM- TEMP
[data2, R2]=geotiffread('E:\STORAGE_COEFF\CALIFORNIA\ESI_PROPOSAL\PRISM_tmean_stable_4kmM2_2001.tif');
I2=GEOTIFF_READ2('E:\STORAGE_COEFF\CALIFORNIA\ESI_PROPOSAL\PRISM_tmean_stable_4kmM2_2001.tif');
%[x3,y3]=conv_coord2(data3, info3);
% x3=I3.x;
% y3=I3.y;
[x2, y2]=meshgrid(I2.x, I2.y);
X2=x2(:);
Y2=y2(:);
D2=data2(:);

% SC from Ojha- inelastic
[data5, R5]=geotiffread('E:\STORAGE_COEFF\CALIFORNIA\ojha\New Folder\ojha_2009_PolygonToRaster1.tif');
I5=GEOTIFF_READ2('E:\STORAGE_COEFF\CALIFORNIA\ojha\New Folder\ojha_2009_PolygonToRaster1.tif');
[x5, y5]=meshgrid(I5.x, I5.y);
X5=x5(:);
Y5=y5(:);

D5=SC_in_f';
D5_1=SC_el_f';


