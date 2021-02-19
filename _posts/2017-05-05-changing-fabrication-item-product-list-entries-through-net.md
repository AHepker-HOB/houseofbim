---
layout: post
title: "Changing Fabrication Item Product List Entries Through .NET"
date: 2017-05-05 10:57
author: Skylar Daniels
comments: true
categories: [.NET, Fabrication CADmep]
tags: [Fabrication API, Lisp, Product List]
---
A few months ago there was an occasion where a colleague needed to swap out some clamps that were product listed for a different size. The simplest method would have been to just do a swap in, but the problem with that method was that the clamps had unique spool names and custom data that would be overwritten if a swap in was performed. This made me decide to look into changing a Job Item product list line entry through the Fabrication .NET API. For more information about getting started with Fabrications Items through the .NET API see the post [Accessing Fabrication Items Through .NET]{% post_url 2017-01-14-accessing-fabricaton-items-through-net %}.

The code below has the user select some fabrication objects, then displays a dialog with a drop down of all unique Product List names within the user selection. The user then selects a name from the drop down and hits "OK". The selected items that have that product list name entry are then updated. It should be noted that the items will not be dynamically stretched/relocated like they would if you used "revdesign" to updated items with Design Line, so you would need to go back through and make any adjustments where needed. The benefit would be the fact that unlike Design Line, all of the user imputed data like "Spool Name" will not be overwritten.

[Click here to download](/assets/dotnet/changeproductlistname2.zip) the AutoCAD/Fabrication 2017 .dll  
Load using the "NETLOAD" command, and type "ChangePLName" to start command

```c#
// SDaniels HOB 01.08.2017
using System.Collections.Generic;
using Autodesk.AutoCAD.Runtime;
using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.DatabaseServices;
using Autodesk.AutoCAD.EditorInput;
using Autodesk.Fabrication;

namespace ChangeProductListName
{
    //This class needed to load the Fabrication .dll
    //See "Accessing Fabrication Items Through .NET" post for more info
    public class MyPlugin : IExtensionApplication
    {
        void IExtensionApplication.Initialize()
        {
            System.Reflection.Assembly.LoadFrom("C:\\Program Files\\Autodesk\\Fabrication 2017\\CADmep\\FabricationAPI.dll");
        }

        void IExtensionApplication.Terminate() { }
    }

    public class MyCommands
    {
        public List<string> plNames = new List<string>();

        [CommandMethod("ChangePLName")]
        public void MyCommand()
        {
            Document doc = Autodesk.AutoCAD.ApplicationServices.Application.DocumentManager.MdiActiveDocument;
            Database db = doc.Database;
            Editor ed = doc.Editor;

            Form1 form1 = new Form1();

            ObjectIdCollection oIdC;

            List<Item> selectedItems = new List<Item>();

            //Get selection based on fabrication parts
            TypedValue[] typArray = new TypedValue[1];
            typArray.SetValue(new TypedValue((int)DxfCode.Start, "MAPS_SOLID"), 0);
            SelectionFilter sf = new SelectionFilter(typArray);
            PromptSelectionResult res = ed.GetSelection();

            //If user presses enter, iterate through selection and compose a list for the drop down of unique Product list names
            if (res.Status == PromptStatus.OK)
            {
                oIdC = new ObjectIdCollection(res.Value.GetObjectIds());
                if (oIdC.Count > 0)
                {
                    try
                    {
                        foreach (ObjectId id in oIdC)
                        {
                            using (Transaction tr = doc.Database.TransactionManager.StartTransaction())
                            {
                                Entity ent = tr.GetObject(id, OpenMode.ForRead) as Entity;
                                if (ent != null)
                                {
                                    Item item = Job.GetFabricationItemFromACADHandle(ent.Handle.ToString());
                                    if (item != null)
                                    {
                                        ItemProductList ipl = item.ProductList as ItemProductList;
                                        if (ipl != null)
                                        {
                                            selectedItems.Add(item);

                                            foreach (ItemProductListDataRow ipdr in ipl.Rows)
                                            {
                                                if (!form1.cmbNames.Items.Contains(ipdr.Name))
                                                {
                                                    form1.cmbNames.Items.Add(ipdr.Name);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    catch { }
                    
                    Autodesk.AutoCAD.ApplicationServices.Application.ShowModalDialog(null, form1, false);

                    if (form1.ok == 1)
                    {
                        List<Item> itemUpdatedList = new List<Item>();

                        foreach (Item item in selectedItems)
                        {
                            ItemProductList ipl = item.ProductList as ItemProductList;
                            if (ipl != null)
                            {
                                int ct = 0;

                                foreach (ItemProductListDataRow ipdr in ipl.Rows)
                                {
                                    if (ipdr.Name == form1.cmbNames.Text)
                                    {
                                        itemUpdatedList.Add(item);
                                        item.LoadProductListEntry(ct);
                                        item.Update();
                                        break;
                                    }
                                    ct++;
                                }
                            }
                        }
                        //Update the item UI view
                        //Without this, the item won't depict the updated productlist entry unless double clicked on.
                        if (itemUpdatedList.Count > 0)
                            Autodesk.Fabrication.UI.UIApplication.UpdateView(itemUpdatedList);
                    }
                }
            }
        }
    }
}
```

Thank you for taking the time to read this post and please leave a comment below with any questions or feedback.
