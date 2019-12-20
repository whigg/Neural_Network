base='E:\STORAGE_COEFF\SCC_Grace\output\RL06_2\';
base2='E:\STORAGE_COEFF\SCC_Grace\output\RL06_4var\';
folder=dir(base);
folder2=dir(base2);
for i=3:12
    if i==9
    continue;end
    curr_folder=folder(i).name;
    curr_folder2=folder2(i).name;
    curr_folder_path=strcat(base, curr_folder,'\');
    curr_folder2_path=strcat(base2, curr_folder2,'\');
    [file,~]=fx_dir(curr_folder_path,'.mat');
    [file2,~]=fx_dir(curr_folder2_path,'.mat');
    filename=file.name;
    filename2=file2.name;
    Z=load(strcat(curr_folder_path,filename));
    A=load(strcat(curr_folder2_path,filename2));
    if isfield(Z,'ann_in')
       SC_out(i-2,:)=Z.ann_out{1,1}(1,:); %supplied as target
    elseif isfield(Z,'results')
        SC_out(i-2,:)=Z.results.target(1,:);
     elseif isfield(Z,'results_f')
        SC_out(i-2,:)=Z.results_f.target_f(1,:);     
    else
        SC_out(i-2,:)=Z.results2.target(1,:);
    end
    
    if isfield(A,'network1_outputs')
       SC_sim(i-2,:)=A.network1_outputs{1,1}; %supplied as target
    elseif isfield(A,'network2_outputs')
        SC_sim(i-2,:)=A.network2_outputs{1,1};
     elseif isfield(A,'network3_outputs')
        SC_sim(i-2,:)=A.network3_outputs{1,1};     
     elseif isfield(A,'network4_outputs')
        SC_sim(i-2,:)=A.network4_outputs{1,1}; 
    else
        continue;
    end

end
for k=1:10
    if k==3 || k==7
        continue; end
    obs=SC_out(k,:);
    sim=SC_sim(k,:);
    E = obs - sim;
    SSE = sum(E.^2);
    u = mean(obs);
    SSU = sum((obs-u).^2);
    NSout = 1 - SSE/SSU;
    NSE_f(k)=NSout;
    RMSE_f(k)=sqrt(sum((obs-sim).^2)/numel(obs));
end