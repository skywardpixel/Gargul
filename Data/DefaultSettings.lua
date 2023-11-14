---@type GL
local _, GL = ...;

---@class DefaultSettings : Data
GL.Data = GL.Data or {};

GL.Data.DefaultSettings = {
    autoOpenCommandHelp = true,
    changeLog = true,
    debugModeEnabled = false,
    fontSize = 11,
    highlightsEnabled = true,
    highlightMyItemsOnly = false,
    highlightHardReservedItems = true,
    highlightSoftReservedItems = true,
    highlightWishlistedItems = true,
    highlightPriolistedItems = true,
    noMessages = false,
    noSounds = false,
    profilerEnabled = false,
    showMinimapButton = true,
    showUpdateAlert = false,
    soundChannel = "SFX",
    welcomeMessage = true,

    DroppedLoot = {
        announceLootToChat = true,
        announceDroppedLootInRW = false,
        minimumQualityOfAnnouncedLoot = 4,
        minimumQualityOfLoggedLoot = 4,
    },
    ShortcutKeys = {
        auction = "DISABLED",
        award = "ALT_SHIFT_CLICK",
        disableWhenCLMIsActive = false,
        disenchant = "CTRL_SHIFT_CLICK",
        doubleClickToTrade = true,
        onlyInGroup = false,
        rollOff = "DISABLED",
        rollOffOrAuction = "ALT_CLICK",
        showLegend = true,
    },
    MasterLooting = {
        alwaysUseDefaultNote = false,
        announceCountdownOnce = false,
        announceMasterLooter = false,
        autoOpenMasterLooterDialog = true,
        announceMasterLooterMessage = "I'm using the Gargul addon to distribute loot. Download it if you don't want to miss out on rolls!",
        announceRollEnd = true,
        announceRollStart = true,
        linkNormalAndHardModeItems = false,
        defaultRollOffNote = "/roll for MS or /roll 99 for OS",
        doCountdown = true,
        numberOfSecondsToCountdown = 5,
        preferredMasterLootingThreshold = 2,
    },
    AwardingLoot = {
        announceAwardMessagesInGuildChat = false,
        announceAwardMessagesInRW = false,
        autoAssignAfterAwardingAnItem = true,
        autoTradeAfterAwardingAnItem = true,
        autoTradeDisenchanter = true,
        autoTradeInCombat = true,
        awardMessagesEnabled = true,
        awardOnReceive = false,
        awardOnReceiveMinimumQuality = 4,
        skipAwardConfirmationDialog = false,
    },
    ExportingLoot = {
        includeDisenchantedItems = true,
        includeOffspecItems = true,
        customFormat = "@ID;@DATE @TIME;@WINNER",
        disenchanterIdentifier = "_disenchanted",
        showLootAssignmentReminder = true,
    },
    LootTradeTimers = {
        enabled = true,
        hideAwarded = false,
        hideAwardedToSelf = false,
        hideDisenchanted = false,
        maximumNumberOfBars = 5,
        maximumTradeTimeLeft = 120,
        scale = 1,
        showHotkeyReminder = true,
        showOnlyWhenMasterLooting = true,
        Broadcast = {
            channel = 1,
            includeAwardedItems = false,
            includeDisenchantedItems = false,
            includeHiddenItems = false,
            includeTimeLeft = true,
            maximumTradeTimeLeft = 120,
            minimumQuality = 4,
            numberOfItems = 20,
            target = nil,
        }
    },
    PackMule = {
        announceDisenchantedItems = true,
        autoConfirmSolo = false,
        autoConfirmGroup = false,
        autoDisableForGroupLoot = true,
        enabledForGroupLoot = false,
        enabledForMasterLoot = false,
        lootGold = true,
        Rules = {},
    },
    Rolling = {
        showRollOffWindow = true,
        closeAfterRoll = false,
        scale = 1,
    },
    RollTracking = {
        sortBySoftRes = true,
        sortByTMBWishlist = true,
        sortByTMBPrio = true,
        trackAll = false,
        Brackets = {
            {"MS", 1, 100, 2, false, false},
            {"OS", 1, 99, 3, true, false},
        },
    },
    SoftRes = {
        announceInfoInChat = true,
        announceInfoWhenRolling = true,
        enableTooltips = true,
        enableWhisperCommand = true,
        fixPlayerNames = true,
        hideInfoOfPeopleNotInGroup = true,
    },
    BoostedRolls = {
        automaticallyAcceptDataFrom = "",
        automaticallyShareData = true,
        defaultCost = 10,
        defaultPoints = 100,
        defaultStep = 10,
        enabled = false,
        enableWhisperCommand = true,
        fixedRolls = false,
        identifier = "BR",
        priority = 1,
        reserveThreshold = 180,
    },
    PlusOnes = {
        automaticallyAcceptDataFrom = "",
        automaticallyShareData = false,
        blockShareData = false,
        enableWhisperCommand = true,
    },
    GDKP = {
        ItemLevelDetails = {},

        acceptBidsLowerThanMinimum = false, -- Change default? Check Auction.lua !!
        addDropsToQueue = true,
        addBOEDropsToQueue = true,
        minimumDropQuality = 4,
        addGoldToTradeWindow = true,
        announceAuctionStart = true,
        announceCountdownInRW = true,
        announceFinalCall = true,
        announceNewBidInRW = true,
        announceBidsClosed = true,
        announceNewBid = true,
        announcePotAfterAuction = true,
        antiSnipe = 15,
        auctionEndLeeway = 2,
        autoAwardViaAuctioneer = true,
        bidderScale = 1,
        bidderQueueHideUnusable = false,
        defaultMinimumBid = 500,
        defaultIncrement = 100,
        delayBetweenQueuedAuctions = 1,
        disableQueues = false,
        enableBidderQueue = true,
        exportFormat = 1,
        finalCallTime = 10,
        potExportFormat = 1,
        customExportHeader = "Item,Player,Gold,Wowheadlink",
        customExportFormat = "@ITEM,@WINNER,@GOLD,@WOWHEAD",
        customPotExportHeader = "Player,Cut",
        customPotExportFormat = "@PLAYER,@CUT",
        invalidBidsTriggerAntiSnipe = true,
        ledgerAuctionScale = 30,
        closeAuctioneerOnAward = false,
        minimizeAuctioneerOnStart = true,
        notifyIfBidTooLow = true,
        numberOfSecondsToCountdown = 5,
        numberOfFiveSecondsToCountdown = 15,
        outbidSound = "Gargul: uh-oh",
        queuedAuctionNoBidsAction = "SKIP",
        showBidWindow = true,
        showQueueWindow = true,
        showHistoryOnTooltip = true,
        storeMinimumAndIncrementPerItem = true,
        queueIsHalted = true,
        time = 30,
        whisperGoldDetails = true,

        -- This holds minimum bid and increment settings per item
        SettingsPerItem = {},

        MultiAuction = {
            awardNotice = true,
            antiSnipe = 15,
            includeAwarded = false,
            includeBOEs = true,
            includeMaterials = false,
            minimumFillQuality = 4,
            time = 600,
        },
    },
    TMB = {
        announcePriolistInfoWhenRolling = true,
        announceWishlistInfoWhenRolling = true,
        automaticallyShareData = false,
        hideInfoOfPeopleNotInGroup = true,
        hideWishListInfoIfPriorityIsPresent = true,
        includePrioListInfoInLootAnnouncement = true,
        includeWishListInfoInLootAnnouncement = true,
        maximumNumberOfTooltipEntries = 35,
        maximumNumberOfAnnouncementEntries = 5,
        OSHasLowerPriority = true,
        shareWhitelist = "",
        showEntriesWhenSolo = true,
        showEntriesWhenUsingPrio3 = true,
        showItemInfoOnTooltips = true,
        showPrioListInfoOnTooltips = true,
        showRaidGroup = true,
        showWishListInfoOnTooltips = true,
    },
    TradeAnnouncements = {
        alwaysAnnounceEnchantments = true,
        enchantmentReceived = true,
        enchantmentGiven = true,
        goldReceived = true,
        goldGiven = true,
        itemsReceived = true,
        itemsGiven = true,
        minimumQualityOfAnnouncedLoot = 0,
        mode = "WHEN_MASTERLOOTER",
    },
    UI = {
        RollOff = {
            closeOnStart = false,
            closeOnAward = false,
            timer = 30,
        },
        PopupDialog = {
            Position = {
                offsetX = 0,
                offsetY = -115,
                point = "TOP",
                relativePoint = "TOP",
            }
        },
        Award = {
            closeOnAward = true,
        },
        ReopenAuctioneerButton = {
            offsetX = 188,
            relativePoint = "CENTER",
            offsetY = -5.5,
            Position = {
                offsetX = 188,
                offsetY = -5.5,
                point = "CENTER",
                relativePoint = "CENTER",
            },
            point = "CENTER",
        },
    }
};