------------
local activeSpec = 1
local selectedSpec = 1;
local frameRef = nil
------------

DragonflightUITalentsPanelMixin = {}

local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

TALENT_TOOLTIP_RESETTALENTGROUP = "Click to reset your preview talent points."
TALENT_TOOLTIP_LEARNTALENTGROUP = "Click to finalize your preview talent points."

local TALENT_INFO = {
    ["default"] = {
        [1] = {color = {r = 1.0, g = 0.72, b = 0.1}},
        [2] = {color = {r = 1.0, g = 0.0, b = 0.0}},
        [3] = {color = {r = 0.3, g = 0.5, b = 1.0}}
    },

    ["DEATHKNIGHT"] = {
        [1] = {
            -- Blood
            color = {r = 1.0, g = 0.0, b = 0.0}
        },
        [2] = {
            -- Frost
            color = {r = 0.3, g = 0.5, b = 1.0}
        },
        [3] = {
            -- Unholy
            color = {r = 0.2, g = 0.8, b = 0.2}
        }
    },

    ["DRUID"] = {
        [1] = {
            -- Balance
            color = {r = 0.8, g = 0.3, b = 0.8}
        },
        [2] = {
            -- Feral
            color = {r = 1.0, g = 0.0, b = 0.0}
        },
        [3] = {
            -- Restoration
            color = {r = 0.4, g = 0.8, b = 0.2}
        }
    },

    ["HUNTER"] = {
        [1] = {
            -- Beast Mastery
            color = {r = 1.0, g = 0.0, b = 0.3}
        },
        [2] = {
            -- Marksmanship
            color = {r = 0.3, g = 0.6, b = 1.0}
        },
        [3] = {
            -- Survival
            color = {r = 1.0, g = 0.6, b = 0.0}
        }
    },

    ["MAGE"] = {
        [1] = {
            -- Arcane
            color = {r = 0.7, g = 0.2, b = 1.0}
        },
        [2] = {
            -- Fire
            color = {r = 1.0, g = 0.5, b = 0.0}
        },
        [3] = {
            -- Frost
            color = {r = 0.3, g = 0.6, b = 1.0}
        }
    },

    ["PALADIN"] = {
        [1] = {
            -- Holy
            color = {r = 1.0, g = 0.5, b = 0.0}
        },
        [2] = {
            -- Protection
            color = {r = 0.3, g = 0.5, b = 1.0}
        },
        [3] = {
            -- Retribution
            color = {r = 1.0, g = 0.0, b = 0.0}
        }
    },

    ["PRIEST"] = {
        [1] = {
            -- Discipline
            color = {r = 1.0, g = 0.5, b = 0.0}
        },
        [2] = {
            -- Holy
            color = {r = 0.6, g = 0.6, b = 1.0}
        },
        [3] = {
            -- Shadow
            color = {r = 0.7, g = 0.4, b = 0.8}
        }
    },

    ["ROGUE"] = {
        [1] = {
            -- Assassination
            color = {r = 0.5, g = 0.8, b = 0.5}
        },
        [2] = {
            -- Combat
            color = {r = 1.0, g = 0.5, b = 0.0}
        },
        [3] = {
            -- Subtlety
            color = {r = 0.3, g = 0.5, b = 1.0}
        }
    },

    ["SHAMAN"] = {
        [1] = {
            -- Elemental
            color = {r = 0.8, g = 0.2, b = 0.8}
        },
        [2] = {
            -- Enhancement
            color = {r = 0.3, g = 0.5, b = 1.0}
        },
        [3] = {
            -- Restoration
            color = {r = 0.2, g = 0.8, b = 0.4}
        }
    },

    ["WARLOCK"] = {
        [1] = {
            -- Affliction
            color = {r = 0.0, g = 1.0, b = 0.6}
        },
        [2] = {
            -- Demonology
            color = {r = 1.0, g = 0.0, b = 0.0}
        },
        [3] = {
            -- Destruction
            color = {r = 1.0, g = 0.5, b = 0.0}
        }
    },

    ["WARRIOR"] = {
        [1] = {
            -- Arms
            color = {r = 1.0, g = 0.72, b = 0.1}
        },
        [2] = {
            -- Fury
            color = {r = 1.0, g = 0.0, b = 0.0}
        },
        [3] = {
            -- Protection
            color = {r = 0.3, g = 0.5, b = 1.0}
        }
    },

    ["PET_409"] = {
        -- Tenacity
        [1] = {color = {r = 1.0, g = 0.1, b = 1.0}}
    },

    ["PET_410"] = {
        -- Ferocity
        [1] = {color = {r = 1.0, g = 0.0, b = 0.0}}
    },

    ["PET_411"] = {
        -- Cunning
        [1] = {color = {r = 0.0, g = 0.6, b = 1.0}}
    }
};

local TALENT_BRANCH_TEXTURECOORDS = {
    up = {[1] = {0.12890625, 0.25390625, 0, 0.484375}, [-1] = {0.12890625, 0.25390625, 0.515625, 1.0}},
    down = {[1] = {0, 0.125, 0, 0.484375}, [-1] = {0, 0.125, 0.515625, 1.0}},
    left = {[1] = {0.2578125, 0.3828125, 0, 0.5}, [-1] = {0.2578125, 0.3828125, 0.5, 1.0}},
    right = {[1] = {0.2578125, 0.3828125, 0, 0.5}, [-1] = {0.2578125, 0.3828125, 0.5, 1.0}},
    topright = {[1] = {0.515625, 0.640625, 0, 0.5}, [-1] = {0.515625, 0.640625, 0.5, 1.0}},
    topleft = {[1] = {0.640625, 0.515625, 0, 0.5}, [-1] = {0.640625, 0.515625, 0.5, 1.0}},
    bottomright = {[1] = {0.38671875, 0.51171875, 0, 0.5}, [-1] = {0.38671875, 0.51171875, 0.5, 1.0}},
    bottomleft = {[1] = {0.51171875, 0.38671875, 0, 0.5}, [-1] = {0.51171875, 0.38671875, 0.5, 1.0}},
    tdown = {[1] = {0.64453125, 0.76953125, 0, 0.5}, [-1] = {0.64453125, 0.76953125, 0.5, 1.0}},
    tup = {[1] = {0.7734375, 0.8984375, 0, 0.5}, [-1] = {0.7734375, 0.8984375, 0.5, 1.0}}
};

