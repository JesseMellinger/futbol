# Futbol
Welcome to our Futbol Project!

Our design strategy consists of a `StatTracker` class serving at the top tier to grab statistical results from lower level classes. Our `StatTracker` class has the sole responsbility of reaching into the right classes to grab requested statistical information.

On the next rung of our class hierarchy sits the `Manager` classes. There are three classes here, namely, `TeamManager`, `GameTeamManager`, and `GameManager`. These classes are each responsible for collecting and sorting data out of their respective CSV files. For example, `TeamManager` generates individual `Team` objects in an array and retrieves data based upon this collection.

At the individual object level there are three classes. The `Game`, `Team`, and `GameTeam` classes. By generating our collections at the `Manager` level with instances of these classes we are able to easily access row data by means of instance variables with reader methods. Also at this level are methods pertaining directly to these objects and are appropriate at this level as opposed to the `Manager` level where many instances of the same class are involved.

Also, two modules are used named `Groupable` and `Findable`. The first of which holds a method that groups data by row data passed into it as arguments. The logic of this method has been abstracted to allow for different data objects and row values to be passed in and grouped. The second module contains methods responsible for finding the necessary data within different collections.

Design Structure:

![Design Structure][logo]

[logo]: https://user-images.githubusercontent.com/56360157/93395257-ce373800-f832-11ea-8016-4a56e5e9af1f.jpeg "Design Structure"
