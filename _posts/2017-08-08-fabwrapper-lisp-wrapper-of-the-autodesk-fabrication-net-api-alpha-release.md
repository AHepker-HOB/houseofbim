---
layout: post
title: FabWrapper - lisp wrapper of the Autodesk Fabrication .Net API - Alpha Release
date: 2017-08-08 15:47
author: Josh Howard
comments: true
categories: [.NET, Fabrication CADmep, Lisp]
tags: [Fabrication API, Wrapper]
---
# UPDATE!!!
**This post is the legacy code from 2017. For the latest code and write-up, please visit the updated post on [Josh's site](https://www.ifnullthen.com).**  
[https://www.ifnullthen.com/posts/FabWrapper/](https://www.ifnullthen.com/posts/FabWrapper/)

<br/>
<br/>
<br/>
<br/>
<br/>

## Legacy Post
Wrappers have always been something of a magical thing to me. It is the process of taking something programmatically impractical or just plain out of reach and making it more accessible. This would usually be a bullet proof and complete encapsulation of the thing being wrapped that hides anything they chose not to support. Well, that isn't what I did here, but I certainly did a decent job emulating the complete encapsulation of the largely incompatible typed Autodesk.Fabrication.API.Item namespace. If I did it correctly, then I would have many thousands of lines of code, but I cheated using ton of .Net reflection to get the most bang (functionality) for my buck (time) with less than 1000 lines of code.

In this post I will show you how to use some various lisp functions to puppeteer the Fabrication API namespaces. This will include handling properties/methods that require unique structures incompatible with lisp and this will be done by saving them to a .Net global variable cache. I will cover how to use those variables in the global cache, get data or set data and even execute methods on the Fabrication objects. Finally, there will be a code take away, but the nature of this doesn't really make it any more expandable than it already is. The only thing you could do to expand on this concept is to apply it to a different API or possibly better trap an error in the current method.

# Reflection:
The great thing about reflection is that it makes things self documenting; to a point anyway….  If you have an object, then you can ask that object for all of its available properties and methods. Through the use of the “dynamic” .Net data type, you can handle properties that contain lists in simple ways, get the value from one of its indices and use it or go back to querying the properties from its returned value if needed. I also provided a lisp function that makes attempts to set the values of a property, but it is important to note that it doesn't even check to see if it can be written to and just uses some error trapping in case your attempt causes a problem. Generally speaking, the Fabrication API isn't complete yet and you should always consult the API documentation to see if something can be set in the first place though. Also note that it is pretty clear that the API designers tend to create functions on the root of the ITEM namespace for doing a lot of the “set” work.
Other than data type conversion and error handling code, the bulk of this is based on introspection and reflection. Which basically means I am doing a lot of repetitive runtime information gathering in order to locate the desired properties and/or methods your requesting. It will attempt to operate on the property or method you requested without knowing if you provided the right data type, if its read-only or even if it exists for that matter. This is a horribly overhead intensive method. However, the .Net framework is a very fast architecture and this technique does dynamically unlock the API for us with zero version control issues. That's correct, this should theoretically work on all prior and all future versions of the Autodesk.Fabrication.API. So, I think the pro's outweigh the cons in my approach.

# Disclaimer & Important Insights:
This is a very loose and somewhat reckless wrapper around the Fabrication API, but a great deal of effort went into handling as many foreseeable stability issues possible and I consider to be generally complete. it should work just fine once you figure out what you can and cannot do with it. It is a fair bet that you will at some point encounter an AutoCAD fatal error as your trying to figure out what you can safely do. So, do not use any of this in production environment where precious work could be lost until you have fully tested everything and have weighed the risk to reward for yourself. Also note that the Fabrication API has a tendency to become unstable (return null values) the longer a drawing is open and/or if you are torturing the API with many thousands of calls. Finally, make sure you are clearing the global variable cache at the end of all your lisp routines to prevent easily avoidable fatal errors related to objects you partially left open for read/write by storing data there.

# Download:
The provided compiled DLL is based on AutoCAD/Fabrication 2018 and has been tested with 2017. Since the 2018 release of AutoCAD was kind of a big one from the binary perspective, I am speculating that this provided DLL should work on 2016 and probably all future versions of AutoCAD/Fabrication. Note that you will have to use the NETLOAD command to load it into AutoCAD.

<a href="https://files.secureserver.net/0sYbQxrp57dxZQ" target="_blank" rel="noopener">Click here to download the functional DLL.</a>

<a href="https://files.secureserver.net/0sj5aoyRugR8p6" target="_blank" rel="noopener">Build your own. Click here to download the source.</a>

# Available Functions:
I am just going to throw all the headers out there so you can see the various pieces and then I will break each one of them down with some minor examples later.

```lisp
(FabGetItemProp ENAME PathToProp [VariableName])
(FabSetItemProp ENAME PathToProp Value)
(FabInvokeItem ENAME PathToMethod ListOfArguments [VariableName])
(FabDumpItem ENAME PathToProp IntBitCode)
(FabVarCache VariableName [Value])
(FabClearCache)
```

# Referencing Cached Variables:
In all instances, you can set a global variable where you see <em>[VariableName]</em> using just about any string name. I think the only characters removed are these: (, [, ), ], $. Whenever you see <em>VariableName</em> without brackets or <em>ENAME</em>. You would have to specify the variable names prefixed with a $ character. This triggers my functions to go look for a value in the Cache to replace your string with. Because lisp cannot understand complex .Net objects, this is how we have to work with those data types. Basically the data never leaves .Net relevance and we use a unique pointer to a reference of that complex data object instead. Also note that paths and variable names are NOT case sensitive. If I capitalize them here it is only to increase the clarity.

# Concept of THIS:
You will see me use the keyword THIS throughout these examples. This is a C# concept that lets us know for sure that we are operating on our current class and not anything in our <em>using</em> reference statements. However, I will say that currently it is largely unnecessary except when using a method on the root of the ITEM namespace, but it is generally a good habit to get in and I believe it may take on more important context once the DB API portion of this is released. Note that it is necessary for that instance because the path would be an empty string; which would be considered an invalid path.
Generally speaking, the ENAME or Cached Variable should always be referred to in your <em>paths</em> as THIS. If you provide my functions a fabrication entity, the word THIS will always be the Autodesk.Fabrication.API.Item namespace. If you were to pluck the Connector Info object out of the ENAME and drop it in a Cached variable using (FabGetItemProp  (car(entsel)) “THIS.Connectors[1].Info” “temp”). When you provide the “$temp” variable name in place of an ENAME, the THIS now refers to the starting point of Autodesk.Fabrication.API.Item.Connectors[1].Info
I am hoping that a detailed look at each of these with some examples will make this all clear, but if it doesn't  you will likely find plenty of future postings with in depth and probably more practical examples in the future.

# FabGetItemProp Overview
This function is probably the heart of everything. We will use it to collect simple data as well as complex data structures from modeled CADmep objects. However, it can also be used to query information from absolutely any “object” you've stored in the Variable Cache. Additionally, this will be your primary tool for adding those complex data objects into the Var Cache so that they can later be <em>$referenced</em> in Methods.

### FabGetItemProp: Syntax

`(FabGetItemProp Ename String1 [String2])`

### FabGetItemProp: Arguments
***Ename*** = Fabrication object  
This will usually be a fabrication objects entity name which you would get with EntSel or SSname. However, you can provide a $variable name string instead to operate on a data structure reference you've stored.

***String1*** = Path to Property  
This will be the .Net Api path reference to the property you are trying to read. The primary intent of this function is that your starting from the ITEM object (your EName) and digging down into its properties to locate the information you seek. You will always represent you base object whether provided by Cached variable string name or a valid CADmep Ename as THIS and . . . your way through its namespaces just as you would in .Net.

***String2*** = Optional Variable Name  
This is an optional Variable name. In a declaration scenario such as this, it is not necessary to prefix with a $ symbol. If provided (and valid) the returned value from FabGetItemProp will additionally be saved in the Variable Cache for future use. Since lisp cannot natively understand the complex data object structures of .Net, this is the only way you can collect valid information for methods that require these complex data structures as arguments.

### FabGetItemProp: Return Values
This function should theoretically reduce any value obtained from the API into one of the following base data types: a String, Integer, Decimal, Point, True or Nil. The result you get will be based on the (THIS) object your trying to do work with and what you are requesting of that object. Please consult the FabricationAPI.chm file found in the SDK folder of your Fabrication installation for expected data type documentation.

### FabGetItemProp: Examples
`(FabGetItemProp (car(entsel)) “This.Connectors[1].Info” “MyVar”)`  
Returns: ”<em>Autodesk.Fabrication.DB.ConnectorInfo</em>” string and stored the complex object in the MyVar variable.

`(FabGetItemProp “$MyVar” “This.Name”)`  
Returns: ”<em>Plain End</em>” in my scenario.

`(FabGetItemProp “$MyVar” “This.LibraryType”)`  
Returns: 2 in my scenario. Which is actually an enumerator and 2 is its closest translation for its actual value of Autodesk.Fabrication.DB.ConnectorLibraryType.Round.

<a href="http://houseofbimblog.files.wordpress.com/2017/07/fwenums.png"><img style="display:inline;background-image:none;" title="FWEnums" src="http://houseofbimblog.files.wordpress.com/2017/07/fwenums_thumb.png" alt="FWEnums" width="644" height="438" border="0" /></a>

# FabSetItemProp Overview
This function will not have nearly as much value as you would like. Yes, there are properties that can be set, but a great deal of the important ones were marked read-only and have to be set using an invoke method instead. So, if your going through the API chm and you see something with only a GET and no SET then you should probably go look at the methods directly on the ITEM object as that seems to be where they've place nearly all of them.

<a href="http://houseofbimblog.files.wordpress.com/2017/07/fwgetset.png"><img style="display:inline;background-image:none;" title="FWGetSet" src="http://houseofbimblog.files.wordpress.com/2017/07/fwgetset_thumb.png" alt="FWGetSet" width="433" height="204" border="0" /></a>

### FabSetItemProp: Syntax
`(FabGetItemProp Ename String [Object])`

### FabSetItemProp: Arguments
Ename = Fabrication object  
This will usually be a fabrication objects entity name which you would get with EntSel or SSname. However, you can provide a $variable name string instead to operate on a data structure reference you've stored.

***String*** = Path to Property  
This will be the .Net Api path reference to the property you are trying to change. The primary intent of this function is that your starting from the ITEM object (your EName) and digging down into its properties to locate the specific one you want to change. You will always represent you base object whether provided by Cached variable string name or a valid CADmep Ename as THIS and . . . your way through its namespaces just as you would in .Net.

***[Object]*** = Value to Set  
I think in a lot of scenarios you will need to use some complex data object and the Object reference here works just like the Ename; if you give it a variable name prefixed with a $ it will go find the true value from the VarCache. Make sure you do your research in the chm to figure out what type of data you should be trying to send into the various properties. If the target property does not require a complex object then you can most likely use lisp primitives as your value.

### FabSetItemProp: Return Values
This function is designed to return a T or Nil. After you tell it to set a property with a value, it then does a crude check to see if that property now contains that value. In the case of a complex object this may not be accurate, but in a lot of cases it will be. So, if you fed something a value of 2 that had a value of 3, it will check the current value after trying to set the value to 2 and if it is now 2 this function will return T. If the value still says 3 then it will return nil.

### FabSetItemProp: Examples
`(FabSetItemProp (car(entsel)) “This.Connectors[1].IsLocked” nil)`  
Returns: T and the connector is now unlocked for later modifications by our invoke method.

`(FabSetItemProp (car(entsel)) “This.Dimensions[1].Option[1].Value” 12.0)`  
Returns: T and the unlocked length dimension of my pipe is now set to 12”. Notes: you will have to call Item.Update() through a COD script for visual transformation. Not at all sure why the Update method in .Net is incapable of accomplishing this; irritating!! The This.Dimension[1].Value property is read-only for some reason. The <em>.Option</em> version I show here doesn't even appear in the chm I am looking at. I found that by using a function of mine that I will document later in this post.

`(FabSetItemProp (car(entsel)) “This.SpoolColor” 1)`  
Returns: T and makes my pipe red when the SETSPOOLCOL command is ran on it.

# FabInvokeItem Overview
This function represents most of the writable power this system has to offer. As stated in the SetProp section, the developers opted to use method invoking for the vast majority of truly important property changes. Also stated earlier, an empty path is an invalid path and most of these important methods are right on the root of the ITEM namespace. So, make sure you are using the THIS nomenclatures with this function. Generally speaking, methods do work, but are only sometimes intended to return a value. Because of this you will have to use the API documentation frequently to get any sense of what a given method will do, return or even want for arguments to perform its job.

### FabInvokeItem: Syntax
`(FabGetItemProp Ename String1 String2 <Objects> [String3])`

### FabInvokeItem: Arguments
***Ename*** = Fabrication object  
This will usually be a fabrication objects entity name which you would get with EntSel or SSname. However, you can provide a $variable name string instead to operate on a data structure reference you've stored.

***String1*** = Path to Property  
This will be the .Net Api path reference to the property value containing the method you want to invoke. You will ### always</u> </strong>represent this with at least the THIS keyword for ITEM based methods or your path will be invalid. Your THIS object does still have the option of being called from the VarCache with the $ prefix.

***String2*** = Method Name  
Refer to the chm documentation to get the exact method name or use the FabDumpItem to discover one. However, if you discover an undocumented method using FabDumpItem, then you will have to figure out for yourself what it wants/needs in order to function.

***\<Objects\>***= List of Arguments  
I've found that quite frequently required method arguments are complex data objects that need to be called from the VarCache and you can do exactly that. If something requires 3 complex objects that are stored in the VarCach, then just make a list of 3 “$VarNames” that exist in the VarCache. You can still use all the typical native lisp data types stated earlier in the FabGetItemProp return values section if those types of primitives are needed; no need to artificially create vars for them.

***[String3]*** = Optional Variable Name  
This is an optional Variable name. In a declaration scenario such as this, it is not necessary to prefix with a $ symbol. If provided, valid and intended to return a value, then FabInvokeItem return will be returned and saved in the Variable Cache for future use.

### FabInvokeItem: Return Values
This function is designed to return values of String, Integer, Decimal, Point, True or Nil. If the calling method returns a complex data object, then you will have to make sure you specify a VarName string so that you can later use or evaluate it.

### FabInvokeItem: Examples
`(FabInvokeItem (car(entsel)) “This” “Update” (list))`  
Returns: T or Nil because update isn't intended to return a meaningful value and it believes it did something or not. Notice this method that doesn't require arguments still was given an empty list to represent the prospect of feeding it arguments.

`(FabInvokeItem (car(entsel)) “This” “ChangeConnector” (list “$MyVar” 1) “Result”)`  
Returns: A complex object known as ItemOperationResult and we would have to dig down into that value to see whether it was successful or not. I would suggest saving methods with this type of return to the VarCache as shown and then further digging down to the Message or Status properties to evaluate success. Like this:

`(FabGetItemProp “$Result” “This.Message” “Result”)`  
Notice I can can save the message result right over the reference that gave me the message in the first place.

`(FabInvokeItem “$Result “This” “Contains” (list “Success”))`  
Returns: T or Nil depending on if the message contained success in the response. Yep, we can even use the .Net native methods for things like strings, integers, collections, etcetera. Clearly there are simpler ways to do this just through lisp, but I am sure there will be a few gems that would otherwise unavailable. You will need to use the MSDN documentation for these methods.

# FabDumpItem Overview
This function is intended to be the .Net FabWrapper equivilent to Vlax-Dump-Object. This will help make the .Net API at least somewhat self documenting and let you explore what is truly there and not just what was documented in the API chm documentation.

### FabDumpItem: Syntax
`(FabDumpItemEname Ename String Integer)`

### FabDumpItem: Arguments
***Ename*** = Fabrication object  
This will usually be a fabrication objects entity name which you would get with EntSel or SSname. However, you can provide a $variable name string instead to operate on a data structure reference you've stored.

***String*** = Path to Property  
As always, this will be the .Net path reference to the property you are trying to change. Also should be at least a “THIS'” path context or it will be considered invalid if empty.

***Integer*** = Bit flags that changes output are as follows:

 	- 1 = Print available Properties only
 	- 2 = Print available Methods only
 	- 3 = Print available Properties & Methods
 	- >4 = Return a list of available Properties & Methods for lisp to process.

### FabDumpItem: Return Values
See the integer portion of the arguments above for what this could return. Note that values 1,2, & 3 always returns nil; they are intended to exclusively print to the command line. Everything is precisely spaced so parsing this information and making decisions from lisp output (4+) should be relatively easy.

### FabDumpItem: Example
<a href="http://houseofbimblog.files.wordpress.com/2017/07/fwdump.png"><img style="display:inline;background-image:none;" title="FWDump" src="http://houseofbimblog.files.wordpress.com/2017/07/fwdump_thumb.png" alt="FWDump" width="644" height="413" border="0" /></a>

# FabVarCache Overview
This function is your manual entry point for retrieving data from the FabWrapper VarCache. Note that it can also be used to manually place information in the FabWrapper VarCache and this may in fact be desirable if you intend on doing work with multiple drawings that need to know what happened in the other.

### FabVarCache: Syntax
`(FabVarCache String [object])`

### FabVarCache: Arguments
***String*** = Variable Name  
It is not necessary to prefix with a $ symbol, but it won't hurt anything if you want to keep things consistent.

***Object*** = Optional Value to store  
If you provide this, then you are telling the FabVarCache function that you want to set this provided data on the specified Variable name. This is how you could potentially persist some primitive data across AutoCAD drawings; if you wanted… There are other ways of doing this like blackboard variables, but if I remember right those have strength length limitation.

### FabVarCache: Return Values
If the provided variable name exists in the VarCache dictionary, it will attempt to return whatever primitive value lisp could understand. If it didn't exist it will return nil. Note, you could even use this to (kind of) rename a variable by using a new VarName as the the first argument and an existing “$VarName” as the value. It doesn't actually rename, but it will essentially allow you to reference a value from one VarName index in another.

### FabVarCache: Example
Earlier we stored an a connector info object in the “MyVar” variable. I can see that reference using FabVarCache, but it is a complex object with no natural lisp translation. See FabGetItemProp on how to get a property of that complex object:  

`(FabVarCache “MyVar”)`  
Returns: ”<em>Autodesk.Fabrication.DB.ConnectorInfo</em>”

Alternatively I could simply throw an arbitrary “simple” lisp value into the variable cache:  
`(FabVarCache “SomeData” 1.25)`  
Returns: T

# FabClearCache Overview
This function should probably be run at the end of all your lisp routines utilizing the VarCache. The only time that might not be true is if you are specifically trying to persist data between functions or drawings. The purpose is to hopefully clean up anything you left in the VarCache thus releasing any complex data objects for garbage collection and hopefully preventing Fatal Errors that may result from persisting data beyond its natural life span.

### FabClearCache : Syntax
`(FabClearCache)`

# GetConnectorEndPoint Method:
I am not sure what happened to this method, but it appears to be in OCS/ECS coordinates these days. Which makes its pretty much useless to us. So, as a band aid to this problem, the GetConnectorEndPoint method call has been hijacked to return all points from the AutoCAD Entity GetStretchPoints method instead. From what I have seen these are equal to what you used to find from the GetConnectorEndPoint function. Also important to note that these points do seem to be in exactly the same order as the VLA Points property, but there are some differences. The VLA Points property will not show any more than 1 point if there are 2 points 100% identical; CID 838 being the obvious example. The GetStretchPoints property will still return both points even though they are essentially equal. I honestly can remember exactly how the GetConnectorEndPoint function used to work, but I know for a fact it is hosed at this point and I put the best band aid on it I could. Make sure when working with points you are making decisions based on the CID your currently working with and cater to this workaround; everything will be fine. So, you can now use GetConnectorEndpoint entirely without arguments just like this for exactly the same result:
(FabInvokeItem (car(entsel)) “This” “GetConnectorEndpoint” (list))

### Update
I have since discovered and reported that this problem is associated with the creation of a Fabrication Job.Item reference using the GetFabricationItemFromACADHandle method. If you were to parse/pluck from the native Job.Items collection, then you will no longer get OCS/ECS coordinates from the GetConnectorEndPoint method.

# Other Important General Notes:
- Make certain your only ever sending this function Fabrication objects
- Design lines do not count as Fabrication objects.
- Always clear the global variable cache when your done with it.
- Adding the “THIS” decoration is mostly for readability and optional except on root method calls.
- Information stored in the Var Cache is persistent across your AutoCAD session and not per drawing. This could be a valuable tool to pass information between drawings, but depending on what your trying to reference could destabilize AutoCAD.

# Post Wrap:
Get it? Anyway… In 2015 I sat through an AU class where the instructor was telling us how the brand new Fabrication API still needed a lot of development and recommended that we use .Net to dynamically write/execute COD scripts to fill in the gaps of the immature .Net API. I am not going to lie, that really pissed me off. Not entirely at the presenter (he was being honest), but at the API and I pretty much refused to dig into the API for a long time as a result. However, after a bit more development on this tool, I think the best thing you could do is utilize lisp as your logical core to leverage, manage and execute the oddly independent powers of VLA, DXF, COD's & .Net!
I think we will all be a while doing real world testing on what I've presented here, but stay tuned for the next release that lets you use these same concepts directly with the Fabrication database. Note that moving forward I will only be providing the DLL and maintaining a single post as a version history. I've already done all the heavy lifting around this concept and I like to give capable people homework. So, if you want the database portion available and require the code you better download what I provided and dig in for yourself <img class="wlEmoticon wlEmoticon-smile" src="http://houseofbimblog.files.wordpress.com/2017/07/wlemoticon-smile1.png" alt="Smile" />
Normally I would provide some ideas, but in this case I feel like I opened Pandora's box and the possibilities are just too staggering to speculate on. So, I'll just say I hope this helps you guys do some really awesome things and if you want to tell us about them, then please do.
