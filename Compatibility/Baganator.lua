local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

function DF.Compatibility:Baganator()
    print('DF.Compatibility:Baganator()')

    local function ConvertTags(tags)
        local res = {}
        for _, tag in ipairs(tags) do res[tag] = true end
        return res
    end

    local base = 'Interface\\Addons\\DragonflightUI\\Textures\\UI\\'

    local skinners = {
        ItemButton = function(frame)
        end,
        IconButton = function(button, tags)
            if tags.sort then
                -- do something
            elseif tags.bank then
                -- do something
            elseif tags.guildBank then
                -- do something
            elseif tags.allCharacters then
                -- do something
            elseif tags.customise then
                -- do something
            elseif tags.bagSlots then
                -- do something
            else
                -- generic
            end
        end,
        Button = function(frame)
        end,
        ButtonFrame = function(frame, tags)
            if tags.backpack then
                -- do something
            elseif tags.bank then
                -- do something
            elseif tags.guild then
                -- do something
            else
                -- generic
            end

            -- corner
            do
                local tex = base .. 'uiframemetal2x'

                local tlc = frame.TopLeftCorner
                tlc:SetTexture(tex)
                tlc:SetTexCoord(0.00195312, 0.294922, 0.00195312, 0.294922)
                tlc:SetSize(75, 74)
                tlc:SetPoint('TOPLEFT', -12, 16)

                local trc = frame.TopRightCorner
                trc:SetTexture(tex)
                trc:SetTexCoord(0.298828, 0.591797, 0.00195312, 0.294922)
                trc:SetSize(75, 74)
                trc:SetPoint('TOPRIGHT', 4, 16)

                local blc = frame.BotLeftCorner
                blc:SetTexture(tex)
                blc:SetTexCoord(0.298828, 0.423828, 0.298828, 0.423828)
                blc:SetSize(32, 32)
                blc:SetPoint('BOTTOMLEFT', -12, -3)

                local brc = frame.BotRightCorner
                brc:SetTexture(tex)
                brc:SetTexCoord(0.427734, 0.552734, 0.298828, 0.423828)
                brc:SetSize(32, 32)
                brc:SetPoint('BOTTOMRIGHT', 4, -3)
            end

            -- edge bottom/top
            do
                local tex = base .. 'UIFrameMetalHorizontal2x'

                local te = frame.TopBorder
                te:SetTexture(tex)
                te:SetTexCoord(0, 1, 0.00390625, 0.589844)
                te:SetSize(32, 74)
                te:SetPoint('TOPLEFT', frame.TopLeftCorner, 'TOPRIGHT', 0, 0)
                te:SetPoint('TOPRIGHT', frame.TopRightCorner, 'TOPLEFT', 0, 0)

                local be = frame.BottomBorder
                be:SetTexture(tex)
                be:SetTexCoord(0, 0.5, 0.597656, 0.847656)
                be:SetSize(16, 32)
                be:SetPoint('TOPLEFT', frame.BotLeftCorner, 'TOPRIGHT', 0, 0)
                be:SetPoint('TOPRIGHT', frame.BotRightCorner, 'TOPLEFT', 0, 0)
            end

            -- edge left/right
            do
                local tex = base .. 'UIFrameMetalVertical2x'

                local le = frame.LeftBorder
                le:SetTexture(tex)
                le:SetTexCoord(0.00195312, 0.294922, 0, 1)
                le:SetSize(75, 16)
                le:SetPoint('TOPLEFT', frame.TopLeftCorner, 'BOTTOMLEFT', 0, 0)
                le:SetPoint('BOTTOMLEFT', frame.BotLeftCorner, 'TOPLEFT', 0, 0)

                local re = frame.RightBorder
                re:SetTexture(tex)
                re:SetTexCoord(0.298828, 0.591797, 0, 1)
                re:SetSize(75, 16)
                re:SetPoint('TOPRIGHT', frame.TopRightCorner, 'BOTTOMRIGHT', 0, 0)
                re:SetPoint('BOTTOMRIGHT', frame.BotRightCorner, 'TOPRIGHT', 0, 0)
            end

            -- DevTools_Dump(frame.CloseButton)

            local closeBtn = frame.CloseButton
            if closeBtn then
                DragonflightUIMixin:UIPanelCloseButton(closeBtn)
                closeBtn:SetPoint('TOPRIGHT', 1, 0)
            end

            -- bg
            frame.Bg:SetAlpha(1)

            local bg = frame.Bg
            bg:SetTexture(base .. 'ui-background-rock')
            -- top:ClearAllPoints()
            -- -- top:SetPoint('TOPLEFT', frame.Bg, 'TOPLEFT', 0, 0)
            -- -- top:SetPoint('BOTTOMRIGHT', frame.Bg.BottomRight, 'BOTTOMRIGHT', 0, 0)
            -- top:SetDrawLayer('BACKGROUND', 2)

        end,
        SearchBox = function(frame)
        end,
        EditBox = function(frame)
        end,
        TabButton = function(frame)
        end,
        TopTabButton = function(frame)
        end,
        SideTabButton = function(frame)
        end,
        TrimScrollBar = function(frame)
        end,
        CheckBox = function(frame)
        end,
        Slider = function(frame)
        end,
        InsetFrame = function(frame)
        end,
        Divider = function(tex)
            tex:SetAlpha(0.5)
        end,
        CategoryLabel = function(btn)
        end,
        CategorySectionHeader = function(btn)
        end,
        CornerWidget = function(frame, tags)
            -- Example widget
            if frame:IsObjectType("FontString") then
                -- modify the scale/font size
            end
        end,
        DropDownWithPopout = function(button)
        end
    }

    local function SkinFrame(details)
        print('~~~~~SKINFRAME', details.regionType)
        local func = skinners[details.regionType]
        if func then func(details.region, details.tags and ConvertTags(details.tags) or {}) end
    end

    Baganator.API.Skins.RegisterListener(SkinFrame)

    for _, details in ipairs(Baganator.API.Skins.GetAllFrames()) do SkinFrame(details) end

end

DF.Compatibility:FuncOrWaitframe('Baganator', DF.Compatibility.Baganator)
