{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module Spark.Core.CollectSpec where

import Test.Hspec
import qualified Data.Text
import Data.List(sort)

import Spark.Core.Context
import Spark.Core.Types
import Spark.Core.Row
import Spark.Core.Functions
import Spark.Core.Column


-- Collecting a dataset made from a list should yield the same list (modulo
-- some reordering)
-- TODO: replace the ordering by the canonical ordering over the data
collectIdempotent :: (Ord a, Eq a, Show a, SQLTypeable a, ToSQL a, FromSQL a) => [a] -> IO ()
collectIdempotent l = do
  let ds = dataset l
  l2 <- exec1Def $ collect (asCol ds)
  l2 `shouldBe` sort l

run :: String -> IO () -> SpecWith (Arg (IO ()))
run s f = it s $ do
  createSparkSessionDef $ defaultConf { confRequestedSessionName = Data.Text.pack s }
  f
  -- This is horribly not robust to any sort of failure, but it will do for now
  -- TODO(kps) make more robust
  closeSparkSessionDef
  return ()

spec :: Spec
spec = do
  describe "Integration test - collect on ints" $ do
    run "empty_ints1" $
      collectIdempotent ([] :: [Int])
    run "ints1" $
      collectIdempotent ([4,5,1,2,3] :: [Int])
    -- TODO(kps) in Spark 2.0.2, this fails!!!
    -- Works with Spark 2.0.1 -> report
    -- run "ints1_opt" $
    --   collectIdempotent ([Just 1, Nothing] :: [Maybe Int])
    -- run "nothing_ints_opt" $
    --   collectIdempotent ([Nothing] :: [Maybe Int])
    run "ints1_opt" $
      collectIdempotent ([Just 1, Just 2] :: [Maybe Int])
    run "empty_ints_opt" $
      collectIdempotent ([] :: [Maybe Int])
  -- describe "Integration test - collect on TestStruct5" $ do
  --   run "empty_TestStruct5" $
  --     collectIdempotent ([] :: [TestStruct5])
  --   run "empty_TestStruct5" $
  --     collectIdempotent ([TestStruct5 1 2] :: [TestStruct5])
