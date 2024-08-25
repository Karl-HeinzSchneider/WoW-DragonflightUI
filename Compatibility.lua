---@class DragonflightUI
---@diagnostic disable-next-line: assign-type-mismatch
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
DF.Compatibility = {}

function DF.Compatibility:FuncOrWaitframe(addon, func)
    local checkAddonFunc = C_AddOns.IsAddOnLoaded
    if checkAddonFunc(addon) then
        -- print('Module:FuncOrWaitframe(addon,func)', addon, 'ISLOADED')
        func()
    else
        local waitFrame = CreateFrame("FRAME")
        waitFrame:RegisterEvent("ADDON_LOADED")
        waitFrame:SetScript("OnEvent", function(self, event, arg1)
            if arg1 == addon then
                -- print('Module:FuncOrWaitframe(addon,func)', addon, 'WAITFRAME')
                func()
                waitFrame:UnregisterAllEvents()
            end
        end)
    end
end

local novaLoaded = C_AddOns.IsAddOnLoaded('NovaWorldBuffs')
-- print('Nova loaded: ', novaLoaded)
if novaLoaded then if _G['MinimapLayerFrame'] then _G['MinimapLayerFrame']:SetPoint('BOTTOM', 0, 4) end end

function DF.Compatibility:AuctionatorCraftingInfoFrame()
    -- print('DF.Compatibility:AuctionatorCraftingInfoFrame()')

    hooksecurefunc(Auctionator.CraftingInfo, 'Initialize', function()
        --
        -- print('Auctionator.CraftingInfo:Initialize()')

        local auctionCraftingFrame = _G['AuctionatorCraftingInfo']
        if not auctionCraftingFrame then
            -- print('no frame!')
            return
        end

        if auctionCraftingFrame.DFHooked == true then return end
        auctionCraftingFrame.DFHooked = true

        local prof = _G['DragonflightUIProfessionFrame']
        auctionCraftingFrame:SetParent(prof)

        local fixFrame = function()
            -- print('fixFrame')
            local first = TradeSkillDescription or TradeSkillReagentLabel

            auctionCraftingFrame:ClearAllPoints()
            auctionCraftingFrame:SetPoint('TOPLEFT', TradeSkillSkillIcon, 'BOTTOMLEFT', -1, -12)

            first:ClearAllPoints()
            first:SetPoint('TOPLEFT', TradeSkillSkillIcon, 'BOTTOMLEFT', -1, -48)
        end

        hooksecurefunc(auctionCraftingFrame, 'ShowIfRelevant', function()
            --
            -- print('ShowIfRelevant')
            fixFrame()
        end)
        hooksecurefunc(auctionCraftingFrame, 'UpdateTotal', function()
            --
            -- print('UpdateTotal')
            fixFrame()
        end)
        prof:HookScript('OnShow', function()
            --
            -- print('OnShow')
            fixFrame()
        end)
        fixFrame()
    end)
end

function DF.Compatibility:TacoTipCharacter()
    local text = _G['PersonalGearScoreText']
    text:ClearAllPoints()
    text:SetPoint('BOTTOMLEFT', CharacterModelFrame, 'BOTTOMLEFT', 10, 30)

    local score = _G['PersonalGearScore']
    score:ClearAllPoints()
    score:SetPoint('BOTTOMLEFT', text, 'TOPLEFT', 0, 2)

    local itemlvltext = _G['PersonalAvgItemLvlText']
    itemlvltext:ClearAllPoints()
    itemlvltext:SetPoint('BOTTOMRIGHT', CharacterModelFrame, 'BOTTOMRIGHT', -10, 30)

    local itemlvl = _G['PersonalAvgItemLvl']
    itemlvl:ClearAllPoints()
    itemlvl:SetPoint('BOTTOMRIGHT', itemlvltext, 'TOPRIGHT', 0, 2)
end

function DF.Compatibility:TacoTipInspect()
    local text = _G['InspectGearScoreText']
    text:ClearAllPoints()
    text:SetPoint('BOTTOMLEFT', InspectModelFrame, 'BOTTOMLEFT', 10, 30)

    local score = _G['InspectGearScore']
    score:ClearAllPoints()
    score:SetPoint('BOTTOMLEFT', text, 'TOPLEFT', 0, 2)

    local itemlvltext = _G['InspectAvgItemLvlText']
    itemlvltext:ClearAllPoints()
    itemlvltext:SetPoint('BOTTOMRIGHT', InspectModelFrame, 'BOTTOMRIGHT', -10, 30)

    local itemlvl = _G['InspectAvgItemLvl']
    itemlvl:ClearAllPoints()
    itemlvl:SetPoint('BOTTOMRIGHT', itemlvltext, 'TOPRIGHT', 0, 2)
end

function DF.Compatibility:LFGBulletinBoard(func)
    -- related issues: #235, Vysci/LFG-Bulletin-Board#301
    local btn = _G['LFGBulletinBoardMinimapButton'] or _G['Lib_GPI_Minimap_LFGBulletinBoard']
    if not btn then return end
    func(btn)
end

