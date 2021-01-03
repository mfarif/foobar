;; SMT 1-2-1 encoding of a Simple Pogram:
;
;1.   void  foobar(int a, int b) {
;2.      int x = 1, y = 0;
;3.      if (a != 0) {
;4.          y = 3+x;
;5.          if (b == 0)
;6.             x = 2*(a+b);
;7.      }
;8.      
;9.       assert(x-y != 0);
;10.  }

; SMT Solver will find values (a = 2 and b = 0) that fail the above assertion.
; Reference: https://arxiv.org/pdf/1610.00502.pdf on Page#2.

(set-logic ALL)
(set-option :produce-models true)
(declare-fun x1 () Int)
(declare-fun y1 () Int)
(declare-fun x2 () Int)
(declare-fun y2 () Int)
(declare-const a Int)
(declare-const b Int)
(define-fun foobar ((a Int) (b Int)) Bool
    (and
        ;;2 int x = 1, y = 0;
        (= x1 1) (= y1 0)
        ;3. if (a != 0) {
        (ite (not (= a 0))
            (and
                ;4. y = 3+x;
                (= y2 (+ 3 x1))
                ;5. if (b == 0)
                (ite (= b 0)
                    ;6. x = 2*(a+b);
                    (= x2 (* 2 (+ a b)))
                    (= x2 x1)
                )
            )
            (and
              (= x2 x1)
              (= y2 y1)
            );end-and
        )
        ;9. assert(x-y != 0);
        (= (- x2 y2) 0)
    );end-and
)
(assert (foobar a b));end-assert
(check-sat)
(get-model)
