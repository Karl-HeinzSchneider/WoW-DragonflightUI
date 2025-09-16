local addonName, addonTable = ...;
local Helper = addonTable.Helper;
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")

DragonflightUIEditModeMixin = {}

function DragonflightUIEditModeMixin:InitEditMode()
    self.box = CreateFrame('FRAME')
    self.box:SetParent(self)
    self.box:SetAllPoints()
    self.box:SetFrameLevel(42)
    self.box:SetFrameStrata('HIGH')

    self.box.texture = self.box:CreateTexture(nil, 'OVERLAY')
    self.box.texture:SetAllPoints()
    self.box.texture:SetColorTexture(0, 0.8, 0, 0.42)
end

function DragonflightUIEditModeMixin:ShowHighlight(show)
    self.box:SetShown(show)
end

DragonflightUIActionbarMixin = CreateFromMixins(DragonflightUIEditModeMixin)

function DragonflightUIActionbarMixin:Init()
    self:SetPoint('BOTTOMLEFT', UIParent, 'CENTER', 0, 380)
    self:SetSize(250, 142)

    self:EnableMouse(false)

    self:InitEditMode()

    Mixin(self, DragonflightUIStateHandlerMixin)
    self:InitStateHandler()

    self.stanceBar = false

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:SetScript('OnEvent', function(_, event, arg1)
        -- print(self:GetName(), event, arg1)
        if InCombatLockdown() then return end
        -- self:Update()
        self:UpdateGridState()
    end)
end

function DragonflightUIActionbarMixin:SetButtons(buttons, barNumber)
    self.buttonTable = buttons

    local multibarFix = (barNumber and barNumber >= 2 and barNumber <= 5)
    local extraBars = (barNumber and barNumber >= 6 and barNumber <= 8)
    local multi;
    local shouldSetParent = false;

    if not barNumber then
        --
    elseif barNumber == 1 then
        -- shouldSetParent = true;
    elseif multibarFix then
        -- print('~~multibarFix', barNumber)
        if barNumber == 2 then
            multi = 6;
        elseif barNumber == 3 then
            multi = 5;
        elseif barNumber == 4 then
            multi = 4;
        elseif barNumber == 5 then
            multi = 3;
        end

        if multi then self:SetAttribute('actionpage', multi) end
        shouldSetParent = true;
    elseif extraBars then
        shouldSetParent = true;
    elseif barNumber == 42 then
        -- stance
        shouldSetParent = true
    elseif barNumber == 69 then
        -- pet
        shouldSetParent = true
    end

    for i = 1, #buttons do
        --
        local btn = buttons[i]
        if shouldSetParent then
            --
            -- btn:SetAttribute('action', multi * 12 + i)
            btn:SetParent(self)
        else
            self:SetHideFrame(btn, i + 1)
        end
    end
end

--[[ local defaultsActionbarPROTO = {
    scale = 1,
    anchorFrame = 'UIParent',
    anchor = 'CENTER',
    anchorParent = 'CENTER',
    x = 0,
    y = 0,
    orientation = 'horizontal',
    buttonScale = 1,
    rows = 1,
    buttons = 12,
    padding = 3,
    alwaysShow = true
} ]]
function DragonflightUIActionbarMixin:SetState(state, key)
    self.state = state
    self.savedAlwaysShow = state.alwaysShow

    if key and key == 'alphaNormal' then
        -- print('alphaNormal')
        self:SetAttribute('alphaNormal', state.alphaNormal)
        self.DFAlphaHandler:SetAttribute('state-alpha', 'update')
        self.DFAlphaHandler:SetAttribute('state-alpha', 'normal')
    elseif key and key == 'alphaCombat' then
        -- print('alphaCombat')
        self:SetAttribute('alphaCombat', state.alphaCombat)
    else
        self:Update()
    end
    -- print('SetState', key)
end

function DragonflightUIActionbarMixin:IsAnchorframeLegal()
    local state = self.state

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    local loopStr = self:GetName();
    local toCheck = parent;
    local relativeTo;

    while toCheck ~= UIParent do
        --
        loopStr = loopStr .. ' -> ' .. toCheck:GetName();
        if toCheck == self then return false, loopStr; end
        _, relativeTo, _, _, _ = toCheck:GetPoint(1)
        toCheck = relativeTo;
    end

    loopStr = loopStr .. ' -> ' .. toCheck:GetName();
    -- UIParent
    return true, loopStr;
end

function DragonflightUIActionbarMixin:Update()
    local state = self.state
    -- print("DragonflightUIActionbarMixin:Update()", state)
    -- DevTools_Dump(state)
    local buttonTable = self.buttonTable
    local btnCount = #buttonTable

    if btnCount < 1 then return end

    if state.reverse then
        local tmp = {}
        for i = 1, btnCount do tmp[i] = buttonTable[i] end
        buttonTable = {}
        for i = 1, btnCount do buttonTable[btnCount + 1 - i] = tmp[i] end
    end

    local btnScale = state.buttonScale
    local btnSize = buttonTable[1]:GetWidth()
    -- local btnSize = self.buttonTable[1]:GetWidth() * state.buttonScale
    -- local btnSize = (self.buttonTable[1]:GetWidth() / self.buttonTable[1]:GetScale()) * btnScale
    -- local btnSize = 36 * state.buttonScale

    -- print(btnScale, btnSize)

    local modulo = state.buttons % state.rows

    local buttons = math.min(state.buttons, btnCount)
    local rows = state.rows
    if rows > state.buttons then rows = buttons end

    local maxRowButtons = math.ceil(buttons / rows)
    -- print('maxRowButtons', maxRowButtons)

    local padding = state.padding
    -- local width = (maxRowButtons * btnSize + (maxRowButtons + 1) * padding) * btnScale
    local width = (maxRowButtons * (btnSize + 2 * padding)) * btnScale
    local height = (rows * (btnSize + 2 * padding)) * btnScale

    if state.orientation == 'horizontal' then
        self:SetSize(width, height)
    else
        self:SetSize(height, width)
    end

    for i = buttons + 1, btnCount do
        local btn = buttonTable[i]
        btn:ClearAllPoints()
        btn:SetPoint('CENTER', UIParent, 'BOTTOM', 0, -666)
        btn:Hide()

        if btn.decoDF then btn.decoDF:Hide() end
    end

    local index = 1

    -- i = rowIndex
    for i = 1, rows do
        local rowButtons = buttons / rows

        if i <= modulo then
            rowButtons = math.ceil(rowButtons)
        else
            rowButtons = math.floor(rowButtons)
        end
        -- print('row', i, rowButtons)

        -- j = btn in row index
        for j = 1, rowButtons do
            local btn = buttonTable[index]
            -- print('btn', i, btn:GetName())
            btn:ClearAllPoints()
            btn:Show()
            if btn.decoDF then btn.decoDF:SetShown(not state.hideArt) end

            if btn.DFIgnoreParentScale then
                btn:SetIgnoreParentScale(true)
                btn:SetScale(UIParent:GetScale() * btnScale)
            else
                btn:SetIgnoreParentScale(false)
                btn:SetScale(btnScale)
            end
            local dx = (2 * j - 1) * padding + (j - 1) * btnSize
            local dy = (2 * i - 1) * padding + (i - 1) * btnSize

            local sgn = 1;
            local anchor = 'BOTTOMLEFT';

            if state.growthDirection == 'down' then
                sgn = -1;
                anchor = 'TOPLEFT'
            end

            if state.orientation == 'horizontal' then
                btn:SetPoint(anchor, self, anchor, dx, sgn * dy)
            else
                btn:SetPoint(anchor, self, anchor, dy, sgn * dx)
            end

            if state.flyoutDirection == 'UP' then
                btn:UpdateFlyoutDirection(nil)
            else
                btn:UpdateFlyoutDirection(state.flyoutDirection)
            end

            -- btn:GetAttribute("showgrid") can be nil
            -- if state.alwaysShow then
            -- if btn:GetAttribute("showgrid") then
            --     if btn:GetAttribute("showgrid") < 1 then btn:SetAttribute("showgrid", 1) end
            -- else
            --     btn:SetAttribute("showgrid", 1)
            -- end            
            -- else
            -- if btn:GetAttribute("showgrid") and btn:GetAttribute("showgrid") > 0 then
            --     btn:SetAttribute("showgrid", 0)
            -- end

            -- if btn.action then
            --     if not HasAction(btn.action) then btn:Hide() end
            -- else
            --     btn:Hide()
            -- end              
            -- end

            if state.alwaysShow then
                btn:SetAttribute("showgrid", 1)
            else
                btn:SetAttribute("showgrid", 0)
            end

            if btn.DFDeco then
                if state.hideArt then
                    btn.DFDeco:Hide()
                else
                    btn.DFDeco:Show()
                end
            end

            local name = btn:GetName()
            local macroText = _G[name .. 'Name']
            local keybindText = _G[name .. 'HotKey']

            if macroText then
                if state.hideMacro then
                    macroText:SetAlpha(0)
                else
                    macroText:SetAlpha(1)
                end

                btn:SetMacroFontSize(state.macroFontSize)
            end

            if keybindText then
                if state.hideKeybind then
                    keybindText:SetAlpha(0)
                else
                    keybindText:SetAlpha(1)
                end

                btn:SetKeybindFontSize(state.keybindFontSize)

                btn:UpdateHotkeyDisplayText(state.shortenKeybind)
            end

            -- if btn.overlay then self:FixGlow(btn) end

            index = index + 1
        end
    end
    self:ShowHighlight(false)

    -- print(self.buttonTable[1]:GetName(), 'update')
    -- self:UpdateGrid(state.alwaysShow)

    -- mainbar only
    if self.gryphonLeft and self.gryphonRight then self:UpdateGryphons(state.gryphons) end
    if self.BorderArt then self.BorderArt:SetShown(not state.hideBorder) end

    if self.numberFrame then self:UpdateNumberFrame() end

    -- if self.decoFrame then self.decoFrame.update(state) end

    self:SetIgnoreRange(not state.range)

    local isLegal, loopStr = self:IsAnchorframeLegal();
    local loopStrFixed, _ = gsub(loopStr, 'DragonflightUI', 'DF')
    -- print(loopStrFixed)
    if not isLegal then
        local retOK, ret1 = xpcall(function()
            local msg = self:GetName() ..
                            ' AnchorFrame is forming an illegal anchor chain, please fix inside the DragonflightUI options! (A frame cant be anchored to another frame depending on it) \n LOOP: ' ..
                            loopStrFixed
            print('|cffFF0000ERROR! |r' .. msg);
            -- print(loopStrFixed)
            error(msg, 1)
        end, geterrorhandler())

        return
    end

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    self:ClearAllPoints()
    self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

    -- optimization as state update is slow (~7ms), noticable when changing sliders etc
    self.ShouldUpdateStateHandler = true;

    Helper:Benchmark('StateUpdater' .. self:GetName(), function()
        local newestState = self.state
        self:UpdateStateHandler(newestState)
        self:UpdatePagingStateDriver(newestState)
        self:UpdateTargetStateDriver(newestState)
    end)

    -- if not self.LastStateHandlerUpdate or ((GetTime() - self.LastStateHandlerUpdate) > 1.0) then
    --     print('instant update')
    --     Helper:Benchmark('StateUpdater' .. self:GetName(), function()
    --         local newestState = self.state
    --         self:UpdateStateHandler(newestState)
    --         self:UpdatePagingStateDriver(newestState)
    --         self:UpdateTargetStateDriver(newestState)
    --     end)
    --     self.ShouldUpdateStateHandler = false;
    --     self.LastStateHandlerUpdate = GetTime()
    -- else
    --     print('delayed')
    --     C_Timer.After(2, function()
    --         if self.ShouldUpdateStateHandler and not InCombatLockdown() then
    --             print('UpdateStateHandler')
    --             Helper:Benchmark('StateUpdater' .. self:GetName(), function()
    --                 local newestState = self.state
    --                 self:UpdateStateHandler(newestState)
    --                 self:UpdatePagingStateDriver(newestState)
    --                 self:UpdateTargetStateDriver(newestState)
    --             end)
    --             self.ShouldUpdateStateHandler = false;
    --             self.LastStateHandlerUpdate = GetTime()
    --         end
    --     end)
    -- end

    if self.StylePetButton then PetActionBar_Update() end
