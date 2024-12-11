function ez = quadruple_predictLocal(train,para)
     nk = para.nc; 
     item = 1;
     [idx1, ~] = knnsearch(train(:,1:2),train(:,1:2),'k',nk,'nsmethod','kdtree');
     normals = [];
     curvatures = [];
     for j=1:size(train,1)
         samples = train(idx1(j,:),:);
         [n,c]= MCS(samples);% calculate normals and curvatures.
         normals(j,:) = n;
         curvatures(j) = c;
     end
     [idx, ~] = knnsearch(train(:,1:2),train(:,1:2),'k',nk,'nsmethod','kdtree');
     for i=1:size(train,1)
        data = train(idx(i,:),:);
        normals01 = normals(i,:);
        normals02 = normals(idx(i,:),:);
        curvatures01 = curvatures(i)';
        curvatures02 = (curvatures(idx(i,:)))';
        lamba = para.lamba;
        iteration = 0;
        SampleNum = size(data,1);
        P = ones(SampleNum,1);
        pc = size(P,2);
        while (1)
            iteration = iteration+1;
            K = quadruple_kernalCompute(data,data,para,1,normals01,normals02,curvatures01,curvatures02);% the quadrilateral kernel function compute
            if iteration == 1
                WeightMatrix = sparse(diag(ones(SampleNum,1)/lamba));
            else
            end
            G = K+WeightMatrix;
            B = [G P;P' zeros(pc)];
            L = [data(:,end);zeros(pc,1)];
            LSCoef = B\L;
            if iteration >= item 
                break
            end
        end
        K = quadruple_kernalCompute(train(i,:),data,para,3,normals01,normals02,curvatures01,curvatures02);
        P = ones(size(K,1),1);
        ez(i) = [K P]*LSCoef; 
    end   
end
