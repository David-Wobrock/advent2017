(define (read-lines . args)
     (let ((p (cond ((null? args) (current-input-port))
                    ((port? (car args)) (car args))
                    ((string? (car args)) (open-input-file (car args)))
                    (else (error 'read-lines "bad argument")))))
          (let loop ((line (read-line p)) (lines (list)))
               (if (eof-object? line)
                   (begin (if (and (pair? args) (string? (car args)))
                       (close-input-port p))
                       (reverse lines))
                   (loop (read-line p) (cons line lines))))))

(define (str-split str ch)
 (let ((len (string-length str)))
  (letrec
   ((split
     (lambda (a b)
      (cond
       ((>= b len) (if (= a b) '() (cons (substring str a b) '())))
       ((char=? ch (string-ref str b)) (if (= a b)
           (split (+ 1 a) (+ 1 b))
           (cons (substring str a b) (split b b))))
       (else (split a (+ 1 b)))))))
   (split 0 0))))

(define (maximum L)
    (if (null? (cdr L))
        (car L)
        (if (< (car L) (maximum (cdr L)))
           (maximum (cdr L))
           (car L))))

(define (find-component components num)
    (filter (lambda (c) (contains-num? c num))
            components))

(define (contains-num? component num)
    (let ((splitted (str-split component #\/)))
        (or (= (string->number (first splitted))
               num)
            (= (string->number (second splitted))
               num))))

(define (get-remaining-components components component)
    (filter (lambda (c) (not (string=? c component)))
            components))

(define (get-other-number component start-num)
    (let ((splitted (str-split component #\/)))
        (if (= (string->number (first splitted))
               start-num)
            (string->number (second splitted))
            (string->number (first splitted)))))

(define (get-value component)
    (let ((splitted (str-split component #\/)))
        (+ (string->number (first splitted))
           (string->number (second splitted)))))

; Depth first search
(define (dfs components start-num)
    (let ((start-components (find-component components start-num)))
        (if (null? start-components)
            0
            (maximum (map (lambda (component)
                                    (+ (dfs
                                        (get-remaining-components components component)
                                        (get-other-number component start-num))
                                       (get-value component)))
                                start-components)))))

(define result
    (let ((components (read-lines "input")))
         (dfs components 0)))
