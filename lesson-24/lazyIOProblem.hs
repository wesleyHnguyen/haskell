import System.IO
import System.Environment


getCount :: String -> (Int, Int, Int)
getCount input = (charCount, wordCount, lineCount)
  where charCount = length input
        wordCount = (length . words) input
        lineCount = (length . lines) input


countsText :: (Int, Int, Int) -> String
countsText (cc, wc, lc) = mconcat ["chars: ", show cc, " " ,"words: ", show wc, " " ,"lines: ", show lc]



-- lazy IO problem -- close file before getting data because of lazy evaluation
{-
lazyIOProblem: hello.txt: hGetContents: illegal operation (delayed read on closed handle)

Lazy evaluation - is just Like Promises in JS

main :: IO ()
main = do
  args <- getArgs

  let fileName = head args
  
  file <- openFile fileName ReadMode

  input <- hGetContents file  -- hGetContents is lazy , NO value fetched and stored into   `input`

  hClose file 

  let summary = (countsText . getCount) input -- `input` is not evaluated here - summary do nothing 

  appendFile "stats.dat" (mconcat [fileName, " ", summary, "\n"]) -- `input` need to be evaluated - now hGetContents need to be evaluated
  ---- But the file has been closed already --

  putStrLn summary


-}

-- fix - get value - appendFile - until then close the file
main :: IO ()
main = do
  args <- getArgs

  let fileName = head args
  
  file <- openFile fileName ReadMode

  input <- hGetContents file

  let summary = (countsText . getCount) input

  appendFile "stats.dat" (mconcat [fileName, " ", summary, "\n"])

  hClose file

  putStrLn summary