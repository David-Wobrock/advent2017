import Data.List(sort)
import Data.List.Split(splitOn)
import Data.Set(fromList, size)
import System.Environment
import System.IO

is_valid :: [String] -> Bool
is_valid line =
    (length line) == (size (fromList (map sort line)))

inc_if_valid line =
  is_valid (splitOn " " line)

main = do
    args <- getArgs
    handle <- openFile (head args) ReadMode
    content <- hGetContents handle
    let correct = map inc_if_valid (lines content)
    let num_true = length (filter (== True) correct)
    print num_true
    hClose handle
