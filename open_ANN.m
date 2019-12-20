%% ANN for traing SC
base='E:\STORAGE_COEFF\SCC_Grace\output\RL06_2\';
folder=dir(base);
for i=3:12
    curr_folder=folder(i).name;
    curr_folder_path=strcat(base, curr_folder,'\');
    [file,~]=fx_dir(curr_folder_path,'.csv');
    [file2,~]=fx_dir(curr_folder_path,'.mat');
    filename=file.name;
    filename2=file2.name;
    A=readtable(strcat(curr_folder_path,filename));
    Z=load(strcat(curr_folder_path,filename2));
    if isfield(Z,'ann_in')
       SC_in(i-2,:)=Z.ann_in{1,1}(2,:); %supplied as input
       SC_out(i-2,:)=Z.ann_out{1,1}(1,:); %supplied as target
       moho=Z.ann_in{1,1}(1,:);
       perm=Z.ann_in{1,1}(3,:);
       %soil=Z.ann_in{1,1}(4,:);
       dem_slope=Z.ann_in{1,1}(5,:);
    elseif isfield(Z,'results')
        SC_in(i-2,:)=Z.results.input(2,:);
        SC_out(i-2,:)=Z.results.target(1,:);
        moho=Z.results.input(1,:);
        perm=Z.results.input(3,:);
        %soil=Z.results.input(4,:);
        dem_slope=Z.results.input(5,:);
     elseif isfield(Z,'results_f')
        SC_in(i-2,:)=Z.results_f.input_f(2,:);
        SC_out(i-2,:)=Z.results_f.target_f(1,:);
        moho=Z.results_f.input_f(1,:);
        perm=Z.results_f.input_f(3,:);
        %soil=Z.results.input(4,:);
        dem_slope=Z.results_f.input_f(5,:);
    else
        SC_in(i-2,:)=Z.results2.input(2,:);
        SC_out(i-2,:)=Z.results2.target(1,:);
        moho=Z.results2.input(1,:);
        perm=Z.results2.input(3,:);
        %soil=Z.results2.input(4,:);
        dem_slope=Z.results2.input(5,:);
    end
    %lon(i-2,:)=A.Var1;
    lon=A.Var1;
    %lat(i-2,:)=A.Var2;
    lat=A.Var2;
    SC_model(i-2,:)=A.Var3; %coming from ANN model
    error(i-2,:)=A.Var4; %error from ANN model
end
[m,n]=size(SC_in);
% Finding minimum error spots
% for j=1:n
%     [min_error, I_min]=min(abs(error(:,j)));
%     SC_in_min(j)=SC_in(I_min,j);
%     ERROR_min(j)=min_error;
%     SC_out_min(j)=SC_out(I_min, j);
%     SC_model_min(j)=SC_model(I_min,j);
% end
% %ANN_IN=[moho; SC_in_min; perm; soil; dem_slope]
% ANN_IN=[moho; SC_in_min; perm; dem_slope];
% ANN_OUT=[SC_out_min];

SC_out_mean=mean(SC_out);
ERROR_mean=mean(error);
SC_in_mean=mean(SC_in);

ANN_IN=[moho; SC_in_mean; perm; dem_slope];
ANN_OUT=[SC_out_mean];

