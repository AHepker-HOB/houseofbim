---
layout: post
title: Notepad++ UDL Highlighting for COD & DCL Languages
date: 2019-03-23 21:32
author: Josh Howard
comments: true
categories: [Notepad++, UDL]
tags: [AutoCAD, COD, DCL, Fabrication CADmep, Lisp]
---
# Dialog Control Language UDL
We had a DLL AutoCAD command that we lost the code to quite some time ago and wanted to “update” its functionality. We could have done this through lisp quite easily, but there was one complex dialog associated with it. I've always hated the Dialog Control Language in AutoCAD, but it certainly does work after a lot of tinkering. Prior to attempting to rebuild that dialog, I decided it was past due to make a worthy editor. Super glad I did because it made the process of recreating the dialog surprisingly easy. With that said I hope this Notepad++ User Defined Language XML helps some other people out there as much as it did me.

DCL is generally quite simplistic, but there are a couple of things you need to understand about why I highlighted a few things red. There are several tiles and properties that exist only for foundational building blocks and are documented as being illegal for public use. You can see examples of this if you go to your AutoCAD folder and find the “Base.DCL” file which defines a lot of the stuff we commonly use.  
<br />
[Click Here](/assets/misc/Dialog%20Control%20Language.xml) to download the DCL Notepad++ UDL XML. Redistribution of this XML is prohibited by anyone other than the House of BIM and notepad-plus-plus.org.
 
# CADmep COD Scripting UDL
After learning the ropes of the Notepad++ UDL system with DCL's, I quickly set my sights on something I've been wanting forever; A proper COD Highlighter! This undertaking was a lot more difficult than the DCL language and honestly would have been full of voids if not for all the content that Darren Young provided on [his website](https://www.darrenjyoung.com/) and AU classes. The Autodesk documentation is quite poor and I simply don't use (in my industry) a lot of the various properties (duct related) available in the COD language; thanks for the indirect help Darren. I was somewhat happy to see there was at least one things I knew about (and use) that even Darren didn't have documented though. Because of that, I will document that method here.
 
Item.UnCatalogue() will throw an erroneous dialog prompt, but it does in fact remove the product list from an item you've drawn. This is how “we” dynamically create trimmed tangents on BPE elbows for the tight spots in our BioPharm projects. Which is just another way that CADmep continues to be the best sandbox software out there. It even lets you do exceptional damage to accomplish otherwise impossible things!  

[Click Here](/assets/misc/CADmep%20Scripting.xml) to download the COD Notepad++ UDL XML. Redistribution of this XML is prohibited by anyone other than the House of BIM and notepad-plus-plus.org.
 
# Thoughts
I hope these will help all of you as much as they have been helping me. I do have the intent of creating one for PCF files next, but if you need that you'll have to reach out to me and see if I actually found the time to complete it. It may not be done for a while (that is a research project) though, I only found time for this blog post because I am on vacation and currently writing this post from the Maui airport. Also note that I am extremely red/green color blind. So, you may not find the colors to be ideal for you and may need to change them.
 
Finally, at the time of writing this blog post, Notepad++ 7.6.4 is the current release and it appears to have a bug that doesn't apply the specified font family upon importing the UDL XML files. I have opened up and meticulously verified the provided XML files to be correct, but they simply don't apply the Consolas font as intended on import. Nothing I can do about it, but I hope they get this bug fixed in future releases.