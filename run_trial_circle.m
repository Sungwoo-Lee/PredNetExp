function trialSettings = run_trial_circle(trialSettings, experimentSettings, screenSettings, frame)

    %%
    window = screenSettings.window;
    xCenter = screenSettings.xCenter;
    yCenter = screenSettings.yCenter;
    aspectRatio = screenSettings.aspectRatio;
    screenXpixels = screenSettings.screenXpixels;
    screenYpixels = screenSettings.screenYpixels;

    %%
    numFrames = experimentSettings.numFrames;
    totalStimulusNumber = experimentSettings.totalStimulusNumber;
    framesPerCondition = experimentSettings.framesPerCondition;
    numConditions = experimentSettings.numConditions;

    %%
    radius = experimentSettings.circle.radius;
    circleRadius = experimentSettings.circle.circleRadius;
    circleColor = experimentSettings.circle.circleColor;
    
    angles = experimentSettings.circle.angles;
    
    %%
    if frame == 0
        isPredictable = trialSettings.isPredictable;
        
        conditionInterval = fix(totalStimulusNumber / numConditions);
        listOfConditions = 1:conditionInterval:totalStimulusNumber;

        if ~isPredictable
            randomizedIndices = randperm(length(listOfConditions));
            listOfConditions = listOfConditions(randomizedIndices);
        end

        listOfConditionsPerFrame = repelem(listOfConditions, framesPerCondition);
    
        if size(listOfConditionsPerFrame,2) < numFrames
            error('SizeError:ConditionListPerFrame', 'The listOfConditions X framesPerCondition is less than total number of frames');
        end
        
        trialSettings.listOfConditionsPerFrame = listOfConditionsPerFrame;

    else
        listOfConditionsPerFrame = trialSettings.listOfConditionsPerFrame;

        currentAngle = angles(listOfConditionsPerFrame(frame));
        
        xPos = xCenter + radius * screenXpixels * cos(currentAngle) / aspectRatio;
        yPos = yCenter + radius * screenYpixels * sin(currentAngle);

        % Draw the circle at the calculated position
        Screen('FillOval', window, circleColor, ...
            [xPos - circleRadius, yPos - circleRadius, xPos + circleRadius, yPos + circleRadius]);
    end

end