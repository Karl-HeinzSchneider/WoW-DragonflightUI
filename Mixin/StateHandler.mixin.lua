local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
DragonflightUIStateHandlerMixin = {}

function DragonflightUIStateHandlerMixin:InitStateHandler(extraX, extraY)
    local handler = CreateFrame('FRAME', self:GetName() .. 'Handler', nil, 'SecureHandlerStateTemplate')
    self.DFStateHandler = handler

    handler:SetAttribute('forceShow', false)
    handler:SetAttribute('_onstate-vis', [[
        -- if not newstate then return end     
        local shower = self:GetFrameRef("Shower")
        if not shower then return end  
        -- print(shower:GetName(),'NewState',newstate)
        local shouldShow = true

        if newstate == "show" then
            shouldShow = true
        elseif newstate == "hide" then
           shouldShow = false         
        else 
           shouldShow = true
        end  

        if shouldShow then
            self:SetAttribute('forceShow', false)
            shower:UnregisterAutoHide()  
        else
            local forceShow = self:GetAttribute('forceShow')     

            if forceShow then  
                shouldShow = true    
                shower:RegisterAutoHide(0.1)
            else
                -- TODO unnecessary?
                shower:UnregisterAutoHide()  
            end
        end

        if shouldShow then 
            shower:Show();
        else
            shower:Hide();
        end
    ]])

    ----------
    extraX = extraX or 2
    extraY = extraY or 2
    ----------
    local shower = CreateFrame('FRAME', self:GetName() .. 'Shower', nil, 'SecureHandlerShowHideTemplate')
    shower:SetPoint('TOPLEFT', self, 'TOPLEFT', -extraX, extraY)
    shower:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', extraX, -extraY)

    shower:SetFrameRef('MainHandler', handler)

    self.DFShower = shower

    handler:SetFrameRef('Shower', shower)
    handler:SetFrameRef('HideFrame1', self)

    shower:SetAttribute('_onshow', [[   
        local frameRef = self:GetFrameRef("MainHandler")

        local unitRef = frameRef:GetAttribute('UnitRef')
        if unitRef and not UnitExists(unitRef) then
            return
        end

        for i=1,13 do
            local f = frameRef:GetFrameRef('HideFrame'..i)
            if f then f:Show() end
        end    
    ]])

    shower:SetAttribute('_onhide', [[     
         local frameRef = self:GetFrameRef("MainHandler")

        for i=1,13 do
            local f = frameRef:GetFrameRef('HideFrame'..i)
            if f then f:Hide() end
        end      
    ]])

    ----------
    local handlerTwo = CreateFrame('FRAME', self:GetName() .. 'HandlerOnEnterLeave', nil,
                                   'SecureHandlerEnterLeaveTemplate')
    handlerTwo:SetPoint('TOPLEFT', self, 'TOPLEFT', -extraX, extraY)
    handlerTwo:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', extraX, -extraY)
    handlerTwo:SetFrameLevel(math.max(self:GetFrameLevel() - 1, 0))
    handlerTwo:SetFrameStrata(self:GetFrameStrata())

    handlerTwo:SetFrameRef('MainHandler', handler)
    handlerTwo:SetFrameRef('Shower', shower)

    self.DFMouseHandler = handlerTwo

    handler:SetFrameRef('HandlerTwo', handlerTwo)
    shower:SetFrameRef('HandlerTwo', handlerTwo)

    handlerTwo:SetAttribute('_onenter', [[ 
        local frameRef = self:GetFrameRef("MainHandler")
        frameRef:SetAttribute('forceShow', true)

        local oldState = frameRef:GetAttribute('state-vis')
        frameRef:SetAttribute('state-vis', oldState)      
    ]])
    handlerTwo:SetAttribute('_onleave', [[]])
end

function DragonflightUIStateHandlerMixin:SetHideFrame(frame, index)
    self.DFStateHandler:SetFrameRef('HideFrame' .. index, frame)
end

function DragonflightUIStateHandlerMixin:SetUnit(unit)
    self.DFStateHandler:SetAttribute('UnitRef', unit)
end

