local M = {}

-- default
local default_config = {
	interval = 15000, -- ms
}

local timer = vim.uv.new_timer()

-- get keymap randomly
local function get_random_keymap()
	math.randomseed(os.time())

	-- Currentry, get keymaps in normal mode only
	-- TODO: Other mode
	local keymaps = vim.api.nvim_get_keymap("n")

	local candidates = {}

	-- only have desc
	for _, map in ipairs(keymaps) do
		if map.desc and map.desc ~= "" then
			table.insert(candidates, {
				lhs = map.lhs,
				desc = map.desc,
			})
		end
	end

	if #candidates == 0 then
		return nil
	end

	return candidates[math.random(#candidates)]
end

-- tips start
local function start_display_keymap_tips(interval)
	timer:stop()
	timer:start(
		0, -- wait time to start
		interval,
		vim.schedule_wrap(function()
			local keymap_tip = get_random_keymap()
			if keymap_tip then
				vim.notify(
					string.format("💡 Key Tips: %s | %s", keymap_tip.lhs, keymap_tip.desc),
					vim.log.levels.INFO,
					{ title = "Keymap tips" }
				)
			end
		end)
	)
end

-- tips stop
local function stop_tips()
	timer:stop()
end

M.setup = function(opts)
	-- merge setting?
	opts = vim.tbl_deep_extend("force", default_config, opts or {})

	-- create command
	vim.api.nvim_create_user_command("TipsStart", function()
		start_display_keymap_tips(opts.interval)
	end, { desc = "Start keymap tips" })
	vim.api.nvim_create_user_command("TipsStop", stop_tips, { desc = "Stop keymap tips" })

	-- start
	start_display_keymap_tips(opts.interval)
end

return M
