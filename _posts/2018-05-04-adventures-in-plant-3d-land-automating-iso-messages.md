---
layout: post
title: "Adventures in Plant 3D Land: Automating Iso Messages"
date: 2018-05-04 01:40
author: Josh Howard
comments: true
categories: [Lisp, Plant 3D]
tags: [ActiveX, AutoCAD, Iso Message, Iso Sphere, IsoMessage, IsoSphere, VLA-OBJECT, XRecord]
---
If you are an avid keyboard user like me, then you probably share my contempt for the developers choice of mandating a dialog prompt for text entry on Plant 3D IsoMessages. I know it was a constant irritation of mine years ago when I was first using P3D. Especially since there were so many logical applications for standardized notes that could be made if they would just let me. Maybe I'm a pessimist for having so little faith in people (and myself) to be consistent, but I do think my personal experiences easily justify my dismal expectations of typical users.

Anyway, I recently had the misfortune of being subjected to that same anguish, but these days I am a much craftier automater. So, things have generally been going my way this time around and I will be talking about one of those many victories in this post.

During the course of this current project I've unfortunately had to dive VERY deep into the Plant SDK. Which is an absolute labyrinth and thankfully I am finally “caching on” to their philosophy. I still don't like something this soupy and seemingly incoherent, but I will admit the crazy fast query of LineGroup data for the ENTIRE project is a pretty impressive byproduct of the choices they've made. Once I figured it out, it was a very small amount of code to export all the line group data to a csv, edit it in excel and put it back into the project database. I've done very similar tricks with CADmep, but it is a lot more messy and overhead intensive.