end

function DragonflightUIActionbarMixin:UpdateGridState()
    local state = self.state;
    if not state then return end

    local buttonTable = self.buttonTable
    local btnCount = #buttonTable
    if btnCount < 1 then return end

    for i = 1, btnCount do
        local btn = buttonTable[i]

        -- print(btn:GetName(), state.alwaysShow)
        if state.alwaysShow then
            btn:SetAttribute("showgrid", 1)
        else
            btn:SetAttribute("showgrid", 0)
        end
        ActionButton_ShowGrid(btn)
    end
end

function DragonflightUIActionbarMixin:HookQuickbindMode()
    EventRegistry:RegisterCallback("DragonflightUI.ToggleQuickKeybindMode", self.OnToggleQuickKeybindMode, self);
end

function DragonflightUIActionbarMixin:OnToggleQuickKeybindMode(on)
    -- print('OnToggleQuickKeybindMode', on)
    if on then
        self.state.alwaysShow = true
    else
        self.state.alwaysShow = self.savedAlwaysShow
    end
    self:Update()
end

function DragonflightUIActionbarMixin:SetupMainBar()
    self.MainBarFrame = CreateFrame('FRAME', 'DragonflightUIActionbarMainBarFrame', self, 'SecureFrameTemplate')
    self:AddGryphons()
    self:SetupPageNumberFrame()
    -- self:AddDeco()
    self:AddDecoNew()

    -- self.gryphonLeft:SetParent(self.MainBarFrame)
    -- self.gryphonLeft:SetScale(0.42)
    -- self.gryphonRight:SetParent(self.MainBarFrame)
    -- self.gryphonRight:SetScale(0.42)

    local handler = self.StateHandler
    if not handler then return end
    handler:SetFrameRef('mainbarFrame', self.MainBarFrame)
end

function DragonflightUIActionbarMixin:AddPagingStateDriver()
    -- print('DragonflightUIActionbarMixin:AddPagingStateDriver()')

    local handler = CreateFrame("Frame", "DragonflightUIActionBarPagingHandler", self, "SecureHandlerStateTemplate")
    self.PagingStateDriver = handler;
    handler:SetFrameRef("MainMenuBarArtFrame", MainMenuBarArtFrame)
    if _G['OverrideActionBar'] then handler:SetFrameRef("OverrideActionBar", OverrideActionBar) end

    SecureHandlerExecute(handler, [[
        handler = self
        buttonsTable = newtable()
    
        UpdateMainActionBar = [=[
            local page = ...
            -- print('UpdateMainActionBar',page)
            -- if page == "tempshapeshift" then
            --     if HasTempShapeshiftActionBar() then
            --         page = GetTempShapeshiftBarIndex()
            --     else
            --         page = 1
            --     end
            if page == "possess" then
                -- page = handler:GetFrameRef("MainMenuBarArtFrame"):GetAttribute("actionpage")
                -- if handler:GetFrameRef("OverrideActionBar") and page <= 10 then
                --     page = handler:GetFrameRef("OverrideActionBar"):GetAttribute("actionpage")
                -- end
                -- if page <= 10 then
                --     page = 12
                -- end
                if HasVehicleActionBar() then
                    page = GetVehicleBarIndex();
                elseif HasOverrideActionBar() then
                    page = GetOverrideBarIndex();               
                elseif HasTempShapeshiftActionBar() then
                    page = GetTempShapeshiftBarIndex();    
                elseif HasBonusActionBar() then
                    page = GetBonusBarIndex();
                else
                    page = nil;
                end
                if not page then
                    print('DragonflightUI: Actionbar1 cant determine vehicle/possess action bar page, please report this!')
                    page = 12;
                end
            end         
            -- print('~>UpdateMainActionBar',page)
            handler:SetAttribute("actionpage", page)
    
            for btn in pairs(buttonsTable) do
                btn:SetAttribute("actionpage", page)
    
                -- Call btn's Refresh method
                -- btn:CallMethod("Refresh")
            end
        ]=]
    ]])

    for i, btn in ipairs(self.buttonTable) do
        handler:SetFrameRef("NewButton", btn)
        SecureHandlerExecute(handler, [[
            buttonsTable[handler:GetFrameRef("NewButton")] = true
        ]])
    end
end

-- local function OnEvent(self, event)
--     print(event)
--     local vehicleui = SecureCmdOptionParse("[vehicleui] 1; 0")
--     local possessbar = SecureCmdOptionParse("[possessbar] 1; 0")
--     local overridebar = SecureCmdOptionParse("[overridebar] 1; 0")
--     local shapeshift = SecureCmdOptionParse("[shapeshift] 1; 0")
--     local bonusbar = SecureCmdOptionParse("[bonusbar] 1; 0")
--     if vehicleui == "1" then print("vehicleui") end
--     if possessbar == "1" then print("possessbar") end
--     if overridebar == "1" then print("overridebar") end
--     if shapeshift == "1" then print("shapeshift") end
--     if bonusbar == "1" then print("bonusbar") end
--     print("barpage: " .. GetActionBarPage())
--     print("type: " .. type(vehicleui))
-- end

-- local barCheck = CreateFrame("Frame")
-- barCheck:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
-- barCheck:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
-- barCheck:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
-- barCheck:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
-- barCheck:SetScript("OnEvent", OnEvent)

function DragonflightUIActionbarMixin:UpdatePagingStateDriver(state)
    if not self.PagingStateDriver then return end

    local handler = self.PagingStateDriver;
    local mode = state.stateDriver;
    -- print('DragonflightUIActionbarMixin:UpdatePagingStateDriver(state)', mode)

    local localizedClass, englishClass, classIndex = UnitClass("player");
    if mode == 'SMART' then
        local shouldChange = (englishClass == 'DRUID')
        -- if not shouldChange then mode = 'DEFAULT' end
    end

    -- print('~>', mode)

    if mode == 'DEFAULT' then
        if self.DriverCache then
            UnregisterStateDriver(handler, "page");
            handler:SetAttribute("_onstate-page", nil);
            self.DriverCache = nil;
        end

        for i, btn in ipairs(self.buttonTable) do
            --
            btn:SetAttribute("useparent-actionpage", true);
            btn:SetAttribute("actionpage", nil);
        end
    elseif mode == 'SMART' then
        local driverTable = {}
        -- 
        tinsert(driverTable, "[overridebar][possessbar][shapeshift]possess")
        -- 
        for i = 2, 6 do
            --
            tinsert(driverTable, ("[bar:%d]%d"):format(i, i))
        end

        if englishClass == 'DRUID' then
            --
            -- tinsert(driverTable, '[stealth]42')
            tinsert(driverTable, "[bonusbar:1,stealth]8")
        end

        for i = 1, 4 do
            --
            tinsert(driverTable, ("[bonusbar:%d]%d"):format(i, i + 6));
        end

        -- Fix for temp shape shift bar
        -- tinsert(driverTable, "[stance:1]possess")

        tinsert(driverTable, "1")

        local driver = table.concat(driverTable, ';')

        if driver == self.DriverCache then return; end
        self.DriverCache = driver;
        UnregisterStateDriver(handler, "page")
        handler:SetAttribute("_onstate-page", nil)

        local result, target = SecureCmdOptionParse(driver)

        -- print('~~>> NOW:', result)

        --
        for i, btn in ipairs(self.buttonTable) do
            --
            btn:SetAttribute("useparent-actionpage", false);
            btn:SetAttribute("actionpage", 1);
        end

        -- -- Register the init value
        handler:SetAttribute("actionpage", result)

        RegisterStateDriver(handler, "page", driver)

        handler:SetAttribute("_onstate-page", [=[
            handler:Run(UpdateMainActionBar, newstate)
        ]=])
        handler:SetAttribute("state-page", result)
    elseif mode == 'NOPAGING' then
        local driverTable = {}
        -- 
        tinsert(driverTable, "[overridebar][possessbar]possess")
        tinsert(driverTable, "1")

        local driver = table.concat(driverTable, ';')

        if driver == self.DriverCache then return; end
        self.DriverCache = driver;
        UnregisterStateDriver(handler, "page")
        handler:SetAttribute("_onstate-page", nil)

        local result, target = SecureCmdOptionParse(driver)

        for i, btn in ipairs(self.buttonTable) do
            --
            btn:SetAttribute("useparent-actionpage", false);
            btn:SetAttribute("actionpage", 1);
        end

        -- Register the init value
        handler:SetAttribute("actionpage", result)

        RegisterStateDriver(handler, "page", driver)

        handler:SetAttribute("_onstate-page", [=[
            handler:Run(UpdateMainActionBar, newstate)
        ]=])
    end
end

function DragonflightUIActionbarMixin:AddAlphaStateDriver()
    print('DragonflightUIActionbarMixin:AddAlphaStateDriver()')
    local handler = CreateFrame("Frame", "DragonflightUIActionBarAlphaHandler", self, "SecureHandlerStateTemplate")
    self.AlphaStateDriver = handler;

    handler:SetFrameRef('frameRef', self)
    handler:SetAttribute('_onstate-alpha', [[
        -- if not newstate then return end     
        local frameRef = self:GetFrameRef("frameRef")
        if not frameRef then return end     

        local newAlpha = 1.0;
        if newstate == 'combat' then
            newAlpha = frameRef:GetAttribute('combatAlpha') or 0.5;
        elseif newstate == 'normal' then
            newAlpha = frameRef:GetAttribute('normalAlpha') or 0.8;
        else
            --
        end
        frameRef:SetAlpha(newAlpha);
    ]])
end

