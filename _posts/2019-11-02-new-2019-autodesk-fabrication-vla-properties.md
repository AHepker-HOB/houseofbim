---
layout: post
title: New 2019 Autodesk Fabrication VLA Properties
date: 2019-11-02 13:36
author: Josh Howard
comments: true
categories: [Fabrication CADmep, Lisp]
---
We received a lot of important (albeit hidden) tools In the 2019 release of Fabrication/CADmep. Most notably with the object enabler. Even standard users have probably noticed new (important) properties like ***ItemSpoolName*** showing up in Navisworks. What may not have realized is that they made some important properties programmatically Read/Write.

Until recently, the only property we could write to was the Notes property. Which I abused on an extremely disgusting level to pass information to and from COD scripts. While this was great, it was not ideal. In our workflows, we use a ton of custom data. So, Autodesk giving us Read/Write access to the entirety of our Custom Data from VLA is a very big deal. Quite literally the only thing I would actually care about, that wasn't made writeable was "Status" and I hope they rectify that in the future.

Currently, we can write to the Notes, ItemSpoolName and CustomData VLA properties. Again, for us the Custom Data was a huge deal. However, I will admit it's a super ugly string based list and you will have to take special care to parse the original values, make your changes and send it back formatted the way you found it. I'll provide something to help you accomplish that as a take away, but as a general rule you should never use the comma or equal symbols in those fields if you want this to work properly.

## ItemSpoolName Example
No more writing COD scripts to dynamically set/change a spool name, no more dynamically writing them to push a Line Number into a custom data field. Now we just go direct using a simple VLAX-PUT-PROPERTY lisp function. Here is a quick baseline of how this would work

```lisp
(setq ent (car(entsel))
(setq obj (vlax-ename->vla-object ent)
(vlax-put-property obj 'ItemSpoolName "MyJob-L2-CHW-001")
```

First we get an entity, then we cast that entity to a vla-object and finally we send our value to the ItemSpoolName property. There is a degree of overhead associated with casting ENames to VLA-Objects, but our tests have proven that a VLAX-FOR on the modelspace object is SUPER fast because it doesn't do any casting. In fact, if you do need to cast, it is better to cast down from the VLA-Object to an EName than it is to cast up. An example of this would be to create a selection set that still needs to be fed into a COD script.

## CustomData Example
Below are some functions designed to read/write to specific custom data fields. We tend to work with highly validated and information driven piping systems. So, we use something like this quite extensively and have various types of reporting associated with those fields. Once upon a time, we had to do all kinds of fancy tricks with the Notes property and COD scripts, but now we can go direct and it has been a very noticeable performance boost for us.

```lisp
(defun HOB:CustomData:Parse ( str )
  (mapcar
    '(lambda (x)
       (mapcar
	 '(lambda (y) (vl-string-trim " " y))
	 (acet-str-to-list "=" x)
	 )
       )
    (acet-str-to-list "," (vl-string-trim ", " str))
    )
  )

(defun HOB:CustomData:Join ( lst / res )
  (setq res "")
  (foreach x lst
    (setq res (strcat res (nth 0 x) " = " (nth 1 x) ","))
    )
  res
  )

(defun HOB:GetCustomData ( obj index / cdl )
  (setq cdl (HOB:CustomData:Parse (vlax-get-property obj 'CustomData)))
  (if (= (type index) 'STR)
    (cdr(assoc index cdl))
    (cdr(nth index cdl))
    )
  )

(defun HOB:SetCustomData ( obj index value / cdl nv )
  (setq cdl (HOB:CustomData:Parse (vlax-get-property obj 'CustomData)))
  (if (= (type index) 'STR)
    (setq nv (list index (vl-princ-to-string value))
	  nv (subst nv (assoc index cdl) cdl))
    (setq nv (list (car(nth index cdl)) (vl-princ-to-string value))
	  nv (subst nv (nth index cdl) cdl))
    )
  (vlax-put-property obj 'CustomData (HOB:CustomData:Join nv))
  )
```


To use the functions above, you will need to reference the ItemSpoolName example for creating a VLA Object from an entity name and pass that as the first argument to the Get or Set functions. The Index argument is dynamic, you can either specify the ***exact*** custom data string name or the integer index of where you expect it to appear. These integer indexes are NOT the number you've assigned in the fabrication interface, these are the zero-based location of what you would see in your standard AutoCAD properties palette.

Refer to my original post on [Fabrication Scripting & VLA Notes Property]{% post_url 2017-01-30-fabrication-scripting-vla-notes-property %} for a good example of writing to the Notes property.

The performance gains of leveraging more VLA instead of COD and DXF have been very substantial. I would highly recommend people with similar skills explore this with more depth. I'll save you some time trying to figure out how to create/convert VLA selections into SelectionSets; from what I can tell, you can't. However, the note above about the downcast being a better direction does help. Your essentially better off making traditional SelectionSets from VLA Objects with Vlax-Vla-Object->Ename instead of the other way around.
