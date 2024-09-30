% ============================
% Predictable and Unpredictable Visual Stimulus Experiment
% Version 1.0
% ============================

% This MATLAB script is designed for an experiment involving visual stimuli
% presented to a participant. The stimuli consist of a circle that
% either moves predictably (in a clockwise or anti-clockwise direction)
% or unpredictably (randomly appearing along a predefined circular path).

% 1. INITIAL SETUP AND PREPARATION

% Set up Psychtoolbox, which includes setting preferences and initializing
% some basic settings that are necessary for the experiment to run correctly.
Screen('Preference', 'SkipSyncTests', 1);
PsychDefaultSetup(2);

% 2. RANDOM SEED FOR REPRODUCIBILITY

% Set a random seed for the experiment. A random seed ensures that the
% randomness in your experiment (like the order of trial types) can be
% replicated if needed. This is crucial for reproducibility.
randomSeed = sum(100 * clock);  % Generate a seed based on the current time
rng(randomSeed);  % Set the random seed in MATLAB

% 3. EXPERIMENT PARAMETERS

% Here we define key experimental parameters, such as the number of trials,
% stimulus duration, and the inter-trial interval (ITI), which is the time
% between trials.

% Set the run number, useful for organizing and distinguishing different runs.
runNumber = 1;

% Record the time when the experiment starts.
experimentStartTime = GetSecs();

% Set the screen size mode. Full-screen is used during the actual experiment,
% while a smaller screen is helpful during debugging.
debugMode = 1;  % 0 for full-screen mode, 1 for debugging mode

if debugMode
    % For debugging, set a smaller screen size.
    screenSize = [0 0 800 600];  % Example of a small screen size
else
    % For the actual experiment, use full-screen mode.
    screenSize = [];
end

% 4. SCREEN SETUP

% Open a window on the screen and set the background color to black (0,0,0).
[window, windowRect] = PsychImaging('OpenWindow', 0, [0 0 0], screenSize);

% Get the center coordinates of the screen. These are used to place stimuli
% at the center of the screen.
[xCenter, yCenter] = RectCenter(windowRect);

% Get the dimensions of the screen in pixels.
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Calculate the aspect ratio of the screen, which helps in adjusting stimulus
% size and positioning correctly.
aspectRatio = screenXpixels / screenYpixels;

% Get the refresh rate of the screen, which is the number of frames per second
% the screen can display. If it returns 0 (which may happen in some setups),
% we set it to 60 Hz as a default.
fps = Screen('FrameRate', window);
if fps == 0
    fps = 60;
end

% 5. EXPERIMENT VARIABLES

% Number of trials to be conducted in the experiment.
numTrials = 6;

% Duration of each stimulus presentation in seconds.
stimulusDuration = 5;

% Duration of the inter-trial interval (ITI) in seconds.
ITI = 3;

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

% Determine whether the predictable stimulus moves clockwise or anti-clockwise.
% 1 for clockwise, -1 for anti-clockwise.
movementDirection = 1;

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

% Define the number of positions around the circle where the stimulus can appear.
% These positions are evenly spaced along the circumference.
numPositions = 40;
angles = linspace(0, 2 * pi, numPositions + 1);
angles(end) = [];  % Remove the last point to avoid duplication

% Calculate how many frames it takes for the stimulus to move from one position
% to the next, depending on the speed and direction of movement.
framesPerPositionPredictable = round(fps / (predictableSpeedDeg / 360));
framesPerPositionUnpredictable = round(fps / (unpredictableSpeedDeg / 360));

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
waitForStart = 13;
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

% 10. MAIN EXPERIMENT

% The rest of the code would include the logic for the main experiment loop,
% saving data after each trial, and eventually closing the screen and ending
% the experiment.

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
                                           'reactionSubsetRatio', reactionSubsetRatio, ...
                                           'reactionTrials', reactionTrials, ...
                                           'stimulusDuration', stimulusDuration, ...
                                           'waitForStart', waitForStart, ...
                                           'ITI', ITI, ...
                                           'numFrames', numFrames, ...
                                           'predictableSpeedDeg', predictableSpeedDeg, ...
                                           'unpredictableSpeedDeg', unpredictableSpeedDeg, ...
                                           'movementDirection', movementDirection, ...
                                           'radius', radius, ...
                                           'circleRadius', circleRadius, ...
                                           'circleColor', circleColor, ...
                                           'fixCrossDimPix', fixCrossDimPix, ...
                                           'lineWidthPix', lineWidthPix, ...
                                           'numPositions', numPositions, ...
                                           'framesPerPositionPredictable', framesPerPositionPredictable, ...
                                           'framesPerPositionUnpredictable', framesPerPositionUnpredictable), ...
                        'trials', []);

