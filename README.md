# Quartz Composition Player (Universal Media Player)
This project features a Cocoa application for OS X that is on the one hand a generalized media player that uses and internal Quartz Composition to display videos, images and other media types and on the other hand can visualize any custom Quartz Composition.

The application is command line based, so at this point there is no GUI available. Possibly in later versions of this software a GUI will be implemented.

## Installation
Either download the pre-compiled OS X App bundle out of the "Binary" directory or clone/download the source-code inside the "Source" directory and to compile yourself. The pre-compiled binary is running on OS X 10.7, 10.8 and 10.9 (and presumably on 10.10). Copy your App bundle anywhere you want  and you're set to go - now further sonftware needed.

## Usage
Start the application by calling the binary inside the App bundle with `/path/to/app/bundle/Contents/Mac OS/QuartzCompositionPlayer`. By default this will only open a black window with the size of 300x100 pixels. To alter the content of the application use the following command line arguments:

### Help ###
argument  | `-help`
:-------- | :------
          | Shows the help page ignoring all other arguments.

### General application settings ###
argument            | `-window-size=W,H`
:---------          | :---------
                    | Substitute `W` and `H` with one integer each and the application will start with the give size. `windows-size=LED-Grid` will automatically set the size to the LED grid size. `window-size=LED-Complete`will automatically size the application to the LED grid plus spot lights.
default             | `-window-size=300,100`
              
argument            | `-window-origin=X,Y`
:---------          | :---------
                    | Substitute `X` and `Y` with one integer each and the application will start at the given position. `window-origin=LED-Grid` will automatically move the application to the LED grid position. `window-origin=LED-Complete` will automatically move the application to the LED grid plus spot lights position. **Beware:** Since Cocoa has a different coordinate system than most other programming frameworks 0,0 won't be in the upper-left corner but in the bottom-left corner.
default             | `-window-origin=0,0`           

### Loading a custom Quartz composition ###
argument            | `-composition=<path>`
:---------          | :---------
                    | If set the given composition will be loaded. Substitute `<path>` with a path or URL to the Quartz composition.
                    
argument            | `-arguments={key:value,key:value,...}`
:---------          | :---------
                    | If set a collection of key:value pairs separated by ',' surrounded by '{ }' containing the arguments that should be passed to the custom quartz composition is expected.

### Showing an image or a video ###
argument            | `-image={path:<path>,<optionalParameter>:<optionalValue>,...}`
:---------          | :---------
                    | Displays an image. Most common image file formats are supported: JPEG, TIFF, PNG, GIF, BMP, TGA, OpenEXR, JPEG 2000, PDF... Substitute `<path>` with a path or URL to the file's location. (required)

optional parameter  | `width:<value>`
:---------          | :---------
                    | Substitute `<value>` with an integer value > 0 or use `auto` if you want the width to adjust to height and keep aspect ratio. Use `full` if you want to use the full window width.
default             | `width:auto`           
                        
optional parameter  | `height:<value>`
:---------          | :---------
                    | Substitute `<value>` with an integer value > 0 or use `auto` if you want the height to adjust to width and keep aspect ratio. Use `full` if you want to use the full window height. **Beware:** If both `width:<value>` and `height:<value>` are set to `auto` aspect ratio will be kept by scaling the image to fit the window in both dimensions. If both `width:<value>` and `height:<value>` are set to `full` aspect ratio will be lost by scaling the image to fit the entire window.
default             | `height:auto`                 
        
argument    | `-video={path:<path>,<optionalParameter>:<optionalValue>,...}`
:-------    | :--------
            | Displays a movie file. The video has to be a QuickTime movie in MOV format. Substitute `<path>` with a path or URL to the file's location. (required)

optional parameter  | `width:<value>`
:-----              | :-----
                    | Substitute `<value>` with an integer value > 0 or use `auto` if you want the width to adjust to height and keep aspect ratio. Use `full` if you want to use the full window width.
default             | `width:auto`             

optional parameter  | `height:<value>`
:---------          | :---------
                    | Substitute `<value>` with an integer value > 0 or use `auto` if you want the height to adjust to width and keep aspect ratio. Use `full` if you want to use the full window height. **Beware:** If both `width:<value>` and `height:<value>` are set to `auto` aspect ratio will be kept by scaling the image to fit the window in both dimensions. If both width and height are set to "full" aspect ratio will be lost by scaling the image to fit the entire window.
default             | `height:auto`
                    
optional parameter  | `loops:<value>`
:---------          | :---------
                    | Substitute `<value>` with an integer value > 0 to set how often the movie should be played. If not set or with an integer less or equal to 0 the movie will be looped as long as the application is running.
