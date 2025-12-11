
local group = {{
    { "GPIO_SPEED_FREQ_LOW"   , "低速", },
    { "GPIO_SPEED_FREQ_MEDIUM", "中速", },
    { "GPIO_SPEED_FREQ_HIGH"  , "高速", },
}, {
    { "GPIO_NOPULL"  , "浮空", },
    { "GPIO_PULLUP"  , "上拉", },
    { "GPIO_PULLDOWN", "下拉", },
}, {
    "GPIO_PIN_0"  ,
    "GPIO_PIN_1"  ,
    "GPIO_PIN_2"  ,
    "GPIO_PIN_3"  ,
    "GPIO_PIN_4"  ,
    "GPIO_PIN_5"  ,
    "GPIO_PIN_6"  ,
    "GPIO_PIN_7"  ,
    "GPIO_PIN_8"  ,
    "GPIO_PIN_9"  ,
    "GPIO_PIN_10" ,
    "GPIO_PIN_11" ,
    "GPIO_PIN_12" ,
    "GPIO_PIN_13" ,
    "GPIO_PIN_14" ,
    "GPIO_PIN_15" ,
    "GPIO_PIN_ALL",
}, {
    "GPIOA",
    "GPIOB",
    "GPIOC",
    "GPIOD",
    "GPIOE",
}, {
    "GPIO_PIN_SET"  ,
    "GPIO_PIN_RESET",
}, {
    { "GPIO_MODE_INPUT"             , "输入模式"   },
    { "GPIO_MODE_AF_INPUT"          , "复用输入"   },
    { "GPIO_MODE_ANALOG"            , "模拟模式"   },

    { "GPIO_MODE_OUTPUT_PP"         , "推挽输出"   },
    { "GPIO_MODE_OUTPUT_OD"         , "开漏输出"   },
    { "GPIO_MODE_AF_PP"             , "复用推挽"   },
    { "GPIO_MODE_AF_OD"             , "复用开漏"   },

    { "GPIO_MODE_IT_RISING"         , "上升中断"   },
    { "GPIO_MODE_IT_FALLING"        , "下降中断"   },
    { "GPIO_MODE_IT_RISING_FALLING" , "双边沿中断" },
    { "GPIO_MODE_EVT_RISING"        , "上升沿"     },
    { "GPIO_MODE_EVT_FALLING"       , "下降沿"     },
    { "GPIO_MODE_EVT_RISING_FALLING", "双边沿"     },
}
}

local cache = {}

local enum_hint = vim.api.nvim_create_namespace("enum_hint")
local enum_last = ""

---@diagnostic disable-next-line: unused-function, unused-local
local function hint(str)
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    vim.api.nvim_buf_clear_namespace(0, enum_hint, 0, -1)
    str = enum_last==str and "" or str
    enum_last = str
    vim.api.nvim_buf_set_extmark(0, enum_hint, row, -1, {
        virt_text = {{ str or "", "NonText" }},
        virt_text_pos = "eol",
    })
end

local function getitem(item)
    if type(item) == "table" then
        return unpack(item)
    else
        return item
    end
end

local function init(tab, tab_cache)
    for _, values in pairs(tab) do
        for i, item in ipairs(values) do
            local cul = getitem(item)
            tab_cache[cul] = {values, i}
        end
    end
end

local function tabnext(tab, i, index)
    local pos = i + index
    if pos > #tab then pos = 1 end
    if pos < 1 then pos = #tab end
    return getitem(tab[pos])
end

local function switch(tab_cache, index)
    local word = vim.fn.expand('<cword>')
    local item = tab_cache[word]
    if not item then return end
    local text, desc = tabnext(item[1], item[2], index)
    vim.cmd("normal! ciw" .. text)
    vim.cmd("normal! b")
    if desc then print(desc) end
end

return {
    switch = function(index)
        init(group, cache)
        return function()
            switch(cache, index)
        end
    end
}