% Main experiment loop
for trial = 1:numTrials
    % Record the trial start time
    trialStartTime = GetSecs();
    
    % Determine if the current trial is predictable or unpredictable
%     isPredictable = trialTypes(trial);

    if ismember(trial, predictableTrials)
        isPredictable = true;
    else
        isPredictable = false;
    end
    
    if isPredictable
        % Predictable condition: Start at a random position and move sequentially
        startIdx = randi([1, numPositions]);
        currentIdx = startIdx;
        framesPerPosition = framesPerPositionPredictable;
        currentAngle = angles(currentIdx);  % Initialize currentAngle for predictable condition
    else
        % Unpredictable condition: Randomize the order of angles
        randomizedIndices = randperm(numPositions);
        currentIdx = 1;  % Start with the first randomized position
        framesPerPosition = framesPerPositionUnpredictable;
        currentAngle = angles(randomizedIndices(currentIdx));  % Initialize currentAngle for unpredictable condition
    end
    
    % Randomly select color change time for reaction trials
    if ismember(trial, reactionTrials)
        colorChangeTime = rand * (stimulusDuration - 1.5); % Random time within the trial (leaving 1.5 sec for response)
    end

    frameCounter = 0;  % To track when to move to the next position
    colorChanged = false; % Flag to check if the color has changed
    responseLogged = false; % Flag to check if the response has been logged
    colorChangeRecordTime = NaN;
    responseTime = NaN;
    
    % Record the stimulus start time
    stimulusStartTime = GetSecs;
    for frame = 1:numFrames
        % Check for 'q' key press to quit the experiment
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown && keyCode(KbName('q'))
            sca;  % Close the screen
            return;  % Exit the function
        end
        
        if frameCounter >= framesPerPosition
            frameCounter = 0;
            if isPredictable
                % Predictable movement: move to the next position along the circumference
                currentIdx = mod(currentIdx - 1 + movementDirection, numPositions) + 1;
                currentAngle = angles(currentIdx);
            else
                % Unpredictable movement: jump to the next randomized position
                randomIdx = randomizedIndices(currentIdx);
                currentAngle = angles(randomIdx);
                currentIdx = mod(currentIdx, numPositions) + 1;
            end
        end
        
        xPos = xCenter + radius * screenXpixels * cos(currentAngle) / aspectRatio;
        yPos = yCenter + radius * screenYpixels * sin(currentAngle);
        
        % Draw the circle at the calculated position
        Screen('FillOval', window, circleColor, ...
            [xPos - circleRadius, yPos - circleRadius, xPos + circleRadius, yPos + circleRadius]);

        % Change fixation cross color at the designated time
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

        % Flip to the screen
        Screen('Flip', window);
        
        frameCounter = frameCounter + 1;  % Increment the frame counter
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
    experimentData.trials(trial).colorChangeTime = colorChangeRecordTime;
    experimentData.trials(trial).responseTime = responseTime;
    experimentData.trials(trial).isPredictable = isPredictable;  % Store whether the trial was predictable
    experimentData.trials(trial).movementDirection = movementDirection;  % Store movement direction
    experimentData.trials(trial).colorChanged = colorChanged;
    
    % Save the data after each trial (overwriting the same file)
    save(['data/run_' num2str(runNumber) '_data.mat'], 'experimentData');
    
    % Display only the fixation cross during the inter-trial interval (ITI)
    Screen('DrawLines', window, allCoords, lineWidthPix, [1 1 1], [xCenter yCenter]);
    Screen('Flip', window);
    
    % Pause for the inter-trial interval (ITI)
    WaitSecs(ITI);
end

% Cleanup
sca;