function DragonflightUIActionbarMixin:UpdateAlphaStateDriver(state)
    if not self.AlphaStateDriver then return end
    local handler = self.AlphaStateDriver
    UnregisterStateDriver(handler, 'vis')

    local driverTable = {}

    table.insert(driverTable, '[combat]combat')
    table.insert(driverTable, 'normal')
    -- table.insert(driverTable, 'show')

    local driver = table.concat(driverTable, ';')
    local result, target = SecureCmdOptionParse(driver)

    RegisterStateDriver(handler, 'alpha', driver)
    handler:SetAttribute('state-alpha', 'hide')
    handler:SetAttribute('state-alpha', 'show')
    handler:SetAttribute('state-vis', result)
end

function DragonflightUIActionbarMixin:AddTargetStateDriver()
    -- print('DragonflightUIActionbarMixin:AddTargetStateDriver()')
    local handler = CreateFrame("Frame", "DragonflightUIActionBarTargetHandler", self, "SecureHandlerStateTemplate")
    self.TargetStateDriver = handler;

    SecureHandlerExecute(handler, [[
        handler = self
        buttonsTable = newtable()
    
        UpdateAllButtonStates = [=[
            local type, state = ...;
            -- print('UpdateAllButtonStates', type, state)    
            
            handler:SetAttribute(type, state)  
    
            for btn in pairs(buttonsTable) do
                btn:SetAttribute(type, state)  
                if btn:GetAttribute("UpdateTargetState") then
                    local page = btn:RunAttribute("GetActionPage");
                    local slotID = btn:RunAttribute("GetActionSlotID",page);
                    btn:RunAttribute("UpdateTargetState",slotID)                
                end
            end
        ]=]       
    ]])

    handler:SetAttribute('_onstate-target-help', [[
        local state = (newstate ~= 'nil') and newstate or nil;
        handler:Run(UpdateAllButtonStates, 'target-help', state);
    ]])
    handler:SetAttribute('_onstate-target-harm', [[
        local state = (newstate ~= 'nil') and newstate or nil;
        handler:Run(UpdateAllButtonStates, 'target-harm', state);
    ]])
    handler:SetAttribute('_onstate-target-all', [[
        local state = (newstate ~= 'nil') and newstate or nil;
        handler:Run(UpdateAllButtonStates, 'target-all', state);
    ]])

    handler:SetAttribute('OnStateChanged', [[
        print('OnStateChanged')
        print('---------')
    ]])

    for i, btn in ipairs(self.buttonTable) do
        handler:SetFrameRef("NewButton", btn)
        SecureHandlerExecute(handler, [[
            buttonsTable[handler:GetFrameRef("NewButton")] = true
        ]])
        btn:SetAttribute('GetActionPage', [[   
            if self:GetAttribute('useparent-actionpage') then
                return self:GetParent():GetAttribute('actionpage')                
            else    
                return self:GetAttribute('actionpage')
            end
        ]])
        -- ActionButton_CalculateAction
        btn:SetAttribute('GetActionSlotID', [[  
            local page = ...
            local ID = self:GetID()

            if ID > 0 then 
                if not page then
                    page = GetActionBarPage()
                    if self.isExtra then
                        page = GetExtraBarPage()
                    elseif self.buttonType == 'MULTICASTACTIONBUTTON' then
                        page = GetMultiCastBarIndex()
                    end
                end
                return (ID + ((page-1)*12))
            else
                return self:GetAttribute('action') or 1;
            end  
        ]])
        btn:SetAttribute('UpdateTargetState', [[
            local slot = ...;

            self:SetAttribute('targettype', nil)
            self:SetAttribute('unit', nil)
        
            if self:GetAttribute('smarttarget') then
                local type, action = GetActionInfo(slot);

                if type == 'spell' and action > 0 then                  
                    if IsSpellHelpful(action) == IsSpellHarmful(action) then
                        self:SetAttribute('targettype',3)
                        self:SetAttribute('unit',self:GetAttribute('target-all'))
                    elseif IsSpellHelpful(action) then
                            self:SetAttribute('targettype',1)
                        self:SetAttribute('unit',self:GetAttribute('target-help'))
                    elseif IsSpellHarmful(action) then
                            self:SetAttribute('targettype',2)
                        self:SetAttribute('unit',self:GetAttribute('target-harm'))
                    end                  
                end
            end
        ]])
    end
end

function DragonflightUIActionbarMixin:UpdateTargetStateDriver(state)
    if not self.TargetStateDriver then return end

    local handler = self.TargetStateDriver;

    local preSelf = '';
    if state.selfCast then preSelf = '[mod:SELFCAST]player;' end

    local preFocus = '';
    if not DF.API.Version.IsEra and state.focusCast then preFocus = '[mod:FOCUSCAST,@focus,exists,nodead]focus;' end

    local modifier = '';
    if state.mouseoverModifier and state.mouseoverModifier ~= 'NONE' then
        --
        modifier = ',mod:' .. state.mouseoverModifier;
    end

    local helpDriver, harmDriver, allDriver = '', '', '';

    if state.useMouseover then
        helpDriver = string.format('[@mouseover,exists,help%s]mouseover;', modifier);
        harmDriver = string.format('[@mouseover,nodead,exists,harm%s]mouseover;', modifier);
        allDriver = string.format('[@mouseover,nodead,exists%s]mouseover;', modifier);
    end

    if state.useAutoAssist then
        helpDriver = helpDriver .. '[help]nil; [@targettarget, help]targettarget';
        harmDriver = harmDriver .. '[harm]nil; [@targettarget, harm]targettarget';
    end

    helpDriver = string.format('%s%s%s', preSelf, preFocus, helpDriver)
    harmDriver = string.format('%s%s', preFocus, harmDriver)
    allDriver = string.format('%s%s%s', preSelf, preFocus, allDriver)

    local changed = false;
    if helpDriver ~= self.HelpDriverCache then
        --
        changed = true;
        self.HelpDriverCache = helpDriver;
        UnregisterStateDriver(handler, 'target-help');
        handler:SetAttribute('state-target-help', 'nil')

        if helpDriver ~= '' then
            --
            helpDriver = string.format('%s nil', helpDriver)
            RegisterStateDriver(handler, 'target-help', helpDriver)
        end
    end

    if harmDriver ~= self.HarmDriverCache then
        --
        changed = true;
        self.HarmDriverCache = harmDriver;
        UnregisterStateDriver(handler, 'target-harm');
        handler:SetAttribute('state-target-harm', 'nil')

        if harmDriver ~= '' then
            --
            harmDriver = string.format('%s nil', harmDriver)
            RegisterStateDriver(handler, 'target-harm', harmDriver)
        end
    end

    if allDriver ~= self.AllDriverCache then
        --
        changed = true;
        self.AllDriverCache = allDriver;
        UnregisterStateDriver(handler, 'target-all');
        handler:SetAttribute('state-target-all', 'nil')

        if allDriver ~= '' then
            --
            allDriver = string.format('%s nil', allDriver)
            RegisterStateDriver(handler, 'target-all', allDriver)
        end
    end

    if changed then
        for i, btn in ipairs(self.buttonTable) do
            --
            btn:SetAttribute('smarttarget', state.useMouseover or state.useAutoAssist);

            btn:SetAttribute('checkselfcast', state.selfCast and true or nil);
            btn:SetAttribute('checkfocuscast', state.focusCast and true or nil);
        end

        SecureHandlerExecute(handler, [[
      --UpdateAllButtonStates()
    ]])
    end
end

function DragonflightUIActionbarMixin:AddTargetStateTable(Module, opt, getDefaultStr)
    local sub = opt.sub;

    local extraOptions = {
        headerTargetDriver = {
            type = 'header',
            name = L['ActionbarTargetDriverHeader'],
            desc = '',
            order = 30,
            isExpanded = true,
            editmode = true
        },
        useMouseover = {
            type = 'toggle',
            name = L['ActionbarTargetDriverUseMouseover'],
            desc = L['ActionbarTargetDriverUseMouseoverDesc'] .. getDefaultStr('useMouseover', sub),
            order = 110.1,
            group = 'headerTargetDriver',
            new = true,
            editmode = true
        },
        mouseoverModifier = {
            type = 'select',
            name = L["ActionbarTargetDriverMouseOverModifier"],
            desc = L["ActionbarTargetDriverMouseOverModifierDesc"] .. getDefaultStr('mouseoverModifier', sub),
            dropdownValues = DF.Settings.ModifierTable,
            order = 110.15,
            group = 'headerTargetDriver',
            new = true,
            editmode = true
        },
        useAutoAssist = {
            type = 'toggle',
            name = L['ActionbarTargetDriverUseAutoAssist'],
            desc = L['ActionbarTargetDriverUseAutoAssistDesc'] .. getDefaultStr('useAutoAssist', sub),
            order = 115,
            group = 'headerTargetDriver',
            new = true,
            editmode = true
        },
        focusCast = {
            type = 'toggle',
            name = L['ActionbarTargetDriverFocusCast'],
            desc = L['ActionbarTargetDriverFocusCastDesc'] .. getDefaultStr('focusCast', sub),
            order = 105.3,
            group = 'headerTargetDriver',
            new = true,
            editmode = true
        },
        focusCastModifier = {
            type = 'select',
            name = L["ActionbarTargetDriverFocusCastModifier"],
            desc = L["ActionbarTargetDriverFocusCastModifierDesc"],
            dropdownValues = DF.Settings.ModifierTable,
            order = 105.35,
            group = 'headerTargetDriver',
            blizzard = true,
            editmode = true
        },
        selfCast = {
            type = 'toggle',
            name = L['ActionbarTargetDriverSelfCast'],
            desc = L['ActionbarTargetDriverSelfCastDesc'] .. getDefaultStr('selfCast', sub),
            order = 100.4,
            group = 'headerTargetDriver',
            new = true,
            editmode = true
        },
        selfCastModifier = {
            type = 'select',
            name = L["ActionbarTargetDriverSelfCastModifier"],
            desc = L["ActionbarTargetDriverSelfCastModifierDesc"],
            dropdownValues = DF.Settings.ModifierTableWithoutNone,
            order = 100.45,
            group = 'headerTargetDriver',
            blizzard = true,
            editmode = true
        }
    }

    local origGet = opt.get;
    local origSet = opt.set;

    local newGet = function(info)
        local key = info[1]
        local subKey = info[2]

        if subKey == 'selfCastModifier' then
            local value = GetModifiedClick("SELFCAST");
            return value;
        elseif subKey == 'focusCastModifier' then
            local value = GetModifiedClick("FOCUSCAST");
            return value;
        end

        return origGet(info)
    end

    local newSet = function(info, value)
        local key = info[1]
        local subKey = info[2]

        if subKey == 'selfCastModifier' then
            --
            SetModifiedClick('SELFCAST', value)
            return;
        elseif subKey == 'focusCastModifier' then
            --
            SetModifiedClick('FOCUSCAST', value)
            return;
        end

        origSet(info, value)
    end

    opt.get = newGet;
    opt.set = newSet;

    if DF.API.Version.IsEra then extraOptions.focusCast = nil; end

    for k, v in pairs(extraOptions) do
        --
        opt.args[k] = v
    end
