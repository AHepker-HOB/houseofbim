---
layout: post
title: 2019 Autocad - R.I.P. FBXIMPORT
date: 2018-09-07 00:38
author: Josh Howard
comments: true
categories: [.NET]
tags: [3dsMax, AutoCAD, FBX]
---
Sorry to go fairly dark for a while, but  I think Andy said it best. “Being asked to accomplish seemingly impossible goals on a regular basis is just what we do, but these days it feels more like trying to rewrite the first 3 laws of physics”.  I am sure that isn't an exact quote, but work has been so busy that it feels more accurate to me every day.

Anyway, enough excuses and on to the topic.

The 2019 release of AutoCAD seems like a nice stable release on the surface, but as you go about your daily routines you will quickly find a disappointing void in this version. For some odd reason, Autodesk decided that we didn't need the ability to import the FBX file formats into AutoCAD anymore. Yes they actually removed the FBXIMPORT command! Consider me very confused because FBX exporting from Navisworks has been a true blessing, it's literally crucial in the AR/VR markets and it has generally seemed like a growing influence within the industry. So, I am somewhat expecting the outcry to be large and loud on their decision to remove it. Enough that it may very well be put back in through a service pack and even more likely that it will return for the 2020 release.  In the meantime, I did find my own work around through 3D Studio Max.

Upon researching our options, we generally found that there was a surprisingly small number of software's that could read an FBX and export to some other format that AutoCAD could read. If you are an AEC collection user like my company is, then you can go install 3DS Max and use the provided executable to puppeteer the 3DSMaxBatch console utility to do your conversions to DWG. My solution of dynamically writing MaxScript is kind of ugly, but it is significantly faster than  opening 3DSMax and it was the clear path of least resistance vs digging into the Autodesk C++ FBX API. Side note to Autodesk, please stop making all your cool standalone API toys C++ exclusives. Lets face it, C++ might be powerful, but we all know its a hateful blizzard of dreadfulness that discourages rapid adoption.

# Warning
I wouldn't suggest targeting a large number of files with this utility. It will create a console window for each one of them and a substantial number of them will inevitably cause the consoles to trip all over themselves. My test involving 200 files resulted in me having to reboot my computer. My tests with a dozen or less files seem to work just fine, but you may want to limit your selection further depending on the size of the files your converting.

## Edit: Additional Warning
The 3DS console doesn't like FBX files on servers. Make sure you are storing the FBX files you want to convert in a folder on your desktop or somewhere other than your networked server.

# Download
[Click Here](/assets/dotnet/HOB.FBXConverter.zip) to download the Code & Executable  
**Note:** The exe is located in that zip file folder structure here: \HOB.FBXConverter\bin\Debug\

# Homework
As always, I like to provide ideas for like minded people to work towards. So, I would like to propose you combine this concept with Navisworks (like I did) and build yourself a 1 button click FBX export/Convert to DWG utility. I am quite certain my previous Navisworks blog posts gave you the tools to figure out how I am accomplishing this. By taking this approach, I was able to eliminate the possibility of collecting a group of FBX's and feeding too many into this provided utility and make it just a little faster by skipping a step.