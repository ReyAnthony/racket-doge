;    racket-doge
;    Anthony REY
;    5/11/15

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
(define (doge-keywords)
  '("such" "much" "so" "very"))
(define (wow)
  "wow")
(define (user-keywords)
  '("Anthony" "awesome" "great"
              "nice" "cool" "programming god"
              "lisper" "lambda" "C++ hater" "doge"))
(define (colors)
  '("red" "magenta" "blue" "green" "yellow" "cyan"))

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
  (read-bitmap "./plainDoge.jpg"))

;drawing on doge
(define text-target doge)
(define dc (new bitmap-dc% [bitmap text-target]))
(send dc set-font
      (make-font #:size 25
                 #:family 'decorative
                 #:weight 'bold))

;actually drawing text
(for-each
 (lambda (kw)
   (send dc set-text-foreground (random-word colors))
   (send dc draw-text kw (random 700) (random 500)))
 (make-sentences user-keywords))

;frame
(define main-frame (new frame%
                        [label "racket-doge"]
                        [width 700]
                        [height 500]
                        [style (list 'no-resize-border)]))
;canvas
(define my-canvas
  (new canvas% [parent main-frame]
       [paint-callback
        (lambda (canvas dc)
          (send dc draw-bitmap doge 0 0))]))

(send main-frame show #t)


