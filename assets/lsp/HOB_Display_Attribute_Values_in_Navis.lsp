;	Written by Josh Howard
;	www.HouseOfBIM.com

(defun C:HOBConvert (/ ss b c o r a lst dlst clst)
  (defun CreateAttTextCopy (a b l / n txt)
    (foreach x l
      (if (= (car x) (vla-get-tagstring a))
	(setq txt (cadr x))))
    (setq n (vla-addtext b txt (vla-get-insertionpoint a) (vla-get-height a)))
    (vlax-ldata-put n "HOBText" "¥")
    (vla-put-alignment n (vla-get-alignment a))
    (vla-put-backward n (vla-get-backward a))
    (vla-put-layer n (vla-get-layer a))
    (vla-put-linetype n (vla-get-linetype a))
    (vla-put-lineweight n (vla-get-lineweight a))
    (vla-put-material n (vla-get-material a))
    (vla-put-normal n (vla-get-normal a))
    (vla-put-obliqueangle n (vla-get-obliqueangle a))
    (vla-put-rotation n (vla-get-rotation a))
    (vla-put-scalefactor n (vla-get-scalefactor a))
    (vla-put-stylename n (vla-get-stylename a))    
    (vla-put-thickness n (vla-get-thickness a))
    (vla-put-color n (vla-get-color a))
    (vla-put-upsidedown n (vla-get-upsidedown a))
    (vla-put-insertionpoint n (vla-get-insertionpoint a))
    (vl-catch-all-apply 'vla-put-textalignmentpoint (list n (vla-get-textalignmentpoint a)))    
    )

  (setq ss (ssget "_I" '((0 . "INSERT")))
	b  (vla-get-blocks(vla-get-activedocument(vlax-get-acad-object)))
	c  0)
  (if (null ss)
    (setq ss (ssget '((0 . "INSERT")))))

  (repeat (sslength ss)
    (setq o (vlax-ename->vla-object(ssname ss c))
	  c (+ c 1))
    (if (= (vla-get-hasattributes o) :vlax-true)
      (progn
	(if (/= (vl-string-search "*" (vla-get-name o)) 0.0)
	  (vla-ConvertToAnonymousBlock o)
	  )
	(setq dlst nil clst nil lst nil
	      r (vla-item b (vla-get-name o))
	      a (vlax-safearray->list(vlax-variant-value(vla-getattributes o))))

	(foreach x a
	  (setq lst (append lst (list(list (vla-get-tagstring x) (vla-get-textstring x)))))
	  (vla-put-visible x :vlax-false)
	  )

	(vlax-for x r
	  (if (= (vlax-ldata-get x "HOBText") "¥")
	    (setq dlst (append dlst (list x)))))
	(foreach x dlst (vla-delete x))

	(vlax-for x r
	  (if (= (vla-get-objectname x) "AcDbAttributeDefinition")
	    (progn
	      (setq clst (append clst (list x)))
	      (vla-put-visible x :vlax-false)
	      )
	    )
	  )

	(foreach x clst
	  (CreateAttTextCopy x r lst)
	  )	
	)
      )
    )
  (vlax-release-object b)
  (princ)
  )



(defun C:HOBReset (/ ss b c o r a dlst)
  (setq ss (ssget "_I" '((0 . "INSERT")))
	b  (vla-get-blocks(vla-get-activedocument(vlax-get-acad-object)))
	c  0)
  (if (null ss)
    (setq ss (ssget '((0 . "INSERT")))))

  (repeat (sslength ss)
    (setq o (vlax-ename->vla-object(ssname ss c))
	  c (+ c 1))
    (if (= (vla-get-hasattributes o) :vlax-true)
      (progn	
	(setq dlst nil
	      r (vla-item b (vla-get-name o))
	      a (vlax-safearray->list(vlax-variant-value(vla-getattributes o))))

	(foreach x a	  
	  (vla-put-visible x :vlax-true)
	  )

	(vlax-for x r
	  (if (= (vlax-ldata-get x "HOBText") "¥")
	    (setq dlst (append dlst (list x))))
	  )
	(foreach x dlst (vla-delete x))

	(vlax-for x r
	  (if (= (vla-get-objectname x) "AcDbAttributeDefinition")
	    (vla-put-visible x :vlax-true)
	    )
	  )
	)      
      )
    )    
  (vlax-release-object b)
  (princ)
  )
   