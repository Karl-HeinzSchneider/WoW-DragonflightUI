local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

DragonflightUIMicromenuMixin = {}

function DragonflightUIMicromenuMixin:OnLoad()
    print('DragonflightUIMicromenuMixin:OnLoad()')
    self.MicroButtons = {}
    self:SetFrameLevel(3)

    table.insert(self.MicroButtons, 1, self:CreateCharacterButton())

    if DF.Era then
    elseif DF.Cata then
        table.insert(self.MicroButtons, self:CreateButton('SpellbookMicroButton'))
        table.insert(self.MicroButtons, self:CreateButton('TalentMicroButton'))
        table.insert(self.MicroButtons, self:CreateButton('AchievementMicroButton'))
        table.insert(self.MicroButtons, self:CreateButton('QuestLogMicroButton'))
        table.insert(self.MicroButtons, self:CreateButton('GuildMicroButton'))
        table.insert(self.MicroButtons, self:CreateButton('CollectionsMicroButton'))
        table.insert(self.MicroButtons, self:CreateButton('PVPMicroButton'))
        table.insert(self.MicroButtons, self:CreateButton('LFGMicroButton'))
        table.insert(self.MicroButtons, self:CreateButton('EJMicroButton'))
        table.insert(self.MicroButtons, self:CreateButton('MainMenuMicroButton'))
        table.insert(self.MicroButtons, self:CreateButton('HelpMicroButton'))
    elseif DF.Wrath then
    end

    local dx, dy = -3, 0;

    -- character = always
    self.MicroButtons[1]:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)

    local numBtn = #self.MicroButtons;
    for k = 2, numBtn do
        -- 
        local btn = self.MicroButtons[k];
        btn:SetPoint('TOPLEFT', self.MicroButtons[k - 1], 'TOPRIGHT', dx, dy)
    end
end

function DragonflightUIMicromenuMixin:CreateCharacterButton()
    print('DragonflightUIMicromenuMixin:CreateCharacterButton()')

    local btn = CreateFrame('Button', 'DragonflightUICharacterMicroButton', self,
                            'DragonflightUIMicroButtonTemplate, SecureActionButtonTemplate')

    return btn;
end

function DragonflightUIMicromenuMixin:CreateButton(name)
    print('DragonflightUIMicromenuMixin:CreateButton()', name)
    local frame = CreateFrame('Button', 'DragonflightUI' .. name, self, 'DragonflightUI' .. name)
    return frame
end

--------------------
--- Buttons
-------------------- 

DragonflightUIMicromenuButtonMixin = {}

function DragonflightUIMicromenuButtonMixin:OnEvent()
    -- print('DragonflightUIMicromenuButtonMixin:OnEvent()', self:GetName())
end

function DragonflightUIMicromenuButtonMixin:OnEnter(self)
    -- print('DragonflightUIMicromenuButtonMixin:OnEnter()', self:GetName())
    if (self:IsEnabled() or self.minLevel or self.disabledTooltip or self.factionGroup) then
        GameTooltip_AddNewbieTip(self, self.tooltipText, 1.0, 1.0, 1.0, self.newbieText);
        if (not self:IsEnabled()) then
            if (self.factionGroup == "Neutral") then
                GameTooltip:AddLine(FEATURE_NOT_AVAILBLE_PANDAREN, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b,
                                    true);
                GameTooltip:Show();
            elseif (self.minLevel) then
                GameTooltip:AddLine(format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, self.minLevel), RED_FONT_COLOR.r,
                                    RED_FONT_COLOR.g, RED_FONT_COLOR.b, true);
                GameTooltip:Show();
            elseif (self.disabledTooltip) then
                GameTooltip:AddLine(self.disabledTooltip, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true);
                GameTooltip:Show();
            end
        end
    end
end

