#lang br/quicklang
(provide + *)

(define-macro (stackerizer-mb EXPR)
  #'(#%module-begin
     EXPR))
(provide (rename-out [stackerizer-mb #%module-begin]))

(define-macro-cases +
  [(+ FIRST) #'FIRST]
  [(+ FIRST NEXT ...) #'(list 'dyadd FIRST (+ NEXT ...))])