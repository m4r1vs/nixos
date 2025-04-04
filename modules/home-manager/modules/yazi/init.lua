---@diagnostic disable: undefined-global

-- Sync yank clipboard across instances
require("session"):setup {
  sync_yanked = true,
}

require("git"):setup()

-- Remove percentage from status bar
function Status:percentage()
end

-- Show symlink path in status bar
function Status:name()
  local h = self._tab.current.hovered
  if not h then
    return ui.Line {}
  end

  local linked = ""
  if h.link_to ~= nil then
    linked = " -> " .. tostring(h.link_to)
  end
  return ui.Line(" " .. h.name .. linked)
end
