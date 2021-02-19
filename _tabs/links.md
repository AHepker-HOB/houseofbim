---
layout: post
title: Links
icon: fa fa-link
order: 4
toc: true
---

I've been managing a cluster of programming related links I use regularly for a while. Although it can quickly become a dumping ground instead of organized; figured this would be a good place to actually organize major references I use. Notice that the right side of this page is a category TOC.

# .Net Framework

* ### Source Code

  * [.Net <= 4.8 Source Reference](https://referencesource.microsoft.com/), this is a labyrinth, but completely invaluable if you are trying to figure out what all you will lose when overriding the metadata of a dependency property.
  * [.Net Core Source Reference](https://source.dot.net/), invaluable for the same reasons, but probably more so since Core has been going through so many changes.

* ### WPF
  
  * [FrameworkElement Class](https://docs.microsoft.com/en-us/dotnet/api/system.windows.frameworkelement?view=netframework-4.8), this is the base element for all the elements you might be referencing, I use this page to explore Control inheritance.
* ### UWP
  
  * [Win2D Documentation](https://microsoft.github.io/Win2D/html/Introduction.htm), this gives .Net drawing capabilities similar to the Canvas control with JavaScript.
  * [FrameworkElement Class](https://docs.microsoft.com/en-us/uwp/api/windows.ui.xaml.frameworkelement), this is the base element for all the elements you might be referencing, I use this page to explore Control inheritance.
* ### XAML
  
  * [XamlFormatter VS Extension](https://marketplace.visualstudio.com/items?itemName=DannOh.XamlFormatter), this thing is a great time saver. I like the fact that it takes absolutely no liberties with line spreading, but I do wish it had a "format selection" version that did auto-stack horizontal properties for me.
  * [Developing Windows 10 Applications with C#](https://www.amazon.com/Developing-Windows-10-Applications-C/dp/1522894918/) by Sergii Baidachnyi, this is a crap title for this book. Its largely focused on XAML and probably the only one I've found that is. Other than the deceptive title, its a high quality book on the topic of UWP XAML; which is conceptually no different than WPF XAMl.



# Autodesk

* [AutoCAD API Documentation](https://help.autodesk.com/view/OARX/2021/ENU/)
* [AutoCAD API Forum](https://forums.autodesk.com/t5/net/bd-p/152)
* [Autodesk Developer Network Platforms](https://www.autodesk.com/developer-network/platform-technologies), gets you to the various public SDK downloads.
* [Navisworks API Forum](https://forums.autodesk.com/t5/navisworks-api/bd-p/600)
* [Revit API Documentation](https://www.revitapidocs.com/), unofficial but more complete than anything Autodesk is providing.
* [Revit .Net API Forum](https://forums.autodesk.com/t5/revit-api-forum/bd-p/160)
* [Revit Dynamo Primer](https://primer.dynamobim.org/)
* [Spiderinnet Blog](https://spiderinnet.typepad.com/blog/), this guy does all kinds of cool modifications to various Autodesk products and his blog rarely comes up in search results.



# Base64

* [Base64 Encode/Decode](https://marketplace.visualstudio.com/items?itemName=moonspace-labs-llc.Base64EncodeDecode) Visual Studio Extension. Strictly for text, but this has been saving me quite a bit of time because I can stay directly in VS if I need to serialize a XAML resource or something. 

* [Base64-Image.de](https://www.base64-image.de/), I pretty much use this exclusively when I need to serialize an image for static browser representation; which happens more often than I would like.



# Colors

* [Paletton](https://paletton.com/), this is a fantastic online app for application color palette selection. I am red-green color blind, so this helps me out quite a lot.
* [Flat UI Color Picker](http://www.flatuicolorpicker.com/), another fantastic resource that groups colors that go together with a variety of output color formats.
* [W3 CSS Color Specification](https://www.w3.org/TR/css-color/), literally everything you need to know about web colors.
* [W3 Schools Web Color Palette](https://www.w3schools.com/cssref/css_colors.asp), I like to use this for base color selection, just because it has fairly large color swatches and still manages to get quite a few on the screen at one time.
* [System.Windows.SystemColors](https://docs.microsoft.com/en-us/dotnet/api/system.windows.systemcolors?redirectedfrom=MSDN&view=net-5.0), definitions of the .Net static resources.
* [System.Windows.SystemColors](https://docs.microsoft.com/en-us/archive/blogs/wpf/systemcolors-reference), subjective, but a good visual reference for .Net static resources.



# Fonts

* [Segoe MDL2 Assets](https://docs.microsoft.com/en-us/windows/uwp/design/style/segoe-ui-symbol-font), I frequently use this native Windows 10 font with windows apps to create vector Icons. This page details the available symbols.
* [Getting Started with Google Fonts](https://developers.google.com/fonts/docs/getting_started), This has definitively been one of the major changes beautifying the internet for us.



# Jekyll

* [Jekyll Docs](https://jekyllrb.com/docs/), not used to the right-side navigation bar, but the various short articles in there are great for ideas that will take you down some google rabbit holes. 
* [:pushpin:](https://web.archive.org/web/20201201231940/https://blog.webjeda.com/jekyll-guide/) [WebJeda - Jekyll Tutorial for Beginners](https://blog.webjeda.com/jekyll-guide/), generally been a good blog to learn stuff from.
* [Liquid Documentation](https://shopify.github.io/liquid/)
* [Sass SCSS Documentation](https://sass-lang.com/documentation/syntax)
* [CloudFlare](https://www.cloudflare.com/), very easy and free NameServer to SSL encrypt your GitHub Pages custom domain. 
* [OctoPress Debugger](https://github.com/octopress/debugger), creates a special liquid tag for breaking a browser during generation.



# Markdown
* ### Editing

  * [Typora](https://typora.io/), I know MD-Monster is the gold standard, but this is a really nice free MD editor. Offers a "unique" experience in that you work in the "pretty view" of a rendered MD file, but it will dynamically show a lot of the stuff you might care about in the "ugliness" of markdown as it becomes contextually relevant to the cursor location. I use it for almost all my MD editing. Note it does have quick way to switch the view to "raw source" mode too.
  * [Markdown All In One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one), this is a VSCode extension that can do quite a lot of stuff, but doesn't give you that "hybrid" view Typora will. I currently use this for dynamically generating the TOC's.

* ### Syntax

  * [Typora Markdown Reference](https://support.typora.io/Markdown-Reference/), again these guys have done a really nice job in general. I just wish this page had a static side navigation.
  * [GitHub Markdown Reference](https://guides.github.com/features/mastering-markdown/), GH does have special rules, so if your making MD's for GitHub Repo's, then use this one.
  * [Mermaid Documentation](https://mermaid-js.github.io), this is a diagraming dialect of Markdown that happens to be used on site; included with Chirpy Theme.
  * [Markdown Preview Enhanced Reference](https://shd101wyy.github.io/markdown-preview-enhanced/#/markdown-basics), I prefer using this one only because it has the left static navigation.

* ### Viewers

  * [Quicklook](https://www.microsoft.com/en-us/p/quicklook/9nv4bs3l1h4s), this is a general enhancement for windows that opens a "view" of many different types of documents from Windows File Explorer just by pressing the spacebar. I am especially fond of the automatically generated table of contents this makes markdown files.
  * [Markdown Preview Enhanced](https://marketplace.visualstudio.com/items?itemName=shd101wyy.markdown-preview-enhanced), if you didn't like Typora and the raw Markdown is your cup of tea, then this is probably the best VSCode Extension viewer to use in conjunction with Markdown All In One.



# Regex

* [HTML5 Patterns](https://www.html5pattern.com/), a great source for commonly used Regex Patterns.

* [RegExr](https://regexr.com/), my go to source for building and debugging Regex patterns.

* [MS Regex Quick Reference](https://docs.microsoft.com/en-us/dotnet/standard/base-types/regular-expression-language-quick-reference), because you need to verify the feature you used in RegExr actually exist when used in .Net applications.



# Sound

* [FreeSound.org](https://freesound.org/), excellent place to find app sound effects.
* [Sonic Pi](https://sonic-pi.net/), if you like coding and electronic music, then this is probably the coolest thing ever.




# Visual Studio Code

- ### API

  - [NodeJS API Documentation](https://nodejs.org/api/), because VSCode is built on and thus exposes NodeJS functionality.
  - [VSCode Language Server Protocol Specification](https://microsoft.github.io/language-server-protocol/specifications/specification-current/), this is for deep dive research. 
  - [VSCode API Documentation](https://code.visualstudio.com/api/references/vscode-api), this is for investigating everything in the `vscode` namespace.
  - [VSCode Predefined Variable Reference](https://code.visualstudio.com/docs/editor/variables-reference), these are all the ${special} keywords that do stuff in the JSON.
  - [VSCode Debugger Extensions](https://code.visualstudio.com/api/extension-guides/debugger-extension), this is a fantastic overview of the debugger API and there is a link to a GitHub repo showing you how to simulate a Mock Debugger made entirely from TypeScript; which is the only way you'll be able to test code if the thing your targeting doesn't expose a debug adapter.
  - [Haxe](https://vshaxe.github.io/vscode-extern/), for some reason the Haxe language required its own implementations of VSCode. This is a derived work, but they also wrote a lot of their own documentation. With that said, you can sometimes find different explanations for things here that might make something about the real VSCode API more understandable. 

- ### Reference Repos
  
  - AutoLispExt - AutoCAD Lisp Language Extension
    - [Autodesk-AutoCAD Repo](https://github.com/Autodesk-AutoCAD/AutoLispExt)
    - [JD-Howard Repo](https://github.com/JD-Howard/AutoLispExt) (my fork)
  - [Error Lens Repo](https://github.com/usernamehw/vscode-error-lens) great extension that makes you want to go fix even trivial errors.
  - FabCOD - Autodesk Fabrication COD Language Extension
    - [AgileBIM Repo](https://github.com/AgileBIM/FabCOD)
    - [JD-Howard Repo](https://github.com/JD-Howard/FabCOD) (my fork)
  - [Microsoft/VSCode](https://github.com/Microsoft/vscode) Official Repo




