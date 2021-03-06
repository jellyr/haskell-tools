{-# LANGUAGE PatternSynonyms #-}
module Decl.PatternSynonym where

data Type = App String [Type]

pattern Arrow :: Type -> Type -> Type
pattern Arrow t1 t2 = App "->"    [t1, t2]


pattern Int        <- App "Int"   []

pattern Maybe t    <- App "Maybe" [t]
   where Maybe (App "()" []) = App "Bool" []
         Maybe t = App "Maybe" [t]

------ this is not supported yet
-- class ListLike a where
--   pattern Head :: e -> a e
--   pattern Tail :: a e -> a e

-- instance ListLike [] where
--   pattern Head h = h:_
--   pattern Tail t = _:t