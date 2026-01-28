return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- ✅ Required: Do not lazy-load
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("markview").setup({
        markdown = {
          enable = true,
          -- Customize as needed (e.g., code blocks, headings)
        },
      })
      vim.keymap.set("n", "mt", "<cmd>Markview toggle<cr>", { desc = "Toggle Markview" })
    end,
  },
}
