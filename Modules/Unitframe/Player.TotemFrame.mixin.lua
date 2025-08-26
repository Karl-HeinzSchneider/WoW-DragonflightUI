local addonName, addonTable = ...;
local DF = addonTable.DF;
local L = addonTable.L;
local Helper = addonTable.Helper;

local subModuleName = 'TotemFrame';
local SubModuleMixin = {};
addonTable.SubModuleMixins[subModuleName] = SubModuleMixin;

function SubModuleMixin:Init()
    self.ModuleRef = DF:GetModule('Unitframe')
    self:SetDefaults()
    self:SetupOptions()
    -- self:SetScript('OnEvent', self.OnEvent);
end
-- ]:SetPoint('TOPLEFT', PlayerFrame, 'BOTTOMLEFT', 99 + 3, 38 - 3)
function SubModuleMixin:SetDefaults()
    local defaults = {
        scale = 1.0,
        anchorFrame = 'PlayerFrame',
        customAnchorFrame = '',
        anchor = 'TOPLEFT',
        anchorParent = 'BOTTOMLEFT',
        x = 99 + 3,
        y = 38 - 3
    };
    self.Defaults = defaults;
end

function SubModuleMixin:SetupOptions()
    local Module = self.ModuleRef;
    local function getDefaultStr(key, sub, extra)
        -- return Module:GetDefaultStr(key, sub)
        local value = self.Defaults[key]
        local defaultFormat = L["SettingsDefaultStringFormat"]
        return string.format(defaultFormat, (extra or '') .. tostring(value))
    end

    local function setDefaultValues()
        Module:SetDefaultValues()
    end

    local function setDefaultSubValues(sub)
        Module:SetDefaultSubValues(sub)
    end

    local function getOption(info)
        return Module:GetOption(info)
    end

    local function setOption(info, value)
        Module:SetOption(info, value)
    end

    local function setPreset(T, preset, sub)
        for k, v in pairs(preset) do
            --
            T[k] = v;
        end
        Module:ApplySettings(sub)
        Module:RefreshOptionScreens()
    end

    local frameTable = {
        {value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'},
        {value = 'PlayerFrame', text = 'PlayerFrame', tooltip = 'descr', label = 'label'}
    }

    local options = {
        name = L["PlayerTotemFrameName"],
        desc = L["PlayerTotemFrameNameDesc"],
        advancedName = 'PlayerTotemFrame',
        sub = 'playerTotemFrame',
        get = getOption,
        set = setOption,
        type = 'group',
        args = {}
    }
    DF.Settings:AddPositionTable(Module, options, 'playerTotemFrame', 'playerTotemFrame', getDefaultStr, frameTable)

    local optionsEditmode = {
        name = 'Pet',
        desc = 'Pet',
        get = getOption,
        set = setOption,
        type = 'group',
        args = {
            resetPosition = {
                type = 'execute',
                name = L["ExtraOptionsPreset"],
                btnName = L["ExtraOptionsResetToDefaultPosition"],
                desc = L["ExtraOptionsPresetDesc"],
                func = function()
                    local dbTable = Module.db.profile.playerTotemFrame
                    local defaultsTable = self.Defaults
                    -- {scale = 1.0, anchor = 'TOPLEFT', anchorParent = 'TOPLEFT', x = -19, y = -4}
                    setPreset(dbTable, {
                        scale = defaultsTable.scale,
                        anchor = defaultsTable.anchor,
                        anchorParent = defaultsTable.anchorParent,
                        anchorFrame = defaultsTable.anchorFrame,
                        x = defaultsTable.x,
                        y = defaultsTable.y
                    })
                end,
                order = 16,
                editmode = true,
                new = false
            }
        }
    }

    self.Options = options;
    self.OptionsEditmode = optionsEditmode;
end

function SubModuleMixin:Setup()
    if not _G['TotemFrame'] then return end
    local function setDefaultSubValues(sub)
        self.ModuleRef:SetDefaultSubValues(sub)
    end

    DF.ConfigModule:RegisterSettingsData('playerTotemFrame', 'unitframes', {
        options = self.Options,
        default = function()
            setDefaultSubValues('playerTotemFrame')
        end
    })
    --
    self:CreateBase()
    self:SkinTotems()

    -- 
    local f = self.BaseFrame

    -- state
    -- Mixin(f, DragonflightUIStateHandlerMixin)
    -- f:InitStateHandler()
    -- editmode

    local EditModeModule = DF:GetModule('Editmode');
    EditModeModule:AddEditModeToFrame(f)

    f.DFEditModeSelection:SetGetLabelTextFunction(function()
        return self.Options.name
    end)

    f.DFEditModeSelection:RegisterOptions({
        options = self.Options,
        extra = self.OptionsEditmode,
        default = function()
            setDefaultSubValues(self.Options.sub)
        end,
        moduleRef = self.ModuleRef,
        showFunction = function()
            --         
            -- fakeWidget.FakePreview:Show()
        end,
        hideFunction = function()
            --
            f:Show()
        end
    });
end

function SubModuleMixin:OnEvent(event, ...)
end

function SubModuleMixin:UpdateState(state)
    self.state = state;
    self:Update();
end

function SubModuleMixin:Update()
    local state = self.state;
    if not state then return end
    if not _G['TotemFrame'] then return end

    local parent;
    if DF.Settings.ValidateFrame(state.customAnchorFrame) then
        parent = _G[state.customAnchorFrame]
    else
        parent = _G[state.anchorFrame]
    end

    local f = self.BaseFrame

    -- f:SetScale(state.scale)
    f:ClearAllPoints()
    f:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)

    if parent == PlayerFrame then
        f:SetParent(parent)
        f:SetScale(state.scale)
    else
        f:SetParent(UIParent)
        -- f:SetScale(PlayerFrame:GetScale() * state.scale)
        f:SetScale(state.scale)
    end
