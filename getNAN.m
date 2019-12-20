function [X1, Y1, D1]= getNAN(X,Y,D, Na)

I= find (D~=Na);

X1=X(I);
Y1=Y(I);
D1=D(I);

end
