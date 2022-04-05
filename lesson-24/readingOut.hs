import System.IO
import System.Environment

-- Reading from a file and writing to stdout and another file

{-

  type FilePath = String

  data IOMode = ReadMode | WriteMode | AppendMode | ReadWriteMode

  Handle -- references to the file - :: FileHandle FilePath | DuplexHandle FilePath


  openFile :: FilePath -> IOMode -> IO Handle
  open a file to start working with it

  hClose :: Handle -> IO ()
  an Action that receive a hanle type value to close that file.

  -- ** --
  - to read **each line of data from a file : --- hGetLine :: Handle -> IO String -- an action that receive a handle type value and return value of String in the IO context

  - to write **each line of data to a file : ---- hPutStrLn :: Handle -> String -> IO () -- an action that receive a file handle value and Data in type of String --> write data to
  -- the file and return Nothing 

-}

{-
main :: IO ()
main = do
  helloFile <- openFile "hello.txt" ReadMode

  firstLine <- hGetLine helloFile
  putStrLn firstLine

  secondLine <- hGetLine helloFile
  putStrLn secondLine

  goodbyeFile <- openFile "goodbye.txt" WriteMode
  hPutStrLn goodbyeFile secondLine

  hClose helloFile
  hClose goodbyeFile
  putStrLn "done!"

-}

-- -----------------**Check the end of the file before Read each line**--------------

-- hIsEOF :: Handle -> IO Bool -- receive a file handle type value do an action to check whether the file is end -> Return Bool value in the context of IO
-- main :: IO ()
-- main = do
--   helloFile <- openFile "hello.txt" ReadMode

--   hasLine <- hIsEOF helloFile

--   firstLine <-  if not hasLine
--                 then hGetLine helloFile
--                 else return "empty"

--   hasSecondLine <- hIsEOF helloFile
--   secondLine <- if not hasSecondLine
--                 then hGetLine helloFile
--                 else return "" 
  
--   print (firstLine ++ "\n" ++ secondLine)
--   putStrLn "done!"




-- ----- *Another IO tools* -------------------
{-
  readFile :: FilePath -> IO String

  writeFile :: FilePath -> String -> IO ()

  appendFile :: FilePath -> String -> IO ()

-}

-- words :: String -> [String]
-- lines :: String -> [String]

getCount :: String -> (Int, Int, Int)
getCount input = (charCount, wordCount, lineCount)
  where charCount = length input
        wordCount = (length . words) input
        lineCount = (length . lines) input


countsText :: (Int, Int, Int) -> String
countsText (cc, wc, lc) = mconcat ["chars: ", show cc, " " ,"words: ", show wc, " " ,"lines: ", show lc]


main :: IO ()
main = do
  args <- getArgs

  let fileName = head args
  
  input <- readFile fileName

  let summary = (countsText . getCount) input

  appendFile "stats.dat" (mconcat [fileName, " ", summary, "\n"])

  putStrLn summary