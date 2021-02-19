---
layout: post
title: "Update & My C# Roadmap"
date: 2016-12-31 06:09
author: Josh Howard
comments: true
categories: [.NET]
---
It has admittedly been a little quiet around here, but we have been very busy and switched gears multiple times.

We got our internal buyoff and now waiting on the 3rd party budget approval for an extensive (6 month) BIM VR workflow research project; this looks like it's a go. Skylar is getting ready to release his first Autodesk App Store offering and you will be seeing a post about that soon. Andy has been pretty bogged down developing new SOP's and setting up a slew of new projects. While I have literally been bouncing around and dabbling in various API's and trying to migrate onto C# as my primary language.

With that said I have a nice DLL gift for Plant 3D users out there that will be in a future blog post. It will basically let you use lisp to request the common string properties, connector locations and connector vectors from P3D parts. I needed this to make a P3D -> Autodesk Fabrication converter. I don't plan on providing that conversion tool, but I have been a starving lisper suffering Plant 3D in the past and know how much good this plugin could do in the right hands.

Anyway, the other thing I wanted to detail in this post is my C# roadmap in case anyone else is interested in going down that path. Please note that I have been a long time VB.Net user and my experience was probably a lot easier than yours would be if you're starting from scratch. However, I found all of the following sources to be very useful and I would generally recommend they be utilized in the order they are presented here:

&nbsp;
**The Experienced Beginner's Guide to Visual Studio** - Bob Tabor  
[https://courses.devu.com/courses/visual-studio](https://courses.devu.com/courses/visual-studio)  
This first one is entirely optional and probably isn't actually worth the money ($20) if you have any prior Visual Studio experience, but I did learn a few things from it even having spent years (off and on) working in visual studio myself. I can't stress enough how important it is to know the IDE your using. That is VLIDE or VS…. You will always be substantially more effective the better you know your work environment!

&nbsp;
**C# Fundamentals for Absolute Beginners** - Bob Tabor  
[https://mva.microsoft.com/en-US/training-courses/c-fundamentals-for-absolute-beginners-16169](https://mva.microsoft.com/en-US/training-courses/c-fundamentals-for-absolute-beginners-16169)  
There seemed to be a couple of videos that didn't play, but Bob is a prolific video blogger and you can easily find topic equivalent videos on YouTube for those broken lessons. This was honestly a fantastic launch pad for me because I already had quite a bit of experience with .Net. I was practically ready to hit the ground running after this, but if your starting from scratch I'd advise you go through this multiple times and then move onto the intermediate C# courses on MVA.

An alternative to that free MVA course would be the comprehensive one directly on Bob's DevU store. It is only $50 and offers 30 hours of training. Based on the course outline it would definitively be a far superior introduction to C# than MVA will ever offer. The only reason I didn't consider it was a complete unwillingness to know anything at all about ASP.Net; I think I am allergic ;)  
[https://courses.devu.com/courses/cs-fundamentals-via-asp-net-web-applications](https://courses.devu.com/courses/cs-fundamentals-via-asp-net-web-applications)

&nbsp;
**A Guide to Object-Oriented Practices** - Bill Wagner and James Sturtevant  
[https://mva.microsoft.com/en-US/training-courses/a-guide-to-objectoriented-practices-14329](https://mva.microsoft.com/en-US/training-courses/a-guide-to-objectoriented-practices-14329)  
I am actually going through the OOP one now and can't currently tell you much about the quality of the lesson, but I can tell you that understanding OOP is critical. I skipped over this in my studies simply because I already had a bunch of background on these concepts and just decided to get a refresher; it does belong in this slot regarding sequence for those just getting started.

&nbsp;
**Advanced C#** - Derek Jensen  
[https://code.tutsplus.com/courses/advanced-c](https://code.tutsplus.com/courses/advanced-c)  
This course is $9 on the TutsPlus website and I truly believe it is worth it. This might have been my headspace or otherwise unrelated, but I found myself coming up with quite a few great ideas and connecting some architectural concepts while I was going through this. I've considered watching this a second time in hopes of more brainstorms. Anyway, I encourage you to support these guys, but I will also tell you that the entire series has been known to grace YouTube as well.

&nbsp;
**Application Architecture Fundamentals** - Bob Tabor  
[https://courses.devu.com/courses/application-architecture-fundamentals](https://courses.devu.com/courses/application-architecture-fundamentals)  
This video session hardly even needs to be videos because it is largely a philosophical dialog of various concepts. My opinion is that you can't listen to this series enough until all of it starts making some degree of sense and you start seeing how to apply the concepts yourself. The cost of this video is $30, but researching topics covered in this series will turn into a life style change and probably still wind up costing you money anyway. I am speaking from the experience of suffering when I say that if you learn to think (and apply) of your programs the way Bob describes here, then it will save you so much suffering!!

&nbsp;
**Windows Presentation Foundation 4.5 Cookbook** - Pavel Yosifovich  
[https://www.amazon.com/Windows-Presentation-Foundation-4-5-Cookbook-ebook/dp/B008W1A39C/ref=asap_bc?ie=UTF8](https://www.amazon.com/Windows-Presentation-Foundation-4-5-Cookbook-ebook/dp/B008W1A39C/ref=asap_bc?ie=UTF8)  
This is a book that I would mostly say is about WPF from the interface side. It isn't strictly XAML, but it does have lot of that type of content. There are some XAML related things on MVA, but honestly it is just one of those topics that a book will do a lot more justice. I had previous Windows Forms & WPF controls experience prior to reading this and I think that is probably the type of person who should read this book. It is very well put together, easy to read, not boring, but probably geared towards people who have at least played with WPF a little bit on their own first. I should be done reading it by now considering I read half of it the first day I got it, but despite having some initial context I find myself going back to re-read various areas of the book trying to find the same level of comfort I had in the beginning; XAML is a beast! Note: if you are trying to figure out whether to go Windows Forms or WPF there is only 1 answer; go WPF. While I would issue a disclaimer that WPF can be like fighting an angry bear, the previously difficult things are made very simple and previously easy things in Forms are now nearly impossible. The fact of the matter is that you will be hurting development greatly if you choose to think/do in Windows Forms ways instead of WPF. Windows forms is indeed the path of least resistance, but it is also Dead End Street. I swear that WPF is insanely cool, but the learning curve will be steep.

&nbsp;
**If you also want to dive into the Plant 3D API**, here are a few links to get you started:  
[http://adndevblog.typepad.com/autocad/plant3d/](http://adndevblog.typepad.com/autocad/plant3d/)  
[http://help.autodesk.com/view/OARX/2021/ENU/](http://help.autodesk.com/view/OARX/2021/ENU/)  

&nbsp;
Some other reading I would highly recommend, but it is much more general:

**Effective Programming: More Than Writing Code** - Jeff Atwood  
[https://www.hyperink.com/Effective-Programming-More-Than-Writing-Code-b1559](https://www.hyperink.com/Effective-Programming-More-Than-Writing-Code-b1559)  
I'll be honest, I bought this book because the first chapter was called **"The Art of Getting Shit Done"**, but it is honestly just a generic fantastic read of micro topics; just plain enjoyable…. He has a second book (also based on his blog) that was also very good. Side note: Jeff and this book is actually the reason why I decided to start blogging in the first place.
