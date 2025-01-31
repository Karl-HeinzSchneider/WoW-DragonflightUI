local btnSize = 28

DragonflightUIEyeTemplateMixin = {};

local LFG_EYE_NONE_ANIM = "NONE";
local LFG_EYE_INIT_ANIM = "INITIAL";
local LFG_EYE_SEARCHING_ANIM = "SEARCHING_LOOP";
local LFG_EYE_HOVER_ANIM = "HOVER_ANIM";
local LFG_EYE_FOUND_INIT_ANIM = "FOUND_INIT";
local LFG_EYE_FOUND_LOOP_ANIM = "FOUND_LOOP";
local LFG_EYE_POKE_INIT_ANIM = "POKE_INIT";
local LFG_EYE_POKE_LOOP_ANIM = "POKE_LOOP";
local LFG_EYE_POKE_END_ANIM = "POKE_END";

function DragonflightUIEyeTemplateMixin:OnLoad()
    -- print('DragonflightUIEyeTemplateMixin:OnLoad()')
    self.currActiveAnims = {};
    self.activeAnim = LFG_EYE_NONE_ANIM;
    self.isStatic = false;

    -- init
    do
        local f = CreateFrame('Frame', nil, self)
        f:SetSize(btnSize, btnSize)
        f:SetPoint('CENTER', self, 'CENTER', 0, 0)

        local searchingTexture = f:CreateTexture()
        searchingTexture:SetAllPoints()
        searchingTexture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\groupfinder-eye-flipbook-initial')
        -- searchingTexture:SetBlendMode('BLEND')

        local animationGroup = searchingTexture:CreateAnimationGroup()
        local animation = animationGroup:CreateAnimation('Flipbook', 'LFGSearchingFlipbookAnimation')

        animationGroup:SetLooping('NONE')

        animation:SetOrder(1)
        local size = 44 * 1
        animation:SetFlipBookFrameWidth(size)
        animation:SetFlipBookFrameHeight(size)
        animation:SetFlipBookRows(5)
        animation:SetFlipBookColumns(11)
        animation:SetFlipBookFrames(52)
        animation:SetDuration(1.5)

        -- animationGroup:Play()
        -- animationGroup:Stop()
        -- searching:Hide()

        f:Hide()

        self.EyeInitial = f
        self.EyeInitial.EyeInitialAnim = animationGroup
    end

    -- searching
    do
        local f = CreateFrame('Frame', nil, self)
        f:SetSize(btnSize, btnSize)
        f:SetPoint('CENTER', self, 'CENTER', 0, 0)

        local searchingTexture = f:CreateTexture()
        searchingTexture:SetAllPoints()
        searchingTexture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\groupfinder-eye-flipbook-searching')
        -- searchingTexture:SetBlendMode('BLEND')

        local animationGroup = searchingTexture:CreateAnimationGroup()
        local animation = animationGroup:CreateAnimation('Flipbook', 'LFGSearchingFlipbookAnimation')

        animationGroup:SetLooping('REPEAT')

        animation:SetOrder(1)
        local size = 44 * 1
        animation:SetFlipBookFrameWidth(size)
        animation:SetFlipBookFrameHeight(size)
        animation:SetFlipBookRows(8)
        animation:SetFlipBookColumns(11)
        animation:SetFlipBookFrames(80)
        animation:SetDuration(2)

        -- animationGroup:Play()
        -- animationGroup:Stop()
        -- searching:Hide()

        f:Hide()

        self.EyeSearchingLoop = f
        self.EyeSearchingLoop.EyeSearchingLoopAnim = animationGroup
    end

    -- hover
    do
        local f = CreateFrame('Frame', nil, self)
        f:SetSize(btnSize, btnSize)
        f:SetPoint('CENTER', self, 'CENTER', 0, 0)

        local searchingTexture = f:CreateTexture('DragonflightUILFGMouseoverFlipbookTexture')
        searchingTexture:SetAllPoints()
        searchingTexture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\groupfinder-eye-flipbook-mouseover')
        -- searchingTexture:SetBlendMode('BLEND')

        local animationGroup = searchingTexture:CreateAnimationGroup()
        local animation = animationGroup:CreateAnimation('Flipbook', 'LFGMouseoverFlipbookAnimation')

        animationGroup:SetLooping('NONE')

        animation:SetOrder(1)
        local size = 43 * 1
        animation:SetFlipBookFrameWidth(size)
        animation:SetFlipBookFrameHeight(size)
        animation:SetFlipBookRows(1)
        animation:SetFlipBookColumns(12)
        animation:SetFlipBookFrames(12)
        animation:SetDuration(0.4)

        f:Hide()

        self.EyeMouseOver = f
        self.EyeMouseOver.EyeMouseOverAnim = animationGroup
    end

    -- init found
    do
        local f = CreateFrame('Frame', nil, self)
        f:SetSize(btnSize, btnSize)
        f:SetPoint('CENTER', self, 'CENTER', 0, 0)

        local searchingTexture = f:CreateTexture('DragonflightUILFGMouseoverFlipbookTexture')
        searchingTexture:SetAllPoints()
        searchingTexture:SetTexture(
            'Interface\\Addons\\DragonflightUI\\Textures\\groupfinder-eye-flipbook-found-initial')
        -- searchingTexture:SetBlendMode('BLEND')

        local animationGroup = searchingTexture:CreateAnimationGroup()
        local animation = animationGroup:CreateAnimation('Flipbook', 'LFGMouseoverFlipbookAnimation')

        animationGroup:SetLooping('NONE')

        animation:SetOrder(1)
        local size = 44 * 1
        animation:SetFlipBookFrameWidth(size)
        animation:SetFlipBookFrameHeight(size)
        animation:SetFlipBookRows(7)
        animation:SetFlipBookColumns(11)
        animation:SetFlipBookFrames(70)
        animation:SetDuration(2)

        f:Hide()

        self.EyeFoundInitial = f
        self.EyeFoundInitial.EyeFoundInitialAnim = animationGroup
    end

    -- found
    do
        local f = CreateFrame('Frame', nil, self)
        f:SetSize(btnSize, btnSize)
        f:SetPoint('CENTER', self, 'CENTER', 0, 0)

        local searchingTexture = f:CreateTexture('DragonflightUILFGMouseoverFlipbookTexture')
        searchingTexture:SetAllPoints()
        searchingTexture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\groupfinder-eye-flipbook-found-loop')
        -- searchingTexture:SetBlendMode('BLEND')

        local animationGroup = searchingTexture:CreateAnimationGroup()
        local animation = animationGroup:CreateAnimation('Flipbook', 'LFGMouseoverFlipbookAnimation')

        animationGroup:SetLooping('REPEAT')

        animation:SetOrder(1)
        local size = 44 * 1
        animation:SetFlipBookFrameWidth(size)
        animation:SetFlipBookFrameHeight(size)
        animation:SetFlipBookRows(4)
        animation:SetFlipBookColumns(11)
        animation:SetFlipBookFrames(41)
        animation:SetDuration(1.5)

        f:Hide()

        self.EyeFoundLoop = f
        self.EyeFoundLoop.EyeFoundLoopAnim = animationGroup
    end

    -- self.EyeSearchingLoop = f
    -- self.EyeSearchingLoop.EyeSearchingLoopAnim = animationGroup
