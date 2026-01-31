local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

function DF.Compatibility:Clique()
    -- print('DF.Compatibility:Clique()')
    local module = DF.API.Modules:GetModule('Unitframe')

    -- player
    local fixPlayer = function()
        _G['PlayerFrameHealthBar']:SetPropagateMouseMotion(true);
        _G['PlayerFrameManaBar']:SetPropagateMouseMotion(true);

        -- pet
        -- _G['PetName']:SetPropagateMouseMotion(true);
        -- _G['PetFrameMyHealPredictionBar']:SetPropagateMouseMotion(true);
        -- _G['PetFrameOtherHealPredictionBar']:SetPropagateMouseMotion(true);

        _G['PetFrameHealthBar']:SetPropagateMouseMotion(true);
        _G['PetFrameHealthBarText']:SetPropagateMouseMotion(true);
        _G['PetFrameHealthBarTextLeft']:SetPropagateMouseMotion(true);
        _G['PetFrameHealthBarTextRight']:SetPropagateMouseMotion(true);

        _G['PetFrameManaBar']:SetPropagateMouseMotion(true);
        _G['PetFrameManaBarText']:SetPropagateMouseMotion(true);
        _G['PetFrameManaBarTextLeft']:SetPropagateMouseMotion(true);
        _G['PetFrameManaBarTextRight']:SetPropagateMouseMotion(true);
    end
    fixPlayer()

    -- target
    local fixTarget = function()
        -- _G['TargetFrameShower']:SetPropagateMouseMotion(true);

        _G['TargetFrameTextureFrame']:SetPropagateMouseMotion(true);
        _G['TargetFrameTextureFrameName']:SetPropagateMouseMotion(true);
        _G['TargetFrameTextureFrameLevelText']:SetPropagateMouseMotion(true);
        _G['TargetFrameTextureFrameUnconsciousText']:SetPropagateMouseMotion(true);

        _G['DragonflightUITargetFrameBackground']:SetPropagateMouseMotion(true);
        -- _G['DragonflightUITargetFrameBorder']:SetPropagateMouseMotion(true);

        _G['TargetFrameHealthBar']:SetPropagateMouseMotion(true);
        _G['TargetFrameTextureFrame'].HealthBarTextLeft:SetPropagateMouseMotion(true);
        _G['TargetFrameTextureFrame'].HealthBarTextRight:SetPropagateMouseMotion(true);

        _G['TargetFrameManaBar']:SetPropagateMouseMotion(true);

        _G['TargetFrameToTHealthBar']:SetPropagateMouseMotion(true);
        _G['TargetFrameToTManaBar']:SetPropagateMouseMotion(true);
    end
    fixTarget()

    C_Timer.After(5, fixTarget)

    -- focus
    local fixFocus = function()
        if not _G['FocusFrame'] then return end
        _G['FocusFrameHealthBarDummy']:SetPropagateMouseMotion(true);
        _G['FocusFrameManaBarDummy']:SetPropagateMouseMotion(true);

        _G['FocusFrameToTHealthBar']:SetPropagateMouseMotion(true);
        _G['FocusFrameToTManaBar']:SetPropagateMouseMotion(true);
    end

    if _G['FocusFrameHealthBarDummy'] and _G['FocusFrameManaBarDummy'] then
        fixFocus();
    else
        -- DF.API.Modules:HookModuleFunction('Unitframe', 'ChangeFocusFrame', function()
        --     fixFocus();
        -- end)
        hooksecurefunc(module.SubFocus, 'ChangeFocusFrame', function()
            fixFocus();
        end)
    end

    -- party
    local function fixParty()
    	if not PartyFrame or not PartyFrame.MemberFrame1 then
    		return
    	end

    	for i = 1, 4 do
    		local f = PartyFrame["MemberFrame" .. i]
    		if f and f.HealthBar and f.ManaBar then
    			local healthbar = f.HealthBar
    			local manabar = f.ManaBar
    
    			healthbar:SetPropagateMouseMotion(true)
    			manabar:SetPropagateMouseMotion(true)
    
    			if healthbar.TextString then
    				healthbar.TextString:SetPropagateMouseMotion(true)
    			end
    			if manabar.TextString then
    				manabar.TextString:SetPropagateMouseMotion(true)
    			end
    
    			for _, bar in pairs({ healthbar, manabar }) do
    				if bar.LeftText then
    					bar.LeftText:SetPropagateMouseMotion(true)
    				end
    				if bar.RightText then
    					bar.RightText:SetPropagateMouseMotion(true)
    				end
    			end
    		end
	    end
    end

    -- Defer until frames exist
    if PartyFrame and PartyFrame.MemberFrame1 then
    	fixParty()
    else
    	C_Timer.After(0, fixParty)
    end
      
end
