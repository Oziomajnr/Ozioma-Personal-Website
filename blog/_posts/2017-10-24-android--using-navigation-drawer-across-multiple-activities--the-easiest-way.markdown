---
layout:	post
title:	"Android, Using Navigation Drawer Across Multiple Activities: The easiest way."
date:	2017-10-24
---

The Navigation Drawer is a very important component in an android application as it allows users to easily navigate
 to different parts of your application without having to go through some set of Activities and fragments.
  We often need to have our navigation drawer in many activities and it would be painful if we have to repeat 
  the code for creating the drawer in different activities, that would also go against the **DRY** principle.

One way of solving this problem is to create a Base Activity that would have the Navigation Drawer 
and all other activities that needs to have the Navigation Drawer would inherit from that Activity.

In this tutorial I would show you an easier way of solving this problem using the library 
[MATERIAL DESIGN DRAWER](https://github.com/mikepenz/MaterialDrawer) by [Mike Penz](https://github.com/mikepenz). 
The material design drawer library helps us create navigation drawer easily by calling a set of methods 
in your activities. We would extend this to multiple activities.

To begin, we first need to install the Material design drawer using gradle, so in your app level build.gradle 
file, add the following dependency excluding the android support library and sync.

Now we can use drawer methods to add it to an activity but to allow the drawer extend to other activities, 
we create a Utility class for initializing the drawer and adding it to an activity.

So let’s create a class called DrawerUtil.java

the drawer util class has one static method getDrawer, this method takes in two arguments, 
the first one is the activity that you want to create the drawer for and the second one is the tool bar of 
that activity, so that the toggle icon or the home icon can be appropriately displayed.

The drawer is created using a builder pattern, initializing necessary parameters, the primary and 
secondary drawer items are initialized with their text, icons and identifiers.

When the drawer items are clicked, the onItemClicked listener is called and the items are identified based on
their identifiers specified when creating them, the code sample tracks when the drawer item that has the 
identifier 2, and then starts the main activity if it is not already open.

Next we have to add this drawer to any activity that requires it, all the have to do is to call the static
 method getDrawer() from the onCreate method and pass in the activity and tool bar as arguments,
  just easy like that and the drawer would be added to our activity. here is a sample

Note: The code sample uses Butterknife for view binding.

So from the code sample above, w have added the Navigation drawer to our Main activity by simply calling

DrawerUtil.getDrawer(this,toolBar);

You can check out the [MATERIAL DESIGN DRAWER](https://github.com/mikepenz/MaterialDrawer) 
library for examples on how to use the drawer library for other features.
