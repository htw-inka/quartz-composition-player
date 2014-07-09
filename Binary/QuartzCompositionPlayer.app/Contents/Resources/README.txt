The following commands can be used via command line arguments:

-help
    Shows this help page ignoring all other arguments.

General application settings:

-window-size=X,Y
    When set followed by two numbers separated by ',' the application will start with the give size.
    (Default: 300,100)

-window-origin=X,Y
    When set followed by two numbers separated by ',' the application will start at the given position.
    (Default: 0,0)

Loading a custom Quartz composition:

-composition=<path>
    When set followed by a path the given composition will be loaded.

-arguments={key:value,key:value,...}
    When set a collection of key:value pairs separated by ',' surrounded by '{ }' containing the arguments that should be passed to the custom quartz composition is expected.

Showing media file(s):

-image={path:<path>,<optionalParameter>:<optinalValue>,...}
    Displays an image. Most common image file formats are supported: JPEG, TIFF, PNG, GIF, BMP, TGA, OpenEXR, JPEG 2000, PDF...
    Substitude <path> with a path or URL to the file's location. (required)
        
-video={path:<path>,<optionalParameter>:<optinalValue>,...}
    Displays a video file. The video has to be a QuickTime Movie in MOV format.
    Substitude <path> with a path or URL to the file's location. (required)

-presentation={path:<path>,duration:<duration>,loop:<loop>,}
    Shows a slide show of all images inside the given path in alphabetical order.
    Substitute <path> with the path to the directory where your slide images are located. (required)
    Substitute <duration> with the time in seconds each slide should be visible. (optional, default: 3)
    Substitute <loop> with a number that determines how often to go through the whole presentation. (optional, default: 1)