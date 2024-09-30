function experimentData = run_trial(trial, experimentSettings, screenSettings, experimentData)
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
    reactionTrials = experimentSettings.reactionTrials;
    stimulusDuration = experimentSettings.stimulusDuration;
     

    %%
    if ismember(trial, predictableTrials)
        isPredictable = true;
    else
        isPredictable = false;
    end

    frame = 0;
    trialSettings.isPredictable = isPredictable;
%     trialSettings = run_trial_circle(trialSettings, experimentSettings, screenSettings, frame);
    if runType == "circle"
        trialSettings = run_trial_circle(trialSettings, experimentSettings, screenSettings, frame);
        USE_FIXATION_TASK = experimentSettings.circle.USE_FIXATION_TASK;
    
    elseif runType ==  "garbor"
        trialSettings = run_trial_garbor(trialSettings, experimentSettings, screenSettings, frame);
        USE_FIXATION_TASK = experimentSettings.garbor.USE_FIXATION_TASK;
    end

%     listOfConditionsPerFrame = trialSettings.listOfConditionsPerFrame;
    
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
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown && keyCode(KbName('q'))
            sca;  % Close the screen
            return;  % Exit the function
        end
        
        %%
        if runType == "circle"
            trialSettings = run_trial_circle(trialSettings, experimentSettings, screenSettings, frame);
        elseif runType ==  "garbor"
            trialSettings = run_trial_garbor(trialSettings, experimentSettings, screenSettings, frame);
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
                [keyIsDown, ~, keyCode] = KbCheck;
                if keyIsDown && keyCode(KbName('a'))
                    Screen('DrawLines', window, allCoords, lineWidthPix, [1 1 1], [xCenter yCenter]);
                    responseLogged = true;
                    responseTime = GetSecs;
                end
            end
        end
    
        % Flip to the screen
        Screen('Flip', window);
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
%     experimentData.trials(trial).listOfConditionsPerFrame = listOfConditionsPerFrame; 
    
    if USE_FIXATION_TASK
        experimentData.trials(trial).colorChangeTime = colorChangeRecordTime;
        experimentData.trials(trial).responseTime = responseTime;
        experimentData.trials(trial).colorChanged = colorChanged;
    end
end