-- microTexture
local microTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\Micromenu\\uimicromenu2x'
if DF.Era then microTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\Micromenu\\uimicromenu2xERA' end
function DragonflightUIMicromenuButtonMixin:UpdateStyle()
    self:SetFrameLevel(5)
    local frame = self;

    -- Style
    local pre = 'UI-HUD-MicroMenu-'
    local key = pre .. self.atlas
    local up = DragonflightUIMicromenuButtonMixin.MicromenuAtlas[key .. '-Up']

    local sizeX, sizeY = 32, 40
    frame:SetSize(sizeX, sizeY)
    frame:SetHitRectInsets(0, 0, 0, 0)

    frame:SetNormalTexture(microTexture)
    frame:GetNormalTexture():SetTexCoord(up[3], up[4], up[5], up[6])

    local disabled = DragonflightUIMicromenuButtonMixin.MicromenuAtlas[key .. '-Disabled']
    frame:SetDisabledTexture(microTexture)
    frame:GetDisabledTexture():SetTexCoord(disabled[3], disabled[4], disabled[5], disabled[6])

    local down = DragonflightUIMicromenuButtonMixin.MicromenuAtlas[key .. '-Down']
    frame:SetPushedTexture(microTexture)
    frame:GetPushedTexture():SetTexCoord(down[3], down[4], down[5], down[6])

    local mouseover = DragonflightUIMicromenuButtonMixin.MicromenuAtlas[key .. '-Mouseover']
    frame:SetHighlightTexture(microTexture)
    frame:GetHighlightTexture():SetTexCoord(mouseover[3], mouseover[4], mouseover[5], mouseover[6])
    frame:GetHighlightTexture():SetSize(sizeX, sizeY)

    -- add missing background
    local dx, dy = -1, 1
    local offX, offY = frame:GetPushedTextOffset()

    -- ["UI-HUD-MicroMenu-ButtonBG-Down"]={32, 41, 0.0654297, 0.12793, 0.330078, 0.490234, false, false, "1x"},
    local bg = frame:CreateTexture('Background', 'BACKGROUND')
    bg:SetTexture(microTexture)
    bg:SetSize(sizeX, sizeY + 1)
    bg:SetTexCoord(0.0654297, 0.12793, 0.330078, 0.490234)
    bg:SetPoint('CENTER', dx, dy)
    frame.Background = bg

    --	["UI-HUD-MicroMenu-ButtonBG-Up"]={32, 41, 0.0654297, 0.12793, 0.494141, 0.654297, false, false, "1x"},
    local bgPushed = frame:CreateTexture('Background', 'BACKGROUND')
    bgPushed:SetTexture(microTexture)
    bgPushed:SetSize(sizeX, sizeY + 1)
    bgPushed:SetTexCoord(0.0654297, 0.12793, 0.494141, 0.654297)
    bgPushed:SetPoint('CENTER', dx + offX, dy + offY)
    bgPushed:Hide()
    frame.BackgroundPushed = bgPushed

    frame.dfState = {}
    frame.dfState.pushed = false
    frame.dfState.highlight = false

    frame.HandleState = function()
        -- DF:Dump(frame.dfState)
        local state = frame.dfState

        if state.pushed then
            frame.Background:Hide()
            frame.BackgroundPushed:Show()
            frame:GetHighlightTexture():ClearAllPoints()
            frame:GetHighlightTexture():SetPoint('CENTER', offX, offY)
        else
            frame.Background:Show()
            frame.BackgroundPushed:Hide()
            frame:GetHighlightTexture():ClearAllPoints()

            frame:GetHighlightTexture():SetPoint('CENTER', 0, 0)
        end
    end
    frame.HandleState()

    frame:GetNormalTexture():HookScript('OnShow', function(self)
        -- frame.Background:Show()
        frame.dfState.pushed = false
        frame.HandleState()
    end)

    --[[   frame:GetNormalTexture():HookScript('OnHide', function(self)
         frame.Background:Hide()
         frame.dfState.pushed = true
         frame.HandleState()
     end)    ]]

    frame:GetPushedTexture():HookScript('OnShow', function(self)
        -- frame.BackgroundPushed:Show()
        frame.dfState.pushed = true
        frame.HandleState()
    end)

    --[[   frame:GetPushedTexture():HookScript('OnHide', function(self)
         frame.BackgroundPushed:Hide()
         frame.dfState.pushed = false
         frame.HandleState()
     end)  ]]

    frame:HookScript('OnEnter', function(self)
        -- frame.Background:Show()
        frame.dfState.highlight = true
        frame.HandleState()
    end)

    frame:HookScript('OnLeave', function(self)
        -- frame.Background:Show()
        frame.dfState.highlight = false
        frame.HandleState()
    end)

    -- flash
    local flash = _G[frame:GetName() .. 'Flash']
    if flash then
        -- print(flash:GetName())
        flash:SetSize(sizeX, sizeY)
        flash:SetTexture(microTexture)
        flash:SetTexCoord(0.323242, 0.385742, 0.00195312, 0.162109)
        flash:ClearAllPoints()
        flash:SetPoint('CENTER', 0, 0)
    end

    if self:GetName() == 'DragonflightUI' .. 'PVPMicroButton' then
        local tex = 'Interface\\Addons\\DragonflightUI\\Textures\\Micromenu\\micropvp'

        local englishFaction, localizedFaction = UnitFactionGroup('player')

        if englishFaction == 'Alliance' then
            self:SetNormalTexture(tex)
            self:GetNormalTexture():SetTexCoord(0, 118 / 256, 0, 151 / 256)

            self:SetDisabledTexture(tex)
            self:GetDisabledTexture():SetTexCoord(0, 118 / 256, 0, 151 / 256)

            self:SetPushedTexture(tex)
            self:GetPushedTexture():SetTexCoord(0, 118 / 256, 0, 151 / 256)

            self:SetHighlightTexture(tex)
            self:GetHighlightTexture():SetTexCoord(0, 118 / 256, 0, 151 / 256)
        else
            self:SetNormalTexture(tex)
            self:GetNormalTexture():SetTexCoord(118 / 256, 236 / 256, 0, 151 / 256)

            self:SetDisabledTexture(tex)
            self:GetDisabledTexture():SetTexCoord(118 / 256, 236 / 256, 0, 151 / 256)

            self:SetPushedTexture(tex)
            self:GetPushedTexture():SetTexCoord(118 / 256, 236 / 256, 0, 151 / 256)

            self:SetHighlightTexture(tex)
            self:GetHighlightTexture():SetTexCoord(118 / 256, 236 / 256, 0, 151 / 256)
        end
    end
