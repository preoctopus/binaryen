(module
  ;; Figure 1a from the Souper paper https://arxiv.org/pdf/1711.04422.pdf
  (func $figure-1a (param $a i64) (param $x i64) (param $y i64) (result i32)
    (local $i i32)
    (local $j i32)
    (local $r i32)
    (set_local $i
      (i64.eq
        (get_local $a)
        (get_local $x)
      )
    )
    (set_local $j
      (i64.ne
        (get_local $a)
        (get_local $y)
      )
    )
    (set_local $r
      (i32.and
        (get_local $i)
        (get_local $j)
      )
    )
    (return (get_local $r))
  )
  ;; Figure 1b, with a potential path condition
  (func $figure-1b (param $a i64) (param $x i64) (param $y i64) (result i32)
    (local $i i32)
    (local $j i32)
    (local $r i32)
    (if
      (i64.lt_s
        (get_local $x)
        (get_local $y)
      )
      (block
        (set_local $i
          (i64.eq
            (get_local $a)
            (get_local $x)
          )
        )
        (set_local $j
          (i64.ne
            (get_local $a)
            (get_local $y)
          )
        )
        (set_local $r
          (i32.and
            (get_local $i)
            (get_local $j)
          )
        )
        (return (get_local $r))
      )
      (unreachable)
    )
  )
  ;; Figure 3, simplified to an if
  (func $figure-3-if (param $x i32) (result i32)
    (if
      (i32.and
        (get_local $x)
        (i32.const 1)
      )
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 1)
        )
      )
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 2)
        )
      )
    )
    (return
      (i32.and
        (get_local $x)
        (i32.const 1)
      )
    )
  )
  ;; flipping of greater than/or equals ops, which are not in Souper IR
  (func $flips
    (local $x i32)
    (local $y i32)
    (set_local $x (i32.ge_s (get_local $x) (get_local $y)))
    (set_local $x (i32.ge_u (get_local $x) (get_local $y)))
    (set_local $x (i32.gt_s (get_local $x) (get_local $y)))
    (set_local $x (i32.gt_u (get_local $x) (get_local $y)))
  )
  (func $various-conditions-1 (param $x i32)
    (if
      (get_local $x)
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 1)
        )
      )
    )
  )
  (func $various-conditions-2 (param $x i32)
    (if
      (i32.lt_s
        (get_local $x)
        (i32.const 0)
      )
      (set_local $x
        (i32.sub
          (get_local $x)
          (i32.const 2)
        )
      )
    )
  )
  (func $various-conditions-3 (param $x i32)
    (if
      (i32.reinterpret/f32 (f32.const 0))
      (set_local $x
        (i32.sub
          (get_local $x)
          (i32.const 4)
        )
      )
    )
  )
  (func $various-conditions-4 (param $x i32)
    (if
      (unreachable)
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 3)
        )
      )
    )
  )
  (func $unaries (param $x i32) (param $y i32)
    (if
      (i32.eqz
        (get_local $x)
      )
      (set_local $x
        (i32.add
          (i32.ctz
            (get_local $y)
          )
          (i32.sub
            (i32.clz
              (get_local $x)
            )
            (i32.popcnt
              (get_local $y)
            )
          )
        )
      )
    )
  )
  (func $unary-condition (param $x i32)
    (if
      (i32.ctz
        (i32.gt_u
          (get_local $x)
          (i32.const 1)
        )
      )
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 2)
        )
      )
    )
  )
  (func $unary-condition-2 (param $x i32)
    (if
      (i32.eqz
        (i32.gt_u
          (get_local $x)
          (i32.const 1)
        )
      )
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 2)
        )
      )
    )
  )
  (func $if-else-cond (param $x i32) (result i32)
    (if
      (i32.lt_s
        (get_local $x)
        (i32.const 1)
      )
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 1)
        )
      )
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 2)
        )
      )
    )
    (return
      (i32.and
        (get_local $x)
        (i32.const 1)
      )
    )
  )
  (func $trivial-ret (result i32)
    (i32.add
      (i32.const 0)
      (i32.const 1)
    )
  )
  (func $trivial-const (result i32)
    (i32.const 0)
  )
  (func $trivial-const-block (result i32)
    (nop)
    (i32.const 0)
  )
  (func $bad-phi-value (result i32)
    (if (result i32)
      (if (result i32)
        (i32.const 1)
        (i32.load
          (i32.const 0)
        )
        (i32.const 0)
      )
      (i32.const 0)
      (i32.const 1)
    )
  )
  (func $bad-phi-value-2 (param $x i32) (result i32)
    (if
      (if (result i32)
        (i32.const 1)
        (i32.load
          (i32.const 0)
        )
        (i32.const 0)
      )
      (set_local $x (i32.const 1))
      (set_local $x (i32.const 2))
    )
    (get_local $x)
  )
  (func $select (param $x i32) (result i32)
    (return
      (select
        (i32.const 1)
        (i32.const 2)
        (i32.const 3)
      )
    )
  )
  (func $select-2 (param $x i32) (param $y i32) (result i32)
    (return
      (select
        (i32.add
          (get_local $x)
          (get_local $y)
        )
        (i32.add
          (get_local $x)
          (i32.const 1)
        )
        (i32.add
          (i32.const 2)
          (get_local $y)
        )
      )
    )
  )
  (func $block-phi-1 (param $x i32) (param $y i32) (result i32)
    (block $out
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 1)
        )
      )
      (br_if $out (get_local $y))
      (set_local $x
        (i32.add
          (get_local $x)
          (i32.const 2)
        )
      )
    )
    (i32.add
      (get_local $x)
      (i32.const 3)
    )
  )
  (func $block-phi-2 (param $x i32) (param $y i32) (result i32)
    (block $out
      (set_local $x
        (i32.const 1)
      )
      (br_if $out (get_local $y))
      (set_local $x
        (i32.const 2)
      )
    )
    (i32.add
      (get_local $x)
      (i32.const 3)
    )
  )
  (func $zero_init-phi-bad_type (result f64)
    (local $x f64)
    (if
      (i32.const 0)
      (set_local $x
        (f64.const 1)
      )
    )
    (get_local $x)
  )
  (func $phi-bad-type  (result f64)
    (block $label$1 (result f64)
      (if (result f64)
        (i32.const 0)
        (f64.const 0)
        (f64.const 1)
      )
    )
  )
  (func $phi-one-side-i1 (param $x i32) (param $y i32) (result i32)
    (local $i i32)
    (if
      (i32.le_s
        (get_local $x)
        (get_local $y)
      )
      (set_local $i
        (i32.eq
          (get_local $x)
          (get_local $y)
        )
      )
      (set_local $i
        (i32.add
          (get_local $x)
          (get_local $y)
        )
      )
    )
    (get_local $i)
  )
  (func $call (result i32)
    (return
      (i32.mul
        (i32.add
          (call $call)
          (call $call)
        )
        (i32.add
          (i32.const 10)
          (call $call)
        )
      )
    )
  )
  (func $in-unreachable-1 (param $x i32) (param $y i32) (result i32)
    (if
      (get_local $x)
      (block
        (set_local $x
          (i32.const 1)
        )
        (return (get_local $x))
      )
      (set_local $x
        (i32.const 2)
      )
    )
    ;; no phi here!
    (return
      (get_local $x)
    )
  )
  (func $in-unreachable-2 (param $x i32) (param $y i32) (result i32)
    (if
      (get_local $x)
      (block
        (set_local $x
          (i32.const 1)
        )
        (unreachable)
      )
      (set_local $x
        (i32.const 2)
      )
    )
    ;; no phi here!
    (return
      (get_local $x)
    )
  )
  (func $in-unreachable-3 (param $x i32) (param $y i32) (result i32)
    (block $out
      (if
        (get_local $x)
        (block
          (set_local $x
            (i32.const 1)
          )
          (br $out)
        )
        (set_local $x
          (i32.const 2)
        )
      )
      ;; no phi here!
      (return
        (get_local $x)
      )
    )
    (return
      (get_local $x)
    )
  )
  (func $in-unreachable-4 (param $x i32) (param $y i32) (result i32)
    (block $out
      (if
        (get_local $x)
        (block
          (set_local $x
            (i32.const 1)
          )
          (br_table $out $out $out (i32.const 1))
        )
        (set_local $x
          (i32.const 2)
        )
      )
      ;; no phi here!
      (return
        (get_local $x)
      )
    )
    (return
      (get_local $x)
    )
  )
  (func $in-unreachable-br_if (param $x i32) (param $y i32) (result i32)
    (block $out
      (if
        (get_local $x)
        (block
          (set_local $x
            (i32.const 1)
          )
          (br_if $out
            (get_local $x)
          )
        )
        (set_local $x
          (i32.const 2)
        )
      )
      ;; there *IS* a phi here since it was a br_if
      (return
        (get_local $x)
      )
    )
    (return
      (get_local $x)
    )
  )
  (func $in-unreachable-big (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32)
   (block $label$1
    (block $label$2
     (block $label$3
      (if
       (get_local $2)
       (if
        (get_local $0)
        (block
         (set_local $1
          (i32.const -8531)
         )
         (br $label$3)
        )
        (block
         (set_local $1
          (i32.const -8531)
         )
         (br $label$1)
        )
       )
      )
      (br $label$2)
     )
     (drop
      (i32.load
       (i32.const 0)
      )
     )
     (br $label$1)
    )
    (i32.store16
     (i32.const 1)
     (get_local $1)
    )
    (unreachable)
   )
   (i32.store16
    (i32.const 0)
    (i32.const -8531)
   )
  )
  (func $in-unreachable-operations (param $x i32) (param $y i32) (result i32)
    (block
      (unreachable)
      (if
        (get_local $x)
        (set_local $x
          (i32.const 1)
        )
        (set_local $x
          (i32.const 2)
        )
      )
      (return
        (get_local $x)
      )
    )
  )
  (func $merge-with-one-less (param $var$0 i32) (result i32)
   (block $label$1
    (block $label$2
     (block $label$3
      (block $label$4
       (block $label$5
        (br_table $label$5 $label$4 $label$3 $label$2
         (i32.load
          (i32.const 1)
         )
        )
       )
       (unreachable)
      )
      (br $label$1)
     )
     (f64.store
      (i32.load
       (tee_local $var$0
        (i32.const 8)
       )
      )
      (f64.const 0)
     )
     (br $label$1)
    )
    (unreachable)
   )
   (i32.store
    (get_local $var$0)
    (i32.const 16)
   )
   (i32.const 1)
  )
  (func $deep (param $x i32) (result i32)
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (set_local $x (i32.xor (get_local $x) (i32.const 1234)))
    (set_local $x (i32.mul (get_local $x) (i32.const 1234)))
    (get_local $x)
  )
  (func $two-pcs (param $x i64) (param $y i64) (result i64)
    (param $t i64)
    (if
      (i64.lt_s
        (get_local $x)
        (get_local $y)
      )
      (if
        (i64.eqz
          (get_local $x)
        )
        (set_local $t
          (i64.add
            (get_local $x)
            (get_local $y)
          )
        )
        (set_local $t
          (i64.sub
            (get_local $x)
            (get_local $y)
          )
        )
      )
      (if
        (i64.eqz
          (get_local $y)
        )
        (set_local $t
          (i64.mul
            (get_local $x)
            (get_local $y)
          )
        )
        (set_local $t
          (i64.div_s
            (get_local $x)
            (get_local $y)
          )
        )
      )
    )
    (return (get_local $t))
  )
  (func $loop-1 (param $x i32) (param $y i32) (result i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
    )
    ;; neither needed a phi
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-2 (param $x i32) (param $y i32) (result i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
      (set_local $x (i32.add (get_local $x) (i32.const 3)))
      (set_local $y (i32.add (get_local $y) (i32.const 4)))
    )
    ;; neither needed a phi
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-3 (param $x i32) (param $y i32) (result i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
      (set_local $x (i32.add (get_local $x) (i32.const 3)))
      (set_local $y (i32.add (get_local $y) (i32.const 4)))
      (br_if $loopy (get_local $y))
    )
    ;; both needed
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-4 (param $x i32) (param $y i32) (result i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
      (set_local $x (i32.add (get_local $x) (i32.const 3)))
      (br_if $loopy (get_local $y))
    )
    ;; only x needed a phi
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-5 (param $x i32) (param $y i32) (result i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
      (set_local $x (i32.add (get_local $x) (i32.const 3)))
      (set_local $y (i32.const 2)) ;; same value
      (br_if $loopy (get_local $y))
    )
    ;; only x needed a phi
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-6 (param $x i32) (param $y i32) (result i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
      (set_local $x (i32.add (get_local $x) (i32.const 3)))
      (set_local $y (get_local $y)) ;; same value
      (br_if $loopy (get_local $y))
    )
    ;; only x needed a phi
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-7 (param $x i32) (param $y i32) (result i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
      (set_local $x (i32.add (get_local $x) (i32.const 3)))
      (set_local $y (i32.const 5)) ;; different!
      (br_if $loopy (get_local $y))
    )
    ;; y changed but we don't need a phi for it
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-8 (param $x i32) (param $y i32) (result i32)
    (local $z i32)
    (local $w i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
      (set_local $z (get_local $x))
      (set_local $w (get_local $y))
      (set_local $x (i32.const 1)) ;; same!
      (set_local $y (i32.const 4)) ;; different!
      (br_if $loopy (get_local $y))
    )
    ;; x is always 3, and y needs a phi.
    ;; each is also copied to another local, which we need
    ;; to handle properly
    (return
      (i32.mul
        (i32.add
          (get_local $x)
          (get_local $y)
        )
        (i32.sub
          (get_local $z)
          (get_local $w)
        )
      )
    )
  )
  (func $loop-9 (param $x i32) (param $y i32) (result i32)
    (local $t i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (loop $loopy
      (set_local $t (get_local $x))
      (set_local $x (get_local $y))
      (set_local $y (get_local $t))
      (br_if $loopy (get_local $t))
    )
    ;; x and y swapped, so both need phis
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-10 (param $x i32) (param $y i32) (result i32)
    (local $t i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 1))
    (loop $loopy ;; we swap the values. but we need a deeper analysis to figure that out...
      (set_local $t (get_local $x))
      (set_local $x (get_local $y))
      (set_local $y (get_local $t))
      (br_if $loopy (get_local $t))
    )
    ;; x and y swapped, but the same constant was swapped
    (return (i32.add (get_local $x) (get_local $y)))
  )
  (func $loop-multicond-1 (param $x i32) (param $y i32) (param $z i32) (result i32)
    (local $t i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (set_local $z (i32.const 3))
    (loop $loopy
      (set_local $x (i32.const 4))
      (br_if $loopy (get_local $t))
      (set_local $y (i32.const 5))
      (br_if $loopy (get_local $t))
      (set_local $z (i32.const 6))
    )
    (return (select (get_local $x) (get_local $y) (get_local $z)))
  )
  (func $loop-multicond-2 (param $x i32) (param $y i32) (param $z i32) (result i32)
    (local $t i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (set_local $z (i32.const 3))
    (loop $loopy
      (set_local $x (i32.add (get_local $x) (i32.const 4)))
      (br_if $loopy (get_local $t))
      (set_local $y (i32.add (get_local $y) (i32.const 5)))
      (br_if $loopy (get_local $t))
      (set_local $z (i32.add (get_local $z) (i32.const 6)))
    )
    (return (select (get_local $x) (get_local $y) (get_local $z)))
  )
  (func $loop-block-1 (param $x i32) (param $y i32) (param $z i32) (result i32)
    (local $t i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (set_local $z (i32.const 3))
    (loop $loopy
      (block $out
        (set_local $x (i32.add (get_local $x) (i32.const 4)))
        (br_if $out (get_local $t))
        (set_local $y (i32.add (get_local $y) (i32.const 5)))
        (br_if $out (get_local $t))
        (set_local $z (i32.add (get_local $z) (i32.const 6)))
        (br $loopy)
      )
    )
    (return (select (get_local $x) (get_local $y) (get_local $z)))
  )
  (func $loop-block-2 (param $x i32) (param $y i32) (param $z i32) (result i32)
    (local $t i32)
    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (set_local $z (i32.const 3))
    (block $out
      (loop $loopy
        (set_local $x (i32.add (get_local $x) (i32.const 4)))
        (br_if $out (get_local $t))
        (set_local $y (i32.add (get_local $y) (i32.const 5)))
        (br_if $out (get_local $t))
        (set_local $z (i32.add (get_local $z) (i32.const 6)))
        (br $loopy)
      )
    )
    (return (select (get_local $x) (get_local $y) (get_local $z)))
  )
)
