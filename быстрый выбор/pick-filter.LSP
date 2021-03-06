; 13_03_12
; �� ������� ������ ... �� �����
; 13_06_28
;(load (strcat #lisppath "common functions\\lst-to-ss.LSP"))


;;;;;;;; �������  vl-catch-all-apply
;;;(defun g:kd:get-src-field ( / hand err)
;;;  (setq hand (kfl-get-xrecdata (vlax-ename->vla-object (car (nentsel))) #kflsrcID))
;;;  (setq err (vl-catch-all-apply 'vla-handletoobject (list #actdoc hand)))
;;;  (if (= (type err) 'VLA-OBJECT)
;;;    (command "_zoom" "_o" (vlax-vla-object->ename err) "")
;;;    (princ (strcat (vl-catch-all-error-message err) "\n" "������ � handle \"" hand "\" ��� ������ �� �����"))
;;;    )
;;;  (princ)
;;;  );defun





(defun c:fltr (/ ss lst)
  (vla-startundomark #actdoc)
  ;(acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0"osmode" 0)T))
  (if (not (setq lst (ssget "_I"))) (setq lst (vl-catch-all-apply 'ssget)))
  (cond
    ((= 'VL-CATCH-ALL-APPLY-ERROR (type lst)) (VL-CATCH-ALL-ERROR-MESSAGE lst))
    ((null lst) (princ))
    ((= 'PICKSET (type lst))
     (setq lst (ss->lsto* lst))
     (setq lst (pf:filter-list-of-objects lst))
     (princ)
     (sssetfirst nil (lst-to-ss lst))
     )
    );cond
  ;(acet-error-restore)
  (vla-endundomark #actdoc)
  );defun




;;;  (setq	assoc-list
;;;	 '(
;;;	   ("���-�������" 0)
;;;	   ("����������" 1)
;;;	   ("�����-��������" 360)
;;;	   ("���-�����" 2)
;;;	   ("���-�����" 6)
;;;	   ("����" 8)
;;;	   ("�����-�������" 10)
;;;	   ("Y=Y" 11)
;;;	   ("������-������-������" 40)
;;;	   ("�������-������" 41)
;;;	   ("�������" 48)
;;;	   ("�������-������" 50)
;;;	   ("����" 62)
;;;	   ("�������-����������" 66)
;;;	   ("��������-������������" 71)
;;;	   ("��������-������" 72)
;;;	   ("�������-�����-�100" 370)
;;;
;;;	   )
;;;	);setq




(defun pf:filter-list-of-objects (lst
				  /
				  formatstringforkword
				  samplobj
				  list-of-properties
				  fltrdata
				  wval
				  ;PICKFILTER_fuzz
				  )
  (princ "\n TO CHANGE -  !PICKFILTER_fuzz ")
  (if (null PICKFILTER_fuzz) (setq PICKFILTER_fuzz 0.1))
  (defun formatstringforkword (str)
    (VL-LIST->STRING (subst 45 32 (subst 45 95 (VL-STRING->LIST (any-to-string str)))))
    );defun
  
  (setq
    list-of-properties
     '(
       ;;;;;;;;;;;;     common
       "ObjectName"
       "Layer"
       "Linetype"
       "LinetypeScale"
       "Lineweight"
       "Color"
       ;;;;;;;;;;;;     line
       ;Angle
       ;Delta
       ;Length
       ;;;;;;;;;;;;     insert
       "EffectiveName"
       ;text
       "TextString"
       "StyleName"
       ;Rotation
       ;Height
       "Length"
       )
    )

  
  (while (null (setq samplobj (entsel))) (princ "\n object was not selected, please, try again..."))
  (setq samplobj (vlax-ename->vla-object (car samplobj)))

  ;;;;  ����� ������� �������� ������� �� � �������-�������
  (setq list-of-properties (vl-remove-if-not '(lambda (x) (vlax-property-available-p samplobj x)) list-of-properties))


  ;��������� �������� ������ ��� �����
  (setq list-of-properties (append list-of-properties (list "WCMATCH" )))
  ;(setq list-of-properties (append list-of-properties (list "FIELDED" )))

  
  (setq
    list-of-properties
     (mapcar
       '(lambda (p / tmp)
	  (cond
	    ((vlax-property-available-p samplobj p)
	     (list (strcat p "=" (formatstringforkword (vlax-get-property samplobj p))) p (vlax-get-property samplobj p)))
	    ((= p "WCMATCH") (list p p p))
	    ;((= p "FIELDED") (list p p p))
	    )
	  )
       list-of-properties)
    )
  
  ;(setq list-of-properties (vl-remove-if 'null list-of-properties))



;;;  (append
;;;    list-of-properties
;;;    (list (list "strWCMATCH" "pf:getstrprop" "pf:getstr"))
;;;    )
  


  
  ;(setq tmp (car (kd:dclget '("*WCMATCH*"))))
  
  (setq fltrdata (cdr (assoc (kw:pick-from-list (mapcar 'car list-of-properties)) list-of-properties)))
	


  ;(setq x (vlax-ename->vla-object (car (entsel))))
  
  (cond
    ;"WCMATCH"
    ((= (car fltrdata) "WCMATCH")
     (setq wval (car (kd:dclget '("�WCMATCH�"))))
     (vl-remove-if-not
       '(lambda (x)
	  (and
	    (member (vla-get-ObjectName x) '("AcDbText" "AcDbMText" "AcDbMLeader"))
	    (wcmatch (vla-get-TextString x) wval)
	    )
	  )
       lst
       )
     )
;;;    ;"FIELDED"
;;;    ((= (car fltrdata) "FIELDED")
;;;     (vl-remove-if-not
;;;       '(lambda (x)
;;;
;;;	  (kfl:isfieldable)
;;;
;;;	  
;;;	  (and
;;;	    (member (vla-get-ObjectName x) '("AcDbText" "AcDbMText" "AcDbMLeader"))
;;;	    (wcmatch (vla-get-TextString x) wval)
;;;	    )
;;;	  )
;;;       lst
;;;       )
;;;     )
    ;"LENGTH"
    ((= (car fltrdata) "Length")
     (vl-remove-if-not
       '(lambda (x)	;(setq x (vlax-ename->vla-object (car (entsel))))
	  (princ (cadr fltrdata))
	  (and
	    (member (vla-get-ObjectName x) '("AcDbPolyline" "AcDbLine"))
	    (< (abs (- (cadr fltrdata) (vla-get-Length x))) PICKFILTER_fuzz)
	    )
	  )
       lst
       )
     )


    
    ;PROPERTY
    (T
     (vl-remove-if-not
       '(lambda (x)
	  (and
	    (vlax-property-available-p x (car fltrdata))
	    (= (cadr fltrdata) (vlax-get-Property x (car fltrdata))))
	  ) lst)
     )
    )
  );defun