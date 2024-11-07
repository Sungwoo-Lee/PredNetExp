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

% Setting the defaults
defaultRunNumber = 1;
defaultRunType = 'circle';  % Could be 'circle', 'garbor' or 'movie'
defaultRecording = 0;      % True (1) or False (0)
defaultDebugMode = 0;     % Set the screen size mode. Full-screen is used during the actual experiment, 0 for full-screen mode, 1 for debugging mode
defaultReactionSubsetRatio = 0.0; % Ratio of trials with a reaction task (0.0~1.0)
defaultPredictableSubsetRatio = 0.0; % Ratio of trials with a predictable task (0.0~1.0)

% Default values for 'garbor' settings
defaultChangeOrientation = 1;         % True (1) or False (0)
defaultChangeSpatialFrequency = 0;    % True (1) or False (0)
defaultChangeSC = 0;                  % True (1) or False (0)
defaultChangePhase = 0;               % True (1) or False (0)
defaultChangeContrast = 0;            % True (1) or False (0)

% Display the default settings
disp('============================================================');
disp('             *** EXPERIMENT DEFUALT SETTINGS ***                    ');
disp('============================================================');
fprintf(' %-30s: %d\n', 'Run Number', defaultRunNumber);
fprintf(' %-30s: %s\n', 'Run Type', defaultRunType);
fprintf(' %-30s: %s\n', 'Recording', convertBooleanToYesNo(defaultRecording));
fprintf(' %-30s: %s\n', 'Debug Mode', convertBooleanToYesNo(defaultDebugMode));
fprintf(' %-30s: %.2f\n', 'Reaction Subset Ratio', defaultReactionSubsetRatio);
fprintf(' %-30s: %.2f\n', 'Predictable Subset Ratio', defaultPredictableSubsetRatio);
disp('============================================================');

% Prompt user for each setting (press Enter to keep default)
runNumber = input(sprintf('-> Enter Run Number (default [%d]): ', defaultRunNumber));
if isempty(runNumber)
    runNumber = defaultRunNumber;  % Keep default if empty
end

runType = input(sprintf('-> Enter Run Type (circle/garbor/movie) (default [%s]): ', defaultRunType), 's');
if isempty(runType)
    runType = defaultRunType;  % Keep default if empty
elseif ~strcmpi(runType, 'circle') && ~strcmpi(runType, 'garbor') && ~strcmpi(runType, 'movie')
    error('Invalid input. Please enter ''circle'', ''garbor'' or ''movie''.');
end

recording = input(sprintf('-> Enable Recording? (1 for true or 0 for false) (default [%s]): ', convertBooleanToYesNo(defaultRecording)));
if isempty(recording)
    recording = defaultRecording;  % Keep default if empty
elseif recording == 1
    recording = true;
elseif recording == 0
    recording = false;
else
    error('Invalid input. Please enter ''1'' or ''0''.');
end

debugMode = input(sprintf('-> Enable Debug Mode? (1 for true or 0 for false) (default [%s]): ', convertBooleanToYesNo(defaultDebugMode)));
if isempty(debugMode)
    debugMode = defaultDebugMode;  % Keep default if empty
elseif debugMode == 1
    debugMode = true;
elseif debugMode == 0
    debugMode = false;
else
    error('Invalid input. Please enter ''1'' or ''0''.');
end

predictableSubsetRatio = input(sprintf('-> Enter Predictable Subset Ratio (0.0~1.0) (default [%.2f]): ', defaultPredictableSubsetRatio));
if isempty(predictableSubsetRatio)
    predictableSubsetRatio = defaultPredictableSubsetRatio;  % Keep default if empty
elseif predictableSubsetRatio < 0.0 || predictableSubsetRatio > 1.0
    error('Invalid input. Please enter a value between 0.0 and 1.0.');
end

reactionSubsetRatio = input(sprintf('-> Enter Reaction Subset Ratio (0.0~1.0) (default [%.2f]): ', defaultReactionSubsetRatio));
if isempty(reactionSubsetRatio)
    reactionSubsetRatio = defaultReactionSubsetRatio;  % Keep default if empty
elseif reactionSubsetRatio < 0.0 || reactionSubsetRatio > 1.0
    error('Invalid input. Please enter a value between 0.0 and 1.0.');
end

if strcmpi(runType, 'circle')
    disp('------------------- Circle-Specific Settings ----------------');
end

