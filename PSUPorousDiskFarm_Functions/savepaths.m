function output = savepaths(results_path, inpt_name)

    % Check if save folder exists, else make it
    if ~exist(results_path, 'dir')
        fprintf('<savepaths> Creating Main Save Directory\n')
        mkdir(results_path);
    end

    % Check if Data subdirectory exist, else create
    data_dir = fullfile(results_path, 'data');
    if ~exist(data_dir, 'dir')
        fprintf('<savepaths> Creating Data Directory\n')
        mkdir(data_dir);
    end

    % Check if Data subdirectory exist, else create
    means_dir = fullfile(results_path, 'means');
    if ~exist(means_dir, 'dir')
        fprintf('<savepaths> Creating Means Directory\n')
        mkdir(means_dir);
    end

     % Check if Data subdirectory exist, else create
    crop_dir = fullfile(results_path, 'crop');
    if ~exist(crop_dir, 'dir')
        fprintf('<savepaths> Creating Cropped Directory\n')
        mkdir(crop_dir);
    end


    % Check if Figure subdirectory exist, else create
    figure_dir = fullfile(results_path, 'figures');
    if ~exist(figure_dir, 'dir')
        fprintf('<savepaths> Creating Figure Directory\n')
        mkdir(figure_dir);
    end
    
    % Create file paths for mat files
    output.data   = fullfile(data_dir  , strcat(inpt_name, '_DATA.mat'));
    output.means  = fullfile(means_dir , strcat(inpt_name, '_MEANS.mat'));
    output.crop   = fullfile(crop_dir  , strcat(inpt_name, '_CROP.mat'));
    output.figure = figure_dir;

end