------------------------------------------------------------------------------
--  host.lua v. 20230627.1
--  host-specific configuration for wezterm, sourced by wezterm.lua
------------------------------------------------------------------------------
local wz = require 'wezterm'
local M  = {}

-- merged with wezterm.config table
function M.apply_config (config)

    -- homebrew bash 5
    config.default_prog  = {"/usr/local/bin/bash", "-l"}

    -- initial geometry influences initial pane:split size
    -- layout is maximized below
    -- 'stty size' prints current tty dimensions (rows cols)
    config.initial_cols = 208
    config.initial_rows = 48

    config.window_background_image = '/Users/Dave/04_Archived/Desktops/bluesBW.png'
    -- config.window_background_image = '/Users/Dave/04_Archived/Desktops/rose_hips.png'
    -- config.window_background_image = '/Users/Dave/04_Archived/Desktops/black_roseBW.png'
    -- config.window_background_image = '/Users/Dave/04_Archived/Desktops/pink_roseBW.png'
    config.window_background_image_hsb = {
        brightness = 0.6,
    }
    config.text_background_opacity = .85 -- lower -> more bg visible under text

    config.font = wz.font ('MonoLisa Variable', {weight="Light"})
    config.font_size   = 20
    config.harfbuzz_features = {"calt=0", "clig=0", "liga=0"}  -- disable ligatures

    -- config.use_ime = false
end

-- used in select.lua
M.paths     = {
    image_dir = "~/.config/wezterm/backgrounds",
    pathsep   = '/',
}

M.cmds  = {
    popen = string.format ("ls %s | sort", M.paths.image_dir),
}

-- Initial pane layout
wz.on ('gui-startup', function (cmd)
    local tab, pane, window = wz.mux.spawn_window (cmd or {})
    local ltpane = pane:split  {direction = 'Left', size = 0.500 }
    local lbpane = ltpane:split {direction = 'Bottom',  size = 0.382 }
    window:gui_window():maximize()
    pane:activate()     -- right pane
end)

return M
