module Main where

import Prelude
import Data.Function.Uncurried (Fn2, runFn2)
import Type.Row (class ListToRow, class RowToList, Cons, Nil, kind RowList)

-- foreign import kind RowList
-- foreign import data Nil :: RowList
-- foreign import data Cons :: Symbol -> Type -> RowList -> RowList

-- class RowToList
--   (row ∷ # Type)
--   (list ∷ RowList) |
--   row → list

class ApplyRecord
  (io ∷ # Type)
  (i ∷ # Type)
  (o ∷ # Type)
  | i o → io
  , io o → i
  , io i → o

instance applyRecordInst
  ∷ ( RowToList io lio
    , RowToList i li
    , RowToList o lo
    , ApplyRowList lio li lo
    , ListToRow lio io
    , ListToRow li i
    , ListToRow lo o
    )
  ⇒ ApplyRecord io i o

class ApplyRowList
  (io ∷ RowList)
  (i ∷ RowList)
  (o ∷ RowList)
  | i o → io
  , io o → i
  , io i → o

instance applyRowListNil
  ∷ ApplyRowList Nil Nil Nil
instance applyRowListCons
  ∷ ApplyRowList tio ti to
  ⇒ ApplyRowList (Cons k (i → o) tio) (Cons k i ti) (Cons k o to)

foreign import applyRecordImpl
  ∷ ∀ io i o
  . ApplyRecord io i o
  ⇒ Fn2 (Record io) (Record i) (Record o)

applyRecord
  ∷ ∀ io i o
  . ApplyRecord io i o
  ⇒ Record io
  → Record i
  → Record o
applyRecord s t = runFn2 applyRecordImpl s t

foo ∷
  { a ∷ Boolean → String
  , b ∷ Int → Boolean
  }
foo =
  { a: show
  , b: (_ > 0)
  }
