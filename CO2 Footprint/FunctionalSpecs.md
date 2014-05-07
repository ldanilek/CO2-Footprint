#CO2 Footprint Functional Specs

##Overall User Interface
* Universal iOS App
* Portrait only
* Table on opening page
    * Carbon footprint, with link to carbon footprint output
    * Add new activity, with link to create an activity
    * List of already inputted activities
* Settings button in navigation controller leads to settings page
* On settings page, change units of time, volume, distance, etc.
* Activities are stored between app launches
* Activities will be represented as average usage for one week

##Activities Input
* New activities can be created
    * A choice of activity types is available, with accompanying graphics
    * Activity types include:
        * Transportation
        * Hygiene
        * Working
        * Surviving
    * Activities will also include appliances the user is responsible for, even if s/he doesn't actively use them
        * For example, user is responsible for refrigerator, heating, and lighting
* Existing activities (including newly created ones) can be edited, changing activities within their type
    * Title
    * Subtype
        * Multiple choice, through picker or popover
        * For example, transportation would have subtypes of Airplane, Car, Truck, Bus, etc.
    * Specific brand and model of machine/appliance used. This will be a simple text field
    * Number of people doing the activity with the user
        * For example, a car ride will have a smaller footprint if multiple people share a car
    * Efficiency of machine/appliance used
        * For transportation, input miles per gallon of vehicle
        * If no input, efficiency will be estimated
    * Average usage per week
        * For transportation, this would be the distance travelled
        * For most other activities, this would be the time spent doing the activity

##Carbon Footprint Output
* Big bold label showing the tons of CO2 emitted by the inputted activities per week
* Small labels for extrapolations:
    * Label saying how much CO2 that would be over one year and ten years
    * Label saying how much CO2 that would be if every human did the same activities
    * Label saying how soon the oil reserves would be used up if everyone acted the same
* Explanation of how CO2 acts as a greenhouse gas
    * Button to a graph showing expected global temperature impact over time
    * List of probable consequences of climate change

##Lifestyle Change Suggestions
* Table of changes, with short descriptions and graphics representing the activities they would modify
* Can be sorted according to impact or cost
*