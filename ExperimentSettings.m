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
    predictableSubsetRatio = 0.5; % Ratio of trials with a predictable task
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
        numPositions = 50;
        angles = linspace(0, 2 * pi, numPositions + 1);
        angles(end) = [];  % Remove the last point to avoid duplication

        if movementDirection == -1
            angles = angles(end:-1:1);
        end

        framesPerPositionPredictable = 14;
        framesPerPositionUnpredictable = 14;

        experimentSettings.circle.USE_FIXATION_TASK = USE_FIXATION_TASK;
        experimentSettings.circle.movementDirection = movementDirection;
        experimentSettings.circle.radius = radius;
        experimentSettings.circle.circleRadius = circleRadius;
        experimentSettings.circle.circleColor = circleColor;
        experimentSettings.circle.numPositions = numPositions;
        experimentSettings.circle.angles = angles;
        experimentSettings.circle.framesPerPositionPredictable = framesPerPositionPredictable;
        experimentSettings.circle.framesPerPositionUnpredictable = framesPerPositionUnpredictable;

    elseif experimentSettings.runType == "garbor"
        % Define Gabor patch parameters
        USE_FIXATION_TASK = false;
        gaborSize = 600;  % Size of the Gabor patch in pixels
        spatialFrequency = 0.03;  % Spatial frequency in cycles per pixel
        sigma = 100;  % Standard deviation of the Gaussian envelope
        contrast = 300.0;
        phase = 90;  % Initial phase (0 to 180)
%         orientation = 0;  % Orientation angle in degrees

        frequencyChangeRate = 0.9;
        contrastChangeRate = 0.7;
        sigmaChangeRate = 0.9;
        changePhaseRate = 0.5;

        % Determine whether the predictable stimulus moves clockwise or anti-clockwise.
        % 1 for clockwise, -1 for anti-clockwise.
        movementDirection = -1;

        numConditions = 100;
        angles = linspace(0, 360, totalStimulusNumber);
        angles(end) = [];  % Remove the last point to avoid duplication

        if movementDirection == -1
            angles = angles(end:-1:1);
        end

        spatialFrequencies = linspace(spatialFrequency-(spatialFrequency*frequencyChangeRate), spatialFrequency+(spatialFrequency*frequencyChangeRate), totalStimulusNumber);
        sigmaList = linspace(sigma-(sigma*sigmaChangeRate), sigma+(sigma*sigmaChangeRate), totalStimulusNumber);
        contrastList = linspace(contrast-(contrast*contrastChangeRate), contrast+(contrast*contrastChangeRate), totalStimulusNumber);
        phaseList = linspace(0, 360, totalStimulusNumber);

        changeOrientation = false;
        changeSpatialFrequency = false;
        changeContrast = false;
        changeSigma = false;
        changePhase = true;

%         framesPerPositionPredictable = 14;
%         framesPerPositionUnpredictable = 14;
        framesPerCondition = experimentSettings.numFrames/numConditions;

        experimentSettings.garbor.USE_FIXATION_TASK = USE_FIXATION_TASK;
        experimentSettings.garbor.gaborSize = gaborSize;
        experimentSettings.garbor.spatialFrequency = spatialFrequency;
        experimentSettings.garbor.sigma = sigma;
        experimentSettings.garbor.contrast = contrast;
        experimentSettings.garbor.phase = phase;
        experimentSettings.garbor.frequencyChangeRate = frequencyChangeRate;
        experimentSettings.garbor.sigmaChangeRate = sigmaChangeRate;
        experimentSettings.garbor.contrastChangeRate = contrastChangeRate;
%         experimentSettings.garbor.orientation = orientation;
        experimentSettings.garbor.numConditions = numConditions;
        experimentSettings.garbor.spatialFrequencies = spatialFrequencies;
        experimentSettings.garbor.contrastList = contrastList;
        experimentSettings.garbor.sigmaList = sigmaList;
        experimentSettings.garbor.phaseList = phaseList;
        experimentSettings.garbor.angles = angles;
        experimentSettings.garbor.changeOrientation = changeOrientation;
        experimentSettings.garbor.changeSpatialFrequency = changeSpatialFrequency;
        experimentSettings.garbor.changeContrast = changeContrast;
        experimentSettings.garbor.changeSigma = changeSigma;
        experimentSettings.garbor.changePhase = changePhase;
        experimentSettings.garbor.framesPerCondition = framesPerCondition;
%         experimentSettings.garbor.framesPerPositionPredictable = framesPerPositionPredictable;
%         experimentSettings.garbor.framesPerPositionUnpredictable = framesPerPositionUnpredictable;
    end

end
