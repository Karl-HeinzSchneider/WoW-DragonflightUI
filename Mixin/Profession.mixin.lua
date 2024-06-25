DragonFlightUIProfessionMixin = {}
local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

function DragonFlightUIProfessionMixin:OnLoad()
    self:SetupFrameStyle()
end

function DragonFlightUIProfessionMixin:OnShow()
    self:UpdateHeader()
end

function DragonFlightUIProfessionMixin:OnHide()

end

function DragonFlightUIProfessionMixin:OnEvent()

end

function DragonFlightUIProfessionMixin:SetupFrameStyle()
    DragonflightUIMixin:ButtonFrameTemplateNoPortrait(self)
    DragonflightUIMixin:MaximizeMinimizeButtonFrameTemplate(self.MinimizeButton)
    self.MinimizeButton:ClearAllPoints()
    self.MinimizeButton:SetPoint('RIGHT', self.ClosePanelButton, 'LEFT', 0, 0)

    local icon = self:CreateTexture('DragonflightUIProfessionIcon')
    icon:SetSize(62, 62)
    icon:SetPoint('TOPLEFT', self, 'TOPLEFT', -5, 7)
    icon:SetDrawLayer('OVERLAY', 6)
    self.Icon = icon

    local pp = self:CreateTexture('DragonflightUIProfessionoIconFrame')
    pp:SetTexture(base .. 'UI-Frame-PortraitMetal-CornerTopLeft')
    pp:SetTexCoord(0.0078125, 0.0078125, 0.0078125, 0.6171875, 0.6171875, 0.0078125, 0.6171875, 0.6171875)
    pp:SetSize(84, 84)
    pp:SetPoint('CENTER', icon, 'CENTER', 0, 0)
    pp:SetDrawLayer('OVERLAY', 7)
    self.PortraitFrame = pp
end

function DragonFlightUIProfessionMixin:UpdateHeader()
    self.NineSlice.Text:SetText('Enchanting')
    self.Icon:SetTexture(136244)
    SetPortraitToTexture(self.Icon, self.Icon:GetTexture())

end

------------------------------
DFProfessionsRecipeListMixin = {}

function DFProfessionsRecipeListMixin:OnLoad()
    print('DFProfessionsRecipeListMixin:OnLoad()')
end

