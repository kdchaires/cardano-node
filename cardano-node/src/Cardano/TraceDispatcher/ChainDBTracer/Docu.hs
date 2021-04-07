{-# LANGUAGE ScopedTypeVariables        #-}
{-# LANGUAGE AllowAmbiguousTypes        #-}


{-# OPTIONS_GHC -Wno-deprecations  #-}

module Cardano.TraceDispatcher.ChainDBTracer.Docu
  ( docChainDBTraceEvent
  ) where


import           Control.Monad.Class.MonadTime (Time (..))

import           Cardano.Logging
import           Cardano.Prelude hiding (Show, show)
import           Cardano.TraceDispatcher.OrphanInstances.Byron ()
import           Cardano.TraceDispatcher.OrphanInstances.Consensus ()
import           Cardano.TraceDispatcher.OrphanInstances.Network ()
import           Cardano.TraceDispatcher.OrphanInstances.Shelley ()

import           Ouroboros.Consensus.Block
import           Ouroboros.Consensus.Fragment.Diff (ChainDiff (..))
import           Ouroboros.Consensus.HeaderValidation
import           Ouroboros.Consensus.Ledger.Extended (ExtValidationError (..))
import qualified Ouroboros.Consensus.Storage.ChainDB as ChainDB
import qualified Ouroboros.Consensus.Storage.ChainDB.Impl.Types as ChainDB
import           Ouroboros.Consensus.Storage.FS.API.Types (FsPath, mkFsPath)
import qualified Ouroboros.Consensus.Storage.ImmutableDB as ImmDB
import qualified Ouroboros.Consensus.Storage.ImmutableDB.Impl.Types as ImmDB
import qualified Ouroboros.Consensus.Storage.LedgerDB.OnDisk as LedgerDB
import qualified Ouroboros.Consensus.Storage.VolatileDB as VolDB
import qualified Ouroboros.Consensus.Storage.VolatileDB.Impl.Types as VolDB
import qualified Ouroboros.Network.AnchoredFragment as AF

----------- Prototype objects for docu generation

docRealPoint :: RealPoint blk
docRealPoint = undefined

docPoint :: Point blk
docPoint = undefined

docHeaderDiff :: ChainDiff (HeaderFields blk)
docHeaderDiff = undefined

docValidationError :: ChainDB.InvalidBlockReason blk
docValidationError = undefined

docNTI :: ChainDB.NewTipInfo blk
docNTI = ChainDB.NewTipInfo docRealPoint (EpochNo 1) 1 docRealPoint

docAFH :: AF.AnchoredFragment (Header blk)
docAFH =  undefined

docExtValidationError :: ExtValidationError blk
docExtValidationError = ExtValidationErrorHeader (HeaderEnvelopeError (UnexpectedSlotNo 1 2))

docFollowerRollState :: ChainDB.FollowerRollState blk
docFollowerRollState = undefined

docWoSlotNo :: WithOrigin SlotNo
docWoSlotNo = undefined

docTime :: Time
docTime = undefined

docChunkNo :: ImmDB.ChunkNo
docChunkNo = undefined

docStreamFrom :: ChainDB.StreamFrom blk
docStreamFrom = undefined

docStreamTo :: ChainDB.StreamTo blk
docStreamTo = undefined

docUnknownRange :: ChainDB.UnknownRange blk
docUnknownRange = undefined

docDiskSnapshot :: LedgerDB.DiskSnapshot
docDiskSnapshot = undefined

docInitFailure :: LedgerDB.InitFailure blk
docInitFailure = undefined

docTip :: ImmDB.Tip blk
docTip = undefined

docChunkFileError :: ImmDB.ChunkFileError blk
docChunkFileError = undefined

docChainHash :: ChainHash blk
docChainHash = undefined

docWithOriginTip :: WithOrigin (ImmDB.Tip blk)
docWithOriginTip = undefined

docParseError :: VolDB.ParseError blk
docParseError = undefined

docFsPath :: FsPath
docFsPath = mkFsPath [""]

docBlockOffset :: VolDB.BlockOffset
docBlockOffset = undefined

----------- Documentation

docChainDBTraceEvent :: Documented (ChainDB.TraceEvent blk)
docChainDBTraceEvent = Documented [
    DocMsg
      (ChainDB.TraceAddBlockEvent
        (ChainDB.IgnoreBlockOlderThanK docRealPoint))
      []
      "A block with a 'BlockNo' more than @k@ back than the current tip\
      \ was ignored."
  , DocMsg
      (ChainDB.TraceAddBlockEvent
        (ChainDB.IgnoreBlockAlreadyInVolatileDB
          docRealPoint))
      []
      "A block that is already in the Volatile DB was ignored."
  , DocMsg
      (ChainDB.TraceAddBlockEvent
        (ChainDB.IgnoreInvalidBlock
          docRealPoint docValidationError))
      []
      "A block that is already in the Volatile DB was ignored."
  , DocMsg
      (ChainDB.TraceAddBlockEvent
        (ChainDB.AddedBlockToQueue
          docRealPoint 1))
      []
      "The block was added to the queue and will be added to the ChainDB by\
      \ the background thread. The size of the queue is included.."
  , DocMsg
      (ChainDB.TraceAddBlockEvent
        (ChainDB.BlockInTheFuture
          docRealPoint 1))
      []
      "The block is from the future, i.e., its slot number is greater than\
      \ the current slot (the second argument)."
  , DocMsg
      (ChainDB.TraceAddBlockEvent
        (ChainDB.AddedBlockToVolatileDB
          docRealPoint 1 ChainDB.IsEBB))
      []
      "A block was added to the Volatile DB"
  , DocMsg
      (ChainDB.TraceAddBlockEvent
        (ChainDB.TryAddToCurrentChain
          docRealPoint))
      []
      "The block fits onto the current chain, we'll try to use it to extend\
      \ our chain."
  , DocMsg
      (ChainDB.TraceAddBlockEvent
        (ChainDB.TrySwitchToAFork
          docRealPoint docHeaderDiff))
      []
      "The block fits onto some fork, we'll try to switch to that fork (if\
      \ it is preferable to our chain)"
  , DocMsg
      (ChainDB.TraceAddBlockEvent
        (ChainDB.StoreButDontChange
          docRealPoint))
      []
      "The block fits onto some fork, we'll try to switch to that fork (if\
      \ it is preferable to our chain)."
  , DocMsg
      (ChainDB.TraceAddBlockEvent
        (ChainDB.AddedToCurrentChain [] docNTI docAFH docAFH))
      []
      "The new block fits onto the current chain (first\
      \ fragment) and we have successfully used it to extend our (new) current\
      \ chain (second fragment)."
  , DocMsg
      (ChainDB.TraceAddBlockEvent
        (ChainDB.SwitchedToAFork [] docNTI docAFH docAFH))
      []
      "The new block fits onto some fork and we have switched to that fork\
      \ (second fragment), as it is preferable to our (previous) current chain\
      \ (first fragment)."
  , DocMsg
      (ChainDB.TraceAddBlockEvent
        (ChainDB.AddBlockValidation
          (ChainDB.InvalidBlock docExtValidationError docRealPoint)))
      []
      "An event traced during validating performed while adding a block.\
      \A point was found to be invalid."
  , DocMsg
      (ChainDB.TraceAddBlockEvent
        (ChainDB.AddBlockValidation
          (ChainDB.InvalidCandidate docAFH)))
      []
      "An event traced during validating performed while adding a block.\
      \A candidate chain was invalid."
  , DocMsg
      (ChainDB.TraceAddBlockEvent
        (ChainDB.AddBlockValidation
          (ChainDB.ValidCandidate docAFH)))
      []
      "An event traced during validating performed while adding a block\
      \A candidate chain was valid."
  , DocMsg
      (ChainDB.TraceAddBlockEvent
        (ChainDB.AddBlockValidation
          (ChainDB.CandidateContainsFutureBlocks docAFH [])))
      []
      "An event traced during validating performed while adding a block\
      \Candidate contains headers from the future which do no exceed the\
      \clock skew."
  , DocMsg
      (ChainDB.TraceAddBlockEvent
        (ChainDB.AddBlockValidation
          (ChainDB.CandidateContainsFutureBlocksExceedingClockSkew docAFH [])))
      []
      "An event traced during validating performed while adding a block\
      \An event traced during validating performed while adding a block\
      \Candidate contains headers from the future which do no exceed the\
      \clock skew."
  , DocMsg
      (ChainDB.TraceAddBlockEvent
        (ChainDB.ChainSelectionForFutureBlock docRealPoint))
      []
      "Run chain selection for a block that was previously from the future.\
      \ This is done for all blocks from the future each time a new block is\
      \ added."
  , DocMsg
      (ChainDB.TraceFollowerEvent ChainDB.NewFollower)
      []
      "A new follower was created."
  , DocMsg
      (ChainDB.TraceFollowerEvent
        (ChainDB.FollowerNoLongerInMem docFollowerRollState))
      []
      "The follower was in the 'FollowerInImmutableDB' state and is switched to\
      \ the 'FollowerInMem' state."
  , DocMsg
      (ChainDB.TraceFollowerEvent
        (ChainDB.FollowerSwitchToMem docPoint docWoSlotNo))
      []
      "The follower was in the 'FollowerInImmutableDB' state and is switched to\
      \ the 'FollowerInMem' state."
  , DocMsg
      (ChainDB.TraceFollowerEvent
        (ChainDB.FollowerNewImmIterator docPoint docWoSlotNo))
      []
      "The follower is in the 'FollowerInImmutableDB' state but the iterator is\
      \ exhausted while the ImmDB has grown, so we open a new iterator to\
      \ stream these blocks too."
  , DocMsg
      (ChainDB.TraceCopyToImmutableDBEvent
        (ChainDB.CopiedBlockToImmutableDB docPoint))
      []
      "A block was successfully copied to the ImmDB."
  , DocMsg
      (ChainDB.TraceCopyToImmutableDBEvent
        (ChainDB.NoBlocksToCopyToImmutableDB))
      []
      "There are no block to copy to the ImmDB."
  , DocMsg
      (ChainDB.TraceGCEvent
        (ChainDB.ScheduledGC 1 docTime))
      []
      "There are no block to copy to the ImmDB."
  , DocMsg
      (ChainDB.TraceGCEvent
        (ChainDB.PerformedGC 1))
      []
      "There are no block to copy to the ImmDB."
  , DocMsg
      (ChainDB.TraceInitChainSelEvent
        (ChainDB.InitChainSelValidation
          (ChainDB.InvalidBlock docExtValidationError docRealPoint)))
      []
      "A point was found to be invalid."
  , DocMsg
      (ChainDB.TraceInitChainSelEvent
        (ChainDB.InitChainSelValidation
          (ChainDB.InvalidCandidate docAFH)))
      []
      "A candidate chain was invalid."
  , DocMsg
      (ChainDB.TraceInitChainSelEvent
        (ChainDB.InitChainSelValidation
          (ChainDB.ValidCandidate docAFH)))
      []
      "A candidate chain was valid."
  , DocMsg
      (ChainDB.TraceInitChainSelEvent
        (ChainDB.InitChainSelValidation
          (ChainDB.CandidateContainsFutureBlocks docAFH [])))
      []
      "Candidate contains headers from the future which do not exceed the\
      \ clock skew."
  , DocMsg
      (ChainDB.TraceInitChainSelEvent
        (ChainDB.InitChainSelValidation
          (ChainDB.CandidateContainsFutureBlocksExceedingClockSkew docAFH [])))
      []
      "Candidate contains headers from the future which exceed the\
      \ clock skew, making them invalid."

  , DocMsg
      (ChainDB.TraceOpenEvent
        (ChainDB.OpenedDB docPoint docPoint))
      []
      "The ChainDB was opened."
  , DocMsg
      (ChainDB.TraceOpenEvent
        (ChainDB.ClosedDB docPoint docPoint))
      []
      "The ChainDB was closed."
  , DocMsg
      (ChainDB.TraceOpenEvent
        (ChainDB.OpenedImmutableDB docPoint docChunkNo))
      []
      "The ImmDB was opened."
  , DocMsg
      (ChainDB.TraceOpenEvent
        ChainDB.OpenedVolatileDB)
      []
      "The VolatileDB was opened."
  , DocMsg
      (ChainDB.TraceOpenEvent
        ChainDB.OpenedLgrDB)
      []
      "The LedgerDB was opened."
  , DocMsg
      (ChainDB.TraceIteratorEvent
        (ChainDB.UnknownRangeRequested docUnknownRange))
      []
      "An unknown range was requested, see 'UnknownRange'."
  , DocMsg
      (ChainDB.TraceIteratorEvent
        (ChainDB.StreamFromVolatileDB docStreamFrom docStreamTo [docRealPoint]))
      []
      "Stream only from the VolatileDB."
  , DocMsg
      (ChainDB.TraceIteratorEvent
        (ChainDB.StreamFromImmutableDB docStreamFrom docStreamTo))
      []
      "Stream only from the ImmDB."
  , DocMsg
      (ChainDB.TraceIteratorEvent
        (ChainDB.StreamFromBoth docStreamFrom docStreamTo [docRealPoint]))
      []
      "Stream from both the VolatileDB and the ImmDB."
  , DocMsg
      (ChainDB.TraceIteratorEvent
        (ChainDB.BlockMissingFromVolatileDB docRealPoint))
      []
      " A block is no longer in the VolatileDB because it has been garbage\
      \ collected. It might now be in the ImmDB if it was part of the\
      \ current chain."
  , DocMsg
      (ChainDB.TraceIteratorEvent
        (ChainDB.BlockWasCopiedToImmutableDB docRealPoint))
      []
      "A block that has been garbage collected from the VolatileDB is now\
      \ found and streamed from the ImmDB."
  , DocMsg
      (ChainDB.TraceIteratorEvent
        (ChainDB.BlockGCedFromVolatileDB docRealPoint))
      []
      "A block is no longer in the VolatileDB and isn't in the ImmDB\
      \ either; it wasn't part of the current chain."
  , DocMsg
      (ChainDB.TraceIteratorEvent
        ChainDB.SwitchBackToVolatileDB)
      []
      "We have streamed one or more blocks from the ImmDB that were part\
      \ of the VolatileDB when initialising the iterator. Now, we have to look\
      \ back in the VolatileDB again because the ImmDB doesn't have the\
      \ next block we're looking for."
  , DocMsg
      (ChainDB.TraceLedgerEvent
        (LedgerDB.InvalidSnapshot docDiskSnapshot docInitFailure))
      []
      "An on disk snapshot was skipped because it was invalid."
  , DocMsg
      (ChainDB.TraceLedgerEvent
        (LedgerDB.TookSnapshot docDiskSnapshot docRealPoint))
      []
      "A snapshot was written to disk."
  , DocMsg
      (ChainDB.TraceLedgerEvent
        (LedgerDB.DeletedSnapshot docDiskSnapshot))
      []
      "An old or invalid on-disk snapshot was deleted."

  , DocMsg
      (ChainDB.TraceLedgerReplayEvent
        (LedgerDB.ReplayFromGenesis docPoint))
      []
      "There were no LedgerDB snapshots on disk, so we're replaying all\
      \ blocks starting from Genesis against the initial ledger.\
      \ The @replayTo@ parameter corresponds to the block at the tip of the\
      \ ImmDB, i.e., the last block to replay."
  , DocMsg
      (ChainDB.TraceLedgerReplayEvent
        (LedgerDB.ReplayFromSnapshot docDiskSnapshot docRealPoint docPoint))
      []
      "There was a LedgerDB snapshot on disk corresponding to the given tip.\
      \ We're replaying more recent blocks against it.\
      \ The @replayTo@ parameter corresponds to the block at the tip of the\
      \ ImmDB, i.e., the last block to replay."
  , DocMsg
      (ChainDB.TraceLedgerReplayEvent
        (LedgerDB.ReplayedBlock docRealPoint [] docPoint))
      []
      "We replayed the given block (reference) on the genesis snapshot\
      \ during the initialisation of the LedgerDB.\
      \ \
      \ The @blockInfo@ parameter corresponds replayed block and the @replayTo@\
      \ parameter corresponds to the block at the tip of the ImmDB, i.e.,\
      \ the last block to replay."

  , DocMsg
      (ChainDB.TraceImmutableDBEvent ImmDB.NoValidLastLocation)
      []
      "No valid last location was found"
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.ValidatedLastLocation docChunkNo docTip))
      []
      "The last location was validatet"
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.ValidatingChunk docChunkNo))
      []
      "The chunk was validatet"
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.MissingChunkFile docChunkNo))
      []
      "Chunk file is missing"
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.InvalidChunkFile docChunkNo docChunkFileError))
      []
      "Chunk file is invalid"
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.ChunkFileDoesntFit docChainHash docChainHash))
      []
      "The hash of the last block in the previous epoch doesn't match the\
      \ previous hash of the first block in the current epoch"
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.MissingPrimaryIndex docChunkNo))
      []
      "The primary index is missing."
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.MissingSecondaryIndex docChunkNo))
      []
      "The secondary index is missing."
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.InvalidPrimaryIndex docChunkNo))
      []
      "The primary index is invalid."
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.InvalidSecondaryIndex docChunkNo))
      []
      "The secondary index is invalid."
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.RewritePrimaryIndex docChunkNo))
      []
      "The primary index gets rewritten."
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.RewriteSecondaryIndex docChunkNo))
      []
      "The secondary index gets rewritten."
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.Migrating ""))
      []
      "Performing a migration of the on-disk files."
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.DeletingAfter docWithOriginTip))
      []
      "TODO"
  , DocMsg
      (ChainDB.TraceImmutableDBEvent ImmDB.DBAlreadyClosed)
      []
      "The immutable DB is already closed"
  , DocMsg
      (ChainDB.TraceImmutableDBEvent ImmDB.DBClosed)
      []
      "Closing the immutable DB"
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.TraceCacheEvent
          (ImmDB.TraceCurrentChunkHit docChunkNo 1)))
      []
      "TODO"
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.TraceCacheEvent
          (ImmDB.TracePastChunkHit docChunkNo 1)))
      []
      "TODO"
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.TraceCacheEvent
          (ImmDB.TracePastChunkMiss docChunkNo 1)))
      []
      "TODO"
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.TraceCacheEvent
          (ImmDB.TracePastChunkEvict docChunkNo 1)))
      []
      "The least recently used past chunk was evicted because the cache\
      \ was full."
  , DocMsg
      (ChainDB.TraceImmutableDBEvent
        (ImmDB.TraceCacheEvent
          (ImmDB.TracePastChunksExpired [docChunkNo] 1)))
      []
      "Past chunks were expired from the cache because they haven't been\
      \ used for a while."

  , DocMsg
      (ChainDB.TraceVolatileDBEvent
        (VolDB.DBAlreadyClosed))
      []
      "TODO"
  , DocMsg
      (ChainDB.TraceVolatileDBEvent
        (VolDB.DBAlreadyOpen))
      []
      "TODO"
  , DocMsg
      (ChainDB.TraceVolatileDBEvent
        (VolDB.Truncate docParseError docFsPath docBlockOffset))
      []
      "TODO"
  , DocMsg
      (ChainDB.TraceVolatileDBEvent
        (VolDB.InvalidFileNames [docFsPath]))
      []
      "TODO"
  , DocMsg
      (ChainDB.TraceVolatileDBEvent
        (VolDB.BlockAlreadyHere undefined))
      []
      "TODO"
  , DocMsg
      (ChainDB.TraceVolatileDBEvent
        (VolDB.TruncateCurrentFile docFsPath))
      []
      "TODO"
  ]
