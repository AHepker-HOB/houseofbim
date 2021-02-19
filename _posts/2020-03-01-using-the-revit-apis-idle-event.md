---
layout: post
title: Using the Revit API's Idle Event
date: 2020-03-01 23:38
author: homeofbim
comments: true
categories: [.NET, Revit]
tags: [C#, Deferred Code, Delegate, Idle Event, Revit, Revit API]
---
I've been digging into the Revit API a lot lately. I am not a Revit true-believer yet, but I give credit where its due and so far the Revit API has been quite impressive. It is lacking a lot of things, but generally you can work around them one way or another. One such pain that many of us encounter is a limited number of places you can actually do work. Which again, isn't a big deal, but I do see a lot of people complaining about having super bloated idle events. I have no idea if someone else has a better way to solve this, but I for one hit the problem and went back to working on my long term goals 20 minutes later after coming up with the method I am presenting. So, maybe there is a better way running around, but since I keep seeing the same dialog, I thought I'd post how I chose to handle postable and/or modeless dialog command issues. It is a system that works pretty well for me because I can cue up stuff to happen, those things can do work, then cue up more stuff to happen and I've actually been able to nest that process 4 or 5 deep with no issues.

## My Idle Event
Yes, this is all of it:

```c#
private void UiApp_Idling(object sender, RUI.Events.IdlingEventArgs e)
{
  if (sender != null && DelegatedTasks.Cue.Count >= 1)
  {
    for (int i = 0; i < DelegatedTasks.Cue.Count; i++)
      { DelegatedTasks.Cue[i].Eval(sender as RUI.UIApplication); }
    DelegatedTasks.Cue = DelegatedTasks.Cue.Where(p => p.Completed == false).ToList();
  }
}
```

The above code is referencing a static class `DelegatedTasks` containing a static `List<DeferredRevitTask>` custom objects variable named Cue. I realize Queue would probably be more accurate, but I like meaningful mini variables. In this same class you *could* also add static void methods that take a UIApplication and a DefferedRevitTask as arguments. These methods represent the code you want to run later during an idle event. As a rule, you should make these static, but other than that any method taking those two arguments in that order should do. This means our "*out of context*" code only needs to know of a method that could perform the task they want done, but other than that, its work is finished as soon as it supplies that delegate to our static Cue variable. When Revit "can" do work and "if" your provided AwaitedAction conditions are met, then it will go do stuff…

***Note:*** The FOR loop is important. You wouldn't want to FOREACH through that list or else you wouldn't have the ability to cue up new tasks from within a delegated method.


## Deferred Tasks
```c#
public delegate void EvalEvent(RUI.UIApplication uiApp, DeferredRevitTask e);

public class DeferredRevitTask
{
  private EvalEvent Handler;
  public AwaitedActionBase Args = null;
  public bool Completed = false;
  
  public DeferredRevitTask(EvalEvent callback, AwaitedActionBase data)
  { Handler = callback; Args = data; }

  public void Eval(RUI.UIApplication app)
  {
    if (Args.isReady(app) == true)
    { Handler(app, this); }
  }
}

public abstract class AwaitedActionBase
{ 
  public List<object> Data = new List<object>();
  public int Interval = 0;
  public AwaitedActionBase() { }
  public abstract bool isReady(RUI.UIApplication app);
}

public class TimeAwaitedAction : AwaitedActionBase
{
  public DateTime Started = DateTime.Now;
  public TimeAwaitedAction(int TimeUntilExec, params object[] data)
  { Data.AddRange(data); Interval = TimeUntilExec; }

  public override bool isReady(RUI.UIApplication app)
  { return (DateTime.Now - Started).TotalMilliseconds >= Interval ? true : false; }
}

public class CountAwaitedAction : AwaitedActionBase
{
  public int Count = 0;
  public CountAwaitedAction(int ExecOnCountOf, params object[] data)
  { Data.AddRange(data); Interval = ExecOnCountOf; }

  public override bool isReady(RUI.UIApplication app)
  { return ++Count >= Interval ? true : false; }
}

public class FileAwaitedAction : AwaitedActionBase
{
  public string rvtPath = "";
  public FileAwaitedAction(string path, params object[] data)
  { Data.AddRange(data); rvtPath = path; }

  public override bool isReady(RUI.UIApplication app)
  { return app.ActiveUIDocument.Document.PathName == rvtPath ? true : false; }
}
```

So, a deferred task is nothing more than a callback, a completion status and some kind of AwaitedAction. The awaited actions were designed to let me wait for a time period, execute on the n'th idle event or to do work when a specific file has been activated. Here are some examples of their utility:

- Time, this can be useful for hourly NWC creation or to force a scheduled Sync & Save prior to when posting models are being built.
- Count, this I probably use the most in conjunction with postable commands so I can let Revit do what it was intended to do before I swoop in and enhance whatever I am trying to polish.
- File, this is useful if your trying to do work that requires another file to be opened temporarily and you want to pick up where you left off when the user closes out of that secondary file you activated.

All the AwaitedAction constructors have a required context value that helps them determine when they should fire, but they also have a completely optional number of other parameters you can feed into them. So, if you are doing something where you want to pass what was selected at the time the user clicked a button on your modeless dialog, then you can do that.  You can send them each in as individual pieces of information, as a list of INT or whatever. All that matters is that the delegate method you make to pick up the slack knows what you were planning to send it.

***Note:*** The EVAL method is in charge of running the `isReady` test on the Awaited Task's and will only execute their callback once the AwaitedTask criteria was met. It's super low overhead that doesn't seem to phase Revit in the slightest and it really shouldn't since its only ever executing while Revit is theoretically doing absolutely nothing.

## Deferred Methods
Here is an example method that immediately sets its completed status to true and then converts the data I passed; which was a list of all GroupType names prior to me using a postable command to LoadGroup from file. So, next I am getting a new list of GroupType's and then using WHERE Linq expression to find all the new ones, grabbing the last GroupType it found (that didn't already exist) , inserting it, ungrouping the inserted instance and finally deleting the GroupType source reference. If I had used the postable LoadGroup and the user didn't actually select something, then the GFL.COUNT wouldn't have been greater than 1, no work would have been performed and the status still would have been set to completed = True. Which means my idle event (shown above) would have removed this Cue'd Task whether it did work or not….. Exactly what I want so that I don't wind up with a bunch of cued tasks that will never do anything or worse one that do unintended things later...

