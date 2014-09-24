### The following commands can be used via command line arguments ###

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

## Loading a custom Quartz composition ##

-composition=<path>
    Loads the given Quartz composition.
    Substitute <path> either with a path or an URL to the Quartz composition.

-arguments={key:value,key:value,...}
    If set a collection of key:value pairs separated by ',' surrounded by '{ }' containing the arguments that should be passed to the custom Quartz composition is expected.

## Showing media file(s) ##

-image={path:<path>,<optionalParameter>:<optinalValue>,...}
    Displays an image. Most common image file formats are supported: JPEG, TIFF, PNG, GIF, BMP, TGA, OpenEXR, JPEG 2000, PDF...
    Substitute <path> with a path or URL to the file's location. (required)
    Optional parameters are:
        width:<value>
            Substitute <value> with an integer value > 0 or "auto" if you want the width to adjust to height and keep aspect ratio.
            Substitute <value> with "full" if you want to use the full window width. (default: width:auto)
        height:<value>
            Substitute <value> with an integer value > 0 or "auto" if you want the height to adjust to width and keep aspect ratio. (default: height:auto)
            Substitute <value> with "full" if you want to use the full window height. (default: height:auto)
        Beware: If both width:value> and height:<value> are set to "auto" aspect ratio will be kept by scaling the image to fit the window in both dimensions.
                If both width:<value> and height:<value> are set to "full" aspect ratio will be lost by scaling the image to fit the entire window.
        
-video={path:<path>,<optionalParameter>:<optionalValue>,...}
    Displays a movie file. The video has to be a QuickTime movie in MOV format.
    Substitute <path> with a path or URL to the file's location. (required)
    Optional parameters are:
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
            
-presentation={path:<path>,optionalParameter:<optionalValue>,...}
    Displays a presentation of the images located at the given path. The presentation will try to show as much of the images as possible without changing the aspect ratio.
    Most common image file formats are supported: JPEG, TIFF, PNG, GIF, BMP, TGA, OpenEXR, JPEG 2000, PDF...
    Substitute <path> with a path or URL to the files' location. (required)
    Optional parameters are:
        duration:<value>
            Substitute <value> with a decimal number which represents the seconds each image of your presentation should be displayed. (default: 3.0)
        loops:<value>
            Substitute <value> with an integer which represents the number of loops the whole presentation should be shown. Settings this to 0 will loop the presentation until the application quits.
        control:<value>
            Substitute <value> with "manual" if you want to manually control the presentation. This will allow you to show next and previous slides. (default: "auto")
            Show next slide with: left mouse button, space key, return key, arrow right key or arrow down key.
            Show previous slide with: right mouse button, backspace key, arrow left key or arrow up key.
            There is also an OSC receiver listing on port 60000 waiting for "/presentation/next/1" resp. "/presentation/prev/1" messages to control the presentation.
            BEWARE: Switching to manual controls will ignore your settings for duration:<value> and loops:<value>.

-website={url:<url>}
    Display a website with the given URL. The website will resize according to the window size.
    Substitute <url> with a URL to the website you want to display. (required)
            
### Examples ###

"/Users/inka/Development/quartz-composition-player/Binary/QuartzCompositionPlayer_10.7_10.8_10.9_x86_x64.app/Contents/MacOS/QuartzCompositionPlayer" -windows-size=1280,1024 -window-origin=200,200 -image={path:/Users/inka/Development/Images/Image.png,width:full,height:100}
    
    The command will start the application loading the image located at "/Users/inka/Development/Images/Image.png" with the same width of the application window and a height of 100 pixels. The application window has a size of 1280x1024 pixels and will origin at 200x200.

"/Users/inka/Development/quartz-composition-player/Binary/QuartzCompositionPlayer_10.7_10.8_10.9_x86_x64.app/Contents/MacOS/QuartzCompositionPlayer" -windows-size=800,600 -window-origin=100,100 -video={path:/Users/inka/Development/Videos/Video.mov,width:full,height:full,loops:10,start:10,duration:25,rate:-1.0}

    The command will start the application loading the video located at "/Users/inka/Development/Videos/Video.mov" with the same width and height of the application window. The application window has a size of 800x600 pixels and will origin at 100x100. The application will play the video backwards 10 times, starting at 35 and ending at 10 seconds.

"/Users/inka/Development/quartz-composition-player/Binary/QuartzCompositionPlayer_10.7_10.8_10.9_x86_x64.app/Contents/MacOS/QuartzCompositionPlayer" -presentation={path:"/Users/inka/Documents/Bilder",duration:2.0,loops:2}

    The command will start the application loading all images inside the path "/Users/inka/Documents/Bilder", showing each image for "2.0" seconds and showing the whole presentation "2" times.

"/Users/inka/Development/quartz-composition-player/Binary/QuartzCompositionPlayer_10.7_10.8_10.9_x86_x64.app/Contents/MacOS/QuartzCompositionPlayer" -url={url:http://www.apple.com}

    The command will start the application loading the website behind the web address "http://www.apple.com".