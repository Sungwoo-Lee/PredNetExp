function trialSettings = run_trial_movie(trialSettings, experimentSettings, screenSettings, frame)

    %%
    window = screenSettings.window;

    %%
    numFrames = experimentSettings.numFrames;
    images = trialSettings.images;
    totalStimulusNumber = size(images,2);
    numConditions = totalStimulusNumber;
    framesPerCondition = numFrames / numConditions;

    if frame == 0
        conditionInterval = framesPerCondition;
        listOfConditions = 1:1:totalStimulusNumber;

        listOfConditionsPerFrame = repelem(listOfConditions, framesPerCondition);

        trialSettings.listOfConditionsPerFrame = listOfConditionsPerFrame;

    else

        listOfConditionsPerFrame = trialSettings.listOfConditionsPerFrame;
        currentImage = images(listOfConditionsPerFrame(frame));

        texture = Screen('MakeTexture', window, currentImage{1});  % Create texture
        Screen('DrawTexture', window, texture);  % Draw the texture

    end

end