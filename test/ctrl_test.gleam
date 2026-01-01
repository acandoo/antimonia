import antimonia/ctrl
import antimonia/mutable

pub fn repeat_test() {
  let #(counter, set_counter) = mutable.tuple_from(0)
  {
    use <- ctrl.repeat(5)
    set_counter(counter() + 1)
  }
  assert counter() == 5
}

pub fn repeat_zero_test() {
  let #(counter, set_counter) = mutable.tuple_from(0)
  {
    use <- ctrl.repeat(0)
    set_counter(counter() + 1)
    panic
  }
  assert counter() == 0
}

pub fn repeat_negative_test() {
  let #(counter, set_counter) = mutable.tuple_from(0)
  {
    use <- ctrl.repeat(-5)
    set_counter(counter() + 1)
  }
  assert counter() == 0
}

pub fn for_test() {
  let #(counter, set_counter) = mutable.tuple_from(0)
  {
    use _ <- ctrl.for(i: 0, cond: fn(i) { i < 5 }, change: fn(i) { i + 1 })
    set_counter(counter() + 1)
    Ok(Nil)
  }
  assert counter() == 5 as "for loops the right number of times"
}

pub fn for_zero_test() {
  let #(counter, set_counter) = mutable.tuple_from(0)
  {
    use _ <- ctrl.for(i: 0, cond: fn(i) { i < 0 }, change: fn(i) { i + 1 })
    set_counter(counter() + 1)
    Ok(Nil)
  }
  assert counter() == 0 as "for loops 0 times"
}

pub fn for_break_test() {
  let #(counter, set_counter) = mutable.tuple_from(0)
  {
    use i <- ctrl.for(i: 0, cond: fn(i) { i < 5 }, change: fn(i) { i + 1 })
    case i == 3 {
      True -> Error(ctrl.Break)
      False -> {
        set_counter(counter() + 1)
        Ok(Nil)
      }
    }
  }
  assert counter() == 3 as "for loop breaks early"
}

pub fn while_test() {
  let #(counter, set_counter) = mutable.tuple_from(0)
  ctrl.while(fn() { counter() < 5 }, fn() {
    set_counter(counter() + 1)
    Ok(Nil)
  })
  assert counter() == 5 as "while loop executes correct times"
}

pub fn while_break_test() {
  let #(counter, set_counter) = mutable.tuple_from(0)
  ctrl.while(fn() { counter() < 5 }, fn() {
    set_counter(counter() + 1)
    case counter() == 3 {
      True -> Error(ctrl.Break)
      False -> Ok(Nil)
    }
  })
  assert counter() == 3 as "while loop breaks early"
}

pub fn do_while_test() {
  let #(counter, set_counter) = mutable.tuple_from(0)
  ctrl.do_while(fn() { counter() < 5 }, fn() {
    set_counter(counter() + 1)
    Ok(Nil)
  })
  assert counter() == 5 as "do_while executes correct times"
}

pub fn do_while_executes_once_test() {
  let #(counter, set_counter) = mutable.tuple_from(0)
  ctrl.do_while(fn() { False }, fn() {
    set_counter(counter() + 1)
    Ok(Nil)
  })
  assert counter() == 1 as "do_while executes at least once"
}

pub fn do_test() {
  let #(counter, set_counter) = mutable.tuple_from(0)
  let f =
    ctrl.do(fn() {
      set_counter(counter() + 1)
      Ok(Nil)
    })
  assert counter() == 1 as "do executes function"
  let _ = f()
  assert counter() == 2 as "do returns executable function"
}
