clear;
clc;
load("data/CheckStimulusBeforeScan/run_12_movie_data.mat");

anchorTime = experimentData.startKeyTime;

% Experiment Start and End Summary
startT = experimentData.startKeyTime - anchorTime;
endT = experimentData.endKeyTime - anchorTime;
duration = endT - startT;
fprintf('\n=== Experiment Timing Summary ===\n');
fprintf('Experiment Start (S Key) : [%.2f seconds]\n', startT);
fprintf('Experiment End   (Q Key) : [%.2f seconds]\n', endT);
fprintf('Total Duration           : [%.2f seconds]\n', duration);
fprintf('------------------------------------\n');

% Trial Information
fprintf('\n=== Trial Timing Details ===\n');
for i = 1:size(experimentData.trials,2)
    startT = experimentData.trials(i).stimulusStartTime - anchorTime;
    endT = experimentData.trials(i).stimulusEnd - anchorTime;
    duration = endT - startT;
    fprintf('Trial %2d:\n', i);
    fprintf('   - Stimulus Start Time : [%.2f seconds]\n', startT);
    fprintf('   - Stimulus End Time   : [%.2f seconds]\n', endT);
    fprintf('   - Duration            : [%.2f seconds]\n', duration);

    % Inter-trial Interval (ITI) Information
    if i < size(experimentData.trials,2)
        startT = experimentData.trials(i).ITIStart - anchorTime;
        endT = experimentData.trials(i+1).trialStart - anchorTime;
        duration = endT - startT;
        fprintf('   - ITI Start Time      : [%.2f seconds]\n', startT);
        fprintf('   - ITI End Time        : [%.2f seconds]\n', endT);
        fprintf('   - ITI Duration        : [%.2f seconds]\n', duration);
    end
    fprintf('------------------------------------\n');
end

% Data Saving Timing
startT = experimentData.dataSavingStart - anchorTime;
endT = experimentData.dataSavingEnd - anchorTime;
duration = endT - startT;
fprintf('\n=== Data Saving Timing ===\n');
fprintf('Data Saving Start Time   : [%.2f seconds]\n', startT);
fprintf('Data Saving End Time     : [%.2f seconds]\n', endT);
fprintf('Data Saving Duration     : [%.2f seconds]\n', duration);
fprintf('------------------------------------\n\n');



% clear;
% clc;
% load("data/run_5_movie_data.mat");
% 
% anchorTime = experimentData.startKeyTime;
% 
% startT = experimentData.startKeyTime - anchorTime;
% endT = experimentData.endKeyTime - anchorTime;
% duration = endT - startT;
% fprintf('Start S key Time [%.2f] End Q key Time [%.2f), Duration [%.2f]: \n', startT ,endT, duration);
% 
% for i = 1:size(experimentData.trials,2)
%     startT = experimentData.trials(i).stimulusStartTime - anchorTime;
%     endT = experimentData.trials(i).stimulusEnd - anchorTime;
%     duration = endT - startT;
%     fprintf('Trial-[%2d] Start Time [%.2f] End Time [%.2f), Duration [%.2f]: \n', i, startT ,endT, duration);
% 
%     if i <size(experimentData.trials,2)
%         startT = experimentData.trials(i).ITIStart - anchorTime;
%         endT = experimentData.trials(i+1).trialStart - anchorTime;
%         duration = endT - startT;
%         fprintf('Trial-[%2d] ITI Start Time [%.2f] End Time [%.2f), Duration [%.2f]: \n', i, startT ,endT, duration);
%     end
% end
% 
% startT = experimentData.dataSavingStart - anchorTime;
% endT = experimentData.dataSavingEnd - anchorTime;
% duration = endT - startT;
% fprintf('Data Saving Start Time [%.2f] End Time [%.2f), Duration [%.2f]: \n', startT ,endT, duration);