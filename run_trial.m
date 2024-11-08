function [experimentData, globalFrame] = run_trial(trial, experimentSettings, screenSettings, experimentData, globalFrame)
    %% Record the trial start time
    trialStartTime = GetSecs();

    %%
    window = screenSettings.window;
    xCenter = screenSettings.xCenter;
    yCenter = screenSettings.yCenter;
    
    %%
    runType = experimentSettings.runType;
    numFrames = experimentSettings.numFrames;
    lineWidthPix = experimentSettings.lineWidthPix;
    allCoords = experimentSettings.allCoords;
    predictableTrials = experimentSettings.predictableTrials;
    
    stimulusDuration = experimentSettings.stimulusDuration;
     

    %%
    if ismember(trial, predictableTrials)
        isPredictable = true;
    else
        isPredictable = false;
    end

    frame = 0;
    trialSettings.isPredictable = isPredictable;
    reactionTrials = experimentSettings.reactionTrials;
    if runType == "circle"
        trialSettings = run_trial_circle(trialSettings, experimentSettings, screenSettings, frame);
        USE_FIXATION_TASK = experimentSettings.circle.USE_FIXATION_TASK;
    elseif runType ==  "garbor"
        trialSettings = run_trial_garbor(trialSettings, experimentSettings, screenSettings, frame);
        USE_FIXATION_TASK = experimentSettings.garbor.USE_FIXATION_TASK;
    elseif runType ==  "movie"
%         trialmovie = experimentSettings.movie.movieFolders(trial);
        if experimentSettings.predictableSubsetRatio == 1
            trialmovie = fullfile(experimentSettings.movie.movieFolders(1).folder,'prediction',sprintf('trial_%d',trial));
        else
            trialmovie = fullfile(experimentSettings.movie.movieFolders(1).folder,'prediction_error',sprintf('trial_%d',trial));
        end

        movieFiles = dir(fullfile(trialmovie, '*png'));
        
        for i = 1:size(movieFiles,1)
            img = imread(fullfile(movieFiles(i).folder,movieFiles(i).name));
            img = imresize(img, [experimentSettings.movie.imageHeight, experimentSettings.movie.imageWidth]);
            images{i}  = img;
        end

        trialSettings.trialmovie = trialmovie;
        trialSettings.movieFiles = movieFiles;
        trialSettings.images = images;
        trialSettings = run_trial_movie(trialSettings, experimentSettings, screenSettings, frame);
        USE_FIXATION_TASK = experimentSettings.movie.USE_FIXATION_TASK;
    end
    
    %%
    if USE_FIXATION_TASK
        % Randomly select color change time for reaction trials
        if ismember(trial, reactionTrials)
            colorChangeTime = rand * (stimulusDuration - 1.5); % Random time within the trial (leaving 1.5 sec for response)
        end

        colorChanged = false; % Flag to check if the color has changed
        responseLogged = false; % Flag to check if the response has been logged
        colorChangeRecordTime = NaN;
        responseTime = NaN;
    end

    %% Record the stimulus start time
    stimulusStartTime = GetSecs;
    
    for frame = 1:numFrames
        % Check for 'q' key press to quit the experiment
        [keyIsDown, ~, keyCode] = KbCheck(-1);
        if keyIsDown && keyCode(KbName('q'))
            sca;  % Close the screen
            return;  % Exit the function
        end
        
        %%
        if runType == "circle"
            trialSettings = run_trial_circle(trialSettings, experimentSettings, screenSettings, frame);
        elseif runType ==  "garbor"
            trialSettings = run_trial_garbor(trialSettings, experimentSettings, screenSettings, frame);
        elseif runType ==  "movie"
            trialSettings = run_trial_movie(trialSettings, experimentSettings, screenSettings, frame);
        end

        %%
        % Change fixation cross color at the designated time
        if USE_FIXATION_TASK
            if ismember(trial, reactionTrials) && ~responseLogged && (GetSecs - trialStartTime) >= colorChangeTime
                % Change fixation cross to red
                Screen('DrawLines', window, allCoords, lineWidthPix, [1 0 0], [xCenter yCenter]); % Change to red
                colorChanged = true; % Update flag
                colorChangeRecordTime = GetSecs;
            else
                % Draw the fixation cross at the center
                Screen('DrawLines', window, allCoords, lineWidthPix, [1 1 1], [xCenter yCenter]);
            end

            if ismember(trial, reactionTrials) && ~ responseLogged
                % Check for 'a' key press to react
                [keyIsDown, ~, keyCode] = KbCheck(-1);
                if keyIsDown && keyCode(KbName('a'))
                    Screen('DrawLines', window, allCoords, lineWidthPix, [1 1 1], [xCenter yCenter]);
                    responseLogged = true;
                    responseTime = GetSecs;
                end
            end
        end
    
        % Flip to the screen
        Screen('Flip', window);

        % Define the rectangle for capturing (entire screen)
        rect = [];  % Empty rectangle captures the entire screen
        
        if experimentSettings.recording
            % Capture the frame from the screen
            imageArray = Screen('GetImage', window, rect);
            fileName = fullfile('recordings', sprintf('globalFrame%04d_trial%03d_STIMULUS_frame_%04d.png', globalFrame, trial, frame));
            % Save the image as a file
            imwrite(imageArray, fileName);

            globalFrame = globalFrame + 1;
        end

    end
    
    %% Record the stimulus end time
    stimulusEndTime = GetSecs();
    
    %% Record the ITI start time
    ITIStartTime = GetSecs();

    %% Store timestamps and trial information for the current trial
    experimentData.trials(trial).trialStart = trialStartTime;
    experimentData.trials(trial).stimulusStartTime = stimulusStartTime;
    experimentData.trials(trial).stimulusEnd = stimulusEndTime;
    experimentData.trials(trial).ITIStart = ITIStartTime;
    experimentData.trials(trial).isPredictable = isPredictable;  % Store whether the trial was predictable
    
    if runType ==  "movie"
        trialSettings = rmfield(trialSettings, 'images');
    end
    experimentData.trials(trial).trialSettings = trialSettings;
    
    if USE_FIXATION_TASK
        experimentData.trials(trial).colorChangeTime = colorChangeRecordTime;
        experimentData.trials(trial).responseTime = responseTime;
        experimentData.trials(trial).colorChanged = colorChanged;
    end
end