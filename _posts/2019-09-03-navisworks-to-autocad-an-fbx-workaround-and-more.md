---
layout: post
title: Navisworks to AutoCAD - an FBX Workaround and More
date: 2019-09-03 19:03
author: Skylar Daniels
comments: true
categories: [AutoCAD, Navisworks]
tags: [App, FBX, plugin]
---

For anyone who uses AutoCAD (with or without one of its verticals) to create models on a BIM job, chances are high that you are also using Navisworks simultaneously to coordinate the 3D space with other trades. Chances are also just as high that you have needed to reference this Coordination model in AutoCAD in order to clear clashes, connect to points of use, utilize a shared hanger, or other various tasks that take place during the natural progression of a BIM job. The way we reference the Coordination model could be using the Cartesian coordinates (X, Y, Z) from the measure tools, Transforming an object to clear a clash and noting the (X, Y, Z) transform, or possibly exporting the geometry as an FBX and then importing it into AutoCAD (Functionality now removed from AutoCAD 2019). There is a Navisworks tool that can make referencing the coordination model in these three ways much faster and simpler.


# Navis to Acad
The [Navis to Acad][Navis to Acad] app gives the user the ability to reference a Navisworks Model in AutoCAD in real time. With the Points->Acad function, a user can instantly reference points taken with the Navisworks Measure tool in AutoCAD.


<iframe width="560" height="315" src="https://www.youtube.com/embed/xVfhLYr5jpI" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


# Transform->Acad
The Transform->Acad allows the user to reference the applied transformation of any number of selected objects in multiple open AutoCAD documents.

<iframe width="560" height="315" src="https://www.youtube.com/embed/RjHudME4oMI" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


# Mesh->Acad
Lastly, it is fairly well known that since the AutoCAD 2019 release, the ability to import FBX's was removed. This disrupted a lot of people's workflows. Fortunately, the Mesh->Acad feature in the [Navis to Acad][Navis to Acad] app allows the user to bring geometry directly from Navisworks into AutoCAD in real time as a block. It also has the ability to write the Navisworks object properties as block attributes depending on the users settings. It is worth noting that it is not optimized for very large exports (either a lot of objects or complicated geometry). There are plans to add the ability to export a file out of Navisworks to disc, then import into AutoCAD in a future release which should hopefully make it more efficient for very large imports.


<iframe width="560" height="315" src="https://www.youtube.com/embed/0E4iFO9F_xw" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


If you are using AutoCAD alongside Navisworks 2019 or later, The [Navis to Acad][Navis to Acad] app could help your workflow. A free 30-day trial is available from the [Autodesk App Store][Navis to Acad].

[Navis to Acad]: https://apps.autodesk.com/NAVIS/en/Detail/Index?id=7769760428595824963&appLang=en&os=Win64