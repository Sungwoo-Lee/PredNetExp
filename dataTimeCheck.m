anchorTime = experimentData.startKeyTime;
for i = 1:size(experimentData.trials,2)
    startT = experimentData.trials(i).stimulusStartTime - anchorTime;
    endT = experimentData.trials(i).stimulusEnd - anchorTime;
    fprintf('Trial-[%2d] Start Time [%.2f] End Time [%.2f): \n', i, startT ,endT);
end