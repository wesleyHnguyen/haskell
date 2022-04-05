{-
  Use non-lazy type for IO --> Data.Text
-}

{-# LANGUAGE OverloadedStrings #-}

import System.IO
import System.Environment

import qualified Data.Text as T
import qualified Data.Text.IO as TI

getCount :: T.Text -> (Int, Int, Int)
getCount input = (charCount, wordCount, lineCount)
  where charCount = T.length input
        wordCount = (length . T.words) input
        lineCount = (length . T.lines) input

countsText :: (Int, Int, Int) -> T.Text
countsText (cc, wc, lc) = T.pack $ mconcat ["chars: ", show cc, " " ,"words: ", show wc, " " ,"lines: ", show lc]

-- main :: IO ()
-- main = do
--   args <- getArgs

--   let fileName = head args
  
--   input <- TI.readFile fileName

--   let summary = (countsText . getCount) input

--   TI.appendFile "stats.dat" (mconcat [T.pack fileName, " ", summary, "\n"])

--   TI.putStrLn summary


main :: IO ()
main = do
  args <- getArgs

  let fileName = head args
  
  file <- openFile fileName ReadMode

  input <- TI.hGetContents file -- with strict IO Type - TI.hGetContents :: Handle -> IO T.Text -- the input is evaluated immediately

  let summary = (countsText . getCount) input

  hClose file

  TI.appendFile "stats.dat" (mconcat [T.pack fileName, " ", summary, "\n"])

  -- hClose file

  TI.putStrLn summary