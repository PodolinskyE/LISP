;;;;   ������� 2-� ������ excel


(tbl|getdata 'tbl:src)

(db|getdata 'db:head 'db:data)
(setq missed '())

(setq newdata
(mapcar
  '(lambda (line / newline oldpoz df)	;(setq line (nth 13 (cdr db:data)))
     (setq oldpoz (db|gpar "old_POZ" line))
     (if (setq df (tbl|filter tbl:src (strcat "old_poz=" oldpoz)))
       (progn
	 (setq newline (db|spar line "old_����" (tbl|gpar (car df) (cadr df) "#����")))
	 (setq newline (db|spar newline "old_�" (tbl|gpar (car df) (cadr df) "#�")))
	 newline
	 )
       (progn
	 (setq missed (cons oldpoz missed))
	 line
	 )
       )
     )
  (cdr db:data)
  ))


(lst>excel (cons db:head newdata))




;;	�� ������� �� ������ ������� �� ������ ������� - � ������ �������
;; �� ���� ��������� �������� ��� �� ������� ��� �� ������ � ������ �������
;missed
;'("��-10" "327" "326" "207" "106" "377" "376" "340" "336" "227" "226" "225" "224" "172" "162" "152" "142" "135" "132" "116�" "116" "101�" "1" "5" "4" "3" "2" "179�" "365" "367" "�377" "328" "338" "339" "394" "RM55S01" "RM55S02" )


;;  ������ �������� - �� ������ ������  -  ��������� �� �� ���� � ����� �������






(setq AbsentInNewBase nil)
(setq ManyInNewBase nil)
;db:head
(mapcar
  '(lambda (line / srcoldpoz res)	;(setq line (nth 13 tbl:src))
     (setq srcoldpoz (car line))	;(setq srcoldpoz "�����.12")
     (setq res (db|filter (cdr db:data) (strcat "old_POZ=" srcoldpoz)))
     (cond
       ((= 1 (length res)) (princ))
       ((null res) (setq AbsentInNewBase (cons srcoldpoz AbsentInNewBase)))
       ((> (length res) 1) (setq ManyInNewBase (cons srcoldpoz ManyInNewBase)))
       )
     )
  (cdr tbl:src)
  )

;AbsentInNewBase
;("�����.14" "�����.13" "�����.12" "�����.11" "125" "�����.10" "86�" "11�" "12" "347 ����" "310(309)" "308" "306" "89" "67" "262�" "254-255" "102�" "130" "�����.09" "�����.08" "133�" "131�" "200" "307" "270" "269" "140" "137" "�����.07" "�����.06" "�����.05" "340��" "336��" "365(67�)" "367(89�)" "370" "348" "�������.04" "137��" "116��" "116���" "142��" "135��" "132��" "02" "01" "�������.03" "130" "172��" "162��" "152��" "106��" "101���" "�����.04" "�����.03" "376��" "02��" "01��" "�����.02" "��-2" "��-1" "229" "227��" "226��" "225��" "224��" "229" "�������.02" "250��" "207��" "�����.01" "198" "197" "283(383)" "284" "282" "281" "�������.01") 