local TALENT_ARROW_TEXTURECOORDS = {
    top = {[1] = {0, 0.5, 0, 0.5}, [-1] = {0, 0.5, 0.5, 1.0}},
    right = {[1] = {1.0, 0.5, 0, 0.5}, [-1] = {1.0, 0.5, 0.5, 1.0}},
    left = {[1] = {0.5, 1.0, 0, 0.5}, [-1] = {0.5, 1.0, 0.5, 1.0}}
};

function DragonflightUITalentsPanelMixin:OnLoad()
    self.TALENT_BRANCH_ARRAY = {};
    self.BUTTON_ARRAY = {}
    for i = 1, 7 do
        self.TALENT_BRANCH_ARRAY[i] = {};
        self.BUTTON_ARRAY[i] = {};
        for j = 1, 4 do
            self.TALENT_BRANCH_ARRAY[i][j] = {
                id = nil,
                up = 0,
                left = 0,
                right = 0,
                down = 0,
                leftArrow = 0,
                rightArrow = 0,
                topArrow = 0
            };
            self.BUTTON_ARRAY[i][j] = nil
        end
    end

    self.ArrowIndex = 1
    self.BranchIndex = 1
end

function DragonflightUITalentsPanelMixin:OnShow()
end

function DragonflightUITalentsPanelMixin:OnHide()
end

function DragonflightUITalentsPanelMixin:OnEvent()
end

function DragonflightUITalentsPanelMixin:Init(id)
    self.ID = id
    local panel = self:GetName()

    for i = 1, 28 do
        local buttonName = panel .. 'Talent' .. i
        local button = _G[buttonName]

        button.panelID = id
        button:SetID(i)
        button.talentID = i

        local anchorFrame = CreateFrame('FRAME', nil, self)
        anchorFrame:SetSize(30, 30)
        anchorFrame:SetPoint('CENTER', self, 'CENTER', 0, 0)

        button:ClearAllPoints()
        button:SetPoint('CENTER', anchorFrame, 'CENTER', 0, 0)

        button.anchorFrame = anchorFrame

        -- events

        button:SetScript('OnEnter', function(self)
            --                    
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
            GameTooltip:SetTalent(id, i)

            C_Timer.After(0, function()
                if (GameTooltip:IsOwned(self)) then GameTooltip:SetTalent(id, i) end
            end)

            C_Timer.After(1, function()
                if (GameTooltip:IsOwned(self)) then GameTooltip:SetTalent(id, i) end
            end)
        end)

        button:SetScript('OnEvent', function(self, event, ...)
            --          
            if (GameTooltip:IsOwned(self)) then GameTooltip:SetTalent(id, i) end
        end)

        button:SetScript('OnClick', function(self, button)
            --                    
            DragonflightUITalentsPanelMixin:ButtonOnClick(self, button)
        end)

        button:RegisterEvent("PREVIEW_TALENT_POINTS_CHANGED");
        button:RegisterEvent("PLAYER_TALENT_UPDATE");
        button:RegisterEvent("PET_TALENT_UPDATE");
    end

    self.RoleIcon = _G[panel .. 'RoleIcon']
    self.RoleIcon2 = _G[panel .. 'RoleIcon2']
    DragonflightUITalentsPanelMixin:UpdateRoleIcon(self, id)
end

function DragonflightUITalentsPanelMixin:ButtonOnClick(self, button)
    -- print('DragonflightUITalentsPanelMixin:ButtonOnClick(self, button)', self:GetName(), button)
    local panelID = self.panelID
    local talentID = self.talentID

    if (IsModifiedClick("CHATLINK")) then
        --
        local link = GetTalentLink(panelID, talentID)
        if link then ChatEdit_InsertLink(link) end
    else
        --
        if button == 'LeftButton' then
            --
            if (GetCVarBool("previewTalentsOption")) then
                AddPreviewTalentPoints(panelID, talentID, 1, false, selectedSpec)
            else
                ---@diagnostic disable-next-line: redundant-parameter
                LearnTalent(panelID, talentID)
            end
        elseif button == 'RightButton' then
            --          

            if (GetCVarBool("previewTalentsOption")) then
                --
                AddPreviewTalentPoints(panelID, talentID, -1, false, selectedSpec)
            end
        end
        PlayerTalentFrame.UpdateDFHeaderText()
    end
end

function DragonflightUITalentsPanelMixin:GetUnspetTalentPoints(spec)
    local level = UnitLevel('player')
    local maxPoints = level - 9

    for i = 1, 3 do
        local id, name, description, iconTexture, pointsSpent, background, previewPointsSpent, isUnlocked =
            GetTalentTabInfo(i, false, false, spec)
        maxPoints = maxPoints - pointsSpent - previewPointsSpent
    end
    return maxPoints
end

