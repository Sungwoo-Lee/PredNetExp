% Clear the command window for a clean start
clc;
clear;

% Fancy welcome message
disp('==============================================');
disp('***    Welcome to the Trial File Organizer   ***');
disp('==============================================');
fprintf('\n');

% Define the path to the 'recordings' folder
recordingsFolder = fullfile(pwd, 'recordings');

% Check if the recordings folder exists
if ~exist(recordingsFolder, 'dir')
    error('The recordings folder does not exist in the current directory.');
end

% Get a list of all PNG files in the recordings directory
fileList = dir(fullfile(recordingsFolder, '*.png'));

% Initialize a counter for total files moved
totalFilesMoved = 0;

% Loop over each file in the list
for k = 1:length(fileList)
    filename = fileList(k).name;
    filePath = fullfile(fileList(k).folder, filename);
    
    % Check if the file is a STIMULUS frame (exclude ITI frames)
    if contains(filename, 'STIMULUS')
        % Extract the trial number using regular expression
        trialNumStr = regexp(filename, 'trial(\d+)', 'tokens');
        
        if ~isempty(trialNumStr)
            % Convert trial number string to a number
            trialNum = str2double(trialNumStr{1}{1});
            
            % Create the trial folder name under recordings
            folderName = fullfile(recordingsFolder, sprintf('trial_%d', trialNum));
            
            % Check if the trial folder exists; if not, create it
            if ~exist(folderName, 'dir')
                mkdir(folderName);
                
                % Display a fancy message when a new folder is created
                fprintf('✨ Created new folder: %s ✨\n', folderName);
            end
            
            % Move the STIMULUS frame file into the trial folder
            movefile(filePath, fullfile(folderName, filename));
            totalFilesMoved = totalFilesMoved + 1;
        end
    end
end

fprintf('\n');
% Fancy completion message
disp('==============================================');
disp('***   All files have been successfully      ***');
disp('***         organized! 🎉                    ***');
disp(['***   Total files moved: ', num2str(totalFilesMoved), '                    ***']);
disp('==============================================');
