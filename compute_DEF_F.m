% Function to compute Deformation

function compute_DEF_F
load('\\private\units\ses\agarwal282\Documents\fengweiigg-GRACE_Matlab_Toolbox-57ec72c\vibhor\res_f\RL06\ewh_mat.mat');
for i=1:numel(str_month') %for number of years in the array
 
    for j=1:61 %degree
        for k=1:61 %order
            f(j,k)=cs_grace(i,j,k);
        end
    end
    % mass coeff to geoid coeff
    a=gmt_mc2gc(f);
    % geoid coeff to loading coeff
    b=gmt_gc2lc(a);
    % to grid
    c(:,:,i)=gmt_cs2grid(b, 300, 1, 'SWENSON');
end
grid_data_grace=c;
save('\\private\units\ses\agarwal282\Documents\fengweiigg-GRACE_Matlab_Toolbox-57ec72c\vibhor\res_f\RL06\SC_grid.mat','grid_data_grace', 'str_year', 'str_month', 'time');


