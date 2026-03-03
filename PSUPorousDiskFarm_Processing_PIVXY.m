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
data = vector2matlabPIVXY(piv_path, paths.data);
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

f = 1;
figure()
hold on
contourf(crop.X, crop.Y, crop.U(:, :, f), 100, 'linestyle', 'none')
hold off
axis equal
colorbar()
% clim([-1, 1])
% xline(60)
clear f


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB DATA TO ENSEMBLE/PHASE MEANS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
% if exist(paths.means, 'file')
%      fprintf('* Loading MEANS from File\n')
%      means = load(paths.means); 
%      means = means.output;
% else
%      means = data2meansPIVXY(wavecrop, paths.means);
% end

means = data2meansPIVXY(wavecrop, paths.means);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X = means.X;
Y = means.Y;

U = means.u;
V = means.v;
W = means.w;

uu = means.uu;
vv = means.vv;
ww = means.ww;

uv = means.uv;
uw = means.uw;
vw = means.vw;

max_wave_profile = max(rerefined_waves, [], 1);
U(Y < max_wave_profile) = nan;
V(Y < max_wave_profile) = nan;
W(Y < max_wave_profile) = nan;

uu(Y < max_wave_profile) = nan;
vv(Y < max_wave_profile) = nan;
ww(Y < max_wave_profile) = nan;

uv(Y < max_wave_profile) = nan;
uw(Y < max_wave_profile) = nan;
vw(Y < max_wave_profile) = nan;

%% Means Plots

levels = 100;
ax = figure();
t  = tiledlayout(1,3);
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

nexttile()
colormap jet
contourf(X, Y, W, levels, 'linestyle', 'none')
axis equal
xlim([-100,100])
colorbar()
title('w')

clear levels

%% Test profiles of u

figure()
plot(U(:, 200), Y(:,1))
xlim([0, 4])

%% Mean u with al waves plotted on top

figure()
hold on
contourf(X, Y, U, 100, 'linestyle', 'none')
for f = 1:length(frames.common)
    plot(X(1,:), wavecrop.waves(f, :), 'color',  'black')
end
hold off
axis equal

%% Stresses Plots

ax = figure();
t  = tiledlayout(2,3);
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

nexttile()
colormap jet
contourf(X, Y, ww, 100, 'linestyle', 'none')
axis equal
xlim([-100,100])
colorbar()
title('ww')


% Shear Stresses
nexttile()
colormap jet
contourf(X, Y, uv, 100, 'linestyle', 'none')
axis equal
xlim([-100,100])
colorbar()
title('uv')

nexttile()
colormap jet
contourf(X, Y, uw, 100, 'linestyle', 'none')
axis equal
xlim([-100,100])
colorbar()
title('uw')

nexttile()
colormap jet
contourf(X, Y, vw, 100, 'linestyle', 'none')
axis equal
xlim([-100,100])
colorbar()
title('vw')





















