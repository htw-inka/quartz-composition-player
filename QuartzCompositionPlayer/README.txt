The following commands can be used via command line arguments:

-window-size=X,Y
When set followed by two numbers separated by ',' the application will start with the give size.
(Default: 300,100)

-window-origin=X,Y
When set followed by two numbers separated by ',' the application will start at the given position.
(Default: 0,0)

-composition=<path>
When set followed by a path the given composition will be loaded.

-help
Shows this page (help).

The following commands do only apply if you pass a custom Quartz Composition via command line argument:

-arguments={key:value,key:value,...}
When set a collection of key:value pairs separated by ',' surrounded by '{ }' containing the arguments that should be passed to the custom quartz composition is expected.