end

function DragonflightUIActionbarMixin:AddGryphons()
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'
    local scale = 0.60
    local dy = self.buttonTable[1]:GetHeight()

    local w = 104.5
    local h = 98

    local gryphonLeft = CreateFrame('Frame', 'DragonflightUIGryphonLeft', self.MainBarFrame)
    gryphonLeft:SetSize(w, h)
    gryphonLeft:SetScale(scale)
    gryphonLeft:SetPoint('RIGHT', self, 'BOTTOMLEFT', 0, dy)
    gryphonLeft:SetFrameStrata('MEDIUM')
    gryphonLeft:SetFrameLevel(5)

    gryphonLeft.texture = gryphonLeft:CreateTexture()
    gryphonLeft.texture:SetTexture(textureRef)
    gryphonLeft.texture:SetSize(w, h)
    gryphonLeft.texture:SetTexCoord(0.001953125, 0.697265625, 0.10205078125, 0.26513671875)
    gryphonLeft.texture:SetPoint('CENTER')

    self.gryphonLeft = gryphonLeft

    local gryphonRight = CreateFrame('Frame', 'DragonflightUIGryphonRight', self.MainBarFrame)
    gryphonRight:SetSize(w, h)
    gryphonRight:SetScale(scale)
    gryphonRight:SetPoint('LEFT', self, 'BOTTOMRIGHT', 0, dy)
    gryphonRight:SetFrameStrata('MEDIUM')
    gryphonRight:SetFrameLevel(5)

    gryphonRight.texture = gryphonRight:CreateTexture()
    gryphonRight.texture:SetTexture(textureRef)
    gryphonRight.texture:SetSize(w, h)
    gryphonRight.texture:SetTexCoord(0.001953125, 0.697265625, 0.26611328125, 0.42919921875)
    gryphonRight.texture:SetPoint('CENTER')

    self.gryphonRight = gryphonRight
end

function DragonflightUIActionbarMixin:UpdateGryphons(gryphons)
    self.gryphonLeft:Show()
    self.gryphonRight:Show()

    local state = self.state
    local padding = state.padding
    local btnCount = state.buttons

    -- local dy = self.buttonTable[1]:GetHeight() + padding

    local btnScale = state.buttonScale
    local gryphonScale = btnScale * 0.42

    local dx = padding + 5
    local dy = 6

    local rows = state.rows
    if rows > btnCount then rows = btnCount end

    local maxRowButtons = math.ceil(btnCount / rows)

    local mainbarScale = btnScale * 1.5 -- *0.65
    self.MainBarFrame:SetScale(mainbarScale)

    if state.reverse then
        self.gryphonLeft:SetPoint('RIGHT', self.buttonTable[12], 'LEFT', dx, dy)
        self.gryphonRight:SetPoint('LEFT', self.buttonTable[12 - maxRowButtons + 1], 'RIGHT', -dx, dy)
    else
        self.gryphonLeft:SetPoint('RIGHT', self.buttonTable[1], 'LEFT', dx, dy)
        self.gryphonRight:SetPoint('LEFT', self.buttonTable[maxRowButtons], 'RIGHT', -dx, dy)
    end

    -- self.numberFrame:SetScale(btnScale)

    if gryphons == 'DEFAULT' then
        local englishFaction, localizedFaction = UnitFactionGroup('player')
        if englishFaction == 'Alliance' then
            self.gryphonLeft.texture:SetTexCoord(0.001953125, 0.697265625, 0.10205078125, 0.26513671875)
            self.gryphonRight.texture:SetTexCoord(0.001953125, 0.697265625, 0.26611328125, 0.42919921875)
        else
            self.gryphonLeft.texture:SetTexCoord(0.001953125, 0.697265625, 0.43017578125, 0.59326171875)
            self.gryphonRight.texture:SetTexCoord(0.001953125, 0.697265625, 0.59423828125, 0.75732421875)
        end
    elseif gryphons == 'ALLY' then
        self.gryphonLeft.texture:SetTexCoord(0.001953125, 0.697265625, 0.10205078125, 0.26513671875)
        self.gryphonRight.texture:SetTexCoord(0.001953125, 0.697265625, 0.26611328125, 0.42919921875)
    elseif gryphons == 'HORDE' then
        self.gryphonLeft.texture:SetTexCoord(0.001953125, 0.697265625, 0.43017578125, 0.59326171875)
        self.gryphonRight.texture:SetTexCoord(0.001953125, 0.697265625, 0.59423828125, 0.75732421875)
    elseif gryphons == 'NONE' then
        self.gryphonLeft:Hide()
        self.gryphonRight:Hide()
    end
end

function DragonflightUIActionbarMixin:SetupPageNumberFrame()
    local f = CreateFrame('Frame', 'DragonflightUIPageNumberFrame', self.MainBarFrame)
    f:SetSize(25, 20)
    f:SetPoint('RIGHT', ActionButton1, 'LEFT')
    f:SetFrameStrata('MEDIUM')
    f:SetFrameLevel(6)

    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'

    -- actionbar switch buttons
    ActionBarUpButton:GetNormalTexture():SetTexture(textureRef)
    ActionBarUpButton:GetNormalTexture():SetTexCoord(0.701171875, 0.767578125, 0.40673828125, 0.42041015625)
    ActionBarUpButton:GetHighlightTexture():SetTexture(textureRef)
    ActionBarUpButton:GetHighlightTexture():SetTexCoord(0.884765625, 0.951171875, 0.34619140625, 0.35986328125)
    ActionBarUpButton:GetPushedTexture():SetTexture(textureRef)
    ActionBarUpButton:GetPushedTexture():SetTexCoord(0.884765625, 0.951171875, 0.33154296875, 0.34521484375)

    ActionBarDownButton:GetNormalTexture():SetTexture(textureRef)
    ActionBarDownButton:GetNormalTexture():SetTexCoord(0.904296875, 0.970703125, 0.29541015625, 0.30908203125)
    ActionBarDownButton:GetHighlightTexture():SetTexture(textureRef)
    ActionBarDownButton:GetHighlightTexture():SetTexCoord(0.904296875, 0.970703125, 0.28076171875, 0.29443359375)
    ActionBarDownButton:GetPushedTexture():SetTexture(textureRef)
    ActionBarDownButton:GetPushedTexture():SetTexCoord(0.904296875, 0.970703125, 0.26611328125, 0.27978515625)

    -- gryphon = 100
    local buttonScale = 0.42
    ActionBarUpButton:SetParent(f)
    ActionBarUpButton:ClearAllPoints()
    ActionBarUpButton:SetPoint('CENTER', f, 'TOP', 0, 0)
    ActionBarUpButton:SetFrameStrata('MEDIUM')
    ActionBarUpButton:SetFrameLevel(7)
    ActionBarUpButton:SetScale(buttonScale)
    -- ActionBarUpButton:SetSize(17, 14)

    ActionBarDownButton:SetParent(f)
    ActionBarDownButton:ClearAllPoints()
    ActionBarDownButton:SetPoint('CENTER', f, 'BOTTOM', 0, 0)
    ActionBarDownButton:SetFrameStrata('MEDIUM')
    ActionBarDownButton:SetFrameLevel(7)
    ActionBarDownButton:SetScale(buttonScale)
    -- ActionBarDownButton:SetSize(17, 14)

    MainMenuBarPageNumber:ClearAllPoints()
    MainMenuBarPageNumber:SetPoint('CENTER', f, 'CENTER', 0, 0)
    MainMenuBarPageNumber:SetParent(f)
    MainMenuBarPageNumber:SetScale(1.25)
    MainMenuBarPageNumber:SetJustifyV('MIDDLE')

    local deltaTable = {[1] = -1.75, [2] = -0.5, [3] = -0.5, [4] = -0.5, [5] = -0.5, [6] = -0.5, [7] = -0.5, [8] = -0.5}

    -- local tester = 8;
    -- MainMenuBarPageNumber:SetText(tostring(tester))
    -- MainMenuBarPageNumber:SetPoint('CENTER', f, 'CENTER', deltaTable[tester], 0)

    local function fixAnchor(text)
        local delta = deltaTable[tonumber(text)] or 0;
        if self.state then delta = delta * (0.8 / (self.state.buttonScale or 0.8)) end
        MainMenuBarPageNumber:SetPoint('CENTER', f, 'CENTER', delta, 0)
    end

    hooksecurefunc(MainMenuBarPageNumber, 'SetText', function(frame, text)
        fixAnchor(text)
    end)
    fixAnchor(GetActionBarPage())

    -- f:SetScale((1 / 1.5) * 0.9)
    -- f:SetScale(0.9)

    self.numberFrame = f
    -- f:Hide()
end

function DragonflightUIActionbarMixin:UpdateNumberFrame()
    local state = self.state
    local padding = state.padding
    local btnCount = state.buttons

    -- local dy = self.buttonTable[1]:GetHeight() + padding

    local btnScale = state.buttonScale
    local gryphonScale = btnScale * 0.42

    local dx = padding + 15
    local dy = 6

    local rows = state.rows
    if rows > btnCount then rows = btnCount end

    local maxRowButtons = math.ceil(btnCount / rows)

    if state.hideScrolling then
        self.numberFrame:Hide()
    else
        self.numberFrame:Show()
    end

    if state.reverse then
        self.numberFrame:SetPoint('RIGHT', ActionButton12, 'LEFT')
    else
        self.numberFrame:SetPoint('RIGHT', ActionButton1, 'LEFT')
    end
end

