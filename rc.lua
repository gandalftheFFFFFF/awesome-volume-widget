...

vol_widget = wibox.widget {
  text = "vol:---",
  align = 'center',
  valign = 'center',
  widget = wibox.widget.textbox,
  font = "monospace 8"
}

local function extract_volume_text(stdout)
  local mute = string.match(stdout, "%[(o%D%D?)%]")
  local volume_percent = string.match(stdout, "(%d?%d?%d)%%")
  local volume_text = volume_percent
  if mute == "off" then volume_text = "off"
  end
  return volume_text
end

awful.spawn.easy_async("amixer sget Master", function(stdout, b, c, d)
  vol_widget.text = "vol:" .. string.format("%3s", extract_volume_text(stdout))
end)

local function update_vol_widget(widget, stdout)
  local volume_text = extract_volume_text(stdout)
  widget.text = "vol:" .. string.format("%3s", volume_text)
end

local update_vol_function = function(stdout, stderr, exitreason, exitcode)
  update_vol_widget(vol_widget, stdout)
end

vol_widget:buttons(awful.util.table.join(
  awful.button({ }, 1, function()
    awful.spawn.easy_async("amixer -D pulse sset Master toggle", update_vol_function)
  end),
  awful.button({ }, 4, function()
    awful.spawn.easy_async("amixer -D pulse sset Master 5%+", update_vol_function)
  end),
  awful.button({ }, 5, function()
    awful.spawn.easy_async("amixer -D pulse sset Master 5%-", update_vol_function)
  end)
))

...

-- Add widgets to the wibox
s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
        layout = wibox.layout.fixed.horizontal,
        mylauncher,
        s.mytaglist,
        s.mypromptbox,
    },
    s.mytasklist, -- Middle widget
    { -- Right widgets
        layout = wibox.layout.fixed.horizontal,
        vol_widget,
        mykeyboardlayout,
        wibox.widget.systray(),
        battery_widget,
        mytextclock,
        s.mylayoutbox,
    },
}

...
