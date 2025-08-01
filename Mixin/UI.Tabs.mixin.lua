function DragonflightUIMixin:ResizeTab(tab, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)
    local tabName = tab:GetName();

    -- local buttonMiddle = tab.Middle or tab.middleTexture or envTable[tabName .. "Middle"];
    -- local buttonMiddleDisabled = tab.MiddleDisabled or (tabName and envTable[tabName .. "MiddleDisabled"]);
    -- local left = tab.Left or tab.leftTexture or envTable[tabName .. "Left"];
    -- local sideWidths = 2 * left:GetWidth();
    local tabText = tab.Text or _G[tabName .. "Text"];
    -- local highlightTexture = tab.HighlightTexture or (tabName and envTable[tabName .. "HighlightTexture"]);

    tabText:SetWidth(0)
    local textWidth = tabText:GetWidth()

    if not padding then padding = 12; end

    if absoluteSize then
        tab:SetWidth(absoluteSize);
        tabText:SetWidth(absoluteSize - 2 * padding);
    else
        local width = textWidth + 2 * padding;

        if minWidth then width = math.max(width, minWidth); end
        if maxWidth then width = math.min(width, maxWidth); end
        tab:SetWidth(width);

        tabText:SetWidth(math.max(width - 2 * padding, 0));
    end
end
