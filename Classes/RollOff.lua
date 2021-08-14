---@type GL
local _, GL = ...;

---@class RollOff
GL.RollOff = GL.RollOff or {
    inProgress = false,
    timerId = 0, -- ID of the timer event
    rollPattern = GL:createPattern(RANDOM_ROLL_RESULT), -- This pattern is used to validate incoming rules
    CurrentRollOff = {
        initiator = nil, -- The player who started the roll off
        time = nil, -- The amount of time players get to roll
        itemId = nil, -- The ID of the item we're rolling for
        itemName = nil, -- The name of the item we're rolling for
        itemLink = nil, -- The item link of the item we're rolling for
        itemIcon = nil, -- The icon of the item we're rolling for
        note = nil, -- The note displayed on the progress bar
        Rolls = {}, -- Player rolls
    }
};
local RollOff = GL.RollOff; ---@type RollOff

local CommActions = GL.Data.Constants.Comm.Actions;
local Events = GL.Events; ---@type Events

--- Anounce to everyone in the raid that a roll off is starting
---
---@param itemLink string
---@param time number
---@param note string|nil
---@return void
function RollOff:announceStart(itemLink, time, note)
    GL:debug("RollOff:announceStart");

    time = tonumber(time);

    if (type(itemLink) ~= "string"
        or GL:empty(itemLink)
        or not GL:higherThanZero(time)
    ) then
        GL:warning("Invalid data provided for roll of start!");
        return false;
    end

    self:listenForRolls();

    GL.CommMessage.new(
        CommActions.startRollOff,
        {
            item = itemLink,
            time = time,
            note = note,
        },
        "RAID"
    ):send();

    local announceMessage = string.format("You have %s seconds to roll on %s", time, itemLink);
    local reserveMessage = "";
    local reserves = GL.SoftRes:byItemLink(itemLink);

    if (type(note) == "string"
        and not GL:empty(note)
    ) then
        announceMessage = string.format("You have %s seconds to roll on %s - %s", time, itemLink, note);
    end

    if (reserves) then
        reserves = table.concat(reserves, ", ");
        reserveMessage = "This item has been reserved by: " .. reserves;
    end

    if (GL.User.isInRaid) then
        GL:sendChatMessage(
            announceMessage,
            "RAID_WARNING",
            "COMMON"
        );

        if (reserveMessage) then
            GL:sendChatMessage(
                reserveMessage,
                "RAID",
                "COMMON"
            );
        end
    else
        GL:sendChatMessage(
            announceMessage,
            "PARTY",
            "COMMON"
        );
    end

    return true;
end

--- Anounce to everyone in the raid that a roll off has ended
---
---@return void
function RollOff:announceStop()
    GL:debug("RollOff:announceStop");

    GL.CommMessage.new(
        CommActions.stopRollOff,
        nil,
        "RAID"
    ):send();

    self:stopListeningForRolls();
end

