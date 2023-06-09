------------------------------------------------------------------------------
--  wezterm_post.lua v. 20230526.1
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

  config.font = wz.font ('MonoLisa Liga', {weight="Light"})
  config.font_size   = 19
	-- harfbuzz_features = {"calt=0", "clig=0", "liga=0"},  -- disable ligatures

  config.use_ime = false
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
  local tab, lpane, window = wz.mux.spawn_window (cmd or {})
  local rpane = lpane:split  {direction = 'Right', size = 0.500 }
  local rmpane = rpane:split {direction = 'Bottom',  size = 0.382 }
  local rbpane = rmpane:split  {direction = 'Bottom',  size = 0.382 }
  window:gui_window():maximize()
  lpane:activate()
end)

return M
