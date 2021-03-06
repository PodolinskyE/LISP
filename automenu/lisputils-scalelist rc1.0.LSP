(vl-load-com)

(defun *autoresetscales-eng* (/)
  (vl-cmdf "_-scalelistedit" "r" "y" "e")
  )
(defun *autoresetscales-rus* (/)
  (vl-cmdf "_-scalelistedit" "�" "�" "�")
  )


(defun add-resetscales-button ( /
			       kd:itemtags
			       ctoolbars
			       toolbar
			       btn
			       bmppath
			       )
  (setq bmppath "d:\\release\\resetscales.BMP")

  (defun kd:itemtags (obj / oexd xr taglist)
    (setq taglist '())
    (vlax-for xr obj (setq taglist (append taglist (list (vla-get-name xr)))))
    taglist
    )



(setq ctoolbars (vla-get-Toolbars (vla-item (vla-get-MenuGroups (vlax-get-acad-object)) "custom")))
(setq toolbar
       (if (member "lisputils" (kd:itemtags ctoolbars))
	 (vla-item ctoolbars "lisputils")
	 (vla-add ctoolbars "lisputils")
	 )
      )
(vla-put-visible toolbar 1)
(if (null (member "resetscales" (kd:itemtags toolbar)))
    (progn
      (setq btn (vla-AddToolbarButton toolbar (vla-get-count toolbar)
	    "resetscales"						; ���������
	    "reset all scales in a drawing to default list"		; ���������
	    "(*autoresetscales-eng*) "					; ������ (����� ������)
	    ;"(*autoresetscales-rus*) "					; russian
	    :vlax-false							; ������� �������
	    ))
      (vla-put-CommandDisplayName btn "resetscales")
      (vla-SetBitmaps btn bmppath bmppath)
      )
    );if
  );defun

;(add-resetscales-button)

�������� ������� ����-���������, ��������� bmp, � ��������� � ������������