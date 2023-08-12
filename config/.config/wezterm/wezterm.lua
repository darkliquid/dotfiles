local wezterm = require 'wezterm'

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- ui
config.color_scheme = 'GitHub Dark'
config.font = wezterm.font 'IntelOne Mono'
config.cursor_blink_rate = 0
config.enable_scroll_bar = true
config.use_fancy_tab_bar = false
config.colors = {
  tab_bar = {
      background = "#101216",
      new_tab = {bg_color = "#101216", fg_color = "#56d364", intensity = "Bold"},
      new_tab_hover = {bg_color = "#101216", fg_color = "#3b5070", intensity = "Bold"},
      active_tab = {bg_color = "#101216", fg_color = "#56d364"},
    }
}
config.window_padding = {
  left = 0,
  top = 0,
  bottom = 0,
  right = 0
}

local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
local SOLID_LEFT_MOST = utf8.char(0x2588)
local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)

local ADMIN_ICON = utf8.char(0xf49c)

local CMD_ICON = utf8.char(0xe62a)
local PS_ICON = utf8.char(0xebc7)
local WSL_ICON = utf8.char(0xe62a)

local VIM_ICON = utf8.char(0xe62b)
local PAGER_ICON = utf8.char(0xf718)
local FUZZY_ICON = utf8.char(0xf0b0)
local HOURGLASS_ICON = utf8.char(0xf252)

local PYTHON_ICON = utf8.char(0xf820)
local NODE_ICON = utf8.char(0xe74e)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local edge_background = "#101216"
  local background = "#8b949e"
  local foreground = "#101216"
  local dim_foreground = "#3b5070"

  if tab.is_active then
    background = "#56d364"
    foreground = "#101216"
  elseif hover then
    background = "#3b5070"
    foreground = "#101216"
  end

  local edge_foreground = background
  local process_name = tab.active_pane.foreground_process_name
  local pane_title = tab.active_pane.title
  local exec_name = basename(process_name):gsub("%.exe$", "")
  local title_with_icon

  if exec_name == "pwsh" or exec_name == "powershell" then
    title_with_icon = PS_ICON .. " PS"
  elseif exec_name == "cmd" then
    title_with_icon = CMD_ICON .. " CMD"
   elseif exec_name == "wsl" or exec_name == "wslhost" then
    title_with_icon = WSL_ICON .. " WSL"
   elseif exec_name == "nvim" or exec_name == "neovim" or exec_name == "vi" or exec_name == "vim" then
    title_with_icon = VIM_ICON .. pane_title:gsub("^(%S+)%s+(%d+/%d+) %- nvim", " %2 %1")
  elseif exec_name == "bat" or exec_name == "less" or exec_name == "moar" or exec_name == "ov" then
    title_with_icon = PAGER_ICON .. " " .. exec_name:upper()
  elseif exec_name == "fzf" or exec_name == "hs" or exec_name == "peco" then
    title_with_icon = FUZZY_ICON .. " " .. exec_name:upper()
   elseif exec_name == "python" or exec_name == "hiss" then
    title_with_icon = PYTHON_ICON .. " " .. exec_name
  elseif exec_name == "node" then
    title_with_icon = NODE_ICON .. " " .. exec_name:upper()
  else
    title_with_icon = HOURGLASS_ICON .. " " .. exec_name
  end
  if pane_title:match("^Administrator: ") then
    title_with_icon = title_with_icon .. " " .. ADMIN_ICON
  end
  local left_arrow = SOLID_LEFT_ARROW
  if tab.tab_index == 0 then
    left_arrow = SOLID_LEFT_MOST
  end
  local title = " " .. wezterm.truncate_right(title_with_icon, max_width-2) .. " "

  return {
    {Attribute={Intensity="Bold"}},
    {Background={Color=edge_background}},
    {Foreground={Color=edge_foreground}},
    {Text=left_arrow},
    {Background={Color=background}},
    {Foreground={Color=foreground}},
    {Text=title},
    {Foreground={Color=dim_foreground}},
    {Background={Color=edge_background}},
    {Foreground={Color=edge_foreground}},
    {Text=SOLID_RIGHT_ARROW},
    {Attribute={Intensity="Normal"}},
  }
end)

-- links
config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
  regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
  format = 'https://www.github.com/$1/$3',
})

-- misc
config.exit_behavior = 'Close'
config.term = 'wezterm'

-- launcher
local launch_menu = {}
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  table.insert(launch_menu, {
    label = 'PowerShell',
    args = { 'c:\\Users\\darkl\\scoop\\apps\\pwsh\\current\\pwsh.exe' },
    cwd = wezterm.home_dir,
    domain = { DomainName = 'local' }
  })
  table.insert(launch_menu, {
    label = 'WSL',
    args = { 'bash', '-l' },
  })

  -- override wsl domains and default to using it
  config.wsl_domains = {
    {
      name = "WSL:Distrod",
      distribution = "Distrod",
      default_cwd = "/home/darkl"
    }
  }
  config.default_domain = "WSL:Distrod"
end
config.launch_menu = launch_menu

-- key binds
config.keys = {
  { key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|TABS|LAUNCH_MENU_ITEMS' } },
}


return config

