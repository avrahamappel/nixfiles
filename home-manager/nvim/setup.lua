------------------------------
-- Treesitter configuration --
------------------------------
---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
    },
    -- refactor = {
    --     smart_rename = {
    --         enable = true,
    --         keymaps = {
    --             smart_rename = "gs",
    --         }
    --     },
    --     navigation = {
    --         enable = true,
    --         keymaps = {
    --             goto_definition_lsp_fallback = "gtd",
    --             list_definitions_toc = "gta",
    --             goto_next_usage = "]t",
    --             goto_previous_usage = "[t",
    --         },
    --     },
    --     incremental_selection = {
    --         enable = true,
    --         keymaps = {
    --             init_selection = "gnn",
    --             node_incremental = "grn",
    --             scope_incremental = "grc",
    --             node_decremental = "grm",
    --         },
    --     },
    -- }
}

-----------------------
-- LSP configuration --
-----------------------

vim.diagnostic.config({
    -- Don't show diagnostic messages in a virtual line
    virtual_text = false,
    severity_sort = true,
    float = {
        -- Show diagnostics sources
        source = true,
    },
})

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Server-specific settings
vim.lsp.config('jsonls', {
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
        }
    }
})
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    }
})
vim.lsp.config('nixd', {
    settings = {
        nixd = {
            formatting = {
                command = { "nixpkgs-fmt" },
            },

            -- Include home-manager options by setting this
            -- options = {
            --     home-manager = {
            --         expr = "some expression"
            --     }
            -- }
            -- see https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md#options-options
        },
    }
})
vim.lsp.config('rust_analyzer', {
    settings = {
        ['rust-analyzer'] = {
            check = {
                command = 'clippy',
                extraArgs = { '--', '-Wclippy::pedantic' },
            },
          }
    }
})
vim.lsp.config('yamlls', {
    settings = {
        yaml = {
            keyOrdering = false,
            schemaStore = { enable = true },
        },
    }
})

-- Globally enabled servers
vim.lsp.enable('bashls')
vim.lsp.enable('cssls')
vim.lsp.enable('eslint')
vim.lsp.enable('html')
vim.lsp.enable('jsonls')
vim.lsp.enable('lemminx')
vim.lsp.enable('lua_ls')
vim.lsp.enable('nixd')
vim.lsp.enable('pylsp')
vim.lsp.enable('taplo')
vim.lsp.enable('ts_ls')
vim.lsp.enable('typos_lsp')
vim.lsp.enable('vimls')
vim.lsp.enable('yamlls')

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

-- nvim-cmp setup
local cmp = require 'cmp'
-- following code copied from here: https://github.com/zbirenbaum/copilot-cmp/?tab=readme-ov-file#tab-completion-configuration-highly-recommended
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm {
            select = true,
        },
        ["<Tab>"] = vim.schedule_wrap(function(fallback)
          if cmp.visible() and has_words_before() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end),
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'treesitter' },
        { name = 'vim-dadbod-completion' },
        { name = 'copilot', group_index = 2 },
    },
    {
        { name = 'buffer' },
    },
})

require 'lsp_signature'.setup({
    hint_prefix = "",        -- no panda
    floating_window = false, -- don't need the whole honkin' window
})

-- Disable diagnostics in .env files
local group = vim.api.nvim_create_augroup("__env", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = ".env*",
    group = group,
    callback = function(args)
        vim.diagnostic.enable(false, { bufnr = args.buf })
    end
})

-- Wrapper around :terminal to run shell aliases without having to jump into an interactive shell
-- 'X' is for 'eXecute'
vim.api.nvim_create_user_command('X', function(args)
    vim.cmd.terminal(string.format("direnv exec . zsh -i -c '%s'", table.concat(args.fargs, ' ')));
end, {
    desc = "a wrapper around :terminal to run shell aliases without having to jump into an interactive shell",
    force = false,
    nargs = '+',
});
-- Map for the above.
vim.api.nvim_set_keymap('', "<leader>x", ":X ", {});
