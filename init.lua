vim.g.mapleader = ' '

-- set nu rnu cul
vim.opt.nu  = true
vim.opt.rnu = true
vim.opt.cul = true

-- set ts=4 sw=4 sts=4 et
vim.opt.tabstop     = 4    -- tab 显示宽度
vim.opt.shiftwidth  = 4    -- >>  缩进宽度
vim.opt.softtabstop = 4    -- 插入模式 tab 宽度
vim.opt.expandtab   = true -- tab 转空格
vim.opt.shiftround  = true -- tab 整数倍
vim.opt.scrolloff   = 4    -- 屏幕上下边距
vim.opt.ignorecase  = true -- 忽略大小写
vim.opt.smartcase   = true -- 智能忽略
vim.opt.title       = true -- 标题
vim.opt.titlestring = "%t"
vim.opt.fillchars   = { fold = ' ', diff = ' ', eob = ' ', vert = '▏' }
vim.opt.modeline    = false

vim.opt.swapfile    = false
vim.opt.undofile    = true

vim.o.shell        = "nu"
vim.opt.shellpipe = "out+err>"
vim.o.shellquote   = ""
vim.o.shellxquote  = ""
vim.o.shellcmdflag = "-c"
vim.o.shellslash   = true

vim.opt.guifont = { "CaskaydiaMono Nerd Font Mono", "NSimSun:h11" }

vim.diagnostic.config({
    virtual_text = {
        enabled = true,
        format = function(diagnostic)
            return tostring(diagnostic.message)
        end,
    },
})

vim.lsp.config.clangd = {
    cmd = { "clangd" },
    root_markers = { ".clangd", "compile_commands.json", ".git" },
    filetypes = { "c", "cpp" },
}

vim.lsp.config.lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    settings = {
        Lua = {
            runtime = { version = "LuaJIT", },
            workspace = { library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library"
            } },
        }
    }
}

vim.lsp.enable { "clangd", "lua_ls" }
vim.o.autocomplete = true

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function()
        vim.opt.foldlevel = 99
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
        vim.cmd("set formatoptions-=ro")
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function() vim.hl.on_yank() end,
})

vim.keymap.set("n", "<leader>cc", ":sour $MYVIMRC<cr>", {desc = "应用设置"})
vim.keymap.set("n", "<leader>ci", ":edit $MYVIMRC<cr>", {desc = "打开设置"})

local lazyload = function(tab)
    if not tab or #tab < 1 then return end
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then return end
    end
    vim.opt.rtp:prepend(lazypath)
    require("lazy").setup({
        spec = tab,
        dev = { path = "D:\\git\\" },
        ui = { border = "single" },
        checker = { enabled = false }, -- 关闭自动更新
        local_spec = false,            -- 禁用自动执行
    })
end

