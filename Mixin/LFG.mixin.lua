local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

local btnSize = 28

DragonflightUIEyeTemplateMixin = {};

local LFG_EYE_IDLE = "IDLE" -- custom
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

    -- idle
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

        animationGroup:SetLooping('NONE')

        animation:SetOrder(1)
        local size = 44 * 1
        animation:SetFlipBookFrameWidth(size)
        animation:SetFlipBookFrameHeight(size)
        animation:SetFlipBookRows(8)
        animation:SetFlipBookColumns(11)
        animation:SetFlipBookFrames(80)
        animation:SetDuration(2)

        animationGroup:Play()
        -- animationGroup:Pause()
        -- searching:Hide()

        f:Hide()

        self.EyeIdle = f
        self.EyeIdle.EyeIdleLoopAnim = animationGroup
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

    -- found loop
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

    -- poke initial
    do
        local f = CreateFrame('Frame', nil, self)
        f:SetSize(btnSize, btnSize)
        f:SetPoint('CENTER', self, 'CENTER', 0, 0)

        local searchingTexture = f:CreateTexture('DragonflightUILFGMouseoverFlipbookTexture')
        searchingTexture:SetAllPoints()
        searchingTexture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\groupfinder-eye-flipbook-poke-initial')
        -- searchingTexture:SetBlendMode('BLEND')

        local animationGroup = searchingTexture:CreateAnimationGroup()
        local animation = animationGroup:CreateAnimation('Flipbook', 'LFGMouseoverFlipbookAnimation')

        animationGroup:SetLooping('NONE')

        animation:SetOrder(1)
        local size = 44 * 1
        animation:SetFlipBookFrameWidth(size)
        animation:SetFlipBookFrameHeight(size)
        animation:SetFlipBookRows(6)
        animation:SetFlipBookColumns(11)
        animation:SetFlipBookFrames(66)
        animation:SetDuration(1.5)

        f:Hide()

        self.EyePokeInitial = f
        self.EyePokeInitial.EyePokeInitialAnim = animationGroup
    end

    -- poke loop
    do
        local f = CreateFrame('Frame', nil, self)
        f:SetSize(btnSize, btnSize)
        f:SetPoint('CENTER', self, 'CENTER', 0, 0)

        local searchingTexture = f:CreateTexture('DragonflightUILFGMouseoverFlipbookTexture')
        searchingTexture:SetAllPoints()
        searchingTexture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\groupfinder-eye-flipbook-poke-loop')
        -- searchingTexture:SetBlendMode('BLEND')

        local animationGroup = searchingTexture:CreateAnimationGroup()
        local animation = animationGroup:CreateAnimation('Flipbook', 'LFGMouseoverFlipbookAnimation')

        animationGroup:SetLooping('NONE')

        animation:SetOrder(1)
        local size = 44 * 1
        animation:SetFlipBookFrameWidth(size)
        animation:SetFlipBookFrameHeight(size)
        animation:SetFlipBookRows(6)
        animation:SetFlipBookColumns(11)
        animation:SetFlipBookFrames(62)
        animation:SetDuration(1.5)

        f:Hide()

        self.EyePokeLoop = f
        self.EyePokeLoop.EyePokeLoopAnim = animationGroup
    end

    -- poke end
    do
        local f = CreateFrame('Frame', nil, self)
        f:SetSize(btnSize, btnSize)
        f:SetPoint('CENTER', self, 'CENTER', 0, 0)

        local searchingTexture = f:CreateTexture('DragonflightUILFGMouseoverFlipbookTexture')
        searchingTexture:SetAllPoints()
        searchingTexture:SetTexture('Interface\\Addons\\DragonflightUI\\Textures\\groupfinder-eye-flipbook-poke-end')
        -- searchingTexture:SetBlendMode('BLEND')

        local animationGroup = searchingTexture:CreateAnimationGroup()
        local animation = animationGroup:CreateAnimation('Flipbook', 'LFGMouseoverFlipbookAnimation')

        animationGroup:SetLooping('NONE')

        animation:SetOrder(1)
        local size = 44 * 1
        animation:SetFlipBookFrameWidth(size)
        animation:SetFlipBookFrameHeight(size)
        animation:SetFlipBookRows(4)
        animation:SetFlipBookColumns(11)
        animation:SetFlipBookFrames(36)
        animation:SetDuration(1.5)

        f:Hide()

        self.EyePokeEnd = f
        self.EyePokeEnd.EyePokeEndAnim = animationGroup
    end

    -- self.EyeSearchingLoop = f
    -- self.EyeSearchingLoop.EyeSearchingLoopAnim = animationGroup
