local navic = require 'nvim-navic'
local util = require 'lspconfig.util'

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
local function tprint(tbl, indent)
    if not indent then
        indent = 0
    end
    for k, v in pairs(tbl) do
        local formatting = string.rep('  ', indent) .. k .. ': '
        if type(v) == 'table' then
            print(formatting)
            tprint(v, indent + 1)
        else
            print(formatting .. tostring(v))
        end
    end
end

require('nvim-treesitter.configs').setup({
    ensure_installed = {
        'c',
        'lua',
        'vim',
        'vimdoc',
        'query',
        'typescript',
        'css',
        'scss',
        'javascript',
        'markdown',
        'markdown_inline',
        'python',
        'tsx',
        'bash',
        'fish',
        'json',
        'http',
        'yaml',
    },
    highlight = {
        enable = true,
    },
    auto_install = true,
    indent = { enable = true },
    autotag = { enable = true, enable_close_on_slash = false },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-s>',
            node_incremental = '<c-s>',
        },
    },
    textobjects = {
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']f'] = '@function.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
            },
            goto_previous_start = {
                ['[f'] = '@function.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
            },
        },
        select = {
            enable = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
            },
        },
    },
})

-- 1. Helper to find the command (from previous step)
local function get_lint_cmd()
    local default_cmd =
        "npx eslint 'src/**/*.{ts,tsx}' --no-color --format stylish"
    local f = io.open('package.json', 'r')
    if f then
        local content = f:read '*a'
        f:close()
        local ok, data = pcall(vim.json.decode, content)
        if ok and data and data.scripts then
            for _, name in ipairs({ 'eslint', 'eslint-check', 'lint' }) do
                if data.scripts[name] then
                    -- Pass args to ensure format is parsable
                    return 'npm run '
                        .. name
                        .. ' -- --no-color --format stylish'
                end
            end
        end
    end
    return default_cmd
end

-- 2. Spinner Configuration
local spinner_frames =
    { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

vim.api.nvim_create_user_command('LintProject', function()
    local cmd = get_lint_cmd()
    local lines = {}

    -- Check for nvim-notify
    local has_notify, notify = pcall(require, 'notify')
    local notif_data = nil
    local spinner_idx = 1
    local timer = nil

    -- Helper to update the notification
    local function update_spinner()
        if not has_notify then
            return
        end

        notif_data = notify('Linting Project...', 'info', {
            title = 'ESLint',
            icon = spinner_frames[spinner_idx],
            replace = notif_data, -- This is the magic key that updates in-place
            hide_from_history = true,
        })

        spinner_idx = (spinner_idx % #spinner_frames) + 1
    end

    -- Start the animation if notify is present, otherwise just print
    if has_notify then
        timer = vim.uv.new_timer() -- Use vim.loop for Neovim < 0.10
        timer:start(0, 100, vim.schedule_wrap(update_spinner))
    else
        print 'Running Project Lint...'
    end

    -- ... (keep get_lint_cmd and spinner logic from previous step) ...

    vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= '' then
                        table.insert(lines, line)
                    end
                end
            end
        end,
        on_exit = function(_, code)
            -- 1. Stop Spinner
            if timer then
                timer:stop()
                timer:close()
            end

            -- 2. PARSE FIRST: Populate the Quickfix list to let Vim do the math
            if #lines > 0 then
                vim.fn.setqflist({}, 'r', {
                    title = 'ESLint Project',
                    lines = lines,
                    -- Stylish format pattern
                    efm = table.concat({
                        '%-P%f', -- Push filename (context, not an error)
                        '%\\s%#%l:%c  %t%\\w%#  %m', -- The actual error line
                        '%-G%.%#', -- Ignore everything else
                    }, ','),
                })
            else
                vim.fn.setqflist({}, 'r')
            end

            -- 3. COUNT ACCURATELY: filter for valid entries only
            local qf_items = vim.fn.getqflist()
            local error_count = 0
            for _, item in ipairs(qf_items) do
                if item.valid == 1 then
                    error_count = error_count + 1
                end
            end

            -- 4. Determine Notification State
            local is_success = (code == 0) and (error_count == 0)
            local icon = is_success and '' or ''
            local level = is_success and 'info' or 'error'
            local title = 'ESLint Finished'
            local msg = is_success and 'Clean! No errors found.'
                or string.format('Found %d issues.', error_count)

            -- 5. Show Notification
            if has_notify then
                notify(msg, level, {
                    title = title,
                    icon = icon,
                    replace = notif_data,
                    timeout = 3000,
                })
            else
                print(title .. ': ' .. msg)
            end

            -- 6. Open Window if errors exist
            if error_count > 0 then
                vim.cmd 'copen'
            end
        end,
    })
end, {})

