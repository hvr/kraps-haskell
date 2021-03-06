{-# LANGUAGE FlexibleContexts #-}

{- |
Module      : Spark.Core.Column
Description : Column types and basic operations.

Operations on columns.
-}
module Spark.Core.Column(
  -- * Types
  Column,
  DynColumn,
  -- * Extractions and collations
  asCol,
  pack1,
  pack,
  pack',
  struct,
  struct',
  castCol,
  castCol',
  colRef,
  (//),
  -- ToStaticProjectable,
  StaticColProjection,
  DynamicColProjection,
  unsafeStaticProjection,
  -- * Column functions
  colType,
  untypedCol,
  colFromObs,
  colFromObs'
  ) where

import Spark.Core.Internal.ColumnStructures
import Spark.Core.Internal.ColumnFunctions
import Spark.Core.Internal.AlgebraStructures
import Spark.Core.Internal.FunctionsInternals