end

function DragonflightUIEyeTemplateMixin:StartInitialAnimation()
    self:StopAnimating();

    self:PlayAnim(self.EyeInitial, self.EyeInitial.EyeInitialAnim);

    self.currAnim = LFG_EYE_INIT_ANIM;
end

-- Era
function DragonflightUIEyeTemplateMixin:StartIdleAnimation()
    -- print('StartIdleAnimation')
    self:StopAnimating();

    self:PlayAnim(self.EyeIdle, self.EyeIdle.EyeIdleLoopAnim);

    self.currAnim = LFG_EYE_IDLE;
end

function DragonflightUIEyeTemplateMixin:StartSearchingAnimation()
    -- print('StartSearchingAnimation')
    self:StopAnimating();

    self:PlayAnim(self.EyeSearchingLoop, self.EyeSearchingLoop.EyeSearchingLoopAnim);

    self.currAnim = LFG_EYE_SEARCHING_ANIM;
end

function DragonflightUIEyeTemplateMixin:StartHoverAnimation()
    -- print('StartHoverAnimation')
    self:StopAnimating();

    self:PlayAnim(self.EyeMouseOver, self.EyeMouseOver.EyeMouseOverAnim);

    self.currAnim = LFG_EYE_HOVER_ANIM;
end

function DragonflightUIEyeTemplateMixin:StartFoundAnimationInit()
    -- print('StartFoundAnimationInit')
    self:StopAnimating();

    self:PlayAnim(self.EyeFoundInitial, self.EyeFoundInitial.EyeFoundInitialAnim);

    self.currAnim = LFG_EYE_FOUND_INIT_ANIM;
end

function DragonflightUIEyeTemplateMixin:StartFoundAnimationLoop()
    -- print('StartFoundAnimationLoop')
    self:StopAnimating();

    self:PlayAnim(self.EyeFoundLoop, self.EyeFoundLoop.EyeFoundLoopAnim);
    -- self:PlayAnim(self.EyeFoundLoop, self.GlowBackLoop.GlowBackLoopAnim);

    self.currAnim = LFG_EYE_FOUND_LOOP_ANIM;
end

function DragonflightUIEyeTemplateMixin:StartPokeAnimationInitial()
    -- print('StartPokeAnimationInitial')
    self:StopAnimating();

    self:PlayAnim(self.EyePokeInitial, self.EyePokeInitial.EyePokeInitialAnim);

    self.currAnim = LFG_EYE_POKE_INIT_ANIM;
end

function DragonflightUIEyeTemplateMixin:StartPokeAnimationLoop()
    -- print('StartPokeAnimationLoop')
    self:StopAnimating();

    self:PlayAnim(self.EyePokeLoop, self.EyePokeLoop.EyePokeLoopAnim);

    self.currAnim = LFG_EYE_POKE_LOOP_ANIM;
end

function DragonflightUIEyeTemplateMixin:StartPokeAnimationEnd()
    -- print('StartPokeAnimationEnd')
    self:StopAnimating();

    self:PlayAnim(self.EyePokeEnd, self.EyePokeEnd.EyePokeEndAnim);

    self.currAnim = LFG_EYE_POKE_END_ANIM;
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

