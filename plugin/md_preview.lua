-- Runs automatically at startup. Just registers a command — cheap.

vim.api.nvim_create_user_command("Thesaurus", function()
	require("thesaurus").run()
end, { desc = "" })
