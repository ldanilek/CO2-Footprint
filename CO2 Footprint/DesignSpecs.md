#CO2 Footprint Design Specifications

##Overall design
* Model, View, Controller design
* Group of Model classes
* View Controller subclasses
* Default UIView, UITableView, etc. implementations

##Data storage
* Every model class complies to NSCoding
* FootprintBrain is main model object
    * Stores inputs
* CFValue class stores a value with units like miles/gallon, which can be converted into other units of the same type like km/L

##Footprint calculation
* FootprintBrain responds to *-(double)footprint*, which returns a number in tons of carbon per day
* FootprintBrain stores information for all inputs and can calculate the footprint for each input category of Home, Transport, and Diet
* Each Activity has a type which defines the way it is edited (editing can change everything but type)
* Even if units are changed, all values *stored* will be in some combination of weeks, gallons, miles, etc.
    * From these units I would convert to the input/output units.