-- IMPROVED
local LFG_ANGER_INC_VAL = 30;
local LFG_ANGER_DEC_VAL = 1;
local LFG_ANGER_INIT_VAL = 60;
local LFG_ANGER_END_VAL = 75;
local LFG_ANGER_CAP_VAL = 90;
DragonflightUILFGButtonImprovedMixin = {}

function DragonflightUILFGButtonImprovedMixin:Init()
    self:SetSize(btnSize, btnSize)

    self.glowLocks = {};
    self.angerVal = 0;
    self.LastUpdate = GetTime()

    self:EnableMouse(false)

    do
        local eye = CreateFrame('Frame', 'DragonflightUILFGEye', self)
        eye:SetParent(self)
        eye:SetSize(btnSize, btnSize)
        eye:SetPoint('CENTER')
        Mixin(eye, DragonflightUIEyeTemplateMixin)
        eye:OnLoad()

        eye:EnableMouse(false)
        eye:StartInitialAnimation()

        self.Eye = eye
    end

    self:ChangeDefault()
    self:HookScripts()

    self:RegisterEvent("LFG_PROPOSAL_SHOW");
    self:RegisterEvent("LFG_PROPOSAL_FAILED");
    self:RegisterEvent("LFG_LIST_ACTIVE_ENTRY_UPDATE")
end

function DragonflightUILFGButtonImprovedMixin:ChangeDefault()
    if DF.Wrath then
        local def = _G['MiniMapLFGFrame'];

        local high = def:GetHighlightTexture()
        high:SetTexture('')

        local border = _G['MiniMapLFGFrameBorder']
        border:Hide()

        local icon = _G['MiniMapLFGFrameIconTexture']
        icon:SetTexture('')
    elseif DF.Era then
        local def = _G['LFGMinimapFrame'];
    end
end

function DragonflightUILFGButtonImprovedMixin:HookScripts()
    local def;

    if DF.Wrath then
        def = _G['MiniMapLFGFrame']
    elseif DF.Era then
        def = _G['LFGMinimapFrame']
    else
        return;
    end

    def:HookScript('OnShow', function()
        --       
        -- print('OnShow')
        self.Eye:Show()
        self.Eye:StartInitialAnimation();
    end)

    def:HookScript('OnHide', function()
        --       
        -- print('OnHide')
        self.Eye:StopAnimating()
        self.Eye:Hide()
    end)

    def:HookScript('OnEnter', function()
        --     
        -- print('OnEnter')
        self.cursorOnButton = true;

        if (self.Eye:IsStaticMode()) then return; end

        if (self.Eye.currAnim == LFG_EYE_SEARCHING_ANIM or self.Eye.currAnim == LFG_EYE_NONE_ANIM) then
            self.Eye:StartHoverAnimation();
        end

        if DF.Era and GameTooltip:GetOwner() == def then
            --
            -- print('self tooltip')
            -- GameTooltip:ClearAllPoints()
            -- GameTooltip:SetPoint('TOPRIGHT', def, 'BOTTOMLEFT', 0, 0)
        end
    end)

    def:HookScript('OnLeave', function()
        --  
        -- print('OnLeave')
        self.cursorOnButton = false;

        if (self.Eye:IsStaticMode()) then return; end

        if (self.Eye.currAnim == LFG_EYE_HOVER_ANIM) then self.Eye:StartSearchingAnimation(); end
    end)

    def:HookScript('OnUpdate', function()
        --  
        -- print('OnUpdate')
        self:OnUpdate()
    end)

    def:HookScript('OnClick', function()
        --  
        -- print('OnClick')
        -- self:OnUpdate()
        if (button == "RightButton") then
        else
            -- Angry Eye
            self.angerVal = self.angerVal + LFG_ANGER_INC_VAL;
        end
    end)

    self:SetScript('OnEvent', GenerateClosure(self.OnEvent, self))
end