end

function DragonflightUIEyeTemplateMixin:StartInitialAnimation()
    self:StopAnimating();

    self:PlayAnim(self.EyeInitial, self.EyeInitial.EyeInitialAnim);

    self.currAnim = LFG_EYE_INIT_ANIM;
end

function DragonflightUIEyeTemplateMixin:StartSearchingAnimation()
    self:StopAnimating();

    self:PlayAnim(self.EyeSearchingLoop, self.EyeSearchingLoop.EyeSearchingLoopAnim);

    self.currAnim = LFG_EYE_SEARCHING_ANIM;
end

function DragonflightUIEyeTemplateMixin:StartHoverAnimation()
    self:StopAnimating();

    self:PlayAnim(self.EyeMouseOver, self.EyeMouseOver.EyeMouseOverAnim);

    self.currAnim = LFG_EYE_HOVER_ANIM;
end

function DragonflightUIEyeTemplateMixin:StartFoundAnimationInit()
    self:StopAnimating();

    self:PlayAnim(self.EyeFoundInitial, self.EyeFoundInitial.EyeFoundInitialAnim);

    self.currAnim = LFG_EYE_FOUND_INIT_ANIM;
end

function DragonflightUIEyeTemplateMixin:StartFoundAnimationLoop()
    self:StopAnimating();

    self:PlayAnim(self.EyeFoundLoop, self.EyeFoundLoop.EyeFoundLoopAnim);
    -- self:PlayAnim(self.EyeFoundLoop, self.GlowBackLoop.GlowBackLoopAnim);

    self.currAnim = LFG_EYE_FOUND_LOOP_ANIM;