end

DragonflightUIMicromenuButtonMixin.MicromenuAtlas = {
    ["UI-HUD-MicroMenu-Achievements-Disabled"] = {
        16, 20, 0.000976562, 0.0634766, 0.00195312, 0.162109, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-Achievements-Down"] = {16, 20, 0.000976562, 0.0634766, 0.166016, 0.326172, false, false, "2x"},
    ["UI-HUD-MicroMenu-Achievements-Mouseover"] = {
        16, 20, 0.000976562, 0.0634766, 0.330078, 0.490234, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-Achievements-Up"] = {16, 20, 0.000976562, 0.0634766, 0.494141, 0.654297, false, false, "2x"},
    ["UI-HUD-MicroMenu-AdventureGuide-Disabled"] = {
        16, 20, 0.000976562, 0.0634766, 0.658203, 0.818359, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-AdventureGuide-Down"] = {16, 20, 0.000976562, 0.0634766, 0.822266, 0.982422, false, false, "2x"},
    ["UI-HUD-MicroMenu-AdventureGuide-Mouseover"] = {
        16, 20, 0.0654297, 0.12793, 0.00195312, 0.162109, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-AdventureGuide-Up"] = {16, 20, 0.0654297, 0.12793, 0.166016, 0.326172, false, false, "2x"},
    ["UI-HUD-MicroMenu-Collections-Disabled"] = {16, 20, 0.0654297, 0.12793, 0.658203, 0.818359, false, false, "2x"},
    ["UI-HUD-MicroMenu-Collections-Down"] = {16, 20, 0.0654297, 0.12793, 0.822266, 0.982422, false, false, "2x"},
    ["UI-HUD-MicroMenu-Collections-Mouseover"] = {16, 20, 0.129883, 0.192383, 0.00195312, 0.162109, false, false, "2x"},
    ["UI-HUD-MicroMenu-Collections-Up"] = {16, 20, 0.129883, 0.192383, 0.166016, 0.326172, false, false, "2x"},
    ["UI-HUD-MicroMenu-Communities-Icon-Notification"] = {
        7, 7, 0.581055, 0.608398, 0.166016, 0.220703, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-GameMenu-Disabled"] = {16, 20, 0.129883, 0.192383, 0.330078, 0.490234, false, false, "2x"},
    ["UI-HUD-MicroMenu-GameMenu-Down"] = {16, 20, 0.129883, 0.192383, 0.494141, 0.654297, false, false, "2x"},
    ["UI-HUD-MicroMenu-GameMenu-Mouseover"] = {16, 20, 0.129883, 0.192383, 0.658203, 0.818359, false, false, "2x"},
    ["UI-HUD-MicroMenu-GameMenu-Up"] = {16, 20, 0.129883, 0.192383, 0.822266, 0.982422, false, false, "2x"},
    ["UI-HUD-MicroMenu-Groupfinder-Disabled"] = {16, 20, 0.194336, 0.256836, 0.00195312, 0.162109, false, false, "2x"},
    ["UI-HUD-MicroMenu-Groupfinder-Down"] = {16, 20, 0.194336, 0.256836, 0.166016, 0.326172, false, false, "2x"},
    ["UI-HUD-MicroMenu-Groupfinder-Mouseover"] = {16, 20, 0.194336, 0.256836, 0.330078, 0.490234, false, false, "2x"},
    ["UI-HUD-MicroMenu-Groupfinder-Up"] = {16, 20, 0.194336, 0.256836, 0.494141, 0.654297, false, false, "2x"},
    ["UI-HUD-MicroMenu-GuildCommunities-Disabled"] = {
        16, 20, 0.194336, 0.256836, 0.658203, 0.818359, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-GuildCommunities-Down"] = {16, 20, 0.194336, 0.256836, 0.822266, 0.982422, false, false, "2x"},
    ["UI-HUD-MicroMenu-GuildCommunities-Mouseover"] = {
        16, 20, 0.258789, 0.321289, 0.658203, 0.818359, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-GuildCommunities-Up"] = {16, 20, 0.258789, 0.321289, 0.822266, 0.982422, false, false, "2x"},
    ["UI-HUD-MicroMenu-Highlightalert"] = {16, 20, 0.323242, 0.385742, 0.00195312, 0.162109, false, false, "2x"},
    ["UI-HUD-MicroMenu-Questlog-Disabled"] = {16, 20, 0.323242, 0.385742, 0.494141, 0.654297, false, false, "2x"},
    ["UI-HUD-MicroMenu-Questlog-Down"] = {16, 20, 0.323242, 0.385742, 0.658203, 0.818359, false, false, "2x"},
    ["UI-HUD-MicroMenu-Questlog-Mouseover"] = {16, 20, 0.323242, 0.385742, 0.822266, 0.982422, false, false, "2x"},
    ["UI-HUD-MicroMenu-Questlog-Up"] = {16, 20, 0.387695, 0.450195, 0.00195312, 0.162109, false, false, "2x"},
    ["UI-HUD-MicroMenu-Shop-Disabled"] = {16, 20, 0.387695, 0.450195, 0.166016, 0.326172, false, false, "2x"},
    ["UI-HUD-MicroMenu-Shop-Mouseover"] = {16, 20, 0.387695, 0.450195, 0.330078, 0.490234, false, false, "2x"},
    ["UI-HUD-MicroMenu-Shop-Down"] = {16, 20, 0.387695, 0.450195, 0.494141, 0.654297, false, false, "2x"},
    ["UI-HUD-MicroMenu-Shop-Up"] = {16, 20, 0.387695, 0.450195, 0.658203, 0.818359, false, false, "2x"},
    ["UI-HUD-MicroMenu-SpecTalents-Disabled"] = {16, 20, 0.387695, 0.450195, 0.822266, 0.982422, false, false, "2x"},
    ["UI-HUD-MicroMenu-SpecTalents-Down"] = {16, 20, 0.452148, 0.514648, 0.00195312, 0.162109, false, false, "2x"},
    ["UI-HUD-MicroMenu-SpecTalents-Mouseover"] = {16, 20, 0.452148, 0.514648, 0.166016, 0.326172, false, false, "2x"},
    ["UI-HUD-MicroMenu-SpecTalents-Up"] = {16, 20, 0.452148, 0.514648, 0.330078, 0.490234, false, false, "2x"},
    ["UI-HUD-MicroMenu-SpellbookAbilities-Disabled"] = {
        16, 20, 0.452148, 0.514648, 0.494141, 0.654297, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-SpellbookAbilities-Down"] = {16, 20, 0.452148, 0.514648, 0.658203, 0.818359, false, false, "2x"},
    ["UI-HUD-MicroMenu-SpellbookAbilities-Mouseover"] = {
        16, 20, 0.452148, 0.514648, 0.822266, 0.982422, false, false, "2x"
    },
    ["UI-HUD-MicroMenu-SpellbookAbilities-Up"] = {16, 20, 0.516602, 0.579102, 0.00195312, 0.162109, false, false, "2x"},
    ["UI-HUD-MicroMenu-StreamDLGreen-Down"] = {16, 20, 0.516602, 0.579102, 0.166016, 0.326172, false, false, "2x"},
    ["UI-HUD-MicroMenu-StreamDLGreen-Up"] = {16, 20, 0.516602, 0.579102, 0.330078, 0.490234, false, false, "2x"},
    ["UI-HUD-MicroMenu-StreamDLRed-Down"] = {16, 20, 0.516602, 0.579102, 0.494141, 0.654297, false, false, "2x"},
    ["UI-HUD-MicroMenu-StreamDLRed-Up"] = {16, 20, 0.516602, 0.579102, 0.658203, 0.818359, false, false, "2x"},
    ["UI-HUD-MicroMenu-StreamDLYellow-Down"] = {16, 20, 0.516602, 0.579102, 0.822266, 0.982422, false, false, "2x"},
    ["UI-HUD-MicroMenu-StreamDLYellow-Up"] = {16, 20, 0.581055, 0.643555, 0.00195312, 0.162109, false, false, "2x"},
    ["UI-HUD-MicroMenu-ButtonBG-Down"] = {32, 41, 0.0654297, 0.12793, 0.330078, 0.490234, false, false, "1x"},
    ["UI-HUD-MicroMenu-ButtonBG-Up"] = {32, 41, 0.0654297, 0.12793, 0.494141, 0.654297, false, false, "1x"},
    ["UI-HUD-MicroMenu-Portrait-Shadow-2x"] = {32, 41, 0.323242, 0.385742, 0.330078, 0.490234, false, false, "1x"},
    ["UI-HUD-MicroMenu-Portrait-Down-2x"] = {32, 41, 0.323242, 0.385742, 0.166016, 0.326172, false, false, "1x"},
    ["UI-HUD-MicroMenu-GuildCommunities-GuildColor-Disabled"] = {
        32, 41, 0.258789, 0.321289, 0.00195312, 0.162109, false, false, "1x"
    },
    ["UI-HUD-MicroMenu-GuildCommunities-GuildColor-Down"] = {
        32, 41, 0.258789, 0.321289, 0.166016, 0.326172, false, false, "1x"
    },
    ["UI-HUD-MicroMenu-GuildCommunities-GuildColor-Mouseover"] = {
        32, 41, 0.258789, 0.321289, 0.330078, 0.490234, false, false, "1x"
    },
    ["UI-HUD-MicroMenu-GuildCommunities-GuildColor-Up"] = {
        32, 41, 0.258789, 0.321289, 0.494141, 0.654297, false, false, "1x"
    }
}
