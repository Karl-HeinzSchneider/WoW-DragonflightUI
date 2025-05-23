DragonflightUISpellFlyoutMixin = CreateFromMixins(DragonflightUIActionbarMixin)

function DragonflightUISpellFlyoutMixin:OnLoad()
    print('DragonflightUISpellFlyoutMixin:OnLoad()')
end

function DragonflightUISpellFlyoutMixin:InitFlyoutButtons()
    print('DragonflightUISpellFlyoutMixin:InitFlyoutButtons()')

    local t = {}

    for i = 1, 2 do
        local btn = CreateFrame("Button", 'Button' .. i, self)
        btn:SetSize(42, 42)
        t[i] = btn;
    end

    self:SetButtons(t);
end
