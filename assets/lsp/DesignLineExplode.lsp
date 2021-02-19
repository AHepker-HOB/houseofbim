;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Written by Josh Howard ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun DL:Explode (e / el cp ret)
  (setq el (entlast)
	cp (vlax-vla-object->ename(vla-copy(vlax-ename->vla-object e))))
  (command ".explode" cp "")
  (while (setq ne (entnext el))
    (setq ret (append ret (list ne))
	  el  ne))
  ret
  )

(defun DL:FindSource (lst / ret p10 cfd)  
  (foreach x lst
    (setq p10 (cdr(assoc 10(entget x)))
	  cfd nil)
    (foreach y lst
      (if (and (/= x y) (null cfd))
	(if (= (distance p10 (cdr(assoc 11(entget y)))) 0.0))
	  (setq cfd t))))
    (if (null cfd)
      (setq ret x))
    )
  ret
  )

(setq dls (ssname (ssget "_:S+." '((0 . "MAPS_DESIGN"))) 0)
      els (DL:Explode dls)
      spt (DL:FindSource els))
	 
  
  
     
  
	