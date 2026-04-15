function output = cropinstantensous2DPIVXY(data, out_path)

    % Load data
    D = data.D;
    u = data.U;
    v = data.V;
    X = data.X;
    Y = data.Y;

    %%% From first round of measurements
    % % Trim up areas
    % top_crop = 49;
    % bottom_crop = -75;
    % outer_left_crop = -117;
    % outer_right_crop = 114;
    % inner_left_crop = -71.5;
    % inner_right_crop = -49;

    %%% From second round of measurements
    % Trim up areas
    top_crop = 30;
    bottom_crop = -30;
    outer_left_crop = -10;
    outer_right_crop = 148;
    inner_left_crop = 24;
    inner_right_crop = 33;

    % Create matfile
    output = matfile(out_path, 'Writable', true);

    % Correct orientation
    for frame = 1:D

        % Print Progress.
        progressbarText(frame/D);
       
        % Get instantaneous components
        UF = u(:,:,frame);
        VF = v(:,:,frame);

        % Orient correctly
        UF = fliplr(-UF.');
        VF = fliplr(-VF.');
        
        % Remove non-processed areas
        UF(UF == 0) = nan;
        VF(VF == 0) = nan;
        
        % Fill holes
        UF = inpaint_nans(double(UF));
        VF = inpaint_nans(double(VF));

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

        % Save
        tmp_inst_u(:,:,frame) = UF;
        tmp_inst_v(:,:,frame) = VF;
    end

    % Save
    output.U = tmp_inst_u;
    output.V = tmp_inst_v;
    output.X = X;
    output.Y = Y;
    output.D = D;

    % Save Matlab File.
    fprintf('\n<cropinstantensousPIVXY> Saving Data to File... \n');
    clc; fprintf('<cropinstantensousPIVXY> Data Save Complete \n')

end