function DragonflightUITalentsPanelMixin:Refresh()
    --   print('DragonflightUITalentsPanelMixin:Refresh()', self.ID)

    local panelID = self.ID
    local panel = self:GetName()
    local preview = GetCVarBool("previewTalentsOption");

    local id, name, description, iconTexture, pointsSpent, background, previewPointsSpent, isUnlocked =
        GetTalentTabInfo(panelID, false, false, selectedSpec)
    local tabPointsSpent = pointsSpent + previewPointsSpent
    -- print('TalentTab', id, pointsSpent, previewPointsSpent)
    -- print(id, name, description, iconTexture, pointsSpent, background, previewPointsSpent, isUnlocked) 

    local isActiveTalentGroup = selectedSpec == activeSpec

    -- header
    do
        local headerName = _G[panel .. 'Name']
        headerName:SetText(name)

        local headerIcon = _G[panel .. 'HeaderIconIcon']
        headerIcon:SetTexture(iconTexture)

        local headerPointsSpent = _G[panel .. 'HeaderIconPointsSpent']
        headerPointsSpent:SetText(pointsSpent + previewPointsSpent)
    end

    -- header color

    do
        local talentInfo;
        local classDisplayName, class = UnitClass("player");
        talentInfo = TALENT_INFO[class] or TALENT_INFO["default"];

        local color = talentInfo and talentInfo[panelID] and talentInfo[panelID].color;
        if (color) then
            _G[panel .. 'HeaderBackground']:SetVertexColor(color.r, color.g, color.b);
            if (_G[panel .. 'Summary']) then
                _G[panel .. 'SummaryBorder']:SetVertexColor(color.r, color.g, color.b);
                _G[panel .. 'SummaryIconGlow']:SetVertexColor(color.r, color.g, color.b);
            end
        else
            _G[panel .. 'HeaderBackground']:SetVertexColor(1, 1, 1);
        end
    end

    -- background
    do
        local bg = _G[panel .. 'BackgroundTopLeft']
        bg:SetTexture(background)
        bg:Show()

        local bgBase = "Interface\\TalentFrame\\" .. background .. "-";

        local backgroundPiece = _G[panel .. "BackgroundTopLeft"];
        backgroundPiece:SetTexture(bgBase .. "TopLeft");
        SetDesaturation(backgroundPiece, not isActiveTalentGroup);
        backgroundPiece = _G[panel .. "BackgroundTopRight"];
        backgroundPiece:SetTexture(bgBase .. "TopRight");
        SetDesaturation(backgroundPiece, not isActiveTalentGroup);
        backgroundPiece = _G[panel .. "BackgroundBottomLeft"];
        backgroundPiece:SetTexture(bgBase .. "BottomLeft");
        SetDesaturation(backgroundPiece, not isActiveTalentGroup);
        backgroundPiece = _G[panel .. "BackgroundBottomRight"];
        backgroundPiece:SetTexture(bgBase .. "BottomRight");
        SetDesaturation(backgroundPiece, not isActiveTalentGroup);
    end

    -- talents

    do
        --
        local numTalents = GetNumTalents(panelID);

        -- local unspentTalentPoints, learnedProfessions = UnitCharacterPoints("player")
        local unspentTalentPoints = DragonflightUITalentsPanelMixin:GetUnspetTalentPoints(selectedSpec)

        self:ResetBranches()
        -- tabPointsSpent
        for i = 1, 28 do
            local buttonName = panel .. 'Talent' .. i
            local button = _G[buttonName]
            local forceDesaturated, tierUnlocked;
            if i <= numTalents then
                local name, iconPath, tier, column, currentRank, maxRank, meetsPrereq, previewRank, meetsPreviewPrereq,
                ---@diagnostic disable-next-line: param-type-mismatch
                      isExceptional, goldBorder = GetTalentInfo(panelID, i, false, false, selectedSpec);

                if name then
                    local displayRank;
                    if (preview) then
                        displayRank = previewRank;
                    else
                        displayRank = currentRank;
                    end

                    _G[buttonName .. 'Rank']:SetText(displayRank)

                    self.BUTTON_ARRAY[tier][column] = button
                    self.TALENT_BRANCH_ARRAY[tier][column].id = i

                    -- position
                    do
                        local offsetX = 20
                        local offsetY = -52
                        local size = 46

                        local x = ((column - 1) * size) + offsetX
                        local y = -((tier - 1) * size) + offsetY

                        -- button:SetSize(25, 25)
                        local anchor = button.anchorFrame
                        anchor:ClearAllPoints()
                        anchor:SetPoint('TOPLEFT', self, 'TOPLEFT', x, y)

                        button:SetScale(30 / 37)
                    end

                    if (unspentTalentPoints <= 0 or not isActiveTalentGroup) and displayRank == 0 then
                        forceDesaturated = 1;
                    else
                        forceDesaturated = nil;
                    end

                    local tierUnlocked;
                    -- is this talent's tier unlocked?
                    if (((tier - 1) * (PLAYER_TALENTS_PER_TIER) <= tabPointsSpent)) then
                        tierUnlocked = 1;
                    else
                        tierUnlocked = nil;
                    end

                    SetItemButtonTexture(button, iconPath);

                    -- Talent must meet prereqs or the player must have no points to spend
                    --[[    local prereqsSet = TalentFrame_SetPrereqs(TalentFrame, tier, column, forceDesaturated, tierUnlocked,
                                                              preview, GetTalentPrereqs(selectedTab, i,
                                                                                        TalentFrame.inspect,
                                                                                        TalentFrame.pet,
                                                                                        TalentFrame.talentGroup)); ]]
                    local prereqsSet = self:SetPrereqs(tier, column, forceDesaturated, tierUnlocked, preview,
                                                       GetTalentPrereqs(panelID, i, false, false, selectedSpec))
                    if (prereqsSet and ((preview and meetsPreviewPrereq) or (not preview and meetsPrereq))) then
                        SetItemButtonDesaturated(button, nil);

                        if (displayRank < maxRank) then
                            -- Rank is green if not maxed out
                            _G[buttonName .. "Slot"]:SetVertexColor(0.1, 1.0, 0.1);
                            _G[buttonName .. "Rank"]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g,
                                                                  GREEN_FONT_COLOR.b);
                        else
                            _G[buttonName .. "Slot"]:SetVertexColor(1.0, 0.82, 0);
                            _G[buttonName .. "Rank"]:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g,
                                                                  NORMAL_FONT_COLOR.b);
                        end
                        _G[buttonName .. "RankBorder"]:Show();
                        _G[buttonName .. "Rank"]:Show();
                    else
                        SetItemButtonDesaturated(button, 1, 0.65, 0.65, 0.65);
                        _G[buttonName .. "Slot"]:SetVertexColor(0.5, 0.5, 0.5);
                        if (displayRank == 0) then
                            _G[buttonName .. "RankBorder"]:Hide();
                            _G[buttonName .. "Rank"]:Hide();
                        else
                            _G[buttonName .. "RankBorder"]:SetVertexColor(0.5, 0.5, 0.5);
                            _G[buttonName .. "Rank"]:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g,
                                                                  GRAY_FONT_COLOR.b);
                        end
                    end

                    button:Show()
                else
                    button:Hide()
                end
            else
                button:Hide()
            end
        end

        self.ArrowIndex = 1
        self.BranchIndex = 1

        local node;
        local textureIndex = 1;
        local xOffset, yOffset;
        local texCoords;
        local tempNode;

        --  local offsetX = 20
        --  local offsetY = -52
        -- local size = 46
        local talentButtonSize = 30
        local initialOffsetX = 20
        local initialOffsetY = 52
        local buttonSpacingX = 46
        local buttonSpacingY = 46

        for i = 1, 7 do
            for j = 1, 4 do
                --
                node = self.TALENT_BRANCH_ARRAY[i][j];

                -- Setup offsets
                xOffset = ((j - 1) * buttonSpacingX) + initialOffsetX + (self.branchOffsetX or 0);
                yOffset = -((i - 1) * buttonSpacingY) - initialOffsetY + (self.branchOffsetY or 0);

                -- DragonflightUITalentsPanelMixin:SetBranchTexture(tier, column, texCoords, xOffset, yOffset, xSize, ySize)

                -- Always draw Right and Down branches, never draw Left and Up branches as those will be drawn by the preceeding talent
                if (node.down ~= 0) then
                    self:SetBranchTexture(i, j, TALENT_BRANCH_TEXTURECOORDS["down"][node.down], xOffset,
                                          yOffset - talentButtonSize, talentButtonSize,
                                          buttonSpacingY - talentButtonSize);
                end
                if (node.right ~= 0) then
                    self:SetBranchTexture(i, j, TALENT_BRANCH_TEXTURECOORDS["right"][node.right],
                                          xOffset + talentButtonSize, yOffset, buttonSpacingX - talentButtonSize,
                                          talentButtonSize);
                end

                if (node.id) then
                    -- There is a talent in this slot; draw arrows
                    local arrowInsetX, arrowInsetY = (self.arrowInsetX or 0), (self.arrowInsetY or 0);
                    if (node.goldBorder) then
                        arrowInsetX = arrowInsetX - TALENT_GOLD_BORDER_WIDTH;
                        arrowInsetY = arrowInsetY - TALENT_GOLD_BORDER_WIDTH;
                    end

                    if (node.rightArrow ~= 0) then
                        self:SetArrowTexture(i, j, TALENT_ARROW_TEXTURECOORDS["right"][node.rightArrow],
                                             xOffset + talentButtonSize / 2 - arrowInsetX, yOffset);
                    end
                    if (node.leftArrow ~= 0) then
                        self:SetArrowTexture(i, j, TALENT_ARROW_TEXTURECOORDS["left"][node.leftArrow],
                                             xOffset - talentButtonSize / 2 + arrowInsetX, yOffset);
                    end
                    if (node.topArrow ~= 0) then
                        self:SetArrowTexture(i, j, TALENT_ARROW_TEXTURECOORDS["top"][node.topArrow], xOffset,
                                             yOffset + talentButtonSize / 2 - arrowInsetY);
                    end
                else
                    -- No talent; draw branches
                    if (node.up ~= 0 and node.left ~= 0 and node.right ~= 0) then
                        self:SetBranchTexture(i, j, TALENT_BRANCH_TEXTURECOORDS["tup"][node.up], xOffset, yOffset);
                    elseif (node.down ~= 0 and node.left ~= 0 and node.right ~= 0) then
                        self:SetBranchTexture(i, j, TALENT_BRANCH_TEXTURECOORDS["tdown"][node.down], xOffset, yOffset);
                    elseif (node.left ~= 0 and node.down ~= 0) then
                        self:SetBranchTexture(i, j, TALENT_BRANCH_TEXTURECOORDS["topright"][node.left], xOffset, yOffset);
                    elseif (node.left ~= 0 and node.up ~= 0) then
                        self:SetBranchTexture(i, j, TALENT_BRANCH_TEXTURECOORDS["bottomright"][node.left], xOffset,
                                              yOffset);
                    elseif (node.left ~= 0 and node.right ~= 0) then
                        self:SetBranchTexture(i, j, TALENT_BRANCH_TEXTURECOORDS["right"][node.right],
                                              xOffset + talentButtonSize, yOffset);
                    elseif (node.right ~= 0 and node.down ~= 0) then
                        self:SetBranchTexture(i, j, TALENT_BRANCH_TEXTURECOORDS["topleft"][node.right], xOffset, yOffset);
                    elseif (node.right ~= 0 and node.up ~= 0) then
                        self:SetBranchTexture(i, j, TALENT_BRANCH_TEXTURECOORDS["bottomleft"][node.right], xOffset,
                                              yOffset);
                    elseif (node.up ~= 0 and node.down ~= 0) then
                        self:SetBranchTexture(i, j, TALENT_BRANCH_TEXTURECOORDS["up"][node.up], xOffset, yOffset);
                    end
                end
            end
        end

        -- Hide any unused branch textures
        for i = self.BranchIndex, 30 do _G[panel .. "Branch" .. i]:Hide(); end
        -- Hide and unused arrowl textures
        for i = self.ArrowIndex, 30 do _G[panel .. "Arrow" .. i]:Hide(); end
    end
