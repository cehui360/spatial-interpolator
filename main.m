clear all  
clc
warning  off all
%% Parameter setting
type = struct('kernel','isotropic','item',1);
para = struct('iterations',1,'nc',10,'item',0,'gama',13,'h',3.5,'r',1.6,'q',20);
%% Input modeling_data
data = dlmread('modeling_data.txt');
minx = min(data(:,1));
maxx = max(data(:,1));
miny = min(data(:,2));
maxy = max(data(:,2));
%% Optimal grid resolution
% ns1 = createns(data(:,1:2),'NsMethod','kdtree');
% [N,D] = knnsearch(ns1,data(:,1:2),'k',2);
% ps = mean(D(:,2));   
% %m = mean(D(:,2)./2); 
m = 1;
%% Input verify_data
testdata = dlmread('verify_data');
testdata(testdata(:,1)<minx,:) = [];
testdata(testdata(:,2)<miny,:) = [];
testdata(testdata(:,1)>maxx,:) = [];
testdata(testdata(:,2)>maxy,:) = [];
xt = testdata(:,1:2);
ze = testdata(:,3);
Num = size(testdata,1);
%% Grid point construction
xgrid = (minx - m/2):m:maxx;
ygrid = (miny - m/2):m:maxy;
[xg,yg] = meshgrid(xgrid,ygrid);
[r,c] = size(xg);
tablehead = struct('ncols',c,'nrows',r,'xllcorner',minx - m/2,'yllcorner',miny - m/2,'cellsize',m);
xg = reshape(xg,r*c,1);
yg = reshape(yg,r*c,1);
F = scatteredInterpolant(data(:,1:2),data(:,3),'natural','nearest');
zz1 = F(xg,yg); 
estimate = [xg yg zz1];
%% iteration
iterations = para.iterations;
h = para.h;
r1 = para.r;
gama = para.gama;
q = para.q;
for i = 1:iterations
    disp(['iteration ', num2str(i)]);
    if i == 1
        zs = predictLocal_iteration01(data,estimate,type,para);
        zs = zs';
    else
        zs = predictLocal_iteration02(data,estimate,type,para);
        zs = zs';
    end
    estimate(:,3) = zs;
    h = h - 0.01;
    r1 = r1 - 0.01;
    gama = gama + 0.01;
    q = q + 0.01;
    tol = max(abs(zs - estimate(:,3)));
    if tol < 0.005
        break;  
    end
end
zs = reshape(zs,r,c);
zs1 = reshape(zz1,r,c);
%% Precision testing
col = floor((testdata(:,1)-(minx-m/2))/m)+1;
row = floor((testdata(:,2)-(miny-m/2))/m)+1;
idxtest = (col-1)*r+row;
zz = zs(idxtest);
error0 = ze-zz;
error0(isnan(error0))=[];
rmse0 = sqrt(sum(error0.^2)/Num);
me0 = mean(abs(error0));
maxe0 = max(error0);
mine0 = min(error0);
error1 = ze-zz1(idxtest);
error1(isnan(error1))=[];
rmse_nn = sqrt(sum(error1.^2)/Num);
fprintf(1,'Max_error%.3fm Min_error%.3fm MAE%.3fm RMSE%.3fm\n',maxe0,mine0,me0,rmse0);
%% Saving
zs = flip(zs,1);
zs1 = flip(zs1,1);
filename = strcat('griddem','.txt');
saveM2GisFile('nn_grid.txt',tablehead,zs1) 
saveM2GisFile(filename,tablehead,zs) 
