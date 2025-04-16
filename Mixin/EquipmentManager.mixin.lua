DFEquipmentManagerMixin = {}

-- Sidebar
local PAPERDOLL_SIDEBARS = {
    {
        name = PAPERDOLL_SIDEBAR_STATS,
        icon = nil, -- Uses the character portrait
        texCoords = {0.109375, 0.890625, 0.09375, 0.90625},
        disabledTooltip = nil,
        IsActive = function()
            return true;
        end
    }, {
        name = PAPERDOLL_SIDEBAR_TITLES,
        icon = "Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs",
        texCoords = {0.01562500, 0.53125000, 0.32421875, 0.46093750},
        disabledTooltip = NO_TITLES_TOOLTIP,
        IsActive = function()
            -- You always have the "No Title" title so you need to have more than one to have an option.
            -- return #GetKnownTitles() > 1;
            return false;
        end
    }, {
        name = PAPERDOLL_EQUIPMENTMANAGER,
        icon = "Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs",
        texCoords = {0.01562500, 0.53125000, 0.46875000, 0.60546875},
        disabledTooltip = function()
            local _, failureReason = C_LFGInfo.CanPlayerUseLFD();
            return failureReason;
        end,
        IsActive = function()
            return C_EquipmentSet.GetNumEquipmentSets() > 0 or C_LFGInfo.CanPlayerUseLFD();
        end
    }
};

DragonflightUISidebarMixin = {}

function DragonflightUISidebarMixin:OnLoad()
    print('OnLoads DragonflightUISidebarMixin')

    _G['DFPaperDollSidebarTab2']:Disable()
end

function DragonflightUISidebarMixin:GetPaperDollSideBarFrame(index)
    if index == 1 then
        return _G['DragonflightUICharacterStatsPanel'];
    elseif index == 2 then
        return _G['DragonflightUICharacterTitlePanel'];
    elseif index == 3 then
        return _G['DragonflightUICharacterEquipmentManagerPanel'];
    end
end

function DragonflightUISidebarMixin:SetSidebar(index)
    local frame = self:GetPaperDollSideBarFrame(index);
    if (not frame:IsShown()) then
        for i = 1, #PAPERDOLL_SIDEBARS do
            local barFrame = self:GetPaperDollSideBarFrame(i);
            barFrame:Hide();
        end
        frame:Show();
        self.currentSideBar = frame;
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
        self:UpdateSidebarTabs();
    end
end

function DragonflightUISidebarMixin:UpdateSidebarTabs()
    for i = 1, #PAPERDOLL_SIDEBARS do
        local tab = _G["PaperDollSidebarTab" .. i];
        if (tab) then
            local frame = self:GetPaperDollSideBarFrame(i);
            if (frame:IsShown()) then
                tab.Hider:Hide();
                tab.Highlight:Hide();
                tab.TabBg:SetTexCoord(0.01562500, 0.79687500, 0.78906250, 0.95703125);
            else
                tab.Hider:Show();
                tab.Highlight:Show();
                tab.TabBg:SetTexCoord(0.01562500, 0.79687500, 0.61328125, 0.78125000);
                if (PAPERDOLL_SIDEBARS[i].IsActive()) then
                    tab:Enable();
                else
                    tab:Disable();
                end
            end
        end
    end
end

-- Tabs

DragonflightUISidebarTabMixin = {}

function DragonflightUISidebarTabMixin:OnLoad()
    print('OnLoads DragonflightUISidebarTabMixin')

    if self:GetID() == 1 then
        self:RegisterEvent("UNIT_PORTRAIT_UPDATE");
        self:RegisterEvent("PORTRAITS_UPDATED");
        self:RegisterEvent("PLAYER_ENTERING_WORLD");

        local tcoords = PAPERDOLL_SIDEBARS[self:GetID()].texCoords;
        self.Icon:SetTexCoord(tcoords[1], tcoords[2], tcoords[3], tcoords[4]);
        self.Icon:SetSize(29, 31);
        self.Icon:SetPoint("BOTTOM", 1, 0);
    else
        self.Icon:SetTexture(PAPERDOLL_SIDEBARS[self:GetID()].icon);
        local tcoords = PAPERDOLL_SIDEBARS[self:GetID()].texCoords;
        self.disabledTooltip = PAPERDOLL_SIDEBARS[self:GetID()].disabledTooltip;
        self.Icon:SetTexCoord(tcoords[1], tcoords[2], tcoords[3], tcoords[4]);
    end

end

function DragonflightUISidebarTabMixin:OnClick()
    print('OnClick DragonflightUISidebarTabMixin')
    -- PaperDollFrame_SetSidebar(self, self:GetID());
    self:GetParent():SetSidebar(self:GetID())
end

function DragonflightUISidebarTabMixin:OnEnable()
    -- print('OnEnable DragonflightUISidebarTabMixin')
    self:SetAlpha(1);
    self.Icon:SetDesaturation(0);
end

function DragonflightUISidebarTabMixin:OnDisable()
    -- print('OnDisable DragonflightUISidebarTabMixin')
    self:SetAlpha(0.5);
    self.Icon:SetDesaturation(1);
end

function DragonflightUISidebarTabMixin:OnEnter()
    -- print('OnEnter DragonflightUISidebarTabMixin')
    -- PaperDollFrame_SidebarTab_OnEnter

    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    GameTooltip_SetTitle(GameTooltip, PAPERDOLL_SIDEBARS[self:GetID()].name);
    if not self:IsEnabled() and self.disabledTooltip then
        local disabledTooltipText = GetValueOrCallFunction(self, "disabledTooltip");
        GameTooltip_AddErrorLine(GameTooltip, disabledTooltipText, true);
    end
    GameTooltip:Show();
end

function DragonflightUISidebarTabMixin:OnLeave()
    -- print('OnLeave DragonflightUISidebarTabMixin')
    GameTooltip:Hide();
end