```c#
internal static void GroupExploder(RUI.UIApplication app, DeferredRevitTask e)
{
  e.Completed = true;
  var existing = (IList<string>)e.Args.Data[0];
  var Doc = app.ActiveUIDocument.Document;
  var gfl = new RDB.FilteredElementCollector(Doc).OfClass(typeof(RDB.GroupType)).ToElements();
  gfl = gfl.Where(p => existing.Contains(p.Name) == false).ToList();
  if (gfl.Count >= 1)
  {
    using (RDB.Transaction tr = new RDB.Transaction(Doc, "GroupProccessor"))
    {
      tr.Start();
      Doc.Create.PlaceGroup(new RDB.XYZ(0, 0, 0), gfl.Last() as RDB.GroupType).UngroupMembers();
      Doc.Delete(gfl.Last().Id);
      tr.Commit();
    }
  }
}
```

## My Using Statments
The code above is using some shorthand using statements that generally make deep dark API's a little easier to work with, but without entirely losing the context of where something is being referenced from.

```c#
using System;
using System.Collections.Generic;
using System.Linq;
using RAT = Autodesk.Revit.Attributes;
using RDB = Autodesk.Revit.DB;
using RUI = Autodesk.Revit.UI;
```

## Wrap up
Like I said, this popped into my head immediately after realizing the problem I was facing. There may be other solutions, but what I have here is working quite well for me and I put stuff like (deferred tasks) this in a (shared) DLL of its own that all my actual Revit command DLL's (having the idle/deferred methods code) can just reference. I'd highly suggest doing something like that too.

Another intersting prospect, there is some kind of Revit arbitrary data store that I haven't fully investigated, but if it is the same store for all users (updated on sync), then theoretically I could potentially add another cue in there dedicated to cueing events for other users to do certain things for me....
