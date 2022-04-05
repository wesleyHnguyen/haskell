{-
  Functors have kind : * -> *

  function/operator: (->) - have kind  * -> * -> *, (->) r -> kind of * -> *

  (->) r type is also a member of Funtor typeclass

  fmap :: (a -> b) -> ((-> r) a) -> ((-> r) b)
  fmap f g = (\x -> f(g x))

  prove that all type  still hold:
  f :: a -> b
  g :: r -> a

  \x -> f (g x) --   (g x :: a) && f (g x :: a) ==> f (y :: a) -> z :: b

  instance Functor (-> r) where
  fmap = (.)

-}