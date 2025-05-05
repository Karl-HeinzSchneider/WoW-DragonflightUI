local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

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

            local first = frame:CreateTexture('DragonflightUIWhatsTrainingCompatibilitySpellBookPage1', 'BACKGROUND')
            first:SetTexture(base .. 'Spellbook-Page-1')
            first:SetPoint('TOPLEFT', frame, 'TOPLEFT', 7, -25)
            first:SetDrawLayer('BACKGROUND', -1)

            local second = frame:CreateTexture('DragonflightUIWhatsTrainingCompatibilitySpellBookPage2', 'BACKGROUND')
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
