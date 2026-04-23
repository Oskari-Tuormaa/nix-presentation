local nmap = require("config.utils").nmap

nmap("<leader>e", function ()
    vim.fn.jobstart({"just", "present-win"}, {detach=true})
end)
