;;;; unittest framework
;;;; original designed by Peter Seibel (Practical Common Lisp)
(provide :unittest)
(defpackage :unittest
  (:use :common-lisp)  ; cl パッケージのシンボルを全部インポートして使えるようにする
  (:export :deftest
	   :check)) ; deftest シンボルを API として公開する

(in-package :unittest)

(defvar test-name nil)

(defmacro deftest (name params &body body)
  `(defun ,name ,params
     (let ((test-name (append test-name `(,',name))))
       ,@body)))

(defmacro check (&body forms)
  `(combine-results
    ,@(mapcar (lambda (_)
		`(report-result ,_ ',_))
	      forms)))

(defmacro combine-results (&body forms)
  (let ((_result (gensym)))
    `(let ((,_result t))
       ,@(mapcar (lambda (_)
		   `(unless ,_ (setf ,_result nil)))
		 forms)
       ,_result)))

(defun report-result (result form)
  (format t "~:[FAIL~;pass~] ... ~a: ~a~%" result test-name form))
