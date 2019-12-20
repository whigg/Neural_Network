%function prepp_ANN
% PREPARES THE DATA FOR sTORAGE cOEFF ANALYSIS
% Moho
[data1, R1]=geotiffread('E:\STORAGE_COEFF\SCC_Grace\matlab_in\moho_dep_4km_Clip13.tif');
I1=GEOTIFF_READ2('E:\STORAGE_COEFF\SCC_Grace\matlab_in\moho_dep_4km_Clip13.tif');
%[x1,y1]=conv_coord2(data1, info1); %x - longitude, y - latitude or equivalent
[x1,y1]=meshgrid(I1.x, I1.y);
% x1=I1.x;
% y1=I1.y;
%Kriged_surface
[data2, R2]=geotiffread('E:\STORAGE_COEFF\SCC_Grace\matlab_in\krig_clip.tif');
I2=GEOTIFF_READ2('E:\STORAGE_COEFF\SCC_Grace\matlab_in\krig_clip.tif');
%[x2,y2]=conv_coord2(data2, info2);
% x2=I2.x;
% y2=I2.y;
[x2, y2]=meshgrid(I2.x, I2.y);
%Permeability
[data3, R3]=geotiffread('E:\STORAGE_COEFF\SCC_Grace\permeable\final_perm.tif');
I3=GEOTIFF_READ2('E:\STORAGE_COEFF\SCC_Grace\permeable\final_perm.tif');
%[x3,y3]=conv_coord2(data3, info3);
% x3=I3.x;
% y3=I3.y;
[x3, y3]=meshgrid(I3.x, I3.y);
%Soil type
A=readtable('E:\STORAGE_COEFF\SOILS\soil_fas.csv');
%A.
x4=A.Var1;
y4=A.Var2;
data4=A.Var3;
I4=GEOTIFF_READ2('E:\STORAGE_COEFF\SCC_Grace\matlab_in\soil_clip1.tif');
[x4, y4]=meshgrid(I4.x, I4.y);

%DEM-SLOPE
[data5, R5]=geotiffread('E:\STORAGE_COEFF\SCC_Grace\matlab_in\Slope_mosaic1_Clip1.tif');
I5=GEOTIFF_READ2('E:\STORAGE_COEFF\SCC_Grace\matlab_in\Slope_mosaic1_Clip1.tif'); 
%[x5,y5]=conv_coord2(data5, info5);
% x5=I5.x;
% y5=I5.y;
[x5,y5]=meshgrid(I5.x, I5.y);

%GRACE
[data, R]=geotiffread('E:\STORAGE_COEFF\SCC_Grace\matlab_in\RL06\SC_compp10_PointToRaster_RL01.tif');
I=GEOTIFF_READ2('E:\STORAGE_COEFF\SCC_Grace\matlab_in\RL06\SC_compp10_PointToRaster_RL01.tif');
%[x,y]=conv_coord2(data, info);
% x=I.x;
% y=I.y;
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

D=double(D);
D1=double(D1);
D3=double(D3);
D4=double(D4);
D5=double(D5);



I=find (D < 1);

X= X(I);
Y=Y(I);
D=D(I);
    
%Now get NANs
Na=D1(1);
[X1,Y1, D1]=getNAN(X1,Y1,D1, Na);
[X2,Y2, D2]=getNAN(X2, Y2, D2, Na);
[X3,Y3, D3]=getNAN(X3, Y3, D3, Na);
Na2=D4(1);
[X4,Y4, D4]=getNAN(X4, Y4, D4, Na2);
[X5,Y5, D5]=getNAN(X5, Y5, D5, Na);
Na2=min(D);
[X,Y, D]=getNAN(X, Y, D, Na2);



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
%d4=griddata(X4,Y4,D4,X2,Y2);
d4=round(d4); %because it is integer
% I=find(d4<0)
% if numel(I)>0
%     d4(I)=1;
% end
d5=F5(X2, Y2);
d=F(X2,Y2);
%d=abs(d); % Some negative values could be seen in the interpolated

ann_in=[d1 d d3 d4 d5];
ann_out=D2;

ann_in=ann_in';
ann_out=ann_out';

save('E:\STORAGE_COEFF\SCC_Grace\output\RL06_2\a10\network.mat', 'ann_in', 'ann_out');
%F=scatteredInterpolant()
%end