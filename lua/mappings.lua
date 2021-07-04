-----------------------------------------------------------------------------//
--[[ NOTE: 
In telescope use <C-q> to send all results to quickfix and <M-q> or 
<A-q> to send selected items

 You can use a regex pattern as part of a range in command mode, E.g.
 :3,/stop/s/hello/world/g ]]
-----------------------------------------------------------------------------//

vim.g.mapleader = " "

-----------------------------------------------------------------------------//
-- Basics
-----------------------------------------------------------------------------//
as.map("n", "Y", "y$")
as.map("n", "Q", "<Nop>")
as.map("i", "jk", "<ESC>")
as.map("n", "<BS>", "<C-^>")
as.map("t", "<C-o>", [[<C-\><C-n>]])
-- toggles between first column and the first character
as.map("n", "0", "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", { expr = true })
-- Move selected line / block of text in visual mode
as.map("x", "K", ":move '<-2<CR>gv=gv")
as.map("x", "J", ":move '>+1<CR>gv=gv")
-- Remap for dealing with word wrap in Normal mode
as.map("n", "k", 'v:count == 0 ? "gk" : "k"', { expr = true })
as.map("n", "j", 'v:count == 0 ? "gj" : "j"', { expr = true })
-- same for visual mode
as.map("x", "k", '(v:count == 0 && mode() !=# "V") ? "gk" : "k"', { expr = true })
as.map("x", "j", '(v:count == 0 && mode() !=# "V") ? "gj" : "j"', { expr = true })
-- Automatically jump to the end of pasted text
as.map("v", "y", "y`]")
as.map("v", "p", "p`]")
as.map("n", "p", "p`]")
-- Select last pasted text
as.map("n", "gp", "'`[' . strpart(getregtype(), 0, 1) . '`]'", { expr = true })

-----------------------------------------------------------------------------//
-- Windows
-----------------------------------------------------------------------------//
as.map("n", "<C-h>", "<C-w>h")
as.map("n", "<C-j>", "<C-w>j")
as.map("n", "<C-k>", "<C-w>k")
as.map("n", "<C-l>", "<C-w>l")
as.map("n", "<S-k>", ":resize -2<CR>")
as.map("n", "<S-j>", ":resize +2<CR>")
as.map("n", "<S-h>", ":vertical resize -2<CR>")
as.map("n", "<S-l>", ":vertical resize +2<CR>")

-----------------------------------------------------------------------------//
-- File manager, undotree
-----------------------------------------------------------------------------//
as.map("n", "<leader>e", ":NvimTreeToggle<CR>")
as.map("n", "<leader>u", ":UndotreeToggle<CR>")

-----------------------------------------------------------------------------//
-- help
-----------------------------------------------------------------------------//
as.map("n", "<leader>hv", ":Telescope help_tags<CR>")
as.map("n", "<leader>hm", ":Telescope man_pages<CR>")
as.map("n", "<leader>ht", ":Telescope colorscheme<CR>")
as.map("n", "<leader>hpi", ":PackerInstall<CR>")
as.map("n", "<leader>hpu", ":PackerUpdate<CR>")
as.map("n", "<leader>hps", ":PackerStatus<CR>")
as.map("n", "<leader>hpS", ":PackerSync<CR>")
as.map("n", "<leader>hpc", ":PackerCompile<CR>")
as.map("n", "<leader>hpC", ":PackerClean<CR>")
as.map("n", "<leader>hph", ":help packer.txt<CR>")