vim.api.nvim_create_user_command('LintJson', function()
    local cmd = "npx eslint --format json 'src/**/*.{ts,tsx}'"

    print 'Running Project Lint (JSON)...'
    local output_lines = {}

    vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    table.insert(output_lines, line)
                end
            end
        end,
        on_exit = function(_, code)
            local json_str = table.concat(output_lines, '\n')

            -- Handle empty output
            if json_str:match '^%s*$' then
                print 'Linting complete: No output returned.'
                vim.fn.setqflist({}, 'r')
                return
            end

            -- Decode JSON
            local ok, results = pcall(vim.json.decode, json_str)
            if not ok then
                print 'Error: Could not parse ESLint JSON output.'
                return
            end

            local qf_list = {}

            -- Build the list manually
            for _, file_result in ipairs(results) do
                local filename = file_result.filePath
                for _, msg in ipairs(file_result.messages) do
                    table.insert(qf_list, {
                        filename = filename,
                        lnum = msg.line,
                        col = msg.column,
                        text = msg.message
                            .. ' ['
                            .. (msg.ruleId or 'unknown')
                            .. ']',
                        type = (msg.severity == 2) and 'E' or 'W',
                    })
                end
            end

            if #qf_list == 0 then
                print 'Linting complete: No errors found.'
                vim.fn.setqflist({}, 'r')
            else
                -- Set the list using the 'items' property to avoid the E475 error
                vim.fn.setqflist({}, 'r', {
                    title = 'ESLint Project (JSON)',
                    items = qf_list,
                })

                vim.cmd 'copen'
                print('Linting complete: ' .. #qf_list .. ' issues found.')
            end
        end,
    })
end, {})

-- LSP settings.
vim.diagnostic.config({ virtual_text = false, update_in_insert = false })

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        local nmap = function(keys, func, desc)
            if desc then
                desc = 'LSP: ' .. desc
            end

            vim.keymap.set('n', keys, func, { buffer = args.buf, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, 'Rename')
        nmap('<leader>a', vim.lsp.buf.code_action, 'Action')
        vim.keymap.set(
            'x',
            '<leader>a',
            vim.lsp.buf.code_action,
            { buffer = args.buf }
        )

        nmap('gi', vim.lsp.buf.implementation, 'Goto Implementation')
        nmap('gy', vim.lsp.buf.type_definition, 'Type definition')
        nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')

        -- See `:help K` for why this keymap
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

        if client.server_capabilities.documentSymbolProvider then
            navic.attach(client, args.buf)
        end

        if client.server_capabilities.documentHighlightProvider then
            nmap(
                '<leader>sh',
                vim.lsp.buf.document_highlight,
                'Highlight symbol'
            )
            nmap(
                '<leader>ch',
                vim.lsp.buf.clear_references,
                'Clear highlight symbol'
            )
        end

        if client.name == 'eslint' then
            vim.api.nvim_create_autocmd('BufWritePre', {
                pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
                command = 'silent! EslintFixAll',
                group = vim.api.nvim_create_augroup(
                    'MyAutocmdsJavaScripFormatting',
                    {}
                ),
            })
        end

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(args.buf, 'Format', function(_)
            vim.lsp.buf.format({ timeout_ms = 2000 })
        end, { desc = 'Format current buffer with LSP' })

        vim.api.nvim_buf_create_user_command(
            args.buf,
            'OrganizeImports',
            function(_)
                local params = {
                    command = '_typescript.organizeImports',
                    arguments = { vim.api.nvim_buf_get_name(0) },
                    title = '',
                }
                vim.lsp.buf.execute_command(params)
                vim.cmd 'EslintFixAll'
            end,
            { desc = 'Organize Imports' }
        )

        if
            client.name == 'golangci_lint_ls'
            or client.name == 'gopls'
            or client.name == 'tsgolsp'
        then
            vim.diagnostic.config({ update_in_insert = true })
        end

        if client.name == 'biome' then
            vim.diagnostic.config({ update_in_insert = true })
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup(
                    'BiomeFixAll',
                    { clear = true }
                ),
                callback = function()
                    vim.lsp.buf.code_action({
                        context = {
                            only = { 'source.fixAll.biome' },
                            diagnostics = {},
                        },
                        apply = true,
                    })
                    -- usually enough to fix all and then save
                    vim.wait(150)
                end,
            })
        end
    end,
})

