;    racket-doge
;    Copyright (c) 2015, Anthony REY

;   This program is free software: you can redistribute it and/or modify
;   it under the terms of the GNU General Public License as published by
;   the Free Software Foundation, either version 3 of the License, or
;   (at your option) any later version.

;   This program is distributed in the hope that it will be useful,
;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;   GNU General Public License for more details.

;   You should have received a copy of the GNU General Public License
;   along with this program.  If not, see <http://www.gnu.org/licenses/>.

#lang racket
(require racket/gui
         racket/draw)

;keywords definitions
(define doge-keywords
  '("such" "much" "so" "very"))
(define (wow)
  "Wow")
(define user-keywords
  '("purr" "claw" "hit" "cate" "mean"
           "bad" "cry"))
(define colors
  '("red" "magenta" "blue" "green" "yellow" "cyan" "white"))

(define (random-member my-list)
  ;gives a random member from a list
  (car
   (shuffle my-list)))

(define (make-sentence keyword)
  ;make a sentence 
  (string-append
   (random-member doge-keywords)
   " "
   keyword))

;TODO add max count
(define (make-sentences my-list)
  ;make a list of sentences
  (if (null? my-list)
      ;return a list containing this message
      '("Empty set of keywords !")
      ;else
      (cons (wow) 
            (map make-sentence
                 (shuffle my-list)))))

;frame
(define parent-frame
  (new frame%
       [label "racket-doge"]
       [width 700]
       [height 600]
       [style (list 'no-resize-border)]))

(define doge
  (read-bitmap "plainDoge.jpg"))

;canvas
(define main-canvas
  (new canvas% [parent parent-frame]
       [min-height 500]
       [paint-callback
        (lambda (canvas dc)
          (send dc draw-bitmap doge 0 0))]))

;horiz panel
(define horiz-panel
  (new horizontal-panel% [parent parent-frame]))

;setting up the text drawing on doge
;we will draw on doge
(define my-dc (new bitmap-dc% [bitmap doge]))
(define (set-font)
  (send my-dc set-font
      (make-font #:size (+ 20 (random 5))
                 #:family 'decorative
                 #:face "Comic Sans MS"
                 #:weight 'bold)))

(define (draw-text-with-keywords kwd) 
  ;draw the text on my-dc
  (for-each
   (lambda (kw)
     (set-font)
     (send my-dc set-text-foreground (random-member colors))
     (send my-dc draw-text kw (random 700) (random 500)))
   (make-sentences kwd)))

(define (draw-text)
  (draw-text-with-keywords user-keywords))

(draw-text)

;text edit
(define user-entries
  (new text-field%
       ;[enabled #f]
       [label "user-keywords :"]
       [init-value (string-join user-keywords ", ")]
       [parent horiz-panel]))

;buttons
(define gen-again
  (new button% [label "Generate again"]
       ;generate again
       [parent horiz-panel]
       ;[enabled #f]
       [callback
        (lambda (b e)
          (draw-text-with-keywords
           (string-split (send user-entries get-value) ", "))
          (send parent-frame show #t))]))

(define save
  (new button% [label "Save"]
       ;Save the bitmap to a file
       [parent horiz-panel]
       [callback
        (lambda (b e)
          (if
           (send doge save-file
                 "./generated_doge.jpg"
                 'jpeg)
           (print "Saved\n")
           (print "Failed to save\n")))]))

(send parent-frame show #t)
