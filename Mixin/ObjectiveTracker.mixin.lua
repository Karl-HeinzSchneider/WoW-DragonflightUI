local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

DragonflightUIObjectiveTrackerMixin = {}

function DragonflightUIObjectiveTrackerMixin:OnLoad()
end

function DragonflightUIObjectiveTrackerMixin:OnShow()
end

function DragonflightUIObjectiveTrackerMixin:OnEvent()
end

--
DFObjectiveTrackerContainerHeaderMixin = {}

function DFObjectiveTrackerContainerHeaderMixin:OnLoad()
    local tex = base .. 'questtracker2x'
    self.Text:SetText('All Objectives')

    self.Background:SetTexture(tex)
    self.Background:SetTexCoord(0.000976562, 0.586914, 0.470703, 0.626953)
    self.Background:SetSize(300, 40)

    self.MinimizeButton:SetNormalTexture(tex)
    self.MinimizeButton:GetNormalTexture():SetTexCoord(0.928711, 0.963867, 0.115234, 0.189453)
    self.MinimizeButton:SetPushedTexture(tex)
    self.MinimizeButton:GetPushedTexture():SetTexCoord(0.883789, 0.918945, 0.236328, 0.310547)
    self.MinimizeButton:SetHighlightTexture(tex, 'ADD')
    self.MinimizeButton:GetHighlightTexture():SetTexCoord(0.920898, 0.956055, 0.314453, 0.388672)
end

