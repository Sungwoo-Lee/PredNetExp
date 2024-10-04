% ============================
% Predictable and Unpredictable Visual Stimulus Experiment
% Version 1.0
% ============================
clear;
clc;
sca;

%%
% This MATLAB script is designed for an experiment involving visual stimuli
% presented to a participant.

% Record the time when the experiment starts.
experimentStartTime = GetSecs();

% 1. RANDOM SEED FOR REPRODUCIBILITY

% Set a random seed for the experiment. A random seed ensures that the
% randomness in your experiment (like the order of trial types) can be
% replicated if needed. This is crucial for reproducibility.
timestamp = datetime("now");
randomSeed = sum(posixtime(timestamp));  % Generate a seed based on the current time
rng(randomSeed);  % Set the random seed in MATLAB

%%
% 2. EXPERIMENT SETTINGS

% Here we define key experimental parameters, such as the number of trials,
% stimulus duration, and the inter-trial interval (ITI), which is the time
% between trials.

% Set the run number, useful for organizing and distinguishing different runs.
runNumber = 1;
% runType = "circle";
runType = "garbor";

experimentSettings.runNumber = runNumber;
experimentSettings.runType = runType;

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

screenSettings = ScreenSettings(screenSize);
window = screenSettings.window;
xCenter = screenSettings.xCenter;
yCenter = screenSettings.yCenter;

%%
% 3. EXPERIMENT VARIABLES
% Number of trials to be conducted in the experiment.
numTrials = 2;

% Duration of each stimulus presentation in seconds.
stimulusDuration = 10;

% Duration of the inter-trial interval (ITI) in seconds.
ITI = 3;
itiFrames = ITI * screenSettings.fps;

% Duration of stabilizing the scanner
waitForStart = 3; % 13

% Calculate the total number of frames for the stimulus duration based on the
% screen's refresh rate (fps).
experimentSettings.numFrames = round(stimulusDuration * screenSettings.fps);
experimentSettings.numTrials = numTrials;
experimentSettings.stimulusDuration = stimulusDuration;
experimentSettings.ITI = ITI;
experimentSettings.itiFrames = itiFrames;
experimentSettings = ExperimentSettings(experimentSettings, screenSettings);

lineWidthPix = experimentSettings.lineWidthPix;
allCoords = experimentSettings.allCoords;

%%
% 4. WAITING FOR EXPERIMENT START

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

%%
% 5. INITIAL WAIT PERIOD

% After pressing 's', wait for a specific period (e.g., 13 seconds) before
% starting the experiment. 
Screen('FillRect', window, [0 0 0]);  % Display a black screen
Screen('DrawLines', window, allCoords, lineWidthPix, [1 1 1], [xCenter yCenter]);  % Show fixation cross
Screen('Flip', window);  % Update the screen with the black screen and fixation cross
WaitSecs(waitForStart);  % Wait for 13 seconds

% Record the time after this initial wait period.
postBreakTime = GetSecs();

%%
% 6. SETTING UP DATA STORAGE

% Create a folder to store experiment data if it doesn't already exist.
if ~exist('data', 'dir')
    mkdir('data');
end

% Store all experiment settings in the experimentData structure
experimentData = struct('experimentStartTime', experimentStartTime, ...
                        'startKeyTime', startKeyTime, ...
                        'postBreakTime', postBreakTime, ...
                        'settings', struct('screenSettings', screenSettings, ...
                                           'experimentSettings', experimentSettings), ...
                        'trials', []);

% Define the path to the folder
recordingFolder = fullfile(pwd, 'recordings');

% Check if the folder exists, if not, create it
if ~exist(recordingFolder, 'dir')
    mkdir(recordingFolder);
end

%%
% 7. MAIN EXPERIMENT
globalFrame = 1;

% Main experiment loop
for trial = 1:numTrials
    [experimentData, globalFrame] = run_trial(trial, experimentSettings, screenSettings, experimentData, globalFrame);
    
    % Save the data after each trial (overwriting the same file)
    save(['data/run_' num2str(runNumber) '_data.mat'], 'experimentData');
    
    % Pause for the inter-trial interval (ITI)
%     WaitSecs(ITI);
    for frame = 1:itiFrames
        % Display only the fixation cross during the inter-trial interval (ITI)
        Screen('DrawLines', window, allCoords, lineWidthPix, [1 1 1], [xCenter yCenter]);
        Screen('Flip', window);

        % Define the rectangle for capturing (entire screen)
        rect = [];  % Empty rectangle captures the entire screen
        
        % Capture the frame from the screen
        imageArray = Screen('GetImage', window, rect);
        fileName = fullfile('recordings', sprintf('globalFrame%04d_trial%03d_ITI_frame_%04d.png', globalFrame, trial, frame));
        % Save the image as a file
        imwrite(imageArray, fileName);

        globalFrame = globalFrame + 1;
    end
end

%%
% Cleanup
sca;
