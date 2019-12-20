%% Filter out the MODIS data (based on unacceptable values). MODIS data 
path='E:\STORAGE_COEFF\ET\MODIS\HEGOUT\';
a=1;
[nyear, n1]=fx_dir(path);
%for year
for i=1:3
    name_year=nyear(i).name;
    month_path=strcat(path,name_year,'\');
    [nmonth, n2]=fx_dir(month_path);
    %This one is for months
     for j=1:n2
         data3=[]; %null the vector for every month
       name_month=nmonth(j).name;
       tif_path=strcat(month_path,name_month,'\');
       [nfile, nf]=fx_dir(tif_path,'.tif');
       %This one is for the number of files in a month
       for k=1:nf
           
           nam_fil=nfile(k).name;
           tif_fil_path=strcat(tif_path,nam_fil);
           [data2, R2]=geotiffread(tif_fil_path);
            info = geotiffinfo(tif_fil_path);
            [x,y]=pixcenters(info);
            [x1,y1]=meshgrid(x, y);
           %edit the data
           data2=data2(:);
           x5=x1(:);
           y5=y1(:);
           %concat the data for all the weeks in a months
           data3=[data3, data2];
       end
           [m,n]=size(data3);
           for l=1:m
             %find values which are not acceptable
             I4=find(data3(l,:) ~= 32767 & data3(l,:) ~= 32766 & data3(l,:) ~= 32764 & data3(l,:) ~= 32761);
             %mean for all the months
             data5(l)=median(data3(l,I4));
%              x5=x1;
%              y5=y1;
           end
           I5=find(data5);
           y5=y5(I5);
           x5=x5(I5);
           data5=data5(I5);
           if a < 10
              tif_fil_save=strcat(tif_path,'MODIS0',num2str(a),'.mat');
           else
               tif_fil_save=strcat(tif_path,'MODIS',num2str(a),'.mat');
           end    
           save(tif_fil_save,'x5','y5','data5');
           
           a=a+1;
       end
     end
       
    
