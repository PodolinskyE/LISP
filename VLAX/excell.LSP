	; ������� 2. ������ ����� Excel � ����������� COM � ���������� ������� � AutoCAD 
	; ��������� COM-����� AutoCAD - Microsoft Excel 2000
	; �.�.�������, 2002
	;
	; ������ ������������ ������� �� ������ �� ����� ����� Excel
	; ������������ ������� ����, ������� ���� � ������� ��������� �����
	; � ������� ��������� ����� ������ ���� ������ ���� ������ �����
	; (����� ������� TEXT ����������� ������ ���� �������)


(defun exc_com1	(/
		 tb_xls
		 hcell
		 hlet
		 oex
		 wkbs
		 awb
		 shs
		 mainsh
		 cell
		 nlines
		 ncolumns
		 table_items
		 i
		 j
		 row
		 pt0
		 widths
		 types
		 headers
		 xx1 xx2 yy1
		 ww
		 val
		 )

; ��� ����� Excel � ������� �����
  (setq	tb_xls	  "D:\\!! ACAD work folder\\������\\��� ���\\tst1.xlsx"
	sheetname "����1"
	) ;_ ����� setq

; ������ ����� �������� ������� � ������ ����
  (setq	hcell 8.0
	hlet 2.5
	) ;_ ����� setq
;
; ���������� ����� c Excel

  (vl-load-com)
  (setq oex (ex_set_connect))
; �������� ��������� ��������� Workbooks
  (setq wkbs (vlax-get-property oex "Workbooks"))
; ������� ���� (�����) � �������� ��������� �����
  (setq awb (vlax-invoke-method wkbs "Open" tb_xls))
  (if (not awb)
    (progn (alert (strcat "�� ��������� ���� " tb_xls)) (exit))
    ) ;_ ����� if

  
; ��������� ������ ������ 
  (setq shs (vlax-get-property awb "Worksheets"))
; �������� ��������� �� ���� � ������ ������   (manish)
  (vlax-for s shs
    (if	(= sheetname (vlax-get-property s "Name"))
      (setq mainsh s)
      ) ;_ ����� if
    ) ;_ ����� vlax-for
  
; ���� ������ ���� �� ���������, �� ��������� ������
  (if (not mainsh)
    (progn (alert (strcat "�� ��������� ���� " sheetname))
	   (exit)
	   ) ;_ ����� progn
    ) ;_ ����� if

  
;
; ������ �� ������ A1 ����� Excel ���������� ����� � ������� �������
;  ������������, ��� ����� ������ ����������
  (setq	cell
	 (vlax-variant-value
	   (vlax-invoke-method mainsh "Evaluate" "A1")
	   ) ;_ ����� vlax-variant-value
	) ;_ ����� setq
  (setq	nlines
	 (fix (vlax-variant-value (vlax-get-property cell "Value")))
	) ;_ ����� setq

  
; ������ ���������� �������� � ������� ������� ������������
;  (�� ������ B1 ����� Excel)
  (setq	cell
	 (vlax-variant-value
	   (vlax-invoke-method mainsh "Evaluate" "B1")
	   ) ;_ ����� vlax-variant-value
	) ;_ ����� setq
  (setq	ncolumns
	 (fix (vlax-variant-value (vlax-get-property cell "Value")))
	) ;_ ����� setq

  
;
; �������� ������ ��������� ������� (������ 2,3,4, ... Excel)
; ������ 2 - ������ �������� � ��
; ������ 3 - ��������� ��������
  (setq	table_items nil
	j 1
	) ;_ ����� setq
  (repeat (+ nlines 3)
    (setq row nil
	  j   (1+ j)
	  i   -1
	  ) ;_ ����� setq
    (repeat ncolumns
      (setq i (1+ i))
      (setq cell
	     (vlax-variant-value
	       (vlax-invoke-method
		 mainsh
		 "Evaluate"
		 (strcat (chr (+ i (ascii "A"))) (itoa j))
		 ) ;_ ����� vlax-invoke-method
	       ) ;_ ����� vlax-variant-value
	    ) ;_ ����� setq
      (setq row
	     (append
	       row
	       (list
		 (vlax-variant-value
		   (vlax-get-property cell "Value")
		   ) ;_ ����� vlax-variant-value
		 ) ;_ ����� list
	       ) ;_ ����� append
	    ) ;_ ����� setq
      );repeat ncolumns
    (setq table_items (append table_items (list row)))
    );repeat nlines
;
; ������� ����� Excel
  (ex_break_connect oex)
;
; ������ ����� ������ �������� ���� �������
  (setq pt0 nil)
  (while (null pt0)
    (setq pt0 (getpoint "\n����� ������ �������� ���� �������: "))
    );while
;
  (setq	widths (nth 0 table_items)
	types  (nth 1 table_items)
	) ;_ ����� setq
;
; ���������� ����� (������ ����� 8 ��)
  (tab_lines pt0 ncolumns nlines widths hcell)
;
; ��������� �������� �������
  (setq	headers	(nth 2 table_items)
	i	-1
	xx1	(car pt0)
	yy1	(- (cadr pt0) hcell)
	) ;_ ����� setq
  (repeat ncolumns
    (setq i   (1+ i)
	  ww  (nth i widths)
	  xx2 (+ xx1 ww)
	  ) ;_ ����� setq
    (setq val (nth i headers))
    
    (write_item val "str" xx1 xx2 yy1 hlet)
    (setq xx1 xx2)
    )					;
					;
					; ��������� �������
  (setq j 2)
  (repeat nlines
    (setq j   (1+ j)
	  i   -1
	  xx1 (car pt0)
	  yy1 (- (cadr pt0) (* (1- j) hcell))
	  ) ;_ ����� setq
    (repeat ncolumns
      (setq i	(1+ i)
	    ww	(nth i widths)
	    xx2	(+ xx1 ww)
	    ) ;_ ����� setq
      (setq val (nth i (nth j table_items)))
      (setq itype (nth i types))
      (write_item val itype xx1 xx2 yy1 hlet)
      (setq xx1 xx2)
      )					;repeat ncolumns
    )					;repeat nlines
					;
  (redraw)
  (princ)
  ) ;_ ����� defun




