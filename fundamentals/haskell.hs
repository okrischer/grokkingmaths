import Criterion.Main

facRec :: Integer -> Integer
facRec 0 = 1
facRec n = n * facRec (n-1)

facIter :: Integer -> Integer
facIter n = iter 1 1
  where
    iter product counter
      | counter > n = product
      | otherwise   = iter (counter * product) (counter + 1)

fibIter :: Int -> [Int]
fibIter n = take n $ fibSeq 1 1
  where fibSeq a b = a:fibSeq b (a+b)

main = defaultMain [
  bgroup "fac" [ bench "facRec"   $ whnf facRec 100
               , bench "facIter"  $ whnf facIter 100
               ]
  ]