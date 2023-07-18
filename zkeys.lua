------------------------------------------------------------------------------
--  zkeys.lua    Rev. 20230527.1
--  wezterm-specific keybindings
------------------------------------------------------------------------------
local wz        = require 'wezterm'
local action    = wz.action
local callback  = wz.action_callback
local M         = {}    -- holds both apply_leader() and keys
M.keys          = {}    -- returned and assigned to config.keys

-- <SUPER>r reloads this file
table.insert (M.keys, {
  key     = "mapped:r",
  mods    = "SUPER",
  action  = action.ReloadConfiguration,
})


------------------------------------------------------------------------------
-- Assign leader = <c-t> (phys 'k')
------------------------------------------------------------------------------
-- <leader> is defined in config, not config.keys. As return con return only
-- one value, assign <leader> in a function that can be called separately from
-- the returned table.
function M.apply_leader (config)
  config.leader =  {
    key   = "mapped:t",
    mods  = "CTRL",
    timeout_milliseconds = 1000,
  }
end

-- <leader> twice sends a <leader> to the program in the terminal
table.insert (M.keys, {
  key     = "mapped:t",
  mods    = "LEADER|CTRL",
  action  = action {SendKey = {key = "t", mods = "CTRL"}}
  -- action = action{SendString = "Hello!"}  -- for testing
})


------------------------------------------------------------------------------
--> Send ALT-key combinations directly to the terminal (e.g., for readline or
--  vim) instead of routing through host IME.
--  config.use_ime = false should do this on mac but doesn't seem to.
--  https://wezfurlong.org/wezterm/config/lua/config/macos_forward_to_ime_modifier_mask.html
------------------------------------------------------------------------------
---[[
for k in ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"):gmatch (".") do
  table.insert(M.keys, {
    key = "mapped:" .. k,
    mods = "ALT",
    action = {SendKey = {key = k, mods = "ALT"}},
  })
end
--]]


------------------------------------------------------------------------------
--> window/workspace management
--  mnemonic: SHIFT-SUPER
------------------------------------------------------------------------------
-- new window: <shift-cmd>n
table.insert (M.keys, {
  key     = "mapped:n",
  mods    = "SHIFT|SUPER",
  action  = action.SpawnWindow,
})

-- no command to close window or navigate among windows

------------------------------------------------------------------------------
--> tab management
--  mnemonic: SUPER
------------------------------------------------------------------------------
-- new tab: <cmd-n>
table.insert (M.keys, {
  key     = "mapped:n",
  mods    = "SUPER",
  action  = action {SpawnTab = "CurrentPaneDomain"},
})

-- move current pane to new tab: <cmd-t>
table.insert (M.keys, {
  key     = "mapped:t",
  mods    = "SUPER",
  action  = callback (
    function (_, pane)
      local tab, _ = pane:move_to_new_tab()
      tab:activate()
    end
  )
})

-- close tab: <cmd-w>
table.insert (M.keys, {
  key     = "mapped:w",
  mods    = "SUPER",
  action  = action {CloseCurrentTab = {confirm = true}},
})

-- activate last tab: <cmd-:>
table.insert (M.keys, {
  key     = "mapped::",
  mods    = "SUPER",
  action  = action.ActivateLastTab,
})

-- activate prev, next tab: <cmd-[>, <cmd-]>
for k, dir in pairs {
  ["["] = -1,
  ["]"] =  1,
} do
  table.insert (M.keys, {
    key     = "mapped:" .. k,
    mods    = "SUPER",
    action  = action {ActivateTabRelative = dir},
  })
end

-- activate tab #i: <cmd-i>
for i = 1, 9 do
  table.insert (M.keys, {
    key     = "mapped:" .. tostring(i),
    mods    = "SUPER",
    action  = action {ActivateTab = i-1},
  })
end


------------------------------------------------------------------------------
--> pane management
--  mnemonic: <leader> [consistent with tmux]
------------------------------------------------------------------------------
-- new vertical split to the right
for _, key in ipairs {"/",} do
  table.insert (M.keys, {
    key     = "mapped:" .. key,
    mods    = "LEADER",
    action  = action {SplitHorizontal = {domain = "CurrentPaneDomain"}},
  })
