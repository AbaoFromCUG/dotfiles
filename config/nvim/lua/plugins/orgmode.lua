return function()
    local orgmode = require "orgmode"
    orgmode.setup {

        org_agenda_files = { "~/Documents/org/*", "~/Documents/**/*" },
        org_default_notes_file = "~/Documents/org/refile.org",
    }
end
