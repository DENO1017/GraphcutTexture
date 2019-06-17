function new_img = paste(pos, old_img, texture)
%return new_img with paste the texture in pos
%
%   INPUT:  pos, left-top of the position where the texture is going to be
%                pasted, 1-By-2 vector(x,y)
%           old,_img, 320-320-3 vector 
%           texture, Nx-Ny-3 vector
%
%   OUTPUT: new_img,  320-320-3 vector
%

new_img=old_img;
[Nx,Ny,~]=size(texture);
pos(:)=max(1,pos(:));
for i=1:Nx
    for j=1:Ny
        if texture(i,j,4)~=0
            new_img(pos(1)+i,pos(2)+j,:)=texture(i,j,:);
        end
    end
end

end