if DF.Era then
    function DF.Compatibility:ClassicCalendarEra()
        -- print('DF.Compatibility:ClassicCalendarEra()')

        local btn = _G['CalendarButtonFrame']
        btn:ClearAllPoints()
        btn:SetPoint('BOTTOMLEFT', UIParent, 'TOPRIGHT', 69, 69)
        btn:Hide()

        local frame = _G['CalendarFrame']
        local DFBtn = _G['DragonflightUICalendarButton']

        DFBtn:SetScript('OnClick', function()
            -- print('override!')
            CalendarButtonFrame_OnClick(btn)
        end)
    end

    function DF.Compatibility:CharacterStatsClassic()
        -- print('DF.Compatibility:CharacterStatsClassic()')
        local children = {CharacterFrame:GetChildren()}

        for k, child in ipairs(children) do
            --
            -- print('children:', k, child:GetName())

            if child:GetName() == nil then
                -- maybe CharacterStatsClassic
                --[[        local point, relativeTo, relativePoint, xOfs, yOfs = child:GetPoint(1)
                print(point, relativeTo, relativePoint, xOfs, yOfs)
                if (point == 'LEFT') and (relativeTo == CharacterFrame) and (relativePoint == 'BOTTOMLEFT') and
                    (xOfs == 50) and (yOfs == 75) then
                    --
                    print('CharacterStatsClassic found!')
                end ]]
                if (child.leftStatsDropDown) and (child.rightStatsDropDown) then
                    --
                    -- print('CharacterStatsClassic found by dropdown')
                    -- SetPoint("LEFT", CharacterFrame, "BOTTOMLEFT", 50, 75); --85 for 6 stats
                    child:SetPoint('LEFT', CharacterFrame, 'BOTTOMLEFT', 50 - 15, 75 - 80)
                end
            end

        end
    end

    function DF.Compatibility:WhatsTraining()
        -- print('DF.Compatibility:WhatsTraining()')

        local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

        hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", function()
            local frame = _G['WhatsTrainingFrame']
            if frame and frame.DFHooked then return end

            frame.DFHooked = true

            local regions = {frame:GetRegions()}

            local LEFT_BG_TEXTURE_FILEID = GetFileIDFromPath("Interface\\AddOns\\WhatsTraining\\left")
            local RIGHT_BG_TEXTURE_FILEID = GetFileIDFromPath("Interface\\AddOns\\WhatsTraining\\right")

            for k, child in ipairs(regions) do
                --     
                if child:GetObjectType() == 'Texture' then
                    local layer, layerNr = child:GetDrawLayer()
                    -- print(layer, layerNr, child:GetTexture())
                    if layer == 'ARTWORK' then
                        --
                    end

                    local tex = child:GetTexture()

                    if tex == LEFT_BG_TEXTURE_FILEID then
                        child:SetPoint('TOPLEFT', frame, 'TOPLEFT', 167, 0)
                    elseif tex == RIGHT_BG_TEXTURE_FILEID then
                    end
                end
            end

            do
                local port = frame:CreateTexture('DragonflightUIWhatsTrainingCompatibilityPortrait')
                port:SetSize(62, 62)
                port:ClearAllPoints()
                port:SetPoint('TOPLEFT', frame, 'TOPLEFT', -5, 7)
                port:SetParent(frame)
                port:SetTexture(136830)
                SetPortraitToTexture(port, port:GetTexture())
                port:SetDrawLayer('OVERLAY', 6)
                port:Show()

                frame.PortraitFrame = frame:CreateTexture('DragonflightUIWhatsTrainingCompatibilityPortraitFrame')
                local pp = frame.PortraitFrame
                pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
                pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
                pp:SetSize(84, 84)
                pp:ClearAllPoints()
                pp:SetPoint('CENTER', port, 'CENTER', 0, 0)
                pp:SetDrawLayer('OVERLAY', 7)
                -- pp:SetFrameLevel(4)
            end

            do
                --
                local inset = CreateFrame('FRAME', 'DragonflightUIWhatsTrainingCompatibilitySpellBookInset', frame,
                                          'InsetFrameTemplate')
                inset:SetPoint('TOPLEFT', frame, 'TOPLEFT', 4, -24)
                inset:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -6, 4)
                inset:SetFrameLevel(1)

                local first =
                    frame:CreateTexture('DragonflightUIWhatsTrainingCompatibilitySpellBookPage1', 'BACKGROUND')
                first:SetTexture(base .. 'Spellbook-Page-1')
                first:SetPoint('TOPLEFT', frame, 'TOPLEFT', 7, -25)
                first:SetDrawLayer('BACKGROUND', -1)

                local second = frame:CreateTexture('DragonflightUIWhatsTrainingCompatibilitySpellBookPage2',
                                                   'BACKGROUND')
                second:SetTexture(base .. 'Spellbook-Page-2')
                second:SetPoint('TOPLEFT', first, 'TOPRIGHT', 0, 0)

                local bg = frame:CreateTexture('DragonflightUIWhatsTrainingCompatibilitySpellBookBG', 'BACKGROUND')
                bg:SetTexture(base .. 'UI-Background-RockCata')
                bg:SetPoint('TOPLEFT', frame, 'TOPLEFT', 2, -21)
                bg:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -2, 2)
                bg:SetDrawLayer('BACKGROUND', -6)
                -- TODO: bugged?
                -- bg:SetVertTile(true) 
                -- bg:SetHorizTile(true)
            end

            local rowOne = _G['WhatsTrainingFrameRow1']
            rowOne:SetPoint('TOPLEFT', frame, 'TOPLEFT', 195, -78)

            local scroll = _G['WhatsTrainingFrameScrollBar']
            -- scroll:SetPoint('TOPLEFT', frame, 'TOPLEFT', 120, -75)
            -- scroll:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -65, 81)
        end)
    end
end
