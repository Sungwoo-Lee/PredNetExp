% Define the base paths for input images and output videos
inputBasePath = 'recordings/circle/predictable/';
outputBasePath = 'videoVersionStimulus/circle/predictable_30fps';
modifyRecordSpeed = true;

% Define the target height and width for resizing
targetWidth = 1920;   % Desired width
targetHeight = 1080;  % Desired height
totalVideoDurationSecond = 10;  % Adjust as needed

if modifyRecordSpeed
    frameRate = 30;
    uniqueStimulusRepetition = 3;
    skipSimulusNumber = 2;
    repetitionInFinals = 3;
end

% Ensure the output base directory exists
if ~exist(outputBasePath, 'dir')
    mkdir(outputBasePath);
    disp(['✨ Created base output directory: ', outputBasePath]);
end

% Load images from the trial_1 folder
imageFiles = dir(fullfile(inputBasePath, '*.png'));

% Sort image files by name to ensure correct order
[~, idx] = sort({imageFiles.name});
imageFiles = imageFiles(idx);

if modifyRecordSpeed
    uniqueStimulusIndex = 1:uniqueStimulusRepetition:length(imageFiles);
    selectedStimulusIndex = 1:skipSimulusNumber:length(uniqueStimulusIndex);
    selectedImagesFiles = imageFiles(uniqueStimulusIndex(selectedStimulusIndex));
    imageFiles = selectedImagesFiles;
end

numFrames = length(imageFiles);

if numFrames == 0
    error('No images found in the trial_1 folder.');
end

% Loop through each trial to generate videos
for trial = 1:14
    % Define trial name and output path
    trialName = sprintf('trial_%d', trial);
    trialOutputPath = fullfile(outputBasePath, trialName);

    % Ensure the trial output directory exists
    if ~exist(trialOutputPath, 'dir')
        mkdir(trialOutputPath);
        disp(['✨ Created output directory for ', trialName, ': ', trialOutputPath]);
    end

    % Define video file path
    videoFileName = fullfile(trialOutputPath, [trialName, '.mp4']);

    if ~modifyRecordSpeed
        frameRate = numFrames / totalVideoDurationSecond;
    end

    % Set up VideoWriter for the current trial
    video = VideoWriter(videoFileName, 'MPEG-4');
    video.FrameRate = frameRate;
    open(video);

    fprintf('🎥 Creating video for %s ...\n', trialName);

    % Write each frame to the video
    for i = 1:numFrames
        % Read and resize the image
        img = imread(fullfile(inputBasePath, imageFiles(i).name));
        imgResized = imresize(img, [targetHeight, targetWidth]);  % Resize image

        % Add resized image to the video
        for j = 1:repetitionInFinals
            writeVideo(video, imgResized);
        end
    end

    % Finalize and save the video
    close(video);
    fprintf('✅ Video for %s saved at %s\n', trialName, videoFileName);
end

fprintf('\n');
% Fancy completion message
disp('==============================================');
disp('***   Videos for all trials have been       ***');
disp('***        successfully generated! 🎉        ***');
disp('==============================================');
