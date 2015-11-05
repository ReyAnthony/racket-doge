;Doge generator
;Anthony REY
;5/11/15
#lang racket
(require racket/gui
         racket/draw)

;keywords definitions
(define (doge-keywords)
  '("such" "much" "so" "very"))
(define (wow)
  "wow")
(define (user-keywords)
  '("Anthony" "awesome" "great"
              "nice" "cool" "programming god"
              "lisper" "lambda" "C++ hater" "doge"))
(define (colors)
  '("red" "pink" "blue" "green" "yellow" "cyan"))

(define (random-word my-list)
  ;gives a random member from a list
  (car
   (shuffle
    (my-list))))

(define (make-sentence keyword)
  ;make a sentence 
  (string-append
   (random-word doge-keywords)
   " "
   keyword))

;TODO add max count
(define (make-sentences my-list)
  ;make a list of sentences
  (if (null? (my-list))
      ;return a list containing this message
      '("Empty set of keywords !")
      (cons (wow) ;else
            (map make-sentence
                 (shuffle (my-list))))))

(define doge
  (read-bitmap "plainDoge.jpg"))

;drawing on doge
(define text-target doge)
(define dc (new bitmap-dc% [bitmap text-target]))
(send dc set-font (make-font #:size 25 #:family 'decorative))

;actually drawing text
(for-each
 (lambda (kw)
     (send dc set-text-foreground (random-word colors))
     (send dc draw-text kw (random 700) (random 500)))
 (make-sentences user-keywords))

;frame
(define f (new frame%
               [label "racket-doge"]
               [width 700]
               [height 500]
               [style (list 'no-resize-border)]))
;canvas
(define my-canvas
  (new canvas% [parent f]
     [paint-callback
      (lambda (canvas dc)
        (send dc draw-bitmap doge 0 0))]))

(send f show #t)
