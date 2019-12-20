%function prepp_ANN
% Moho
[data1, R1]=geotiffread('E:\STORAGE_COEFF\SCC_Grace\moho\moho_dep_4km_Clip11.tif');
info1=geotiffinfo('E:\STORAGE_COEFF\SCC_Grace\moho\moho_dep_4km_Clip11.tif');
[x1,y1,lat1,lon1]=conv_coord(data1, info1);
%Kriged_surface
[data2, R2]=geotiffread('E:\STORAGE_COEFF\SCC_Grace\kriging\GALayerToGri2_ProjectRaster_41.tif');
info2=geotiffinfo('E:\STORAGE_COEFF\SCC_Grace\kriging\GALayerToGri2_ProjectRaster_41.tif');
[x2,y2,lat2,lon2]=conv_coord(data2, info2);
%Permeability
[data3, R3]=geotiffread('E:\STORAGE_COEFF\SCC_Grace\permeable\perm_fas2_PolygonToRaster2_P11.tif');
info3=geotiffinfo('E:\STORAGE_COEFF\SCC_Grace\permeable\perm_fas2_PolygonToRaster2_P11.tif');
[x3,y3,lat3,lon3]=conv_coord(data3, info3);
%Soil type
[data4, R4]=geotiffread('E:\STORAGE_COEFF\SCC_Grace\soil_clip\soil_clip.tif');
info4=geotiffinfo('E:\STORAGE_COEFF\SCC_Grace\soil_clip\soil_clip.tif'); 
[x4,y4,lat4,lon4]=conv_coord(data4, info4);

%DEM-SLOPE
[data5, R5]=geotiffread('E:\STORAGE_COEFF\SCC_Grace\Slope\Slope_mosaic1_Clip1.tif');
info5=geotiffinfo('E:\STORAGE_COEFF\SCC_Grace\Slope_mosaic1_Clip1.tif'); 
[x5,y5,lat5,lon5]=conv_coord(data5, info5);


[data, R]=geotiffread('E:\STORAGE_COEFF\SCC_Grace\GRACE\SC_compp5_PointToRaster_Clip41.tif');
info=geotiffinfo('E:\STORAGE_COEFF\SCC_Grace\GRACE\SC_compp5_PointToRaster_Clip41.tif');
[x,y,lat,lon]=conv_coord(data, info);

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