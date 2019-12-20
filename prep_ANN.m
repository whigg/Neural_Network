prepp_ANN
[data, R]=geotiffread('E:\STORAGE_COEFF\SCC_Grace\moho\moho_dep_4km_Clip11.tif');
info=geotiffinfo('E:\STORAGE_COEFF\SCC_Grace\moho\moho_dep_4km_Clip11.tif');
[data2, R2]=geotiffread('E:\STORAGE_COEFF\SCC_Grace\kriging\Krig_331.tif');
info2=geotiffinfo('E:\STORAGE_COEFF\SCC_Grace\kriging\Krig_331.tif');
[data3, R3]=geotiffread('E:\STORAGE_COEFF\SCC_Grace\permeable\florid_ras_PR1.tif');
info3=geotiffinfo('E:\STORAGE_COEFF\SCC_Grace\permeable\florid_ras_PR1.tif');
[data4, R4]=geotiffread('E:\STORAGE_COEFF\SCC_Grace\soil_clip\soil_clip.tif');
info4=geotiffinfo('E:\STORAGE_COEFF\SCC_Grace\soil_clip\soil_clip.tif'); 