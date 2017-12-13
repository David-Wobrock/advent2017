(import sys)

(defn cross [layers]
    (setv num_layers (+ (max (.keys layers)) 1))
    (setv severity 0)
    (setv currentPos (* [0] num_layers))
    (setv goingUp (* [True] num_layers))
    (for [i (range num_layers)]
        ; Increase severity if needed
        (when (and (in i (.keys layers))
                   (= (get currentPos i) 0))
            (setv severity (+ severity
                              (* i (get layers i)))))
        ; Make positions progress
        (for [j (range num_layers)]
            (when (in j (.keys layers))
                (cond
                    [(and (= (get goingUp j) True)
                          (= (get layers j) (inc (get currentPos j))))
                     (do (assoc goingUp j False)
                         (assoc currentPos j (dec (get currentPos j))))]
                    [(= (get goingUp j) True)
                     (do (assoc currentPos j (inc (get currentPos j))))]

                    [(and (= (get goingUp j) False)
                          (= 0 (get currentPos j)))
                     (do (assoc goingUp j True)
                         (assoc currentPos j (inc (get currentPos j))))]
                    [(= (get goingUp j) False)
                     (do (assoc currentPos j (dec (get currentPos j))))]
                )
            )))
    (print severity))

(defn processInput [input]
    (setv layers {})
    (with [f (open input)]
        (for [line f]
            (setv tuple
                    (-> line
                        (.strip)
                        (.split ": ")))
                (assoc
                    layers
                    (int (get tuple 0))
                    (int (get tuple 1)))))
    (cross layers))

(if (< (len sys.argv) 2)
    (print "Need an input")
    (processInput (get sys.argv 1)))
