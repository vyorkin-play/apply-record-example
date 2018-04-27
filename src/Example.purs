module Example where

import Prelude
import Data.Function.Uncurried (Fn2, runFn2)

foreign import add2Impl
  :: Fn2 Int Int Int

add2 :: Int -> Int -> Int
add2 x y = runFn2 add2Impl x y
