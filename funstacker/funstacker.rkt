#lang br/quicklang

(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define src-datums (format-datums '~a src-lines))
  (define module-datum `(module funstacker-mod "funstacker.rkt"
                          (handle-args ,@src-datums)))
  (datum->syntax #f module-datum))
(provide read-syntax)

(define-macro (stacker-module-begin HANDLE-EXPR ...)
  #'(#%module-begin
     HANDLE-EXPR ...
     (display (first stack))))
(provide (rename-out [stacker-module-begin #%module-begin]))

(define stack '())

(define (stack-pop!)
  (define el (first stack))
  (set! stack (rest stack))
  el)

(define (stack-push! arg)
  (set! stack (cons arg stack)))

(define (handle [arg #f])
  (cond
    [(number? arg) (stack-push! arg)]
    [(or (equal? + arg) (equal? * arg))
     (define result (arg (stack-pop!) (stack-pop!)))
     (stack-push! result)]))
(provide handle)
(provide + *)
