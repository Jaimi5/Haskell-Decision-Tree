--Imports
import Data.List.Split
import qualified Data.Map as M
import Data.Map (Map, (!))
import Data.List (nub, transpose)

--Class types
type Result = String
type Attribute = String
type DataSet = [([Attribute], Result)]
type Entropy = Double

--Mushrom Attribute Types to show the results for better understanding
mushromTypes = ["","cap-shape: ","cap-surface: ", "cap-color: ","bruises: ","odor: ","gill-attachment: ","gill-spacing: ","gill-size: ","gill-color: ","stalk-shape: ","stalk-root: ","stalk-surface-above-ring: ","stalk-surface-below-ring: ","stalk-color-above-ring: ","stalk-color-below-ring: ","veil-type: ","veil-color: ","ring-number: ","ring-type: ","spore-print-color: ","population: ","habitat: "]

-- Define a Data Structure Tree
data DTree = InfoTree { mushromType :: String, children :: [DTree] } 
    | Node String String deriving (Show)    

main = do
    contents <- readFile "agaricus-lepiota.data"
    let a = map (\x -> splitOn "," x) (lines contents)
    let myData = map (\x -> (tail x, head x)) $ map(\s -> map(concatString) (zip mushromTypes s)) a
    let tree = dtree "root" myData
    putStrLn $ writeMultipleTree (children $ tree) 0
    print tree
    writeQuestions $ children tree


-- Questionary and Writting SECTION --------------------------------------------------------------------

-- --Write the Questionary, TODO: when eneterd an attribute that not exists this should be in a loop for getting a existing attribute
writeQuestions :: [DTree] -> IO()
writeQuestions ((InfoTree x y):xs) = (do
    putStrLn("Which " ++ getClass x ++ "?")
    attr <- getLine
    if ((getAttribute x) == attr) 
        then (writeQuestions y) 
    else (continueWritingQuestions $ head $ filter(\k -> (getAttributeNode k) == attr) xs)) 
writeQuestions ((Node x y):xs) = hasMoreValues
    where
        hasMoreValues = if (length xs > 0) 
            then (do 
                putStrLn("Which " ++ getClass x ++ "?")
                attr <- getLine
                if ((getAttribute x) == attr) 
                    then (putStrLn (putPrediction y)) 
                else (continueWritingQuestions $ head $ filter(\k -> (getAttributeNode k) == attr) xs)) 
            else (putStrLn (putPrediction y))

--Auxiliar function for Writing Questionary
continueWritingQuestions :: DTree -> IO()
continueWritingQuestions (Node _ y) = putStrLn $ putPrediction $ getAttribute y
continueWritingQuestions (InfoTree _ x) = writeQuestions x

--Gets the Attribute name of the Tree
getAttributeNode :: DTree -> String
getAttributeNode (Node x _) = getAttribute x
getAttributeNode (InfoTree x _) = getAttribute x

--Splits the string and get the attribute of the mushroom
getAttribute :: String -> String
getAttribute str = last (splitOn ": " str)

--Splits the string and get the Type name of Mushroom
getClass :: String -> String 
getClass str = head (splitOn ": " str)

--Generates a Prediction result
putPrediction :: String -> String
putPrediction str = "Prediction: " ++ getValueInString str

--Write the DataTree a little Preaty
writeMultipleTree :: [DTree] -> Int -> String
writeMultipleTree [] _ = ""
writeMultipleTree ((Node x y):xs) i = (duplicate "\t" i) ++ "Attr: " ++ x ++ "\n" ++ (duplicate "\t" (i + 1)) ++ "Value: " ++ (getValueInString y) ++ "\n\n" ++ writeMultipleTree xs i
writeMultipleTree ((InfoTree x y):xs) i = (duplicate "\t" i) ++ "Attr: " ++ x ++ "\n" ++ writeDifferent
    where 
        writeDifferent = if (length y > 0) then (writeMultipleTree y (i + 1) ++ writeMultipleTree xs (i)) else (writeMultipleTree xs (i) ++writeMultipleTree y (i + 1))

--Convert the string to Something   
getValueInString :: String -> String
getValueInString val = if (val == "e") then "Edible" else "Poisonous"

--Duplicate n times the string and concat it
duplicate :: String -> Int -> String
duplicate str n = concat $ replicate n str

--Concat two Strings
concatString :: (String, String) -> String
concatString (a, b) = a ++ b
-- END Questionary and Writting SECTION -------------------------------------------------------------------------------------


-- Data Tree Constructor SECTION --------------------------------------------------------------------------------------------

-- Construct the Data Tree
dtree :: String -> DataSet -> DTree
dtree f d 
    | allEqual (result d) = Node f $ head (result d) 
    | otherwise = InfoTree f $ M.foldrWithKey (\k a b -> b ++ [dtree k a] ) [] (datatrees d)

--Compare if all values are Equal
allEqual :: Eq a => [a] -> Bool
allEqual [] = True
allEqual [x] = True
allEqual (x:xs) = x == (head xs) && allEqual xs

--Get the Result name
result :: DataSet -> [Result]
result x = map snd x

--Get the Samples
samples :: DataSet -> [[String]]
samples xs = map fst xs

datatrees :: DataSet -> Map String DataSet
datatrees d =
  foldl (\m (x,n) -> M.insertWith (++) (x!!i) [((x `dropAt` i), fst (cs!!n))] m)
    M.empty (zip (samples d) [0..])
  where {i = highestInformationGain d;
    dropAt xs i = let (a,b) = splitAt i xs in a ++ drop 1 b;
    cs = zip (result d) [0..]}

--Get the position of the highest information of the DataSet
highestInformationGain :: DataSet -> Int
highestInformationGain d = snd $ maximum $ 
  zip (map ((informationGain . result) d) attrs) [0..]
  where {attrs = map (attr d) [0..num_attrs-1];
    attr d n = map (\(xs,x) -> (xs!!n,x)) d;
    num_attrs = (length . fst . head) d}

--Get the information Gain for one attribute related of the DataSet
informationGain :: [Result] -> [(Attribute, Result)] -> Double
informationGain s a = entropy s - newInformation
  where {eMap = splitEntropy $ splitAttr a;
    m = splitAttr a;
    toDouble x = read x :: Double;
    ratio x y = (fromIntegral x) / (fromIntegral y);
    sumE = M.map (\x -> (fromIntegral.length) x / (fromIntegral.length) s) m;
    newInformation = M.foldrWithKey (\k a b -> b + a*(eMap!k)) 0 sumE}

--Split the Tree
splitAttr :: [(Attribute, Result)] -> Map Attribute [Result]
splitAttr dc = foldl (\m (f,c) -> M.insertWith (++) f [c] m) M.empty dc

-- Obtain the different entropies
splitEntropy :: Map Attribute [Result] -> M.Map Attribute Entropy
splitEntropy m = M.map entropy m

-- Calculate the entropy of a list of values
entropy :: (Eq a) => [a] -> Entropy
entropy xs = sum $ map (\k -> prob k * into k) $ nub xs
    where 
    prob x = (/) (fromIntegral $ count x xs) (fromIntegral $ length xs)
    into x = negate $ logBase 2 (prob x)

--Count the number of ocurrences in a list
count :: Eq a => a -> [a] -> Int
count x = length . filter (x==)

-- END Data Tree Constructor SECTION --------------------------------------------------------------------------------------------


