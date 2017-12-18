(load "split-sequence.lisp")
(defparameter *state* (make-hash-table :test 'equal))

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

(defun snd-instruction (arg)
    (setf (gethash 'sounds *state*)
        (append (gethash 'sounds *state*) (list (get-value arg)))))

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
    (if (= (get-value arg) 0)
        nil
        (progn (setf (gethash arg *state*) (nth 0 (last (gethash 'sounds *state*))))
               (setf (gethash 'sounds *state*) (reverse (cdr (reverse (gethash 'sounds *state*)))))
               (print (gethash arg *state*))
               (exit))))

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

(defun main (filename)
    (setf (gethash 'pc *state*) 0)
    (setf (gethash 'sounds *state*) '())
    (let ((lines (readfile filename)))
        (while (< (gethash 'pc *state*) (length lines))
            (handle-line (nth (gethash 'pc *state*) lines))
            (setf (gethash 'pc *state*) (+ (gethash 'pc *state*) 1))
            ;(display *state*)
            ;(print "---------------------")
            )))

(defun display (hash-table) 
    (loop for key being the hash-keys of hash-table
        for value being the hash-values of hash-table
          do (print (format nil "~a : ~a" key value))))

(main "input")
