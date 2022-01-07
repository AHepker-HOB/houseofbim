



(defun c:CCExample (/ fileDir scr dwgList file)
  (vl-load-com)
  (setq fileDir (acet-ui-pickdir) 			  						;;;User Selects File Directory
	scr (getfiled "Select a Script File" "" "scr" 0)  						;;;User Selects Script File
	dwgList (vl-directory-files fileDir "*.dwg" 1)   						;;;Gets all DWG's in fileDir
	)
  (foreach dwg dwgList
    (setq file (strcat fileDir "\\" dwg)		  						;;;Attach directory path to DWG name
	  )
    (command "start" (strcat "accoreconsole.exe /i " "\"" file "\"" " /s " "\"" scr "\"" " /l en-US"))  ;;;Run the script on each dwg through core console
    )
  (princ)
  )