local lazytab = {{
    "Mofiqul/vscode.nvim",
    config = function()
        local c = require('vscode.colors').get_colors()
        require('vscode').setup {
            transparent = not vim.g.neovide, -- 透明
            group_overrides = {
                GrugFarInputLabel       = { fg = c.vscMediumBlue     }, -- grug-far
                GrugFarResultsPath      = { fg = c.vscDarkYellow     },
                GrugFarInputPlaceholder = { fg = c.vscLeftLight      }, -- 提示
                CursorLine              = { bg = c.vscTabOther       }, -- 当前行
                MiniCursorword          = { bg = c.vscLeftMid        },
                DiffAdd                 = { bg = c.vscDiffGreenDark  }, -- git diff
                DiffDelete              = { bg = c.vscLeftDark       },
                DiffChange              = { bg = c.vscLeftDark       },
                DiffText                = { bg = c.vscDiffGreenLight },
                NeoTreeRootName         = { fg = c.vscLeftLight      },
                NeoTreeGitConflict      = { fg = c.vscDarkYellow     },
                NeoTreeGitUntracked     = { fg = c.vscDarkYellow     },
                NeoTreeCursorLine       = { bg = c.vscTabOther       },
                DiffviewFilePanelInsertions = { link = "NonText"  },
                DiffviewFilePanelDeletions  = { link = "NonText"  },
                DiffviewFilePanelCounter    = { link = "NonText" },
                DiffviewFilePanelPath       = { link = "NonText" },
                DiffviewNonText             = { fg = c.vscLeftDark },
            }
        }
        vim.cmd.colorscheme "vscode"
    end
}, {
    "tpope/vim-sleuth",
    event = "VeryLazy",
}, {
    "nvim-lua/plenary.nvim",
    event = "VeryLazy",
}, {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
}, {
    "MunifTanjim/nui.nvim",
    event = "VeryLazy",
}, {
    'nvim-mini/mini.cursorword',
    version = '*',
    event = "VeryLazy",
    init = function()
        vim.g.minicursorword_disable = true
    end,
    opts = {},
}, {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    opts = {
        keymaps = {
            file_panel = {
                { "n", "q", "<cmd>tabc<cr>" },
            },
            view = {
                { "n", "q", "<cmd>tabc<cr>" },
                { "n", "s", "<cmd>Gitsigns stage_hunk<cr>"}, -- 存储差异
            },
            file_history_panel = {
                { "n", "q", ":tabc<cr>" },
            },
        },
        hooks = {
            diff_buf_read = function()
                vim.opt_local.wrap = false
            end,
        },
    }
}, {
    "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
}, {
    "tpope/vim-fugitive",
    event = "VeryLazy",
},{
    'folke/which-key.nvim',
    event = "VeryLazy",
    opts = {
        preset = "helix",
        spec = {
            { "<leader>g", group = "git"    },
            { "<leader>f", group = "file"   },
            { "<leader>h", group = "search" },
            { "<leader>u", group = "ui"     },
            { "<leader>c", group = "config" },
            { "<leader>t", group = "text"   },
            { "<leader>d", group = "debug"  },
            { "<c-w>", hidden = true }
        }
    }
}, {
    "saghen/blink.cmp",
    enabled = false,
    event = "VeryLazy",
    version = "1.*",
    opts = {
        completion = {
            ghost_text = { enabled = function() return vim.g.blink_ghost end },
            menu = { auto_show = function () return vim.g.blink_menu end },
        },
        sources = {
            default = { "lsp", "buffer", "snippets", "path" },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
    }
}, {
    "MagicDuck/grug-far.nvim",
    event = "VeryLazy",
    opts = {
        keymaps = { close = { n = 'q' } },
        engines = {
            ripgrep = {
                placeholders = {
                    enabled = false,
                },
            },
            astgrep = { placeholders = { enabled = false } },
        },
        startInInsertMode = false,
        openTargetWindow = { preferredLocation = 'right' },
        enabledEngines = { 'ripgrep', 'astgrep', },
    }
},{
    -- 缩进线
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    opts = {
        indent = { char = "▏" },
        scope = { enabled = false },
    }
}, {
    "nvim-lualine/lualine.nvim",
    opts = {
        options = {
            theme = "jellybeans",
            always_show_tabline = false,
        },
        tabline = { lualine_b = {{
            'tabs',
            mode = 1,
            max_length = vim.o.columns * 2 / 3,
        }}},
        inactive_sections = {},
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'progress'},
            lualine_c = { 'branch', 'filename', 'diagnostics' },
            lualine_x = { 'encoding', 'fileformat', 'filesize', },
            lualine_y = { 'filetype' },
            lualine_z = {},
        },
        extensions = {{
            filetypes = {
                "neo-tree",
                "grug-far",
                "DiffviewFiles"
            },
            sections = { lualine_a = { 'mode' } },
            inactive_sections = {},
        }}
    }
}, {
    "nvim-neo-tree/neo-tree.nvim",
    init = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
        popup_border_style = "single",
        filesystem = {
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,      -- 同步树视图
            filtered_items = { visible = true } -- 显示隐藏文件
        },
        default_component_configs = {
            indent = {
                with_markers = false,
                with_expanders = true,
            },
            modified = { symbol = "" },
            git_status = {
                symbols = {
                    added    = "󱇬", modified = "", deleted   = "󱎘",
                    renamed  = "󰁕", ignored  = "", untracked = "?",
                    unstaged = "", staged   = "", conflict  = "󱈸",
                },
            },
        },
        window = { mappings = { ['<leader>'] = false } },
    }
}, {
    "junegunn/vim-easy-align",
    event = "VeryLazy",
    config = function()
        vim.g.easy_align_delimiters = {
            ['('] = {
                pattern        = '[()]',
                left_margin    = 0, -- 左边空格
                right_margin   = 0, -- 右边空格
                stick_to_right = 1, -- 右对齐
            },
            [')'] = {
                pattern        = ')',
                left_margin    = 0, -- 左边空格
                right_margin   = 0, -- 右边空格
                stick_to_right = 1, -- 右对齐
            },
            [','] = {
                pattern        = ',',
                left_margin    = 0,
                right_margin   = 1,
            },
            ['/'] = {
                pattern        = [[//\+\|/\*\|\*/]],
                left_margin    = 1,
                right_margin   = 1,
                ignore_groups  = {'!Comment'},
            },
        }
    end,
},
}

lazyload(lazytab)

local vimt = function(str)
    return function()
        vim.g[str] = not vim.g[str]
    end
end

vim.keymap.set('v', '<leader>a' , "<Plug>(EasyAlign)", { desc = "文本对齐" })
vim.keymap.set("n", "<leader>ff", ":Neotree toggle<cr>")

vim.keymap.set("n", "<leader>hh", function()
    require('grug-far').toggle_instance({
        instanceName="far",
        prefills = {
            search = vim.fn.expand("<cword>"),
            paths = vim.fn.expand("%")
        }
    })
end, {desc = "查找"})

vim.keymap.set('n', '<leader>uw', "<cmd>set wrap!<cr>", { desc = "自动换行" })
vim.keymap.set('n', '<leader>ul', "<cmd>IBLToggle<cr>", { desc = "缩进线" })
vim.keymap.set('n', '<leader>ug', vimt("blink_ghost"), { desc = "幽灵文本" })
vim.keymap.set('n', '<leader>ua', vimt("blink_menu"), { desc = "自动提示" })
vim.keymap.set('n', '<leader>uc', vimt("minicursorword_disable"), { desc = "高亮单词" })
vim.keymap.set('n', '<leader>uh', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "参数提示" })