end

function DragonflightUITalentsPanelMixin:SetArrowTexture(tier, column, texCoords, xOffset, yOffset)
    local talentFrameName = self:GetName();
    local arrowTexture = self:GetArrow()
    arrowTexture:SetTexCoord(texCoords[1], texCoords[2], texCoords[3], texCoords[4]);
    arrowTexture:SetPoint("TOPLEFT", arrowTexture:GetParent(), "TOPLEFT", xOffset, yOffset);
    arrowTexture:Show()
end

function DragonflightUITalentsPanelMixin:SetBranchTexture(tier, column, texCoords, xOffset, yOffset, xSize, ySize)
    local talentFrameName = self:GetName();
    local branchTexture = self:GetBranch();
    branchTexture:SetTexCoord(texCoords[1], texCoords[2], texCoords[3], texCoords[4]);
    branchTexture:SetPoint("TOPLEFT", branchTexture:GetParent(), "TOPLEFT", xOffset, yOffset);
    branchTexture:SetWidth(xSize or 30);
    branchTexture:SetHeight(ySize or 30);
    branchTexture:Show()
end

function DragonflightUITalentsPanelMixin:SetPrereqs(buttonTier, buttonColumn, forceDesaturated, tierUnlocked, preview, ...)
    local requirementsMet = tierUnlocked and not forceDesaturated;
    for i = 1, select("#", ...), 4 do
        local tier, column, isLearnable, isPreviewLearnable = select(i, ...);
        if (forceDesaturated or (preview and not isPreviewLearnable) or (not preview and not isLearnable)) then
            ---@diagnostic disable-next-line: cast-local-type
            requirementsMet = nil;
        end
        self:DrawLines(buttonTier, buttonColumn, tier, column, requirementsMet)
    end
    return requirementsMet;
end

