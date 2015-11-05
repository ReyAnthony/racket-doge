;Doge generator
;Anthony REY
;5/11/15
#lang racket

;keywords definitions
(define (doge-keywords)
  '("such" "much" "so" "very"))
(define (wow)
  "wow")
(define (user-keywords)
  '("Anthony" "awesome" "great"
              "nice" "cool" "programming god"
              "lisper" "lambda" "C++ hater" "doge"))

;gives a random member from a list
(define (random-word my-list)
  (car
   (shuffle
    (my-list))))

;make a sentence 
(define (make-sentence keyword)
  (string-append
   (random-word doge-keywords)
   " "
   keyword))

;add max count
;make a list of sentences
(define (make-sentences my-list)
  (cons (wow)
        (map make-sentence
             (shuffle(my-list)))))

;print result
(for-each
 (lambda (value)
   (display value)
   (display "\n"))
 (make-sentences user-keywords))

