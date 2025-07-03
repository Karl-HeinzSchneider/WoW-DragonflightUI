local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

DragonflightUIMicroMenuMixin = {}

function DragonflightUIMicroMenuMixin:OnLoad()
    -- print('~~DragonflightUIMicroMenuMixin:OnLoad()', self:GetName())

    -- self:SetSize(200, 40)
    -- self:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)

    self.MicroButtons = {}
    self:ChangeButtons()

    if self.MicroButtons[1]:GetParent() == MainMenuBarArtFrame then
        self.ParentByUI = false;
    else
        self.ParentByUI = true
    end

    -- print('~~~~>', self.ParentByUI, '<~~~~')

    self.OriginalAnchors = {}
    for k, v in ipairs(self.MicroButtons) do
        self.OriginalAnchors[k] = {v:GetPoint(1)}
        v:SetFrameLevel(self:GetFrameLevel() + 1)
    end

    local numButtons = #self.MicroButtons;
    if DF.Era then
        -- socials/guild button
        numButtons = numButtons - 1
    elseif DF.Cata then
        -- socials/guild button
        numButtons = numButtons - 1
        -- elseif DF.Wrath and GuildMicroButton then
    elseif DF.Wrath then
        numButtons = numButtons - 1
    end

    local sizeX, sizeY = self.MicroButtons[1]:GetSize()
    local width = (sizeX - 3) * numButtons + 3
    local height = sizeY
    self:SetSize(width, height)

    hooksecurefunc('UpdateMicroButtons', function()
        -- print('#UpdateMicroButtons')
        self:UpdateLayout()
    end)

    hooksecurefunc('UpdateMicroButtonsParent', function(parent)
        -- print('#UpdateMicroButtonsParent')
        self:OnUpdateMicroButtonsParent(parent)
    end)

    -- inside calls UpdateMicroButtons
    -- hooksecurefunc('MoveMicroButtons', function()
    --     -- print('#MoveMicroButtons')
    --     self:UpdateLayout(true)
    -- end)

    hooksecurefunc('ActionBarController_UpdateAll', function(force)
        -- print('#ActionBarController_UpdateAll')
        self:OnActionBarController_UpdateAll()
    end)

    UpdateMicroButtonsParent(self)
end

function DragonflightUIMicroMenuMixin:OnUpdateMicroButtonsParent(parent)
    -- print('OnUpdateMicroButtonsParent() to ', parent:GetName())

    if (not parent) or (parent == UIParent) then
        -- normal
        -- print('~~> normal')
        UpdateMicroButtonsParent(self)
        -- self:UpdateLayout()
    elseif parent == OverrideActionBar then
        -- vehicle etc
        -- print('~~> vehicle')
        self:BlizzardMicroMenuShow()
    elseif parent == PetBattleFrame then
        -- pet battle
        -- print('~~> pet battle')
        self:BlizzardMicroMenuShow()
    elseif parent == self then
        -- custom
        -- print('~~> self')
        self:UpdateLayout(false)
    else
        -- ELSE - should not happen?
        -- print('~~> ELSE')
        UpdateMicroButtonsParent(self)
    end
end

function DragonflightUIMicroMenuMixin:OnActionBarController_UpdateAll()
    -- print('OnActionBarController_UpdateAll()', ActionBarController_GetCurrentActionBarState())
    local abState = ActionBarController_GetCurrentActionBarState();
    if abState == LE_ACTIONBAR_STATE_MAIN and not (C_PetBattles and C_PetBattles.IsInBattle()) then
        self:UpdateLayout()
    end
end

function DragonflightUIMicroMenuMixin:BlizzardMicroMenuShow()
    -- print('BlizzardMicroMenuShow()')
    -- restore anchors
    for k, v in ipairs(self.MicroButtons) do
        if v == CharacterMicroButton or v == PVPMicroButton then
            --
        else
            v:ClearAllPoints()
            v:SetPoint(unpack(self.OriginalAnchors[k]))
        end
    end
end