--- Start a roll off
--- This is done via a CommMessage even for the masterlooter to make
--- sure that the roll off starts simultaneously for everyone
---
---@param CommMessage CommMessage
function RollOff:start(CommMessage)
    GL:debug("RollOff:start");

    if (not GL.Settings:get("Rolling.showRollOffWindow")) then
        return;
    end

    local content = CommMessage.content;

    --[[
        MAKE SURE THE PAYLOAD IS VALID
        PROVIDE VERY SPECIFIC ERROR MESSAGE IF IT'S NOT
    ]]
    if (not content) then
        return GL:error("Missing content in RollOff:start");
    elseif (not type(content) == "table") then
        return GL:error("Content is not a table in RollOff:start");
    elseif (not content.time) then
        return GL:error("No time provided in RollOff:start");
    elseif (not content.item) then
        return GL:error("No item provided in RollOff:start");
    else

        --- We have to wait with starting the actual roll off process until
        --- the item that's up for rolling has been successfully loaded by the Item API
        ---
        ---@vararg Item
        ---@return void
        GL:onItemLoadDo(content.item, function (Items)
            for _, Entry in pairs(Items) do
                local time = tonumber(content.time);
                self.inProgress = true;

                -- This is a new roll off so clean everything
                if (Entry.link ~= self.CurrentRollOff.itemLink) then
                    -- This is a new item so make sure to
                    -- override all previously set properties
                    self.CurrentRollOff = {
                        initiator = CommMessage.Sender.name,
                        time = time,
                        itemId = Entry.id,
                        itemName = Entry.name,
                        itemLink = Entry.link,
                        itemIcon = Entry.icon,
                        note = content.note,
                        Rolls = {},
                    };
                else
                    -- If we roll the same item again we do need to make
                    -- sure that we update the roll timer
                    self.CurrentRollOff.time = time;
                end

                GL.RollerUI:show(time, Entry.id, Entry.link, Entry.icon, content.note);

                self.timerId = GL.Ace:ScheduleTimer(function ()
                    self:stop();
                end, time);

                -- Play raid warning sound
                GL:playSound(8959, "Master");
                return;
            end
        end);
    end
end

--- Stop a roll off. This method can be invoked internally when the roll
--- off time is over or when announced by the initiation of the roll off.
---
---@param CommMessage string|nil
---@return boolean
function RollOff:stop(CommMessage)
    GL:debug("RollOff:stop");

    if (not RollOff.inProgress) then
        return GL:warning("Can't stop roll off, no roll off in progress");
    end

    if (CommMessage
        and self.CurrentRollOff.initiator ~= GL.User.name
        and CommMessage.Sender.name ~= self.CurrentRollOff.initiator
    ) then
        if (self.CurrentRollOff.initiator) then
            GL:warning(CommMessage.Sender.name .. " is not allowed to stop roll off started by " .. self.CurrentRollOff.initiator);
        else
            GL:warning(CommMessage.Sender.name .. " is not allowed to stop current roll off: roll off is invalid");
        end

        return false;
    end

    -- Play raid warning sound
    GL:playSound(8959);

    RollOff.inProgress = false;
    GL.Ace:CancelTimer(RollOff.timerId);

    GL.RollerUI:hide();

    -- If we're the initiator then we need to update our initiator UI
    if (RollOff.CurrentRollOff.initiator == GL.User.name) then
        GL.MasterLooterUI:updateWidgets();
    end

    return true;
end

-- Award the item to one of the rollers
function RollOff:award(roller, itemLink)
    GL:debug("RollOff:award");

    -- If the roller has a roll number suffixed to his name
    -- e.g. "playerName [2]" then make sure to remove that number
    local openingBracketPosition = string.find(roller, " %[");
    if (openingBracketPosition) then
        roller = string.sub(roller, 1, openingBracketPosition - 1);
    end

    itemLink = GL:tableGet(self.CurrentRollOff, "itemLink", itemLink);

    local award = function ()
        -- Add the player we awarded the item to to the item's tooltip
        GL.AwardedLoot:addWinner(roller, itemLink);

        self:reset();
        GL.MasterLooterUI:reset();
    end

    -- Make sure the initiator has to confirm his choices
    StaticPopupDialogs[GL.name .. "_ROLLOFF_AWARD_CONFIRMATION"].OnAccept = award;
    StaticPopupDialogs[GL.name .. "_ROLLOFF_AWARD_CONFIRMATION"].text = string.format("Award %s to %s?",
        itemLink,
        roller
    );
    StaticPopup_Show(GL.name .. "_ROLLOFF_AWARD_CONFIRMATION");
end

--- Start listening for rolls
---
---@return void
function RollOff:listenForRolls()
    GL:debug("RollOff:listenForRolls");

    Events:register("RollOffChatMsgSystemListener", "CHAT_MSG_SYSTEM", function (message)
        self:processRoll(message);
    end);
end

