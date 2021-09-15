---@type GL
local _, GL = ...;

local Overview = GL.Interface.Settings.Overview; ---@type SettingsOverview

---@class PackMuleSettings
GL.Interface.Settings.PackMule = {
    description = "PackMule allows you to funnel specific items or items of a given quality to people in your raid automatically.\n\nThis will only work if you are the master looter and PackMule is enabled! When looting a corpse while holding the shift-button, PackMule will be temporarily disabled, allowing you to loot the old fashioned way!\n\nPackMule is safe to use because it ignores all recipes, quest items, and a list of other items that are not tradable. Want to check what's on this list? Click the 'Show Ignored Items' button below!",
    wikiUrl = "https://github.com/papa-smurf/Gargul/wiki/Setting-up-PackMules",
};
local PackMule = GL.Interface.Settings.PackMule; ---@type PackMuleSettings

---@return void
function PackMule:draw(Parent)
    GL:debug("PackMuleSettings:draw");

    local Checkboxes = {
        {
            label = "Enable",
            description = "The PackMule rules will only be applied if this box is checked",
            setting = "PackMule.enabled",
        },
        {
            label = "Persist after zone switch",
            description = "PackMule is disabled by default after you as a player change to a different zone (e.g. you enter or leave an instance). If you check this box then PackMule will keep its former state even after moving between zones. |cff8aecffUse with caution!",
            setting = "PackMule.persistsAfterZoneChange",
        },
        {
            label = "Persist after reload",
            description = "PackMule is disabled by default after you as a player reload (e.g. reload the UI or restart the game). If you check this box then PackMule will keep its former state even after reloading. |c00be3333Use with EXTREME caution|r!",
            setting = "PackMule.persistsAfterReload",
        },
        {
            label = "Announce disenchanted items",
            description = "If enabled PackMule will post a message whenever an item is disenchanted",
            setting = "PackMule.announceDisenchantedItems",
        },
    };

    Overview:drawCheckboxes(Checkboxes, Parent);

    local HorizontalSpacer = GL.AceGUI:Create("SimpleGroup");
    HorizontalSpacer:SetLayout("FILL");
    HorizontalSpacer:SetFullWidth(true);
    HorizontalSpacer:SetHeight(20);
    Parent:AddChild(HorizontalSpacer);

    local OpenPackMule = GL.AceGUI:Create("Button");
    OpenPackMule:SetText("Set Up PackMules");
    OpenPackMule:SetCallback("OnClick", function()
        GL.Settings:close();
        GL.Commands:call("packmule");
    end);
    Parent:AddChild(OpenPackMule);

    local IgnoredItems = GL.AceGUI:Create("Button");
    IgnoredItems:SetText("Show Ignored Items");
    IgnoredItems:SetCallback("OnClick", function()
        GL.Settings:close();
        GL.Interface.PackMule.IgnoredItems:draw();
    end);
    Parent:AddChild(IgnoredItems);
end

GL:debug("Interface/Settings/PackMule.lua");