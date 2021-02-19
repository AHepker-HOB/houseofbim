(defun SETSPOOLCOLOUR (ci ssi / scr pval file)
  (setq scr (strcat (getvar "Logfilepath") "HOB - Set Spool Color.cod")
	cl '(1 2 3 4 5 6 7 8 9 40))
  
  (setq file (open scr "w"))
  (setq si (strcat "item.spoolcolour = " (chr 34) (rtos(nth ci cl)) (chr 34)))
  (write-line si file)
  (close file)
  (executescript scr ssi)
  )

(defun HOB_SETCOLOR (ci ssi / e cl o ck)
  (setq cl '(1 2 3 4 5 6 7 8 35 95 155 215)
	ck 0)
  (repeat (sslength ssi)
    (setq e (ssname ssi ck)
	  o (vlax-ename->vla-object e)
	  ck (+ ck 1))
    (vlax-put-property o 'notes (rtos(nth ci cl)))
    )
  )

(defun C:HOB_SetSpoolColor (/ ss lst jsn c e o n l) ;Set Spool Color on all Spools
  (setq ss	(ssget "_X" '((0 . "MAPS_SOLID")))
	lst	(list)
	jsn	nil
	c	0
	cc	0)
  (repeat (sslength ss)
    (setq e (ssname ss c)
	  o (vlax-ename->vla-object e)
	  n (car(Get300s e (list "SPOOL")))
	  c (+ c 1))
    (if (null(assoc n lst))
      (setq jsn (append jsn (list n))))
    (if (assoc n lst)
      (setq l   (assoc n lst)
	    l   (cons n (list (append (cadr l) (list (cdr(assoc 5(entget e)))))))
	    lst (subst l (assoc n lst) lst))
      (setq lst (append lst (list(cons n (list (list (cdr(assoc 5(entget e)))))))))
      )
    )
  (setq lst (vl-sort lst '(lambda (a b) (< (car a) (car b)))))
  (foreach x lst
    (setq ss (ssadd)
	  ce 0)
    (if (and (vl-position (car x) jsn) (/= (vl-string-trim " " (vl-princ-to-string(car x))) ""))
      (foreach i (cdr x)
	(foreach ii i
	  (setq ss (ssadd (handent ii) ss))
	  )a 
	(HOB_SetColor cc ss)
	)
      )
    (if (>= cc 11)
      (setq cc 0)
      (setq cc (+ cc 1))
      )
    )
  (setq ss (ssget "_X" '((0 . "MAPS_SOLID"))))
  (executescript (findfile "KSI Automation - Notes to Spool Color.cod") ss)
  (command "setspoolcol" "all" "")
  (princ)
  )


; Get the status of a single object
(defun C:HOB_GetStatus (/ ent obj sta)
  (setq ent (car(entsel))
	obj (vlax-ename->vla-object ent)
	sta (vlax-get-property obj 'Status))
  (print (vl-string-trim " " sta))
  (princ)
  )

; Get a list of all object statuses in current drawing
(defun C:HOB_GetAllStatuses (/ ss stalist sta in ent obj)
  (setq	ss 	(ssget "_X" '((0 . "MAPS_SOLID")))
	stalist	nil
	sta	nil
	in	0)
  (if (and ss (> (sslength ss) 0))
    (repeat (sslength ss)
      (setq ent (ssname ss in)
	    obj (vlax-ename->vla-object ent)
	    sta (vl-string-trim " " (vlax-get-property obj 'Status))
	    in  (+ in 1)
	    )
      (if (not (member sta stalist))
	(setq stalist (cons sta stalist))
	)
      )
    (alert "There are no Autodesk Fabrication objects in the active drawing")
    )
  (foreach status (acad_strlsort stalist)
    (princ (strcat "\n" (vl-princ-to-string status)))
    )
  (princ)
  )

(defun C:HOB_ColorByStatus (/ InvStatusList InvStatuses in statuslist ss ent obj sta color)
  
  ; Set some variables for use later
  (setq	InvalidStatus	(ssadd)
	InvStatusList	nil
	InvStatuses	"\n\nInvalid Statuses:"
	in		0)
  
  ; Set a list of valid statuses
  (setq statuslist '(("0: Design" 20)
		     ("1: Draw Rev 1" 40)
		     ("2: Draw Rev 2" 60)
		     ("3: For Approval" 80)
		     ("4: Approved" 120)
		     ("5: Issued for Manufacture" 140)
		     ("6: Manufactured" 160)
		     ("7: Staked" 190)
		     )
	)
  
  ;Get selection set of all Fabrication parts
  (setq ss (ssget "_X" '((0 . "MAPS_SOLID"))))

  ; Check to see if the selection set is valid and not empty
  (if (and ss (> (sslength ss) 0))
    
  ; Iterate through selection set and get object's status
    (repeat (sslength ss)
      (setq ent (ssname ss in)
	    obj (vlax-ename->vla-object ent)
	    sta (vl-string-trim " " (vlax-get-property obj 'Status))
	    in  (+ in 1)
	    )
      
      ;Check to see if the object's status is part of the status list.
      (if (assoc sta statuslist)
	
	;IF TRUE, set color
	(progn
	  (setq color (car(cdr(assoc sta statuslist))))
	  (vla-put-Color obj color)
	  )
	
	;ELSE, add object to selection set and add status to list
	(progn
	  (setq InvalidStatus (ssadd ent InvalidStatus))
	  (if (not (member sta InvStatusList))
	    (setq InvStatusList (cons sta InvStatusList))
	    )
	  )
	)
      )
    (alert "There are no Autodesk Fabrication objects in the active drawing")
    )
  (command "regen")
      
  (if (> (length InvStatusList) 0)
    (progn
      (foreach status (acad_strlsort InvStatusList)
	(setq InvStatuses (strcat InvStatuses "\n" (vl-princ-to-string status)))
	)
      (alert (strcat "Some objects in the model have a Status that does not match the StatusList\nObjects with an invalid status are saved to the InvalidStatus selection set" InvStatuses))
      )
    )
  (princ)    
  )