--- Process an incoming roll (if it's valid!)
---
---@param message string
---@return void
function RollOff:processRoll(message)
    GL:debug("RollOff:processRoll");

    -- We only track rolls when a rollof is actually in progress
    if (not RollOff.inProgress) then
        return;
    end

    local Roll = false;
    for roller, roll, low, high in string.gmatch(message, GL.RollOff.rollPattern) do
        GL:debug(string.format("Roll detected: %s rolls %s (%s-%s)", roller, roll, low, high));

        roll = tonumber(roll) or 0;
        low = tonumber(low) or 0;
        high = tonumber(high) or 0;

        if (low ~= 1 or high ~= 100) then
            return;
        else
            local maximumNumberOfGroupMembers = _G.MEMBERS_PER_RAID_GROUP;
            if (GL.User.isInRaid) then
                maximumNumberOfGroupMembers = _G.MAX_RAID_MEMBERS;
            end

            -- This is to fetch the roller's class and to make sure
            -- that the person rolling is actually part of our group/raid
            for index = 1, maximumNumberOfGroupMembers do
                local player, _, _, _, class = GetRaidRosterInfo(index);

                if (roller == player) then
                    Roll = {
                        player = player,
                        class = class,
                        amount = roll,
                        time = GetServerTime(),
                    };

                    break;
                end
            end
        end
    end

    if (not Roll) then
        return;
    end

    tinsert(RollOff.CurrentRollOff.Rolls, Roll);
    RollOff:refreshRollsTable();
end

--- Unregister the CHAT_MSG_SYSTEM to stop listening for rolls
---
---@return void
function RollOff:stopListeningForRolls()
    GL:debug("RollOff:stopListeningForRolls");

    Events:unregister("RollOffChatMsgSystemListener");
end

-- Whenever a new roll comes in we need to refresh
-- the rolls table to make sure it actually shows up
function RollOff:refreshRollsTable()
    GL:debug("RollOff:refreshRollsTable");

    local RollTableData = {};
    local Rolls = self.CurrentRollOff.Rolls;
    local RollsTable = GL.MasterLooterUI.UIComponents.Tables.Players;
    local NumberOfRollsPerPlayer = {};

    for _, Roll in pairs(Rolls) do
        -- Determine how many times this player rolled during the current rolloff
        NumberOfRollsPerPlayer[Roll.player] = NumberOfRollsPerPlayer[Roll.player] or 0;
        NumberOfRollsPerPlayer[Roll.player] = NumberOfRollsPerPlayer[Roll.player] + 1;

        local playerName = Roll.player;
        local numberOfTimesRolledByPlayer = NumberOfRollsPerPlayer[Roll.player];

        -- Check if the player reserved the current item id
        local softReservedValue = "";
        if (GL.SoftRes:itemIdIsReservedByPlayer(self.CurrentRollOff.itemId, playerName)) then
            softReservedValue = "reserved";
        end

        -- If this isn't the player's first roll for the current item
        -- then we add a number behind the players name like so: PlayerName [#]
        if (numberOfTimesRolledByPlayer > 1) then
            playerName = string.format("%s [%s]", playerName, numberOfTimesRolledByPlayer);
        end

        local class = string.lower(Roll.class);
        local Row = {
            cols = {
                {
                    value = playerName,
                    color = GL:classRGBAColor(class),
                },
                {
                    value = Roll.amount,
                    color = GL:classRGBAColor(class),
                },
                {
                    value = softReservedValue,
                    color = GL:classRGBAColor(class),
                },
            },
        };
        tinsert(RollTableData, Row);
    end

    RollsTable:SetData(RollTableData);
    RollsTable:SortData();
end

-- Reset the last rolloff. This happens when the master looter
-- awards an item or when he clicks the "clear" button in the UI
function RollOff:reset()
    GL:debug("RollOff:reset");

    -- All we need to do is reset the itemLink and let self:start() take care of the rest
    self.CurrentRollOff.itemLink = "";

    GL.MasterLooterUI:reset();
end

GL:debug("RollOff.lua");