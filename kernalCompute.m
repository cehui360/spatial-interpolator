function k = kernalCompute(x,y,para,type,o,normals01,normals02)
        h = para.h; 
        r = para.r;
        q = para.q;
        n = size(x,1);
        m = size(y,1);
        if o == 1
            nor_x = repmat(normals02(:,1),1,m).*repmat(normals02(:,1)',n,1);
            nor_y = repmat(normals02(:,2),1,m).*repmat(normals02(:,2)',n,1); 
            nor_z = repmat(normals02(:,3),1,m).*repmat(normals02(:,3)',n,1);
        else
            nor_x = repmat(normals01(:,1),1,m).*repmat(normals02(:,1)',n,1);
            nor_y = repmat(normals01(:,2),1,m).*repmat(normals02(:,2)',n,1); 
            nor_z = repmat(normals01(:,3),1,m).*repmat(normals02(:,3)',n,1);
        end
        nor_xyz =1-(nor_x+nor_y+nor_z);
        deltx = repmat(x(:,1),1,m)-repmat(y(:,1)',n,1);
        delty = repmat(x(:,2),1,m)-repmat(y(:,2)',n,1);
        deltz = repmat(x(:,3),1,m)-repmat(y(:,3)',n,1);
        if strcmp(type, 'isotropic')
            d = deltx.^2 + delty.^2;
            z = deltz.^2;
            nor = nor_xyz.^2;
            k = exp(-d/(2*h^2)).*exp(-z/(2*r^2)).*exp(-nor/(2*q^2));
        end
end