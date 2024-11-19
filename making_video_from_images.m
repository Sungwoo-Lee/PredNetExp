% Base paths for input images and output videos
inputBasePath = 'recordings/circle/unpredictable';
% inputBasePath = 'movies/prediction_200frames';
outputBasePath = 'videoVersionStimulus/circle/unpredictable_30fps';
modifyRecordSpeed = true;

% Define the target height and width for resizing
targetWidth = 1920;  % Set desired width
targetHeight = 1080;  % Set desired height
% targetWidth = 800;  % Set desired width
% targetHeight = 600;  % Set desired height
totalVideoDurationSecond = 10;  % Desired video duration for each video

if modifyRecordSpeed
    frameRate = 30;
    uniqueStimulusRepetition = 3;
    skipSimulusNumber = 2;
    repetitionInFinals = 3;
end

% Ensure the output base directory exists
if ~exist(outputBasePath, 'dir')
    mkdir(outputBasePath);
    disp(['Created base output directory: ', outputBasePath]);
end

% Get list of trial folders in the input directory
trialFolders = dir(fullfile(inputBasePath, 'trial_*'));

% Loop through each trial folder
for trialIdx = 1:length(trialFolders)
    % Define input and output paths for each trial
    trialName = trialFolders(trialIdx).name;  % e.g., 'trial_1'
    trialInputPath = fullfile(inputBasePath, trialName);
    trialOutputPath = fullfile(outputBasePath, trialName);

    % Ensure the trial output directory exists
    if ~exist(trialOutputPath, 'dir')
        mkdir(trialOutputPath);
        disp(['Created output directory for ', trialName, ': ', trialOutputPath]);
    end
    
    % Define video file path
    videoFileName = fullfile(trialOutputPath, [trialName, '.mp4']);

    % Load images from the trial folder
    imageFiles = dir(fullfile(trialInputPath, '*.png'));

    if modifyRecordSpeed
        uniqueStimulusIndex = 1:uniqueStimulusRepetition:length(imageFiles);
        selectedStimulusIndex = 1:skipSimulusNumber:length(uniqueStimulusIndex);
        selectedImagesFiles = imageFiles(uniqueStimulusIndex(selectedStimulusIndex));
        imageFiles = selectedImagesFiles;
    end

    numFrames = length(imageFiles);
    % numFrames = length(selectedImagesFiles);

    if ~modifyRecordSpeed
        frameRate = numFrames / totalVideoDurationSecond;
    end

    % Set up VideoWriter for the current trial
    video = VideoWriter(videoFileName, 'MPEG-4');
    video.FrameRate = frameRate;
    open(video);
    
    % Write each frame to the video
    for i = 1:numFrames
        % Read and resize the image
        img = imread(fullfile(trialInputPath, imageFiles(i).name));
        % img = imread(fullfile(trialInputPath, selectedImagesFiles(i).name));
        imgResized = imresize(img, [targetHeight, targetWidth]);  % Resize image
        
        for j = 1:repetitionInFinals
            % Add resized image to the video
            writeVideo(video, imgResized);
        end
    end
    
    % Finalize and save the video
    close(video);
    disp(['Video created for ', trialName, ' with precise timing at ', videoFileName]);
end

disp('All trial videos have been created successfully.');
