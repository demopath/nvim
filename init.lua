vim.g.mapleader = ' '

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
    init_options = {
        fallbackFlags = { "-ID:\\scoop\\apps\\tcc\\current\\tcc\\include" }
    }
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

local windows = vim.fn.has('win32')==1 or vim.fn.has('win64')==1
if false then
    -- 切换到 normal 自动转英文
    local ffi = require("ffi")
    local user32 = ffi.load("user32")
    local imm32 = ffi.load("imm32")
    ffi.cdef[[
        void* GetForegroundWindow(void);
        void* ImmGetDefaultIMEWnd(void* hwnd);
        int SendMessageW(void* hWnd, int Msg, int wParam, int lParam);
    ]]
    local ime_en = {
        group = vim.api.nvim_create_augroup("ImeAutoGroup", { clear = true }),
        callback = function (cmd, data) 
            local fhwnd = user32.GetForegroundWindow()
            local ihwnd = imm32.ImmGetDefaultIMEWnd(fhwnd) 
            user32.SendMessageW(ihwnd, 0x283, 6, 0) -- 关闭 ime
            user32.SendMessageW(ihwnd, 0x283, 2, 0) -- 切换状态
        end
    } 
    vim.api.nvim_create_autocmd("InsertLeave", ime_en)
end

vim.pack.add {
    "https://github.com/Mofiqul/vscode.nvim",
    "https://github.com/tpope/vim-sleuth",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/MunifTanjim/nui.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-mini/mini.cursorword",
    "https://github.com/sindrets/diffview.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/MagicDuck/grug-far.nvim",
    "https://github.com/lukas-reineke/indent-blankline.nvim",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/nvim-neo-tree/neo-tree.nvim",
    "https://github.com/junegunn/vim-easy-align",
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range "1.*" },
}


if not vim.g.vscode then
    local vsc = require('vscode.colors').get_colors()
    require('vscode').setup {
        transparent = not vim.g.neovide, -- 透明
        group_overrides = {
            GrugFarInputLabel       = { fg = vsc.vscMediumBlue     }, -- grug-far
            GrugFarResultsPath      = { fg = vsc.vscDarkYellow     },
            GrugFarInputPlaceholder = { fg = vsc.vscLeftLight      }, -- 提示
            CursorLine              = { bg = vsc.vscTabOther       }, -- 当前行
            MiniCursorword          = { bg = vsc.vscLeftMid        },
            DiffAdd                 = { bg = vsc.vscDiffGreenDark  }, -- git diff
            DiffDelete              = { bg = vsc.vscLeftDark       },
            DiffChange              = { bg = vsc.vscLeftDark       },
            DiffText                = { bg = vsc.vscDiffGreenLight },
            NeoTreeRootName         = { fg = vsc.vscLeftLight      },
            NeoTreeGitConflict      = { fg = vsc.vscDarkYellow     },
            NeoTreeGitUntracked     = { fg = vsc.vscDarkYellow     },
            NeoTreeCursorLine       = { bg = vsc.vscTabOther       },
            DiffviewFilePanelInsertions = { link = "NonText"  },
            DiffviewFilePanelDeletions  = { link = "NonText"  },
            DiffviewFilePanelCounter    = { link = "NonText" },
            DiffviewFilePanelPath       = { link = "NonText" },
            DiffviewNonText             = { fg = vsc.vscLeftDark },
        }
    }
    vim.cmd.colorscheme "vscode"
end

require("diffview").setup()
require('mini.cursorword').setup()

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require('lualine').setup {
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

require('blink.cmp').setup { 
    completion = {
        ghost_text = { enabled = function() return vim.g.blink_ghost end },
        menu = { auto_show = function () return vim.g.blink_menu end },
    },
    sources = {
        default = { "lsp", "buffer", "snippets", "path" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
}


require('grug-far').setup { 
    engines = {
        ripgrep = { placeholders = { enabled = false } },
        astgrep = { placeholders = { enabled = false } },
    },
    startInInsertMode = false,
    openTargetWindow = { preferredLocation = 'right' },
    enabledEngines = { 'ripgrep', 'astgrep', },
}

require('ibl').setup { 
    indent = { char = "▏" },
    scope = { enabled = false },
}

require('neo-tree').setup { 
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
vim.keymap.set('n', '<leader>gd', "<cmd>DiffviewOpen<cr>" ,       { desc = "diff"    })
vim.keymap.set('n', '<leader>gh', "<cmd>DiffviewFileHistory<cr>", { desc = "history" })

vim.keymap.set('n', 'gp', "<cmd>Gitsigns preview_hunk<cr>", { desc = '查看修改' })
vim.keymap.set('n', 'do', "<cmd>Gitsigns reset_hunk<cr>"  , { desc = '取消修改' })
vim.keymap.set('n', ']c', "<cmd>Gitsigns next_hunk<cr>"   , { desc = '下个修改' })
vim.keymap.set('n', '[c', "<cmd>Gitsigns prev_hunk<cr>"   , { desc = '上个修改' })

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

local word = require "word"
vim.keymap.set("n", "<leader>tt", word.toggle)

do return end
local define = require "define"
vim.keymap.set("n", "<c-n>", define.switch(1))
vim.keymap.set("n", "<c-p>", define.switch(-1))
vim.keymap.set("n", "<c-k>", define.switch(0))


