local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

local locale = GetLocale()

-- globals
BINDING_CATEGORY_DRAGONFLIGHTUI = "DragonflightUI"

BINDING_CATEGORY_DFACTIONBAR6 = "Action Bar 6"
BINDING_HEADER_DFACTIONBAR6_BUTTON1 = "Action Bar 6 Button 1"
for i = 1, 12 do
    _G["BINDING_NAME_CLICK DragonflightUIMultiactionBar6Button" .. i .. ":Keybind"] = "Action Bar 6 Button " .. i
end

BINDING_CATEGORY_DFACTIONBAR7 = "Action Bar 7"
BINDING_HEADER_DFACTIONBAR7_BUTTON1 = "Action Bar 7 Button 1"
for i = 1, 12 do
    _G["BINDING_NAME_CLICK DragonflightUIMultiactionBar7Button" .. i .. ":Keybind"] = "Action Bar 7 Button " .. i
end

BINDING_CATEGORY_DFACTIONBAR8 = "Action Bar 8"
BINDING_HEADER_DFACTIONBAR8_BUTTON1 = "Action Bar 8 Button 1"
for i = 1, 12 do
    _G["BINDING_NAME_CLICK DragonflightUIMultiactionBar8Button" .. i .. ":Keybind"] = "Action Bar 8 Button " .. i
end

-- flyout

for f = 1, 10 do
    _G['BINDING_CATEGORY_DFCUSTOMFLYOUT' .. f] = 'Custom Flyout ' .. f
    _G['BINDING_HEADER_DFCUSTOMFLYOUT' .. f .. '_BUTTON1'] = 'Custom Flyout ' .. f

    _G["BINDING_NAME_CLICK DragonflightUISpellFlyoutCustom" .. f .. "Button:Keybind"] = "Custom Flyout " .. f ..
                                                                                            " Expand"
    for i = 1, 12 do
        _G["BINDING_NAME_CLICK DragonflightUISpellFlyoutCustom" .. f .. "ButtonSub" .. i .. ":Keybind"] =
            "Custom Flyout " .. f .. " Button " .. i
    end
end
