import Data.Array.Unboxed
import Data.Array.ST
import Control.Monad
import Control.Monad.ST

{-
  Haskell - lazy evaluation - plan all computation for evaluated later
  -- when evaluation is absolutely needed - first it builds List/all-any-lazy-type e.g: String
  -- then begin to do something on that - which are already stored

  --> lead to bad performance.

  
  problem with list:
  - Lists are slower than arrays for operations that involve --looking up values
  - Lazy evaluation can cause major performance problems 
  
  - In-place sorting required mutation


-}

{- Creating a UArray
  
  data UArray i e  - use array functin to create UArray

  array :: (i, i) -> [(i, e)] -> a i e
  - the first is a pair of value - specify (minbound, maxbound) of indices - index must be Enum, bounded -> Int or Char or Bool
  - the second is list of pair - (index, value)

  -- If an index is missing in pairs -> the default value will be provided
  ---- Int: 0  -- Bool : False  

-}

{-
  (!) :: a i e -> i -> e
  -- This will throw exception if index is out of range

-}

-- zeroIndexArray :: UArray Int Bool
-- zeroIndexArray = array (1,9) [(3, True)]

-- zeroIndexArray ! 3 ==> True
-- zeroIndexArray ! 6 ==> False

{-
  Updating UArray:
  - creating the whole struture with new changes
  - using (//)
-}

-- beansInBuckets :: UArray Int Int
-- beansInBuckets = array (0,3) []
-- -- beanInBuckets = array (0,3) [(0,0), (1,0)..(3,0)]

-- updateBiB :: UArray Int Int
-- updateBiB = beansInBuckets // [(1,5), (3,6)]

-- UArray - more efficient for look up operation
-- UArray -- updated with copy of new structured - NOT in-place

-- In-place - updating is we dont have to have a second copy of the arrayto perform update

{- Mutating STUArray
  -- special type of UArray - which uses a more general type called ST - stateful, non-lazy

  -- STUArray : allow us to perform computation in `STUArray Context` - we can change the value `in place` - in the unsafe context - like IO


  -- writeArray myArray i val :: a i e -> i -> e -> m () rewrites the data in your array -- do **side effect things
-}

listToSTUArray :: [Int] -> ST s (STUArray s Int Int)
listToSTUArray vals = do
  let end = length vals - 1 -- end is normal variable so we can assign it with let
  
  stArray <- newArray (0, end) 0 -- newArray bound initValue --> stArray is a mutable in the ST context

  -- forM_ action replicates a for loop
  -- forM_ [0..end] $ \i -> do
  --   let val = vals !! i -- looking up val from a list
  --   writeArray stArray i val -- rewrite state - in-place

  forM_ [0..end] (\i -> let val = vals !! i in writeArray stArray i val)

  return stArray

-- run this -- listToSTUArray [3,5,6] --> return <<ST action>>

{- Taking values out of the ST Context

-STUArray - enforcing encapsulation - stateful-code is obey encapsulation -> referential transparency is hold
----> we can take values out of STUArray from its context 

- with --------   runSTUArray :: ST s (STUArray s i e) -> UArray i e

-}


-- Here we can keep our stateful code in a safe context, but still treat it as pure code
-- Because STUArray forces us to maintain perfect encapsulation - we can leave the context of STUArray without violating any of core rules.

listToUArray :: [Int] -> UArray Int Int
listToUArray vals = runSTUArray $ listToSTUArray vals

{-
  use do to write a block of code
-}