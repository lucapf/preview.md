local M = {}

M.config = {
	key = "<leader>pp",
	script = vim.api.nvim_get_runtime_file("scripts/run.sh", false)[1],
}

-- The main action: run the bash script against the current file.
function M.run()
	local file = vim.api.nvim_buf_get_name(0) -- full path of current buffer
	if file == "" then
		vim.notify("Render: this buffer isn't a saved file", vim.log.levels.WARN)
		return
	end
	local is_md = string.match(file, ".*.[md,puml]")
	if is_md then
		vim.cmd("write")
		vim.notify(file .. " is a Markdown", vim.log.levels.DEBUG)
		local result = vim.system({ M.config.script, file }, { text = true }):wait()
		if result.code ~= 0 then
			local output = (result.stdout or "") .. (result.stderr or "")
			vim.notify("error while creating the preview \n" .. output, vim.log.levels.ERROR)
		end
	else
		vim.notify(file .. " is NOT a Markdown", vim.log.levels.DEBUG)
	end

	--	local result = vim.system({ M.config.script, selected_word }, { text = true }):wait()

	--	local output = (result.stdout or "") .. (result.stderr or "")
	--	show_output(vim.split(output, "\n", { trimempty = true }))
end

-- setup() is the conventional entry point users call from their config.
function M.setup(opts)
	M.config = vim.tbl_extend("force", M.config, opts or {})

	vim.keymap.set("n", M.config.key, M.run, { desc = "<leader> pp - MD Preview" })
end

return M