function DragonflightUITalentsPanelMixin:ResetBranches()
    for i = 1, 7 do
        for j = 1, 4 do
            self.TALENT_BRANCH_ARRAY[i][j].id = nil;
            self.TALENT_BRANCH_ARRAY[i][j].up = 0;
            self.TALENT_BRANCH_ARRAY[i][j].down = 0;
            self.TALENT_BRANCH_ARRAY[i][j].left = 0;
            self.TALENT_BRANCH_ARRAY[i][j].right = 0;
            self.TALENT_BRANCH_ARRAY[i][j].rightArrow = 0;
            self.TALENT_BRANCH_ARRAY[i][j].leftArrow = 0;
            self.TALENT_BRANCH_ARRAY[i][j].topArrow = 0;

            self.BUTTON_ARRAY[i][j] = nil
        end
    end

    local panel = self:GetName()
    for i = 1, 30 do
        _G[panel .. 'Arrow' .. i]:Hide()
        _G[panel .. 'Branch' .. i]:Hide()
    end

    self.ArrowIndex = 1
    self.BranchIndex = 1
end

function DragonflightUITalentsPanelMixin:GetArrow()
    local arrowIndex = self.ArrowIndex
    self.ArrowIndex = arrowIndex + 1

    local arrow = _G[self:GetName() .. 'Arrow' .. arrowIndex]
    return arrow
end

function DragonflightUITalentsPanelMixin:GetBranch()
    local branchIndex = self.BranchIndex
    self.BranchIndex = branchIndex + 1

    local branch = _G[self:GetName() .. 'Branch' .. branchIndex]
    return branch
end

function DragonflightUITalentsPanelMixin:DrawLines(buttonTier, buttonColumn, tier, column, requirementsMet)
    -- print('drawLine', buttonTier, buttonColumn, tier, column, requirementsMet)

    if (requirementsMet) then
        requirementsMet = 1;
    else
        requirementsMet = -1;
    end

    -- Check to see if are in the same column
    if (buttonColumn == column) then
        -- Check for blocking talents
        if ((buttonTier - tier) > 1) then
            -- If more than one tier difference
            for i = tier + 1, buttonTier - 1 do
                if (self.TALENT_BRANCH_ARRAY[i][buttonColumn].id) then
                    -- If there's an id, there's a blocker
                    ---@diagnostic disable-next-line: missing-parameter
                    message("Error this layout is blocked vertically " .. self.TALENT_BRANCH_ARRAY[buttonTier][i].id);
                    return;
                end
            end
        end

        -- Draw the lines
        for i = tier, buttonTier - 1 do
            self.TALENT_BRANCH_ARRAY[i][buttonColumn].down = requirementsMet;
            if ((i + 1) <= (buttonTier - 1)) then
                self.TALENT_BRANCH_ARRAY[i + 1][buttonColumn].up = requirementsMet;
            end
        end

        -- Set the arrow
        self.TALENT_BRANCH_ARRAY[buttonTier][buttonColumn].topArrow = requirementsMet;
        return;
    end
    -- Check to see if they're in the same tier
    if (buttonTier == tier) then
        local left = min(buttonColumn, column);
        local right = max(buttonColumn, column);

        -- See if the distance is greater than one space
        if ((right - left) > 1) then
            -- Check for blocking talents
            for i = left + 1, right - 1 do
                if (self.TALENT_BRANCH_ARRAY[tier][i].id) then
                    -- If there's an id, there's a blocker
                    ---@diagnostic disable-next-line: missing-parameter
                    message("there's a blocker " .. tier .. " " .. i);
                    return;
                end
            end
        end
        -- If we get here then we're in the clear
        for i = left, right - 1 do
            self.TALENT_BRANCH_ARRAY[tier][i].right = requirementsMet;
            self.TALENT_BRANCH_ARRAY[tier][i + 1].left = requirementsMet;
        end
        -- Determine where the arrow goes
        if (buttonColumn < column) then
            self.TALENT_BRANCH_ARRAY[buttonTier][buttonColumn].rightArrow = requirementsMet;
        else
            self.TALENT_BRANCH_ARRAY[buttonTier][buttonColumn].leftArrow = requirementsMet;
        end
        return;
    end
    -- Now we know the prereq is diagonal from us
    local left = min(buttonColumn, column);
    local right = max(buttonColumn, column);
    -- Don't check the location of the current button
    if (left == column) then
        left = left + 1;
    else
        right = right - 1;
    end
    -- Check for blocking talents
    local blocked = nil;
    for i = left, right do
        if (self.TALENT_BRANCH_ARRAY[tier][i].id) then
            -- If there's an id, there's a blocker
            blocked = 1;
        end
    end
    left = min(buttonColumn, column);
    right = max(buttonColumn, column);
    if (not blocked) then
        self.TALENT_BRANCH_ARRAY[tier][buttonColumn].down = requirementsMet;
        self.TALENT_BRANCH_ARRAY[buttonTier][buttonColumn].up = requirementsMet;

        for i = tier, buttonTier - 1 do
            self.TALENT_BRANCH_ARRAY[i][buttonColumn].down = requirementsMet;
            self.TALENT_BRANCH_ARRAY[i + 1][buttonColumn].up = requirementsMet;
        end

        for i = left, right - 1 do
            self.TALENT_BRANCH_ARRAY[tier][i].right = requirementsMet;
            self.TALENT_BRANCH_ARRAY[tier][i + 1].left = requirementsMet;
        end
        -- Place the arrow
        self.TALENT_BRANCH_ARRAY[buttonTier][buttonColumn].topArrow = requirementsMet;
        return;
    end
    -- If we're here then we were blocked trying to go vertically first so we have to go over first, then up
    if (left == buttonColumn) then
        left = left + 1;
    else
        right = right - 1;
    end
    -- Check for blocking talents
    for i = left, right do
        if (self.TALENT_BRANCH_ARRAY[buttonTier][i].id) then
            -- If there's an id, then throw an error
            ---@diagnostic disable-next-line: missing-parameter
            message("Error, this layout is undrawable " .. self.TALENT_BRANCH_ARRAY[buttonTier][i].id);
            return;
        end
    end
    -- If we're here we can draw the line
    left = min(buttonColumn, column);
    right = max(buttonColumn, column);
    -- TALENT_BRANCH_ARRAY[tier][column].down = requirementsMet;
    -- TALENT_BRANCH_ARRAY[buttonTier][column].up = requirementsMet;

    for i = tier, buttonTier - 1 do
        self.TALENT_BRANCH_ARRAY[i][column].up = requirementsMet;
        self.TALENT_BRANCH_ARRAY[i + 1][column].down = requirementsMet;
    end

    -- Determine where the arrow goes
    if (buttonColumn < column) then
        self.TALENT_BRANCH_ARRAY[buttonTier][buttonColumn].rightArrow = requirementsMet;
    else
        self.TALENT_BRANCH_ARRAY[buttonTier][buttonColumn].leftArrow = requirementsMet;
    end
