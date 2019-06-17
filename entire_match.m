function P = entire_match(pos, pic, t, k)
%return the sum-of-squared-differences (SSD) cost
%
%   INPUT:  pos, left-top of the position where the texture is going to be
%                pasted, 1-By-2 vector(x,y)
%           pic, thecurrently synthesized output picture, Nx-Ny-4 vector 
%           t, the original texture, Nx-Ny-4 vector
%           k, controls the randomness in patch selection, double
%
%   OUTPUT: texture,  32-32-4 vector
%
sigma=std2(t);

x1=max(1,-pos(1));
x2=min(size(t,1),size(pic,1)-pos(1));
y1=max(1,-pos(2));
y2=min(size(t,2),size(pic,2)-pos(2));
t=t(x1:x2,y1:y2,:);
pos(:)=max(1,pos(:));
[Nx,Ny,~]=size(t);
mask=zeros(Nx,Ny,3);%1->pic,2->ot,3->exist

for i=1:Nx
    for j=1:Ny
        if pic(pos(1)+i,pos(2)+j,4)~=0
            mask(i,j,1)=sum(pic(pos(1)+i,pos(2)+j,1:3));
            mask(i,j,2)=sum(t(i,j,1:3));
            mask(i,j,3)=1;
        end
    end
end


N=0;
C=0;
for i=1:Nx
    for j=1:Ny
        if mask(i,j,3)~=0
            N=N+1;
            C=C+(mask(i,j,1)-mask(i,j,2))^2;
        end
    end
end

C=C/N;
P=exp(-C/(k*sigma*sigma));

end