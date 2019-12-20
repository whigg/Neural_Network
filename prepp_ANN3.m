%function prepp_ANN
% Moho
I1=GEOTIFF_READ('E:\STORAGE_COEFF\SCC_Grace\moho\moho_dep_4km_Clip11.tif');
%info1=geotiffinfo('E:\STORAGE_COEFF\SCC_Grace\moho\moho_dep_4km_Clip11.tif');
[x1,y1]=meshgrid(I1.x, I1.y); %x - longitude, y - latitude or equivalent
%Kriged_surface
I2=GEOTIFF_READ('E:\STORAGE_COEFF\SCC_Grace\kriging\GALayerToGri2_ProjectRaster_41.tif');
% info2=geotiffinfo('E:\STORAGE_COEFF\SCC_Grace\matlab_in\GALayerToGri2_ProjectRaster_41.tif');
% [x2,y2]=conv_coord2(data2, info2);
[x2, y2]=meshgrid(I2.x, I2.y);
%Permeability
I3=GEOTIFF_READ('E:\STORAGE_COEFF\SCC_Grace\permeable\perm_fas2_PolygonToRaster2_P11.tif');
%info3=geotiffinfo('E:\STORAGE_COEFF\SCC_Grace\matlab_in\perm_fas2_PolygonToRaster2_P1.tif');
[x3, y3]=meshgrid(I3.x, I3.y);
%Soil type
I4=GEOTIFF_READ('E:\STORAGE_COEFF\SCC_Grace\soil_clip\soil_clip.tif');
%info4=geotiffinfo('E:\STORAGE_COEFF\SCC_Grace\matlab_in\soil_clip1.tif'); 
[x4, y4]=meshgrid(I4.x, I4.y);
%DEM-SLOPE
I5=GEOTIFF_READ('E:\STORAGE_COEFF\SCC_Grace\Slope\Slope_mosaic1_Clip1.tif');
%info5=geotiffinfo('E:\STORAGE_COEFF\SCC_Grace\matlab_in\Slope_mosaic1_Clip1.tif'); 
[x5,y5]=meshgrid(I5.x, I5.y);
%GRACE_solutions
I=GEOTIFF_READ('E:\STORAGE_COEFF\SCC_Grace\GRACE\SC_compp5_PointToRaster_Clip71.tif');
%info=geotiffinfo('E:\STORAGE_COEFF\SCC_Grace\matlab_in\SC_compp5_PointToRaster_Clip411.tif');
[x,y]=meshgrid(I.x, I.y);

X1=x1(:);    
X2=x2(:);
X3=x3(:);
X4=x4(:);
X5=x5(:);

Y1=y1(:);
Y2=y2(:);
Y3=y3(:);
Y4=y4(:);
Y5=y5(:);

X=x(:);
Y=y(:);

D1=data1(:);
D2=data2(:);
D3=data3(:);
D4=data4(:);
D5=data5(:);

D=data(:);
D1=double(D1);
D2=double(D2);
D3=double(D3);
D4=double(D4);
D5=double(D5);

Na=D1(1);
%Now get NANs
[X1,Y1, D1]=getNAN(X1,Y1,D1, Na);
[X2,Y2, D2]=getNAN(X2, Y2, D2, Na);
[X3,Y3, D3]=getNAN(X3, Y3, D3, Na);
[X4,Y4, D4]=getNAN(X4, Y4, D4, -1);
[X5,Y5, D5]=getNAN(X5, Y5, D5, Na);
[X,Y, D]=getNAN(X, Y, D, -1);



F=scatteredInterpolant(X,Y,D);
F1=scatteredInterpolant(X1,Y1,D1);
%F2=scatteredInterpolant(X2,Y2,D2);
F3=scatteredInterpolant(X3,Y3,D3);
F4=scatteredInterpolant(X4,Y4,D4);
F5=scatteredInterpolant(X5,Y5,D5);

d1=F1(X2,Y2);
%d2=F2(X2,Y2);
d3=F3(X2,Y2);
d4=F4(X2,Y2);
d4=round(d4); %because it is integer
d5=F5(X2, Y2);
d=F(X2,Y2);
%d=abs(d); % Some negative values could be seen in the interpolated

ann_in=[d1 D2 d3 d4 d5];
ann_out=d;

ann_in=ann_in';
ann_out=ann_out';

%F=scatteredInterpolant()
%end