end

-- 'DAMAGER', 'TANK', 'HEALER'
local PlayerClassRoleTable = {
    {{'DAMAGER'}, {'DAMAGER'}, {'TANK'}}, -- Warrior
    {{'HEALER'}, {'TANK'}, {'DAMAGER'}}, -- Paladin 
    {{'DAMAGER'}, {'DAMAGER'}, {'DAMAGER'}}, -- Hunter 
    {{'DAMAGER'}, {'DAMAGER'}, {'DAMAGER'}}, -- Rogue 
    {{'HEALER'}, {'HEALER'}, {'DAMAGER'}}, -- Priest  
    {{'TANK'}, {'DAMAGER'}, {'DAMAGER'}}, -- DeathKnight 
    {{'DAMAGER'}, {'DAMAGER', 'TANK'}, {'HEALER'}}, -- Shaman 
    {{'DAMAGER', 'HEALER'}, {'DAMAGER'}, {'DAMAGER'}}, -- Mage 
    {{'DAMAGER'}, {'DAMAGER'}, {'DAMAGER'}}, -- Warlock 
    {{'DAMAGER'}, {'DAMAGER'}, {'DAMAGER'}}, -- Monk 
    {{'DAMAGER'}, {'DAMAGER', 'TANK'}, {'HEALER'}}, -- Druid 
    {{'DAMAGER'}, {'DAMAGER'}, {'DAMAGER'}} -- Demon Hunter 
}

function DragonflightUITalentsPanelMixin:GetPlayerRole(panelID)
    local localizedClass, englishClass, classIndex = UnitClass('player');

    local roleData = PlayerClassRoleTable[classIndex][panelID]

    return roleData[1], roleData[2]
end

function DragonflightUITalentsPanelMixin:UpdateRoleIcon(self, panelID)
    -- local role1, role2 = GetTalentTreeRoles(self.talentTree, self.inspect, self.pet); 
    -- local role1, role2 = 'TANK', 'TANK'
    local role1, role2 = DragonflightUITalentsPanelMixin:GetPlayerRole(panelID)

    -- swap roles to match order on the summary screen
    if (role2) then role1, role2 = role2, role1; end

    -- Update roles
    if (role1 == "TANK" or role1 == "HEALER" or role1 == "DAMAGER") then
        self.RoleIcon.Icon:SetTexCoord(GetTexCoordsForRoleSmall(role1));
        self.RoleIcon:Show();
        self.RoleIcon.role = role1;
    else
        self.RoleIcon:Hide();
    end

    if (role2 == "TANK" or role2 == "HEALER" or role2 == "DAMAGER") then
        self.RoleIcon2.Icon:SetTexCoord(GetTexCoordsForRoleSmall(role2));
        self.RoleIcon2:Show();
        self.RoleIcon2.role = role2;
    else
        self.RoleIcon2:Hide();
    end
end

-------------

DragonflightUITalentsFrameMixin = {}

