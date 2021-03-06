#lang br/quicklang
(provide + *)

(define-macro (stackerizer-mb EXPR)
  #'(#%module-begin
     (for-each displayln (reverse (flatten EXPR)))))
(provide (rename-out [stackerizer-mb #%module-begin]))

;; TODO: define with ellipses
(define-macro (define-op OP)
  '#(define-macro-cases OP
      [(OP FIRST) #'FIRST]
      [(OP FIRST NEXT (... ...)) #'(list 'OP FIRST (OP NEXT (... ...)))]))

(define-op +)
(define-op *)
;; (define-op + *)