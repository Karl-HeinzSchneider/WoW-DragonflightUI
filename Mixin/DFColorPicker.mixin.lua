local CreateColor = DFCreateColor;

------------------
DFColorPickerMixin = {}

function DFColorPickerMixin:OnLoad()
    -- print('DFColorPickermixin:OnLoad()')
    -- self:Show()
    self:SetScale(UIParent:GetEffectiveScale())

    self.Header.Text:SetText(COLOR_PICKER)

    self.CopyString = ''
    self.Content.PasteButton:SetText('paste')
    self.Content.PasteButton:SetEnabled(self.CopyString ~= '')
    self.Content.PasteButton:SetScript("OnClick", function()
        if (self.CopyString ~= '') then
            -- local color = CreateColorFromRGBAHexString(self.CopyString .. "ff");
            -- self.Content.ColorPicker:SetColorRGB(color:GetRGB());
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);

            self.Content.HexBox:SetText(self.CopyString)
            self.Content.HexBox:OnEnterPressed()
        else
            self:SetEnabled(false)
        end
    end);

    self.Content.CopyButton:SetText('copy')
    self.Content.CopyButton:SetScript("OnClick", function()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
        self.CopyString = self.Content.HexBox:GetText()
        self.Content.PasteButton:SetEnabled(self.CopyString ~= '')
    end);

    -- blizz
    self.Content.ColorPicker:SetScript("OnColorSelect", function(colorPicker, r, g, b)
        self.Content.ColorSwatchCurrent:SetColorTexture(r, g, b);
        self.Content.HexBox:OnColorSelect(r, g, b);
        if self.swatchFunc then self.swatchFunc(); end

        if self.opacityFunc then self.opacityFunc(); end
    end);

    self.Footer.OkayButton:SetScript("OnClick", function()
        if self.swatchFunc then self.swatchFunc(); end
        if self.opacityFunc then self.opacityFunc(); end
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
        self:Hide();
    end);

    self.Footer.CancelButton:SetScript("OnClick", function()
        if self.cancelFunc then self.cancelFunc(self.previousValues); end
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
        self:Hide();
    end);
end

function DFColorPickerMixin:OnEvent()
    -- print('DFColorPickermixin:OnEvent()')
end

function DFColorPickerMixin:OnShow()
    -- print('DFColorPickermixin:OnShow()')
    if self.hasOpacity then
        -- self.Content.ColorPicker.Alpha:Show();
        -- self.Content.ColorPicker.AlphaThumb:Show();
        -- self.Content.AlphaBackground:Show();
        self.Content.ColorPicker:SetColorAlpha(self.opacity);

        self.Content.ColorPicker:SetWidth(255);
        self:SetWidth(388);
    else
        -- self.Content.ColorPicker.Alpha:Hide();
        -- self.Content.ColorPicker.AlphaThumb:Hide();
        -- self.Content.AlphaBackground:Hide();

        self.Content.ColorPicker:SetWidth(200);
        self:SetWidth(331);
    end
end

function DFColorPickerMixin:OnKeyDown(key)
    -- print('DFColorPickermixin:OnKeyDown()')
    if GetBindingFromClick(key) == "TOGGLEGAMEMENU" then
        if self.cancelFunc then self.cancelFunc(self.previousValues); end
        self:Hide();
    end
end

function DFColorPickerMixin:OnDragStart()
    -- print('DFColorPickermixin:OnDragStart()')
    self:StartMoving()
end

function DFColorPickerMixin:OnDragStop()
    -- print('DFColorPickermixin:OnDragStop()')
    self:StopMovingOrSizing()
end

function DFColorPickerMixin:SetupColorPickerAndShow(info)
    -- print('DFColorPickermixin:SetupColorPickerAndShow()')
    self.swatchFunc = info.swatchFunc;
    self.hasOpacity = info.hasOpacity;
    self.opacityFunc = info.opacityFunc;
    self.opacity = info.opacity;
    self.previousValues = {r = info.r, g = info.g, b = info.b, a = info.opacity};
    self.cancelFunc = info.cancelFunc;
    self.extraInfo = info.extraInfo;

    self.Content.ColorSwatchOriginal:SetColorTexture(info.r, info.g, info.b);
    self.Content.HexBox:OnColorSelect(info.r, info.g, info.b);

    -- This must come last, since it triggers a call to swatchFunc
    self.Content.ColorPicker:SetColorRGB(info.r, info.g, info.b);
    self:Show();
