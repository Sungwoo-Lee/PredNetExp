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

    %%
    radius = experimentSettings.circle.radius;
    circleRadius = experimentSettings.circle.circleRadius;
    circleColor = experimentSettings.circle.circleColor;
    numPositions = experimentSettings.circle.numPositions;
    angles = experimentSettings.circle.angles;
    framesPerPosition = experimentSettings.circle.framesPerPosition;

    %%
    if frame == 0
        isPredictable = trialSettings.isPredictable;

        listOfConditions = linspace(1, numPositions, numPositions);
        
        if isPredictable
            randomStartIdex = randi(length(listOfConditions));
            listOfConditions = [listOfConditions(randomStartIdex:end), listOfConditions(1:randomStartIdex)];
           
        else
            randomizedIndices = randperm(numPositions);
            listOfConditions = listOfConditions(randomizedIndices);
        end
        
        listOfConditionsPerFrame = repelem(listOfConditions, framesPerPosition);
    
        if size(listOfConditionsPerFrame,2) < numFrames
            error('SizeError:ConditionListPerFrame', 'The listOfConditions X framesPerPosition is less than total number of frames');
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