end

-- new horizontal split below
for _, key in ipairs {"-",} do
  table.insert (M.keys, {
    key     = "mapped:" .. key,
    mods    = "LEADER",
    action  = action {SplitVertical = {domain = "CurrentPaneDomain"}},
  })
end

-- toggle panel zoom: <leader>z
table.insert (M.keys, {
  key     = "mapped:z",
  mods    = "LEADER",
  action  = action.TogglePaneZoomState,
})

-- pane navigation by direction: <leader><dir> [Dvorak mappings]
for k, dir in pairs {
  ["d"] = "Left",
  ["n"] = "Right",
  ["t"] = "Up",
  ["h"] = "Down",
} do
  table.insert(M.keys, {
    key     = "mapped:" .. k,
    mods    = "LEADER",
    action  = action {ActivatePaneDirection = dir},
  })
end

-- pane navigation by direct selection, pane #i: <leader>i
for i  =  1, 9
do
    table.insert (M.keys, {
        key = tostring(i),
        mods = "LEADER",
        action = action {ActivatePaneByIndex = i-1},
    })
end

-- pane navigation by direct selection (alt), pane #i: <alt-i>
for i  =  1, 9
do
    -- regular Dvorak layout
    table.insert (M.keys, {
        key = tostring(i),
        mods = "ALT",
        action = action {ActivatePaneByIndex = i-1},
    })

    -- Programmer Dvorak layout, with SHIFT modifier
    table.insert (M.keys, {
        key = "mapped:" .. tostring(i),
        mods = "SHIFT|ALT",
        action = action {ActivatePaneByIndex = i-1},
    })
end

-- Same, for Programmer Dvorak keyboard without SHIFT modifier
local unshifted = "()}+{]&!="       -- 123456789, no zero
for i = 1, unshifted:len()
do
    table.insert (M.keys, {
        key = "mapped:" .. unshifted:sub(i,i),  -- can't bracket index strings
        mods = "ALT",
        action = action {ActivatePaneByIndex = i-1},
    })
end

-- pane navigation by direct selection using displayed numbers (mnemonic: 'go')
-- https://wezfurlong.org/wezterm/config/lua/keyassignment/PaneSelect.html
table.insert (M.keys, {
  key     = "mapped:g",
  mods    = "LEADER",
  action  = action.PaneSelect {alphabet = "1234567890",},
})

-- *swap* current pane content for that of pane specified by number.
-- https://wezfurlong.org/wezterm/config/lua/keyassignment/PaneSelect.html
table.insert (M.keys, {
  key     = "mapped:g",
  mods    = "LEADER|SHIFT",
  action  = action.PaneSelect {
    mode = 'SwapWithActive',
    alphabet = "1234567890",
  },
})

-- rotate pane content without changing active pane
-- https://wezfurlong.org/wezterm/config/lua/keyassignment/RotatePanes.html
for k, dir in pairs {
  ["r"] = "Clockwise",
  ["R"] = "CounterClockwise",
} do
  table.insert (M.keys, {
    key     = "mapped:" .. k,
    mods    = "LEADER",
    action  = action.RotatePanes (dir),
  })
end

-- fine pane resizing: <:><ctrl><dir> [Dvorak mappings]
for k, dir in pairs {
  ["d"] = "Left",
  ["n"] = "Right",
  ["t"] = "Up",
  ["h"] = "Down",
} do
  table.insert (M.keys, {
    key     = "mapped:" .. k,
    mods    = "LEADER|CTRL",
    action  = action {AdjustPaneSize = {dir, 1}},
  })
end

-- coarse pane resizing: <leader><ctrl-alt><dir> [Dvorak mappings]
for k, dir in pairs {
  ["d"] = "Left",
  ["n"] = "Right",
  ["t"] = "Up",
  ["h"] = "Down",
} do
  table.insert (M.keys, {
    key     = "mapped:" .. k,
    mods    = "LEADER|SHIFT|CTRL",
    action  = action {AdjustPaneSize = {dir, 3}},
  })
end

-- close pane: <leader>w
table.insert (M.keys, {
  key     = "mapped:w",
  mods    = "LEADER",
  action  = action {CloseCurrentPane = {confirm = true}},
})


return M