function DragonflightUIMicroMenuMixin:UpdateLayout(force)
    -- print('UpdateLayout()', #self.MicroButtons)
    local _, relativeTo, _, _, _ = CharacterMicroButton:GetPoint(1)
    if (relativeTo == self) then
        -- print('~> ALREADY SET');
        if not force then
            -- print('~> NO FORCE');
            return;
        end
    end
    -- print('~> set custom anchors')
    -- set custom anchors
    for k, v in ipairs(self.MicroButtons) do
        -- print(k, v:GetName(), v)
        if v == CharacterMicroButton then
            --
            -- print('~~>> CharacterMicroButton')
            v:ClearAllPoints()
            v:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
        else
            v:ClearAllPoints()
            v:SetPoint(unpack(self.OriginalAnchors[k]))
        end
    end
end

function DragonflightUIMicroMenuMixin:UpdateState(state)
    self.State = state
    self:Update()
end

function DragonflightUIMicroMenuMixin:Update()
    local state = self.State

    self:SetClampedToScreen(true)
    self:SetScale(state.scale)
    self:ClearAllPoints()
    self:SetPoint(state.anchor, _G[state.anchorFrame], state.anchorParent, state.x, state.y)

    self:UpdateStateHandler(state)
end

function DragonflightUIMicroMenuMixin:ChangeButtons()
    -- print('~~~~DragonflightUIMicroMenuMixin:ChangeButtons()')
    if DF.API.Version.IsMoP then
        self:ChangeCharacterMicroButton()
        self:ChangeMicroMenuButton(SpellbookMicroButton, 'SpellbookAbilities')
        self:ChangeMicroMenuButton(TalentMicroButton, 'SpecTalents')
        self:ChangeMicroMenuButton(AchievementMicroButton, 'Achievements')
        self:ChangeMicroMenuButton(QuestLogMicroButton, 'Questlog')
        self:ChangeMicroMenuButton(GuildMicroButton, 'GuildCommunities')
        self:ChangeMicroMenuButton(SocialsMicroButton, 'GuildCommunities')
        self:ChangeMicroMenuButton(CollectionsMicroButton, 'Collections')
        self:ChangeMicroMenuButton(PVPMicroButton, 'AdventureGuide')
        self:BetterPVPMicroButton(PVPMicroButton)
        PVPMicroButtonTexture:Hide()
        self:ChangeMicroMenuButton(LFGMicroButton, 'Groupfinder')
        self:ChangeMicroMenuButton(EJMicroButton, 'AdventureGuide')
        self:ChangeMicroMenuButton(StoreMicroButton, 'Shop')
        self:ChangeMicroMenuButton(MainMenuMicroButton, 'GameMenu')

        MainMenuBarTextureExtender:Hide()

        -- MainMenuBarPerformanceBar:ClearAllPoints()
        MainMenuBarPerformanceBar:SetPoint('BOTTOM', MainMenuMicroButton, 'BOTTOM', 0, 0)
        MainMenuBarPerformanceBar:SetSize(19, 39)
        MainMenuBarPerformanceBar:Hide() -- TODO

        -- self:HookMicromenuOverride()
    elseif DF.Cata then
        self:ChangeCharacterMicroButton()
        self:ChangeMicroMenuButton(SpellbookMicroButton, 'SpellbookAbilities')
        self:ChangeMicroMenuButton(TalentMicroButton, 'SpecTalents')
        self:ChangeMicroMenuButton(AchievementMicroButton, 'Achievements')
        self:ChangeMicroMenuButton(QuestLogMicroButton, 'Questlog')
        self:ChangeMicroMenuButton(GuildMicroButton, 'GuildCommunities')
        self:ChangeMicroMenuButton(SocialsMicroButton, 'GuildCommunities')
        self:ChangeMicroMenuButton(CollectionsMicroButton, 'Collections')
        self:ChangeMicroMenuButton(PVPMicroButton, 'AdventureGuide')
        self:BetterPVPMicroButton(PVPMicroButton)
        PVPMicroButtonTexture:Hide()
        self:ChangeMicroMenuButton(LFGMicroButton, 'Groupfinder')
        self:ChangeMicroMenuButton(EJMicroButton, 'AdventureGuide')
        self:ChangeMicroMenuButton(MainMenuMicroButton, 'Shop')
        self:ChangeMicroMenuButton(HelpMicroButton, 'GameMenu')

        MainMenuBarTextureExtender:Hide()

        -- MainMenuBarPerformanceBar:ClearAllPoints()
        MainMenuBarPerformanceBar:SetPoint('BOTTOM', MainMenuMicroButton, 'BOTTOM', 0, 0)
        MainMenuBarPerformanceBar:SetSize(19, 39)

        -- self:HookMicromenuOverride()
    elseif DF.Wrath then
        self:ChangeCharacterMicroButton()
        self:ChangeMicroMenuButton(SpellbookMicroButton, 'SpellbookAbilities')
        self:ChangeMicroMenuButton(TalentMicroButton, 'SpecTalents')
        self:ChangeMicroMenuButton(AchievementMicroButton, 'Achievements')
        self:ChangeMicroMenuButton(QuestLogMicroButton, 'Questlog')
        if GuildMicroButton then self:ChangeMicroMenuButton(GuildMicroButton, 'GuildCommunities') end -- wrath newer version, e.g. CN
        self:ChangeMicroMenuButton(SocialsMicroButton, 'GuildCommunities')
        self:ChangeMicroMenuButton(CollectionsMicroButton, 'Collections')
        self:ChangeMicroMenuButton(PVPMicroButton, 'AdventureGuide')
        self:BetterPVPMicroButton(PVPMicroButton)
        PVPMicroButtonTexture:Hide()
        self:ChangeMicroMenuButton(LFGMicroButton, 'Groupfinder')
        self:ChangeMicroMenuButton(MainMenuMicroButton, 'Shop')
        self:ChangeMicroMenuButton(HelpMicroButton, 'GameMenu')

        MainMenuBarTextureExtender:Hide()

        -- MainMenuBarPerformanceBar:ClearAllPoints()
        MainMenuBarPerformanceBar:SetPoint('BOTTOM', MainMenuMicroButton, 'BOTTOM', 0, 0)
        MainMenuBarPerformanceBar:SetSize(19, 39)
    elseif DF.Era then
        self:ChangeCharacterMicroButton()
        self:ChangeMicroMenuButton(SpellbookMicroButton, 'SpellbookAbilities')
        self:ChangeMicroMenuButton(TalentMicroButton, 'SpecTalents')
        self:ChangeMicroMenuButton(QuestLogMicroButton, 'Questlog')
        -- WorldMapMicroButton    
        self:ChangeMicroMenuButton(WorldMapMicroButton, 'Collections')

        if LFGMicroButton then self:ChangeMicroMenuButton(LFGMicroButton, 'Groupfinder') end
        if SocialsMicroButton then self:ChangeMicroMenuButton(SocialsMicroButton, 'GuildCommunities') end
        if GuildMicroButton then self:ChangeMicroMenuButton(GuildMicroButton, 'GuildCommunities') end

        self:ChangeMicroMenuButton(MainMenuMicroButton, 'Shop')
        self:ChangeMicroMenuButton(HelpMicroButton, 'GameMenu')

        MainMenuBarPerformanceBarFrame:Hide()
    end
end

function DragonflightUIMicroMenuMixin:ChangeCharacterMicroButton()
    -- print('~~DragonflightUIMicroMenuMixin:ChangeCharacterMicroButton()')
    local microTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\Micromenu\\uimicromenu2x'

    --[[   local name = 'CharacterInfo'
    local pre = 'UI-HUD-MicroMenu-'
    local key = pre .. name
    local up = self:MicromenuAtlas[key .. '-Up']
    ]]

    local frame = CharacterMicroButton
    table.insert(self.MicroButtons, frame)

    local sizeX, sizeY = 32, 40
    local offX, offY = frame:GetPushedTextOffset()

    frame:SetSize(sizeX, sizeY)
    frame:SetHitRectInsets(0, 0, 0, 0)

    frame:GetNormalTexture():SetAlpha(0)
    frame:GetPushedTexture():SetAlpha(0)
    frame:GetHighlightTexture():SetAlpha(0)

    MicroButtonPortrait:ClearAllPoints()
    MicroButtonPortrait:Hide()

    -- new portrait
    local dfPortrait = frame:CreateTexture('NewPortrait', 'ARTWORK')
    dfPortrait:SetAllPoints()
    -- newPortrait:SetSize(sizeX - 2 * inside, sizeY - 2 * inside)
    -- newPortrait:SetPoint('CENTER', 0.5, 0)
    dfPortrait:SetPoint('TOPLEFT', 8, -7)
    dfPortrait:SetPoint('BOTTOMRIGHT', -6, 7)
    dfPortrait:SetTexCoord(0.2, 0.8, 0.0666, 0.9)
    frame.dfPortrait = dfPortrait

    local microPortraitMaskTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\Micromenu\\uimicromenuportraitmask2x'

    -- portraitMask
    local dfPortraitMask = frame:CreateMaskTexture()
    dfPortraitMask:SetTexture(microPortraitMaskTexture, 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
    dfPortraitMask:SetPoint('CENTER')
    dfPortraitMask:SetSize(35, 65)
    dfPortrait:AddMaskTexture(dfPortraitMask)
    frame.dfPortraitMask = dfPortraitMask

    -- portraitShadow (pushed)
    local dfPortraitShadow = frame:CreateTexture('NewPortraitShadow', 'OVERLAY')
    dfPortraitShadow:SetTexture(microTexture)
    dfPortraitShadow:SetTexCoord(0.323242, 0.385742, 0.166016, 0.326172)
    dfPortraitShadow:SetSize(32, 41)
    dfPortraitShadow:SetPoint('CENTER', 1, -4)
    dfPortraitShadow:Hide()
    frame.dfPortraitShadow = dfPortraitShadow

    SetPortraitTexture(frame.dfPortrait, 'player')

    -- CharacterMicroButton_OnEvent
    CharacterMicroButton:HookScript('OnEvent', function(self)
        -- print('on event')
        SetPortraitTexture(frame.dfPortrait, 'player')
    end)

    frame.dfSetState = function(pushed)
        if pushed then
            local delta = offX / 2
            frame.dfPortraitMask:ClearAllPoints()
            frame.dfPortraitMask:SetPoint('CENTER', delta, -delta)

            frame.dfPortrait:ClearAllPoints()
            frame.dfPortrait:SetPoint('TOPLEFT', 8 + delta, -7 - delta)
            frame.dfPortrait:SetPoint('BOTTOMRIGHT', -6 + delta, 7 - delta)

            dfPortraitShadow:Show()
        else
            frame.dfPortraitMask:ClearAllPoints()
            frame.dfPortraitMask:SetPoint('CENTER', 0, 0)

            frame.dfPortrait:ClearAllPoints()
            frame.dfPortrait:SetPoint('TOPLEFT', 8, -7)
            frame.dfPortrait:SetPoint('BOTTOMRIGHT', -6, 7)

            dfPortraitShadow:Hide()
        end
    end

    do
        -- add missing background
        local dx, dy = -1, 1

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

        -- frame:GetHighlightTexture():SetPoint('CENTER', 0, 0)
        -- frame:GetHighlightTexture():SetPoint('CENTER', 2, -2)

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
            frame.dfSetState(state.pushed)
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
    end
end

function DragonflightUIMicroMenuMixin:BetterPVPMicroButton(btn)
    local tex = 'Interface\\Addons\\DragonflightUI\\Textures\\Micromenu\\micropvp'

    local englishFaction, localizedFaction = UnitFactionGroup('player')

    if englishFaction == 'Alliance' then
        btn:SetNormalTexture(tex)
        btn:GetNormalTexture():SetTexCoord(0, 118 / 256, 0, 151 / 256)

        btn:SetDisabledTexture(tex)
        btn:GetDisabledTexture():SetTexCoord(0, 118 / 256, 0, 151 / 256)

        btn:SetPushedTexture(tex)
        btn:GetPushedTexture():SetTexCoord(0, 118 / 256, 0, 151 / 256)

        btn:SetHighlightTexture(tex)
        btn:GetHighlightTexture():SetTexCoord(0, 118 / 256, 0, 151 / 256)
    else
        btn:SetNormalTexture(tex)
        btn:GetNormalTexture():SetTexCoord(118 / 256, 236 / 256, 0, 151 / 256)

        btn:SetDisabledTexture(tex)
        btn:GetDisabledTexture():SetTexCoord(118 / 256, 236 / 256, 0, 151 / 256)

        btn:SetPushedTexture(tex)
        btn:GetPushedTexture():SetTexCoord(118 / 256, 236 / 256, 0, 151 / 256)

        btn:SetHighlightTexture(tex)
        btn:GetHighlightTexture():SetTexCoord(118 / 256, 236 / 256, 0, 151 / 256)
    end
end

function DragonflightUIMicroMenuMixin:ChangeMicroMenuButton(frame, name)
    -- print('~~DragonflightUIMicroMenuMixin:ChangeMicroMenuButton()')
    table.insert(self.MicroButtons, frame)
    local microTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\Micromenu\\uimicromenu2x'

    if DF.Era then microTexture = 'Interface\\Addons\\DragonflightUI\\Textures\\Micromenu\\uimicromenu2xERA' end

    local pre = 'UI-HUD-MicroMenu-'
    local key = pre .. name
    local up = DragonflightUIMicroMenuMixin.MicromenuAtlas[key .. '-Up']

    local sizeX, sizeY = 32, 40
    frame:SetSize(sizeX, sizeY)
    frame:SetHitRectInsets(0, 0, 0, 0)

    frame:SetNormalTexture(microTexture)
    frame:GetNormalTexture():SetTexCoord(up[3], up[4], up[5], up[6])

    local disabled = DragonflightUIMicroMenuMixin.MicromenuAtlas[key .. '-Disabled']
    frame:SetDisabledTexture(microTexture)
    frame:GetDisabledTexture():SetTexCoord(disabled[3], disabled[4], disabled[5], disabled[6])

    local down = DragonflightUIMicroMenuMixin.MicromenuAtlas[key .. '-Down']
    frame:SetPushedTexture(microTexture)
    frame:GetPushedTexture():SetTexCoord(down[3], down[4], down[5], down[6])

    local mouseover = DragonflightUIMicroMenuMixin.MicromenuAtlas[key .. '-Mouseover']
    frame:SetHighlightTexture(microTexture)
    frame:GetHighlightTexture():SetTexCoord(mouseover[3], mouseover[4], mouseover[5], mouseover[6])
    frame:GetHighlightTexture():SetSize(sizeX, sizeY)

    -- Fix: on Era textures get overwritten inside OnUpdate :x
    if DF.Era and frame == MainMenuMicroButton then
        MainMenuMicroButton:HookScript('OnUpdate', function(self)
            frame:SetNormalTexture(microTexture)
            frame:SetDisabledTexture(microTexture)
            frame:SetPushedTexture(microTexture)
            frame:SetHighlightTexture(microTexture)
        end)
    end

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

    -- frame:GetHighlightTexture():SetPoint('CENTER', 0, 0)
    -- frame:GetHighlightTexture():SetPoint('CENTER', 2, -2)

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

    -- gap
    --[[     local gap = 0
    local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(1)
    print(point, relativeTo, relativePoint, xOfs, yOfs)
    frame:SetPoint(point, relativeTo, relativePoint, gap, yOfs)
    ]]

end

DragonflightUIMicroMenuMixin.MicromenuAtlas = {
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