% Conditional prompts for garbor-specific settings
if strcmpi(runType, 'garbor')
    disp('------------------- Garbor-Specific Settings ----------------');
    
    changeOrientation = input(sprintf('-> Change Orientation? (1 for true or 0 for false) (default [%s]): ', convertBooleanToYesNo(defaultChangeOrientation)));
    if isempty(changeOrientation)
        changeOrientation = defaultChangeOrientation;  % Keep default if empty
    elseif changeOrientation ~= 1 && changeOrientation ~= 0
        error('Invalid input. Please enter ''1'' or ''0''.');
    end

    changeSpatialFrequency = input(sprintf('-> Change Spatial Frequency? (1 for true or 0 for false) (default [%s]): ', convertBooleanToYesNo(defaultChangeSpatialFrequency)));
    if isempty(changeSpatialFrequency)
        changeSpatialFrequency = defaultChangeSpatialFrequency;  % Keep default if empty
    elseif changeSpatialFrequency ~= 1 && changeSpatialFrequency ~= 0
        error('Invalid input. Please enter ''1'' or ''0''.');
    end

    changeSC = input(sprintf('-> Change SC? (1 for true or 0 for false) (default [%s]): ', convertBooleanToYesNo(defaultChangeSC)));
    if isempty(changeSC)
        changeSC = defaultChangeSC;  % Keep default if empty
    elseif changeSC ~= 1 && changeSC ~= 0
        error('Invalid input. Please enter ''1'' or ''0''.');
    end

    changePhase = input(sprintf('-> Change Phase? (1 for true or 0 for false) (default [%s]): ', convertBooleanToYesNo(defaultChangePhase)));
    if isempty(changePhase)
        changePhase = defaultChangePhase;  % Keep default if empty
    elseif changePhase ~= 1 && changePhase ~= 0
        error('Invalid input. Please enter ''1'' or ''0''.');
    end

    changeContrast = input(sprintf('-> Change Contrast? (1 for true or 0 for false) (default [%s]): ', convertBooleanToYesNo(defaultChangeContrast)));
    if isempty(changeContrast)
        changeContrast = defaultChangeContrast;  % Keep default if empty
    elseif changeContrast ~= 1 && changeContrast ~= 0
        error('Invalid input. Please enter ''1'' or ''0''.');
    end
end

% Final display of chosen settings
disp('============================================================');
disp('                  *** MODIFIED EXPERIMENT SETTINGS ***           ');
disp('============================================================');
fprintf(' %-30s: %d\n', 'Run Number', runNumber);
fprintf(' %-30s: %s\n', 'Run Type', runType);
fprintf(' %-30s: %s\n', 'Recording', convertBooleanToYesNo(recording));
fprintf(' %-30s: %s\n', 'Debug Mode', convertBooleanToYesNo(debugMode));
fprintf(' %-30s: %.2f\n', 'Predictable Subset Ratio', predictableSubsetRatio);
fprintf(' %-30s: %.2f\n', 'Reaction Subset Ratio', reactionSubsetRatio);

if strcmpi(runType, 'circle')
end

if strcmpi(runType, 'garbor')
    fprintf(' %-30s: %s\n', 'Change Orientation', convertBooleanToYesNo(changeOrientation));
    fprintf(' %-30s: %s\n', 'Change Spatial Frequency', convertBooleanToYesNo(changeSpatialFrequency));
    fprintf(' %-30s: %s\n', 'Change SC', convertBooleanToYesNo(changeSC));
    fprintf(' %-30s: %s\n', 'Change Phase', convertBooleanToYesNo(changePhase));
end
disp('============================================================');


experimentSettings.runNumber = runNumber;
experimentSettings.runType = runType;
experimentSettings.recording = recording;
experimentSettings.predictableSubsetRatio = predictableSubsetRatio;
experimentSettings.reactionSubsetRatio = reactionSubsetRatio;

if strcmpi(runType, 'circle')
elseif strcmpi(runType, 'garbor')
    experimentSettings.garbor.changeOrientation = changeOrientation;
    experimentSettings.garbor.changeSpatialFrequency = changeSpatialFrequency;
    experimentSettings.garbor.changeSC = changeSC;
    experimentSettings.garbor.changePhase = changePhase;
    experimentSettings.garbor.changeContrast = changeContrast;
elseif strcmpi(runType, 'movie')
    movieFolders = dir(fullfile('movies'));
    experimentSettings.movie.movieFolders = movieFolders;
end

%%
% 3. EXPERIMENT VARIABLES
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

experimentSettings = ExperimentSettings(experimentSettings, screenSettings);
lineWidthPix = experimentSettings.lineWidthPix;
allCoords = experimentSettings.allCoords;

%%
% 4. SETTING UP DATA STORAGE

% Create a folder to store experiment data if it doesn't already exist.
if ~exist('data', 'dir')
    mkdir('data');