function DragonflightUILFGButtonImprovedMixin:OnUpdate()
    -- print('DragonflightUILFGButtonMixin:OnUpdate()')
    if (self.Eye:IsStaticMode()) then
        -- self.Eye.texture:Show();
        return;
    end

    -- self.Eye.texture:Hide();

    -- Animation state machine
    if (self:IsInitialEyeAnimFinished() or self:IsPokeEndAnimFinished()) then
        if DF.Era then
            self.Eye:StartIdleAnimation();
        else
            self.Eye:StartSearchingAnimation();
        end
        -- self.Eye:StartSearchingAnimation();
    elseif (self:IsFoundInitialAnimFinished()) then
        self.Eye:StartFoundAnimationLoop();
    elseif (self:ShouldStartPokeInitAnim()) then
        self.Eye:StartPokeAnimationInitial();
    elseif (self:IsPokeInitAnimFinished()) then
        self.Eye:StartPokeAnimationLoop();
    elseif (self:ShouldStartPokeEndAnim()) then
        self.Eye:StartPokeAnimationEnd();
    elseif (self:ShouldStartHoverAnim()) then
        self.Eye:StartHoverAnimation();
    end

    self.angerVal = self.angerVal - LFG_ANGER_DEC_VAL;
    self.angerVal = Clamp(self.angerVal, 0, LFG_ANGER_CAP_VAL);
end

function DragonflightUILFGButtonImprovedMixin:OnEvent(self, event, ...)
    -- print('DragonflightUILFGButtonMixin:OnEvent()', event, ...)

    if event == "LFG_PROPOSAL_SHOW" then
        self.Eye:StartFoundAnimationInit();
    elseif event == "LFG_PROPOSAL_FAILED" then
        self.Eye:StartSearchingAnimation();
    elseif event == "LFG_LIST_ACTIVE_ENTRY_UPDATE" then
        if (C_LFGList.HasActiveEntryInfo()) then
            self.Eye:StartSearchingAnimation();
        else
            self.Eye:StartIdleAnimation();
        end
    end
end

function DragonflightUILFGButtonImprovedMixin:IsInitialEyeAnimFinished()
    return self.Eye.currAnim == LFG_EYE_INIT_ANIM and not self.Eye.EyeInitial.EyeInitialAnim:IsPlaying();
end

function DragonflightUILFGButtonImprovedMixin:IsFoundInitialAnimFinished()
    return self.Eye.currAnim == LFG_EYE_FOUND_INIT_ANIM and not self.Eye.EyeFoundInitial.EyeFoundInitialAnim:IsPlaying();
end

function DragonflightUILFGButtonImprovedMixin:ShouldStartHoverAnim()
    return self.cursorOnButton and self.Eye.currAnim == LFG_EYE_SEARCHING_ANIM;
end

function DragonflightUILFGButtonImprovedMixin:ShouldStartPokeInitAnim()
    return self.angerVal >= LFG_ANGER_INIT_VAL and
               (self.Eye.currAnim == LFG_EYE_HOVER_ANIM or self.Eye.currAnim == LFG_EYE_SEARCHING_ANIM or
                   self.Eye.currAnim == LFG_EYE_IDLE);
end

function DragonflightUILFGButtonImprovedMixin:IsPokeInitAnimFinished()
    return self.Eye.currAnim == LFG_EYE_POKE_INIT_ANIM and not self.Eye.EyePokeInitial.EyePokeInitialAnim:IsPlaying();
end

function DragonflightUILFGButtonImprovedMixin:ShouldStartPokeEndAnim()
    return self.angerVal < LFG_ANGER_END_VAL and
               (self.Eye.currAnim == LFG_EYE_POKE_LOOP_ANIM or self:IsPokeInitAnimFinished());
end

function DragonflightUILFGButtonImprovedMixin:IsPokeEndAnimFinished()
    return self.Eye.currAnim == LFG_EYE_POKE_END_ANIM and not self.Eye.EyePokeEnd.EyePokeEndAnim:IsPlaying();
end

