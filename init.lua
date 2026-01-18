vim.g.mapleader = ' '
vim.g.maplocalleader = "\\"

vim.opt.nu  = true
vim.opt.rnu = true
vim.opt.cul = true

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
vim.opt.wrap        = false
vim.opt.clipboard = "unnamedplus"

vim.opt.swapfile = false
vim.opt.undofile = true

vim.o.shellquote   = ""
vim.o.shellxquote  = ""
vim.o.shellcmdflag = "-c"
vim.o.shellslash   = true
vim.o.shell = "bash"
-- vim.o.shell = "nu"
-- vim.opt.shellpipe = "out+err>"

local function lazyload(tab)
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                { out, "WarningMsg" },
                { "\nPress any key to exit..." },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
    end
    vim.opt.rtp:prepend(lazypath)
    require("lazy").setup({
        spec = tab,
        ui = { border = "single" },
        install = { colorscheme = { "vscode" } },
        checker = { enabled = false }, -- 关闭自动更新
        local_spec = false,            -- 禁用自动执行
    })
end

local lazytab = { {
    "tpope/vim-sleuth",
    event = "VeryLazy",
}, {
    "nvim-lua/plenary.nvim",
    event = "VeryLazy",
}, {
    "MunifTanjim/nui.nvim",
    event = "VeryLazy",
}, {
    "tpope/vim-fugitive",
    event = "VeryLazy",
},{
    "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
}, {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    keys = {
        { 'gp', "<cmd>Gitsigns preview_hunk<cr>", desc = '查看修改' }, 
        { 'do', "<cmd>Gitsigns reset_hunk<cr>"  , desc = '取消修改' }, 
        { ']c', "<cmd>Gitsigns next_hunk<cr>"   , desc = '下个修改' }, 
        { '[c', "<cmd>Gitsigns prev_hunk<cr>"   , desc = '上个修改' }, 
    },
}, {
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
    keys = {
        { '<leader>gd', "<cmd>DiffviewOpen<cr>" ,       desc = "diff"    },
        { '<leader>gh', "<cmd>DiffviewFileHistory<cr>", desc = "history" },
    },
    opts = {
        keymaps = {
            view = {
                { "n", "s", "<cmd>Gitsigns stage_hunk<cr>"}, -- 存储差异
            },
        },
        hooks = {
            diff_buf_read = function()
                vim.opt_local.wrap = false
            end,
        },
    }
}, {
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
        engines = {
            ripgrep = { placeholders = { enabled = false } },
            astgrep = { placeholders = { enabled = false } },
        },
        startInInsertMode = false,
        openTargetWindow = { preferredLocation = 'right' },
        enabledEngines = { 'ripgrep', 'astgrep', },
    },
    keys = {
        {
            "<leader>hh", function()
                require('grug-far').toggle_instance({
                    instanceName="far",
                    prefills = {
                        search = vim.fn.expand("<cword>"),
                        paths = vim.fn.expand("%")
                    }
                })
            end, desc = "查找"
        },
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
        vim.api.nvim_create_user_command("Le", "Neotree toggle", {})
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
    keys = {
        { mode = { 'v' }, '<leader>a', "<Plug>(EasyAlign)", desc = "文本对齐" }
    }
},
}

lazyload(lazytab)

vim.diagnostic.config({
    virtual_text = {
        enabled = true,
        format = function(diagnostic)
            return tostring(diagnostic.message)
        end,
    },
})

vim.lsp.config.clangd = {
    cmd = { "clangd", },
    root_markers = { ".clangd", "compile_commands.json", ".git" },
    filetypes = { "c", "cpp" },
}

vim.lsp.enable { "clangd" }

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function()
        vim.opt.foldlevel = 99
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function() vim.hl.on_yank() end,
})

vim.keymap.set("n", "<leader>cc", ":sour $MYVIMRC<cr>", { desc = "应用设置" })
vim.keymap.set("n", "<leader>ci", ":edit $MYVIMRC<cr>", { desc = "打开设置" })
vim.keymap.set('n', '<leader>uw', "<cmd>set wrap!<cr>", { desc = "自动换行" })


vim.keymap.set('i', '<c-x>', function()
    vim.g.blink_menu = not vim.g.blink_menu
end, { desc = "自动提示" })

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
    },
    tcc = {
        makeprg = 'tcc -run "%"',
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

