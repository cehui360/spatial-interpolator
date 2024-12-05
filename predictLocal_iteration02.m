function ez = predictLocal_iteration02(train,test,type,para)
     nk = para.nc; 
     [idx1, ~] = knnsearch(train(:,1:2),train(:,1:2),'k',nk,'nsmethod','kdtree');
     normals = [];
     for j=1:size(train,1)
         samples = train(idx1(j,:),:);
         [n,~]= M_Estimator(samples);
         normals(j,:) = n;
     end
     [idx2, ~] = knnsearch(test(:,1:2),test(:,1:2),'k',nk,'nsmethod','kdtree');
     for g=1:size(test,1)
         samples02 = test(idx2(g,:),:);
         [n02,~]= M_Estimator(samples02);
         normals001(g,:) = n02;
     end
     [idx, ~] = knnsearch(train(:,1:2),test(:,1:2),'k',nk,'nsmethod','kdtree');
     for i=1:size(test,1)
        data = train(idx(i,:),:);
        normals01 = normals001(i,:);
        normals02 = normals(idx(i,:),:);
        gama = para.gama;
        iteration = 0;
        SampleNum = size(data,1);
        P = ones(SampleNum,1);
        pc = size(P,2);
        while (1)
            iteration = iteration+1;
            K = kernalCompute(data,data,para,type.kernel,1,normals01,normals02);
            if iteration == 1
                WeightMatrix = sparse(diag(ones(SampleNum,1)/gama));
            else
            end
            G = K+WeightMatrix;
            B = [G P;P' zeros(pc)];
            L = [data(:,end);zeros(pc,1)];
            LSCoef = B\L;
            if iteration >= type.item 
                break
            end
        end
        K = kernalCompute(test(i,:),data,para,type.kernel,3,normals01,normals02);
        ez(i) = [K P]*LSCoef; 
    end   
end
