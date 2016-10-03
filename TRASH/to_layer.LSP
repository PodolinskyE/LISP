;;(defun c:to-layer (nowset / my_set)

(defun begin_activex ()
  (vl-load-com)
  (setq acad_application (vlax-get-acad-object))
  (setq active_document (vla-get-activeDocument acad_application))
  (setq model_space (vla-get-modelSpace active_document))
  (setq paper_space (vla-get-paperSpace active_document))
)



(defun c:to-layer ()

; (begin_activex)


  
  (setq my_set (ssget))
  

;(setq my_set (vlax-get-acad-object))


  
  (if (not (tblobjname "layer" "���������"))
    (command "_.-layer" "_new" "���������" "_color" "161" "���������" "")  ;; Create ��������� if needed
  );if

; (vla-put-layer my_set "���������" )


  
  (command "_.-layer" "_set" "���������" "")
;  (command "_.chprop" (nowset) "" "_lay" "���������" "")
  (command "_.chprop" my_set "" "_lay" "���������" "")
  (command "_.-layer" "_freeze" "*" "")

(setq my_set nil)
)


;	(defun c:yh ()
;	  (setq yh 38)
;	)