local visConditionalTable = {}
do
    visConditionalTable['hideAlways'] = 'hide'
    visConditionalTable['hideCombat'] = '[combat]hide'
    visConditionalTable['hideOutOfCombat'] = '[nocombat]hide'
    visConditionalTable['hidePet'] = '[pet]hide'
    visConditionalTable['hideNoPet'] = '[nopet]hide'
    visConditionalTable['hideStance'] = ''
    visConditionalTable['hideStealth'] = '[stealth]hide'
    visConditionalTable['hideNoStealth'] = '[nostealth]hide'
    visConditionalTable['hideBattlePet'] = '[petbattle]hide'
end

function DragonflightUIStateHandlerMixin:UpdateStateHandler(state, activateOverride)
    local handler = self.DFStateHandler
    UnregisterStateDriver(handler, 'vis')

    local driverTable = {}

    if state.EditModeActive then table.insert(driverTable, 'show') end
    if activateOverride ~= nil then
        if not activateOverride then table.insert(driverTable, 'hide') end
    else
        if state.activate ~= nil and not state.activate then table.insert(driverTable, 'hide') end
    end

    if state.hideCustom then
        table.insert(driverTable, state.hideCustomCond)
    else
        for k, v in pairs(visConditionalTable) do
            if state[k] then
                if k == 'hideStance' then
                    for i = 1, 6 do table.insert(driverTable, ('[stance:%d]hide'):format(i)) end
                else
                    table.insert(driverTable, visConditionalTable[k])
                end
            end
        end
        table.insert(driverTable, 'show')
    end

    local driver = table.concat(driverTable, ';')
    local result, target = SecureCmdOptionParse(driver)
    -- DevTools_Dump(driver)
    if #driverTable > 1 or state.hideCustom then
        --
        -- print(self:GetName(), driver)
        -- print('result:', result)
    end
    RegisterStateDriver(handler, 'vis', driver)
    handler:SetAttribute('state-vis', 'hide')
    handler:SetAttribute('state-vis', 'show')
    handler:SetAttribute('state-vis', result)

    local mouseHandler = self.DFMouseHandler
    if state.showMouseover and not state.EditModeActive and not (state.activate ~= nil and not state.activate) then
        mouseHandler:Show()
    else
        mouseHandler:Hide()
    end
end

