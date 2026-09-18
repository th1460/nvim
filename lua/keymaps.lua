vim.g.mapleader = " "

vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>", { desc = "Restart configuration" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

vim.keymap.set("n", "<leader>vs", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>hs", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>hw", ":resize +4<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<leader>hn", ":resize -4<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<leader>n", ":vertical resize -4<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<leader>w", ":vertical resize +4<CR>", { desc = "Increase window width" })

vim.keymap.set("n", "J", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "K", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("v", "'", "c'<ESC>pa'", { desc = "Insert single quote" })
vim.keymap.set("v", '"', 'c"<ESC>pa"', { desc = "Insert double quote" })
vim.keymap.set("v", "(", "c(<ESC>pa)", { desc = "Insert parentheses" })
vim.keymap.set("v", '[', 'c[<ESC>pa]', { desc = "Insert brackets" })
vim.keymap.set("v", '{', 'c{<ESC>pa}', { desc = "Insert braces" })
vim.keymap.set('i', '(', '()<Left>', { desc = "Close parentheses", expr = false })
vim.keymap.set('i', '[', '[]<Left>', { desc = "Close brackets", expr = false })
vim.keymap.set('i', '{', '{}<Left>', { desc = "Close braces", expr = false })

vim.keymap.set('n', '<leader>do', vim.lsp.buf.hover, { desc = 'LSP Hover Documentation' })
vim.keymap.set("n", "<leader>di", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set("n", "<leader>dt", vim.diagnostic.setqflist, { desc = "Show table diagnostics" })

vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format Code" })

vim.keymap.set("n", "<leader>vt", ":vertical terminal<CR>", { desc = "Open terminal vertically" })
vim.keymap.set("n", "<leader>ht", ":horizontal terminal<CR>", { desc = "Open terminal horizontally" })
vim.keymap.set('t', '<C-x>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })

vim.keymap.set("n", "<leader>vo", ":vsplit term://opencode<CR>", { desc = "Start OpenCode" })
vim.keymap.set("n", "<leader>ho", ":split term://opencode<CR>", { desc = "Start OpenCode vertically" })

vim.keymap.set("n", "<leader>vb", ":vsplit term://bob<CR>", { desc = "Start Bob" })
vim.keymap.set("n", "<leader>hb", ":split term://bob<CR>", { desc = "Start Bob horizontally" })

vim.keymap.set("n", "<leader>u", function()
    vim.cmd.packadd("nvim.undotree")
    require("undotree").open()
end, { desc = "Toggle Builtin Undotree" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up and center" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

vim.keymap.set("n", "<leader>py", ":vsplit | terminal python3<CR>", { desc = "Open Python" })
vim.keymap.set("n", "<leader>rp", ":vsplit | terminal python3 %<CR>", { desc = "Run Python" })

vim.keymap.set("n", "<leader>mh", "<C-W>H", { desc = "Move window to left" })
vim.keymap.set("n", "<leader>ml", "<C-W>L", { desc = "Move window to right" })
vim.keymap.set("n", "<leader>mk", "<C-W>K", { desc = "Move window to top" })
vim.keymap.set("n", "<leader>mj", "<C-W>J", { desc = "Move window to bottom" })

vim.keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files() end,
    { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fk', function() require('telescope.builtin').keymaps() end,
    { desc = 'Telescope find keymaps' })
vim.keymap.set("n", "z=", function() require('telescope.builtin').spell_suggest {} end,
    { desc = 'Spelling Suggestions' })
vim.keymap.set('n', '<leader>fb', function() require('telescope.builtin').buffers() end,
    { desc = 'Telescope find buffers' })


vim.keymap.set('v', '<leader>s', function()
    local mode = vim.api.nvim_get_mode().mode
    local selection = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = mode })

    local term_bufs = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "terminal" then
            local name = vim.api.nvim_buf_get_name(buf)
            table.insert(term_bufs, { buf = buf, label = string.format("[%d] %s", buf, name) })
        end
    end

    if #term_bufs == 0 then
        vim.notify("No terminal buffers found", vim.log.levels.WARN)
        return
    end

    local menu = { "Choose terminal:" }
    for i, t in ipairs(term_bufs) do
        table.insert(menu, string.format("%d. %s", i, t.label))
    end

    local choice = vim.fn.inputlist(menu)
    if choice < 1 or choice > #term_bufs then return end

    local target_buf = term_bufs[choice].buf
    local terminal_chan_id = vim.bo[target_buf].channel
    if terminal_chan_id and terminal_chan_id > 0 then
        vim.fn.chansend(terminal_chan_id, table.concat(selection, "\n") .. "\n")
    else
        vim.notify("No active channel found for buffer " .. target_buf, vim.log.levels.WARN)
    end
end, { desc = "Send current selection to a specific terminal buffer" })

vim.keymap.set('n', '<leader>qp', function() require("quarto").quartoPreview() end, { silent = true, noremap = true })

vim.keymap.set("n", "<leader>e", ":Lexplore<CR>", { silent = true })

vim.keymap.set('n', '<leader>q', '<cmd>q<cr>', { desc = 'Quit window' })
vim.keymap.set('n', '<leader>qa', '<cmd>qa<cr>', { desc = 'Quit Neovim' })
vim.keymap.set('n', '<leader>qw', '<cmd>wqa<cr>', { desc = 'Save and Quit Neovim' })

vim.keymap.set('n', '<leader>o', ':only<CR>', { silent = true, desc = 'Close all other windows' })


local function current_buffer_to_floating_win()
    local buf = vim.api.nvim_get_current_buf()
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
    local opts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = "rounded" -- Keeps visible borders
    }
    vim.api.nvim_open_win(buf, true, opts)
end

vim.keymap.set('n', '<leader>z', current_buffer_to_floating_win, { desc = "Move current buffer to floating window" })

local function open_floating_terminal()
    local width = math.floor(vim.o.columns * 0.7)
    local height = math.floor(vim.o.lines * 0.6)

    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local buf = vim.api.nvim_create_buf(false, true)

    local opts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = " \u{f120}  Terminal ",
        title_pos = "center"
    }
    vim.api.nvim_open_win(buf, true, opts)
    vim.fn.termopen(vim.o.shell)
    vim.cmd("startinsert")
end

vim.keymap.set('n', '<leader>t', open_floating_terminal, { desc = "Open floating terminal" })


local function open_bob_inline()
    local width = 50
    local height = 1
    local buf = vim.api.nvim_create_buf(false, true)

    local opts = {
        relative = "cursor",
        row = 1,
        col = 0,
        width = width,
        height = height,
        style = "minimal",
        border = "rounded",
        title = " \u{ee0d}  Bob Inline ",
        title_pos = "center"
    }

    local win = vim.api.nvim_open_win(buf, true, opts)

    vim.api.nvim_set_option_value("wrap", true, { win = win })
    vim.api.nvim_set_option_value("linebreak", true, { win = win })

    local function send_and_close()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local text = table.concat(lines, "\n")

        if text ~= "" then
            local output = vim.fn.system("bob run --format json", text)
            local tbl_out = vim.json.decode(output)
            print(tbl_out["last_message"])
        end

        vim.api.nvim_win_close(win, true)
    end

    vim.cmd("startinsert")

    vim.keymap.set("n", "<CR>", send_and_close, { buffer = buf, silent = true })
    vim.keymap.set("n", "<Esc>", ":close<CR>", { buffer = buf, silent = true })
end

vim.api.nvim_create_user_command("BobInline", open_bob_inline, {})
vim.keymap.set("n", "<leader>bi", open_bob_inline, { desc = "Open Bob Inline" })
