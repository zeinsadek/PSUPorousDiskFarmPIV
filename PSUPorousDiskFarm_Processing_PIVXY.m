%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PATHS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;
addpath('C:\Users\sadek\Desktop\readimx-v2.1.9-win64');
addpath('C:\Users\sadek\Desktop\ZeinPIVCodes_Github\PSUPorousDiskFarmPIV\PSUPorousDiskFarm_Functions');
addpath('C:\Users\sadek\Desktop\ZeinPIVCodes_Github\PSUPorousDiskFarmPIV\PSUPorousDiskFarm_Functions\Inpaint_nans\Inpaint_nans');
addpath('C:\Program Files\MATLAB\slanCM')
fprintf('All Paths Imported...\n\n')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT PARAMETERS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Data paths
clc;
project_path   = 'E:\LeoSingleTurbine_Full';
recording_name = 'SingleTurbine_WT3';

% Image paths
piv_path = fullfile(project_path, recording_name, 'PIV_MPd(1x32x32_50%ov_ImgCorr)_GPU');

% Save paths
save_path = 'E:\LeoSingleTurbineResults';
paths     = savepaths(save_path, recording_name);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DAVIS TO MATLAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clc;
% if exist(paths.data, 'file')
%     fprintf('* Loading DATA from File\n')
%     data = matfile(paths.data);
% else
%     tic
%     data = vector2matlabPIVXY(piv_path, paths.data);
%     toc
% end

clc;
tic
data = vector2matlab2DPIVXY(piv_path, paths.data);
toc

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORIENT AND CROP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clc;
% if exist(paths.crop, 'file')
%     fprintf('* Loading CROP from File\n')
%     crop = matfile(paths.crop);
% else
    % tic
    % crop = cropinstantensousPIVXY(data, paths.crop);
    % toc
% end

clc;
tic
crop = cropinstantensousPIVXY(data, paths.crop);
toc

%% check

f = 100;
figure()
hold on
contourf(crop.X, crop.Y, crop.U(:, :, f), 100, 'linestyle', 'none')
hold off
axis equal
colorbar()
clim([0, inf])
% xline(60)
clear f


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB DATA TO ENSEMBLE/PHASE MEANS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
if exist(paths.means, 'file')
     fprintf('* Loading MEANS from File\n')
     means = load(paths.means); 
     means = means.output;
else
     means = data2means2DPIVXY(crop, paths.means);
end

% means = data2meansPIVXY(crop, paths.means);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X = means.X;
Y = means.Y;

U = means.u;
V = means.v;

uu = means.uu;
vv = means.vv;
uv = means.uv;

%% Means Plots

levels = 100;
ax = figure();
t  = tiledlayout(2,1);
sgtitle(recording_name, 'interpreter', 'none')

nexttile()
colormap jet
contourf(X, Y, U, levels, 'linestyle', 'none')
axis equal
xlim([-100,100])
colorbar()
title('u')

nexttile()
colormap jet
contourf(X, Y, V, levels, 'linestyle', 'none')
axis equal
xlim([-100,100])
colorbar()
title('v')


clear levels

%% Test profiles of u

figure()
plot(U(:, 200), Y(:,1))
xlim([0, 4])

%% Stresses Plots

ax = figure();
t  = tiledlayout(1,3);
sgtitle(recording_name, 'interpreter', 'none')

% Normal Stresses
nexttile()
colormap jet
contourf(X, Y, uu, 100, 'linestyle', 'none')
axis equal
xlim([-100,100])
colorbar()
title('uu')

nexttile()
colormap jet
contourf(X, Y, vv, 100, 'linestyle', 'none')
axis equal
xlim([-100,100])
colorbar()
title('vv')


% Shear Stresses
nexttile()
colormap jet
contourf(X, Y, uv, 100, 'linestyle', 'none')
axis equal
xlim([-100,100])
colorbar()
title('uv')





