function DragonflightUIActionbarMixin:AddDecoNew()
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'

    -- self.decoFrame:SetPoint('TOPLEFT')
    -- self.decoFrame:SetPoint('BOTTOMRIGHT')

    if false then
        self.decoFrame = CreateFrame('Frame', 'DragonflightUIMainActionBarDecoFrame', self)
        self.decoFrame:SetFrameStrata('LOW')
        self.decoFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
        self.decoFrame:SetSize(1, 1)
        self.decoFrame.decoTable = {}

        local tex = self.decoFrame:CreateTexture()

        -- tex:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\Actionbar-nineslice')
        -- tex:SetTextureSliceMargins(36, 36, 36, 36)

    end

    for k, v in ipairs(self.buttonTable) do
        local tex = v:CreateTexture('DragonflightUISlotDeco')
        v.DFDeco = tex
        tex:SetTexture(textureRef)
        tex:SetSize(45, 45 - 2)
        tex:SetPoint('TOPLEFT')
        tex:SetTexCoord(0.701171875, 0.951171875, 0.10205078125, 0.16259765625)
        tex:SetDrawLayer('BACKGROUND', -5)
        -- tex:SetFrameLevel('1')
    end

    --[[    for i = 1, 1 do
        local tex = self.decoFrame:CreateTexture()
        tex:SetTexture(textureRef)
        tex:SetSize(45, 45)
        -- tex:SetScale(1)
        tex:SetTexCoord(0.701171875, 0.951171875, 0.10205078125, 0.16259765625)
        self.decoFrame.decoTable[i] = tex
    end ]]

    do
        --     ["Interface/HUD/UIActionBarFrame2x"]={
        -- 	["UI-HUD-ActionBar-Frame"]={55, 55, 0.0078125, 0.867188, 0.0078125, 0.867188, false, false, "2x", slice={20, 20, 25, 25, tile=true}},
        -- }, -- Interface/HUD/UIActionBarFrame2x
        -- local texTwo = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbarframe2x'
        -- local borderArt = self:CreateTexture('DragonflightUIActionbarBorderArt')
        -- borderArt:SetTexture(texTwo)
        -- borderArt:SetSize(110, 110)
        -- borderArt:SetTexCoord(0.0078125, 0.867188, 0.0078125, 0.867188)
        -- -- borderArt:SetTexCoord(0, 1, 0, 1)

        -- borderArt:SetPoint('TOPLEFT', self, 'TOPLEFT', -4, 4)
        -- borderArt:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 8, -7)
        -- borderArt:SetTextureSliceMode(1)
        -- borderArt:SetTextureSliceMargins(20, 20, 25, 25)

        -- self.BorderArt = borderArt;
    end
end

function DragonflightUIActionbarMixin:AddDeco()
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'

    self.decoFrame = CreateFrame('Frame', 'DragonflightUIMainActionBarDecoFrame')
    self.decoFrame:SetFrameStrata('LOW')
    self.decoFrame:SetPoint('CENTER')
    self.decoFrame.decoTable = {}

    for i = 1, 12 do

        local tex = self.decoFrame:CreateTexture()
        tex:SetTexture(textureRef)
        tex:SetSize(128, 124)
        tex:SetScale(0.3)
        tex:SetTexCoord(0.701171875, 0.951171875, 0.10205078125, 0.16259765625)
        self.decoFrame.decoTable[i] = tex
    end

    self.decoFrame.update = function(state)
        local a1, a2 = self:GetSize()
        self.decoFrame:SetSize(a1, a2)

        local padding = state.padding
        local btnSize = self.buttonTable[1]:GetWidth()

        for i = 1, 1 do

            local point, relativeTo, relativePoint, xOfs, yOfs = self.buttonTable[i]:GetPoint(1)

            local deco = self.decoFrame.decoTable[i]
            deco:Show()
            deco:ClearAllPoints()
            deco:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
            deco:SetSize(btnSize, btnSize)
            deco:SetScale(1)
        end
    end
end

function DragonflightUIActionbarMixin:GetShortKey(k)
    if not k then return '' end

    local key = k:upper():gsub(" ", "")

    local KEY_REPLACEMENTS = DF.KEY_REPLACEMENTS;

    for pattern, replacement in pairs(KEY_REPLACEMENTS) do key = key:gsub(pattern, replacement) end

    return key;
end

function DragonflightUIActionbarMixin:StyleButtons()
    local count = #(self.buttonTable)

    for i = 1, count do
        local btn = self.buttonTable[i]
        self:StyleButton(btn)
    end
end

-- C_Timer.After(0, function()
--     print(':3')
--     local btn = CreateFrame("CheckButton", "testbutton", UIParent, "ActionBarButtonTemplate")
--     btn:SetSize(64, 64)
--     btn:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
--     btn:SetScale(5.0)
--     btn:SetAttribute("type", "action")
--     btn:SetAttribute("action", 6) -- Action slot 1

--     DragonflightUIActionbarMixin:StyleButton(btn)
-- end)

function DragonflightUIActionbarMixin:StyleButton(btn, keepNormalHighlight)
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar'
    local textureRefTwo = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'

    local btnName = btn:GetName()

    btn:SetSize(45, 45)
    -- print(btn:GetName())
    -- print(btn:GetName(), btn:GetAttribute("statehidden"))

    local icon = _G[btnName .. 'Icon']
    -- icon:ClearAllPoints()
    icon:SetSize(45, 45)
    -- icon:SetPoint('CENTER')
    -- icon:SetAlpha(0)
    btn.Icon = icon

    local mask = btn:CreateMaskTexture('DragonflightUIIconMask')
    btn.Mask = mask
    mask:SetAllPoints(icon)
    mask:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\maskNew')
    mask:SetSize(45, 45)

    icon:AddMaskTexture(mask)

    local cd = _G[btnName .. 'Cooldown']
    cd:SetSwipeTexture('Interface\\Addons\\DragonflightUI\\Textures\\maskNewAlpha')
    cd:SetSize(45, 45)
    -- cd:GetSwipeTexture():SetAlpha(0.5)
    local deltaCD = 0;
    cd:ClearAllPoints();
    cd:SetPoint('TOPLEFT', btn, 'TOPLEFT', deltaCD + 0.3, -deltaCD);
    cd:SetPoint('BOTTOMRIGHT', btn, 'BOTTOMRIGHT', -deltaCD + 0.2, deltaCD);

    local floatingBG = _G[btnName .. 'FloatingBG']
    if floatingBG then
        floatingBG:ClearAllPoints()
        floatingBG:SetSize(46, 45)
        floatingBG:SetTexture(textureRef)
        floatingBG:SetTexCoord(0.707031, 0.886719, 0.401367, 0.445312)
        floatingBG:SetAllPoints()
    end

    -- TODO: better visibility
    -- iconframe-border
    local border = _G[btnName .. 'Border']
    border:ClearAllPoints()
    border:SetSize(46, 45)
    border:SetPoint('TOPLEFT')
    border:SetTexture(textureRefTwo)
    border:SetTexCoord(0.701171875, 0.880859375, 0.36181640625, 0.40576171875)
    border:SetDrawLayer('OVERLAY')

    -- iconframe
    local normal = btn:GetNormalTexture()
    normal:ClearAllPoints()
    normal:SetSize(46, 45)
    normal:SetPoint('TOPLEFT')
    normal:SetTexture(textureRefTwo)
    normal:SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)
    normal:SetAlpha(1)

    -- iconframe-down
    local pushed = btn:GetPushedTexture()
    pushed:ClearAllPoints()
    pushed:SetSize(46, 45)
    pushed:SetPoint('TOPLEFT')
    pushed:SetTexture(textureRefTwo)
    pushed:SetTexCoord(0.701171875, 0.880859375, 0.43017578125, 0.47412109375)
    -- pushed:SetAlpha(0)

    -- iconframe-mouseover
    local highlight = btn:GetHighlightTexture()
    highlight:ClearAllPoints()
    highlight:SetSize(46, 45)
    highlight:SetPoint('TOPLEFT')
    highlight:SetTexture(textureRefTwo)
    highlight:SetTexCoord(0.701171875, 0.880859375 + 18 * 0.0001, 0.52001953125, 0.56396484375 + 6 * 0.0001)

    if not keepNormalHighlight then
        local ontop = CreateFrame('Frame', btn:GetName() .. 'DFOnTopFrame', btn)
        ontop:SetFrameStrata('MEDIUM')
        ontop:SetFrameLevel(5)
        ontop:SetPoint('TOPLEFT')
        ontop:SetPoint('BOTTOMRIGHT')

        local fakeHighlight = ontop:CreateTexture(btn:GetName() .. 'DFFakeHighlight', 'ARTWORK')
        fakeHighlight:ClearAllPoints()
        fakeHighlight:SetSize(46, 45)
        fakeHighlight:SetPoint('TOPLEFT')
        fakeHighlight:SetTexture(textureRefTwo)
        -- fakeHighlight:SetTexCoord(0.701171875, 0.880859375, 0.52001953125, 0.56396484375)
        fakeHighlight:SetTexCoord(0.701171875, 0.880859375 + 18 * 0.0001, 0.52001953125, 0.56396484375 + 6 * 0.0001)

        fakeHighlight:Hide()

        highlight:SetTexture('')

        btn:HookScript('OnEnter', function()
            -- print('OnEnter')
            fakeHighlight:Show()
        end)
        btn:HookScript('OnLeave', function()
            -- print('OnLeave')
            fakeHighlight:Hide()
        end)
    end

    -- iconframe-mouseover
    if btn.GetCheckedTexture then
        local checked = btn:GetCheckedTexture()
        checked:ClearAllPoints()
        checked:SetSize(46, 45)
        checked:SetPoint('TOPLEFT')
        checked:SetTexture(textureRefTwo)
        checked:SetTexCoord(0.701171875, 0.880859375, 0.52001953125, 0.56396484375)
    end

    local flyoutBorder = _G[btnName .. 'FlyoutBorder']
    if flyoutBorder then
        flyoutBorder:ClearAllPoints()
        --  flyoutBorder:SetSize(46, 45)
        -- flyoutBorder:SetTexture(textureRef)
        -- flyoutBorder:SetTexCoord(0.707031, 0.886719, 0.401367, 0.445312)
        -- flyoutBorder:SetAllPoints()
    end

    local flyoutBorderShadow = _G[btnName .. 'FlyoutBorderShadow']
    if flyoutBorderShadow then
        flyoutBorderShadow:ClearAllPoints()
        flyoutBorderShadow:SetSize(52, 52)
        flyoutBorderShadow:SetTexture(textureRefTwo)
        flyoutBorderShadow:SetTexCoord(0.701172, 0.904297, 0.163574, 0.214355)
        flyoutBorderShadow:SetPoint('CENTER', icon, 'CENTER', -0.3, 0.6)
        flyoutBorderShadow:SetDrawLayer('ARTWORK', -1)
        -- ["UI-HUD-ActionBar-IconFrame-FlyoutBorderShadow"]={52, 26, 0.701172, 0.904297, 0.163574, 0.214355, false, false, "2x"},
    end

    local flyoutArrow = _G[btnName .. 'FlyoutArrow']
    if flyoutArrow then
        -- ["UI-HUD-ActionBar-Flyout"]={18, 3, 0.884766, 0.955078, 0.438965, 0.445801, false, false, "2x"},
        -- ["UI-HUD-ActionBar-Flyout-Down"]={19, 4, 0.884766, 0.958984, 0.430176, 0.437988, false, false, "2x"},
        -- ["UI-HUD-ActionBar-Flyout-Mouseover"]={18, 3, 0.884766, 0.955078, 0.446777, 0.453613, false, false, "2x"},

        flyoutArrow:ClearAllPoints()
        flyoutArrow:SetSize(18, 6)
        flyoutArrow:SetTexture(textureRefTwo)
        flyoutArrow:SetTexCoord(0.884766, 0.955078, 0.438965, 0.445801)
        flyoutArrow:SetPoint('TOP', btn, 'TOP', 0, 6)
    end

    local flash = _G[btnName .. 'Flash']
    if flash then
        flash:ClearAllPoints()
        flash:SetSize(46, 45)
        flash:SetPoint('TOPLEFT')
        flash:SetTexture(textureRefTwo)
        flash:SetTexCoord(0.701172, 0.880859, 0.475098, 0.519043)
        flash:SetDrawLayer('OVERLAY')
    end

    -- TODO: support dynamic
    -- btn:SetAttribute("flyoutDirection", nil);

    function btn:UpdateFlyoutDirection(dir)
        btn:SetAttribute("flyoutDirection", dir);
        if self.action then ActionButton_UpdateFlyout(btn); end
    end
    btn:UpdateFlyoutDirection(nil);

    function btn:SetKeybindFontSize(newSize)
        local hotkey = self.HotKey
        local fontFile, fontHeight, flags = hotkey:GetFont()
        hotkey:SetFont(fontFile, newSize, "OUTLINE")
    end

    function btn:FixHotkeyPosition()
        local hotkey = self.HotKey
        hotkey:ClearAllPoints()
        hotkey:SetSize(46 - 10, 10)
        hotkey:SetPoint('TOPRIGHT', -5, -5)
    end

    do
        function btn:UpdateHotkeyDisplayText(shorten)
            local name = self:GetName();
            local actionButtonType = self.buttonType;
            local id;
            if (not actionButtonType) then
                actionButtonType = "ACTIONBUTTON";
                id = self:GetID();
            else
                if (actionButtonType == "MULTICASTACTIONBUTTON") then
                    id = self.buttonIndex;
                else
                    id = self:GetID();
                end
            end

            local hotkey = self.HotKey
            hotkey:Show()
            local key = GetBindingKey(actionButtonType .. id) or GetBindingKey("CLICK " .. name .. ":Keybind");

            if not key then
                hotkey:SetText('');
                return
            end

            local text = GetBindingText(key, 1);

            if not shorten then
                hotkey:SetText(text)
                -- print('..', name, id, actionButtonType, key, text, '*')
                return;
            end

            local shortText = DragonflightUIActionbarMixin:GetShortKey(key)

            hotkey:SetText(shortText)
            -- print('..', name, id, actionButtonType, key, text, shortText)
        end

        btn:UpdateHotkeyDisplayText(false)
    end

    btn.BarRef = self;
    function btn:DragonflightFixHotkey()
        self:FixHotkeyPosition()

        local state = self.BarRef.state;
        if not state then
            self:SetKeybindFontSize(14 + 2)
            return
        end
        self:UpdateHotkeyDisplayText(state.shortenKeybind)
        self:SetKeybindFontSize(state.keybindFontSize)
    end
    btn:DragonflightFixHotkey()

    do
        local name = _G[btnName .. 'Name']
        name:ClearAllPoints()
        name:SetSize(46, 10)
        name:SetPoint('BOTTOM', 0, 2)

        function btn:SetMacroFontSize(newSize)
            local fontFile, fontHeight, flags = name:GetFont()
            name:SetFont(fontFile, newSize, "OUTLINE")
        end

        btn:SetMacroFontSize(14)
    end

    do
        local count = _G[btnName .. 'Count']
        count:ClearAllPoints()
        count:SetPoint('BOTTOMRIGHT', btn, 'BOTTOMRIGHT', -5, 5)
        local fontFile, fontHeight, flags = count:GetFont()
        count:SetFont(fontFile, 14 + 2, flags)
    end
