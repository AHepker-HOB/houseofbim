(defun C:PipeNesting (/ ml kf cl cc ss fd la li name qty vlst cval ridx )  
  (setq ml (getreal "Enter Maxmimum (base drawing units) Pipe Length: ")
	kf (getreal "Enter the (base drawing units) Kerf deduction: ")
	cc 0)

  ;; Collect Pipe Info
  (command "showall")
  (mapfilter "#39 = 2041") ; Select Pipe
  (repeat (sslength (setq ss (ssget "_I")))
    (setq ee (ssname ss cc)
	  oo (vlax-ename->vla-object ee)
	  fd (vlax-get-property oo 'Description)
	  la (vlax-get-property oo 'LengthAngle)
	  cc (+ cc 1))
    (if (assoc fd cl)
      (setq li (assoc fd cl)
	    li (append li (list la))
	    cl (subst li (assoc fd cl) cl))
      (setq li (list fd la)
	    cl (append cl (list li)))
      )
    )

  ;; Process Pipe Info
  (foreach x (vl-sort cl '(lambda (a b) (< (car a) (car b))))
    (setq name (car x)
	  qty  0
	  vlst (vl-sort (cdr x) '>))
    (while (>= (length vlst) 1)
      (setq cval (car vlst)
	    ridx (list)
	    vlst (cdr vlst)
	    cc 0)
      (repeat (length vlst)
	(setq y (nth cc vlst))
	(if (<= (+ y cval kf) ml)
	  (setq ridx (append ridx (list cc))
		cval (+ y cval kf))
	  )
	(setq cc (+ cc 1))
	)
      (if (>= (length ridx) 1)
	(foreach i (reverse ridx)
	  (setq vlst (acet-list-remove-nth i vlst))))
      (setq qty (+ qty 1))
      )
    (princ (strcat "\nMinimum Required Lengths: "
		   (if (> qty 9) "" " ")
		   (itoa qty)
		   "\t "
		   name)
	   )
    )
  (sssetfirst) ; Unselect Pipe
  (princ)
  )