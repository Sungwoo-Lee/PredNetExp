function [experimentData, globalFrame] = run_trial(trial, experimentSettings, screenSettings, experimentData, globalFrame)
    %% Record the trial start time
    trialStartTime = GetSecs();

    %%
    window = screenSettings.window;
    xCenter = screenSettings.xCenter;
    yCenter = screenSettings.yCenter;
    
    %%
    useVideoForStimulus = experimentSettings.useVideoForStimulus;
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

    if useVideoForStimulus
        if runType == "circle"
            if isPredictable
                videoPath = "videoVersionStimulus/circle/predictable";
            else
                videoPath = "videoVersionStimulus/circle/unpredictable";
            end
        elseif runType ==  "garbor"
            if isPredictable
                videoPath = "videoVersionStimulus/garbor/predictable";
            else
                videoPath = "videoVersionStimulus/garbor/unpredictable";
            end
        elseif runType ==  "movie"
            if isPredictable
                videoPath = "videoVersionStimulus/movie/predictable";
            else
                videoPath = "videoVersionStimulus/movie/unpredictable";
            end
        end

        trialVideoFolder = dir(fullfile(videoPath, sprintf('trial_%d', trial)));
        trialFileName = sprintf('trial_%d.mp4', trial);
        trialVideoFilePath = fullfile(trialVideoFolder(1).folder,trialFileName);
        [movie, duration, fps, width, height] = Screen('OpenMovie', window, trialVideoFilePath);
        trialSettings.movieFiles = trialVideoFilePath;

    else
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
    end

    %% Record the stimulus start time
    stimulusStartTime = GetSecs;
    
    if useVideoForStimulus
        % Start the video playback
        Screen('PlayMovie', movie, 1); % 1 means play, 0 would pause
        vbl = Screen('Flip', window); % Initial flip to sync timing

        while true  % Stops if a key is pressed
            % Check for 'q' key press to quit the experiment
            [keyIsDown, ~, keyCode] = KbCheck(-1);
            if keyIsDown && keyCode(KbName('q'))
                sca;  % Close the screen
                return;  % Exit the function
            end
            
            tex = Screen('GetMovieImage', window, movie);
            % Exit loop if end of movie is reached (tex == -1)
            if tex <= 0
                break;
            end

            % Draw the texture to the screen
            Screen('DrawTexture', window, tex, []);
            % Draw Fixation cross
            Screen('DrawLines', window, allCoords, lineWidthPix, [1 1 1], [xCenter yCenter]);

            % vbl = Screen('Flip', window, vbl + (1/fps - 0.5 * Screen('GetFlipInterval', win)));
            vbl = Screen('Flip', window);

            % Release the texture to free memory
            Screen('Close', tex);
        end

        % Stop playback and close the video
        Screen('PlayMovie', movie, 0); % Stop the movie
        Screen('CloseMovie', movie); % Close the movie file
    else
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
    
    if ~useVideoForStimulus
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
end