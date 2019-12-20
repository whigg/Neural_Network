load('E:\STORAGE_COEFF\GW_ANN\FOR_SIMULATION\MONTHLY\ANN_IP_SIM_loc.mat')
gwl_GWL=[];
TIME_GWL=[];
[points, time]=size(SIM_ANN_OUT_f);

year=2006;
month=1;
for i=1:time
    
    if i==13
        year=2007;
        month=i-12; %resetting back to 1
    end
    if i==25
        year=2008;
        month=i-24;
    end
    
    YEAR_GWL=repmat(year,points,1);
    MON_GWL=repmat(month,points,1);
    DAT_GWL=repmat(15,points,1);
    
    dyear=decyear(YEAR_GWL,MON_GWL,DAT_GWL);
    %med_YEAR=median(dyear);
    med_YEAR=dyear;
    TIME_GWL=[TIME_GWL;med_YEAR];
    %med_GWL=median(SIM_ANN_OUT_f(:,i));
    med_GWL=SIM_ANN_OUT_f(:,i);
    gwl_GWL=[gwl_GWL;med_GWL];
    
    month=month+1;
 
end

TIME_month_f=[];
gwl_month_f=[];

TIME_GWL=round(TIME_GWL,1);
%     figure;
  
%     hold on
    for k=2006.0:0.1:2009.0
        I=find(TIME_GWL==k);
        TIME_month=TIME_GWL(I);
        TIME_month_f=[TIME_month_f;median(TIME_month)];
        gwl_month=gwl_GWL(I);
        gwl_month_f=[gwl_month_f;median(gwl_month)];
    end
    
    filename_plot1='GWL_SIM.jpg'; %filename same as whhat was read .tif
    path_file_plot1=fullfile('E:\STORAGE_COEFF\GW_ANN\PLOTS\SIM_DATA\', filename_plot1); %path where file will be plotted
    
     h=figure('visible', 'off');
    set(h, 'Position', [1 1 600 300]);
    
     set(gca,'FontSize',8);
    
    gwl_month_f=-gwl_month_f;
    M=movmean(gwl_month_f,2);
    hold on
    scatter(TIME_month_f,gwl_month_f, 10, 'filled');
    plot(TIME_month_f,M);
    xlabel('Year');
    ylabel('Groundwater Storage (m)');
    
    title('Groundwater Storage Variations', 'FontSize',14);
    set(gca,'FontSize',14)
    box on;
    print(h, '-dtiff', '-r300', path_file_plot1);
% save('E:\STORAGE_COEFF\GW_ANN\GW_ORIG.mat','lat_GWL','lon_GWL','YEAR_GWL','gwl_GWL');

