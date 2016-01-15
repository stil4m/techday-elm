xs = [1, 2, 3]

4 :: xs -- [4, 1, 2, 3]

head list
  case list of
    x::xs -> Just x
    []    -> Nothing