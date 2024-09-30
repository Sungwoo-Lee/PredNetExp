% ============================
% Gabor Patch Visual Stimulus Experiment
% Version 1.0 - Gabor Patch with Adjustable Parameters
% ============================

% 1. INITIAL SETUP AND PREPARATION
Screen('Preference', 'SkipSyncTests', 1);
PsychDefaultSetup(2);

% 2. RANDOM SEED FOR REPRODUCIBILITY
randomSeed = sum(100 * clock);
rng(randomSeed);

% 3. EXPERIMENT PARAMETERS
runNumber = 1;
experimentStartTime = GetSecs();
debugMode = 1;  % 0 for full-screen, 1 for debugging mode

if debugMode
    screenSize = [0 0 800 600]; 
else
    screenSize = [];
end

% 4. SCREEN SETUP
[window, windowRect] = PsychImaging('OpenWindow', 0, [0 0 0], screenSize);
[xCenter, yCenter] = RectCenter(windowRect);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
aspectRatio = screenXpixels / screenYpixels;
fps = Screen('FrameRate', window);
if fps == 0
    fps = 60;
end

% 5. EXPERIMENT VARIABLES
numTrials = 6;
stimulusDuration = 5;  % Stimulus presentation duration in seconds
ITI = 3;  % Inter-trial interval

% Calculate the total number of frames for the stimulus duration based on the
% screen's refresh rate (fps).
numFrames = round(stimulusDuration * fps);

% Define variables for the reaction task
reactionSubsetRatio = 0.7; % Ratio of trials withㄴ a reaction task
reactionTrials = sort(randperm(numTrials, round(numTrials * reactionSubsetRatio))); % Randomly select trials for reaction task

% 6. STIMULUS PARAMETERS
% Define variables for the predictable trials
predictableSubsetRatio = 0.9; % Ratio of trials with a predictable task
predictableTrials = sort(randperm(numTrials, round(numTrials * predictableSubsetRatio))); % Randomly select trials for predictable task

% Speed of the moving stimulus in degrees per second for both predictable and
% unpredictable conditions.
predictableSpeedDeg = 3000;
unpredictableSpeedDeg = 3000;

% Radius of the circular path (as a proportion of screen size) along which
% the stimulus will move.
radius = 0.3;

% Adjust the size of the circle based on the radius.
circleRadius = 0.05 * radius * min(screenXpixels, screenYpixels);  % Circle size
circleColor = [1 1 1];  % White color for the circle

% Parameters for the fixation cross, which remains on the screen to help the
% participant maintain their gaze at the center.
fixCrossDimPix = 0.05 * radius * min(screenXpixels, screenYpixels);
lineWidthPix = 4;  % Thickness of the fixation cross

% Coordinates for the lines that make up the fixation cross.
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Calculate how many frames it takes for the stimulus to move from one position
% to the next, depending on the speed and direction of movement.
framesPerPositionPredictable = round(fps / (predictableSpeedDeg / 360));
framesPerPositionUnpredictable = round(fps / (unpredictableSpeedDeg / 360));

% Define Gabor patch parameters
gaborSize = 600;  % Size of the Gabor patch in pixels
spatialFrequency = 0.01;  % Spatial frequency in cycles per pixel
sigma = 100;  % Standard deviation of the Gaussian envelope
contrast = 300.0;
phase = 0;  % Initial phase (0 to 1)
orientation = 0;  % Orientation angle in degrees

% Change variables
changeOrientation = false;
changeSpatialFrequency = true;

% Create a Gabor texture
% function [gaborid, gaborrect] = CreateProceduralGabor(windowPtr, width, height, nonSymmetric, backgroundColorOffset, disableNorm, contrastPreMultiplicator, validModulationRange)
gaborTexture = CreateProceduralGabor(window, gaborSize, gaborSize, [], [0.0 0.0 0.0 0.0]);


% 6. GABOR PATCH PRESENTATION LOOP
radius = 200;  % Define the radius of the circular path
numSteps = 360;  % Number of steps to complete one circle

% 7. WAITING FOR EXPERIMENT START

% Display instructions on the screen, asking the user to press the 's' key
% to start the experiment. This is typically synchronized with the start of
% an fMRI scan.
DrawFormattedText(window, 'Press ''s'' to start the experiment.', 'center', 'center', [1 1 1]);
Screen('Flip', window);

% Wait for the participant or experimenter to press the 's' key.
while true
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown && keyCode(KbName('s'))
        startKeyTime = GetSecs();  % Record the time when the 's' key is pressed
        break;
    end
end

% 8. INITIAL WAIT PERIOD

% After pressing 's', wait for a specific period (e.g., 13 seconds) before
% starting the experiment. 
waitForStart = 2;
Screen('FillRect', window, [0 0 0]);  % Display a black screen
Screen('DrawLines', window, allCoords, lineWidthPix, [1 1 1], [xCenter yCenter]);  % Show fixation cross
Screen('Flip', window);  % Update the screen with the black screen and fixation cross
WaitSecs(waitForStart);  % Wait for 13 seconds

