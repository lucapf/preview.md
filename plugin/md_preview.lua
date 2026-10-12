-- Runs automatically at startup. Just registers a command — cheap.

vim.api.nvim_create_user_command("MdPreview", function()
	require("md_preview").run()
end, { desc = "Render a preview of the current Markdown/PlantUML file" })
