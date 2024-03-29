vim.g.mapleader = '\\'

local opt = vim.opt
opt.clipboard = 'unnamedplus'
opt.wrap = false
opt.relativenumber = true
opt.showmode = false
opt.mouse = 'a'
opt.signcolumn = 'number'
opt.syntax = 'enabled'
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.hidden = true
opt.expandtab = true
opt.smartindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.termguicolors = true
opt.updatetime = 300
opt.shortmess = 'filnxtToOFc'

require('plugins')

local cmd = vim.cmd
cmd('colorscheme kanagawa')
-- cmd('let g:lightline = { \'colorscheme\': \'nightowl\'}')
cmd('hi Comment guifg=#637777 ctermfg=243 gui=None cterm=None')
cmd('filetype plugin indent on')

local map = vim.api.nvim_set_keymap
local function nm(key, command)
    map('n', key, command, { noremap = true })
end

local function tm(key, command)
    map('t', key, command, { noremap = true })
end


nm('<leader>r', ':NvimTreeRefresh<CR>')
nm('<leader>n', ':NvimTreeFindFile<CR>')
nm('<leader>e', ':NvimTreeToggle<CR>')
nm('<C-n>', ':tabnew<CR>')
nm('<C-h>', ':bprevious<CR>')
nm('<C-l>', ':bnext<CR>')
nm('<A-h>', '<C-w>h')
nm('<A-j>', '<C-w>j')
nm('<A-k>', '<C-w>k')
nm('<A-l>', '<C-w>l')

tm('<Esc>', '<C-\\><C-n>')


-- Bufferline
require("bufferline").setup {
    highlights = {
        buffer_selected = {
            italic = false
        }
    }
}

-- Autopairs
require('nvim-autopairs').setup {}

-- Lualine
require('lualine').setup {
    options = {
        theme = 'everforest',
        icons_enabled = true,
        component_separators = '|',
        section_separators = '',
    }
}

-- Comment
require('Comment').setup()

-- Indent
require('indent_blankline').setup {
    char = '┊',
    show_trailing_blankline_indent = false,
}

-- Telescope
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
            },
        }, require("bufferline").setup {}
    },
}
local builtin = require('telescope.builtin')
vim.keymap.set('n', 'ff', builtin.find_files, { desc = '[F]ind [F]ile' })
vim.keymap.set('n', 'fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', 'fb', builtin.buffers, { desc = '[F]ind existing [B]uffers' })
vim.keymap.set('n', 'fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
-- Enable extension
pcall(require('telescope').load_extension, 'fzf')
vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer]' }
)

-- Treesitter
-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'go', 'lua', 'python', 'help', 'vim', 'rust' },

    highlight = { enable = true },
    indent = { enable = true, disable = { 'python' } },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<c-backspace>',
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
                ['<leader>A'] = '@parameter.inner',
            },
        },
    },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

--- Nvim-tree
require('nvim-tree').setup {
    respect_buf_cwd = true,
    disable_netrw = true,
    sort_by = "name",
    renderer = {
        highlight_git = true,
        special_files = { 'README.md', 'Makefile', 'MAKEFILE', 'Dockerfile' },
        highlight_opened_files = 'icon',
        group_empty = true,
        indent_width = 3,
        indent_markers = {
            enable = true,
        },
        icons = {
            show = {
                git = false,
                folder_arrow = false,
            },
        },
    },
}

-- LSP settings.
-- This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
local servers = {
    pyright = {}
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Mason
require('mason').setup()
local mason_lspconfig = require 'mason-lspconfig'
mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}
mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
        }
    end,
}

-- Turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-d>'] = cmp.mapping.scroll_docs( -4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable( -1) then
                luasnip.jump( -1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}
