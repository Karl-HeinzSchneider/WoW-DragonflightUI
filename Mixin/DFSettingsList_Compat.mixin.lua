DFSettingsListDropdownContainer_CompatMixin = {}

function DFSettingsListDropdownContainer_CompatMixin:OnLoad()
    -- print('~~DFSettingsListDropdownMixin:OnLoad()');
    DFSettingsListElementBaseMixin.OnLoad(self);

    self.Button:ClearAllPoints()
    -- self.Button:SetPoint('LEFT', self.Text, 'RIGHT', 4 + 32 + 5, 0);
    self.Button:SetPoint('LEFT', self.Text, 'RIGHT', 20, 0);
    -- self.Button:SetEnabled(false)

    local sizeX = 185
    -- self.Button.Dropdown:SetWidth(sizeX)
    -- self.Button:SetWidth(sizeX - 2 * (32 + 5))
    -- self.Button.Dropdown.Text:SetText('TEST')

    -- DevTools_Dump(self.Button.Dropdown)

    local xOffset = -10
    self.Button.IncrementButton:SetPoint("LEFT", self.Button, "RIGHT", xOffset, 0)
    -- self.IncrementButton:SetScript("OnClick", GenerateClosure(self.OnIncrementClicked, self));

    self.Button.DecrementButton:SetPoint("RIGHT", self.Button, "LEFT", -xOffset, 0)
    -- self.DecrementButton:SetScript("OnClick", GenerateClosure(self.OnDecrementClicked, self));

    self.Button.IncrementButton:HookScript('OnClick', function()
        self.Button:OnIncrementClicked()
    end)
    self.Button.DecrementButton:HookScript('OnClick', function()
        self.Button:OnDecrementClicked()
    end)
end

function DFSettingsListDropdownContainer_CompatMixin:Init(node)
    -- print('~~~~DFSettingsListDropdownMixin:Init()');
    local elementData = node:GetData();
    self.ElementData = elementData;
    local args = elementData.args;

    self.Text:SetText(args.name);
    self.Text:Show();

    self:SetTooltip(args.name, args.desc);

    self:SetBaseSmall(elementData.small);

    if elementData.small then
        self.Button:SetWidth(140)
        self.Button:SetPoint('LEFT', self.Text, 'RIGHT', 0 + 45, 0);
    else
        self.Button:SetWidth(200)
        self.Button:SetPoint('LEFT', self.Text, 'RIGHT', 20 + 13, 0);
    end

    -- self.Button.SelectionDetails.SelectionName:SetText(elementData.get({elementData.key}))
    -- self.Button.SelectionDetails.SelectionName:Show()

    if args.dropdownValuesFunc then
        self.Button:SetupMenu(args.dropdownValuesFunc)
    elseif args.dropdownValues then
        local generator = function(dropdown, rootDescription)
            rootDescription:SetTag('TAG?')

            local function IsSelected(name)
                -- print('IsSelected', name)
                return elementData.get({elementData.key}) == name;
            end

            local function SetSelected(name)
                -- print('SetSelected', name)
                elementData.set({elementData.key}, name)
            end

            for k, v in ipairs(args.dropdownValues) do
                --
                local name = v.value;
                local desc = v.text;

                local radio = rootDescription:CreateRadio(desc, IsSelected, SetSelected, name);
            end
        end
        self.Button:SetupMenu(generator)
    else
        self.Button:SetupMenu(function(_, _)
        end)
    end

    self.Button:SetValue(elementData.get({elementData.key}))
end

DFSettingsDropdownButton_CompatMixin = {}

function DFSettingsDropdownButton_CompatMixin:UpdateSteppers()
    -- print('UpdateSteppers')

    local options = self.RootDesc.Options;

    if self.SelectedIndex == 1 then
        self.DecrementButton:Disable();
    else
        self.DecrementButton:Enable();
    end

    if self.SelectedIndex >= self.MaxIndex then
        self.IncrementButton:Disable();
    else
        self.IncrementButton:Enable();
    end
end

function DFSettingsDropdownButton_CompatMixin:OnDecrementClicked()
    -- print('OnDecrementClicked')
    if self.SelectedIndex < 2 then return end

    self.SelectedIndex = self.SelectedIndex - 1

    local selected = self.RootDesc.Options[self.SelectedIndex];
    self:SetValue(selected[4]);
    selected[3](selected[4]);
end

function DFSettingsDropdownButton_CompatMixin:OnIncrementClicked()
    -- print('OnIncrementClicked')
    if self.SelectedIndex >= self.MaxIndex then return end

    self.SelectedIndex = self.SelectedIndex + 1

    local selected = self.RootDesc.Options[self.SelectedIndex];
    self:SetValue(selected[4]);
    selected[3](selected[4]);
end

function DFSettingsDropdownButton_CompatMixin:SetupMenu(generator)
    -- print('SetupMenu')

    local rootDesc = CreateAndInitFromMixin(DFSettingsDropdownMenuRootDescription_CompatMixin)
    generator(_, rootDesc)

    self.RootDesc = rootDesc;
    -- DevTools_Dump(rootDesc.Options)
end

function DFSettingsDropdownButton_CompatMixin:SetValue(val)
    local index = 1;

    for k, v in ipairs(self.RootDesc.Options) do if v[4] == val then index = k; end end

    self.SelectedIndex = index;
    self.MaxIndex = #self.RootDesc.Options

    -- self.SelectionDetails.SelectionName:SetText(val .. '(' .. index .. ')')
    self.SelectionDetails.SelectionName:SetText(val)

    self.SelectionDetails.SelectionName:Show()

    self:UpdateSteppers()
end

DFSettingsDropdownSelectionDetails_CompatMixin = {}

DFSettingsDropdownMenuRootDescription_CompatMixin = {}

function DFSettingsDropdownMenuRootDescription_CompatMixin:Init()
    -- print('~Init~')
    self.Options = {}
end

function DFSettingsDropdownMenuRootDescription_CompatMixin:SetTag()
end

function DFSettingsDropdownMenuRootDescription_CompatMixin:CreateRadio(desc, IsSelected, SetSelected, name)
    table.insert(self.Options, {desc, IsSelected, SetSelected, name})
end

function DFSettingsDropdownMenuRootDescription_CompatMixin:CreateDivider()
end
-- function DFSettingsDropdownMenuRootDescription_CompatMixin:SetTag()
-- end
