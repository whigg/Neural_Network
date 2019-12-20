function compute_SC_F
load('\\private\units\ses\agarwal282\Documents\fengweiigg-GRACE_Matlab_Toolbox-57ec72c\vibhor\res_f\FINAL\final\cs_gsm_csr_vibhor_2002_2012_fltr300km_2.mat');
for i=1:131 %for number of years in the array
 
    for j=1:61 %degree
        for k=1:61 %order
            f(j,k)=cs_grace(i,j,k);
        end
    end
       a=gmt_mc2gc(f);
    b=gmt_gc2lc(a);
    c(:,:,i)=gmt_cs2grid(b, 200, 1, 'SWENSON');
end
grid_data_grace=c;
save('\\private\units\ses\agarwal282\Documents\fengweiigg-GRACE_Matlab_Toolbox-57ec72c\vibhor\res_f\SC_grid.mat','grid_data_grace', 'str_year', 'str_month', 'time');