Having failed miserably with lisp years ago, one of my top agenda items this time around was automating the creation of standardize Iso Messages using the .Net API. I found almost no documentation in the SDK download and the only help the internet had to offer was some [ObjectARX pseudo code](http://adndevblog.typepad.com/autocad/2012/09/create-isospheresymbol-in-plant3d-using-objectarx.html) that ultimately fell short of making a fully functional Iso Message Sphere. After a ton of ineffective web browsing and some deciphering of related code, I did gain fundamental insights on how these existed and related to other Plant objects. However, it was very disappointing to have my .Net attempt fail miserably like my lisp attempt did years before. I actually considered accomplishing my goal purely from post processing the PCF's, but then I eventually picked up on the fact that numerous Iso Spheres derived from the same base class and set upon convincing a pig to act like a bull; which paid off!

The Iso Message, Floor Symbol, Insulation Symbol and Location Point all derived from the same .Net namespace of:

`Autodesk.ProcessPower.PnP3dObjects.IsoSphereSymbol`

I also discovered that IsoSphere's were essentially being claimed by a LineGroup and other than that they literally weren't associated to anything. So, after some prodding I found that they had an AutoCAD extension dictionary, that contained an X-Record, that contained data, that Plant 3D makes some pretty wild behavioral changes based upon. I am still not sure if the first SafeArray list in my code has rigid values, but  I've had zero issues with the static values I extracted from an existing Iso Message; the documentation says these are declarations of dxf data types and you can see that if you entget the xRecord. However, the important thing is that the X-Record name determined the actual Sphere type and that the 2nd SafeArray (Data argument) did allow me to set the Message value, the Box type and whether it was dimensioned! What does this all mean? Well, with some some old school command lisp puppeteering of the PLANTISOADDINFO command we can build our IsoMessages from any of the other derived Sphere types that do not involve dialogs. Once it exists, then we just have to superimpose the desired data we want onto it.

Note: The PLANTISOADDINFO does not let you provide a point from code, I assume Plant 3D is using a specialized version of point selection user input due to its need of making a relationship between the sphere and a LineGroup. Based on what I know about the P3D's API, you should want it doing this heavy lifting of object associations anyway. It is very fickle and these are truly paper thin relationships that are likely impossible to rebuild from lisp after the fact if it doesn't make the proper decision upon creation. Please correct me if you find a way to associate a sphere after creation using lisp or Plant 3D commands. With this trick and my .Net background, I could pretty much fabricate these things from scratch using a block reference, but it's quite ugly.

```lisp
(defun HOB:CreateIsoMessage (msg box dimed / lent nsa nsd dic rec obj)
  (setq lent (entlast)
        msg (acet-str-replace " " "@" msg)
        msg (acet-str-replace "\n" "$" msg))
  (command "PLANTISOADDINFO" "L" pause)
  (if (/= (vl-princ-to-string lent) (vl-princ-to-string (entlast)))
    (progn
      (setq ent (entlast)
            obj (vlax-ename-&gt;vla-object ent)
            dic (vla-GetExtensionDictionary obj)
            rec (vla-item dic 0)
            nsa (vlax-make-safearray vlax-vbInteger '(0 . 2))
            nsd (vlax-make-safearray vlax-vbVariant '(0 . 2)))
      (if (null dimed) (setq dimed 0) (setq dimmed 1))
      (if (or (null box) (/= (type box) 'INT)) (setq box 0))
      (vlax-safearray-put-element nsa 0 1)
      (vlax-safearray-put-element nsa 1 90)
      (vlax-safearray-put-element nsa 2 90)
      (vlax-safearray-put-element nsd 0 (vlax-make-variant msg vlax-vbString))
      (vlax-safearray-put-element nsd 1 (vlax-make-variant dimed vlax-vbLong))
      (vlax-safearray-put-element nsd 2 (vlax-make-variant box vlax-vbLong))
      (vla-SetXRecordData rec nsa nsd)
      (vla-put-name rec "PnP3dMsg")
      )
    )
  )

;Example function call
(HOB:CreateIsoMessage "Stuff and Things\nCan't forget THINGS!" 1 1)
```

Probably more verbose than needed, but there just isn't much information out there about these and I thought my process background would be a fine example of how I consistently manage to solve my real world problems. In the world of code, there really is no spoon. Enjoy the new utility… 


# Update
*This code was graciously posted by Jason Hudson in a comment on the former Wordpress site. We've included it here as an example of creating iso messages with the .NET API.*

```c#
private ObjectId CreateTieInPoint(string tipGroup, string tipNumber)
{
    Document doc = AcadApp.DocumentManager.MdiActiveDocument;
    Database db = doc.Database;
    Editor ed = doc.Editor;
    Point3d issPoint3d = Point3d.Origin;
    ObjectId issId = ObjectId.Null;
    ObjectId componentId = ObjectId.Null;
    string issPortName = "";
    string componentPortName = "";
    string issMsgString = tipGroup + @"\P" + tipNumber;
    // Get the sphere block to insert at the iss point
    ObjectId issBlockId = CreateTieInPointIssBlock();
    if (issBlockId == ObjectId.Null)
    {
        AcadApp
            .ShowAlertDialog("Error: Failed to get Tie-In Point blockId.\nPlease make sure you are in the World Coordinate System (UCS ‘W'");
        return ObjectId.Null;
    }
    Autodesk.AutoCAD.Internal.Utils.SetFocusToDwgView();
    // save osmode to reset when done
    Object origOsmode = AcadApp.GetSystemVariable("osmode");
    // set osmode to ‘node’ only
    AcadApp.SetSystemVariable("OSMODE", 8);
    // Get the iss insertion point
    PromptPointResult pPtRes;
    PromptPointOptions pPtOpts =
        new PromptPointOptions("\nSelect the Tie-In Point location: ");
    pPtRes = doc.Editor.GetPoint(pPtOpts);
    issPoint3d = pPtRes.Value;
    ed.WriteMessage("\n");
    // restore original osmode
    AcadApp.SetSystemVariable("OSMODE", origOsmode);
    // Find a component with port at selected point location
    Dictionary partsPointsCoordsDict =
        MiscUtilities.GetPartPointsCoordsDict();
    if (!partsPointsCoordsDict.ContainsKey(issPoint3d))
    {
        AcadApp
            .ShowAlertDialog("Error: Could not get Tie-In Point location.\n\n Please verify the following:\n" +
            " – You are in WCS.\n – You are choosing the node of a piping component.\n" +
            " – You are choosing a component in the current drawing (not Xref).");
        return ObjectId.Null;
    }
    componentId = partsPointsCoordsDict[issPoint3d];
    using (DocumentLock lockDoc = doc.LockDocument())
    {
        using (Transaction tr = db.TransactionManager.StartTransaction()
        )
        {
            try
            {
                // Create the iss symbol and add a symbolic port ——————————————————————–
                IsoSphereSymbol iss = new IsoSphereSymbol();
                iss.Position = issPoint3d;
                iss.Radius = 1;
                iss.Layer = GetTieInPointsLayer();
                Port issPort = new Port();
                issPort.IsSymbolic = true;
                issPort.Position = issPoint3d;
                issPort.Direction = (new Vector3d(0, 0, 1));
                issPortName = "Symbolic";
                issPort.Name = issPortName;
                iss.AddPort (issPort);
                iss.BlockId = issBlockId;
                BlockTable bt =
                    (BlockTable)
                    tr
                        .GetObject(doc.Database.BlockTableId,
                        OpenMode.ForRead);
                BlockTableRecord btr =
                    (BlockTableRecord)
                    tr
                        .GetObject(bt[BlockTableRecord.ModelSpace],
                        OpenMode.ForWrite);
                btr.AppendEntity (iss);
                tr.AddNewlyCreatedDBObject(iss, true);
                issId = iss.ObjectId;
                // Add a symbolic port the the host piping component ———————————————————————
                Part component =
                    (Part) tr.GetObject(componentId, OpenMode.ForWrite);
                Port componentPort = new Port();
                componentPort.IsSymbolic = true;
                componentPortName =
                    component.GenerateDynamicPortName(true);
                componentPort.Name = componentPortName;
                componentPort.Position = issPoint3d;
                componentPort.Direction = (new Vector3d(0, 0, -1));
                component.AddPort (componentPort);
                // Create port pairs and connect them ————————————————————————————–
                ConnectionManager cm = new ConnectionManager();
                Part issPart =
                    tr.GetObject(issId, OpenMode.ForRead) as
                    Autodesk.ProcessPower.PnP3dObjects.Part;
                Part componentPart =
                    tr
                        .GetObject(component.ObjectId,
                        OpenMode.ForRead) as
                    Autodesk.ProcessPower.PnP3dObjects.Part;
                // Fetch ports information
                Autodesk.ProcessPower.PnP3dObjects.PortCollection issPorts =
                    issPart.GetPorts(PortType.Symbolic);
                Autodesk.ProcessPower.PnP3dObjects.PortCollection connectorPorts =
                    componentPart.GetPorts(PortType.Symbolic);
                // Create port pairs and connect them
                Pair issPair = new Pair();
                issPair.Port = issPorts[issPortName];
                issPair.ObjectId = issId;
                Pair componentPair = new Pair();
                componentPair.Port = connectorPorts[componentPortName];
                componentPair.ObjectId = componentId;
                cm.Connect (issPair, componentPair);
                // Cancel the transaction and return NULL if the iss did not connect
                if (!cm.IsConnected(issPair))
                {
                    ed
                        .WriteMessage("Error: Could not connect tie-in point!");
                    tr.Abort();
                }
                // Create the Tie-In Point tag ———————————————————————————————-
                ObjectId mleaderId =
                    TagTieInPoint(issId, tipGroup, tipNumber);
                // set the iso message ——————————————————————————————————
                Entity ent =
                    tr
                        .GetObject(iss.ObjectId,
                        OpenMode.ForRead,
                        false,
                        true) as
                    Entity;
                // Create the ExtensionDictionary if it does not exist
                if (ent.ExtensionDictionary.IsValid != true)
                {
                    ent.UpgradeOpen();
                    ent.CreateExtensionDictionary();
                    ent.DowngradeOpen();
                }
                if (ent.ExtensionDictionary.IsValid == true)
                {
                    ResultBuffer rb = new ResultBuffer();
                    Xrecord xRec = new Xrecord();
                    DBDictionary extDict =
                        (DBDictionary)
                        tr
                            .GetObject(ent.ExtensionDictionary,
                            OpenMode.ForWrite);
                    // Add issType XRec
                    rb = new ResultBuffer();
                    rb
                        .Add(new TypedValue((int) DxfCode.Text,
                            "TieInPoint"));
                    xRec = new Xrecord();
                    xRec.Data = rb;
                    extDict.SetAt("issType", xRec);
                    tr.AddNewlyCreatedDBObject(xRec, true);
                    // Set PnP3dMsg XRec
                    rb = new ResultBuffer();
                    rb
                        .Add(new TypedValue((int) DxfCode.Text,
                            issMsgString));
                    xRec = new Xrecord();
                    xRec.Data = rb;
                    extDict.SetAt("PnP3dMsg", xRec);
                    tr.AddNewlyCreatedDBObject(xRec, true);
                    // Set mleader objectId XRec
                    rb = new ResultBuffer();
                    rb.Add(new TypedValue(330, mleaderId));
                    xRec = new Xrecord();
                    xRec.Data = rb;
                    extDict.SetAt("mleaderObjId", xRec);
                    tr.AddNewlyCreatedDBObject(xRec, true);
                    extDict.DowngradeOpen();
                }
            }
            catch
            {
                AcadApp
                    .ShowAlertDialog("Error: Could not add Tie-In Point.");
                tr.Abort();
            }
            tr.Commit();
        }
    }
    // Error if valid ObjectId not returned
    if (issId == ObjectId.Null)
    {
        AcadApp
            .ShowAlertDialog("Error: Could not get Tie-In Point location.\n\n Please verify the following:\n" +
            " – You are in WCS.\n – You are choosing the node of a piping component.\n" +
            " – You are choosing a component in the current drawing (not Xref).");
    }
    return issId;
}


// Tap port example:
// Add a dynamic port the the host piping component
Port tapPort = new Port();
tapPort.EndType = "TAP";
tapPort.EngagementLength = 0;
tapPort.IsDynamic = true;
tapPort.IsSymbolic = false;
tapPort.Name = tapPortName;
tapPort.NominalDiameter = partDef.MainNomDiam;
tapPort.Position = partDef.TapPoint;

if (partDef.IsBranchEol)
tapPort.Direction = partDef.MainVector;
else
tapPort.Direction = partDef.BranchVector;

part.UpgradeOpen();
part.AddPort(tapPort);
```