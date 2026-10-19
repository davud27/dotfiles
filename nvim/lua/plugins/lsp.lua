return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.config("clangd", {
                cmd = { "clangd", "--background-index", "--clang-tidy" },
            })
            vim.lsp.enable({ "lua_ls", "clangd", "asm_lsp", "ts_ls", "jdtls", "pyright" })

            vim.o.winborder = "rounded"
            vim.o.completeopt = "menuone,noselect,popup,fuzzy"

            local sev = vim.diagnostic.severity
            vim.diagnostic.config({
                virtual_text = { prefix = "●" },
                severity_sort = true,
                float = { source = true },
                signs = {
                    text = { [sev.ERROR] = "E", [sev.WARN] = "W", [sev.INFO] = "I", [sev.HINT] = "H" },
                },
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end
                    local buf = args.buf

                    if client:supports_method("textDocument/completion") then
                        -- Trigger completion on letters and member-access characters
                        local chars = { ".", ":", ">", "_" }
                        for c in ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"):gmatch(".") do
                            table.insert(chars, c)
                        end
                        client.server_capabilities.completionProvider.triggerCharacters = chars
                        vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
                    end
                    if client:supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint.enable(true, { bufnr = buf })
                    end

                    local map = function(keys, fn, desc)
                        vim.keymap.set("n", keys, fn, { buffer = buf, desc = desc })
                    end
                    map("gd", vim.lsp.buf.definition, "Go to definition")
                    map("<leader>e", vim.diagnostic.open_float, "Show diagnostic")
                    map("<leader>f", vim.lsp.buf.format, "Format file")
                    map("<leader>h", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }))
                    end, "Toggle inlay hints")
                end,
            })
        end,
    },
}