end

function DFColorPickerMixin:GetColorRGB()
    return self.Content.ColorPicker:GetColorRGB();
end

function DFColorPickerMixin:GetColorAlpha()
    -- return self.Content.ColorPicker:GetColorAlpha(); TODO
    return 1.0
end

function DFColorPickerMixin:GetExtraInfo()
    return self.extraInfo;
end

function DFColorPickerMixin:GetPreviousValues()
    return self.previousValues.r, self.previousValues.g, self.previousValues.b, self.previousValues.a;
end

-----------------------

DFColorPickerHexBoxMixin = {}

function DFColorPickerHexBoxMixin:OnLoad()
    self:SetTextInsets(16, 0, 0, 0);
    self.Instructions:SetText(COLOR_PICKER_HEX);
    self.Instructions:ClearAllPoints();
    self.Instructions:SetPoint("TOPLEFT", self, "TOPLEFT", 16, 0);
    self.Instructions:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0);
end

function DFColorPickerHexBoxMixin:OnTextChanged()
    local text = self:GetText();
    self:SetText(string.gsub(text, "[^A-Fa-f0-9]", ""));
    self.Instructions:SetShown(self:GetText() == "");
end

function DFColorPickerHexBoxMixin:OnEnterPressed()
    -- If a full hex code was not provided, copy from the start of the string until we have all characters.
    local text = self:GetText();
    local length = string.len(text);
    if length == 0 then
        self:SetText("ffffff");
    elseif length < 6 then
        local startingText = text;
        while length < 6 do
            for i = 1, #startingText do
                local char = startingText:sub(i, i);
                text = text .. char;

                length = length + 1;
                if length == 6 then break end
            end
        end
        self:SetText(text);
    end

    -- Update color to match string.
    -- Add alpha values to the end to be correct format.
    local color = CreateColorFromRGBAHexString(self:GetText() .. "ff");
    _G['DragonflightUIColorPicker'].Content.ColorPicker:SetColorRGB(color:GetRGB());
    self:ClearFocus()
end

function DFColorPickerHexBoxMixin:OnColorSelect(r, g, b)
    local hexColor = CreateColor(r, g, b):GenerateHexColorNoAlpha();
    self:SetText(hexColor);
end

-----------------------

DFColorPickerAlphaBoxMixin = {}

function DFColorPickerAlphaBoxMixin:OnLoad()
    self:SetTextInsets(16, 0, 0, 0);
    self.Instructions:SetText(COLOR_PICKER_HEX);
    self.Instructions:ClearAllPoints();
    self.Instructions:SetPoint("TOPLEFT", self, "TOPLEFT", 16, 0);
    self.Instructions:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0);
end

function DFColorPickerAlphaBoxMixin:OnTextChanged()
    local text = self:GetText();
    self:SetText(string.gsub(text, "[^.0-9]", ""));
    self.Instructions:SetShown(self:GetText() == "");
end

function DFColorPickerAlphaBoxMixin:OnEnterPressed()
    -- -- If a full hex code was not provided, copy from the start of the string until we have all characters.
    -- local text = self:GetText();
    -- local length = string.len(text);
    -- if length == 0 then
    --     self:SetText("ffffff");
    -- elseif length < 6 then
    --     local startingText = text;
    --     while length < 6 do
    --         for i = 1, #startingText do
    --             local char = startingText:sub(i, i);
    --             text = text .. char;

    --             length = length + 1;
    --             if length == 6 then break end
    --         end
    --     end
    --     self:SetText(text);
    -- end

    -- -- Update color to match string.
    -- -- Add alpha values to the end to be correct format.
    -- local color = CreateColorFromRGBAHexString(self:GetText() .. "ff");
    -- _G['DragonflightUIColorPicker'].Content.ColorPicker:SetColorRGB(color:GetRGB());
    -- self:ClearFocus()
end

function DFColorPickerAlphaBoxMixin:OnColorSelect(r, g, b)
    -- local hexColor = CreateColor(r, g, b):GenerateHexColorNoAlpha();
    -- self:SetText(hexColor);
end

