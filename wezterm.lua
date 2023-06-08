------------------------------------------------------------------------------
--  wezterm.lua v. 20230608.1
--  General config file for wezterm terminal emulator
--  https://wezfurlong.org/wezterm/config/files.html
------------------------------------------------------------------------------
-- local select    = require 'select'    -- bg image selection function
local zkeys   = require 'zkeys' -- custom keybindings
local host    = require 'host'  -- final host-specific config
local config = {

    enable_wayland  = true,
    use_ime         = false,
    macos_forward_to_ime_modifier_mask = "",

    window_padding = {
        left 	= "2cell",
        right 	= "2cell",
        top 	= "1cell",
        bottom 	= "4cell",
    },

    color_scheme = 'Pastel White (terminal.sexy)',
    colors = {
        -- background = 'black',
    },
    -- select background image from images in backgrounds/*.png
    -- image is stretched to fill entire window
    -- CMD-R reloads this file and selects another image
    -- edit image list by hand as new images are added
    -- window_background_image     = select.selectImg (),
    -- window_background_image_hsb = {brightness = 0.3,},
    -- window_background_opacity   = 0.95,
    -- text_background_opacity     = 0.7,   -- lower -> bg more visible under text
    inactive_pane_hsb     = {brightness = 0.50,},

    default_cursor_style  = "BlinkingBar",
    cursor_thickness      = 1.25,
    cursor_blink_rate     = 500,

    freetype_load_target  = "Light",	 -- affects hinting; "Light" = mac-like
    font_size             = 18,
    line_height           = 1.0,
    pane_select_font_size = 108,       -- pane numbers

    keys                  = zkeys.keys,
    debug_key_events      = true,
}

zkeys.apply_leader (config)
host.apply_config (config)

return config
