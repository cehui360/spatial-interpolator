function [normals,curvature] = MCS(points)
h0 = 3; 
%% Calculation of the number of iterations
% Pr = 0.9999;
% q = 0.5;
% I = round(log(1-Pr)/log(1-(1-q)^h0));
% I = 5; 
% %% MCS
% numPoints = size(points, 1);
% h = round(0.5*numPoints);  
% S_lambda0 = []; 
% h_subset = cell(1,I);
% for iter = 1:I
%     for j = 1:I
%         randomIndices  = randperm(numPoints, h0); 
%         subset = points(randomIndices, :);
%         while rank(subset) < h0
%             randomIndices  = randperm(numPoints, 1);
%             subset01 = points(randomIndices, :);
%             subset = vertcat(subset,subset01);
%         end 
%         meanPointCloud = mean(points);
%         for i = 1:numPoints
%             ODs(i) = calculateODs(subset,points(i,:), meanPointCloud);   
%         end
%         ODs = sort(ODs);
%         if abs(ODs(h) - ODs(1)) < abs(ODs(numPoints) - ODs(h+1))
%             h_subset{j} = points(1:h,:);
%         else
%             h_subset{j}= points(h+1:numPoints,:);
%         end
%         averP=mean(h_subset{j});
%         tempC=h_subset{j}-repmat(averP,h,1);
%         C=tempC'*tempC/h;
%         eigenvalues = eig(C);
%         lambda0 = min(eigenvalues);
%         S_lambda0(j) = lambda0;
%     end
% end
% minlambda0 = min(S_lambda0);
% minIndex = find(S_lambda0 == minlambda0);
% minIndex = minIndex(1);
% h_subset = h_subset{minIndex};
% %% MCMD_MD
% % robust_ph = mean(h_subset);
% % CC=points-repmat(robust_ph,numPoints,1);
% % covarianceMatrix=CC'*CC/numPoints;
% % %covarianceMatrix = cov(h_subset);
% % INdx = [];
% % OINdx = [];
% % for w = 1:numPoints
% %     RMD(w) = sqrt((points(i,:)-robust_ph)*inv(covarianceMatrix)*(points(i,:)-robust_ph)');
% %     if RMD(w) < 3.075
% %         INdx = [INdx, w];
% %     else
% %         OINdx = [OINdx, w];
% %     end
% % end
% %% MCMD_Z
% INdx = [];
% OINdx = [];
% robust_ph = mean(h_subset);
% for w = 1:numPoints
%     ODss(w) = calculateODs(h_subset,points(w,:), meanPointCloud); 
% end
% median_ODss = median(ODss);
% for z = 1:numPoints
%     median1(z) = abs(ODss(z) - median_ODss);
% end
% MAD = 1.4826*median(median1);
% for x = 1:numPoints
%     Rz(x) = abs(ODss(x)-median_ODss)/MAD;
%     if Rz(x) < 2.5
%         INdx = [INdx, w];
%     else
%         OINdx = [OINdx, w];
%     end   
% end
% points(OINdx,:) = [];
%% Classical method
Cleanmean_P=mean(points);
k = size(points,1);
tempCC=points-repmat(Cleanmean_P,k,1);
CC=tempCC'*tempCC/k;
[v,d] = eig(CC);
d = diag(d);
[lambda,kk] = min(d);  
%% store normals
normals = v(:,kk)';
%% store curvature
curvature = lambda / sum(d);