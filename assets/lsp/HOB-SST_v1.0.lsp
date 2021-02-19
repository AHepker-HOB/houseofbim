(vl-load-com)
(defun HOB:SST (Title Headers oData Corner Width AutoSize ShowBorders / rCount cCount Weights cSpace ri Data cc sum obj ci val)
  (setq rCount  (length oData)
	cCount  (length Headers)
	Width   (float Width)
	Headers (mapcar 'vl-princ-to-string Headers)
	Weights (mapcar 'strlen Headers)
	ri      2
	cSpace  (if (= (vla-get-activespace(vla-get-activedocument(vlax-get-acad-object))) 1)
		  (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object)))
		  (vla-get-paperspace(vla-get-activedocument(vlax-get-acad-object)))))
  
  
  (if (= cCount 0)
    (setq cCount (length(car oData))))
  (if (< Width cCount) ; Fixes possible error - Seems to want at least 1 unit available per column
    (setq Width cCount))
  (foreach entry oData
    (setq Data (append Data (list (mapcar 'vl-princ-to-string entry)))))
  (foreach entry Data
    (if (null Weights)
      (setq Weights (mapcar 'strlen entry))
      (progn
	(setq cc 0)
	(repeat cCount
	  (if (<= (- (length entry) 1) cCount)
	    (if (> (strlen (nth cc entry)) (nth cc Weights))
	      (setq Weights (acet-list-put-nth (strlen (nth cc entry)) Weights cc))))
	  (setq cc (+ cc 1))))))
  
  (setq sum (apply '+ Weights)
	Weights (mapcar '(lambda (x) (/ (float x) (float sum))) Weights)
	obj (vla-addtable cSpace (vlax-3d-point Corner) (+ 2 rCount) cCount 0.01 (/ Width cCount)))
  
  (if (null Headers)
    (progn
      (vla-deleterows obj 1 1)
      (setq ri (- ri 1)))
    (progn
      (setq cc 0)
      (repeat (length Headers)
	(if (/= (nth cc Headers) "nil")
	  (vla-SetText obj 1 cc (vl-princ-to-string (nth cc Headers))))
	(setq cc (+ cc 1)))
      )
    )
  
  (if (null Title)
    (progn
      (vla-deleterows obj 0 1)
      (setq ri (- ri 1)))
    (vla-SetText obj 0 0 (vl-princ-to-string Title))
    )
  
  (foreach entry Data
    (setq ci 0)
    (repeat (length entry)
      (if (>= (- cCount 1) ci)
	(if (/= (nth ci entry) "nil")
	  (vla-SetText obj ri ci (vl-princ-to-string (nth ci entry)))))	
      (setq ci (+ ci 1))
      )
    (setq ri (+ ri 1))
    )

  (setq cc 0)
  (if AutoSize    
    (repeat cCount
      (setq val (* (vla-get-width obj) (nth cc Weights)))
      (vla-SetColumnWidth obj cc (if (= val 0.0) 0.0001 val))
      (setq cc (+ cc 1))))

  (vla-SetGridVisibility obj 63 7 (if ShowBorders :vlax-true :vlax-false))  

  (vla-put-width obj Width)  
  (vla-update obj)
  
  (vlax-vla-object->ename obj)
  )







;Usage example
(defun C:HOBExample (/ lst hdr old)
  (setq hdr (list	0	1	0	1	0	1	0)
	lst (list
	      (list "#"  nil  nil  nil  "#"  nil  "#"  "#"  "#"  "#"  "#"  nil  "#"  "#"  "#"  "#"  nil)
	      (list "#"  nil  nil  nil  "#"  nil  "#"  nil  nil  nil  "#"  nil  "#"  nil  nil  nil  "#")
	      (list "#"  nil  nil  nil  "#"  nil  "#"  nil  nil  nil  "#"  nil  "#"  nil  nil  nil  "#")
	      (list "#"  "#"  "#"  "#"  "#"  nil  "#"  nil  nil  nil  "#"  nil  "#"  "#"  "#"  "#"  nil)
	      (list "#"  nil  nil  nil  "#"  nil  "#"  nil  nil  nil  "#"  nil  "#"  nil  nil  nil  "#")
	      (list "#"  nil  nil  nil  "#"  nil  "#"  nil  nil  nil  "#"  nil  "#"  nil  nil  nil  "#")
	      (list "#"  nil  nil  nil  "#"  nil  "#"  "#"  "#"  "#"  "#"  nil  "#"  "#"  "#"  "#"  nil))
	)

  (HOB:SST "Stuff... and Things!" hdr lst (getpoint) 0 t t)
  (HOB:SST "Stuff... and Things!" hdr lst (getpoint) 0 t nil)
  (HOB:SST "Stuff... and Things!" nil lst (getpoint) 20 t t)
  (HOB:SST nil nil lst (getpoint) 0 t t)
  (princ)
  )