end

function DragonflightUIEyeTemplateMixin:SetStaticMode(set)
    self.isStatic = set;

    for _, currAnim in ipairs(self.currActiveAnims) do
        if (self.isStatic) then
            currAnim[1]:Hide();
            currAnim[2]:Pause();
        else
            currAnim[1]:Show();
            currAnim[2]:Play();
        end
    end
end

function DragonflightUIEyeTemplateMixin:IsStaticMode()
    return self.isStatic;
end

function DragonflightUIEyeTemplateMixin:PlayAnim(parentFrame, anim)
    parentFrame:Show();
    anim:Play();

    tinsert(self.currActiveAnims, #(self.currActiveAnims) + 1, {parentFrame, anim});
end

function DragonflightUIEyeTemplateMixin:StopAnimating()
    if self.currAnim == LFG_EYE_NONE_ANIM then return; end
    self.currAnim = LFG_EYE_NONE_ANIM;

    for _, currAnim in ipairs(self.currActiveAnims) do
        currAnim[1]:Hide();
        currAnim[2]:Stop();
    end

    self.currActiveAnims = {};
end

DragonflightUILFGButtonMixin = {}

local LFG_ANGER_INC_VAL = 30;
local LFG_ANGER_DEC_VAL = 1;
local LFG_ANGER_INIT_VAL = 60;
local LFG_ANGER_END_VAL = 75;
local LFG_ANGER_CAP_VAL = 90;

function DragonflightUILFGButtonMixin:Init()
    -- print('Init')
    self:SetSize(btnSize, btnSize)

    do
        local eye = CreateFrame('Frame', 'DragonflightUILFGEye', self)
        eye:SetParent(self)
        eye:SetSize(btnSize, btnSize)
        eye:SetPoint('CENTER')
        Mixin(eye, DragonflightUIEyeTemplateMixin)
        eye:OnLoad()

        -- eye:StartInitialAnimation()

        self.Eye = eye
    end

    self:Hide()

    self:HookScript('OnUpdate', GenerateClosure(self.OnUpdate, self))
    self:HookScript('OnLoad', GenerateClosure(self.OnLoad, self))
    self:HookScript('OnShow', GenerateClosure(self.OnShow, self))
    self:HookScript('OnHide', GenerateClosure(self.OnHide, self))

    self:HookScript('OnEnter', GenerateClosure(self.OnEnter, self))
    self:HookScript('OnLeave', GenerateClosure(self.OnLeave, self))

    self:OnLoad()

    self:Show()

    self:RegisterEvent("LFG_PROPOSAL_SHOW");
    self:RegisterEvent("LFG_PROPOSAL_FAILED");

    self:SetScript('OnEvent', GenerateClosure(self.OnEvent, self))

    --[[  QueueStatusFrame:HookScript('OnShow', function(frame)
        frame:ClearAllPoints()
        frame:SetPoint('TOPRIGHT', self, 'BOTTOMLEFT', 0, 6)
    end) ]]
end

function DragonflightUILFGButtonMixin:HookCata()
    MiniMapLFGFrame:HookScript('OnShow', function()
        --       
        --  self.parent.DFEditMode
        self:Show()
    end)

    MiniMapLFGFrame:HookScript('OnHide', function()
        --  
        if self.DFEditMode then return; end
        self:Hide()
    end)

    MiniMapLFGFrame:HookScript('OnEnter', function()
        --       
        self:OnEnter()
    end)

    MiniMapLFGFrame:HookScript('OnLeave', function()
        --  
        self:OnLeave()
    end)

    local updateInterval = 0.15;
    self.LastUpdate = GetTime()

    function self:SetEditMode(edit)
        -- print('self:SetEditMode(edit)', edit)
        if edit then
            self:Show()

            self:SetScript("OnUpdate", function()
                --
                if not self.DFEditMode then return; end
                -- print('self:OnUpdate')

                -- if self.DFEditModeSelection.isDragging then
                --     --
                --     local state = self.state;

                --     local parent = _G[state.anchorFrame]
                --     MiniMapLFGFrame:SetScale(state.scale)
                --     MiniMapLFGFrame:ClearAllPoints()
                --     MiniMapLFGFrame:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
                -- end
                if GetTime() - self.LastUpdate >= updateInterval then
                    self.LastUpdate = GetTime()
                    -- print('self:OnUpdate') 

                    local state = self.state;

                    local parent = _G[state.anchorFrame]
                    MiniMapLFGFrame:SetScale(state.scale)
                    MiniMapLFGFrame:ClearAllPoints()
                    MiniMapLFGFrame:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
                end
            end)
        else
            self:SetShown(MiniMapLFGFrame:IsShown());

            self:SetScript("OnUpdate", nil);
        end
    end
end

function DragonflightUILFGButtonMixin:UpdateState(state)
    self.state = state;
    self:Update()
end

function DragonflightUILFGButtonMixin:Update()
    -- print('DragonflightUILFGButtonMixin:Update()')
    local state = self.state;

    local parent = _G[state.anchorFrame]
    self:SetScale(state.scale)
    self:ClearAllPoints()
    self:SetPoint(state.anchor, parent, state.anchorParent, state.x, state.y)
end

function DragonflightUILFGButtonMixin:OnLoad()
    -- print('DragonflightUILFGButtonMixin:OnLoad()')
    -- self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    self.glowLocks = {};
    self.angerVal = 0;

    -- self:HookScript('OnClick', GenerateClosure(self.OnClick, self)) 

    if MiniMapLFGFrame:IsShown() then self:Show() end

    self:EnableMouse(false)
end

function DragonflightUILFGButtonMixin:OnShow()
    -- print('DragonflightUILFGButtonMixin:OnShow()')

    self.Eye:Show()
    self.Eye:StartInitialAnimation();
end

function DragonflightUILFGButtonMixin:OnHide()
    -- print('DragonflightUILFGButtonMixin:OnHide()')
    QueueStatusFrame:Hide();

    self.Eye:StopAnimating()
    self.Eye:Hide()
end

function DragonflightUILFGButtonMixin:OnEnter()
    -- print('DragonflightUILFGButtonMixin:OnEnter()')
    self.cursorOnButton = true;

    if (self.Eye.currAnim == LFG_EYE_SEARCHING_ANIM or self.Eye.currAnim == LFG_EYE_NONE_ANIM) then
        self.Eye:StartHoverAnimation();
    end

    QueueStatusFrame:Show();
end

function DragonflightUILFGButtonMixin:OnLeave()
    -- print('DragonflightUILFGButtonMixin:OnLeave()')
    self.cursorOnButton = false;

    if (self.Eye.currAnim == LFG_EYE_HOVER_ANIM) then self.Eye:StartSearchingAnimation(); end

    QueueStatusFrame:Hide();
end

function DragonflightUILFGButtonMixin:OnUpdate()
    -- print('DragonflightUILFGButtonMixin:OnUpdate()')

    -- Animation state machine
    if (self:IsInitialEyeAnimFinished()) then
        self.Eye:StartSearchingAnimation();
    elseif (self:IsFoundInitialAnimFinished()) then
        self.Eye:StartFoundAnimationLoop();
    elseif (self:ShouldStartHoverAnim()) then
        self.Eye:StartHoverAnimation();
    end
end

function DragonflightUILFGButtonMixin:OnEvent(self, event, ...)
    print('DragonflightUILFGButtonMixin:OnEvent()', event, ...)

    if event == "LFG_PROPOSAL_SHOW" then
        self.Eye:StartFoundAnimationInit();
    elseif event == "LFG_PROPOSAL_FAILED" then
        self.Eye:StartSearchingAnimation();
    end
end

function DragonflightUILFGButtonMixin:OnClick(self, button)
    -- print('DragonflightUILFGButtonMixin', button)
    if (button == "RightButton") then
        -- QueueStatusDropDown_Show(self.DropDown, self:GetName());
    end
    MiniMapLFGFrame_OnClick(MiniMapLFGFrame, button)

end

function DragonflightUILFGButtonMixin:IsInitialEyeAnimFinished()
    return self.Eye.currAnim == LFG_EYE_INIT_ANIM and not self.Eye.EyeInitial.EyeInitialAnim:IsPlaying();
end

function DragonflightUILFGButtonMixin:IsFoundInitialAnimFinished()
    return self.Eye.currAnim == LFG_EYE_FOUND_INIT_ANIM and not self.Eye.EyeFoundInitial.EyeFoundInitialAnim:IsPlaying();
end

function DragonflightUILFGButtonMixin:ShouldStartHoverAnim()
    return self.cursorOnButton and self.Eye.currAnim == LFG_EYE_SEARCHING_ANIM;
end

