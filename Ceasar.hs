

import Data.Char

rot :: Int -> Char -> Char
rot n c
  | isUpper c = r 'A'
  | isLower c = r 'a'
  | otherwise = c
  where
    r b = chr $ (((ord c - ord b) + n) `mod` 26) + ord b

rotations :: String -> [String]
rotations str = map (\n -> show n ++ ": " ++ map (rot n) str) [1..25]

main = do
  str <- getLine
  mapM_ putStrLn $ rotations str
