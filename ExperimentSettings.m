function experimentSettings = ExperimentSettings(experimentSettings, screenSettings)
    % Number of trials to be conducted in the experiment.
    numTrials = 14;
    
    % Duration of each stimulus presentation in seconds.
    stimulusDuration = 10;
    
    % Duration of the inter-trial interval (ITI) in seconds.
    ITI = 3;
    itiFrames = ITI * screenSettings.fps;

    numFrames = round(stimulusDuration * screenSettings.fps);
    
    predictableSubsetRatio = experimentSettings.predictableSubsetRatio;
    screenXpixels = screenSettings.screenXpixels;
    screenYpixels = screenSettings.screenYpixels;
    
    % STIMULUS PARAMETERS
    % Define variables for the predictable trials
    predictableTrials = sort(randperm(numTrials, round(numTrials * predictableSubsetRatio))); % Randomly select trials for predictable task

    % Parameters for the fixation cross, which remains on the screen to help the
    % participant maintain their gaze at the center.
    fixCrossDimPix = 0.015 * min(screenXpixels, screenYpixels);
    lineWidthPix = 4;  % Thickness of the fixation cross

    % Coordinates for the lines that make up the fixation cross.
    xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
    yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
    allCoords = [xCoords; yCoords];

    totalStimulusNumber = 1200;
    numConditions = 120;

    framesPerCondition = numFrames/numConditions;
    
    experimentSettings.numFrames = numFrames;
    experimentSettings.numTrials = numTrials;
    experimentSettings.stimulusDuration = stimulusDuration;
    experimentSettings.ITI = ITI;
    experimentSettings.itiFrames = itiFrames;
    experimentSettings.predictableSubsetRatio = predictableSubsetRatio;
    experimentSettings.predictableTrials = predictableTrials;
    experimentSettings.fixCrossDimPix = fixCrossDimPix;
    experimentSettings.lineWidthPix = lineWidthPix;
    experimentSettings.allCoords = allCoords;
    experimentSettings.numConditions = numConditions;
    experimentSettings.framesPerCondition = framesPerCondition;
    experimentSettings.totalStimulusNumber = totalStimulusNumber;
   
    reactionSubsetRatio = experimentSettings.reactionSubsetRatio;
    reactionTrials = sort(randperm(numTrials, round(numTrials * reactionSubsetRatio))); % Randomly select trials for reaction task
    experimentSettings.reactionTrials = reactionTrials;

    if experimentSettings.runType == "circle"
        USE_FIXATION_TASK = true;
        % Determine whether the predictable stimulus moves clockwise or anti-clockwise.
        % 1 for clockwise, -1 for anti-clockwise.
        movementDirection = 1;

        % Radius of the circular path (as a proportion of screen size) along which
        % the stimulus will move.
        radius = 0.3;

        % Adjust the size of the circle based on the radius.
        circleRadius = 0.1 * radius * min(screenXpixels, screenYpixels);  % Circle size
        circleColor = [1 1 1];  % White color for the circle

        % Define the number of positions around the circle where the stimulus can appear.
        % These positions are evenly spaced along the circumference.
        angles = linspace(0, 2 * pi, totalStimulusNumber);

        if movementDirection == -1
            angles = angles(end:-1:1);
        end
        
        experimentSettings.circle.reactionSubsetRatio = reactionSubsetRatio;
        experimentSettings.circle.USE_FIXATION_TASK = USE_FIXATION_TASK;
        experimentSettings.circle.movementDirection = movementDirection;
        experimentSettings.circle.radius = radius;
        experimentSettings.circle.circleRadius = circleRadius;
        experimentSettings.circle.circleColor = circleColor;
        experimentSettings.circle.angles = angles;

    elseif experimentSettings.runType == "garbor"
        % Define Gabor patch parameters
        USE_FIXATION_TASK = true;
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

        experimentSettings.garbor.USE_FIXATION_TASK = USE_FIXATION_TASK;
        experimentSettings.garbor.gaborSize = gaborSize;
        experimentSettings.garbor.spatialFrequency = spatialFrequency;
        experimentSettings.garbor.sc = sc;
        experimentSettings.garbor.contrast = contrast;
        experimentSettings.garbor.frequencyChangeRate = frequencyChangeRate;
        experimentSettings.garbor.scChangeRate = scChangeRate;
        experimentSettings.garbor.contrastChangeRate = contrastChangeRate;
        experimentSettings.garbor.spatialFrequencies = spatialFrequencies;
        experimentSettings.garbor.contrastList = contrastList;
        experimentSettings.garbor.scList = scList;
        experimentSettings.garbor.phaseList = phaseList;
        experimentSettings.garbor.angles = angles;

    elseif  experimentSettings.runType == "movie"
        USE_FIXATION_TASK = true;
        imageHeightRatio = 0.4;
        imageWidthRatio = 0.7;

        imageHeight = imageHeightRatio * screenXpixels;
        imageWidth = imageWidthRatio * screenYpixels;
        
        experimentSettings.movie.imageHeightRatio = imageHeightRatio;
        experimentSettings.movie.imageWidthRatio = imageWidthRatio;
        experimentSettings.movie.imageHeight = imageHeight;
        experimentSettings.movie.imageWidth = imageWidth;
        experimentSettings.movie.USE_FIXATION_TASK = USE_FIXATION_TASK;
    end
end
