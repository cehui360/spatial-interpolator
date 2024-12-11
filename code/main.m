clear all  
clc
warning  off all
%% Input modeling_data
data = dlmread('s23-modeling.txt');
minx = min(data(:,1));
maxx = max(data(:,1));
miny = min(data(:,2));
maxy = max(data(:,2));
%% Input checking_data
testdata = dlmread('s23-checking.txt');
testdata(testdata(:,1)<minx,:) = [];
testdata(testdata(:,2)<miny,:) = [];
testdata(testdata(:,1)>maxx,:) = [];
testdata(testdata(:,2)>maxy,:) = [];
xt = testdata(:,1:2);
ze = testdata(:,3);
Num = size(testdata,1);
%% Parameter setting
para = struct('iterations',6,'nc',10,'lamba',5.8,'d',2.8,'h',4,'q',20,'g',2);
% iterations:interpolation of number of iterations
% nc:number of neighbors for the local interpolation
% lamba: smoothing parameter
% d,h,q,g:radius of the kernel function
%% Optimal grid resolution
% ns1 = createns(data(:,1:2),'NsMethod','kdtree');
% [N,D] = knnsearch(ns1,data(:,1:2),'k',2);
% ps = mean(D(:,2));   
% %m = mean(D(:,2)./2); 
m = 0.5;
%% Grid point construction
xgrid = (minx - m/2):m:maxx;
ygrid = (miny - m/2):m:maxy;
[xg,yg] = meshgrid(xgrid,ygrid);
[r,c] = size(xg);
tablehead = struct('ncols',c,'nrows',r,'xllcorner',minx - m/2,'yllcorner',miny - m/2,'cellsize',m);
xg = reshape(xg,r*c,1); yg = reshape(yg,r*c,1);
F = scatteredInterpolant(data(:,1:2),data(:,3),'natural','nearest');%calculate initial elevations of all DEM grid cells.
zz1 = F(xg,yg); 
estimate = [xg yg zz1];
%% Iterative Computation
iterations = para.iterations;
h = para.h; d = para.d; lamba = para.lamba;
q = para.q; g = para.g;
zs = triple_predictLocal(data,estimate,para);%estimate the elevations of all DEM grid cells  by using trilateral kernel function.
zs = reshape(zs,r*c,1);
estimate = [xg yg zs];
for i = 1:iterations
    disp(['iteration ', num2str(i)]);
    zs = quadruple_predictLocal(data,estimate,para);%estimate the elevations of all DEM grid cells  by using quadrilateral  kernel function.
    zs = zs';
    h = h - 0.01;
    d = d - 0.01;
    lamba = lamba + 0.01;
    q = q + 0.01;
    g = g + 0.01;
    tol = max(abs(zs - estimate(:,3)));
    estimate(:,3) = zs;
    if tol < 0.01
        break;  
    end
end
zs = reshape(zs,r,c);
zs1 = reshape(zz1,r,c);
%% Precision Validation
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
fprintf(1,' MAE%.3fm RMSE%.3fm\n',me0,rmse0);
%% Data Save
zs = flip(zs,1);
zs1 = flip(zs1,1);
filename = strcat('griddem','.txt');
saveFile(filename,tablehead,zs) %save data
