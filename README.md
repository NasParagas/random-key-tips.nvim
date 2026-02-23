# random-key-tips.nvim
NOTE: This plugin (and this README) is **Under construction** 
- Notify random keys as tips.
- Currently, only confirmed operation in neovim nightly (but I think it maybe works.)

## Installation
`lazy.nvim`
```lua
return {
	"NasParagas/random-key-tips.nvim",
	event = "VeryLazy",
	config = function()
		require("random-key-tips").setup({ interval = 15000 })
	end,
}
```

## Recommendation
- Using a notification plugin such as`nvim-notify` or `noice.nvim` provides a confortable experience
