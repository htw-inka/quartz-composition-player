The following commands can be used via command line arguments:

-help
    Shows this help page ignoring all other arguments.

General application settings:

-window-size=W,H
    Substitute W and H with one integer each and application will start with the give size.
    Using -window-size=LED-Grid will start the application with the size of the LED grid.
    Using _window-size=LED-Complete will start the application with the size of the LED grid plus spot lights.
    (default: -window-size=300,100)

-window-origin=X,Y
    Substitute X and Y with one integer each amd the application will start at the given position.
    Using -window-origin=LED-Grid will start the application at the LED grid position.
    Using -window-origin=LED-Complete will start the application at the LED grid plus spot lights position.
    Beware: Since Cocoa has a different coordinate system than most other programming frameworks 0,0 won't be in 
    the upper-left corner but in the bottom-left corner.

Loading a custom Quartz composition:

-composition=<path>
    Loads the given Quartz composition.
    Substitute <path> either with a path or an URL to the Quartz composition.

-arguments={key:value,key:value,...}
    If set a collection of key:value pairs separated by ',' surrounded by '{ }' containing the arguments that should be passed to the custom Quartz composition is expected.

Showing media file(s):

-image={path:<path>,<optionalParameter>:<optinalValue>,...}
    Displays an image. Most common image file formats are supported: JPEG, TIFF, PNG, GIF, BMP, TGA, OpenEXR, JPEG 2000, PDF...
    Substitute <path> with a path or URL to the file's location. (required)
    Optional Parameters are:
        width:<value>
            Substitute <value> with an integer value > 0 or "auto" if you want the width to adjust to height and keep aspect ratio.
            Substitute <value> with "full" if you want to use the full window width. (default: width:auto)
        height:<value>
            Substitute <value> with an integer value > 0 or "auto" if you want the height to adjust to width and keep aspect ratio. (default: height:auto)
            Substitute <value> with "full" if you want to use the full window height. (default: height:auto)
        Beware: If both width:value> and height:<value> are set to "auto" aspect ratio will be kept by scaling the image to fit the window in both dimensions.
                If both width:<value> and height:<value> are set to "full" aspect ratio will be lost by scaling the image to fit the entire window.
        
-video={path:<path>,<optionalParameter>:<optinalValue>,...}
    Displays a movie file. The video has to be a QuickTime movie in MOV format.
    Substitute <path> with a path or URL to the file's location. (required)
    Optional Parameters are:
        width:<value>
            Substitute <value> with an integer value > 0 or "auto" if you want the width to adjust to height and keep aspect ratio.
            Substitute <value> with "full" if you want to use the full window width. (Default: "auto")
        height:<value>
            Substitute <value> with an integer value > 0 or "auto" if you want the height to adjust to width and keep aspect ratio. (Default: "auto")
            Substitute <value> with "full" if you want to use the full window height. (Default: "auto")
            Beware: If both width:<value> and height:<value> are set to "auto" aspect ratio will be kept by scaling the image to fit the window in both dimensions.
                    If both width:<value> and height:<value> are set to "full" aspect ratio will be lost by scaling the image to fit the entire window.
        loops:<value>
            Substitute <value> with an integer > 0 to set how often the movie should be played. If not set or with an integer less or equal to 0
            the movie will be looped as long as the application is running. (default: loops:0)
        rate:<value>
            Substitute <value> with a decimal number to set the playback speed of the video. rate:0.0 meaning pause, rate:1.0 meaning normal playback speed, rate:-1.0 meaning reverse playback, rate:2.0 meaning double playback speed. (default: rate:1.0)
        start:<value>
            Substitute <value> with a positiv decimal number between 0 and the duration of your movie to set the time stamp where the movie playback should start.
            Values < 0 will be ignored. If the value exeeds the total movie duration it will be ignored.
            Set to "0" or don't set to start at the beginning of the video. (default: start:0.0)
        duration:<value>
            Substitute <value> with a positiv decimal number > 0 to set the duration the movie should be played starting either at the time set via
            start:<value> command or at the beginning of the video. If set to "0" the argument start:value will be ingnored and the
            whole video will be played. If the sum of start:<value> and duration:<value> exeeds the movie duration this option will also be ignored.