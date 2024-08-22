local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
DragonflightUIStateHandlerMixin = {}

function DragonflightUIStateHandlerMixin:InitStateHandler()
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
    local extraBorder = 2
    ----------
    local shower = CreateFrame('FRAME', self:GetName() .. 'Shower', nil, 'SecureHandlerShowHideTemplate')
    shower:SetPoint('TOPLEFT', self, 'TOPLEFT', -extraBorder, extraBorder)
    shower:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', extraBorder, -extraBorder)

    shower:SetFrameRef('MainHandler', handler)

    handler:SetFrameRef('Shower', shower)

    shower:SetAttribute('_onshow', [[   
        local frameRef = self:GetFrameRef("MainHandler")

        for i=1,12 do
            local btn = frameRef:GetFrameRef('Btn'..i)
            if btn then btn:Show() end
        end

        local mainbarFrame = frameRef:GetFrameRef('mainbarFrame')
        if mainbarFrame then mainbarFrame:Show() end
    ]])

    shower:SetAttribute('_onhide', [[     
         local frameRef = self:GetFrameRef("MainHandler")

        for i=1,12 do
            local btn = frameRef:GetFrameRef('Btn'..i)
            if btn then btn:Hide() end
        end

        local mainbarFrame = frameRef:GetFrameRef('mainbarFrame')
        if mainbarFrame then mainbarFrame:Hide() end
    ]])

    ----------
    local handlerTwo = CreateFrame('FRAME', self:GetName() .. 'HandlerOnEnterLeave', nil,
                                   'SecureHandlerEnterLeaveTemplate')
    handlerTwo:SetPoint('TOPLEFT', self, 'TOPLEFT', -extraBorder, extraBorder)
    handlerTwo:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', extraBorder, -extraBorder)
    handlerTwo:SetFrameLevel(2)

    handlerTwo:SetFrameRef('MainHandler', handler)
    handlerTwo:SetFrameRef('Shower', shower)

    frame.DFMouseHandler = handlerTwo

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
end

function DragonflightUIStateHandlerMixin:UpdateStateHandler(state)
    local handler = self.DFStateHandler
    UnregisterStateDriver(handler, 'vis')

    local driverTable = {}

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
    if state.showMouseover then
        mouseHandler:Show()
    else
        mouseHandler:Hide()
    end
end
