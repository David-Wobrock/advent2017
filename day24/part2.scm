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

(define (get-strength bridge)
    (reduce + 0
            (map (lambda (c) (get-value c)) bridge)))

(define (flatten arr)
    (cond ((null? arr) '())
          ((not (pair? (first arr))) (list arr))
          (else (append (flatten (car arr))
                        (flatten (cdr arr))))))

(define (keep-longuests arr)
    (let ((longuest-len (maximum (map (lambda (b) (length b)) arr))))
       (filter (lambda (b)
            (= (length b) longuest-len))
            arr)))

(define (keep-longuest-and-strongest arr)
    (if (null? arr)
        '()
        (let ((longests (keep-longuests arr)))
            (let ((strongest-val
                  (maximum (map (lambda (b) (get-strength b))
                               longests))))
               (first (filter (lambda (b)
                       (= (get-strength b) strongest-val))
                    longests))))))

(define (get-longuest-bridge components start-num)
    (let ((start-components (find-component components start-num)))
        (if (null? start-components) ; cannot be longer
            '()
            (keep-longuest-and-strongest
                (map (lambda (c)
                    (append (list c)
                        (get-longuest-bridge
                            (get-remaining-components components c)
                            (get-other-number c start-num))))
                     start-components)))))

(define result
    (let ((components (read-lines "input")))
            (get-strength (get-longuest-bridge components 0))))
