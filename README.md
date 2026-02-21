# random-key-tips.nvim
NOTE: **Under construction**
Notify random keys as tips.

## Installation
`lazy.nvim`
```lua
return {
	"NasParagas/random-key-tips.nvim",
	event = "VeryLazy",
	config = function()
		require("random-key-tips").setup({ interval = 5000 })
	end,
}
```