function DragonflightUIStateHandlerMixin:AddStateTable(Module, optionTable, sub, displayName, getDefaultStr)
    local popupName = sub and (sub .. "CustomVisCondition") or (displayName .. "CustomVisCondition")

    local macroOptions = [[
        This option evaluates macro conditionals, which have to return '|cff8080ffshow|r' or '|cff8080ffhide|r', e.g.:

        1) |cff8080ff[@target,exists]show; hide|r
        2) |cff8080ff[@target,exists,help,raid] show; hide|r
        3) |cff8080ff[swimming] hide; show|r

        For more Infos see:
            |cff8080ff https://warcraft.wiki.gg/wiki/Macro_conditionals|r
        ]]

    local Validate = function(t)
        local result, target = SecureCmdOptionParse(t)
        if result ~= 'show' and result ~= 'hide' and result ~= '' then
            Module:Print('|cFFFF0000Error: Custom Condition for ' .. displayName .. ' does not return ' ..
                             [['show' or 'hide'!|r]])
            return
        end

        -- valid
        Module:Print('Set Custom Condition for ' .. displayName .. ': \'' .. t .. '\'')
        Module:Print('Current Value: ' .. result)

        -- valid, reset
        return true, true;
    end

    StaticPopupDialogs[popupName] = {
        text = 'Set Custom Condition for ' .. displayName .. '\n\n' .. macroOptions,
        button1 = ACCEPT,
        button2 = CANCEL,
        OnShow = function(self, data)
            local db = Module.db.profile
            local dbSub = sub and db[sub] or db

            self.editBox:SetText(dbSub.hideCustomCond)
        end,
        OnAccept = function(self, data, data2)
            local text = self.editBox:GetText()
            local result, target = SecureCmdOptionParse(text)
            if result ~= 'show' and result ~= 'hide' and result ~= '' then
                Module:Print('|cFFFF0000Error: Custom Condition for ' .. displayName .. ' does not return ' ..
                                 [['show' or 'hide'!|r]])
                return
            end
            -- do whatever you want with it      
            if sub then
                Module:SetOption({sub, 'hideCustomCond'}, text)
            else
                Module:SetOption({'hideCustomCond'}, text)
            end
            Module:Print('Set Custom Condition for ' .. displayName .. ': \'' .. text .. '\'')
            Module:Print('Current Value: ' .. result)
        end,
        hasEditBox = true,
        editBoxWidth = 666
    }

    local function cond(str)
        return 'macro condition: ' .. '|cff8080ff' .. str .. '|r'
    end

    local extraOptions = {
        headerVis = {type = 'header', name = 'Visibility', desc = '', order = 100, isExpanded = true, editmode = true},
        showMouseover = {
            type = 'toggle',
            name = 'Show On Mouseover',
            desc = 'This (temporarily) overrides the hide conditions below when mouseover.' ..
                getDefaultStr('showMouseover', sub),
            order = 100.5,
            group = 'headerVis',
            new = false,
            editmode = true
        },
        hideAlways = {
            type = 'toggle',
            name = 'Always Hide',
            desc = '' .. cond('hide') .. getDefaultStr('hideAlways', sub),
            order = 101,
            group = 'headerVis',
            new = false,
            editmode = true
        },
        hideCombat = {
            type = 'toggle',
            name = 'Hide In Combat',
            desc = '' .. cond('[combat]hide; show') .. getDefaultStr('hideCombat', sub),
            order = 102,
            group = 'headerVis',
            new = false,
            editmode = true
        },
        hideOutOfCombat = {
            type = 'toggle',
            name = 'Hide Out Of Combat',
            desc = '' .. cond('[nocombat]hide; show') .. getDefaultStr('hideOutOfCombat', sub),
            order = 103,
            group = 'headerVis',
            new = false,
            editmode = true
        },
        hidePet = {
            type = 'toggle',
            name = 'Hide With Pet',
            desc = '' .. cond('[pet]hide; show') .. getDefaultStr('hidePet', sub),
            order = 104,
            group = 'headerVis',
            new = false,
            editmode = true
        },
        hideNoPet = {
            type = 'toggle',
            name = 'Hide Without Pet',
            desc = '' .. cond('[nopet]hide; show') .. getDefaultStr('hideNoPet', sub),
            order = 105,
            group = 'headerVis',
            new = false,
            editmode = true
        },
        hideStance = {
            type = 'toggle',
            name = 'Hide Without Stance/Form',
            desc = '' .. cond('[stance:X]hide; show') .. ' (X=1..6)' .. getDefaultStr('hideStance', sub),
            order = 106,
            group = 'headerVis',
            new = false,
            editmode = true
        },
        hideStealth = {
            type = 'toggle',
            name = 'Hide In Stealth',
            desc = '' .. cond('[stealth]hide; show') .. getDefaultStr('hideStealth', sub),
            order = 107,
            group = 'headerVis',
            new = false,
            editmode = true
        },
        hideNoStealth = {
            type = 'toggle',
            name = 'Hide Outside Stealth',
            desc = '' .. cond('[nostealth]hide; show') .. getDefaultStr('hideNoStealth', sub),
            order = 108,
            group = 'headerVis',
            new = false,
            editmode = true
        },
        hideBattlePet = {
            type = 'toggle',
            name = 'Hide In Pet Battle',
            desc = '' .. cond('[petbattle]hide; show') .. getDefaultStr('hideBattlePet', sub),
            order = 108.5,
            group = 'headerVis',
            new = true,
            editmode = true
        },
        hideCustom = {
            type = 'toggle',
            name = 'Use Custom Condition',
            desc = 'Same syntax as macro conditionals\n|cFFFF0000Note: This will disable all of the above settings!|r' ..
                getDefaultStr('hideCustom', sub),
            order = 109,
            group = 'headerVis',
            new = false,
            editmode = true
        },
        hideCustomCond = {
            type = 'editbox',
            name = 'Set Custom Condition',
            Validate = Validate,
            order = 109.5,
            group = 'headerVis',
            editmode = true
        }
    }

    for k, v in pairs(extraOptions) do
        --
        optionTable.args[k] = v
    end
end
