local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'GroupLootContainer';
local SubModuleMixin = {};
addonTable.SubModuleMixins[subModuleName] = SubModuleMixin;

function SubModuleMixin:Init()
    self.ModuleRef = DF:GetModule('UI')

    self:SetDefaults()
    self:SetupOptions()
end

function SubModuleMixin:SetDefaults()
    local defaults = {
        enabled = true,
        scale = 1,
        anchorFrame = 'UIParent',
        customAnchorFrame = '',
        anchor = 'BOTTOM',
        anchorParent = 'BOTTOM',
        x = 425, -- 0
        y = 200 -- 152 = default blizz
    };
    self.Defaults = defaults;
end

function SubModuleMixin:SetupOptions()
    local Module = self.ModuleRef;
    local function getDefaultStr(key, sub, extra)
        -- return Module:GetDefaultStr(key, sub)
        local value = self.Defaults[key]
        local defaultFormat = L["SettingsDefaultStringFormat"]
        return string.format(defaultFormat, (extra or '') .. tostring(value))
    end

    local function setDefaultValues()
        Module:SetDefaultValues()
    end

    local function setDefaultSubValues(sub)
        Module:SetDefaultSubValues(sub)
    end

    local function getOption(info)
        return Module:GetOption(info)
    end

    local function setOption(info, value)
        Module:SetOption(info, value)
    end

    local function setPreset(T, preset, sub)
        for k, v in pairs(preset) do
            --
            T[k] = v;
        end
        Module:ApplySettings(sub)
        Module:RefreshOptionScreens()
    end

    local frameTable = {
        {value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'},
        {value = 'Minimap', text = 'Minimap', tooltip = 'descr', label = 'label'}
    }

    local rollOptions = {
        name = L["GroupLootContainerName"],
        desc = L["GroupLootContainerDesc"],
        advancedName = 'GroupLootContainer',
        sub = 'roll',
        get = getOption,
        set = setOption,
        type = 'group',
        args = {}
    }
    DF.Settings:AddPositionTable(Module, rollOptions, 'roll', 'GroupLootContainer', getDefaultStr, frameTable)
    -- DragonflightUIStateHandlerMixin:AddStateTable(Module, rollOptions, 'possess', 'PossessBar', getDefaultStr)
    rollOptions.args.scale = nil;
    rollOptions.args.enabled = {
        type = 'toggle',
        name = 'Enable Dragonflight loot rolls',
        desc = 'Restyle and reposition the group loot roll frames.'
            .. ' Turning this OFF requires a /reload to restore the classic look.'
            .. getDefaultStr('enabled', 'roll'),
        order = 0.5
    }
    local rollOptionsEditmode = {
        name = 'possess',
        desc = 'possess',
        get = getOption,
        set = setOption,
        type = 'group',
        args = {
            resetPosition = {
                type = 'execute',
                name = L["ExtraOptionsPreset"],
                btnName = L["ExtraOptionsResetToDefaultPosition"],
                desc = L["ExtraOptionsPresetDesc"],
                func = function()
                    local dbTable = Module.db.profile.roll
                    local defaultsTable = self.Defaults
                    -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                    setPreset(dbTable, {
                        scale = defaultsTable.scale,
                        anchor = defaultsTable.anchor,
                        anchorParent = defaultsTable.anchorParent,
                        anchorFrame = defaultsTable.anchorFrame,
                        x = defaultsTable.x,
                        y = defaultsTable.y
                    }, 'roll')
                end,
                order = 16,
                editmode = true,
                new = false
            }
        }
    }

    self.Options = rollOptions;
    self.OptionsEditmode = rollOptionsEditmode;
end

function SubModuleMixin:Setup()
    local function setDefaultSubValues(sub)
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('roll', 'misc', {
        options = self.Options,
        default = function()
            setDefaultSubValues('roll')
        end
    })

    self:CreateRollPreview()

    self:SetScript('OnEvent', self.OnEvent);
    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('START_LOOT_ROLL')
    self:RegisterEvent('LOOT_HISTORY_ROLL_CHANGED')
    self:RegisterEvent('LOOT_HISTORY_ROLL_COMPLETE')
    self:RegisterEvent('LOOT_ROLLS_COMPLETE')

    -- editmode 
    local EditModeModule = DF:GetModule('Editmode');

    local fakeRoll = self.PreviewRoll

    EditModeModule:AddEditModeToFrame(fakeRoll)

    fakeRoll.DFEditModeSelection:SetGetLabelTextFunction(function()
        return self.Options.name
    end)

    fakeRoll.DFEditModeSelection:RegisterOptions({
        options = self.Options,
        extra = self.OptionsEditmode,
        default = function()
            setDefaultSubValues('roll')
        end,
        moduleRef = self.ModuleRef,
        showFunction = function()
            --         
            fakeRoll.FakePreview:Show()
        end,
        hideFunction = function()
            --
            fakeRoll.FakePreview:Hide()
        end
    });
end

-- TEMP diagnostics: readable from disk via DFUIErrorGrab's SavedVariables.
local function lootlog(fmt, ...)
    if not DFUIErrorGrabDB then return end
    local log = DFUIErrorGrabDB.lootLog
    if not log then
        log = {}
        DFUIErrorGrabDB.lootLog = log
    end
    if #log >= 120 then table.remove(log, 1) end
    local ok, line = pcall(string.format, '%.1f ' .. fmt, GetTime(), ...)
    log[#log + 1] = ok and line or ('logfail: ' .. fmt)
end

local ROLL_TYPE_ICON = {
    [1] = 'Interface\\Buttons\\UI-GroupLoot-Dice-Up', -- need
    [2] = 'Interface\\Buttons\\UI-GroupLoot-Coin-Up', -- greed
    [3] = 'Interface\\Buttons\\UI-GroupLoot-DE-Up' -- disenchant
}

-- Corner display. Mid-roll this client never reveals roll NUMBERS (they
-- exist only once the roll resolves), so while rolling we show the live
-- choice tally + how many are still deciding; if numbers ever are
-- revealed (they are at resolution), the leading "Name (roll)" wins.
function SubModuleMixin:UpdateTopRoll(f)
    local topRoll, rollIcon = f.DFTopRoll, f.DFTopRollIcon
    if not (topRoll and f.rollID and C_LootHistory and C_LootHistory.GetNumItems) then return end

    local itemIdx
    for i = 1, C_LootHistory.GetNumItems() do
        local rollID = C_LootHistory.GetItem(i)
        if rollID == f.rollID then
            itemIdx = i
            break
        end
    end

    -- 1) revealed numbers take precedence
    if itemIdx then
        local _, _, numPlayers = C_LootHistory.GetItem(itemIdx)
        local bestName, bestClass, bestType, bestRoll
        for pl = 1, numPlayers or 0 do
            local name, class, rollType, roll = C_LootHistory.GetPlayerInfo(itemIdx, pl)
            if name and roll and rollType and rollType > 0 then
                if not bestType or rollType < bestType or (rollType == bestType and roll > bestRoll) then
                    bestName, bestClass, bestType, bestRoll = name, class, rollType, roll
                end
            end
        end
        if bestName then
            local color = bestClass and RAID_CLASS_COLORS and RAID_CLASS_COLORS[bestClass]
            if color and color.colorStr then
                bestName = '|c' .. color.colorStr .. bestName .. '|r'
            end
            topRoll:SetFormattedText('%s (%d)', bestName, bestRoll)
            local tex = ROLL_TYPE_ICON[bestType]
            if tex then
                rollIcon:SetTexture(tex)
                rollIcon:Show()
            else
                rollIcon:Hide()
            end
            lootlog('toproll %s revealed best=%s roll=%s', tostring(f:GetName()), bestName, tostring(bestRoll))
            return
        end
    end

    -- 2) live tally of choices + players still deciding
    rollIcon:Hide()
    local tableNeed, tableGreed, tablePass, tableDiss, tableNone = self:CreateTableForRollID(f.rollID)
    local parts = {}
    local function addPart(icon, t)
        if t and #t > 0 then parts[#parts + 1] = ('|T%s:11:11|t%d'):format(icon, #t) end
    end
    addPart('Interface\\Buttons\\UI-GroupLoot-Dice-Up', tableNeed)
    addPart('Interface\\Buttons\\UI-GroupLoot-Coin-Up', tableGreed)
    addPart('Interface\\Buttons\\UI-GroupLoot-Pass-Up', tablePass)
    if tableNone and #tableNone > 0 then
        parts[#parts + 1] = ('|cff999999%d left|r'):format(#tableNone)
    end
    topRoll:SetText(table.concat(parts, '  '))
    lootlog('toproll %s tally n=%s g=%s p=%s left=%s', tostring(f:GetName()),
        tableNeed and #tableNeed or '-', tableGreed and #tableGreed or '-',
        tablePass and #tablePass or '-', tableNone and #tableNone or '-')
end

-- Winner toast: numbers exist exactly when the toast frame disappears, so
-- announce the resolution in a short-lived DF panel where the rolls stack.
function SubModuleMixin:ShowWinnerToast(itemIdx)
    local rollID, itemLink, numPlayers, isDone, winnerIdx = C_LootHistory.GetItem(itemIdx)
    if not (isDone and winnerIdx) then return end
    local name, class, rollType, roll = C_LootHistory.GetPlayerInfo(itemIdx, winnerIdx)
    if not name then return end

    local toast = self.WinnerToast
    if not toast then
        toast = CreateFrame('Frame', 'DragonflightUILootWinnerToast', UIParent, 'BackdropTemplate')
        toast:SetSize(272, 30)
        toast:SetFrameStrata('DIALOG')
        SubModuleMixin.ApplyDFBackdrop(toast)
        local text = toast:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
        text:SetPoint('CENTER')
        text:SetWidth(260)
        toast.Text = text
        toast:Hide()
        self.WinnerToast = toast
    end
    toast:ClearAllPoints()
    toast:SetPoint('BOTTOM', self.PreviewRoll, 'BOTTOM', 0, -34)

    local color = class and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
    local coloredName = (color and color.colorStr) and ('|c' .. color.colorStr .. name .. '|r') or name
    local typeIcon = ROLL_TYPE_ICON[rollType]
    local typeTag = typeIcon and (' |T' .. typeIcon .. ':11:11|t') or ''
    local rollTag = roll and (' (' .. roll .. ')') or ''
    toast.Text:SetFormattedText('%s%s%s  %s', coloredName, typeTag, rollTag, itemLink or '')
    toast:SetAlpha(1)
    toast:Show()
    lootlog('toast winner=%s roll=%s item=%s', name, tostring(roll), tostring(itemLink))

    if self.WinnerToastTimer then self.WinnerToastTimer:Cancel() end
    self.WinnerToastTimer = C_Timer.NewTimer(4, function()
        if UIFrameFadeOut then
            UIFrameFadeOut(toast, 0.5, 1, 0)
            C_Timer.After(0.5, function() toast:Hide() end)
        else
            toast:Hide()
        end
    end)
end

function SubModuleMixin:OnEvent(event, ...)
    -- print(event, ...)
    if not (self.state and self.state.enabled and self.Styled) then return end

    if (event == 'LOOT_HISTORY_ROLL_COMPLETE' or event == 'LOOT_ROLLS_COMPLETE')
        and C_LootHistory and C_LootHistory.GetNumItems then
        self.ToastedRolls = self.ToastedRolls or {}
        for i = 1, C_LootHistory.GetNumItems() do
            local rollID, _, _, isDone, winnerIdx = C_LootHistory.GetItem(i)
            if rollID and isDone and winnerIdx and not self.ToastedRolls[rollID] then
                self.ToastedRolls[rollID] = true
                self:ShowWinnerToast(i)
            end
        end
    end

    for i = 1, 4 do
        local f = _G['GroupLootFrame' .. i];
        self:UpdateAllButtons(f);
        -- rollID may land after OnShow; re-tint the quality border once
        -- the roll data is definitely there.
        if f and f:IsShown() then
            SubModuleMixin.ApplyDFBackdrop(f)
            self:UpdateTopRoll(f)
        end
    end
end

function SubModuleMixin:UpdateState(state)
    self.state = state;
    self:Update();
end

function SubModuleMixin:Update()
    local state = self.state;
    if not state then return end

    if not state.enabled then
        if self.Styled and not self.DisabledNotePrinted then
            self.DisabledNotePrinted = true
            DF:Print('Dragonflight loot rolls disabled - /reload to restore the classic frames.')
        end
        return
    end
    self.DisabledNotePrinted = nil
    if not self.Styled then
        self.Styled = true
        self:StyleRollFrames()
    end

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    local preview = self.PreviewRoll;
    preview:ClearAllPoints()
    preview:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
    -- preview:SetScale(state.scale)
    preview:SetScale(1)

    local f = _G['GroupLootContainer']
    f.ignoreFramePositionManager = true;
    f:ClearAllPoints()
    f:SetPoint('BOTTOM', preview, 'BOTTOM', 0, 0)
end

function SubModuleMixin:CreateRollPreview()
    local fakeRoll = CreateFrame('Frame', 'DragonflightUIEditModeGroupLootContainerPreview', UIParent)
    fakeRoll:SetSize(256, 100)
    self.PreviewRoll = fakeRoll

    local fakePreview = CreateFrame('Frame', 'DragonflightUIEditModeGroupLootContainerFakeLootPreview', fakeRoll,
                                    'DFEditModePreviewGroupLootTemplate')
    fakePreview:SetPoint('CENTER')
    self:UpdateGroupLootFrameStyle(fakePreview)

    fakeRoll.FakePreview = fakePreview
end

-- Restyles the REAL roll frames - destructive, so it only runs once the
-- 'roll' state confirms the feature is enabled (see Update).
function SubModuleMixin:StyleRollFrames()
    -- Blizzard hardcodes reservedSize=100 per roll slot at OnLoad; with
    -- 50px frames that stacked them 50px apart. Reserve frame height + gap.
    if _G['GroupLootContainer'] then _G['GroupLootContainer'].reservedSize = 56 end

    for i = 1, 4 do
        local f = _G['GroupLootFrame' .. i]
        self:UpdateGroupLootFrameStyle(f);
        -- Blizzard's GroupLootFrame_OnShow re-applies the classic dialog
        -- backdrop on every popup; ours must win each time.
        f:HookScript('OnShow', SubModuleMixin.ApplyDFBackdrop)
        f:SetScript('OnEnter', function()
        end)
    end

    -- local tester = CreateFrame('Frame', 'tester', UIParent, 'DFEditModePreviewGroupLootTemplate')
    -- tester:SetPoint('CENTER', 400, 0)
    -- tester:Show()
    -- self:UpdateGroupLootFrameStyleSimple(tester)

    -- local norm = CreateFrame('Frame', 'normal', UIParent, 'DFEditModePreviewGroupLootTemplate')
    -- norm:SetPoint('BOTTOMLEFT', tester, 'TOPLEFT', 0, 10)
    -- norm:Show()
end

-- function SubModuleMixin:HookGroupLootFrame(f)
--     if not f then return end
--     -- print('HookGroupLootFrame', f:GetName())

--     local fontFile, height, flags = GameFontRedLarge:GetFont()
--     local newFontSize = 18;

--     local need = f.NeedButton
--     do
--         need:SetMotionScriptsWhileDisabled(true)
--         need:SetScript('OnEnter', function()
--             GameTooltip:SetOwner(need, "ANCHOR_RIGHT");
--             GameTooltip:SetText(need.tooltipText);
--             if (not need:IsEnabled()) then
--                 GameTooltip:AddLine(need.reason, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true);
--                 GameTooltip:Show();
--             end
--             self:AddTooltipLines(need, 1, false)
--         end)

--         local text = need:CreateFontString(nil, 'OVERLAY', "GameFontRedLarge")
--         text:SetPoint('CENTER', need, 'CENTER', 0, 0)
--         text:SetFont(fontFile, newFontSize, flags)
--         need.DFText = text;
--     end

--     local greed = f.GreedButton
--     do
--         greed:SetMotionScriptsWhileDisabled(true)
--         greed:SetScript('OnEnter', function()
--             GameTooltip:SetOwner(greed, "ANCHOR_RIGHT");
--             GameTooltip:SetText(greed.tooltipText);
--             if (not greed:IsEnabled()) then
--                 GameTooltip:AddLine(greed.reason, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true);
--                 GameTooltip:Show();
--             end
--             self:AddTooltipLines(greed, 2, false)
--         end)

--         local text = greed:CreateFontString(nil, 'OVERLAY', "GameFontRedLarge")
--         text:SetPoint('CENTER', greed, 'CENTER', 0, 2)
--         text:SetFont(fontFile, newFontSize, flags)
--         greed.DFText = text;
--     end
-- end

function SubModuleMixin:UpdateAllButtons(f)
    if not f then return end
    local rollID = f.rollID
    if not rollID then return end

    local tableNeed, tableGreed, tablePass, tableDiss, tableNone, tableData = self:CreateTableForRollID(rollID)

    local needText = f.NeedButton.DFText
    if needText then
        if tableNeed then
            needText:SetText(tostring(#tableNeed))
        else
            needText:SetText('*')
        end
    end

    local greedText = f.GreedButton.DFText
    if greedText then
        if tableGreed then
            greedText:SetText(tostring(#tableGreed))
        else
            greedText:SetText('*')
        end
    end

    local passText = f.PassButton.DFText
    if passText then
        if tableGreed then
            passText:SetText(tostring(#tablePass))
        else
            passText:SetText('*')
        end
    end

    if tableData then
        local link = tableData[2]
        if link then
            local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
                  itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType, expansionID, setID,
                  isCraftingReagent = C_Item.GetItemInfo(link)
            DragonflightUIItemColorMixin:UpdateOverlayQuality(f.IconFrame, itemQuality or 1)
        else
            DragonflightUIItemColorMixin:UpdateOverlayQuality(f.IconFrame, 1)
        end
    end
end

-- rollType    number - (0:pass, 1:need, 2:greed, 3:disenchant)

function SubModuleMixin:CreateTableForRollID(rollID)
    local numPlayers;
    local itemIDx = 1;
    local tableData = {}
    while true do
        -- rollID, itemLink, numPlayers, isDone, winnerIdx, isMasterLoot = C_LootHistory.GetItem(itemIdx)
        local rID, _, num, _, _, _ = C_LootHistory.GetItem(itemIDx)
        if not rID then
            return nil;
        elseif rID == rollID then
            numPlayers = num;
            tableData = {C_LootHistory.GetItem(itemIDx)}
            break
        end
        itemIDx = itemIDx + 1;
    end

    local tableNeed = {}
    local tableGreed = {}
    local tablePass = {}
    local tableDiss = {}
    local tableNone = {}

    for i = 1, numPlayers do
        --
        local name, class, rollType, roll, isWinner, isMe = C_LootHistory.GetPlayerInfo(itemIDx, i)
        local data = {name = name, class = class, id = i};
        -- print(name, class, rollType)

        if rollType ~= nil then
            if rollType == 0 then
                table.insert(tablePass, data)
            elseif rollType == 1 then
                table.insert(tableNeed, data)
            elseif rollType == 2 then
                table.insert(tableGreed, data)
            elseif rollType == 3 then
                table.insert(tableDiss, data)
            end
        else
            table.insert(tableNone, data)
        end
    end

    -- TODO: SORT

    return tableNeed, tableGreed, tablePass, tableDiss, tableNone, tableData;
end

local function AddRollLines(t)
    if #t < 1 then return end
    for k, v in ipairs(t) do
        --
        local str = DF:GetClassColoredText(v.name, v.class) or '???'
        GameTooltip:AddLine(string.format(' %s', str))
    end
end

function SubModuleMixin:AddTooltipLines(f, btnType, showAll)
    local rollID = f:GetParent().rollID
    if not rollID then return end

    local tableNeed, tableGreed, tablePass, tableDiss, tableNone = self:CreateTableForRollID(rollID)
    if not tableNeed then return end

    GameTooltip:AddLine('    ')

    if #tableNeed ~= 0 and (showAll or btnType == 1) then
        --
        GameTooltip:AddLine(NEED)
        AddRollLines(tableNeed)
    end

    if #tableGreed ~= 0 and (showAll or btnType == 2) then
        --
        GameTooltip:AddLine(GREED)
        AddRollLines(tableGreed)
    end

    if #tableDiss ~= 0 and (showAll or btnType == 3) then
        --
        GameTooltip:AddLine(ROLL_DISENCHANT)
        AddRollLines(tableDiss)
    end

    if #tablePass ~= 0 and (showAll or btnType == 0) then
        --
        GameTooltip:AddLine(PASS)
        AddRollLines(tablePass)
    end

    if showAll or true then
        --
        GameTooltip:AddLine('Undecided')
        AddRollLines(tableNone)
    end

    GameTooltip:Show()
end

-- era-1159: Blizzard's GroupLootFrame_OnShow re-applies the classic
-- dialog-box backdrop (gold for rare+) on EVERY popup, which kept the
-- rolls looking classic no matter the restyle. Swap it for the DF dark
-- panel and keep the quality signal on the border color.
function SubModuleMixin.ApplyDFBackdrop(frame)
    if not frame.SetBackdrop then return end
    frame:SetBackdrop({
        bgFile = 'Interface\\DialogFrame\\UI-DialogBox-Background-Dark',
        edgeFile = 'Interface\\Tooltips\\UI-Tooltip-Border',
        tile = true,
        tileSize = 32,
        edgeSize = 12,
        insets = {left = 3, right = 3, top = 3, bottom = 3}
    })
    local quality
    if frame.rollID and GetLootRollItemInfo then
        local _, _, _, q = GetLootRollItemInfo(frame.rollID)
        quality = q
    end
    local color = quality and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[quality]
    if color then
        frame:SetBackdropBorderColor(color.r, color.g, color.b)
    else
        frame:SetBackdropBorderColor(0.6, 0.6, 0.6)
    end

    do
        local t = frame.Timer
        local mn, mx
        if t and t.GetMinMaxValues then mn, mx = t:GetMinMaxValues() end
        lootlog('show %s rollID=%s quality=%s timerShown=%s w=%s val=%s minmax=%s-%s',
            tostring(frame.GetName and frame:GetName()), tostring(frame.rollID),
            tostring(quality), tostring(t and t:IsShown()), t and t:GetWidth() or -1,
            t and t.GetValue and t:GetValue() or -1, tostring(mn), tostring(mx))
    end

    -- Blizzard's OnShow re-shows the gold dragon Decoration for BoP items
    -- and re-textures the Corner on every popup - keep them gone.
    local frameName = frame.GetName and frame:GetName()
    if frameName then
        local corner = _G[frameName .. 'Corner']
        if corner then corner:Hide() end
        local decoration = _G[frameName .. 'Decoration']
        if decoration then decoration:Hide() end
    end
end

function SubModuleMixin:UpdateGroupLootFrameStyle(f)
    f:SetWidth(272) -- 243
    f:SetHeight(50) -- 84

    -- art (named children are nil-guarded: the edit-mode preview template
    -- only carries a subset of the real GroupLootFrame's regions)
    do
        local corner = _G[f:GetName() .. "Corner"]
        if corner then corner:Hide() end

        local decoration = _G[f:GetName() .. "Decoration"]
        if decoration then
            decoration:ClearAllPoints()
            decoration:SetTexture('')
            decoration:Hide()
        end

        local slotTexture = _G[f:GetName() .. "SlotTexture"]
        if slotTexture then
            slotTexture:SetSize(60, 60)
            slotTexture:Hide()
        end

        local iconSize = 34;
        local iconFrame = f.IconFrame
        iconFrame:SetSize(iconSize, iconSize)
        iconFrame:ClearAllPoints()
        iconFrame:SetPoint('LEFT', f, 'LEFT', 9, 0)

        local icon = iconFrame.Icon
        icon:SetSize(iconSize, iconSize)

        local mask = iconFrame:CreateMaskTexture('DragonflightUIIconMask')
        iconFrame.Mask = mask
        mask:SetAllPoints(icon)
        mask:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\maskNew')
        mask:SetSize(45, 45)
        icon:AddMaskTexture(mask)

        local iconOverlay = DragonflightUIItemColorMixin:AddOverlayToFrame(iconFrame)
        iconOverlay:SetPoint('TOPLEFT', icon, 'TOPLEFT', 0, 0)
        iconOverlay:SetPoint('BOTTOMRIGHT', icon, 'BOTTOMRIGHT', 0, 0)

        -- DragonflightUIItemColorMixin:UpdateOverlayQuality(iconFrame, 4)

        local container = CreateFrame("Frame", nil, f)
        container:SetSize(130, 32)
        container:SetPoint('LEFT', icon, 'RIGHT', 6, 0)

        local nameFrame = _G[f:GetName() .. "NameFrame"]
        if nameFrame then
            nameFrame:SetSize(180, 25)
            nameFrame:ClearAllPoints()
            nameFrame:SetPoint('TOPLEFT', container, 'TOPLEFT', 0, 0)
            nameFrame:SetTexCoord(0, 106 / 128, 0, 40 / 64)
            nameFrame:Hide()
        end

        local name = f.Name;
        name:SetSize(128, 16)
        name:ClearAllPoints()
        name:SetPoint('TOPLEFT', container, 'TOPLEFT', 2, -2)
        name:SetJustifyH('LEFT')

        local fontFile, fontHeight, flags = name:GetFont()
        name:SetFont(fontFile, 12, flags)

        -- Slim DF-style timer under the name instead of the chunky
        -- yellow-green classic bar.
        local timer = f.Timer;
        if timer then
        timer:ClearAllPoints()
        -- x=2 matches the name text's left edge; the bar must start in
        -- line with the text, not tucked behind the icon.
        timer:SetPoint('BOTTOMLEFT', container, 'BOTTOMLEFT', 2, 3)
        timer:SetWidth(96)
        timer:SetHeight(8)
        timer:SetStatusBarTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health-Status32')
        timer:SetStatusBarColor(1, 0.82, 0)
        -- own track + 1px frame: the template's Background is not reliable
        -- here, and the naked fill read as a floating yellow strip
        local bg = timer.Background
        if not bg then
            bg = timer:CreateTexture(nil, 'BACKGROUND')
            timer.Background = bg
        end
        bg:SetTexture(nil)
        bg:SetColorTexture(0, 0, 0, 0.55)
        bg:ClearAllPoints()
        bg:SetAllPoints(timer)
        if not timer.DFBorder then
            local border = CreateFrame('Frame', nil, timer, 'BackdropTemplate')
            border:SetPoint('TOPLEFT', timer, 'TOPLEFT', -1, 1)
            border:SetPoint('BOTTOMRIGHT', timer, 'BOTTOMRIGHT', 1, -1)
            border:SetBackdrop({edgeFile = 'Interface\\Buttons\\WHITE8X8', edgeSize = 1})
            border:SetBackdropBorderColor(0, 0, 0, 0.9)
            timer.DFBorder = border
        end

        -- The classic timer ships border/track art with rounded end caps
        -- anchored WIDER than the bar - that's what stuck out past the
        -- fill on the left. Strip every region except our fill + track.
        local fill = timer:GetStatusBarTexture()
        for _, region in ipairs({timer:GetRegions()}) do
            if region ~= fill and region ~= timer.Background and region.SetTexture then
                region:SetTexture(nil)
                region:Hide()
            end
        end
        end
    end

    SubModuleMixin.ApplyDFBackdrop(f)

    -- buttons
    do
        local btnSize = 24; -- 32
        local padding = 1;

        local texCoords = {
            [0] = {1.05, -0.1, 1.05, -0.1}, -- pass
            [1] = {0.05, 1.05, -0.05, .95}, -- need
            [2] = {0.05, 1.0, -0.025, 0.85} -- greed
        }

        local function updateTexCoords(btn, rollType)
            local left, right, top, bottom = unpack(texCoords[rollType])

            btn:GetNormalTexture():SetTexCoord(left, right, top, bottom)
            btn:GetHighlightTexture():SetTexCoord(left, right, top, bottom)
            btn:GetPushedTexture():SetTexCoord(left, right, top, bottom)
        end

        local pass = f.PassButton;
        pass:SetSize(btnSize, btnSize)
        pass:ClearAllPoints()
        pass:SetPoint('RIGHT', f, 'RIGHT', -8, 4)
        pass:SetNormalTexture('Interface\\Buttons\\UI-GroupLoot-Pass-Up')
        pass:SetHighlightTexture('Interface\\Buttons\\UI-GroupLoot-Pass-Highlight')
        pass:SetPushedTexture('Interface\\Buttons\\UI-GroupLoot-Pass-Down')
        updateTexCoords(pass, 0)

        local greed = f.GreedButton
        greed:SetSize(btnSize, btnSize)
        greed:ClearAllPoints()
        greed:SetPoint('RIGHT', pass, 'LEFT', -padding, 0)
        updateTexCoords(greed, 2)

        local need = f.NeedButton;
        need:SetSize(btnSize, btnSize)
        need:ClearAllPoints()
        need:SetPoint('RIGHT', greed, 'LEFT', -padding, 0)
        updateTexCoords(need, 1)
    end

    -- Current leading roll, retail-style: class-colored "Name (roll)" with
    -- the roll-type icon, bottom-right under the buttons. Fed by
    -- UpdateTopRoll from the loot-history events.
    if not f.DFTopRoll then
        local topRoll = f:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
        topRoll:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -9, 4)
        topRoll:SetJustifyH('RIGHT')
        f.DFTopRoll = topRoll

        local rollIcon = f:CreateTexture(nil, 'OVERLAY')
        rollIcon:SetSize(11, 11)
        rollIcon:SetPoint('RIGHT', topRoll, 'LEFT', -2, 0)
        f.DFTopRollIcon = rollIcon
    end
    f.DFTopRoll:SetText('')
    f.DFTopRollIcon:Hide()

    do
        local t = f.Timer
        lootlog('styled %s timer=%s w=%s h=%s pts=%s bg=%s border=%s',
            tostring(f:GetName()), tostring(t ~= nil), t and t:GetWidth() or -1,
            t and t:GetHeight() or -1, t and t:GetNumPoints() or -1,
            tostring(t and t.Background ~= nil), tostring(t and t.DFBorder ~= nil))
    end

    -- Refresh cycle for LIVE frames only: at setup time these are hidden,
    -- and an unconditional Hide/Show popped four empty roll frames on login.
    if f:IsShown() then
        f:Hide()
        f:Show()
    end
end

function SubModuleMixin:UpdateGroupLootFrameStyleSimple(f)
    f:SetWidth(243) -- 243
    f:SetHeight(84) -- 84

    -- art
    do
        local corner = _G[f:GetName() .. "Corner"]
        corner:Hide()

        local decoration = _G[f:GetName() .. "Decoration"]
        local slotTexture = _G[f:GetName() .. "SlotTexture"]

        local iconSize = 38;
        local iconFrame = f.IconFrame
        iconFrame:SetSize(iconSize, iconSize)
        iconFrame:ClearAllPoints()
        iconFrame:SetPoint('CENTER', slotTexture, 'CENTER', 0, 0)

        local icon = iconFrame.Icon
        icon:SetSize(iconSize, iconSize)
        icon:ClearAllPoints()
        icon:SetPoint('CENTER', iconFrame, 'CENTER', 0, 0)

        local mask = iconFrame:CreateMaskTexture('DragonflightUIIconMask')
        iconFrame.Mask = mask
        mask:SetAllPoints(icon)
        mask:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\maskNew')
        mask:SetSize(45, 45)
        icon:AddMaskTexture(mask)

        local iconOverlay = DragonflightUIItemColorMixin:AddOverlayToFrame(iconFrame)
        iconOverlay:SetPoint('TOPLEFT', icon, 'TOPLEFT', 0, 0)
        iconOverlay:SetPoint('BOTTOMRIGHT', icon, 'BOTTOMRIGHT', 0, 0)

        DragonflightUIItemColorMixin:UpdateOverlayQuality(iconFrame, 4)
    end

    -- buttons
    do
        local btnSize = 28; -- 32
        local padding = 2;

        local fontFile, height, flags = GameFontHighlight:GetFont()
        local newFontSize = 14;

        local texCoords = {
            [0] = {1.05, -0.1, 1.05, -0.1}, -- pass
            [1] = {0.05, 1.05, -0.05, .95}, -- need
            [2] = {0.05, 1.0, -0.025, 0.85} -- greed
        }

        local function updateTexCoords(btn, rollType)
            local left, right, top, bottom = unpack(texCoords[rollType])

            btn:GetNormalTexture():SetTexCoord(left, right, top, bottom)
            btn:GetHighlightTexture():SetTexCoord(left, right, top, bottom)
            btn:GetPushedTexture():SetTexCoord(left, right, top, bottom)
        end

        local pass = f.PassButton;
        local need = f.NeedButton;
        local greed = f.GreedButton

        -- pass
        do
            pass:SetSize(btnSize, btnSize)
            pass:ClearAllPoints()
            -- pass:SetPoint('RIGHT', f, 'RIGHT', -14, 0)
            pass:SetPoint('TOPRIGHT', f, 'TOPRIGHT', -14, -14)
            pass:SetNormalTexture('Interface\\Buttons\\UI-GroupLoot-Pass-Up')
            pass:SetHighlightTexture('Interface\\Buttons\\UI-GroupLoot-Pass-Highlight')
            pass:SetPushedTexture('Interface\\Buttons\\UI-GroupLoot-Pass-Down')
            updateTexCoords(pass, 0)

            local text = pass:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
            text:SetFont(fontFile, newFontSize, 'OUTLINE')
            text:SetPoint('BOTTOMRIGHT', pass, 'BOTTOMRIGHT', 2, -2)
            text:SetText('11')
            pass.DFText = text;

            pass:SetMotionScriptsWhileDisabled(true)
            pass:SetScript('OnEnter', function()
                GameTooltip:SetOwner(pass, "ANCHOR_RIGHT");
                GameTooltip:SetText(PASS);
                -- if (not pass:IsEnabled()) then
                --     GameTooltip:AddLine(pass.reason, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true);
                --     GameTooltip:Show();
                -- end
                self:AddTooltipLines(pass, 0, false)
            end)
        end

        -- greed
        do
            greed:SetSize(btnSize, btnSize)
            greed:ClearAllPoints()
            -- greed:SetPoint('RIGHT', pass, 'LEFT', -padding, 0)
            greed:SetPoint('TOP', need, 'BOTTOM', 0, -padding)
            updateTexCoords(greed, 2)

            local text = greed:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
            text:SetFont(fontFile, newFontSize, 'OUTLINE')
            text:SetPoint('BOTTOMRIGHT', greed, 'BOTTOMRIGHT', 2, -2)
            text:SetText('11')
            greed.DFText = text;

            greed:SetMotionScriptsWhileDisabled(true)
            greed:SetScript('OnEnter', function()
                GameTooltip:SetOwner(greed, "ANCHOR_RIGHT");
                GameTooltip:SetText(GREED);
                if (not greed:IsEnabled()) then
                    GameTooltip:AddLine(greed.reason, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true);
                    GameTooltip:Show();
                end
                self:AddTooltipLines(greed, 2, false)
            end)
        end

        -- need
        do
            need:SetSize(btnSize, btnSize)
            need:ClearAllPoints()
            -- need:SetPoint('RIGHT', greed, 'LEFT', -padding, 0)
            need:SetPoint('RIGHT', pass, 'LEFT', -padding, 0)
            updateTexCoords(need, 1)

            local text = need:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
            text:SetFont(fontFile, newFontSize, 'OUTLINE')
            text:SetPoint('BOTTOMRIGHT', need, 'BOTTOMRIGHT', 2, -2)
            text:SetText('11')
            need.DFText = text;

            need:SetMotionScriptsWhileDisabled(true)
            need:SetScript('OnEnter', function()
                GameTooltip:SetOwner(need, "ANCHOR_RIGHT");
                GameTooltip:SetText(NEED);
                if (not need:IsEnabled()) then
                    GameTooltip:AddLine(need.reason, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true);
                    GameTooltip:Show();
                end
                self:AddTooltipLines(need, 1, false)
            end)
        end
    end

end
