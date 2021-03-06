(module
  (func $basic (param $p i32)
    (local $x i32)
    (set_local $x (i32.const 10))
    (call $basic (i32.add (get_local $x) (get_local $x)))
  )
  (func $split (param $p i32)
    (local $x i32)
    (if (i32.const 1)
      (set_local $x (i32.const 10))
    )
    (call $basic (i32.add (get_local $x) (get_local $x)))
  )
  (func $split-but-join (param $p i32)
    (local $x i32)
    (if (i32.const 1)
      (set_local $x (i32.const 10))
      (set_local $x (i32.const 10))
    )
    (call $basic (i32.add (get_local $x) (get_local $x)))
  )
  (func $split-but-join-different (param $p i32)
    (local $x i32)
    (if (i32.const 1)
      (set_local $x (i32.const 10))
      (set_local $x (i32.const 20))
    )
    (call $basic (i32.add (get_local $x) (get_local $x)))
  )
  (func $split-but-join-different-b (param $p i32)
    (local $x i32)
    (if (i32.const 1)
      (set_local $x (i32.const 10))
      (set_local $x (get_local $p))
    )
    (call $basic (i32.add (get_local $x) (get_local $x)))
  )
  (func $split-but-join-init0 (param $p i32)
    (local $x i32)
    (if (i32.const 1)
      (set_local $x (i32.const 0))
    )
    (call $basic (i32.add (get_local $x) (get_local $x)))
  )
  (func $later (param $p i32)
    (local $x i32)
    (set_local $x (i32.const 10))
    (call $basic (i32.add (get_local $x) (get_local $x)))
    (set_local $x (i32.const 22))
    (call $basic (i32.add (get_local $x) (get_local $x)))
    (set_local $x (i32.const 39))
  )
  (func $later2 (param $p i32) (result i32)
    (local $x i32)
    (set_local $x (i32.const 10))
    (set_local $x (i32.add (get_local $x) (get_local $x)))
    (get_local $x)
  )
  (func $two-ways-but-identical (param $p i32) (result i32)
    (local $x i32)
    (local $y i32)
    (set_local $x (i32.const 10))
    (if (i32.const 1)
      (set_local $y (i32.const 11))
      (set_local $y (i32.add (get_local $x) (i32.const 1)))
    )
    (set_local $y (i32.add (get_local $x) (get_local $y)))
    (get_local $y)
  )
  (func $two-ways-but-almost-identical (param $p i32) (result i32)
    (local $x i32)
    (local $y i32)
    (set_local $x (i32.const 10))
    (if (i32.const 1)
      (set_local $y (i32.const 12)) ;; 12, not 11...
      (set_local $y (i32.add (get_local $x) (i32.const 1)))
    )
    (set_local $y (i32.add (get_local $x) (get_local $y)))
    (get_local $y)
  )
  (func $deadloop (param $p i32) (result i32)
    (local $x i32)
    (local $y i32)
    (loop $loop ;; we look like we depend on the other, but we don't actually
      (set_local $x (if (result i32) (i32.const 1) (i32.const 0) (get_local $y)))
      (set_local $y (if (result i32) (i32.const 1) (i32.const 0) (get_local $x)))
      (br $loop)
    )
  )
  (func $deadloop2 (param $p i32)
    (local $x i32)
    (local $y i32)
    (loop $loop ;; we look like we depend on the other, but we don't actually
      (set_local $x (if (result i32) (i32.const 1) (i32.const 0) (get_local $y)))
      (set_local $y (if (result i32) (i32.const 1) (i32.const 0) (get_local $x)))
      (call $deadloop2 (get_local $x))
      (call $deadloop2 (get_local $y))
      (br $loop)
    )
  )
  (func $deadloop3 (param $p i32)
    (local $x i32)
    (local $y i32)
    (loop $loop ;; we look like we depend on the other, but we don't actually
      (set_local $x (if (result i32) (i32.const 1) (i32.const 0) (get_local $x)))
      (set_local $y (if (result i32) (i32.const 1) (i32.const 0) (get_local $y)))
      (call $deadloop2 (get_local $x))
      (call $deadloop2 (get_local $y))
      (br $loop)
    )
  )
  (func $through-tee (param $x i32) (param $y i32) (result i32)
    (set_local $x
      (tee_local $y
        (i32.const 7)
      )
    )
    (return
      (i32.add
        (get_local $x)
        (get_local $y)
      )
    )
  )
  (func $through-tee-more (param $x i32) (param $y i32) (result i32)
    (set_local $x
      (i32.eqz
        (tee_local $y
          (i32.const 7)
        )
      )
    )
    (return
      (i32.add
        (get_local $x)
        (get_local $y)
      )
    )
  )
  (func $multipass (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
   (local $3 i32)
   (if
    (get_local $3)
    (set_local $3 ;; this set is completely removed, allowing later opts
     (i32.const 24)
    )
   )
   (if
    (get_local $3)
    (set_local $2
     (i32.const 0)
    )
   )
   (get_local $2)
  )
)