end

% Store all experiment settings in the experimentData structure
experimentData = struct('experimentStartTime', experimentStartTime, ...
                        'settings', struct('screenSettings', screenSettings, ...
                                           'experimentSettings', experimentSettings), ...
                        'trials', []);

% Define the path to the folder
recordingFolder = fullfile(pwd, 'recordings');

% Check if the folder exists, if not, create it
if ~exist(recordingFolder, 'dir')
    mkdir(recordingFolder);
end

% Print details of experimentData.settings.screenSettings
disp('============================================================');
disp('         *** EXPERIMENT DATA DETAILS ***                    ');
% Example usage for screenSettings and experimentSettings
printStructDetails('Screen Settings', experimentData.settings.screenSettings);
printStructDetails('Experiment Settings', experimentData.settings.experimentSettings);
disp('============================================================');


%%
% 5. WAITING FOR EXPERIMENT START

% Display instructions on the screen, asking the user to press the 's' key
% to start the experiment. This is typically synchronized with the start of
% an fMRI scan.
DrawFormattedText(window, 'Press ''s'' to start the experiment.', 'center', 'center', [1 1 1]);
Screen('Flip', window);

% Wait for the participant or experimenter to press the 's' key.
while true
    [keyIsDown, ~, keyCode] = KbCheck(-1);
    if keyIsDown && keyCode(KbName('s'))
        startKeyTime = GetSecs();  % Record the time when the 's' key is pressed
        break;
    end
end
experimentData.startKeyTime = startKeyTime;

%%
% 6. INITIAL WAIT PERIOD
waitForStart = 3; % 13

% After pressing 's', wait for a specific period (e.g., 13 seconds) before
% starting the experiment. 
Screen('FillRect', window, [0 0 0]);  % Display a black screen
Screen('DrawLines', window, allCoords, lineWidthPix, [1 1 1], [xCenter yCenter]);  % Show fixation cross
Screen('Flip', window);  % Update the screen with the black screen and fixation cross
WaitSecs(waitForStart);  % Wait for 13 seconds

% Record the time after this initial wait period.
postBreakTime = GetSecs();

experimentData.postBreakTime = postBreakTime;

%%
% 7. MAIN EXPERIMENT
globalFrame = 1;

% Main experiment loop
for trial = 1:experimentSettings.numTrials
    [experimentData, globalFrame] = run_trial(trial, experimentSettings, screenSettings, experimentData, globalFrame);
    
    % Save the data after each trial (overwriting the same file)
%     save(['data/run_' num2str(runNumber) '_' runType '_data.mat'], 'experimentData');

    % Pause for the inter-trial interval (ITI)
    if experimentSettings.recording
        for frame = 1:experimentSettings.itiFrames
            % Display only the fixation cross during the inter-trial interval (ITI)
            Screen('DrawLines', window, allCoords, lineWidthPix, [1 1 1], [xCenter yCenter]);
            Screen('Flip', window);

            % Define the rectangle for capturing (entire screen)
            rect = [];  % Empty rectangle captures the entire screen

            %         if experimentSettings.recording
            % Capture the frame from the screen
            imageArray = Screen('GetImage', window, rect);
            fileName = fullfile('recordings', sprintf('globalFrame%04d_trial%03d_ITI_frame_%04d.png', globalFrame, trial, frame));
            % Save the image as a file
            imwrite(imageArray, fileName);

            globalFrame = globalFrame + 1;
            %         end
        end
    else
        Screen('DrawLines', window, allCoords, lineWidthPix, [1 1 1], [xCenter yCenter]);
        Screen('Flip', window);
        WaitSecs(experimentSettings.ITI);
    end
end

dataSavingStart = GetSecs();
experimentData.dataSavingStart = dataSavingStart;
save(['data/run_' num2str(runNumber) '_' runType '_data.mat'], 'experimentData');

dataSavingEnd = GetSecs();
experimentData.dataSavingEnd = dataSavingEnd;

DrawFormattedText(window, 'Press ''q'' to end the experiment.', 'center', 'center', [1 1 1]);
Screen('Flip', window);
% Wait for the participant or experimenter to press the 's' key.
while true
    [keyIsDown, ~, keyCode] = KbCheck(-1);
    if keyIsDown && keyCode(KbName('q'))
        endKeyTime = GetSecs();  % Record the time when the 's' key is pressed
        break;
    end
end
experimentData.endKeyTime = endKeyTime;
save(['data/run_' num2str(runNumber) '_' runType '_data.mat'], 'experimentData');

%%
% Cleanup
sca;
