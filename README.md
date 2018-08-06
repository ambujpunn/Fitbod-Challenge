# Fitbod-Challenge

## Architecture/Design Pattern
This application is using the MVVM design pattern to render views using view models responsible for holding the state of those views. This helps with not running into the MVC ("Massive View Controller") problem as the view controller and the view have less responsbility taking advantage of the seperation of concern principle. Dependency injections are used to ensure an entity is given the correct input during the creation. This is evident in the creation of the Singleton WorkoutData class. Since the data being displayed is coming from one source of truth (the data file), it made sense to treat the WorkoutData class as a Singleton ensuring more than 1 is not created (we don't want to read more than 1 file at a time). We use a failable initializer to fail immediately if the given file is not found in the project. Extensions are used to separate out logic when conforming to protocols to ensure a Swifty environment. Since this is a simple layout with 2 pages, all of the UI design is done using the main storyboard. A reusable xib for the exercise table view cell is used in the storyboard for the 2 places it appears. 

## UI
Auto Layout is used to ensure that all the views are situated in the correct manner for all devices. Alerts and loading indicators are used whenever the user needs to be told of something. 

## Pods used
Three pods are used extensively in this project:
    1. CSVImporter - I chose this pod because it was one of the only ones that imported line by line of a CSV file rather than creating a massive String object and then parsing it. This ensures that there will be no memory issues as we are getting a line by line mapped object through Swifty closure callbacks. We make sure to run the actual importing task on the .utility background global queue whereas the closure callbacks are ran on the .userInteractive background global queue. Once the results come in, we delegate to the OneRepMaxViewController which renders the data into the table views on the main queue. 
    2. Charts - I chose this pod due to the immense popularity it has on Github. It is very widely used as it is the iOS clone of the very popular Android version. Charts allowed me to display the historical values of the data on both axis. With a good amount of customization, I was able to get it close as possible to the mocks. 
    3. NVActivityIndicatorView - I chose this pod for the customization it provided for indicators. I really liked how the protocol included can be conformed by a View Controller and transform the View Controller to be of that type to allow UI blocking. I used this initially when the import starts. It is useful in the case where an import of a huge file is happening showing the number of lines we've imported so far. 
        
## One Rep Max Brzycki Formula
Instead of using the approximation calculation method, I used the exact calculation method: (w * (36 / (37 - r))). The max rep calculations are all done in Floating point integers and are stored in Floats as well. However, I chose to display the one max rep as Integers (Floats are truncated) in the app to allow for a more appealing experience. 
