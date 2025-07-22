local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Profiles'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {profile = {scale = 1, general = {toCopy = 'Default', toDelete = 'Default'}}}
Module:SetDefaults(defaults)

local function getDefaultStr(key, sub)
    return Module:GetDefaultStr(key, sub)
end

local function setDefaultValues()
    Module:SetDefaultValues()
end

local function setDefaultSubValues(sub)
    Module:SetDefaultSubValues(sub)
end

local function getOption(info)
    local key = info[1]

    if key == 'currentProfile' then
        --  
        return Module:GetCurrentProfile()
    end

    return Module:GetOption(info)
end

local function setOption(info, value)
    local key = info[1]

    if key == 'currentProfile' then
        --  
        Module:SetCurrentProfile(value)
    else
        Module:SetOption(info, value)
    end

    Module:RefreshOptionScreens()
end

local function GetProfileOptions()
    local generalOptions = {
        type = 'group',
        name = 'Profiles',
        get = getOption,
        set = setOption,
        args = {
            -- scale = {
            --     type = 'range',
            --     name = 'Scale',
            --     desc = '' .. getDefaultStr('scale', 'minimap'),
            --     min = 0.1,
            --     max = 5,
            --     bigStep = 0.1,
            --     order = 1
            -- }    
        }
    }

    return generalOptions
end

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    hooksecurefunc(DF:GetModule('Config'), 'AddConfigFrame', function()
        Module:RegisterSettings()
    end)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    -- DF:RegisterModuleOptions(mName, generalOptions)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    if DF.Cata then
        Module.Cata()
    elseif DF.Wrath then
        Module.Wrath()
    else
        Module.Era()
    end

    Module:SetupDialogFrames()

    Module:ApplySettings()
    Module:RegisterOptionScreens()

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)
end

function Module:OnDisable()
end

function Module:RegisterSettings()
    local moduleName = 'Profiles'
    local cat = 'general'
    local function register(name, data)
        data.module = moduleName;
        DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    end

    register('profiles', {order = 3, name = 'Profiles', descr = 'Profiless', isNew = false})
end

function Module:RegisterOptionScreens()
    local options = {
        name = 'Profiles',
        get = getOption,
        set = setOption,
        args = {
            headerCurrentProfile = {type = 'header', name = 'Current Profile', isExpanded = true, order = 1},
            currentProfile = {
                type = 'select',
                name = 'Current Profile',
                desc = L["ProfilesSetActiveProfile"],
                dropdownValuesFunc = Module:GeneratorCurrentProfilesWithDefaults(true, function(name)
                    -- print('IsSelected', name)
                    return Module:GetCurrentProfile() == name;
                end, function(name)
                    -- print('SetSelected', name)
                    Module:SetCurrentProfile(name)
                end),
                group = 'headerCurrentProfile',
                order = 10

            },
            -- headerNewProfile = {type = 'header', name = 'New Profile', order = 20},
            createNewProfile = {
                type = 'execute',
                name = 'New Profile',
                btnName = 'Create',
                desc = L["ProfilesNewProfile"],
                func = function()
                    -- print('func! *NewProfile*')
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
                    StaticPopup_Show('DragonflightUINewProfile')
                end,
                group = 'headerCurrentProfile',
                order = 21
            },
            -- headerCopy = {type = 'header', name = 'Copy From Profile', order = 30},
            -- toCopy = {
            --     type = 'select',
            --     name = 'Copy From',
            --     desc = L["ProfilesCopyFrom"],
            --     dropdownValuesFunc = Module:GeneratorCurrentProfilesWithDefaults(false, function(name)
            --         return getOption({'toCopy'}) == name;
            --     end, function(name)
            --         setOption({'toCopy'}, name)
            --     end),
            --     order = 31
            -- },
            -- copyFromProfile = {
            --     type = 'execute',
            --     name = 'Copy To Current Profile',
            --     btnName = 'Copy',
            --     desc = L["ProfilesOpenCopyDialogue"],
            --     func = function()
            --         -- print('func! *CopyFromProfile*')
            --         PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
            --         StaticPopup_Show('DragonflightUICopyProfile')
            --     end,
            --     order = 32
            -- },
            headerDelete = {type = 'header', name = 'Delete Profile', isExpanded = true, order = 40},
            toDelete = {
                type = 'select',
                name = 'Profile To Delete',
                desc = L["ProfilesDeleteProfile"],
                dropdownValuesFunc = Module:GeneratorCurrentProfilesWithDefaults(false, function(name)
                    return getOption({'toDelete'}) == name;
                end, function(name)
                    setOption({'toDelete'}, name)
                end),
                group = 'headerDelete',
                order = 41
            },
            deleteProfile = {
                type = 'execute',
                name = 'Delete Profile',
                btnName = 'Delete',
                desc = L["ProfilesOpenDeleteDialogue"],
                func = function()
                    -- print('func! *DeleteProfile*')
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
                    StaticPopup_Show('DragonflightUIDeleteProfile')
                end,
                group = 'headerDelete',
                order = 42
            },
            headerImportExport = {type = 'header', name = L["ProfilesImportShareHeader"], isExpanded = true, order = 50},
            importProfile = {
                type = 'execute',
                name = L["ProfilesImportProfile"],
                btnName = L["ProfilesImportProfileButton"],
                desc = L["ProfilesImportProfileDesc"],
                func = function()
                    -- print('func! *DeleteProfile*')
                    Module:ShowImportProfileDialog()
                end,
                group = 'headerImportExport',
                order = 52
            },
            exportProfile = {
                type = 'execute',
                name = L["ProfilesExportProfile"],
                btnName = L["ProfilesExportProfileButton"],
                desc = L["ProfilesExportProfileDesc"],
                func = function()
                    -- print('func! *DeleteProfile*')
                    Module:CopyActiveProfileToClipboard()
                end,
                group = 'headerImportExport',
                order = 53
            }
        }
    }

    local config = {name = 'Profiles', options = options}
    DF.ConfigModule:RegisterSettingsData('profiles', 'general', config)
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame
    local cat = 'General'
    configFrame:RefreshCatSub(cat, 'Profiles')