% Record the time after this initial wait period.
postBreakTime = GetSecs();


% 9. SETTING UP DATA STORAGE

% Create a folder to store experiment data if it doesn't already exist.
if ~exist('data', 'dir')
    mkdir('data');
end

% Store all experiment settings in the experimentData structure
experimentData = struct('experimentStartTime', experimentStartTime, ...
                        'startKeyTime', startKeyTime, ...
                        'postBreakTime', postBreakTime, ...
                        'settings', struct('randomSeed', randomSeed, ...  % Store the random seed
                                           'predictableSubsetRatio', predictableSubsetRatio, ...
                                           'predictableTrials', predictableTrials, ...  % Store the trial types
                                           'runNumber', runNumber, ...
                                           'debugMode', debugMode, ...
                                           'screenSize', screenSize, ...
                                           'xCenter', xCenter, ...
                                           'yCenter', yCenter, ...
                                           'screenXpixels', screenXpixels, ...
                                           'screenYpixels', screenYpixels, ...
                                           'aspectRatio', aspectRatio, ...
                                           'fps', fps, ...
                                           'numTrials', numTrials, ...
                                           'stimulusDuration', stimulusDuration, ...
                                           'waitForStart', waitForStart, ...
                                           'ITI', ITI, ...
                                           'numFrames', numFrames, ...
                                           'predictableSpeedDeg', predictableSpeedDeg, ...
                                           'unpredictableSpeedDeg', unpredictableSpeedDeg, ...
                                           'framesPerPositionPredictable', framesPerPositionPredictable, ...
                                           'framesPerPositionUnpredictable', framesPerPositionUnpredictable), ...
                        'trials', []);

% Main experiment loop
for trial = 1:numTrials
    % Record the trial start time
    trialStartTime = GetSecs();
    
    if ismember(trial, predictableTrials)
        isPredictable = true;
    else
        isPredictable = false;
    end
    
    % Adjust Gabor patch parameters for each frame (optional)
    % Change the orientation dynamically as an example
    if changeOrientation
        orientations = linspace(0, 360, numFrames+1);
    else
        orientations = repmat(orientation, 1, numFrames);
    end

    if changeSpatialFrequency
        spatialFrequencies = linspace(spatialFrequency-(spatialFrequency*0.1), spatialFrequency+(spatialFrequency*0.1), numFrames+1);
    else
        spatialFrequencies = repmat(spatialFrequency, 1, numFrames);
    end

    if ~isPredictable
        orientations = orientations(randperm(length(orientations)));
        spatialFrequencies = spatialFrequencies(randperm(length(spatialFrequencies)));
    end
    
    stimulusStartTime = GetSecs;
    for frame = 1:numFrames
        % Check for 'q' key press to quit the experiment
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown && keyCode(KbName('q'))
            sca;  % Close the screen
            return;  % Exit the function
        end

        % Calculate the position of the Gabor patch on the circular trajectory
        angle = (frame / numFrames) * 2 * pi;
        xPos = xCenter + radius * cos(angle);
        yPos = yCenter + radius * sin(angle);
       

        % Draw the Gabor patch with updated parameters
        Screen('DrawTexture', window, gaborTexture, [], [], orientations(frame), [], [], [], [], ...
            kPsychDontDoRotation, [phase, spatialFrequencies(frame), sigma, contrast, 1, 0, 0, 0]);
        
        % Flip the screen to display the Gabor patch at the calculated position
        Screen('Flip', window);
        
        % Ensure stimulus presentation lasts for the defined duration
        if (GetSecs() - trialStartTime) > stimulusDuration
            break;
        end
    end
    
    % Record the stimulus end time
    stimulusEndTime = GetSecs();
    
    % Record the ITI start time
    ITIStartTime = GetSecs();
    
    % Store timestamps and trial information for the current trial
    experimentData.trials(trial).trialStart = trialStartTime;
    experimentData.trials(trial).stimulusStartTime = stimulusStartTime;
    experimentData.trials(trial).stimulusEnd = stimulusEndTime;
    experimentData.trials(trial).ITIStart = ITIStartTime;
%     experimentData.trials(trial).colorChangeTime = colorChangeRecordTime;
%     experimentData.trials(trial).responseTime = responseTime;
    experimentData.trials(trial).isPredictable = isPredictable;  % Store whether the trial was predictable
%     experimentData.trials(trial).movementDirection = movementDirection;  % Store movement direction
%     experimentData.trials(trial).colorChanged = colorChanged;
    
    % Save the data after each trial (overwriting the same file)
    save(['data/run_' num2str(runNumber) '_data.mat'], 'experimentData');
    
    % Display only the fixation cross during the inter-trial interval (ITI)
    Screen('DrawLines', window, allCoords, lineWidthPix, [1 1 1], [xCenter yCenter]);
    Screen('Flip', window);

    % Inter-trial interval (ITI)
    WaitSecs(ITI);
end

% 7. END OF EXPERIMENT
sca;  % Close all screens
