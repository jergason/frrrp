module Actions where

type Action =
    PlaySound String
  | NoOp
  | SetAngel Bool
