(load "split-sequence.lisp")
(defparameter *globalstate* (make-hash-table :test 'equal))
(defparameter *state* nil)

(defmacro while (condition &body body)
 (let ((block-name (gensym)) (done (gensym)))
  `(tagbody
      ,block-name
  (unless ,condition
   (go ,done))
  (progn
   ,@body)
  (go ,block-name)
  ,done)))

(defun string-is-num (string)
    (handler-case (progn (parse-integer string)
                t)  ; parse succeeded, discard it and return true (t)
    (sb-int:simple-parse-error ()
    nil)))  ; parse failed, return false (nil)

(defun readfile (filename)
    (with-open-file (stream filename)
        (loop for line = (read-line stream nil)
            while line
            collect line)))

(defun get-value (arg)
    (if (string-is-num arg) (parse-integer arg)
        (gethash arg *state* 0)))

(defun get-other-proc ()
    (if (string-equal (gethash 'current *globalstate*) "proc0")
        'proc1
        'proc0))

(defun get-other-proc-str ()
    (if (string-equal (gethash 'current *globalstate*) "proc0")
        "proc1"
        "proc0"))

(defun get-proc ()
    (if (string-equal (gethash 'current *globalstate*) "proc0")
        'proc0
        'proc1))

(defun swap-proc ()
    (print "SWAP")
    (setf (gethash 'current *globalstate*) (get-other-proc-str))
    (setf *state* (gethash (get-proc) *globalstate*))
    (setf (gethash 'pc *state*) (- (gethash 'pc *state*) 1)))

(defun snd-instruction (arg)
    (display *state*)
    (cond ((string-equal (get-other-proc-str) "proc0") ; proc1
            (setf (gethash 'counter *globalstate*) (+ 1 (gethash 'counter *globalstate*)))))
    (let ((otherproc (get-other-proc)))
            (setf (gethash 'buffer (gethash otherproc *globalstate*))
                (append (gethash 'buffer (gethash otherproc *globalstate*)) (list (get-value arg)))))
        )

(defun set-instruction (arg1 arg2)
    (setf (gethash arg1 *state*) (get-value arg2)))

(defun add-instruction (arg1 arg2)
    (setf (gethash arg1 *state*)
        (+ (get-value arg1)
           (get-value arg2))))

(defun mul-instruction (arg1 arg2)
    (setf (gethash arg1 *state*)
        (* (get-value arg1)
           (get-value arg2))))

(defun mod-instruction (arg1 arg2)
    (setf (gethash arg1 *state*)
        (mod (get-value arg1)
             (get-value arg2))))

(defun rcv-instruction (arg)
    (if (gethash 'buffer *state*)
        (progn (setf (gethash arg *state*) (first (gethash 'buffer *state*)))
               (setf (gethash 'buffer *state*) (cdr (gethash 'buffer *state*))))
        (swap-proc))
    )

(defun jgz-instruction (arg1 arg2)
    (if (> (get-value arg1) 0)
        (setf (gethash 'pc *state*)
            (- (+ (gethash 'pc *state*) (get-value arg2))
               1))
        nil))

(defun handle-line (line)
    (let ((splitted (split-sequence:SPLIT-SEQUENCE #\Space line)))
        (let ((instruction (first splitted)))
            (cond ((string-equal instruction "snd") (snd-instruction (second splitted)))
                  ((string-equal instruction "set") (set-instruction (second splitted) (third splitted)))
                  ((string-equal instruction "add") (add-instruction (second splitted) (third splitted)))
                  ((string-equal instruction "mul") (mul-instruction (second splitted) (third splitted)))
                  ((string-equal instruction "mod") (mod-instruction (second splitted) (third splitted)))
                  ((string-equal instruction "rcv") (rcv-instruction (second splitted)))
                  ((string-equal instruction "jgz") (jgz-instruction (second splitted) (third splitted)))
                  (t 'UNKNOWN)))))

(defun both-blocked ()
    nil)

(defun main (filename)
    (setf (gethash 'current *globalstate*) "proc0")
    (setf (gethash 'counter *globalstate*) 0)
    (setf (gethash 'proc0 *globalstate*) (make-hash-table :test 'equal))
    (setf (gethash 'proc1 *globalstate*) (make-hash-table :test 'equal))
    (setf (gethash 'pc (gethash 'proc0 *globalstate*)) 0)
    (setf (gethash 'pc (gethash 'proc1 *globalstate*)) 0)
    (setf (gethash 'blocked (gethash 'proc0 *globalstate*)) nil)
    (setf (gethash 'blocked (gethash 'proc1 *globalstate*)) nil)
    (setf (gethash "p" (gethash 'proc0 *globalstate*)) 0)
    (setf (gethash "p" (gethash 'proc1 *globalstate*)) 1)
    (setf (gethash 'buffer (gethash 'proc0 *globalstate*)) '())
    (setf (gethash 'buffer (gethash 'proc1 *globalstate*)) '())
    (setf *state* (gethash 'proc0 *globalstate*))
    (let ((lines (readfile filename)))
        ;(while (not (both-blocked))
        (while (< (gethash 'pc *state*) (length lines))
            (handle-line (nth (gethash 'pc *state*) lines))
            (setf (gethash 'pc *state*) (+ (gethash 'pc *state*) 1))
            (print "+++++++++++++++++")
            (display *globalstate*)
            ;(print "+++++++++++++++++")
            ;(print (gethash 'current *globalstate*))
            ;(display *state*)
            (print "---------------------")
            )))

(defun display (hash-table) 
    (loop for key being the hash-keys of hash-table
        for value being the hash-values of hash-table
          do (print (format nil "~a : ~a" key value))))

(main "input")
(print "********************end**********************")
(display *state*)
(display *globalstate*)
