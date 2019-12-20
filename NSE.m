base='E:\STORAGE_COEFF\CALIFORNIA\output\final\';
[n_fold, nfold]=fx_dir(base);
for k=1:nfold
    fold=strcat(base,n_fold(k).name,'\');
    [n_file,~]=fx_dir(fold,'.csv');
    a=readtable(strcat(fold,n_file.name));
    obs=a.Var4;
    sim=a.Var3;
    E = obs - sim;
    SSE = sum(E.^2);

    u = mean(obs);
    SSU = sum((obs-u).^2);
    NSout = 1 - SSE/SSU;
    NSE_f(k)=NSout;
    RMSE_f(k)=sqrt(sum((obs-sim).^2)/numel(obs));
end
%obs=






