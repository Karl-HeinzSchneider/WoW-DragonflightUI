DragonflightUICharacterStatsPanelMixin = {}

function DragonflightUICharacterStatsPanelMixin:OnLoad()
    print('DragonflightUICharacterStatsPanelMixin:OnLoad()')

    local btn = CreateFrame('Button', 'DragonflightUICharacterFrameExpandButton', CharacterFrame,
                            'DFCharacterFrameExpandButton')
    btn:SetPoint('BOTTOMRIGHT', CharacterFrame.DFInset, 'BOTTOMRIGHT', -2, -1)
    CharacterFrame.DFExpandButton = btn;
    -- <Anchor point="BOTTOMRIGHT" relativeKey="$parent.DFInset" x="-2" y="-1" />

    self:AddCharacterFrameFunctions()
    self:AddInset()
    CharacterFrame:Expand()
end

function DragonflightUICharacterStatsPanelMixin:AddCharacterFrameFunctions()
    function CharacterFrame:Collapse()
        self.Expanded = false;
        CharacterFrame:DFUpdateFrameWidth(false);
        -- characterFrameDisplayInfo["Default"].width = PANEL_DEFAULT_WIDTH;
        -- characterFrameDisplayInfo["PetPaperDollFrame"].width = PANEL_DEFAULT_WIDTH;
        self.DFExpandButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up");
        self.DFExpandButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down");
        self.DFExpandButton:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled");
        -- for i = 1, #PAPERDOLL_SIDEBARS do GetPaperDollSideBarFrame(i):Hide(); end
        self.DFInsetRight:Hide();
        -- PaperDollFrame_SetLevel();
        -- self:RefreshDisplay();
    end

    function CharacterFrame:Expand()
        self.Expanded = true;
        CharacterFrame:DFUpdateFrameWidth(true);
        -- characterFrameDisplayInfo["Default"].width = CHARACTERFRAME_EXPANDED_WIDTH;
        -- characterFrameDisplayInfo["PetPaperDollFrame"].width = CHARACTERFRAME_EXPANDED_WIDTH;
        self.DFExpandButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up");
        self.DFExpandButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down");
        self.DFExpandButton:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled");
        -- if (PaperDollFrame:IsShown() and PaperDollFrame.currentSideBar) then
        --     PaperDollFrame.currentSideBar:Show();
        -- else
        --     CharacterStatsPane:Show();
        -- end
        -- PaperDollFrame_UpdateSidebarTabs();
        self.DFInsetRight:Show();
        -- PaperDollFrame_SetLevel();
        -- self:RefreshDisplay();
    end
end

function DragonflightUICharacterStatsPanelMixin:AddInset()
    local inset = CreateFrame('Frame', 'DragonflightUICharacterFrameInsetRight', CharacterFrame, 'InsetFrameTemplate')
    inset:ClearAllPoints()
    inset:SetPoint('TOPLEFT', CharacterFrame.DFInset, 'TOPLEFT', 1, 0)
    inset:SetPoint('BOTTOMRIGHT', CharacterFrame, 'BOTTOMRIGHT', -4, 4)
    CharacterFrame.DFInsetRight = inset
end
-- function DragonflightUICharacterStatsPanelMixin:OnLoad()
-- end
-- function DragonflightUICharacterStatsPanelMixin:OnLoad()
-- end

-- expand button
DragonflightUICharacterFrameExpandButtonMixin = {}

function DragonflightUICharacterFrameExpandButtonMixin:OnLoad()
    self:SetFrameLevel(self:GetParent():GetFrameLevel() + 2);

    self.collapseTooltip = STATS_COLLAPSE_TOOLTIP;
    self.expandTooltip = STATS_EXPAND_TOOLTIP;
end

function DragonflightUICharacterFrameExpandButtonMixin:OnClick()
    if (CharacterFrame.Expanded) then
        -- SetCVar("characterFrameCollapsed", "1");
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE);
        CharacterFrame:Collapse();
    else
        -- SetCVar("characterFrameCollapsed", "0");
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN);
        CharacterFrame:Expand();
    end
    if (GameTooltip:GetOwner() == self) then self:GetScript("OnEnter")(self); end
end

function DragonflightUICharacterFrameExpandButtonMixin:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    if (CharacterFrame.Expanded) then
        GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE .. self.collapseTooltip .. FONT_COLOR_CODE_CLOSE);
    else
        GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE .. self.expandTooltip .. FONT_COLOR_CODE_CLOSE);
    end
end

function DragonflightUICharacterFrameExpandButtonMixin:OnLeave()
    GameTooltip:Hide();
end

