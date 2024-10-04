function trialSettings = run_trial_garbor(trialSettings, experimentSettings, screenSettings, frame)

    %%
    window = screenSettings.window;

    %%
    numFrames = experimentSettings.numFrames;
    totalStimulusNumber = experimentSettings.totalStimulusNumber;
    %%
    gaborSize = experimentSettings.garbor.gaborSize;
    numConditions = experimentSettings.garbor.numConditions;
    spatialFrequencies = experimentSettings.garbor.spatialFrequencies;
    contrastList = experimentSettings.garbor.contrastList;
    scList = experimentSettings.garbor.scList;
    phaseList = experimentSettings.garbor.phaseList;
    angles = experimentSettings.garbor.angles;
    changeOrientation = experimentSettings.garbor.changeOrientation;
    changeSpatialFrequency = experimentSettings.garbor.changeSpatialFrequency;
    changeContrast = experimentSettings.garbor.changeContrast;
    changeSC = experimentSettings.garbor.changeSC;
    changePhase = experimentSettings.garbor.changePhase;
    framesPerCondition = experimentSettings.garbor.framesPerCondition;

    %%
    if frame == 0
        isPredictable = trialSettings.isPredictable;
        gaborTexture = CreateProceduralGabor(window, gaborSize, gaborSize, [], [0.0 0.0 0.0 0.0]);
        
        conditionInterval = fix(totalStimulusNumber / numConditions);
        listOfConditions = 1:conditionInterval:totalStimulusNumber;
        
        if ~isPredictable
            randomizedIndices = randperm(length(listOfConditions));
            listOfConditions = listOfConditions(randomizedIndices);
        end
        
        listOfConditionsPerFrame = repelem(listOfConditions, framesPerCondition);
    
        if size(listOfConditionsPerFrame,2) < numFrames
            error('SizeError:ConditionListPerFrame', 'The listOfConditions X framesPerCondition is less than total number of frames');
        end

        trialSettings.gaborTexture = gaborTexture;
        trialSettings.listOfConditionsPerFrame = listOfConditionsPerFrame;

    else
        listOfConditionsPerFrame = trialSettings.listOfConditionsPerFrame;
        gaborTexture = trialSettings.gaborTexture;

        if changeOrientation
            currentAngle = angles(listOfConditionsPerFrame(frame));
        else
            currentAngle = angles(1);
        end

        if changeSpatialFrequency
            currentSpatialFrequency = spatialFrequencies(listOfConditionsPerFrame(frame));
        else
            currentSpatialFrequency = spatialFrequencies(fix(length(spatialFrequencies)/2));
        end

        if changeContrast
            currentContrast = contrastList((listOfConditionsPerFrame(frame)));
        else
            currentContrast = contrastList(fix(length(contrastList)/2));
        end

        if changeSC
            currentSC= scList((listOfConditionsPerFrame(frame)));
        else
            currentSC= scList(fix(length(scList)/2));
        end

        if changePhase
            currentPhase= phaseList((listOfConditionsPerFrame(frame)));
        else
            currentPhase= phaseList(fix(length(phaseList)/2));
        end

        % Draw the Gabor patch with updated parameters
        Screen('DrawTexture', window, gaborTexture, [], [], currentAngle, [], [], [], [], ...
            kPsychDontDoRotation, [currentPhase, currentSpatialFrequency, currentSC, currentContrast, 1, 0, 0, 0]);
    end

end