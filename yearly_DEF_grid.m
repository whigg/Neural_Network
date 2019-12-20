% % Function to compute yearly grid of vertical deformation
%  function yearly_DEF_grid
% 
load('\\private\units\ses\agarwal282\Documents\fengweiigg-GRACE_Matlab_Toolbox-57ec72c\vibhor\res_f\RL06\SC_grid.mat');
%years=2003:1:2012;
temp1=str2num(cell2mat(str_year'));
I=find(temp1 >= 2003 & temp1 <= 2012);
tim=time(I);
 c= [tim(1:5); mean([tim(5),tim(6)]); tim(6:95); mean([tim(95),tim(96)]); tim(96:99); mean([tim(99),tim(100)]); tim(100:109); mean([tim(109),tim(110)]); tim(110:113); mean([tim(113),tim(114)]); tim(114:115)];
 def=grid_data_grace(:,:,I);
% 
%% Applying the easonal correction
[n,m,~]=size(deff);
%% 1. Apply 12 year moving average
% 
% a=1;
% for i=1:m
%     for j=1:n
%         deff(a,:)=def(i,j,:);
%         a=a+1;
%     end 
% end

for j=1:n
        %fill up the data gaps
        y=deff(j,:)'; %FOPR ALL TIME FOR A COORDINATE POINT
        % Filling up the data gaps
        b = [y(1:5); mean([y(5),y(6)]); y(6:95); mean([y(95),y(96)]); y(96:99); mean([y(99),y(100)]); y(100:109); mean([y(109),y(110)]); y(110:113); mean([y(113),y(114)]); y(114:115)]; 

        T = length(b);
        sW13 = [1/22;repmat(1/12,6,1);1/10;1/20]; %year stuff
        yS = conv(b,sW13,'same'); %To prevent observation loss, repeat the first and last smoothed values six times. 
                                  %Subtract the smoothed series from the original series to detrend the data. Add the moving average trend estimate to the observed time series plot.
        yS(1:6) = yS(7); yS(T-5:T) = yS(T-6);
        xt = b-yS;

%         h = plot(c, yS, 'r','LineWidth',2);
%         legend(h,'12-Term Moving Average')
%         hold off

        %% 2. Create seasonal indices.
        s = 12;
        sidx = cell(s,1);
        for i = 1:s
            sidx{i,1} = i:s:T;
        end

        %% 3. Apply a stable seasonal filter
        sst = cellfun(@(x) mean(xt(x)),sidx);

        % Put smoothed values back into a vector of length N
        nc = floor(T/s); % no. complete years
        rm = mod(T,s); % no. extra months
        sst = [repmat(sst,nc,1);sst(1:rm)];

        % Center the seasonal estimate (additive)
        sBar = mean(sst); % for centering
        sst = sst-sBar;

        SEASON(j,:)=sst; %FOR ALL TIME FOR A POINT
%         figure
%         plot(c,sst)
%         title 'Stable Seasonal Component';
%         h2 = gca;
%         % h2.XLim = [0 T];
%         ylabel 'EWH';
        % h2.XTick = 1:12:T;
        % h2.XTickLabel = datestr(dates(1:12:T),10);

        %% Deseasonalize the series.
%         dt = b - sst;
    end


lon=0.5:1:359.5;
lat=89.5:-1:-89.5;

average_def(1,:)=median(SEASON(:,:,1:12)); 

F=scatteredInterpolant(mascon_group.lon_cent, mascon_group.lat_cent,average_def(1,:)');
ave_grid_f(:,:,1)=F({lon, lat})';


for j=2:10
    average_def(j,:)=median(SEASON(:,:,(((j-1)*12+1):j*12))); %converting from cm to m
    F=scatteredInterpolant(mascon_group.lon_cent, mascon_group.lat_cent,average_def(j,:)');
    ave_grid_f(:,:,j)=F({lon, lat})';
end


save('\\private\units\ses\agarwal282\Documents\fengweiigg-GRACE_Matlab_Toolbox-57ec72c\vibhor\res_f\RL06\deformation_seas.mat','ave_grid_f')
% end        