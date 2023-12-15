-- DragonFlightUIConfigCategoryButtonMixin = {}
DragonFlightUIConfigCategoryButtonMixin = CreateFromMixins(ButtonStateBehaviorMixin)

function DragonFlightUIConfigCategoryButtonMixin:OnLoad()
    self.Toggle:SetScript("OnClick", function(button, buttonName, down)
        -- local initializer = self:GetElementData();
        -- local category = initializer.data.category;
        -- self:SetExpanded(not category.expanded);
        -- print('OnClick', buttonName)
    end);

    self.over = nil
    self.down = nil
    self.isEnabled = false
    self.isSelected = false

    self.category = nil
    self.categoryRef = nil
    self.subCategory = nil

    self.displayData = nil
    self.displayFrame = nil

    self:UpdateState()
end

function DragonFlightUIConfigCategoryButtonMixin:OnEnter()
    -- print(self:GetName(), 'OnEnter')

    if ButtonStateBehaviorMixin.OnEnter(self) then self:UpdateState(); end
end

function DragonFlightUIConfigCategoryButtonMixin:OnLeave()
    -- print(self:GetName(), 'OnLeave')

    if ButtonStateBehaviorMixin.OnLeave(self) then self:UpdateState(); end
end

function DragonFlightUIConfigCategoryButtonMixin:OnMouseDown()
    -- print(self:GetName(), 'OnMouseDown')
end

function DragonFlightUIConfigCategoryButtonMixin:OnMouseUp()
    -- print(self:GetName(), 'OnMouseUp')
    self:BtnClicked()
end

function DragonFlightUIConfigCategoryButtonMixin:IsEnabled()
    return self.isEnabled
end

function DragonFlightUIConfigCategoryButtonMixin:SetEnabled(enabled)
    self.isEnabled = enabled
    self:UpdateState()
end

function DragonFlightUIConfigCategoryButtonMixin:SetCallback(cb)
    self.callback = cb
end

function DragonFlightUIConfigCategoryButtonMixin:BtnClicked()
    -- print('DragonFlightUIConfigCategoryButtonMixin:BtnClicked()')  
    if self:IsEnabled() then self.categoryRef.configRef:SubCategoryBtnClicked(self) end
    self:UpdateState()
end

function DragonFlightUIConfigCategoryButtonMixin:SetCategory(cat, sub)
    self.category = cat.category
    self.categoryRef = cat
    self.subCategory = sub
end

function DragonFlightUIConfigCategoryButtonMixin:UpdateStateInternal(selected)
    if selected then
        self.Label:SetFontObject("GameFontHighlight");
        self.Texture:SetAtlas("Options_List_Active", TextureKitConstants.UseAtlasSize);
        self.Texture:Show();
    else
        local initializer = self:GetElementData();
        local category = initializer.data.category;
        local fontObject;
        if category:HasParentCategory() then
            fontObject = "GameFontHighlight";
        else
            fontObject = "GameFontNormal";
        end

        self.Label:SetFontObject(fontObject);
        if self.over then
            self.Texture:SetAtlas("Options_List_Hover", TextureKitConstants.UseAtlasSize);
            self.Texture:Show();
        else
            self.Texture:Hide();
        end
    end
end

function DragonFlightUIConfigCategoryButtonMixin:UpdateState()
    -- self:UpdateStateInternal(g_selectionBehavior:IsSelected(self));
    if not self:IsEnabled() then
        self.Label:SetFontObject("GameFontHighlight");
        self.Label:SetAlpha(0.5)

        self.Texture:Hide()
    elseif self.isSelected then
        self.Label:SetFontObject("GameFontHighlight");
        self.Label:SetAlpha(1)

        self.Texture:SetAtlas("Options_List_Active", TextureKitConstants.UseAtlasSize);
        self.Texture:Show();
    else
        self.Label:SetFontObject("GameFontNormal");
        self.Label:SetAlpha(1)

        if self.over then
            self.Texture:SetAtlas("Options_List_Hover", TextureKitConstants.UseAtlasSize);
            self.Texture:Show();
        else
            self.Texture:Hide();
        end
    end
end

function DragonFlightUIConfigCategoryButtonMixin:SetDisplayData(data)
    self.displayData = data
    -- if self.displayFrame then self.displayFrame:Hide() end
    self.displayFrame = CreateFrame('Frame', nil, nil, 'SettingsListTemplateDF')
    self.displayFrame:Display(data)
end
