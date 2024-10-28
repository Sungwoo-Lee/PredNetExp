function screenSettings = ScreenSettings(screenSize)
   
    % Set up Psychtoolbox, which includes setting preferences and initializing
    % some basic settings that are necessary for the experiment to run correctly.
    Screen('Preference', 'SkipSyncTests', 1);
    PsychDefaultSetup(2);
    
    % Open a window on the screen and set the background color to black (0,0,0).
    [window, windowRect] = PsychImaging('OpenWindow', 0, [0 0 0], screenSize);
    
    % Get the center coordinates of the screen. These are used to place stimuli
    % at the center of the screen.
    [xCenter, yCenter] = RectCenter(windowRect);
    
    % Get the dimensions of the screen in pixels.
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    
    % Calculate the aspect ratio of the screen, which helps in adjusting stimulus
    % size and positioning correctly.
    aspectRatio = screenXpixels / screenYpixels;
    
    % Get the refresh rate of the screen, which is the number of frames per second
    % the screen can display. If it returns 0 (which may happen in some setups),
    % we set it to 60 Hz as a default.
    fps = Screen('FrameRate', window);
    if fps == 0
        fps = 60;
    end

%     fps = 24;

    screenSettings.window = window;
    screenSettings.windowRect = windowRect;
    screenSettings.xCenter = xCenter;
    screenSettings.yCenter = yCenter;
    screenSettings.screenXpixels = screenXpixels;
    screenSettings.screenYpixels = screenYpixels;
    screenSettings.aspectRatio = aspectRatio;
    screenSettings.fps = fps;
end
