import Data.Array.Unboxed
import Data.Array.ST
import Control.Monad
import Control.Monad.ST

{-
  thaw UArray into STUArray
  thaw :: a i e -> m (b i e)
-}

myData :: UArray Int Int
myData = listArray (0,5) [7,6,4,8,10,2]

bubleSort :: UArray Int Int -> UArray Int Int
bubleSort myArray = runSTUArray $ do
  stArray <- thaw myArray

  let end = (snd . bounds) myArray

  forM_ [1..end] $ \i -> do
    forM_ [0..(end-1)] $ \j -> do
      val <- readArray stArray j
      nextVal <- readArray stArray (j+1)
      let outOfOrder = val > nextVal
      when outOfOrder $ do
        writeArray stArray j nextVal
        writeArray stArray (j + 1) val
  
  return stArray

