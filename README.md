# Traffic Collision Data in Seattle

The presentation deals with the dataset obtained from the Seattle Department of Transportation (SDOT). [link to source](https://data.seattle.gov/Transportation/SDOT-Collisions/v7k9-7dn4/data) This dataset consists of annual traffic report on the locations and attributes of collisions that occur within Seattle.

For our presentation, we will be focusing on different neighborhoods in Seattle. We will compare the frequency of accidents in each neighborhood (Ballard, Phinney Ridge, Fremont, Greenwood, University District, Green Lake, Northgate, Magnolia, Queen Anne, Capitol Hill).

The primary feature of the application is a leaflet map containing data points with information on collisions, such as the location, description, and number of injuries. The first layer of the map contains an overview with a circle representing each neighborhood. The size of the circle corresponds to the number of collisions. Clicking on a circle zoom the map in and view the collisions that occurred in the clicked neighborhood. The number of collisions are dependent on the factors that the user decides to filter the collisions by.

The second feature is a stacked bar graph with a summarized view of the collision data. The graph would show the relationship between the number of collisions and the severity of the collisions as well as a specific condition the user can choose using the widget.
