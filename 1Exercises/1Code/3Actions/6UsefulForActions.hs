module UsefulForActions where
import Types 
import Renaming            (append,wrap,andThen,and,unwrapAnd,glue,forEach,printString)
import Renaming            (convertIntToString,convertIntFromString)
import Prelude             (not,(<),(.),filter,(&&),(>),(||),(==),repeat,take)
import Prelude             (length,Bool(..),getLine,Int,IO,(+),($),elem,(-),(!!))
import StringFromExercises (exercisesToString)
import FileManagement      (writeToNextDataKeeper)
import Data.Function       ((&))

beautify        = ("\t"`append`)`and`(`append`"\n")
putTogether     = forEach ((`append`repeat ' ')`and`take 25)`and`glue
printBeutified  = beautify`and`printString
exercisesToFile = exercisesToString`and`writeToNextDataKeeper
getChoice       = getLine`unwrapAnd`(convertIntFromString`and`wrap)

-- Show Subjects
showSubjects = \exs->exs&getSubjects&printSubjects 1
getSubjects = \case 
 []     -> []
 ex:exs -> 
  let
   sub  = ex&getData& \(s,_,_)->s
   subs = getSubjects exs 
  in
  elem sub subs& \case 
   True -> subs
   _    -> sub:subs
printSubjects :: Int->Strings->IO ()
printSubjects = \i-> \case
 []      ->wrap ()
 sub:subs->
  (printString $ glue [convertIntToString i,": ",sub])`andThen`
  printSubjects (i+1) subs
getSub = \case
 Done   (sub,_,_)  ->sub
 Missed (sub,_,_)  ->sub
 ToDo   (sub,_,_) _->sub

-- Sort Chronologically
sortChrono = \case 
 []    ->[]     
 ex:exs-> sortChrono (filter (before     ex) exs)`append`[ex]`append`
          sortChrono (filter (not.before ex) exs)

before   = \e1 e2->getTDate e2`isBefore`getTDate e1
isBefore = \[d,m,y] [d',m',y']-> y<y'||(y==y'&&m<m')||(y==y'&&m==m'&&d<d')

askFor = \s ->
 printString s`andThen`getLine`unwrapAnd`\a->
 case length a>20 of
  True->printString "More than 20 chars is not pretty"`andThen`askFor s
  _   ->wrap a