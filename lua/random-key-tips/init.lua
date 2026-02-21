local M = {}

-- デフォルト設定
local default_config = {
	interval = 15000, -- ミリ秒
}

local timer = vim.uv.new_timer()

-- ランダムにキーマップ取得する関数
local function get_random_keymap()
	-- 乱数シードを初期化（毎回違う結果が出るようにする）
	math.randomseed(os.time())

	-- normalモードのkeymapを全て取得(配列)
	local keymaps = vim.api.nvim_get_keymap("n")

	-- 最終的な取得keymap候補
	local candidates = {}

	-- descが記載されているものだけ受け取る
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

-- tips表示開始
local function start_display_keymap_tips(interval)
	timer:stop() -- 既存のタイマーがあれば止める
	timer:start(
		0, -- 開始までの待ち時間
		interval, -- 繰り返す間隔
		vim.schedule_wrap(function()
			local keymap_tip = get_random_keymap()
			if keymap_tip then
				vim.notify(
					string.format("💡 Tip: %s | Cmd: %s", keymap_tip.lhs, keymap_tip.desc),
					vim.log.levels.INFO,
					{ title = "Keymap tips" }
				)
			end
		end)
	)
end

-- tips表示停止
local function stop_tips()
	timer:stop()
end

M.setup = function(opts)
	-- 設定のマージ
	opts = vim.tbl_deep_extend("force", default_config, opts or {})

	-- コマンド登録
	vim.api.nvim_create_user_command("TipsStart", function()
		start_display_keymap_tips(opts.interval)
	end, { desc = "Start keymap tips" })

	vim.api.nvim_create_user_command("TipsStop", stop_tips, { desc = "Stop keymap tips" })

	-- 初回起動
	start_display_keymap_tips(opts.interval)
end

return M