vim.lsp.config('denols', {
    root_markers = { 'deno.json' },
    workspace_required = true,
    settings = {
        {
            deno = {
                enable = true,
                disablePaths = {},
                enablePaths = nil,
                cache = nil,
                cacheOnSave = true,
                certificateStores = nil,
                config = nil,
                importMap = nil,
                codeLens = {
                    implementations = false,
                    references = false,
                    referencesAllFunctions = false,
                    test = false,
                },
                internalDebug = false,
                internalInspect = false,
                logFile = false,
                lint = true,
                documentPreloadLimit = 1000,
                suggest = {
                    imports = {
                        autoDiscover = true,
                        hosts = {
                            ['https://deno.land'] = true,
                        },
                    },
                },
                testing = {
                    args = {
                        '--allow-all',
                        '--no-check',
                    },
                },
                tlsCertificate = nil,
                unsafelyIgnoreCertificateErrors = nil,
                unstable = true,
            },
        },
    },
})

vim.lsp.config('biome', {
    settings = {
        biome = {
            requireConfigFile = true,
        },
    },
})

vim.lsp.config('oxlint', {
    cmd = {
        '/Users/efra/dev/sin-boleto-next/node_modules/oxlint/bin/oxc_language_server',
    },
    -- cmd = './node_modules/oxlint/bin/oxc_language_server',
    -- cmd = 'npx oxc_language_server',
    -- root_dir = function(bufnr, on_dir)
    --   local fname = vim.api.nvim_buf_get_name(bufnr)
    --   on_dir(vim.fs.dirname(vim.fs.find({ '.oxlintrc.json' }, { path = fname, upward = true })[1]))
    -- end,
    -- single_file_support = false
})

vim.lsp.enable 'oxlint'

vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            format = {
                enable = false,
                defaultConfig = {
                    quote_style = 'single',
                    indent_style = 'space',
                    indent_size = '2',
                    max_line_length = '80',
                    break_table_list = 'smart',
                },
            },
        },
    },
})

vim.lsp.config('pyright', {
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'openFilesOnly',
                useLibraryCodeForTypes = true,
            },
        },
    },
})

-- Setup mason so it can manage external tooling
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'html',
        'vtsls',
        'eslint',
        'jsonls',
        'biome',
        'lua_ls',
        'cssls',
        'pyright',
        'gopls',
        'golangci_lint_ls',
        'denols',
        'stylua',
        'tailwindcss',
    },
    automatic_enable = true,
})

vim.lsp.enable 'tsgolsp'
vim.lsp.enable 'biome'

local luasnip = require 'luasnip'
vim.keymap.set({ 'i' }, '<C-E>', function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end, { silent = true })

-- Turn on lsp status information
require('fidget').setup({})

local function quickFix()
    local is_first = true
    -- Filter actions by _typescipr/workspace_edit or eslint.applySuggestion to mimic coc code action
    -- generaly the first option is the common fix, so for quickfix we filter just the first one
    -- and apply it
    vim.lsp.buf.code_action({
        async = false,
        filter = function(action)
            if string.find(action.kind, 'suppressRule') then
                return false
            end
            if is_first then
                is_first = false
                return true
            end

            return false
        end,
        apply = true,
        context = { only = { 'quickfix' } },
    })
end

-- Additional kepmaps

