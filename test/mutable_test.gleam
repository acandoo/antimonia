import antimonia/mutable

pub fn mutable_test() {
  let initial = 0
  let #(val, _) = mutable.tuple_from(initial)
  assert val() == initial
    as "value initializes to the right value: mutable.tuple_from"

  let initial2 = 1
  let mut_val = mutable.from(initial2)
  assert mutable.get(mut_val) == initial2
    as "value initializes to the right value: mutable.from"

  let initial3 = 2
  let #(val, _) =
    mutable.from(initial3)
    |> mutable.to_tuple
  assert val() == initial3
    as "value initializes to the right value: mutable.from |> mutable.to_tuple"
}

pub fn mutable_identity_test() {
  let mut_1 = mutable.from(0)
  let mut_2 = mutable.from(0)
  assert mut_1 != mut_2 as "mutables have separate identities"
}

pub fn mutable_change_test() {
  let val1 = 3
  let mut_1 = mutable.from(0)
  mutable.set(mut_1, val1)
  assert mutable.get(mut_1) == val1
    as "mutable changes to the right value: mutable.from"

  let val2 = <<3>>
  let #(val, set_val) = mutable.tuple_from(<<"3":utf8>>)
  set_val(val2)
  assert val() == val2
    as "mutable changes to the right value: mutable.tuple_from"

  let val3 = "3"
  let #(val, set_val) = mutable.from("1") |> mutable.to_tuple
  set_val(val3)
  assert val() == val3
    as "mutable changes to the right value: mutable.from |> mutable.to_tuple"
}
