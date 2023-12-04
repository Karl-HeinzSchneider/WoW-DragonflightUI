DragonFlightUIConfigMixin = {}
DragonFlightUIConfigMixin2 = {}

function DragonFlightUIConfigMixin:OnLoad()
    print('OnLoad')

    self.NineSlice.Text:SetText('DragonflightUI')

    local function closePanel()
        self:Close();
    end

    self.CloseButton.Text:SetText(SETTINGS_CLOSE);
    self.CloseButton:SetScript("OnClick", closePanel);
end

function DragonFlightUIConfigMixin:OnShow()
    print('OnShow')
end

function DragonFlightUIConfigMixin:OnHide()
    print('OnHide')
end

function DragonFlightUIConfigMixin:OnEvent(event, ...)
    print('OnEvent')
end

function DragonFlightUIConfigMixin:Close()
    self:Hide()
end

function DragonFlightUIConfigMixin:GetCategoryList()
    return self.CategoryList;
end

function DragonFlightUIConfigMixin:GetSettingsList()
    return self.Container.SettingsList;
end

function DragonFlightUIConfigMixin:GetSettingsCanvas()
    return self.Container.SettingsCanvas;
end

-- SettingsCategoryListMixinDF   - Blizzard_CategoryList.lua
SettingsCategoryListMixinDF = {}
function SettingsCategoryListMixinDF:OnLoad()
    self.ScrollBar:Hide()
end
