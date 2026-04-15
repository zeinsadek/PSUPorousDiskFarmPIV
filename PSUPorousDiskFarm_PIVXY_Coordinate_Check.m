%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PATHS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;
addpath('C:\Users\sadek\Desktop\readimx-v2.1.9-win64');
addpath('C:\Users\sadek\Desktop\ZeinPIVCodes_Github\PSUPorousDiskFarmPIV\PSUPorousDiskFarm_Functions');
addpath('C:\Users\sadek\Desktop\ZeinPIVCodes_Github\PSUPorousDiskFarmPIV\PSUPorousDiskFarm_Functions\Inpaint_nans\Inpaint_nans');
addpath('C:\Program Files\MATLAB\slanCM')
fprintf('All Paths Imported...\n\n')


%% Paths

data = readimx('F:\Leo_Prototype_1\Leo_Black_10p_WT6\PIV_MPd(1x24x24_0%ov_ImgCorr)\B00001.vc7');


%% Load Single Image

names       = data.Frames{1,1}.ComponentNames;        
U0_index    = find(strcmp(names, 'U0'));
V0_index    = find(strcmp(names, 'V0'));

UF = data.Frames{1,1}.Components{U0_index,1}.Scale.Slope.*data.Frames{1,1}.Components{U0_index,1}.Planes{1,1} + data.Frames{1,1}.Components{U0_index,1}.Scale.Offset;
VF = data.Frames{1,1}.Components{V0_index,1}.Scale.Slope.*data.Frames{1,1}.Components{V0_index,1}.Planes{1,1} + data.Frames{1,1}.Components{V0_index,1}.Scale.Offset;

% Add Image/Data Parameters to struct file.
nf = size(UF);
x = data.Frames{1,1}.Scales.X.Slope.*linspace(1, nf(1), nf(1)).*data.Frames{1,1}.Grids.X + data.Frames{1,1}.Scales.X.Offset;
y = data.Frames{1,1}.Scales.Y.Slope.*linspace(1, nf(2), nf(2)).*data.Frames{1,1}.Grids.Y + data.Frames{1,1}.Scales.Y.Offset;
[X, Y] = meshgrid(x, y);

% Orient correctly
UF = fliplr(-UF.');
VF = fliplr(-VF.');

% Remove non-processed areas
UF(UF == 0) = nan;
VF(VF == 0) = nan;


% Fill holes
% UF = inpaint_nans(double(UF));
% VF = inpaint_nans(double(VF));


% % Trim up areas
% top_crop = 49;
% bottom_crop = -75;
% outer_left_crop = -117;
% outer_right_crop = 114;
% inner_left_crop = -71.5;
% inner_right_crop = -49;

top_crop = 30;
bottom_crop = -30;
outer_left_crop = -10;
outer_right_crop = 148;
inner_left_crop = 24;
inner_right_crop = 33;

% Trim top/bottom
UF(Y > top_crop) = nan;
UF(Y < bottom_crop) = nan;
VF(Y > top_crop) = nan;
VF(Y < bottom_crop) = nan;

% Trim outer left/right
UF(X < outer_left_crop) = nan;
UF(X > outer_right_crop) = nan;
VF(X < outer_left_crop) = nan;
VF(X > outer_right_crop) = nan;

% Trim where turbine was deleted
UF(X > inner_left_crop & X < inner_right_crop) = nan;
VF(X > inner_left_crop & X < inner_right_crop) = nan;

% % Test setting turbine as origin
x_offset = -28;
y_offset = 2;
D = 30;

X = (X + x_offset) / D;
Y = (Y - y_offset) / D;

% Plot
clc; close all
figure('color', 'white')
% t = tiledlayout(2,1);
% 
% ax1 = nexttile();
contourf(X, Y, UF, 100, 'linestyle', 'none')
axis equal
colorbar
% colormap(ax1, "jet")
xline(0)
yline(0)

% clim([0, 4.5])
% xlim([-100, 100])
% ylim([-120, 100])

% ax2 = nexttile();
% contourf(X, Y, VF, 100, 'linestyle', 'none')
% axis equal
% colorbar
% colormap(ax2, slanCM("bwr"))
% % clim([-1,1])
% % xlim([-100, 100])
% % ylim([-120, 100])
% 
% linkaxes([ax2, ax2], 'xy')

%% Loop over a couple images to see rough means


inst = vector2matlab2DPIVXY('F:\Leo_Prototype_1\Leo_Black_10p_WT6\PIV_MPd(1x24x24_0%ov_ImgCorr)', 'F:\test.mat');

%%

u_mean = mean(inst.U, 3, 'omitnan');
v_mean = mean(inst.V, 3, 'omitnan');
% w_mean = mean(inst.W, 3, 'omitnan');


v_mean(u_mean == 0) = nan;
w_mean(u_mean == 0) = nan;
% u_mean(u_mean == 0) = nan;


figure()
t = tiledlayout(1,3);

nexttile()
contourf(-X, Y, u_mean.', 100, 'linestyle', 'none')
axis equal
colorbar
colormap coolwarm
clim([-0.5,0.5])
% xlim([-100, 100])
% ylim([-120, 100])

nexttile()
contourf(-X, Y, v_mean.', 100, 'linestyle', 'none')
axis equal
colorbar
colormap coolwarm
clim([-0.5,0.5])
% % xlim([-100, 100])
% % ylim([-120, 100])
% 
% nexttile()
% contourf(-X, Y, w_mean.', 100, 'linestyle', 'none')
% axis equal
% colorbar
% colormap coolwarm
% clim([-1.5,4.5])
% xline(0)
% % xlim([-100, 100])
% ylim([-120, 100])

%% Reassign to tunnel coordinates

X = -X;
Y = Y;

U = w_mean.';     
V = v_mean.';
W = u_mean.'; 

%%

figure()
t = tiledlayout(1,3);

nexttile()
contourf(X, Y, U, 100, 'linestyle', 'none')
axis equal
colorbar
colormap coolwarm
clim([-1.5,4.5])
xlim([-100, 100])
ylim([-120, 100])

nexttile()
contourf(X, Y, V, 100, 'linestyle', 'none')
axis equal
colorbar
colormap coolwarm
clim([-0.5,0.5])
xlim([-100, 100])
ylim([-120, 100])
 
nexttile()
contourf(X, Y, W, 100, 'linestyle', 'none')
axis equal
colorbar
colormap coolwarm
clim([-0.5,0.5])
xlim([-100, 100])
ylim([-120, 100])








