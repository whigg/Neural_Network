% Iw = (results2.net.IW{1,1});
% Lw = (results2.net.Lw{2,1});

Iw = network1.IW{1,1};
Lw = network1.LW{2,1};

for i=1:size(Iw,2)
    prod(:,i)=Iw(:,i).*Lw';
end
imp=sum(prod,1); 
rel_imp=imp/sum(imp);