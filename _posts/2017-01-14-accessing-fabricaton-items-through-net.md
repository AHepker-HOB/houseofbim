---
layout: post
title: "Accessing Fabricaton Items Through .NET"
date: 2017-01-14 13:28
author: Skylar Daniels
comments: true
categories: [.NET, Fabrication CADmep]
tags: [Autodesk, Automation, command, Fabrication, Fabrication API]
---
Like AutoCAD, Fabrication MEP has its own API that can be used to read/write properties, and access different Fabrication objects.  If you have used .NET to create commands for AutoCAD in the past but had difficulty setting up a project to access Fabrication Items, this post may help. If you are new to setting up an AutoCAD project in .NET (the example below is in C#) the [link Here](https://knowledge.autodesk.com/support/autocad/learn-explore/caas/simplecontent/content/my-first-autocad-plug-overview.html) will show you how to set up a new AutoCAD project in visual studio using VB.NET, but the setup for C# is the same.  If you are new to .NET and or programming, I recommend checking out Josh's post: "Update my C# Roadmap", particularly Bob Tabors class on Microsoft Virtual Academy: ["C# Fundamentals for Absolute Beginners"](https://mva.microsoft.com/en-us/training-courses/c-fundamentals-for-absolute-beginners-16169?l=Lvld4EQIC_2706218949).  After going through the videos and reading some examples in the help files and online, you should be ready to start poking around with customizing AutoCAD.

A common object that users interact with in a Fabrication drawing is an "Item" which, depending on the version of Fabrication, has properties that are read/write, and properties that are read only.  A "Job Item" is an instance of the parent Fabrication ITM.  Because it is an Instance of an ITM, some properties that we can write to will persist, and some will go back to that of the Parent ITM.  In order to make changes to the parent ITM we need to change the "Disk Item", which will be in a future post.  It is important to note that if we change the parent ITM, ***ALL*** instances in all drawings will be effected by any changes that we make. There is a help file called "FabricationAPI.chm" located at "C:\Program Files\Autodesk\Fabrication 2017\SDK" that outlines the API and has examples to help you get started.

Before we access the Fabrication Items we need to set up a project correctly.  After the AutoCAD project set up in Visual Studio, the next step is to reference the FabricationAPI.dll located at "C:\Program Files\Autodesk\Fabrication 2017\CADmep".  There is another critical step in order to get your Plugin to work.  This step is mentioned in the FabricationAPI.chm help file under Contents\Getting Started\Addin Integration\Addin Integration-CADmep. It states:

> "As of the 2016 release of the Autodesk Fabrication API, it is required that the FabricationAPI.dll is loaded when Initializing the AutoCAD addin.  This can be done using the following method: System.Reflection.Assembly.LoadFrom(path to FabricationAPI.dll in CADmep);"

It is important to add the above Method where the Plugin is initialized.  If you use the wizard to set your project up, there is a file in your project called "MyPlugin.cs" which has the initialization interface code block already populated.  In the example provided, I just added the MyPlugin class at the beginning of the "FabCommand" class.

In the code below, the user selects some Fabrication objects, the command then iterates through the selection and get a list of the unique spool names and prints them to the command line.  We can access the Items by simply supplying the entity handle string to the Job.GetFabricationItemFromACADHandle() method.

```c#
using System;
using System.Collections.Generic;
using Autodesk.AutoCAD.Runtime;
using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.DatabaseServices;
using Autodesk.AutoCAD.EditorInput;
using Autodesk.Fabrication;

namespace FabricationExample
{
    public class FabCommand
    {
        //Important!!!!
        //This is needed for using Reflection of the FabricaitonAPI.dll
        //Without this class, the plugin will not work.  See C:\Program Files\Autodesk\Fabrication 2017\SDK\FabricationAPI.chm for more details
        public class MyPlugin : IExtensionApplication
        {
            void IExtensionApplication.Initialize()
            {
                System.Reflection.Assembly.LoadFrom("C:\\Program Files\\Autodesk\\Fabrication 2017\\CADmep\\FabricationAPI.dll");
            }

            void IExtensionApplication.Terminate()
            {
                // Do plug-in application clean up here
            }
    
        }
    
        //Start of the command "UniqueSpools"
        [CommandMethod("UniqueSpools")]
        public void UniqueSpools()
        {
            //Initialize list of spools
            List<string> usedSpools = new List<string>();
    
            //Get the current document, database, and editor object
            Document doc = Application.DocumentManager.MdiActiveDocument;
            Database db = doc.Database;
            Editor ed = doc.Editor;
    
            //Set up a typed value array for selection filter
            TypedValue[] typeArray = new TypedValue[1];

            //For Lispers; Works like using DXF group codes, same as (0 . "MAPS_SOLID")
            typeArray[0] = new TypedValue((int)DxfCode.Start, "MAPS_SOLID"); 
    
            //Set selection filter from our typed array and prompt user selection
            SelectionFilter selFilter = new SelectionFilter(typeArray);
            PromptSelectionResult selResult = ed.GetSelection(selFilter);
    
            //If user presses enter, iterate through selection
            if (selResult.Status == PromptStatus.OK)
            {
                //get transaction object
                using (Transaction tr = db.TransactionManager.StartTransaction())
                {
                    SelectionSet ss = selResult.Value;
    
                    //Iterate through the selection set
                    foreach (SelectedObject selObject in ss)
                    {
                        if (selObject != null)
                        {
                            //Get the entity
                            Entity ent = tr.GetObject(selObject.ObjectId, OpenMode.ForRead) as Entity;
    
                            if (ent != null)
                            {
                                //Get the Fabrication Item from the entity handle
                                Item item = Job.GetFabricationItemFromACADHandle(ent.Handle.ToString());
    
                                //If object is a Fabrication item, check to see if the spool name is in our list.
                                //Add to list if it does not exist.
                                if (item != null)
                                {
                                    if (!usedSpools.Contains(item.SpoolName))
                                        usedSpools.Add(item.SpoolName);
                                }
                            }
                        }
                    }
                }
    
                //Print a list of all unique spool names to the command line
                ed.WriteMessage("List of unique Spools:");
                foreach (string spool in usedSpools)
                {
                    ed.WriteMessage(String.Format("\n{0}", spool));
                }
            }
        }
    }
}
```

Below is an example of a creating a Lisp Function that can be used to find the Connector Vector of an Item. The function takes two arguments, the entity handle (string), and the Connector index (short), and returns a point (list of doubles) from the Connector origin. Connector Vector is an example of a property that can only be accessed through the Fabrication .NET API. This vector can be used to calculate the true midpoint of fabrication Items.

```c#
using Autodesk.AutoCAD.Runtime;
using Autodesk.AutoCAD.DatabaseServices;
using Autodesk.Fabrication;
using Autodesk.Fabrication.Geometry;

[assembly: CommandClass(typeof(ConnVector.MyCommands))]

namespace ConnVector
{
    public class MyPlugin : IExtensionApplication
    {
        void IExtensionApplication.Initialize()
        {
            System.Reflection.Assembly.LoadFrom("C:\\Program Files\\Autodesk\\Fabrication 2017\\CADmep\\FabricationAPI.dll");
        }

        void IExtensionApplication.Terminate()
        {
        }
    }
    
    public class MyCommands
    {
        [LispFunction("ConnVector")]
        public ResultBuffer ConnVectorLispFunction(ResultBuffer args)
        {
            string eHandle;
            short connectorIndex;
            Point3D p3;
            TypedValue[] input = args.AsArray();
    
            //Set the first argument to the entity handle
            eHandle = (string)input[0].Value;
    
            //Set the second argument to the connector index
            connectorIndex = (short)input[1].Value;
    
            //Get fabrication item from the entity handle
            Item item = Job.GetFabricationItemFromACADHandle(eHandle);
    
            //get the connector vector of the specified index
            p3 = item.GetConnectorDirectionVector(connectorIndex);
    
            //Prepare and return the Result buffer as a point (list of reals)
            ResultBuffer resBuff = new ResultBuffer();
            resBuff.Add(new TypedValue((int)LispDataType.ListBegin));
            resBuff.Add(new TypedValue((int)LispDataType.Double, p3.X));
            resBuff.Add(new TypedValue((int)LispDataType.Double, p3.Y));
            resBuff.Add(new TypedValue((int)LispDataType.Double, p3.Z));
            resBuff.Add(new TypedValue((int)LispDataType.ListEnd));
            return resBuff;
        }
    }
}
```

Here is a [link to the dll](/assets/dotnet/ConnVector.dll)

Thank you for taking the time to read this post and please leave a comment or email me at Skylar.Daniels@houseofbim.com with any questions or suggestions.
