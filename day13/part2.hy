(import sys)

(defn putInPosition [layers currentPos goingUp delay]
    (when (not (= delay 0))
        (setv num_layers (+ (max (.keys layers)) 1))
        (for [j (range num_layers)]
            (when (in j (.keys layers))
                (setv size (get layers j))
                (if (= size 2)
                    (when (not (= 0 (% delay 2)))
                        (do
                            (assoc goingUp j False)
                            (assoc currentPos j 1)))
                    (do 
                        ; If more than 2 of size
                        (setv fullsize (* (dec size) 2))
                        (setv actualValue (% delay fullsize))
                        ; Set going up
                        (when (or (= actualValue size)
                                  (> actualValue size))
                            (assoc goingUp j False))
                        ; Set position
                        (if (> actualValue (dec size))
                            (assoc currentPos j (- fullsize actualValue))
                            (assoc currentPos j actualValue))))
            ))))

(defn move [layers currentPos goingUp]
    (setv num_layers (+ (max (.keys layers)) 1))
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

(defn cross [layers delay]
    (setv num_layers (+ (max (.keys layers)) 1))
    (setv currentPos (* [0] num_layers))
    (setv goingUp (* [True] num_layers))
    (putInPosition layers currentPos goingUp delay)
    (for [i (range num_layers)]
        ; Increase severity if needed
        (when (and (in i (.keys layers))
                   (= (get currentPos i) 0))
            (raise ValueError))
        ; Make positions progress
        (move layers currentPos goingUp))
    True)

(defn isCrossing [layers delay]
    (try
        (cross layers delay)
    (except [ValueError] False)))

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
    (setv delay 0)
    (while (not (isCrossing layers delay))
        (setv delay (inc delay)))
    (print delay))

(if (< (len sys.argv) 2)
    (print "Need an input")
    (processInput (get sys.argv 1)))
