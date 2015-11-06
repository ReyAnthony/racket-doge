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
;TODO random capitalisation for first letter
(define doge-keywords
  '("such" "much" "so" "very"))
(define wow
  "Wow")

(define user-keywords
  '())
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
      '()
      ;else
      (cons wow 
            (map make-sentence
                 (shuffle my-list)))))
     
;frame
(define (create-parent-frame)
  (new frame%
       [label "racket-doge"]
       [width 700]
       [height 600]
       [style (list 'no-resize-border)]))

;canvas
(define (main-canvas parent-frame to-draw)
  (new canvas% [parent parent-frame]
       [min-height 500]
       [paint-callback
        (lambda (canvas dc)
          (send dc draw-bitmap to-draw 0 0))]))

;horiz panel
(define (create-horiz-panel parent-frame)
  (new horizontal-panel% [parent parent-frame]))

;font management
(define (set-font my-dc)
  (send my-dc set-font
      (make-font #:size (+ 20 (random 5))
                 #:family 'decorative
                 #:face "Comic Sans MS"
                 #:weight 'bold)))

;draw on doge
(define (draw-text-with-keywords kwd my-dc) 
  ;draw the text on my-dc
  (for-each
   (lambda (kw)
     (set-font my-dc)
     (send my-dc set-text-foreground (random-member colors))
     (send my-dc draw-text kw (random 700) (random 500)))
   (make-sentences kwd)))

;text edit
(define (create-user-entries horiz-panel)
  (new text-field%
       ;[enabled #f]
       [label "user-keywords :"]
       [init-value (string-join user-keywords ", ")]
       [parent horiz-panel]))

(define (parse-user-input user-entries)
  (string-split (send user-entries get-value) ", "))

;buttons
(define (gen-again-but horiz-panel user-entries my-dc p-frame)
  (new button% [label "Generate again"]
       ;generate again
       [parent horiz-panel]
       ;[enabled #f]
       [callback
        (lambda (b e)
          ;redraw not working on OSX ???
          (draw-text-with-keywords
           (parse-user-input user-entries) my-dc)
          ;shitty fix for restart issue
          (send p-frame refresh)
          (make-gui))]))

(define (save-but doge horiz-panel)
  (new button% [label "Save"]
       ;Save the bitmap to a file
       [parent horiz-panel]
       [callback
        (lambda (b e)
           (send doge save-file
                 "./generated_doge.png"
                 'png))]))


;let's make the GUI and run the whole program
(define (make-gui)
  (let
      ([p-frame (create-parent-frame)])
    (let
        ([doge (read-bitmap "plainDoge.jpg")])
      (main-canvas p-frame doge)
      (let
          ([horiz-panel (create-horiz-panel p-frame)])
        ;let's create a drawing context and draw on it
        (let
            ([my-dc (new bitmap-dc% [bitmap doge])])
          (let
              ([user-entries (create-user-entries horiz-panel)]) 
            (draw-text-with-keywords
             (parse-user-input user-entries) my-dc)
            (gen-again-but horiz-panel user-entries my-dc p-frame)
            (save-but doge horiz-panel))))) 
    (send p-frame show #t)))
  
(make-gui)