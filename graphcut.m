function texture = graphcut(pos, pic, ot)
%return texture that can be pasted to a new picture
%
%   INPUT:  pos, left-top of the position where the texture is going to be
%                pasted, 1-By-2 vector(x,y)
%           pic, 320-320-4 vector 
%           ot, 32-32-4 vector, original texture
%
%   OUTPUT: texture,  32-32-4 vector
%
x1=max(1,-pos(1));
x2=min(size(ot,1),size(pic,1)-pos(1));
y1=max(1,-pos(2));
y2=min(size(ot,2),size(pic,2)-pos(2));
ot=ot(x1:x2,y1:y2,:);
pos(:)=max(1,pos(:));
[Nx,Ny,~]=size(ot);
mask=zeros(Nx,Ny,4);%1->pic,2->ot,3->index,4->border
texture=zeros(Nx,Ny,4);
for i=1:Nx
    for j=1:Ny
        if pic(pos(1)+i,pos(2)+j,4)==0
            texture(i,j,:)=ot(i,j,:);
        else
            mask(i,j,1)=sum(pic(pos(1)+i,pos(2)+j,1:3));
            mask(i,j,2)=sum(ot(i,j,1:3));
            mask(i,j,3)=1;
        end
    end
end

K=nnz(mask(:,:,3));
A=zeros(K+2,K+2);
k=1;
for i=1:Nx
    for j=1:Ny
        if mask(i,j,3)~=0
            k=k+1;
            mask(i,j,3)=k;
            if i==1 || i==Nx || j==1 || j==Ny
                mask(i,j,4)=1;
            end
            if pic(pos(1)+i-1,pos(2)+j,4) == 0 || pic(pos(1)+i+1,pos(2)+j,4) == 0 || pic(pos(1)+i,pos(2)+j-1,4) == 0 || pic(pos(1)+i,pos(2)+j-1,4) == 0 
                if mask(i,j,4)==1
                    mask(i,j,4)=0;
                else
                    mask(i,j,4)=2;
                end
            end
            if j<Ny && mask(i,j+1,3)~=0
                A(k,k+1)=abs(mask(i,j,1)-mask(i,j,2))+abs(mask(i,j+1,1)-mask(i,j+1,2));
            end
            if i<Nx && mask(i+1,j,3)~=0
                A(k,k+nnz(mask(i,j+1:Ny))+nnz(mask(i+1,1:j)))=abs(mask(i,j,1)-mask(i,j,2))+abs(mask(i+1,j,1)-mask(i+1,j,2));
            end
        end
    end
end

[a,b]=find(mask(:,:,4)==1);
for i=1:size(a)
    A(1,mask(a,b,3))=inf;
end

[a,b]=find(mask(:,:,4)==2);
for i=1:size(a)
    A(mask(a,b,3),K+2)=inf;
end


A=A+A';
G = graph(A);
[~,~,~,ct] = maxflow(G,1,K+2);

for i=1:size(ct)-1
    [x,y]=find(mask(:,:,3)==ct(i));
    texture(x,y,:)=ot(x,y,:);
end

end