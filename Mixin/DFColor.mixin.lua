DFColorMixin = {};

function DFCreateColor(r, g, b, a)
    -- print('DFCreateColor', r, g, b, a)
    local color = CreateFromMixins(DFColorMixin);
    color:OnLoad(r, g, b, a);
    return color;
end

function DFColorMixin:OnLoad(r, g, b, a)
    self:SetRGBA(r, g, b, a);
end

function DFColorMixin:IsRGBEqualTo(otherColor)
    return self.r == otherColor.r and self.g == otherColor.g and self.b == otherColor.b;
end

function DFColorMixin:IsEqualTo(otherColor)
    return self:IsRGBEqualTo(otherColor) and self.a == otherColor.a;
end

function DFColorMixin:GetRGB()
    return self.r, self.g, self.b;
end

function DFColorMixin:GetRGBAsBytes()
    return Round(self.r * 255), Round(self.g * 255), Round(self.b * 255);
end

function DFColorMixin:GetRGBA()
    return self.r, self.g, self.b, self.a;
end

function DFColorMixin:GetRGBAAsBytes()
    return Round(self.r * 255), Round(self.g * 255), Round(self.b * 255), Round((self.a or 1) * 255);
end

function DFColorMixin:SetRGBA(r, g, b, a)
    self.r = r;
    self.g = g;
    self.b = b;
    self.a = a or 1;
end

function DFColorMixin:SetRGB(r, g, b)
    self:SetRGBA(r, g, b, nil);
end

function DFColorMixin:GenerateHexColor()
    return ("ff%.2x%.2x%.2x"):format(self:GetRGBAsBytes());
end

function DFColorMixin:GenerateHexColorNoAlpha()
    return ("%.2X%.2X%.2X"):format(self:GetRGBAsBytes());
end

function DFColorMixin:GenerateHexColorMarkup()
    return "|c" .. self:GenerateHexColor();
end

function DFColorMixin:WrapTextInColorCode(text)
    return WrapTextInColorCode(text, self:GenerateHexColor());
end

-- function WrapTextInColorCode(text, colorHexString)
-- 	return ("|c%s%s|r"):format(colorHexString, text);
-- end

-- function WrapTextInColor(text, color)
-- 	return WrapTextInColorCode(text, color:GenerateHexColor());
-- end

-- do
-- 	local envTbl = GetCurrentEnvironment();
-- 	local DBColors = C_UIColor.GetColors();
-- 	for _, dbColor in ipairs(DBColors) do
-- 		local color = CreateColor(dbColor.color.r, dbColor.color.g, dbColor.color.b, dbColor.color.a);
-- 		envTbl[dbColor.baseTag] = color;
-- 		envTbl[dbColor.baseTag.."_CODE"] = color:GenerateHexColorMarkup();
-- 	end
-- end

--
local COLOR_FORMAT_RGBA = 'RRGGBBAA';
local COLOR_FORMAT_RGB = 'RRGGBB';

function DFCreateColorFromRGBAHexString(hexColor)
    if #hexColor == #COLOR_FORMAT_RGBA then
        local r, g, b, a = ExtractColorValueFromHex(hexColor, 1), ExtractColorValueFromHex(hexColor, 3),
                           ExtractColorValueFromHex(hexColor, 5), ExtractColorValueFromHex(hexColor, 7);
        return DFCreateColor(r, g, b, a);
    else
        GMError("DFCreateColorFromHexString input must be hexadecimal digits in this format: RRGGBBAA.");
    end
end
if not CreateColorFromRGBAHexString then CreateColorFromRGBAHexString = DFCreateColorFromRGBAHexString end

function DFCreateColorFromRGBHexString(hexColor)
    if #hexColor == #COLOR_FORMAT_RGB then
        local r, g, b = ExtractColorValueFromHex(hexColor, 1), ExtractColorValueFromHex(hexColor, 3),
                        ExtractColorValueFromHex(hexColor, 5);
        return DFCreateColor(r, g, b, 1);
    else
        GMError("DFCreateColorFromRGBHexString input must be hexadecimal digits in this format: RRGGBB.");
    end
end
if not CreateColorFromRGBHexString then CreateColorFromRGBHexString = DFCreateColorFromRGBHexString end