function DragonflightUITalentsFrameMixin:OnLoad()
    -- print('DragonflightUITalentsFrameMixin:OnLoad()')
    frameRef = self

    local headerText = PlayerTalentFrame:CreateFontString('DragonflightUIPlayerTalentFrameHeaderText', 'OVERLAY',
                                                          'GameFontHighlight')
    headerText:SetPoint('TOP', PlayerTalentFrame, 'TOP', 0, -36)

    PlayerTalentFrameTitleText:ClearAllPoints()
    local titleText = PlayerTalentFrame:CreateFontString('DragonflightUIPlayerTalentFrameTitleText', 'OVERLAY',
                                                         'GameFontNormal')
    titleText:SetPoint('TOP', PlayerTalentFrame, 'TOP', 0, -5)
    titleText:SetPoint('LEFT', PlayerTalentFrame, 'LEFT', 60, 0)
    titleText:SetPoint('RIGHT', PlayerTalentFrame, 'RIGHT', -60, 0)
    titleText:SetText(TALENTS)

    PlayerTalentFrame.UpdateDFHeaderText = function()
        -- print('UpdateDFHeaderText')

        local unspentTalentPoints, learnedProfessions = UnitCharacterPoints("player")
        -- TODO: bug?  UnitCharacterPoints("player") not updating instantly
        unspentTalentPoints = DragonflightUITalentsPanelMixin:GetUnspetTalentPoints(selectedSpec)

        if unspentTalentPoints > 0 then
            headerText:SetFormattedText(PLAYER_UNSPENT_TALENT_POINTS, unspentTalentPoints);
            headerText:Show()
        elseif GetNextTalentLevel() then
            headerText:SetFormattedText(NEXT_TALENT_LEVEL, GetNextTalentLevel());
            headerText:Show()
        else
            headerText:Hide()
        end

        if activeSpec == selectedSpec then
            if selectedSpec == 1 then
                titleText:SetText(TALENT_SPEC_PRIMARY_ACTIVE)
            else
                titleText:SetText(TALENT_SPEC_SECONDARY_ACTIVE)
            end
        else
            if selectedSpec == 1 then
                titleText:SetText(TALENT_SPEC_PRIMARY)
            else
                titleText:SetText(TALENT_SPEC_SECONDARY)
            end
        end
    end

    PlayerTalentFrame.DFPanels = {}
    self.Panels = {}

    for i = 1, 3 do
        --
        local panel = CreateFrame('FRAME', 'DragonflightUIPlayerTalentFramePanel' .. i, PlayerTalentFrame,
                                  'DFPlayerTalentFramePanelTemplate')
        -- panel:SetSize(208, 376)
        panel:Init(i)
        -- panel:Refresh()

        PlayerTalentFrame.DFPanels[i] = panel
        self.Panels[i] = panel

        if i == 1 then
            panel:SetPoint('BOTTOMLEFT', PlayerTalentFrame.DFInset, 'BOTTOMLEFT', 5, 3)
        else
            panel:SetPoint('TOPLEFT', PlayerTalentFrame.DFPanels[i - 1], 'TOPRIGHT', 1, 0)
        end
    end

    do
        local check = CreateFrame('CHECKBUTTON', 'DragonflightUIPlayerTalentFrameCheckbox', PlayerTalentFrame,
                                  'DFPlayerTalentFrameCheckboxTemplate')
        -- check:SetPoint('TOPRIGHT', PlayerTalentFrame, 'TOPRIGHT', -5, -28)
        check:SetSize(23, 22)
        check:SetPoint('BOTTOMLEFT', PlayerTalentFrame, 'BOTTOMLEFT', 5, 3)

        self.Checkbox = check

        check:SetScript('OnClick', function(button, buttonName, down)
            --
            -- print('OnClick', button:GetName(), buttonName, down)
            -- print('Click', button:GetChecked(), GetCVar('previewTalentsOption'))

            self:ToggleCVar()
        end)

        check:SetScript('OnEnter', function(self)
            --
            GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
            -- GameTooltip:SetText(OPTION_PREVIEW_TALENT_CHANGES_DESCRIPTION)
            GameTooltip_AddNormalLine(GameTooltip, PREVIEW_TALENT_CHANGES)
            GameTooltip_AddHighlightLine(GameTooltip, OPTION_PREVIEW_TALENT_CHANGES_DESCRIPTION)
            GameTooltip:Show()
        end)
        -- PREVIEW_TALENT_CHANGES, OPTION_PREVIEW_TALENT_CHANGES_DESCRIPTION

        local checkText = PlayerTalentFrame:CreateFontString('DragonflightUIPlayerTalentFrameCheckboxDescription',
                                                             'OVERLAY', 'GameFontHighlight')
        checkText:SetPoint('LEFT', check, 'RIGHT', 4, 0)
        checkText:SetText(PREVIEW_TALENT_CHANGES)
    end

    do
        --
        PlayerTalentFramePreviewBar:ClearAllPoints()

        local reset = CreateFrame('BUTTON', 'DragonflightUIPlayerTalentFrameResetButton', PlayerTalentFrame,
                                  'DFPlayerTalentFrameResetButton')
        reset:SetPoint('BOTTOMRIGHT', PlayerTalentFrame, 'BOTTOMRIGHT', -5, 4)
        self.ResetButton = reset

        local learn = CreateFrame('BUTTON', 'DragonflightUIPlayerTalentFrameLearnButton', PlayerTalentFrame,
                                  'DFPlayerTalentFrameLearnButton')
        learn:SetPoint('RIGHT', reset, 'LEFT', 0, 0)
        self.LearnButton = learn
    end

    do
        local tab1 = PlayerSpecTab1
        tab1:ClearAllPoints()
        tab1:SetPoint('TOPLEFT', PlayerTalentFrame, 'TOPRIGHT', 0, -36)

        local tab2 = PlayerSpecTab2
        tab2:ClearAllPoints()
        tab2:SetPoint('TOPLEFT', tab1, 'BOTTOMLEFT', 0, -22)

        PlayerSpecTab1:SetAlpha(0)
        PlayerSpecTab1:EnableMouse(false)
        PlayerSpecTab2:SetAlpha(0)
        PlayerSpecTab2:EnableMouse(false)

        local newTab1 = CreateFrame('CHECKBUTTON', 'DragonflightUIPlayerTalentFrameSpecButton' .. 1, PlayerTalentFrame,
                                    'DFPlayerSpecTabTemplate')
        newTab1:SetPoint('TOPLEFT', PlayerTalentFrame, 'TOPRIGHT', 0, -36)
        newTab1.specIndex = 1

        local newTab2 = CreateFrame('CHECKBUTTON', 'DragonflightUIPlayerTalentFrameSpecButton' .. 2, PlayerTalentFrame,
                                    'DFPlayerSpecTabTemplate')
        newTab2:SetPoint('TOPLEFT', newTab1, 'BOTTOMLEFT', 0, -22)
        newTab2.specIndex = 2
    end

    do
        PlayerTalentFrameActivateButton:ClearAllPoints()
        PlayerTalentFrameActivateButton:Hide()

        local activate = CreateFrame('BUTTON', 'DragonflightUIPlayerTalentFrameActivateButton', PlayerTalentFrame,
                                     'DFPlayerTalentFrameActivateButton')
        activate:SetPoint('TOPRIGHT', PlayerTalentFrame, 'TOPRIGHT', -10, -30)
    end

    -- self:RegisterEvent("ADDON_LOADED");
    self:RegisterEvent("PREVIEW_TALENT_POINTS_CHANGED");
    -- self:RegisterEvent("PREVIEW_PET_TALENT_POINTS_CHANGED");
    -- self:RegisterEvent("UNIT_PET");
    -- self:RegisterEvent("UNIT_MODEL_CHANGED");
    self:RegisterEvent("UNIT_LEVEL");
    self:RegisterEvent("LEARNED_SPELL_IN_TAB");
    self:RegisterEvent("PLAYER_TALENT_UPDATE");
    -- self:RegisterEvent("PET_TALENT_UPDATE");
    self:RegisterEvent("PREVIEW_TALENT_PRIMARY_TREE_CHANGED");
    self:RegisterEvent("CVAR_UPDATE")

    self:Refresh()

    PlayerTalentFrame:HookScript('OnShow', function()
        -- self:Refresh()
        self:RefreshSpecTabs()
    end)

    activeSpec = GetActiveTalentGroup()
    selectedSpec = activeSpec

    hooksecurefunc('ToggleTalentFrame', function()
        --
        -- print('ToggleTalentFrame')
        self:Refresh()
    end)
end

function DragonflightUITalentsFrameMixin:OnShow()
    -- print('DragonflightUITalentsFrameMixin:OnShow()')
    self:Refresh()
end

function DragonflightUITalentsFrameMixin:OnEvent(event, ...)
    -- print('OnEvent', event, ...)
    -- if PlayerTalentFrame:IsVisible() then self:Refresh() end
    self:Refresh()
end

function DragonflightUITalentsFrameMixin:Refresh()
    -- print('DragonflightUITalentsFrameMixin:Refresh()')
    activeSpec = GetActiveTalentGroup()

    for k, panel in ipairs(self.Panels) do panel:Refresh() end

    PlayerTalentFrame.UpdateDFHeaderText()
    self:RefreshCheckbox()
    self:RefreshSpecTabs()
    self:UpdateControls()
end

function DragonflightUITalentsFrameMixin:RefreshSpecTabs()
    local tab1 = _G['DragonflightUIPlayerTalentFrameSpecButton1']
    tab1:Update()

    local tab2 = _G['DragonflightUIPlayerTalentFrameSpecButton2']
    tab2:Update()
end

