function k = triple_kernalCompute(x,y,para,o,normals01,normals02,k1,k2)
        d = para.d; 
        q = para.q;
        g = para.g;
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
        if o == 1
            deltc = repmat(k2,1,m)-repmat(k2',n,1);
        else
            deltc = repmat(k1,1,m)-repmat(k2',n,1);
        end
            d1 = deltx.^2 + delty.^2;% euclidean distance
            nor = nor_xyz.^2;% normal 
            c = deltc.^2; % curvatures
            k = exp(-d1/(2*d^2)).*exp(-nor/(2*q^2)).*exp(-c/(2*g^2));% the trilateral kernel function
end