end

function DragonflightUIActionbarMixin:MigrateOldKeybinds()
    DF:Debug(DF, '~~MigrateOldKeybinds()~~')
    local which = GetCurrentBindingSet()
    local changed = false;
    for i = 6, 8 do
        for j = 1, 12 do
            local n = "CLICK DragonflightUIMultiactionBar" .. i .. "Button" .. j .. ":LeftButton"
            local updated = "CLICK DragonflightUIMultiactionBar" .. i .. "Button" .. j .. ":Keybind"

            local key1, key2 = GetBindingKey(n)

            if key1 and key2 then
                -- print('~OLD:', n, key1 or "", ' | ', key2 or "")
                local ok1 = SetBinding(key1, updated, which)
                local ok2 = SetBinding(key2, updated, which)
                -- print('~CHANGED?', ok1, ok2)
                changed = true;
            elseif key1 then
                -- print('~OLD:', n, key1 or "")
                local ok1 = SetBinding(key1, updated, which)
                -- print('~CHANGED?', ok1)
                changed = true;
            end
        end
    end
    DF:Debug(DF, '~~~> changes?', changed);
    if changed then SaveBindings(which) end
end

function DragonflightUIActionbarMixin:ReplaceNormalTexture2()
    local count = #(self.buttonTable)
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar'
    local textureRefTwo = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'
    local maskRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbariconframemask'

    for i = 1, count do
        local btn = self.buttonTable[i]
        local btnName = btn:GetName()

        local normal = btn:GetNormalTexture()
        normal:Hide()
        normal:SetTexture('')

        local newNormal = btn:CreateTexture('DragonflightUINormalTexture2Replacement', 'BORDER')
        newNormal:ClearAllPoints()
        newNormal:SetSize(46, 45)
        newNormal:SetPoint('TOPLEFT')
        newNormal:SetTexture(textureRefTwo)
        newNormal:SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)
        btn.DFNormalTexture = newNormal
        -- newNormal:SetAlpha(1)
    end
end

function DragonflightUIActionbarMixin:SetIgnoreRange(ignore)
    local count = #(self.buttonTable)

    for i = 1, count do
        local btn = self.buttonTable[i]
        btn.ignoreRange = ignore

        local icon = btn.Icon
        icon:SetVertexColor(1.0, 1.0, 1.0, 1.0) -- default
        icon:SetDesaturated(false) -- default

        btn.checksRange = nil;
        btn.inRange = nil;
    end
end

function DragonflightUIActionbarMixin:StyleFlyout()
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'

    local bgEnd = SpellFlyout.BgEnd
    bgEnd:ClearAllPoints()
    bgEnd:SetSize(47, 28)
    bgEnd:SetPoint('TOP', SpellFlyout, 'TOP', 0, 7)
    bgEnd:SetTexture(textureRef)
    bgEnd:SetTexCoord(0.701172, 0.884766, 0.564941, 0.593262)

    local textureVert = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbarvertical2x'

    local vert = SpellFlyout.VertBg
    vert:ClearAllPoints()
    vert:SetSize(47, 32)
    vert:SetPoint('TOP', bgEnd, 'BOTTOM', 0, 0)
    vert:SetPoint('BOTTOM', SpellFlyout, 'BOTTOM', 0, 0)
    vert:SetTexture(textureVert)
    vert:SetTexCoord(0.00390625, 0.371094, 0, 1)

    --     ["UI-HUD-ActionBar-IconFrame-FlyoutBottom"]={47, 2, 0.701172, 0.884766, 0.594238, 0.599121, false, false, "2x"},
    if not SpellFlyout.Start then
        local start = SpellFlyout:CreateTexture('DragonflightUISpellFlyoutStartTexture', 'BACKGROUND')
        start:SetSize(47, 4)
        -- start:SetPoint('TOP', bgEnd, 'BOTTOM', 0, 0)
        start:SetPoint('TOP', vert, 'BOTTOM', 0, 0)
        start:SetTexture(textureRef)
        start:SetTexCoord(0.701172, 0.884766, 0.594238, 0.599121)

        SpellFlyout.Start = start
    end
end

function DragonflightUIActionbarMixin:StyleFlyoutButton(btn)
    -- print(' DragonflightUIActionbarMixin:StyleFlyoutButton(btn)', btn:GetName())
    btn.DFHooked = true

    local textureRefTwo = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'

    local btnName = btn:GetName()
    local icon = _G[btnName .. 'Icon']

    local mask = btn:CreateMaskTexture('DragonflightUIIconMask')
    btn.Mask = mask
    mask:SetAllPoints(icon)
    mask:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\maskNew')
    mask:SetSize(28, 28)

    icon:AddMaskTexture(mask)

    local border = btn:CreateTexture('border', 'OVERLAY')
    border:SetSize(28, 28)
    border:SetPoint('CENTER')
    border:SetTexture(textureRefTwo)
    border:SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)
    border:SetDrawLayer('OVERLAY')
    btn.DFBorder = border

    local highlight = btn:GetHighlightTexture()
    highlight:ClearAllPoints()
    highlight:SetSize(28, 28)
    highlight:SetPoint('CENTER')
    highlight:SetTexture(textureRefTwo)
    highlight:SetTexCoord(0.701171875, 0.880859375, 0.52001953125, 0.56396484375)

    local pushed = btn:GetPushedTexture()
    pushed:ClearAllPoints()
    pushed:SetSize(28, 28)
    pushed:SetPoint('CENTER')
    pushed:SetTexture(textureRefTwo)
    pushed:SetTexCoord(0.701171875, 0.880859375, 0.43017578125, 0.47412109375)
end

