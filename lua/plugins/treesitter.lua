return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "javascript",
        "typescript",
        "tsx",
        "vue",
        "astro",
        "css",
        "html",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "yaml",
        "vim",
        "vimdoc",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    },
  },
}