vim.keymap.set('n', '<leader>gd', "<cmd>DiffviewOpen<cr>" ,       { desc = "diff"    })
vim.keymap.set('n', '<leader>gh', "<cmd>DiffviewFileHistory<cr>", { desc = "history" })

vim.keymap.set('n', 'gp', "<cmd>Gitsigns preview_hunk<cr>", { desc = '查看修改' })
vim.keymap.set('n', 'do', "<cmd>Gitsigns reset_hunk<cr>"  , { desc = '取消修改' })
vim.keymap.set('n', ']c', "<cmd>Gitsigns next_hunk<cr>"   , { desc = '下个修改' })
vim.keymap.set('n', '[c', "<cmd>Gitsigns prev_hunk<cr>"   , { desc = '上个修改' })

vim.keymap.set('n', '<leader>ts', function()
    vim.fn.setreg('+', 'openocd -f interface/stlink.cfg -f target/stm32f1x.cfg')
end, { desc = 'stm32f1x' })

local dbgtab = {
    eabi = {
        makeprg = "cmake --build --preset=Debug",
        command = {
            "arm-none-eabi-gdb",
            "-ex", "target remote localhost:3333",
            "-ex", "monitor reset halt",
            "-ex", "load",
            "-ex", "monitor reset halt",
            "-ex", "b main",
            "-ex", "c",
        }
    },
    gcc = {
        makeprg = 'gcc -g "%"',
        command = { "gdb" }
    }
}

vim.api.nvim_create_user_command('Debug', function(opts)
    local opt = dbgtab[opts.args]
    if opt then
        vim.opt.makeprg = opt.makeprg
        vim.g.termdebug_config = {
            command = opt.command
        }
    end
end, { nargs = 1 })

vim.cmd("Debug eabi")
vim.keymap.set("n", "<leader>dd", function()
    local path = "./build/Debug/"
    for name, type in vim.fs.dir(path) do
        if type == "file" and name:match("%.elf$") then
            vim.cmd("packadd termdebug")
            vim.cmd("Termdebug " .. path .. name)
            return
        end
    end
end, { desc = "下载调试文件" })
vim.keymap.set("n", "<leader>dq", ":bd! gdb<cr>", { desc = "退出" })

local debug_maps = {
    ['s'] = { cmd = ":Step<cr>",     desc = "步进" },
    ['n'] = { cmd = ":Over<cr>",     desc = "步过" },
    ['d'] = { cmd = ":Break<cr>",    desc = "清除" },
    ['c'] = { cmd = ":Continue<cr>", desc = "继续" },
    ['t'] = { cmd = ":Until<cr>",    desc = "直到" },
    ['q'] = { cmd = ":bd! gdb<cr>",  desc = "退出" },
}

local groupt = vim.api.nvim_create_augroup('TermdebugKey', { clear = true })
vim.api.nvim_create_autocmd('User', {
    pattern = 'TermdebugStartPost',
    group = groupt,
    callback = function()
        for key, map_info in pairs(debug_maps) do
            vim.keymap.set('n', key, map_info.cmd, {
                desc = map_info.desc,
                nowait = true,
            })
        end
        vim.api.nvim_create_autocmd('User', {
            pattern = "TermdebugStopPost",
            group = groupt,
            once = true,
            callback = function()
                for key in pairs(debug_maps) do
                    pcall(vim.keymap.del, 'n', key)
                end
            end
        })
    end
})

local cdgit = function()
    local target_dir
    local git_path = vim.fn.finddir(".git", ".;")
    if type(git_path)=="string" and #git_path>0 then
        target_dir = vim.fn.fnamemodify(git_path, ":p:h:h")
        vim.api.nvim_set_current_dir(target_dir)
    else
        target_dir = vim.fn.expand("%:p:h")
    end
    if target_dir and #target_dir>0 then
        vim.fn.setreg('+', 'cd "'..target_dir..'"')
        print(target_dir)
    end
end

vim.keymap.set("n", "<leader>fc", cdgit, { desc = "进入目录" })

local define = require "define"
vim.keymap.set("n", "<c-n>", define.switch(1))
vim.keymap.set("n", "<c-p>", define.switch(-1))
vim.keymap.set("n", "<c-k>", define.switch(0))

local word = require "word"
vim.keymap.set("n", "<leader>tt", word.toggle)

