module SwitchableStack
    ( State,
      empty,
      push,
      pop,
      setInactive,
      setActive,
      mapState,
      popWhere
    ) where

import Data.List (elem,nub)

newtype State a = State (Bool, [a])

{- This should create an empty state of your stack. 
   By default, your stack should be active. -}
empty :: State a
empty = State (True, [])

{- This should push a new element onto your stack.
   In this stack, you cannot have two of the element on the stack.
   If the element already exists on the stack, do not edit the state. -}
push :: (Eq a) => State a -> a -> State a
push (State (isActive, s)) x =
   if x `elem` s then
      State (isActive, s)
   else
      State (isActive, x:s)


{- This should pop the most recently added element off the stack.
   If there are no elements on the stack, return Nothing and an
   unedited version of the stack.
   If the stack is not active, return Nothing and an unedited version
   of the stack. -}
pop :: State a -> (Maybe a,State a)
pop (State (isActive, [])) = (Nothing, State (isActive, []))
pop (State (isActive, h:t)) = 
   if isActive then
      (Just h, State(isActive, t))
   else
      (Nothing, State (isActive, h:t))

{- This should switch the stack to the "inactive" state.
When a stack is inactive, elements can be pushed on it, but they
cannot be popped off it. -}
setInactive :: State a -> State a
setInactive (State (_, s)) =
   State (False, s)

{- This should switch the stack to the "active" state.
When a stack is active, elements can be pushed on it, and they
can be popped off it. -}
setActive :: State a -> State a
setActive (State (_, s)) =
   State (True, s)

{- This edits elements on the stack according to the provided function.
   However, this edit may cause duplicates to be added. After mapping the state,
   be sure to remove duplicate elements. -}
mapState :: (Eq b) => (a -> b) -> State a -> State b
mapState f (State (isActive, s)) =
   State (isActive, new_s) 
   where
      new_s = nub (map f s)

{- This pops all elements that satisfy a given predicate off the stack.
   The remaining elements on the stack are those that do not satisfy
   the provided predicate, in the original order.
   Do not pop any elements from the stack if the stack is inactive. -}
popWhere :: (a -> Bool) -> State a -> ([a],State a)
popWhere _ (State (False, s)) =
   ([], State (False, s))
popWhere f (State (isActive, s)) = 
   let 
      popped = fst (helpPop f s ([],[]))
      new_s = snd (helpPop f s ([],[])) in

   (popped, State (isActive, new_s))

   where
      helpPop :: (a -> Bool) -> [a] -> ([a], [a]) -> ([a], [a])
      helpPop _ [] acc = acc
      helpPop f (h:t) (popped, new_s) =
         if f h then
            helpPop f t (popped++[h], new_s)
         else
            helpPop f t (popped, new_s ++ [h])


