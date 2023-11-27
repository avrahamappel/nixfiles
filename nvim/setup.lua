require 'impatient'

-- Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

------------------------------
-- Treesitter configuration --
------------------------------
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
        -- A list of parsers that add highlight groups unsupported by Molokai
        disable = { "diff", "html", "gitcommit" },
    },
    refactor = {
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "gs",
            }
        },
        navigation = {
            enable = true,
            keymaps = {
                goto_definition_lsp_fallback = "gtd",
                list_definitions_toc = "gta",
                goto_next_usage = "]t",
                goto_previous_usage = "[t",
            },
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },
    }
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
        source = "always",
    },
})

local lspconfig = require 'lspconfig'

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Mappings
local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = true }
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    --  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    --  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    --  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>c', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>w', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>l', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
end

-- Globally enabled servers
local servers = {
    'bashls',
    'cssls',
    'elmls',
    'eslint',
    'html',
    'jsonls',
    'lemminx',
    'lua_ls',
    'nil_ls',
    'pylsp',
    'rnix',
    'taplo',
    'vimls',
    'yamlls'
}

-- Server-specific settings
local settings = {
    json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
    },

    Lua = {
        runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
        },
        diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim', 'registerLsps' },
        },
        workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
        },
    },

    ['nil'] = {
        formatting = {
            command = { "nixpkgs-fmt" },
        },
    },

    ['rust-analyzer'] = {
        checkOnSave = {
            command = 'clippy',
            extraArgs = { '--', '-Wclippy::pedantic' },
        },
    },

    yaml = {
        keyOrdering = false,
        schemaStore = { enable = true },
    },
}


-- Global function to allow for project-level LSP config
function registerLsps(args)
    local lsps = args.lsps or {}
    local lsp_settings = args.lsp_settings or {}
    local commands = args.commands or {}
    local root_dirs = args.root_dirs or {}

    local setup_opts = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = lsp_settings,
    }

    for _, lsp in ipairs(lsps) do
        if commands[lsp] then
            setup_opts.cmd = commands[lsp]
        end

        if root_dirs[lsp] then
            setup_opts.root_dir = root_dirs[lsp]
        end

        lspconfig[lsp].setup(setup_opts)
    end
end

registerLsps { lsps = servers, settings = settings }

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

---------------------------
-- Null LS Configuration --
---------------------------
local null_ls = require 'null-ls'

null_ls.setup {
    sources = {
        -- If and when version 2023-06-28 of null-ls is merged into NixOS 23.05 (or I start using the unstable channel),
        -- we can switch from codespell to typos, which is apparently better (and written in Rust!)
        null_ls.builtins.diagnostics.codespell.with {
            extra_args = { "--ignore-words", vim.fn.expand("~/.config/codespell/ignore-words") }
        },
    }
}

------------------------------
-- Rust Tools Configuration --
------------------------------
local rt = require("rust-tools")

rt.setup({
    server = {
        on_attach = function(_arg, bufnr)
            -- Call normal on_attach function
            on_attach(_arg, bufnr)
            -- Hover actions
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>C", rt.code_action_group.code_action_group, { buffer = bufnr })
        end,
        settings = settings
    },
    tools = {
        inlay_hints = {
            only_current_line = true,
        },
    },
})

---------------------------
-- typescript.nvim setup --
---------------------------
require("typescript").setup({
    server = {
        on_attach = on_attach,
        settings = settings,
    }
})

-- nvim-cmp setup
local cmp = require 'cmp'
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
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
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
        { name = 'treesitter' }
    },
    {
        { name = 'buffer' },
    },
})

require 'lsp_signature'.setup({
    hint_prefix = "", -- no panda
    floating_window = false, -- don't need the whole honkin' window
})

-- Disable diagnostics in .env files
local group = vim.api.nvim_create_augroup("__env", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = ".env*",
    group = group,
    callback = function(args)
        vim.diagnostic.disable(args.buf)
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

-- Load local config
require('config-local').setup {
    config_files = { ".vimrc.lua" }
}
