% Base paths for input images and output videos
inputBasePath = 'movies/prediction_200frames';
outputBasePath = 'videoVersionStimulus/movie/predictable';

% Define the target height and width for resizing
targetHeight = 400;  % Set desired height
targetWidth = 600;  % Set desired width

% Ensure the output base directory exists
if ~exist(outputBasePath, 'dir')
    mkdir(outputBasePath);
    disp(['Created base output directory: ', outputBasePath]);
end

% Get list of trial folders in the input directory
trialFolders = dir(fullfile(inputBasePath, 'trial_*'));

% Loop through each trial folder
totalVideoDurationSecond = 10;  % Desired video duration for each video
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
    numFrames = length(imageFiles);
    
    % Calculate frame rate to match the total duration
    frameRate = numFrames / totalVideoDurationSecond;

    % Set up VideoWriter for the current trial
    video = VideoWriter(videoFileName, 'MPEG-4');
    video.FrameRate = frameRate;
    open(video);
    
    % Write each frame to the video
    for i = 1:numFrames
        % Read and resize the image
        img = imread(fullfile(trialInputPath, imageFiles(i).name));
        imgResized = imresize(img, [targetHeight, targetWidth]);  % Resize image

        % Add resized image to the video
        writeVideo(video, imgResized);
    end
    
    % Finalize and save the video
    close(video);
    disp(['Video created for ', trialName, ' with precise timing at ', videoFileName]);
end

disp('All trial videos have been created successfully.');
