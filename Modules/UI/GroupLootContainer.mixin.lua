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

    self:ChangeGroupLootContainer()

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

function SubModuleMixin:OnEvent(event, ...)
    -- print(event, ...)
    for i = 1, 4 do
        local f = _G['GroupLootFrame' .. i];
        self:UpdateAllButtons(f);
    end
end

function SubModuleMixin:UpdateState(state)
    self.state = state;
    self:Update();
end

function SubModuleMixin:Update()
    local state = self.state;
    if not state then return end

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

function SubModuleMixin:ChangeGroupLootContainer()
    local fakeRoll = CreateFrame('Frame', 'DragonflightUIEditModeGroupLootContainerPreview', UIParent)
    fakeRoll:SetSize(256, 100)
    self.PreviewRoll = fakeRoll

    local fakePreview = CreateFrame('Frame', 'DragonflightUIEditModeGroupLootContainerFakeLootPreview', fakeRoll,
                                    'DFEditModePreviewGroupLootTemplate')
    fakePreview:SetPoint('CENTER')
    self:UpdateGroupLootFrameStyleSimple(fakePreview)

    fakeRoll.FakePreview = fakePreview

    for i = 1, 4 do self:UpdateGroupLootFrameStyleSimple(_G['GroupLootFrame' .. i]); end

    local tester = CreateFrame('Frame', 'tester', UIParent, 'DFEditModePreviewGroupLootTemplate')
    tester:SetPoint('CENTER', 400, 0)
    tester:Show()
    self:UpdateGroupLootFrameStyleSimple(tester)

    local norm = CreateFrame('Frame', 'normal', UIParent, 'DFEditModePreviewGroupLootTemplate')
    norm:SetPoint('BOTTOMLEFT', tester, 'TOPLEFT', 0, 10)
    norm:Show()
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

function SubModuleMixin:UpdateGroupLootFrameStyle(f)
    f:SetWidth(350) -- 243
    f:SetHeight(64) -- 84

    -- art
    do
        local corner = _G[f:GetName() .. "Corner"]
        corner:Hide()

        local decoration = _G[f:GetName() .. "Decoration"]
        decoration:ClearAllPoints()
        decoration:SetTexture('')
        decoration:Hide()

        local slotTexture = _G[f:GetName() .. "SlotTexture"]
        slotTexture:SetSize(60, 60)
        slotTexture:Hide()

        local iconSize = 40;
        local iconFrame = f.IconFrame
        iconFrame:SetSize(iconSize, iconSize)
        iconFrame:ClearAllPoints()
        iconFrame:SetPoint('CENTER', slotTexture, 'CENTER', 0, 0)

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
        container:SetSize(180, 40)
        container:SetPoint('LEFT', icon, 'RIGHT', 4, 0)

        local nameFrame = _G[f:GetName() .. "NameFrame"]
        nameFrame:SetSize(180, 25)
        nameFrame:ClearAllPoints()
        nameFrame:SetPoint('TOPLEFT', container, 'TOPLEFT', 0, 0)
        nameFrame:SetTexCoord(0, 106 / 128, 0, 40 / 64)
        nameFrame:Hide()

        local name = f.Name;
        name:SetSize(180 - 4, 28 - 4)
        name:ClearAllPoints()
        name:SetPoint('CENTER', nameFrame, 'CENTER', 0, 0)

        local fontFile, fontHeight, flags = name:GetFont()
        name:SetFont(fontFile, 14, "OUTLINE")
        name:SetFont(fontFile, 14, flags)

        local timer = f.Timer;
        timer:ClearAllPoints()
        timer:SetPoint('BOTTOMLEFT', container, 'BOTTOMLEFT', 0, 0 + 1)
        timer:SetWidth(180)
        timer.Background:SetWidth(180)

        local regs = {timer:GetRegions()}
        for k, v in ipairs(regs) do
            -- [04:17:42] 1 table: 000002123F4D2D20 nil
            -- [04:17:42] 2 table: 000002123F4D3A40 136571
            -- [04:17:42] 3 table: 000002123F4D2D70 136570
            -- print(k, v, v:GetTexture())

            local tex = v:GetTexture()
            if tex and tex == 136571 then
                --
                v:SetWidth(180 + 4)
            end
        end
    end

    -- buttons
    do
        local btnSize = 28; -- 32
        local padding = 2;

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
        pass:SetPoint('RIGHT', f, 'RIGHT', -12, 0)
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

    f:Hide()
    f:Show()
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
