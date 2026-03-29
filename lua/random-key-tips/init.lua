local M = {}

-- Default configuration
local default_config = {
	interval = 15000, -- ms
	auto_start = false, -- Control auto-start behavior
}

local timer = vim.uv.new_timer()

-- Get keymap randomly
local function get_random_keymap()
	math.randomseed(os.time())

	-- Currently, get keymaps in normal mode only
	-- TODO: Implement other modes (insert, visual, terminal)
	local normal_keymaps = vim.api.nvim_get_keymap("n")

	local candidates = {}

	-- Only collect keymaps that have a description
	for _, map in ipairs(normal_keymaps) do
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

-- Start displaying tips
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

-- Stop displaying tips
local function stop_tips()
	timer:stop()
end

M.setup = function(opts)
	-- Merge user options with default config
	opts = vim.tbl_deep_extend("force", default_config, opts or {})

	-- Create commands for manual control
	vim.api.nvim_create_user_command("TipsStart", function()
		start_display_keymap_tips(opts.interval)
	end, { desc = "Start keymap tips" })

	vim.api.nvim_create_user_command("TipsStop", stop_tips, { desc = "Stop keymap tips" })

	-- Start automatically only if auto_start is true
	if opts.auto_start then
		start_display_keymap_tips(opts.interval)
	end
end

return M
