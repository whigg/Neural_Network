[data1, R1]=geotiffread('E:\STORAGE_COEFF\SOILS\MapunitRaster_10m2.tif');
I1=GEOTIFF_READ2('E:\STORAGE_COEFF\SOILS\MapunitRaster_10m2.tif');
%[x1,y1]=conv_coord2(data1, info1); %x - longitude, y - latitude or equivalent
[x1,y1]=meshgrid(I1.x, I1.y);

[data2, R2]=geotiffread('E:\STORAGE_COEFF\SOILS\MapunitRaster_10m3.tif');
I2=GEOTIFF_READ2('E:\STORAGE_COEFF\SOILS\MapunitRaster_10m3.tif');
%[x1,y1]=conv_coord2(data1, info1); %x - longitude, y - latitude or equivalent
[x2,y2]=meshgrid(I2.x, I2.y);

[data3, R3]=geotiffread('E:\STORAGE_COEFF\SOILS\MapunitRaster_10m4.tif');
I3=GEOTIFF_READ2('E:\STORAGE_COEFF\SOILS\MapunitRaster_10m4.tif');
%[x1,y1]=conv_coord2(data1, info1); %x - longitude, y - latitude or equivalent
[x3,y3]=meshgrid(I3.x, I3.y);

[data4, R4]=geotiffread('E:\STORAGE_COEFF\SOILS\MapunitRaster_10m5.tif');
I4=GEOTIFF_READ2('E:\STORAGE_COEFF\SOILS\MapunitRaster_10m5.tif');
%[x1,y1]=conv_coord2(data1, info1); %x - longitude, y - latitude or equivalent
[x4,y4]=meshgrid(I4.x, I4.y);

Y1=y1(:);
Y2=y2(:);
Y3=y3(:);
Y4=y4(:);

X1=x1(:);    
X2=x2(:);
X3=x3(:);
X4=x4(:);

D1=data1(:);
D2=data2(:);
D3=data3(:);
D4=data4(:);

Y=[Y1;Y2;Y3;Y4];
X=[X1;X2;X3;X4];
D=[D1;D2;D3;D4];

T=[X, Y, D];
    
    cHeader = {'LON' 'LAT' 'soil'}; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    
    
    filename='E:\STORAGE_COEFF\SOILS\soil_fas.csv';
    
    %write header to file
    fid = fopen(filename,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
    %Now append the data
    dlmwrite(filename,T,'-append');






