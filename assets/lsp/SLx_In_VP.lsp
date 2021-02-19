(command "undefine" "sl1")

(defun C:SL1 (/ ss ns cc ee oo sv)
  (setq ss (ssget "_I" '((0 . "MAPS_SOLID")))
	ns (ssadd)
	cc 0)
  (if (null ss)
    (setq ss (ssget '((0 . "MAPS_SOLID")))))
  (command nil)
  (repeat (sslength ss)
    (setq ee (ssname ss cc)
	  oo (vlax-ename->vla-object ee)
	  sv (if (null(vl-position (vlax-get-property oo 'ServiceName) sv)) (append sv (list (vlax-get-property oo 'ServiceName))) sv)
	  cc (+ cc 1)))
  (setq ss (ssget "_X" '((0 . "MAPS_SOLID")))
	cc 0)
  (repeat (sslength ss)
    (setq ee (ssname ss cc)
	  oo (vlax-ename->vla-object ee)	  
	  cc (+ cc 1))
    (if (vl-position (vlax-get-property oo 'ServiceName) sv)
      (setq ns (ssadd ee ns)))
    )
  (if (= (vla-get-ActiveSpace(vla-get-activedocument(vlax-get-acad-object))) 0)
    (command "ISOLATESELECTEDINVP" ns "")
    (command "MASKVIEW" ns "")
    )
  (princ)
  )

(command "undefine" "sl2")
(defun C:SL2 (/ ss ns cc ee oo sv)
  (setq ss (ssget "_I" '((0 . "MAPS_SOLID")))
	ns (ssadd)
	cc 0)
  (if (null ss)
    (setq ss (ssget '((0 . "MAPS_SOLID")))))
  (command nil)
  (repeat (sslength ss)
    (setq ee (ssname ss cc)
	  oo (vlax-ename->vla-object ee)
	  sv (if (null(vl-position (vlax-get-property oo 'ServiceName) sv)) (append sv (list (vlax-get-property oo 'ServiceName))) sv)
	  cc (+ cc 1)))
  (setq ss (ssget "_X" '((0 . "MAPS_SOLID")))
	cc 0)
  (repeat (sslength ss)
    (setq ee (ssname ss cc)
	  oo (vlax-ename->vla-object ee)	  
	  cc (+ cc 1))
    (if (vl-position (vlax-get-property oo 'ServiceName) sv)
      (setq ns (ssadd ee ns)))
    )
  (if (= (vla-get-ActiveSpace(vla-get-activedocument(vlax-get-acad-object))) 0)
    (command "HIDESELECTEDINVP" ns "")
    (command "HIDESELECTED" ns "")
    )
  (princ)
  )