function DragonflightUIActionbarMixin:HookFlyout()
    hooksecurefunc('ActionButton_UpdateFlyout', function(self)
        if not self.FlyoutArrow then return; end

        local actionType = GetActionInfo(self.action);
        if not (actionType == "flyout") then return; end

        -- Update border
        local isMouseOverButton = self:IsMouseMotionFocus()
        -- if GetMouseFocus then
        --     isMouseOverButton = GetMouseFocus() == self;
        -- else
        --     local foci = GetMouseFoci()
        --     isMouseOverButton = foci[1] == self;
        -- end
        local isFlyoutShown = SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == self;
        if (isFlyoutShown or isMouseOverButton) then
            self.FlyoutBorderShadow:Show();
        else
            self.FlyoutBorderShadow:Hide();
        end
        local isButtonDown = self:GetButtonState() == "PUSHED";
        -- print('State:', self:GetButtonState())

        if (isButtonDown) then
            -- print('isButtonDown')
            -- self.FlyoutArrow:SetSize(19, 8)
            -- self.FlyoutArrow:SetTexCoord(0.884766, 0.958984, 0.430176, 0.437988)
            self.FlyoutArrow:SetSize(18, 6)
            self.FlyoutArrow:SetTexCoord(0.884766, 0.955078, 0.438965, 0.445801)
        elseif (isMouseOverButton) then
            -- print('isMouseOverButton')
            self.FlyoutArrow:SetSize(18, 6)
            self.FlyoutArrow:SetTexCoord(0.884766, 0.955078, 0.446777, 0.453613)
        else
            -- print('else')
            self.FlyoutArrow:SetSize(18, 6)
            self.FlyoutArrow:SetTexCoord(0.884766, 0.955078, 0.438965, 0.445801)
        end

        self.FlyoutArrow:Show();
        self.FlyoutArrow:ClearAllPoints();

        local arrowDirection = self:GetAttribute("flyoutDirection");
        local arrowDistance = isFlyoutShown and 1 or 4;

        -- print('arrow', arrowDirection, arrowDistance)

        -- arrowDirection = 'LEFT'
        --[[ 
        if (arrowDirection == "LEFT") then
            SetClampedTextureRotation(self.FlyoutArrow, 90);
            self.FlyoutArrow:SetPoint("LEFT", self, "LEFT", -arrowDistance, 0);
            -- self.FlyoutArrow:SetRotation(math.pi / 2, {x = 0.5, y = 0.5})
        elseif (arrowDirection == "RIGHT") then
            -- SetClampedTextureRotation(self.FlyoutArrow, isFlyoutShown and 270 or 90);
            self.FlyoutArrow:SetPoint("RIGHT", self, "RIGHT", arrowDistance, 0);
        elseif (arrowDirection == "DOWN") then
            -- SetClampedTextureRotation(self.FlyoutArrow, isFlyoutShown and 0 or 180);
            self.FlyoutArrow:SetPoint("BOTTOM", self, "BOTTOM", 0, -arrowDistance);
        else
            SetClampedTextureRotation(self.FlyoutArrow, 0);
            self.FlyoutArrow:SetPoint("TOP", self, "TOP", 0, arrowDistance);
        end ]]

        -- TODO

        if isFlyoutShown then
            -- self.FlyoutArrow:SetTexCoord(0.884766, 0.955078, 0.438965, 0.445801)
            -- self.FlyoutArrow:SetTexCoord(0.884766, 0.955078, 0.438965, 0.445801)    
            self.FlyoutArrow:SetRotation(math.pi, {x = 0.5, y = 0.5})
            self.FlyoutArrow:SetPoint("TOP", self, "TOP", 0, 1);
        else
            self.FlyoutArrow:SetRotation(0, {x = 0.5, y = 0.5})
            self.FlyoutArrow:SetPoint("TOP", self, "TOP", 0, 4);
        end
    end)

    hooksecurefunc(SpellFlyout, 'Toggle', function(self, flyoutID, parent, direction, distance, isActionBar)
        -- print('toggles', self, flyoutID, parent, direction, distance, isActionBar)

        if not SpellFlyout:IsVisible() then return end
        DragonflightUIActionbarMixin:StyleFlyout()

        for i = 1, 10 do
            local btn = _G['SpellFlyoutButton' .. i]

            if btn and not btn.DFHooked then
                --
                DragonflightUIActionbarMixin:StyleFlyoutButton(btn)
            end
        end
    end)
end

-- TODO only debug for now..
function DragonflightUIActionbarMixin:HookGrid()
    hooksecurefunc('ActionButton_ShowGrid', function(btn)
        if (btn.NormalTexture) then btn.NormalTexture:SetVertexColor(1.0, 1.0, 1.0, 1); end
    end)
end

function DragonflightUIActionbarMixin:FixGlow(btn)
    if not btn.overlay then return end
    print('~~~FixGlow', btn:GetName())

    local isGlowing = btn.overlay.animIn:IsPlaying()
    local isOut = btn.overlay.animOut:IsPlaying()

    print('~~>> isGlowing, isOut?', isGlowing, isOut)
    -- if not isGlowing then return end
    -- print('GLOWING')

    -- btn.overlay.animIn:Stop();
    -- btn.overlay.animOut:Stop();

    -- self.overlay = ActionButton_GetOverlayGlow();
    local frameWidth, frameHeight = btn:GetSize();
    btn.overlay:SetParent(btn);
    btn.overlay:ClearAllPoints();
    -- Make the height/width available before the next frame:
    btn.overlay:SetSize(frameWidth * 1.4, frameHeight * 1.4);
    btn.overlay:SetPoint("TOPLEFT", btn, "TOPLEFT", -frameWidth * 0.2, frameHeight * 0.2);
    btn.overlay:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", frameWidth * 0.2, -frameHeight * 0.2);
    -- self.overlay.animIn:Play();

    if isGlowing then
        -- local elapsedSec = btn.overlay.animIn:GetElapsed()
        -- btn.overlay.animIn:Stop();

        -- local func = btn.overlay.animIn:GetScript('OnPlay')
        -- func(btn.overlay.animIn)
        -- btn.overlay.animIn:Play(false, elapsedSec);
    elseif isOut then
        -- btn.overlay.animIn:Stop();
        -- local elapsedSec = btn.overlay.animOut:GetElapsed()
        -- local func = btn.overlay.animIn:GetScript('OnFinished')
        -- func(btn.overlay.animIn)
        -- btn.overlay.animOut:Play(false, elapsedSec);
    end
end

function DragonflightUIActionbarMixin:HookGlow()
    -- print('DragonflightUIActionbarMixin:HookGlow()')

    -- hooksecurefunc('ActionButton_ShowOverlayGlow', function(btn)
    --     print('ActionButton_ShowOverlayGlow', btn:GetName())
    --     -- self:FixGlow(btn)
    -- end)

    -- hooksecurefunc('ActionButton_ShowOverlayGlow', function(btn)
    --     -- print('~ActionButton_ShowOverlayGlow', btn:GetName(), btn.overlay:GetSize())
    --     fixGlow(btn)
    -- end)

    -- hooksecurefunc('ActionButton_HideOverlayGlow', function(btn)
    --     -- print('~ActionButton_HideOverlayGlow', btn:GetName())
    -- end)
end

DragonflightUIPetbarMixin = CreateFromMixins(DragonflightUIActionbarMixin)

--[[ function DragonflightUIPetbarMixin:Update()
    local state = self.state
    print("DragonflightUIPetbarMixin:Update()", state)
    DevTools_Dump(state)
end ]]

function DragonflightUIPetbarMixin:UpdateGrid()
end

function DragonflightUIPetbarMixin:StylePetButton()
    local count = #(self.buttonTable)
    local textureRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar'
    local textureRefTwo = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbar2x'
    local maskRef = 'Interface\\Addons\\DragonflightUI\\Textures\\uiactionbariconframemask'

    for i = 1, count do
        local btn = self.buttonTable[i]
        local btnName = btn:GetName()

        btn.buttonType = 'BONUSACTIONBUTTON'

        local normalTwo = _G[btnName .. 'NormalTexture2']
        normalTwo:Hide()
        normalTwo:SetTexture('')
        normalTwo:SetAlpha(0)

        local newNormal = btn:CreateTexture('DragonflightUINormalTexture2Replacement', 'OVERLAY')
        newNormal:ClearAllPoints()
        newNormal:SetSize(46, 45)
        newNormal:SetPoint('TOPLEFT')
        newNormal:SetTexture(textureRefTwo)
        newNormal:SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)
        newNormal:SetAlpha(1)
        newNormal:SetDrawLayer('OVERLAY', 1)
        btn.DFNormalTexture = newNormal

        local shine = _G[btnName .. 'Shine']
        -- <Frame name="$parentShine" inherits="AutoCastShineTemplate">
        -- <Anchor point="CENTER" x="0" y="0"/>
        -- <Size x="28" y="28"/>
        -- shine:SetSize(46, 46)      

        local child1, child2, child3 = btn:GetChildren()
        child1:SetSize(41, 41)

        local auto = _G[btnName .. 'AutoCastable']
        local autoSize = 80
        auto:SetSize(autoSize, autoSize)
        auto:SetDrawLayer('OVERLAY', 2)
    end
end

DragonflightUIStancebarMixinCode = {}

function DragonflightUIStancebarMixinCode:CreateCustomStanceBarButtons()
    local extraParent = CreateFrame('FRAME', 'DragonflightUIStanceBarVisParent', UIParent)
    extraParent:SetFrameLevel(0)

    local function customOnEnter(f)
        if (GetCVarBool("UberTooltips")) then
            GameTooltip_SetDefaultAnchor(GameTooltip, f);
        else
            GameTooltip:SetOwner(f, "ANCHOR_RIGHT");
        end

        GameTooltip:SetShapeshift(f:GetID());
        f.UpdateTooltip = customOnEnter;
    end

    local btns = {}
    for i = 1, 10 do
        --
        local btn =
            CreateFrame("CheckButton", "DragonflightUIStanceButton" .. i, extraParent, "StanceButtonTemplate", i)
        btn:SetSize(64, 64)
        btn:SetPoint("CENTER", UIParent, "CENTER", 64 * i, 0)
        -- btn:SetAttribute("type", "action")
        -- btn:SetAttribute("action", 144 + (n - 6) * 12 + i) -- Action slot 1
        btn:SetFrameLevel(3)

        btn.command = "SHAPESHIFTBUTTON" .. i
        btn.commandHuman = "Stance Bar Button " .. i

        btn:SetScript('OnEnter', customOnEnter)

        btns[i] = btn;

        local orig = _G['StanceButton' .. i]
        orig:ClearAllPoints()
        orig:Hide()
        orig:SetPoint('TOP', UIParent, 'BOTTOM', 0, -666)
    end

    self:SetButtons(btns, 42)
    self:StyleButtons()
    self:ReplaceNormalTexture2()

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
    self:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
    self:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    self:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
    self:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
    self:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")

    self:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
    self:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
    self:RegisterEvent("UPDATE_POSSESS_BAR")

    self:RegisterEvent("UPDATE_BINDINGS", "ReassignBindings")
    self:SetScript('OnEvent', function(_, event, arg1)
        -- print(self:GetName(), event, arg1)
        self:UpdateButtonState(not InCombatLockdown())

        -- if event == 'UPDATE_SHAPESHIFT_COOLDOWN' then
        --     self:UpdateButtonState(false)
        -- elseif event == 'PLAYER_REGEN_ENABLED' then
        --     if InCombatLockdown() then return end
        --     self:UpdateButtonState(true)
        -- else
        --     if InCombatLockdown() then
        --         self:UpdateButtonState(false)
        --     else
        --         self:UpdateButtonState(true)
        --     end
        -- end
        -- self:Update()
        -- self:UpdateGridState()
    end)

    self:UpdateButtonState(true)

    -- hooksecurefunc('StanceBar_Select', function(id)
    --     print('StanceBar_Select')
    --     self:UpdateButtonState(false)
    -- end)

    -- hooksecurefunc('CastShapeshiftForm', function()
    --     print('CastShapeshiftForm')
    --     self:UpdateButtonState(false)
    -- end)

end

function DragonflightUIStancebarMixinCode:UpdateButtonState(showHide)
    local numForms = GetNumShapeshiftForms();
    local texture, isActive, isCastable;
    local button, icon, cooldown;
    local start, duration, enable;
    for i = 1, NUM_STANCE_SLOTS do
        button = self.buttonTable[i];
        icon = button.icon;
        if (i <= numForms) then
            texture, isActive, isCastable = GetShapeshiftFormInfo(i);
            icon:SetTexture(texture);

            -- Cooldown stuffs
            cooldown = button.cooldown;
            if (texture) then
                cooldown:Show();
            else
                cooldown:Hide();
            end
            start, duration, enable = GetShapeshiftFormCooldown(i);
            CooldownFrame_Set(cooldown, start, duration, enable);

            if (isActive) then
                self.lastSelected = button:GetID();
                button:SetChecked(true);
            else
                button:SetChecked(false);
            end

            if (isCastable) then
                icon:SetVertexColor(1.0, 1.0, 1.0);
            else
                icon:SetVertexColor(0.4, 0.4, 0.4);
            end

            if self.state then
                button.buttonType = 'SHAPESHIFTBUTTON'
                button:UpdateHotkeyDisplayText(self.state.shortenKeybind)
            end
            if showHide then button:Show(); end
        else
            if showHide then button:Hide(); end
        end
    end
