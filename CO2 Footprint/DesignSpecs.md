#CO2 Footprint Design Specifications

##Overall design
* Model, View, Controller design
* Group of Model classes
* View Controller subclasses
* Default UIView, UITableView, etc. implementations

##Data storage
* Every model class complies to NSCoding
* FootprintBrain is main model object
    * Stores list of Activity objects

##Footprint calculation
* FootprintBrain responds to *-(double)footprint*, which returns a number in tons of carbon per day
* FootprintBrain stores an array of Activity objects, sorted by their individual footprints
    * footprint is calculated as a sum of the footprints of each activity
* Each Activity has a type which defines the way it is edited (editing can change everything but type)
* Even if units are changed, all values *stored* will be in some combination of weeks, gallons, miles, etc.
    * From these units I would convert to the input/output units.