end

function SubModuleMixin:CreateBase()
    local baseFrame = CreateFrame('Frame', 'DragonflightUIPlayerTotemFrame', UIParent);
    baseFrame:SetSize(128, 53);
    -- baseFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0);
    baseFrame:SetClampedToScreen(true)
    -- baseFrame:Hide()
    self.BaseFrame = baseFrame;

    _G['TotemFrame']:ClearAllPoints()
    _G['TotemFrame']:SetPoint('TOPLEFT', baseFrame, 'TOPLEFT', 0, 0)
    _G['TotemFrame']:SetParent(baseFrame)
end

local base = 'Interface\\Addons\\DragonflightUI\\Textures\\'

function SubModuleMixin:SkinTotems()
    for i = 1, 4 do
        local totem = _G['TotemFrameTotem' .. i];

        local bg = _G['TotemFrameTotem' .. i .. 'Background'];
        bg:SetSize(31, 31)
        bg:SetTexture(base .. 'ui-minimap-background')
        bg:ClearAllPoints()
        bg:SetPoint("CENTER", totem, "CENTER")

        local icon = totem.icon
        -- print(icon:GetSize())

        local children = {totem:GetChildren()}
        for j, child in ipairs(children) do
            -- print(j, child, child:GetObjectType())
            --            
            if child:GetObjectType() == 'Frame' and child ~= icon then
                --
                -- print('!')
                local childRegions = {child:GetRegions()}

                for k, v in ipairs(childRegions) do
                    if v:GetObjectType() == 'Texture' then
                        -- 
                        if v:GetDrawLayer() == 'OVERLAY' then
                            --
                            -- print(k, v, v:GetTexture())

                            v:SetSize(31, 31)
                            v:SetTexture(base .. 'minimap-trackingborder')
                            v:SetVertexColor(0.4, 0.4, 0.4) -- TODO
                            v:SetTexCoord(0 / 64, 38 / 64, 0 / 64, 38 / 64)
                            v:ClearAllPoints()
                            v:SetPoint("CENTER", totem, "CENTER")

                            if not totem.DFMask then
                                totem.DFMask = totem:CreateMaskTexture()
                                totem.DFMask:SetTexture(base .. 'tempportraitalphamask')
                                local delta = 0;
                                totem.DFMask:SetPoint('TOPLEFT', totem.icon, 'TOPLEFT', delta, -delta)
                                totem.DFMask:SetPoint('BOTTOMRIGHT', totem.icon, 'BOTTOMRIGHT', -delta, delta)
                                totem.icon.texture:AddMaskTexture(totem.DFMask)

                                totem.icon.cooldown:SetUseCircularEdge(true)
                            end
                        end
                    end
                end

            end
        end
    end
end