end

function Module:ApplySettings()
    local db = Module.db.profile
end

function Module:GetCurrentProfile()
    return DF.db:GetCurrentProfile()
end

function Module:SetCurrentProfile(name)
    local current = Module:GetCurrentProfile()
    Module:Print('Set current profile from ' .. current .. ' to ' .. name)
    DF.db:SetProfile(name)
    Module:RefreshOptionScreens()
end

function Module:CopyProfile(name)
    DF.db:CopyProfile(name, false)
    Module:RefreshOptionScreens()
end

function Module:DeleteProfile(name)
    Module:Print('Delete profile ' .. name)

    DF.db:DeleteProfile(name, false)
    Module:RefreshOptionScreens()
end

function Module:GetProfiles()
    local profilesT = DF.db:GetProfiles()
    local profiles = {}

    for k, v in ipairs(profilesT) do profiles[v] = v end

    return profiles
end

function Module:SetupDialogFrames()
    StaticPopupDialogs['DragonflightUINewProfile'] = {
        text = L["ProfilesAddNewProfile"],
        button1 = ACCEPT,
        button2 = CANCEL,
        OnShow = function(self, data)
            --
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
            self.button1:Disable()

            local EditBoxOnTextChanged = function(self, data)
                if self:GetText() ~= '' then
                    self:GetParent().button1:Enable()
                else
                    self:GetParent().button1:Disable()
                end
            end

            self.editBox:SetScript('OnTextChanged', EditBoxOnTextChanged)
        end,
        OnAccept = function(self, data, data2)
            --
            local text = self.editBox:GetText()
            print(L["ProfilesChatNewProfile"] .. text)
            if text == '' or text == ' ' then
                Module:Print(L["ProfilesErrorNewProfile"])
            else
                Module:SetCurrentProfile(text)
            end
        end,
        hasEditBox = true
    }

    StaticPopupDialogs['DragonflightUIDeleteProfile'] = {
        text = 'Delete profile ..',
        button1 = ACCEPT,
        button2 = CANCEL,
        OnShow = function(self, data)
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
            local toDelete = getOption({'toDelete'})

            self.text:SetText(string.format(L["ProfilesDialogueDeleteProfile"], toDelete))
        end,
        OnAccept = function(self, data, data2)
            --         
            local toDelete = getOption({'toDelete'})
            DF:EnableProfileCallbacks(false)
            Module:SetCurrentProfile('Default')
            DF:EnableProfileCallbacks(true)
            Module:DeleteProfile(toDelete)
        end
    }

    StaticPopupDialogs['DragonflightUICopyProfile'] = {
        text = 'Copy profile ..',
        button1 = ACCEPT,
        button2 = CANCEL,
        OnShow = function(self, data)
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
            local toCopy = getOption({'toCopy'})

            self.text:SetText(string.format(L["ProfilesDialogueCopyProfile"], toCopy))

            self.button1:Disable()
            local EditBoxOnTextChanged = function(self, data)
                if self:GetText() ~= '' then
                    self:GetParent().button1:Enable()
                else
                    self:GetParent().button1:Disable()
                end
            end
            self.editBox:SetScript('OnTextChanged', EditBoxOnTextChanged)
        end,
        OnAccept = function(self, data, data2)
            --      
            local text = self.editBox:GetText()
            print(L["ProfilesChatNewProfile"] .. text)
            if text == '' or text == ' ' then
                Module:Print(L["ProfilesErrorNewProfile"])
                return;
            end

            local toCopy = getOption({'toCopy'})

            -- print('copy: OnAccept', toCopy)
            DF:EnableProfileCallbacks(false)
            Module:SetCurrentProfile(text)
            DF:EnableProfileCallbacks(true)
            Module:CopyProfile(toCopy)
        end,
        hasEditBox = true
    }

    do
        StaticPopupDialogs['DragonflightUIExportProfile'] = {
            text = 'Copy profile ..',
            button1 = CLOSE,
            OnShow = function(self, data)
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
                local active = Module:GetCurrentProfile()

                self.text:SetText(string.format(L["EditModeExportProfile"], active))

                local str = Module:GetSerializedString(active)
                Module.ExportFrame.Editbox:SetText(str)
            end,
            OnAccept = function(self, data, data2)
                --  
            end
            -- hasEditBox = true,
            -- editBoxWidth = 200
        }

        local scrollBoxWidth = 370
        local scrollBoxHeight = 120

        local outerFrame = CreateFrame("Frame")
        outerFrame:SetSize(scrollBoxWidth + 80, scrollBoxHeight + 20)

        local scrollFrame = CreateFrame("ScrollFrame", nil, outerFrame, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("CENTER", -10, 0)
        scrollFrame:SetSize(scrollBoxWidth, scrollBoxHeight)

        local editbox = CreateFrame("EditBox", nil, scrollFrame, "InputBoxScriptTemplate")
        editbox:SetMultiLine(true)
        editbox:SetAutoFocus(false)
        editbox:SetFontObject(ChatFontNormal)
        editbox:SetWidth(scrollBoxWidth)
        editbox:SetText("test\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\n")
        editbox:SetCursorPosition(0)
        editbox:SetScript('OnEditFocusGained', function()
            editbox:HighlightText()
        end)

        ---@diagnostic disable-next-line: param-type-mismatch
        scrollFrame:SetScrollChild(editbox)
        outerFrame.Editbox = editbox

        Module.ExportFrame = outerFrame

        DF:LoadAddOn("LibDeflate")
    end

    do
        StaticPopupDialogs['DragonflightUIImportProfile'] = {
            text = 'Copy profile ..',
            button1 = L["EditModeImportLayout"],
            button2 = CANCEL,
            OnShow = function(self, data)
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
                local active = Module:GetCurrentProfile()

                self.text:SetText(string.format(L["EditModeImportProfile"], active))

                local dialog = self;
                local EditBoxOnTextChanged = function(self, data)
                    if self:GetText() ~= '' then
                        dialog.button1:Enable()
                    else
                        dialog.button1:Disable()
                    end
                end

                Module.ImportFrame.Editbox:SetScript('OnTextChanged', EditBoxOnTextChanged)
                Module.ImportFrame.Editbox:SetText('')
                Module.ImportFrame.Editbox:SetFocus()
            end,
            OnAccept = function(self, data, data2)
                --  
                -- local str = Module:GetSerializedString(active)
                -- Module.ImportFrame.Editbox:SetText(str)
                local str = Module.ImportFrame.Editbox:GetText()
                if str == '' or str == ' ' then return; end

                local prof = Module:DeSerializeString(str)
                Module:OverrideProfileWithTable(prof)
            end
            -- hasEditBox = true,
            -- editBoxWidth = 200
        }

        local scrollBoxWidth = 370
        local scrollBoxHeight = 120

        local outerFrame = CreateFrame("Frame")
        outerFrame:SetSize(scrollBoxWidth + 80, scrollBoxHeight + 20)

        local scrollFrame = CreateFrame("ScrollFrame", nil, outerFrame, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("CENTER", -10, 0)
        scrollFrame:SetSize(scrollBoxWidth, scrollBoxHeight)

        local editbox = CreateFrame("EditBox", nil, scrollFrame, "InputBoxScriptTemplate")
        editbox:SetMultiLine(true)
        editbox:SetAutoFocus(false)
        editbox:SetFontObject(ChatFontNormal)
        editbox:SetWidth(scrollBoxWidth)
        -- editbox:SetText("test\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\n")
        editbox:SetCursorPosition(0)

        editbox:SetScript('OnEditFocusGained', function()
            editbox:HighlightText()
        end)

        ---@diagnostic disable-next-line: param-type-mismatch
        scrollFrame:SetScrollChild(editbox)
        outerFrame.Editbox = editbox

        Module.ImportFrame = outerFrame
    end
end

function Module:ShowNewProfileDialog(copyFrom)
    if copyFrom then
        setOption({'toCopy'}, copyFrom)
        StaticPopup_Show('DragonflightUICopyProfile')
    else
        StaticPopup_Show('DragonflightUINewProfile')
    end
end

function Module:ShowDeleteProfileDialog(toDelete)
    if toDelete then
        setOption({'toDelete'}, toDelete)
        StaticPopup_Show('DragonflightUIDeleteProfile')
    end
end

function Module:CopyActiveProfileToClipboard(profile)
    -- print('Module:CopyActiveProfileToClipboard(profile)')
    -- CopyToClipboard(':3')
    StaticPopup_Show('DragonflightUIExportProfile', nil, nil, nil, Module.ExportFrame)
end

function Module:ShowImportProfileDialog()
    -- print('Module:ShowImportProfileDialog()')
    -- CopyToClipboard(':3')
    StaticPopup_Show('DragonflightUIImportProfile', nil, nil, nil, Module.ImportFrame)
end

-- Simple shallow copy for copying defaults
local function copyTable(src, dest)
    if type(dest) ~= "table" then dest = {} end
    if type(src) == "table" then
        for k, v in pairs(src) do
            if type(v) == "table" then
                -- try to index the key first so that the metatable creates the defaults, if set, and use that table
                v = copyTable(v, dest[k])
            end
            dest[k] = v
        end
    end
    return dest
end

function Module:OverrideProfileWithTable(t)
    -- print('Module:OverrideProfileWithTable()')
    -- CopyToClipboard(':3')

    for name, d in pairs(t.namespaces) do copyTable(d, DF.db.children[name].profile) end

    DF:RefreshConfig()
end

function Module:GetSerializedString(profile)
    local fullProfile = {profile = DF.db.profile, namespaces = {}}

    for name, ns in pairs(DF.db.children) do
        --
        fullProfile.namespaces[name] = ns.profile
    end
    -- DevTools_Dump(fullProfile)

    local serial = DF:Serialize(fullProfile)
    -- DevTools_Dump(serial)

    local libDeflate = LibStub:GetLibrary("LibDeflate")
    local cfg = {level = 9}
    local compressed = libDeflate:CompressDeflate(serial, cfg)

    -- DevTools_Dump(compressed)

    local encoded = libDeflate:EncodeForPrint(compressed)
    -- local encoded = libDeflate:EncodeForWoWAddonChannel(compressed)

    -- local test = self:DeSerializeString(encoded)
    -- DevTools_Dump(test)

    return encoded
end

function Module:DeSerializeString(str)
    local libDeflate = LibStub:GetLibrary("LibDeflate")

    local decoded = libDeflate:DecodeForPrint(str)
    ---@diagnostic disable-next-line: param-type-mismatch
    local decompressed = libDeflate:DecompressDeflate(decoded)

    local _, fullProfile = DF:Deserialize(decompressed)

    -- DevTools_Dump(fullProfile)

    return fullProfile
end

function Module:GeneratorCurrentProfilesWithDefaults(withDefaults, IsSelected, SetSelected)
    -- print('Module:GeneratorCurrentProfilesWithDefaults(dropdown, rootDescription)')

    local generator = function(dropdown, rootDescription)
        -- print('generator')
        local profiles = Module:GetProfiles()
        -- DevTools_Dump(profiles)

        -- local tmp = {DF.db.keys.char, DF.db.keys.class, DF.db.keys.faction, DF.db.keys.realm}
        -- local defaultProfiles = {}
        -- for k, v in ipairs(tmp) do defaultProfiles[v] = v; end
        -- DevTools_Dump(defaultProfiles)

        rootDescription:SetTag('TAG?')
        -- rootDescription:CreateTitle('TITLETEST')      

        if withDefaults then
            local radioDefault = rootDescription:CreateRadio('Default', IsSelected, SetSelected, 'Default');

            local divOne = rootDescription:CreateDivider();
        end

        for k, v in pairs(profiles) do
            if k ~= 'Default' then local radio = rootDescription:CreateRadio(v, IsSelected, SetSelected, k); end
        end

    end

    return generator;
end

function Module:GeneratorEditmodeLayout(withDefaults, IsSelected, SetSelected)
    local generator = function(dropdown, rootDescription)
        -- print('generator')
        local profiles = Module:GetProfiles()

        rootDescription:SetTag('MENU_EDIT_MODE_MANAGER')
        -- rootDescription:CreateTitle('TITLETEST')      

        if withDefaults then
            local radio = rootDescription:CreateRadio('Default', IsSelected, SetSelected, 'Default');

            local copyButton = radio:CreateButton(L["EditModeCopyLayout"], function()
                self:ShowNewProfileDialog('Default')
            end);

            radio:CreateButton(L["EditModeRenameLayout"], function()
                -- self:ShowRenameLayoutDialog(index, layoutInfo);
                self:Print('Rename profile not yet implemented - coming soon!')
            end);

            radio:DeactivateSubmenu();

            radio:AddInitializer(function(button, description, menu)
                local gearButton = MenuTemplates.AttachAutoHideGearButton(button);
                gearButton:SetPoint("RIGHT");
                gearButton:SetScript("OnClick", function()
                    description:ForceOpenSubmenu();
                end);

                MenuUtil.HookTooltipScripts(gearButton, function(tooltip)
                    GameTooltip_SetTitle(tooltip, L["EditModeRenameOrCopyLayout"]);
                end);

                local cancelButton = MenuTemplates.AttachAutoHideCancelButton(button);
                cancelButton:SetPoint("RIGHT", gearButton, "LEFT", -3, 0);
                cancelButton:SetScript("OnClick", function()
                    -- self:ShowDeleteLayoutDialog(index, layoutInfo);
                    self:ShowDeleteProfileDialog(v)
                    menu:Close();
                end);

                MenuUtil.HookTooltipScripts(cancelButton, function(tooltip)
                    GameTooltip_SetTitle(tooltip, L["EditModeDeleteLayout"]);
                end);
            end);

            local divOne = rootDescription:CreateDivider();
        end

        for k, v in pairs(profiles) do
            if k ~= 'Default' then
                --
                local radio = rootDescription:CreateRadio(v, IsSelected, SetSelected, k);

                local copyButton = radio:CreateButton(L["EditModeCopyLayout"], function()
                    -- self:ShowNewLayoutDialog(layoutInfo);
                    self:ShowNewProfileDialog(v)
                end);

                radio:CreateButton(L["EditModeRenameLayout"], function()
                    -- self:ShowRenameLayoutDialog(index, layoutInfo);
                    self:Print('Rename profile not yet implemented - coming soon!')
                end);

                radio:DeactivateSubmenu();

                radio:AddInitializer(function(button, description, menu)
                    local gearButton = MenuTemplates.AttachAutoHideGearButton(button);
                    gearButton:SetPoint("RIGHT");
                    gearButton:SetScript("OnClick", function()
                        description:ForceOpenSubmenu();
                    end);

                    MenuUtil.HookTooltipScripts(gearButton, function(tooltip)
                        GameTooltip_SetTitle(tooltip, L["EditModeRenameOrCopyLayout"]);
                    end);

                    local cancelButton = MenuTemplates.AttachAutoHideCancelButton(button);
                    cancelButton:SetPoint("RIGHT", gearButton, "LEFT", -3, 0);
                    cancelButton:SetScript("OnClick", function()
                        -- self:ShowDeleteLayoutDialog(index, layoutInfo);
                        self:ShowDeleteProfileDialog(v)
                        menu:Close();
                    end);

                    MenuUtil.HookTooltipScripts(cancelButton, function(tooltip)
                        GameTooltip_SetTitle(tooltip, L["EditModeDeleteLayout"]);
                    end);
                end);
            end
        end

        if true then
            local divTwo = rootDescription:CreateDivider();

            local presets = {'Modern (preset)', 'Classic (preset)'}
            for k, v in ipairs(presets) do
                local radio = rootDescription:CreateRadio(v, IsSelected, SetSelected, k);
                radio:SetEnabled(false)

                local copyButton = radio:CreateButton(L["EditModeCopyLayout"], function()
                    -- self:ShowNewLayoutDialog(layoutInfo);
                    print('copyss')
                end);

                radio:DeactivateSubmenu();

                radio:AddInitializer(function(button, description, menu)
                    local gearButton = MenuTemplates.AttachAutoHideGearButton(button);
                    gearButton:SetPoint("RIGHT");
                    gearButton:SetScript("OnClick", function()
                        -- self:ShowNewLayoutDialog(layoutInfo);
                        menu:Close();
                    end);
                    gearButton:SetEnabled(false)

                    MenuUtil.HookTooltipScripts(gearButton, function(tooltip)
                        GameTooltip_SetTitle(tooltip, L["EditModeCopyLayout"]);
                    end);
                end);
            end
        end

        rootDescription:CreateDivider();
        -- new layout    
        -- local disabled = GetDisableReason(disableOnMaxLayouts, not disableOnActiveChanges) ~= nil;
        local disabled = false;
        local text = self:GetNewLayoutText(disabled);
        local newLayoutButton = rootDescription:CreateButton(text, function()
            -- self:ShowNewLayoutDialog();      
            self:ShowNewProfileDialog()
        end);
        -- SetPresetEnabledState(newLayoutButton, disableOnMaxLayouts, not disableOnActiveChanges);

        -- import layout
        local importLayoutButton = rootDescription:CreateButton(L["EditModeImportLayout"], function()
            -- self:ShowImportLayoutDialog();
            self:ShowImportProfileDialog()
        end);
        -- SetPresetEnabledState(importLayoutButton, disableOnMaxLayouts, disableOnActiveChanges);

        -- share
        local shareSubmenu = rootDescription:CreateButton(L["EditModeShareLayout"]);
        shareSubmenu:CreateButton(L["EditModeCopyToClipboard"], function()
            -- self:CopyActiveLayoutToClipboard();
            self:CopyActiveProfileToClipboard()
        end);
    end

    return generator;
end

function Module:GetNewLayoutText(disabled)
    local tex = [[Interface\AddOns\DragonflightUI\Textures\Editmode\editmodeui]]
    if disabled then
        return L["EditModeNewLayoutDisabled"]:format(CreateTextureMarkup(tex, 32, 256, 14, 14, 0.03125, 0.53125,
                                                                         0.425781, 0.488281, 0, 0));
    end
    return L["EditModeNewLayout"]:format(CreateTextureMarkup(tex, 32, 256, 14, 14, 0.03125, 0.53125, 0.496094, 0.558594,
                                                             0, 0));
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event)    
end
frame:SetScript('OnEvent', frame.OnEvent)

-- Cata
function Module.Cata()
end

-- Wrath
function Module.Wrath()
end

-- Era
function Module.Era()
end
