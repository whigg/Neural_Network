S=shaperead('E:\STORAGE_COEFF\CALIFORNIA\ann_in\soil_fine.shp');
x4=[];
y4=[];
data4=[];
for i=1:numel(S)
     X_temp=(S(i).X)';
     x4=[X_temp;x4];
     Y_temp=(S(i).Y)';
     y4=[Y_temp;y4];
     D_temp=repmat(str2num(S(i).MUKEY), numel(X_temp),1);
     data4=[D_temp;data4];
    %[Grid, RefVec] = vec2mtx(sort(X_temp), sort(Y_temp), 60);
end



% MOHO
[data1, R1]=geotiffread('E:\STORAGE_COEFF\CALIFORNIA\ann_in\moho_dep_4km_Clip_Clip1.tif');
I1=GEOTIFF_READ2('E:\STORAGE_COEFF\CALIFORNIA\ann_in\moho_dep_4km_Clip_Clip1.tif');
%[x1,y1]=conv_coord2(data1, info1); %x - longitude, y - latitude or equivalent
[x1,y1]=meshgrid(I1.x, I1.y);

%Permeability
[data3, R3]=geotiffread('E:\STORAGE_COEFF\CALIFORNIA\ann_in\CentralV2_PolygonToRaster_Pr1.tif');
I3=GEOTIFF_READ2('E:\STORAGE_COEFF\CALIFORNIA\ann_in\CentralV2_PolygonToRaster_Pr1.tif');
%[x3,y3]=conv_coord2(data3, info3);
% x3=I3.x;
% y3=I3.y;
[x3, y3]=meshgrid(I3.x, I3.y);

%DEM-SLOPE
[data5, R5]=geotiffread('E:\STORAGE_COEFF\CALIFORNIA\ann_in\Slope_NOSAIC31.tif');
I5=GEOTIFF_READ2('E:\STORAGE_COEFF\CALIFORNIA\ann_in\Slope_NOSAIC31.tif'); 
%[x5,y5]=conv_coord2(data5, info5);
% x5=I5.x;
% y5=I5.y;
[x5,y5]=meshgrid(I5.x, I5.y);

%GRACE
[data, R]=geotiffread('E:\STORAGE_COEFF\CALIFORNIA\ann_in\SC_compp10_PointToRaster_RL01.tif');
I=GEOTIFF_READ2('E:\STORAGE_COEFF\CALIFORNIA\ann_in\SC_compp10_PointToRaster_RL01.tif');
[x,y]=meshgrid(I.x, I.y);


X1=x1(:);    
%X2=x2(:);
X3=x3(:);
X4=x4(:);
X5=x5(:);

Y1=y1(:);
%Y2=y2(:);
Y3=y3(:);
Y4=y4(:);
Y5=y5(:);

X=x(:);
Y=y(:);

D1=data1(:);
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

Na=D1(1);
[X1,Y1, D1]=getNAN(X1,Y1,D1, Na);
%[X2,Y2, D2]=getNAN(X2, Y2, D2, Na);
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

%d1=F1(X1,Y1);
%d2=F2(X2,Y2);
d3=F3(X1,Y1);
d4=F4(X1,Y1);
%d4=griddata(X4,Y4,D4,X2,Y2);
d4=round(d4); %because it is integer
% I=find(d4<0)
% if numel(I)>0
%     d4(I)=1;
% end
d5=F5(X1, Y1);
d=F(X1,Y1);

ann_in2=[D1 d d3 d5];

ann_in2=ann_in2';



