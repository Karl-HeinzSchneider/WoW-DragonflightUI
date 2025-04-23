DragonflightUICharacterTabMixin = {}

function DragonflightUICharacterTabMixin:sasasas()

end

function DragonflightUICharacterTabMixin:Tab_OnClick(self, frame)
    DragonflightUICharacterTabMixin:SetTab(frame, self:GetID())
end

function DragonflightUICharacterTabMixin:SetTab(frame, id)
    frame.selectedTab = id;
    DragonflightUICharacterTabMixin:UpdateTabs(frame);
end

local function GetTabByIndex(frame, index)
    return frame.Tabs and frame.Tabs[index] or _G[frame:GetName() .. "Tab" .. index];
end

function DragonflightUICharacterTabMixin:UpdateTabs(frame)
    if (frame.selectedTab) then
        local tab;
        for i = 1, frame.numTabs, 1 do
            tab = GetTabByIndex(frame, i);
            if (tab.isDisabled) then
                -- PanelTemplates_SetDisabledTabState(tab);
                DragonflightUICharacterTabMixin:DisableTab(tab);
                -- print('tab.isDisabled')
            elseif (i == frame.selectedTab) then
                DragonflightUICharacterTabMixin:SelectTab(tab);
            else
                DragonflightUICharacterTabMixin:DeselectTab(tab);
            end
        end
    end
end

function DragonflightUICharacterTabMixin:DeselectTab(tab)
    local name = tab:GetName();

    local left = tab.Left or _G[name .. "Left"];
    local middle = tab.Middle or _G[name .. "Middle"];
    local right = tab.Right or _G[name .. "Right"];
    left:Show();
    middle:Show();
    right:Show();
    -- tab:UnlockHighlight();
    -- tab:Enable();
    tab:DFHighlight(false)
    tab:SetNormalFontObject(GameFontNormalSmall)
    local text = tab.Text or _G[name .. "Text"];
    text:SetPoint("CENTER", tab, "CENTER", (tab.deselectedTextX or 0), (tab.deselectedTextY or 2));

    local leftDisabled = tab.LeftDisabled or _G[name .. "LeftDisabled"];
    local middleDisabled = tab.MiddleDisabled or _G[name .. "MiddleDisabled"];
    local rightDisabled = tab.RightDisabled or _G[name .. "RightDisabled"];
    if leftDisabled then leftDisabled:Hide(); end
    if middleDisabled then middleDisabled:Hide(); end
    if rightDisabled then rightDisabled:Hide(); end
end

function DragonflightUICharacterTabMixin:SelectTab(tab)
    local name = tab:GetName();

    local left = tab.Left or _G[name .. "Left"];
    local middle = tab.Middle or _G[name .. "Middle"];
    local right = tab.Right or _G[name .. "Right"];
    left:Hide();
    middle:Hide();
    right:Hide();
    -- tab:LockHighlight();
    -- tab:Disable();
    tab:DFHighlight(true)
    tab:SetDisabledFontObject(GameFontHighlightSmall);
    tab:SetNormalFontObject(GameFontHighlightSmall)
    local text = tab.Text or _G[name .. "Text"];
    text:SetPoint("CENTER", tab, "CENTER", (tab.selectedTextX or 0), (tab.selectedTextY or -3));

    local leftDisabled = tab.LeftDisabled or _G[name .. "LeftDisabled"];
    local middleDisabled = tab.MiddleDisabled or _G[name .. "MiddleDisabled"];
    local rightDisabled = tab.RightDisabled or _G[name .. "RightDisabled"];
    if leftDisabled then leftDisabled:Show(); end
    if middleDisabled then middleDisabled:Show(); end
    if rightDisabled then rightDisabled:Show(); end
    local tooltip = GetAppropriateTooltip();
    if tooltip:IsOwned(tab) then tooltip:Hide(); end
end

function DragonflightUICharacterTabMixin:DisableTab(tab)
    local name = tab:GetName();

    local left = tab.Left or _G[name .. "Left"];
    local middle = tab.Middle or _G[name .. "Middle"];
    local right = tab.Right or _G[name .. "Right"];
    left:Show();
    middle:Show();
    right:Show();
    -- tab:UnlockHighlight();
    -- tab:Enable();
    tab:DFHighlight(false)
    tab:SetDisabledFontObject(GameFontHighlightSmall);
    tab:SetNormalFontObject(GameFontNormalSmall)
    local text = tab.Text or _G[name .. "Text"];
    text:SetPoint("CENTER", tab, "CENTER", (tab.deselectedTextX or 0), (tab.deselectedTextY or 2));

    local leftDisabled = tab.LeftDisabled or _G[name .. "LeftDisabled"];
    local middleDisabled = tab.MiddleDisabled or _G[name .. "MiddleDisabled"];
    local rightDisabled = tab.RightDisabled or _G[name .. "RightDisabled"];
    if leftDisabled then leftDisabled:Hide(); end
    if middleDisabled then middleDisabled:Hide(); end
    if rightDisabled then rightDisabled:Hide(); end
end
