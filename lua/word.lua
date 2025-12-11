local word = {
    pos = nil,
    id  = nil,
    line = true,
    count = 0,
}

-- 删除高亮单词
word.del = function(t)
    pcall(vim.fn.matchdelete, t.id)
    t.pos = nil
    t.id = nil
end

-- 随机高亮单词
word.randhl = function(t)
    local words = {}
    vim.api.nvim_set_hl(0, 'RandomHighlight', { bg = 'green', fg = 'black' })
    for line = vim.fn.line('w0'), vim.fn.line('w$') do
        local text = vim.fn.getline(line)
        local col = 1
        while col <= #text do
            local s, e = string.find(text, '%w+', col)
            if not s then break end
            table.insert(words, { line, s, e-s+1 })
            col = e + 1
        end
    end
    if #words == 0 then return end
    t.pos = words[math.random(#words)]
    t.id = vim.fn.matchaddpos('RandomHighlight', {t.pos})
end

-- 判断光标是否在单词上
local word_on = function(cur, w, line)
    if not (cur and w) then return true end
    local row, col = cur[1], cur[2]+1
    if line and row==w[1] then
        return true
    end
    if row==w[1] and col>=w[2] and col<=w[2]+w[3]-1 then
        return true
    else
        print("line:"..w[1])
    end
end

word.on = function(t)
    local on = word_on(vim.api.nvim_win_get_cursor(0), t.pos, t.line)
    if on then
        if t.count==0 then
            t.start = vim.loop.hrtime()
        else
            local now = (vim.loop.hrtime() - t.start) / 1e9
            print(string.format("time:%.2f, count:%d", now/t.count, t.count))
        end
        t.count = t.count + 1
    end
    return on
end

word.toggle = function()
    if word.id then
        word:del()
        vim.keymap.del('n', '<CR>')
        print(" -- Word stop -- ")
    else
        word.count = 0
        word:del()
        word:randhl()
        vim.keymap.set('n', '<CR>', function()
            if word:on() then
                word:del()
                word:randhl()
            end
        end)
        print(" -- Word start -- ")
    end
end

return word