default             | `loops:0`                    
                    
optional parameter  | `rate:<value>`
:---------          | :---------
                    | Substitute `<value>` with a decimal number to set the playback speed of the video. `rate:0.0` meaning pause, `rate:1.0` meaning normal playback speed, `rate:-1.0` meaning reverse playback, `rate:2.0` meaning double playback speed. 
default                 | `rate:1.0`

optional parameter  | `start:<value>`
:---------          | :---------
                    | Substitute `<value>` with a positiv decimal number between zero and the duration of your movie to set the time stamp where the movie playback should start. Negative values will be ignored. If the value exeeds the total movie duration this value will be ignored. Set to "0" or don't set to start at the beginning of the video. 
default                 |`start:0.0`

optional parameter  | `duration:<value>`
:---------          | :---------
                    | Substitute `<value>` with a positiv decimal number bigger than zero to set the duration the movie should be played starting either at the time set via `start:<value>` command or at the beginning of the video. If you set this to "0.0" the value set for start will be ingnored and the whole video will be played. If the sum of the start time and the duration time exeed the movie duration this option will be ignored.
default             | `duration:0.0`

### Showing a presentation
argument    | `-presentation={path:<path>,optionalParameter:<optionalValue>,...}`
:-----      | :-----    
            | Shows a slide show of all images inside the given path in alphabetical order. Substitute `<path>` with the path to the directory where your slide images are located. (required)
            
optional parameter  | `duration:<value>` 
:-----              | :------
                    | Substitute `<value>` with the time in seconds each slide should be visible. 
default             | `duration:3.0`

optional parameter  | `loops:<value>`
:-----              | :-----
                    | Substitute `<value>` with a number that determines how often to go through the whole presentation.
default             | `loops:1`

optional parameter  | `control:<value>`
:-----              | :-----
                    | Substitue `<value>` with `manual` if you want to manually control the presentation. Show next slide with: `left mouse button`, `space key`, `return key`, `arrow right key` or `arrow down key`. Show previous slide with: `right mouse button`, `backspace key`, `arrow left key` or `arrow up key`. There is also an OSC receiver listing on port 60000 waiting for `/presentation/next/1` resp. `/presentation/prev/1` messages to control the presentation. **BEWARE:** Switching to manual controls will ignore your settings for `duration:<value>` and `loops:<value>`. 

### Loading a website
argument    |`-website={url:<url>}`
:------     | :------
            | Display a website with the given URL. The website will resize according to the window size. Substitute `<url>` with a URL to the website you want to display. (required)

### Examples ###
command line        | `"/Users/inka/Development/quartz-composition-player/Binary/QuartzCompositionPlayer_10.7_10.8_10.9_x86_x64.app/Contents/MacOS/QuartzCompositionPlayer" -windows-size=1280,1024 -window-origin=200,200 -image={path:/Users/inka/Development/Images/Image.png,width:full,height:100}`
:------             | :------
result              | The command will start the application loading the image located at "/Users/inka/Development/Images/Image.png" with the same width of the application window and a height of 100 pixels. The application window has a size of 1280x1024 pixels and will origin at 200x200.

command line        | `"/Users/inka/Development/quartz-composition-player/Binary/QuartzCompositionPlayer_10.7_10.8_10.9_x86_x64.app/Contents/MacOS/QuartzCompositionPlayer" -windows-size=800,600 -window-origin=100,100 -video={path:/Users/inka/Development/Videos/Video.mov,width:full,height:full,loops:10,start:10,duration:25,rate:-1.0}`
:------             | :------
result              | The command will start the application loading the video located at "/Users/inka/Development/Videos/Video.mov" with the same width and height of the application window. The application window has a size of 800x600 pixels and will origin at 100x100. The application will play the video backwards 10 times, starting at 35 and ending at 10 seconds.

commad line         | `"/Users/inka/Development/quartz-composition-player/Binary/QuartzCompositionPlayer_10.7_10.8_10.9_x86_x64.app/Contents/MacOS/QuartzCompositionPlayer" -presentation={path:"/Users/inka/Documents/Bilder",duration:2.0,loops:2}`
:-----              | :-----
result              | The command will start the application loading all images inside the path "/Users/inka/Documents/Bilder", showing each image for "2.0" seconds and showing the whole presentation "2" times.

command line        | `"/Users/inka/Development/quartz-composition-player/Binary/QuartzCompositionPlayer_10.7_10.8_10.9_x86_x64.app/Contents/MacOS/QuartzCompositionPlayer" -url={url:http://www.apple.com}`
:-----              | :-----
result              | The command will start the application loading the website behind the web address "http://www.apple.com".