vim.keymap.set(
    'n',
    '[d',
    '<cmd>lua vim.diagnostic.jump({count= -1, float= true})<CR>'
)
vim.keymap.set(
    'n',
    ']d',
    '<cmd>lua vim.diagnostic.jump({count= 1, float= true})<CR>'
)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>qf', quickFix)
vim.keymap.set('x', '<leader>qf', quickFix)

-- LSP commands
vim.api.nvim_create_user_command(
    'RemoveUnusedImports',
    ':VtsExec remove_unused_imports',
    {}
)
vim.api.nvim_create_user_command(
    'RemoveUnusedCode',
    ':VtsExec remove_unused',
    {}
)
vim.api.nvim_create_user_command(
    'AddMissingImports',
    ':VtsExec add_missing_imports',
    {}
)
vim.api.nvim_create_user_command('FixAll', ':VtsExec fix_all', {})

-- TODO: UI SETTINGS, MOVE TO OWN FILE
local function get_prompt_text(prompt, default_prompt)
    local prompt_text = prompt or default_prompt
    if prompt_text:sub(-1) == ':' then
        prompt_text = '[' .. prompt_text:sub(1, -2) .. ']'
    end
    return prompt_text
end

local Menu = require 'nui.menu'
local event = require('nui.utils.autocmd').event

local function override_ui_select()
    local UISelect = Menu:extend 'UISelect'

    function UISelect:init(items, opts, on_done)
        local border_top_text = get_prompt_text(opts.prompt, '[Select Item]')
        local kind = opts.kind or 'unknown'
        local format_item = opts.format_item
            or function(item)
                return tostring(item.__raw_item or item)
            end

        local popup_options = {
            relative = 'editor',
            position = '50%',
            border = {
                style = 'rounded',
                text = {
                    top = border_top_text,
                    top_align = 'left',
                },
            },
            win_options = {
                winhighlight = 'Normal:Normal,FloatBorder:Normal',
            },
            zindex = 999,
        }

        if kind == 'codeaction' then
            -- change position for codeaction selection
            popup_options.relative = 'cursor'
            popup_options.position = {
                row = 1,
                col = 0,
            }
        end

        local max_width = popup_options.relative == 'editor'
                and vim.o.columns - 4
            or vim.api.nvim_win_get_width(0) - 4
        local max_height = popup_options.relative == 'editor'
                and math.floor(vim.o.lines * 80 / 100)
            or vim.api.nvim_win_get_height(0)

        local menu_items = {}
        for index, item in ipairs(items) do
            if type(item) ~= 'table' then
                item = { __raw_item = item }
            end
            item.index = index
            local item_text = tostring(index)
                .. ': '
                .. string.sub(format_item(item), 0, max_width)
            menu_items[index] = Menu.item(item_text, item)
        end

        local menu_options = {
            min_width = vim.api.nvim_strwidth(border_top_text),
            max_width = max_width,
            max_height = max_height,
            lines = menu_items,
            keymap = {
                focus_next = { 'j', '<Down>', '<C-N>' },
                focus_prev = { 'k', '<Up>', '<C-P>' },
                close = { '<Esc>', '<C-c>' },
                submit = { '<CR>', '<Space>' },
            },
            on_close = function()
                on_done(nil, nil)
            end,
            on_submit = function(item)
                on_done(item.__raw_item or item, item.index)
            end,
        }

        UISelect.super.init(self, popup_options, menu_options)

        -- cancel operation if cursor leaves select
        self:on(event.BufLeave, function()
            on_done(nil, nil)
        end, { once = true })

        for index, item in ipairs(items) do
            self:map('n', tostring(item.index), function()
                on_done(item.__raw_item or item, item.index)
            end)
        end
    end

    local select_ui = nil

    vim.ui.select = function(items, opts, on_choice)
        assert(type(on_choice) == 'function', 'missing on_choice function')

        if select_ui then
            -- ensure single ui.select operation
            vim.api.nvim_err_writeln 'busy: another select is pending!'
            return
        end

        select_ui = UISelect(items, opts, function(item, index)
            if select_ui then
                -- if it's still mounted, unmount it
                select_ui:unmount()
            end
            -- pass the select value
            on_choice(item, index)
            -- indicate the operation is done
            select_ui = nil
        end)

        select_ui:mount()
    end
end

override_ui_select()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