function DragonflightUITalentsFrameMixin:RefreshCheckbox()
    local check = self.Checkbox

    local preCVAR = C_CVar.GetCVarBool("previewTalentsOption")

    if preCVAR then
        check:SetChecked(true)
    else
        check:SetChecked(false)
    end
end

function DragonflightUITalentsFrameMixin:ToggleCVar()
    -- print(' DragonflightUITalentsFrameMixin:ToggleCVar()')
    local preCVAR = C_CVar.GetCVarBool("previewTalentsOption")

    if preCVAR then
        C_CVar.SetCVar('previewTalentsOption', 0)
    else
        C_CVar.SetCVar('previewTalentsOption', 1)
    end
end

function DragonflightUITalentsFrameMixin:UpdateControls()
    -- print('DragonflightUITalentsFrameMixin:UpdateControls()')

    local isActiveSpec = selectedSpec == activeSpec
    local activate = _G['DragonflightUIPlayerTalentFrameActivateButton']

    if isActiveSpec then
        activate:Hide()
    else
        activate:Show()
    end

    --
    local preview = GetCVarBool("previewTalentsOption");

    local learn = self.LearnButton
    local reset = self.ResetButton

    if preview then
        -- print('-> SHOW')

        learn:Show()
        reset:Show()

        -- enable the control bar if this is the active spec, preview is enabled, and preview points were spent
        local talentPoints = GetUnspentTalentPoints(false, false, selectedSpec);
        if (talentPoints > 0 and GetGroupPreviewTalentPointsSpent(false, selectedSpec) > 0) then
            learn:Enable();
            reset:Enable();
        else
            learn:Disable();
            reset:Disable();
        end
    else
        -- print('-> HIDE')
        learn:Hide()
        reset:Hide()
    end
end

------

DragonflightUIPlayerSpecMixin = {}

function DragonflightUIPlayerSpecMixin:OnLoad()
    -- print('DragonflightUIPlayerSpecMixin:OnLoad()')
    local normalTexture = self:GetNormalTexture();
    -- SetPortraitTexture(normalTexture, 'player');
    normalTexture:SetTexture('Interface\\Icons\\Ability_Marksmanship')
end

function DragonflightUIPlayerSpecMixin:OnClick()
    PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB);
    local specIndex = self.specIndex;

    selectedSpec = specIndex

    frameRef:Refresh()
    self:OnEnter()
end

function DragonflightUIPlayerSpecMixin:OnEnter()
    -- print('DragonflightUIPlayerSpecMixin:OnEnter()')

    local specIndex = self.specIndex;

    GameTooltip:ClearLines()
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    if specIndex == 1 then
        GameTooltip:AddLine(TALENT_SPEC_PRIMARY);
    else
        GameTooltip:AddLine(TALENT_SPEC_SECONDARY);

        if GetNumTalentGroups() < 2 then
            GameTooltip_AddErrorLine(GameTooltip, 'Dual Talent Specialization not yet learned.')
            GameTooltip:Show()
            return
        end
    end

    if activeSpec == specIndex then
        GameTooltip:AddLine(TALENT_ACTIVE_SPEC_STATUS, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
    end

    for i = 1, 3 do
        local id, name, description, iconTexture, pointsSpent, background, previewPointsSpent, isUnlocked =
            GetTalentTabInfo(i, false, false, specIndex)

        GameTooltip:AddDoubleLine(name, pointsSpent + previewPointsSpent, HIGHLIGHT_FONT_COLOR.r,
                                  HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r,
                                  HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
    end
    GameTooltip:Show()
end

function DragonflightUIPlayerSpecMixin:OnLeave()
    -- print('DragonflightUIPlayerSpecMixin:OnLeave()')
    GameTooltip:Hide()
end

function DragonflightUIPlayerSpecMixin:Update()
    -- print('DragonflightUIPlayerSpecMixin:Update()')
    local specIndex = self.specIndex;

    if selectedSpec == specIndex then
        -- self:GetCheckedTexture():Show();
        self:SetChecked(true)
    else
        -- self:GetCheckedTexture():Hide();
        self:SetChecked(false)
    end

    local normalTexture = self:GetNormalTexture();
    -- SetPortraitTexture(normalTexture, 'player');
    normalTexture:SetTexture('Interface\\Icons\\Ability_Marksmanship')
end

-------

DragonflightUIPlayerSpecActivateMixin = {}

function DragonflightUIPlayerSpecActivateMixin:OnLoad()
    self:SetWidth(self:GetTextWidth() + 40);
end

function DragonflightUIPlayerSpecActivateMixin:OnClick()
    if selectedSpec then
        --
        SetActiveTalentGroup(selectedSpec)
    end
end

function DragonflightUIPlayerSpecActivateMixin:OnShow()
    self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED");
    self:Update()
end

function DragonflightUIPlayerSpecActivateMixin:OnHide()
    self:UnregisterEvent("CURRENT_SPELL_CAST_CHANGED");
end

function DragonflightUIPlayerSpecActivateMixin:OnEvent(event, ...)
    self:Update()
end

function DragonflightUIPlayerSpecActivateMixin:Update()
    if selectedSpec and self:IsShown() then
        if (IsCurrentSpell(TALENT_ACTIVATION_SPELLS[selectedSpec])) then
            self:Disable()
        else
            self:Enable()
        end
    end
end

-------

DragonflightUIPlayerSpecPreviewLearnMixin = {}

function DragonflightUIPlayerSpecPreviewLearnMixin:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    GameTooltip:SetText(TALENT_TOOLTIP_LEARNTALENTGROUP);
end

function DragonflightUIPlayerSpecPreviewLearnMixin:OnLeave()
    GameTooltip:Hide()
end

function DragonflightUIPlayerSpecPreviewLearnMixin:OnClick()
    if UnitIsDeadOrGhost("player") then
        UIErrorsFrame:AddMessage(ERR_PLAYER_DEAD, 1.0, 0.1, 0.1, 1.0);
    else
        StaticPopup_Show("CONFIRM_LEARN_PREVIEW_TALENTS");
    end
end

-------

DragonflightUIPlayerSpecPreviewResetMixin = {}

function DragonflightUIPlayerSpecPreviewResetMixin:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    GameTooltip:SetText(TALENT_TOOLTIP_RESETTALENTGROUP);
end

function DragonflightUIPlayerSpecPreviewResetMixin:OnLeave()
    GameTooltip:Hide()
end

function DragonflightUIPlayerSpecPreviewResetMixin:OnClick()
    ResetGroupPreviewTalentPoints(false, selectedSpec)
end

