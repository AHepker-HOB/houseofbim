---
layout: post
title: Autocad PDF Binder Utility
date: 2018-01-12 08:38
author: homeofbim
comments: true
categories: [.NET, PDF, AutoCAD]
tags: [AutoCAD .NET Lisp Function, Lisp, PDF API, PDF Binder, PDF SDK]
---
Hello again, as you know I have been playing with PDF API's quite a bit lately and came upon a situation where I needed to make a ton of small PDF binders. I was able to grab and organize all of the files into individual folders using lisp quite efficiently, but ultimately I didn't have a good way to automate the creation of those PDF binders. I unfortunately had a junior designer process them folder by folder for me.

However, this experience got me thinking there could be more applications for a lisp version of a PDF binder. In our department, it is not uncommon for projects without a specified line numbering to have spool names based on the rack name. With that level of association in the filename, it would then become very easy to programmatically create a single PDF “package” of all the fabrication information relevant to any given rack section. We also already have the ability to find all the pdf's for a given selection, so now we could augment that utility with actually creating binder of the spool drawings within a given selection. This could be very useful if the superintendent says to you “I'm putting a crew between column X and column Y on Thursday and I need all the drawings for that area”.

In my case I was packaging “like” support details for our SharePoint document library. From there the unique 4 character detail “prefix” served as a great hyperlink target and an excellent way for the fabricators to quickly pull up the detailed fabrication info for the specified hanger they were trying to pre-fab.

Bottom line, yes just about all of us have the software to build binders through an interface, but when you need to build a lot of them, then there really isn't a standard product on the market to accomplish this... Which is where the HOB-PDF-Binder lisp function will make your life a lot easier.

# HOB-PDF-Binder Overview
This function creates a new PDF from a list of existing PDF's. You will need to run the NETLOAD command and target the DLL supplied in the links at the end of the post. This plugin shouldn't have the ability to crash AutoCAD and a fair amount of error checking built in, but generally you should take some care when asking it to do something. I just put in a support ticket with Xfinium about a layer issue. At this time the merged PDF that contains largely the same layer content will be very ugly; it is currently creating a new layer without checking/utilizing existing layers. I'll update this post when that issue has been resolved.

### HOB-PDF-Binder: Syntax
(hob-pdf-binder String (list Strings))

### HOB-PDF-Binder: Arguments
*String*
This will be the full path of the new PDF you are wanting to create. Note that if the file already exists at the time of execution it will be deleted.

*String(s)*
You can supply this function a list of string or just additional string arguments representing the PDF's you wish to have merged together. Both circumstances are entirely valid uses of this function. Also note that the order in which the strings appear will determine the order in which the final PDF binder pages will be organized. So, you may want to consider this while assembling your file list.

### HOB-PDF-Binder: Return Values
This function will always return T or Nil. However, in the event any single file was unable to be processed, then the result will still be T, but a message specifying the filename will be printed to the command line. If the return is T, then a file should have been created. If the return is Nil, then no valid file should have been created.

### HOB-PDF-Binder: Examples
Assuming pdf's 1,2 and 3 exist, then both of these situations will have identical results.

```lisp
(hob-pdf-binder "C:\\temp\\4.pdf" (list "C:\\temp\\1.pdf" "C:\\temp\\2.pdf" "C:\\temp\\3.pdf"))
T
(hob-pdf-binder "C:\\temp\\4.pdf" "C:\\temp\\1.pdf" "C:\\temp\\2.pdf" "C:\\temp\\3.pdf")
T
```

***Note:*** If the file 2.pdf did not exist then it would have returned Nil for both.

# Downloads:
[Click Here](/assets/dotnet/HOB_P3DLispSupport_Project.zip) to download the code; note that this does not contain any Xfinium DLL's and you will have to provide your own.  
[Click Here](/assets/dotnet/HOB.PDF.Binder.dll.zip) to download the fully functional compiled DLL that just needs to be loaded into AutoCAD. It has no Xfinium watermarks on the output.

# Thoughts:
Well, that is about it for this small post, but I will say this… AutoCAD super powers are clearly a passion of mine and it is little things like this that keep pushing the boundaries of what I can get out of it. While this was created with C#, AutoCAD's Lisp integration is still a better rapid development platform for tasks that aren't overly convoluted. With that said, I hope someone finds this new power useful and stay tuned because I am considering expanding on my AutoCAD PDF powers from lisp in the future.
