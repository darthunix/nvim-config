return {
  "mrcjkb/rustaceanvim",
  init = function()
    local cargo_home = vim.env.CARGO_HOME or vim.fn.expand("~/.cargo")

    vim.g.rustaceanvim = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              noDefaultFeatures = false,
              features = { "default" },
              buildScripts = { enable = true },

              -- Separate rust-analyzer artifacts from normal cargo builds.
              targetDir = true,
            },
            procMacro = { enable = true },
            hover = {
              memoryLayout = {
                enable = true,
                size = "both",
                offset = "hexadecimal",
                alignment = "hexadecimal",
                niches = true,
              },
            },

            -- If you want no check-on-save:
            checkOnSave = false,

            files = {
              excludeDirs = {
                ".git",
                "monitoring",
                "tarantool/target",
                "tarantool-sys",
                "target",
                "test",
                "tools",
                "venv",
                "vshard",
                "webui",
                cargo_home .. "/registry",
                cargo_home .. "/git",
              },
              watcher = "server",
            },
            workspace = { symbol = { search = { limit = 5120 } } },
          },
        },
      },
    }
  end,
}
