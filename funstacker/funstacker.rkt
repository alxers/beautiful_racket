#lang br/quicklang

(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define src-datums (format-datums '~a src-lines))
  (define module-datum `(module funstacker-mod "funstacker.rkt"
                          (handle ,@src-datums)))
  (datum->syntax #f module-datum))
(provide read-syntax)

(define-macro (funstacker-module-begin HANDLE-ARGS-EXPR)
  #'(#%module-begin
     (display (first HANDLE-ARGS-EXPR))))
(provide (rename-out [funstacker-module-begin #%module-begin]))

(define stack '())

(define (stack-pop!)
  (define el (first stack))
  (set! stack (rest stack))
  el)

(define (stack-push! arg)
  (set! stack (cons arg stack)))

(define (handle . args)
  (for/fold ([stack-acc empty])
            ([arg (filter-not void? args)])
    (cond
      [(number? arg) (cons arg stack-acc)]
      [(or (equal? + arg) (equal? * arg))
       (define result (arg (first stack-acc) (second stack-acc)))
       (cons result (drop stack-acc 2))])))
(provide handle)
(provide + *)
