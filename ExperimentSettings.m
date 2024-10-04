function experimentSettings = ExperimentSettings(experimentSettings, screenSettings)
    numTrials = experimentSettings.numTrials;
    screenXpixels = screenSettings.screenXpixels;
    screenYpixels = screenSettings.screenYpixels;
%     fps = screenSettings.fps;

    % Define variables for the reaction task
    reactionSubsetRatio = 0.7; % Ratio of trials with a reaction task
    reactionTrials = sort(randperm(numTrials, round(numTrials * reactionSubsetRatio))); % Randomly select trials for reaction task
    
    % STIMULUS PARAMETERS
    % Define variables for the predictable trials
    predictableSubsetRatio = 0.0; % Ratio of trials with a predictable task
    predictableTrials = sort(randperm(numTrials, round(numTrials * predictableSubsetRatio))); % Randomly select trials for predictable task

    % Parameters for the fixation cross, which remains on the screen to help the
    % participant maintain their gaze at the center.
    fixCrossDimPix = 0.015 * min(screenXpixels, screenYpixels);
    lineWidthPix = 4;  % Thickness of the fixation cross

    % Coordinates for the lines that make up the fixation cross.
    xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
    yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
    allCoords = [xCoords; yCoords];

    totalStimulusNumber = 1000;

    experimentSettings.reactionSubsetRatio = reactionSubsetRatio;
    experimentSettings.reactionTrials = reactionTrials;
    experimentSettings.predictableSubsetRatio = predictableSubsetRatio;
    experimentSettings.predictableTrials = predictableTrials;
    experimentSettings.fixCrossDimPix = fixCrossDimPix;
    experimentSettings.lineWidthPix = lineWidthPix;
    experimentSettings.allCoords = allCoords;
    experimentSettings.totalStimulusNumber = totalStimulusNumber;

    if experimentSettings.runType == "circle"
        USE_FIXATION_TASK = true;
        % Determine whether the predictable stimulus moves clockwise or anti-clockwise.
        % 1 for clockwise, -1 for anti-clockwise.
        movementDirection = -1;

        % Radius of the circular path (as a proportion of screen size) along which
        % the stimulus will move.
        radius = 0.3;

        % Adjust the size of the circle based on the radius.
        circleRadius = 0.05 * radius * min(screenXpixels, screenYpixels);  % Circle size
        circleColor = [1 1 1];  % White color for the circle

        % Define the number of positions around the circle where the stimulus can appear.
        % These positions are evenly spaced along the circumference.
        numPositions = 100;
        angles = linspace(0, 2 * pi, numPositions + 1);
        angles(end) = [];  % Remove the last point to avoid duplication

        if movementDirection == -1
            angles = angles(end:-1:1);
        end
        
        framesPerPosition = experimentSettings.numFrames/numPositions;

        experimentSettings.circle.USE_FIXATION_TASK = USE_FIXATION_TASK;
        experimentSettings.circle.movementDirection = movementDirection;
        experimentSettings.circle.radius = radius;
        experimentSettings.circle.circleRadius = circleRadius;
        experimentSettings.circle.circleColor = circleColor;
        experimentSettings.circle.numPositions = numPositions;
        experimentSettings.circle.angles = angles;
        experimentSettings.circle.framesPerPosition = framesPerPosition;

    elseif experimentSettings.runType == "garbor"
        % Define Gabor patch parameters
        USE_FIXATION_TASK = false;
        gaborSize = 600;  % Size of the Gabor patch in pixels
        spatialFrequency = 0.03;  % % Frequency of sine grating
        sc = 100;  % Spatial constant of the exponential "hull" (https://github.com/Psychtoolbox-3/Psychtoolbox-3/blob/master/Psychtoolbox/PsychDemos/ProceduralGarboriumDemo.m)
        contrast = 300.0; % Contrast of grating

        frequencyChangeRate = 0.9;
        contrastChangeRate = 0.7;
        scChangeRate = 0.9;

        % Determine whether the predictable stimulus moves clockwise or anti-clockwise.
        % 1 for clockwise, -1 for anti-clockwise.
        movementDirection = -1;

        numConditions = 50;

        angles = linspace(0, 360, totalStimulusNumber);
        phaseList = linspace(0, 360, totalStimulusNumber);
    
        spatialFrequencies = linspace(spatialFrequency-(spatialFrequency*frequencyChangeRate), spatialFrequency+(spatialFrequency*frequencyChangeRate), totalStimulusNumber);
        scList = linspace(sc-(sc*scChangeRate), sc+(sc*scChangeRate), totalStimulusNumber);
        contrastList = linspace(contrast-(contrast*contrastChangeRate), contrast+(contrast*contrastChangeRate), totalStimulusNumber);
        
        if movementDirection == -1
            angles = angles(end:-1:1);
            phaseList = phaseList(end:-1:1);
            spatialFrequencies = spatialFrequencies(end:-1:1);
            scList = scList(end:-1:1);
            contrastList = contrastList(end:-1:1);
        end

        changeOrientation = false;
        changeSpatialFrequency = false;
        changeContrast = false;
        changeSC = false;
        changePhase = true;

        framesPerCondition = experimentSettings.numFrames/numConditions;

        experimentSettings.garbor.USE_FIXATION_TASK = USE_FIXATION_TASK;
        experimentSettings.garbor.gaborSize = gaborSize;
        experimentSettings.garbor.spatialFrequency = spatialFrequency;
        experimentSettings.garbor.sc = sc;
        experimentSettings.garbor.contrast = contrast;
        experimentSettings.garbor.frequencyChangeRate = frequencyChangeRate;
        experimentSettings.garbor.scChangeRate = scChangeRate;
        experimentSettings.garbor.contrastChangeRate = contrastChangeRate;
        experimentSettings.garbor.numConditions = numConditions;
        experimentSettings.garbor.spatialFrequencies = spatialFrequencies;
        experimentSettings.garbor.contrastList = contrastList;
        experimentSettings.garbor.scList = scList;
        experimentSettings.garbor.phaseList = phaseList;
        experimentSettings.garbor.angles = angles;
        experimentSettings.garbor.changeOrientation = changeOrientation;
        experimentSettings.garbor.changeSpatialFrequency = changeSpatialFrequency;
        experimentSettings.garbor.changeContrast = changeContrast;
        experimentSettings.garbor.changeSC = changeSC;
        experimentSettings.garbor.changePhase = changePhase;
        experimentSettings.garbor.framesPerCondition = framesPerCondition;
    end

end