;-------------- ������������ -----------------
; ���������� ����� � Excel 2000
; ������������ �������� - VLA-������ ����������
(defun ex_set_connect (/ e)
  (setq e (vlax-get-or-create-object "Excel.Application"))
; ���� ����� �� �����������, �� �������� ��������� ������
  (if (null e)
    (progn
      (alert "������ ��������� Microsoft Excel")
      (exit)
      ) ;_ ����� progn
    );if
; ����� ������� Excel �������:
;;; (vlax-put-property e "Visible" :vlax-true)
;
; ������������ ��������
  e
  ) ;_ ����� defun



;---------------------------------------------
; ��������� ����� � Excel
(defun ex_break_connect	(e /)
  (vlax-invoke-method e "Quit")
  (vlax-release-object e)
  ) ;_ ����� defun


;-----------------------------------------------------------
; ������������ �������� �������, � �������� �� ������ ������
(defun write_item (item		; item  - �������
		   typ		; typ   - ��� ("int", "str", ...)
		   x1 x2	; x1,x2 - ��������� �������� ������
		   		; �������, � ������� ����� ������ �����
		   yi		; yi    - �������� ������ ������� ������
		   hl		; hl    - ������ ���� �������
		   /
		   gapx		; gapx - ������ �� X �� ����� � ������ ������ ������
		   gapy		; gapy - ������ �� Y �� ������ ������� ������
		   wi		; wi    - ������ ������
		   yig
		   st
		   siz
		   sizex
		   )
  (setq	gapx 1.0
	gapy 1.0
	wi   (- x2 x1)
	yig  (+ yi gapy)
	) ;_ ����� setq
  (if item
    (progn
;
; �������������� �������� item � �����, � ����������� �� �������
; �������� ���� "int" ����� ������������ ��� ������� �����
      (setq st
	     (if (= typ "int")
	       (itoa (fix item))
	       (vl-princ-to-string item)
	       ) ;_ ����� if
	    ) ;_ ����� setq
;
; ��������� ������ ������ (sizex - ������ �� �����������)
      (setq size (textbox (list (cons 1 st) (cons 40 hl))))
      (setq sizex (- (caadr size) (caar size)))
; ���� ����� ���������� � ������, �� ��������� ���
;  � ������������� �� ����� ������ �����
; ���� ����� �� ����������, �� ��������� ��� � ������ Fit (�� ������)
      (if (<= sizex (- wi (+ gapx gapx)))
	(command "_.TEXT" (list (+ x1 gapx) yig) hl 0.0 st)
	(command "_.TEXT"
		 "_F"
		 (list (+ x1 gapx) yig)
		 (list (- xx2 gapx) yig)
		 hl
		 st
		 ) ;_ ����� command
	)				;if
      )					;progn
    )					;if item
  );




;--------------------------------------
; ������������ ����� �������
(defun tab_lines (p0 nc nl wids h / w k xx yy htab)
					; p0  - ����� �������� ������ ���� �������
					; nc   - ���������� ��������
					; nl   - ���������� �����
					; wids - ������ ����� ��������
					; h    - ������ �����
					;
					; ���������� w - ������ ������ �������
  (setq	w 0.0
	k -1
	) ;_ ����� setq
  (repeat nc
    (setq k (1+ k)
	  w (+ w (nth k wids))
	  ) ;_ ����� setq
    ) ;_ ����� repeat
					;
					; �������������� �������
  (setq	xx (car p0)
	yy (cadr p0)
	) ;_ ����� setq
  (repeat (+ nl 2)
    (command "_.LINE" (list xx yy) (list (+ xx w) yy) "")
    (setq yy (- yy h))
    )					;repeat
					;
					; ������������ �������
  (setq	xx   (car p0)
	yy   (cadr p0)
	htab (* h (1+ nl))
	k    -1
	) ;_ ����� setq
  (command "_.LINE" (list xx yy) (list xx (- yy htab)) "")
  (repeat nc
    (setq k  (1+ k)
	  xx (+ xx (nth k wids))
	  ) ;_ ����� setq
    (command "_.LINE" (list xx yy) (list xx (- yy htab)) "")
    )					;repeat
  )					;defun