---
layout: post
title: "Displaying AutoCAD Attribute Values in Navisworks"
date: 2017-05-11 02:21
author: Josh Howard
comments: true
categories: [AutoCAD, Navisworks, Lisp]
tags: [Attributes, Block Definitions, Block Records, LData, Navis, Visual Lisp, VLA, VLA Text Creation]
---
I was reading a [post](https://forums.autodesk.com/t5/autocad-plant-3d-forum/tie-point-via-spec-in-3d-model/td-p/7071352) about the limitations of Attributed text values within Navisworks today. It made me recall a trick that I conjured on a past project and thought it would make an excellent post. To be clear though, you cannot <u>natively</u> display the values of an attribute in Navisworks!! It is a 3D model viewer and sadly does not play as well as expected with various 2D objects and data.

However, I do have a work around that I'll share in this post and have used quite successfully in the past, but there are some things to consider before using my method:

- It will disassociate your inserted blocks with their original block definitions.
	- This can be a problem if you have expected needs to block edit them later
	- Note that attributes are always instantiated and the only editing you could possibly do would be on non-attribute geometry. So, sub-point 1 may not matter if that was your goal; you can't entirely update instantiated attributes anyway…
- You will have to toggle between attribute and text display modes.
	- In (native) attribute mode, you can edit the values of the attributes as you normally would.
	- In text display mode the attributes are disabled and replaced with matching AutoCAD text objects; which cannot be edited.

Well those are the bad things, but the pro's are reading the name of that generic fume hood right inside Navisworks and that the values you populate are never edited or ever truly gone; just invisible. So, there shouldn't be any risk of data loss with this method. If anyone is having an issue after deciding to use this, let me know and I'll see if I can help.

## Demonstration:
You can click the image to get a clearer visual of what's going on. You can [click here](/assets/lsp/HOB_Display_Attribute_Values_in_Navis.lsp) to download the code.

<a href="/assets/img/naviswithattributevalues.gif"><img src="../assets/img/naviswithattributevalues.gif" alt="" width="100%" /></a>

&nbsp;

## How it Works:
You can [click here](/assets/lsp/HOB_Display_Attribute_Values_in_Navis.lsp) to download the HOBConvert & HOBReset command code. These are no where near 100% polished, I just sat down with an old idea and brought it back to life to get the idea out there. I don't personally use very many model space attributed blocks these days. So, maybe someone out there will take this very functional starting point and put a bit more polish on it. I'd be more than willing to repost revisions if someone is interested in doing that. Here are the fundamentals of what is going on:

- We take a block with attributes and convert it to an anonymous block.
	- This is a big deal because the user can no longer access the block definition through the block editor.
	- We could probably convert to and then back to a normal/randomly generated named block to prevent blocking the users edit capabilities; maybe…
- Once we have a fresh block definition to defile, we start collecting all the instantiated attribute values.
- Then we actually start recreating the appearance of the attributes using standard AutoCAD text.
	- Note that there are some strange behaviors when using various alignments and that is why I have the error trap on the alignment point; necessary evil.
	- We are “marking” the text that we auto generated using LData. This is to ensure our reset function isn't deleting naturally occurring text in block definitions. We only let it do delete work on things it created!
- Finally we hide the attributes in both the instance (block insert) and the block definition.

## The Reset:
This is doing about half the work the Convert is, but is more simply on a mission to delete any auto generated text and restore the visibility state of the attributes.

As always, feedback or questions are welcome.