-----------------------------------------------------------------------------//
-- buffers
-----------------------------------------------------------------------------//
as.map("n", "<TAB>", ":bnext<CR>") -- buffer next
as.map("n", "<S-TAB>", ":bprevious<CR>") -- buffer previous
as.map("n", "<leader>bb", ":Telescope buffers theme=get_dropdown<CR>") -- all buffers
as.map("n", "<leader>bs", ":update<CR>") -- save buffer
as.map("n", "<leader>bS", ":silent! wa<CR>") -- save all buffers
as.map("n", "<leader>bq", ":update | bdelete<CR>") -- quit buffer
as.map("n", "<leader>bQ", [[<cmd>w <bar> %bd <bar> e#<CR>]]) -- quit all buffers but current
as.map("n", "<leader>b%", ":luafile %<CR>", { silent = false }) -- source buffer
as.map("n", "<leader>bh", ":noh<CR>") -- No highlight
as.map("n", "<leader>b]", ":bn<CR>") -- buffer next
as.map("n", "<leader>b[", ":bp<CR>") -- buffer previous
as.map("n", "<leader>bn", [[:enew<CR>]], { silent = false }) -- new buffer
as.map("n", "<leader>bf", [[:e <C-R>=expand("%:p:h") . "/" <CR>]], { silent = false }) -- new file
as.map("n", "<leader>bv", [[:vsp <C-R>=expand("%:p:h") . "/" <CR>]], { silent = false }) -- new split

-----------------------------------------------------------------------------//
-- tabs
-----------------------------------------------------------------------------//
as.map("n", "<leader>tq", [[:tabclose<CR>]], { silent = false }) -- tab close
as.map("n", "<leader>t[", [[:tabprevious<CR>]]) -- tab previous
as.map("n", "<leader>t]", [[:tabnext<CR>]]) -- tab previous
as.map("n", "<leader>tf", [[:tabedit <C-R>=expand("%:p:h") . "/" <CR>]], { silent = false }) -- new file
as.map("n", "<leader>tn", [[:tabnew<CR>]], { silent = false }) -- new tab

-----------------------------------------------------------------------------//
-- windows
-----------------------------------------------------------------------------//
as.map("n", "<leader>ww", "<C-w>q") -- cycle through window
as.map("n", "<leader>wq", "<C-w>q") -- quit window
as.map("n", "<leader>ws", "<C-w>s") -- split window
as.map("n", "<leader>wv", "<C-w>v") -- vertical split
as.map("n", "<leader>wh", "<C-w>h") -- jump to left window
as.map("n", "<leader>wj", "<C-w>j") -- jump to the down window
as.map("n", "<leader>wk", "<C-w>k") -- jump to the up window
as.map("n", "<leader>wl", "<C-w>l") -- jump to right window
as.map("n", "<leader>wm", "<C-w>|") -- max out to fullscreen
as.map("n", "<leader>w=", "<C-w>=") -- equally high and width
as.map("n", "<leader>wT", "<C-w>T") -- break out into a new tab
as.map("n", "<leader>wr", "<C-w>x") -- replace current with next
as.map("n", "<leader>w<", ":vertical resize -10<CR>") -- decrease width
as.map("n", "<leader>w>", ":vertical resize +10<CR>") -- increase width
as.map("n", "<leader>w-", ":resize -15<CR>") -- decrease height
as.map("n", "<leader>w+", ":resize +15<CR>") -- increase height

-----------------------------------------------------------------------------//
-- Git
-----------------------------------------------------------------------------//
as.map("n", "<leader>gg", ":Neogit<CR>") -- Git
as.map("n", "<leader>gd", ":DiffviewOpen<CR>") -- show diff
as.map("n", "<leader>gL", ":Neogit log<CR>") -- log
as.map("n", "<leader>gb", ":Telescope git_branches<CR>") -- git branches
as.map("n", "<leader>gf", ":Telescope git_files<CR>") -- git files
as.map("n", "<leader>gc", ":Telescope git_commits<CR>") -- git commits
as.map("n", "<leader>gp", ":Gitsigns preview_hunk<CR>") -- preview hunk
as.map("n", "<leader>gl", ":Gitsigns toggle_current_line_blame<CR>") -- toggle line blame
as.map("n", "<leader>gB", ":Gitsigns blame_line<CR>") -- git blame
as.map("n", "<leader>gr", ":Gitsigns reset_hunk<CR>") -- reset hunk
as.map("n", "<leader>gR", ":Gitsigns reset_buffer<CR>") -- reset buffer
as.map("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>") -- undo last stage hunk
as.map("n", "<leader>gs", ":Gitsigns stage_hunk<CR>") -- git stage hunk
as.map("n", "<leader>gS", ":Gitsigns stage_buffer<CR>") -- git stage buffer
as.map("n", "<leader>g[", ":Gitsigns prev_hunk<CR>") -- previous hunk
as.map("n", "<leader>g]", ":Gitsigns next_hunk<CR>") -- next hunk

-----------------------------------------------------------------------------//
-- Telescope
-----------------------------------------------------------------------------//
as.map("n", "<leader><space>", ":Telescope find_files<CR>")
as.map("n", "<leader>/", ":Telescope live_grep theme=get_ivy<CR>")
as.map("n", "<leader>ff", ":Telescope find_files<CR>")
as.map("n", "<leader>fr", ":Telescope oldfiles<CR>")
as.map("n", "<leader>fg", ":Telescope live_grep theme=get_ivy<CR>")
as.map("n", "<leader>fb", ":Telescope current_buffer_fuzzy_find theme=get_ivy<CR>")
as.map("n", "<leader>fC", ":Telescope command_history<CR>")
as.map("n", "<leader>fc", ":Telescope commands<CR>")
as.map("n", "<leader>fs", ":Telescope search_history<CR>")
as.map("n", "<leader>fn", ":Telescope fd cwd=$HOME/.config/nvim/<CR>")

-----------------------------------------------------------------------------//
-- Zen Mode
-----------------------------------------------------------------------------//
as.map("n", "<leader>zf", [[:lua require("utils.extra").focus()<CR>]])
as.map("n", "<leader>zc", [[:lua require("utils.extra").centered()<CR>]])
as.map("n", "<leader>zm", [[:lua require('utils.extra').minimal()<CR>]])
as.map("n", "<leader>za", [[:lua require('utils.extra').ataraxis()<CR>]])
as.map("n", "<leader>zq", ":close<CR>")

-----------------------------------------------------------------------------//
-- Session
-----------------------------------------------------------------------------//
as.map("n", "<leader>ss", ":SSave<CR>")
as.map("n", "<leader>sq", ":SClose<CR>")
as.map("n", "<leader>sd", ":SDelete<CR>")
as.map("n", "<leader>sl", ":SLoad<CR>")
as.map("n", "<leader>sr", ":lua require('utils.extra').Reload()<CR>")

-----------------------------------------------------------------------------//
-- Open/Run
-----------------------------------------------------------------------------//
as.map("n", "<leader>o,", ":Startify<CR>")
as.map("n", "<leader>ot", ":ToggleTerm<CR>")
as.map("n", "<leader>ob", ":Telescope file_browser<CR>")
as.map("n", "<leader>of", ":NvimTreeFindFile<CR>")
as.map("n", "<leader>oe", ":NvimTreetoggle<CR>")
as.map("n", "<leader>ou", ":UndotreeToggle<CR>")
as.map("n", "<leader>on", ":vsp ~/.config/nvim/lua/config.lua<CR>")
as.map("n", "<leader>oca", ":ColorizerAttachToBuffer<CR>")
as.map("n", "<leader>oct", ":ColorizerToggle<CR>")