end

function DragonflightUIStancebarMixinCode:Update()
    local state = self.state
    -- print("DragonflightUIStancebarMixin:Update()", state)
    -- DevTools_Dump(state)
    local buttonTable = self.buttonTable
    local btnCount = #buttonTable

    if state.reverse then
        local tmp = {}
        for i = 1, btnCount do tmp[i] = buttonTable[i] end
        buttonTable = {}
        for i = 1, btnCount do buttonTable[btnCount + 1 - i] = tmp[i] end
    end

    local btnScale = state.buttonScale
    local btnSize = buttonTable[1]:GetWidth()
    -- local btnSize = self.buttonTable[1]:GetWidth() * state.buttonScale
    -- local btnSize = (self.buttonTable[1]:GetWidth() / self.buttonTable[1]:GetScale()) * btnScale
    -- local btnSize = 36 * state.buttonScale

    -- print(btnScale, btnSize)

    local modulo = state.buttons % state.rows

    local buttons = math.min(state.buttons, btnCount)
    -- local buttons = math.min(state.buttons, GetNumShapeshiftForms())
    local rows = state.rows
    if rows > state.buttons then rows = buttons end

    local maxRowButtons = math.ceil(buttons / rows)
    -- print('maxRowButtons', maxRowButtons)

    local padding = state.padding
    -- local width = (maxRowButtons * btnSize + (maxRowButtons + 1) * padding) * btnScale
    local width = (maxRowButtons * (btnSize + 2 * padding)) * btnScale
    local height = (rows * (btnSize + 2 * padding)) * btnScale

    if state.orientation == 'horizontal' then
        self:SetSize(width, height)
    else
        self:SetSize(height, width)
    end

    for i = buttons + 1, btnCount do
        local btn = buttonTable[i]
        btn:ClearAllPoints()
        btn:SetPoint('CENTER', UIParent, 'BOTTOM', 0, -666)
        btn:Hide()

        if btn.decoDF then btn.decoDF:Hide() end
    end

    local index = 1

    local forms = GetNumShapeshiftForms()

    -- i = rowIndex
    for i = 1, rows do
        local rowButtons = buttons / rows

        if i <= modulo then
            rowButtons = math.ceil(rowButtons)
        else
            rowButtons = math.floor(rowButtons)
        end
        -- print('row', i, rowButtons)

        -- j = btn in row index
        for j = 1, rowButtons do
            local btn = buttonTable[index]
            -- print('btn', i, btn:GetName())
            btn:ClearAllPoints()
            if index > forms then
                -- btn:Hide()
            else
                -- btn:Show()
            end
            if btn.decoDF then btn.decoDF:SetShown(not state.hideArt) end

            btn:SetScale(btnScale)
            local dx = (2 * j - 1) * padding + (j - 1) * btnSize
            local dy = (2 * i - 1) * padding + (i - 1) * btnSize

            local sgn = 1;
            local anchor = 'BOTTOMLEFT';

            if state.growthDirection == 'down' then
                sgn = -1;
                anchor = 'TOPLEFT'
            end

            if state.orientation == 'horizontal' then
                btn:SetPoint(anchor, self, anchor, dx, sgn * dy)
            else
                btn:SetPoint(anchor, self, anchor, dy, sgn * dx)
            end

            -- btn:GetAttribute("showgrid") can be nil
            -- if state.alwaysShow then
            -- if btn:GetAttribute("showgrid") then
            --     if btn:GetAttribute("showgrid") < 1 then btn:SetAttribute("showgrid", 1) end
            -- else
            --     btn:SetAttribute("showgrid", 1)
            -- end            
            -- else
            -- if btn:GetAttribute("showgrid") and btn:GetAttribute("showgrid") > 0 then
            --     btn:SetAttribute("showgrid", 0)
            -- end

            -- if btn.action then
            --     if not HasAction(btn.action) then btn:Hide() end
            -- else
            --     btn:Hide()
            -- end              
            -- end

            -- if state.alwaysShow then
            --     btn:SetAttribute("showgrid", 1)
            -- else
            --     btn:SetAttribute("showgrid", 0)
            -- end
            btn:SetAttribute("showgrid", 0)

            if state.hideArt then
                if btn.DFDeco then btn.DFDeco:Hide() end
            else
                if btn.DFDeco then btn.DFDeco:Show() end
            end

            local name = btn:GetName()
            local macroText = _G[name .. 'Name']
            local keybindText = _G[name .. 'HotKey']

            if state.hideMacro then
                macroText:SetAlpha(0)
            else
                macroText:SetAlpha(1)
            end

            btn:SetMacroFontSize(state.macroFontSize)

            if state.hideKeybind then
                keybindText:SetAlpha(0)
            else
                keybindText:SetAlpha(1)
            end

            btn:SetKeybindFontSize(state.keybindFontSize)

            btn.buttonType = 'SHAPESHIFTBUTTON'
            btn:UpdateHotkeyDisplayText(state.shortenKeybind)

            index = index + 1
        end
    end
    self:ShowHighlight(false)

    -- print(self.buttonTable[1]:GetName(), 'update')
    -- self:UpdateGrid(state.alwaysShow)

    -- mainbar only
    -- if self.gryphonLeft and self.gryphonRight then self:UpdateGryphons(state.gryphons) end

    -- if self.numberFrame then self:UpdateNumberFrame() end

    -- if self.decoFrame then self.decoFrame.update(state) end

    -- if state.activate ~= nil and false then
    --     --
    --     -- print('state.activate ~= nil', state.activate, self:GetName())
    --     -- self:SetShown(state.activate)
    --     if state.activate == false then
    --         if self.stanceBar then self:Hide() end
    --         for i = 1, btnCount do
    --             local btn = buttonTable[i]
    --             btn:ClearAllPoints()
    --             btn:SetPoint('CENTER', UIParent, 'BOTTOM', 0, -666)
    --             btn:Hide()
    --             if btn.decoDF then btn.decoDF:Hide() end
    --         end
    --     else
    --         if self.stanceBar then
    --             self:Show()
    --             for i = 1, btnCount do
    --                 local btn = buttonTable[i]

    --                 if btn.action then
    --                     --
    --                     if HasAction(btn.action) then btn:Show() end
    --                 end
    --             end
    --         end
    --     end
    -- end

    local isLegal, loopStr = self:IsAnchorframeLegal();
    local loopStrFixed, _ = gsub(loopStr, 'DragonflightUI', 'DF')
    -- print(loopStrFixed)
    if not isLegal then
        local retOK, ret1 = xpcall(function()
            local msg = self:GetName() ..
                            ' AnchorFrame is forming an illegal anchor chain, please fix inside the DragonflightUI options! (A frame cant be anchored to another frame depending on it) \n LOOP: ' ..
                            loopStrFixed
            print('|cffFF0000ERROR! |r' .. msg);
            -- print(loopStrFixed)
            error(msg, 1)
        end, geterrorhandler())

        return
    end

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    self:ClearAllPoints()
    self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

    self:UpdateStateHandler(state)

    -- StanceBar_UpdateState()
    self:UpdateButtonState(true)
end

DragonflightUIStancebarMixin = CreateFromMixins(DragonflightUIActionbarMixin, DragonflightUIStancebarMixinCode)

-- FPS
DragonflightUIFPSMixin = {}

function DragonflightUIFPSMixin:OnLoad()
    UIPARENT_MANAGED_FRAME_POSITIONS.FramerateLabel = nil

    self:SetupFrame()

    self.fpsTime = 0;
    self:Hide()

    hooksecurefunc('ToggleFramerate', function()
        --
        self:Update()
    end)
end

function DragonflightUIFPSMixin:SetupFrame()
    local Path, Size, Flags = FramerateText:GetFont()

    do
        local t = self:CreateFontString('FPSLabel', 'OVERLAY', 'SystemFont_Shadow_Med1')
        t:SetPoint('TOPLEFT', 0, 0)
        t:SetText('FPS:')
        t:SetFont(Path, Size, Flags)

        self.FPSLabel = t
    end

    do
        local t = self:CreateFontString('PingLabel', 'OVERLAY', 'SystemFont_Shadow_Med1')
        t:SetPoint('TOPLEFT', self.FPSLabel, 'BOTTOMLEFT', 0, 0)
        t:SetText('MS:')
        t:SetFont(Path, Size, Flags)

        self.PingLabel = t
    end

    do
        local t = self:CreateFontString('FPSText', 'OVERLAY', 'SystemFont_Shadow_Med1')
        t:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 0, 0)
        t:SetText('')
        t:SetFont(Path, Size, Flags)

        self.FPSText = t
    end

    do
        local t = self:CreateFontString('PingText', 'OVERLAY', 'SystemFont_Shadow_Med1')
        t:SetPoint('TOPRIGHT', self.FPSText, 'BOTTOMRIGHT', 0, 0)
        t:SetText('')
        t:SetFont(Path, Size, Flags)

        self.PingText = t
    end
end

function DragonflightUIFPSMixin:OnUpdate(elapsed)
    if not self:IsShown() then return end

    local timeLeft = self.fpsTime - elapsed
    if (timeLeft <= 0) then
        -- 0.25
        self.fpsTime = FRAMERATE_FREQUENCY;

        local framerate = GetFramerate();
        self.FPSText:SetFormattedText("%.1f", framerate);

        local down, up, lagHome, lagWorld = GetNetStats()
        -- local str = 'MS: ' .. lagHome .. '|' .. lagWorld
        local str = tostring(math.max(lagHome, lagWorld))
        self.PingText:SetText(str)
    else
        self.fpsTime = timeLeft;
    end
end

function DragonflightUIFPSMixin:SetState(state)
    self.state = state
    self:Update()
end

function DragonflightUIFPSMixin:Update()
    local state = self.state;

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    self:ClearAllPoints()
    self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

    self:SetScale(state.scale)

    -- self:UpdateStateHandler(state)

    FramerateLabel:ClearAllPoints()
    if state.hideDefaultFPS then
        FramerateLabel:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 117 - 500)
    else
        FramerateLabel:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 117)
    end

    if state.showPing then
        self.PingLabel:Show()
        self.PingText:Show()
    else
        self.PingLabel:Hide()
        self.PingText:Hide()
    end

    if state.showFPS then
        self.FPSLabel:Show()
        self.FPSText:Show()
    else
        self.FPSLabel:Hide()
        self.FPSText:Hide()
    end

    self:SetShown(FramerateLabel:IsShown())

    if state.alwaysShowFPS then self:Show() end

    if state.EditModeActive then self:Show() end
end

