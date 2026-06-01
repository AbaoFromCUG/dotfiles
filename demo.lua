require("neotest-playwright").adapter({
    options = {
        enable_dynamic_test_discovery = false,

        -- Custom criteria for a file path to be a test file. Useful in large
        -- projects or projects with peculiar tests folder structure. IMPORTANT:
        -- When setting this option, make sure to be as strict as possible. For
        -- example, the pattern should not return true for jpg files that may end up
        -- in your test directory.
        is_test_file = function(file_path)
            -- By default, only returns true if a file contains one of several file
            -- extension patterns. See default implementation here: https://github.com/thenbe/neotest-playwright/blob/53c7c9ad8724a6ee7d708c1224f9ea25fa071b61/src/discover.ts#L25-L47
            local result = file_path:find("%.test%.[tj]sx?$") ~= nil or file_path:find("%.spec%.[tj]sx?$") ~= nil
            -- Alternative example: Match only files that end in `test.ts`
            local result = file_path:find("%.test%.ts$") ~= nil
            -- Alternative example: Match only files that end in `test.ts`, but only if it has ancestor directory `e2e/tests`
            local result = file_path:find("e2e/tests/.*%.test%.ts$") ~= nil
            return result
        end,

    },
})
> **Dynamic Test Discovery**
> `neotest-playwright` can make use of the playwright cli to unlock extra features. Most importantly, the playwright cli provides information about which tests belongs to which project. neotest-playwright will parse this information to display, run, and report the results of tests on a per-project basis.
> 
> To enable this, set `enable_dynamic_test_discovery` to true.
> 
> Caveats
> This feature works by calling `playwright test --list --reporter=json`. While this is a relatively fast operation, it does add some overhead. Therefore, neotest-playwright only calls this feature once (when the adapter is first initialized). From then on, neotest-playwright continues to rely on treesitter to track your tests and enhance them with the data previously resolved by the playwright cli. There are times, however, where we want to refresh this data. To remedy this: neotest-playwright exposes a command `:NeotestPlaywrightRefresh`. This comes in handy in the following scenarios:
> 
> * Adding a new test
> * Renaming a test
> * Changing the project(s) configuration in your playwright.config.ts file

As a reference, [neotest-playwright](https://github.com/thenbe/neotest-playwright?utm_source=chatgpt.com) already provides a similar configuration option:

```lua id="jtwvnl"
require("neotest-playwright").adapter({
    options = {
        enable_dynamic_test_discovery = false,

        is_test_file = function(file_path)
            return file_path:find("e2e/tests/.*%.test%.ts$") ~= nil
        end,
    },
})
```

Their approach is to perform dynamic discovery only once during initialization, and expose a manual refresh command afterwards.

However, I think using something like `singleflight` to deduplicate concurrent refresh/discovery requests might provide a better UX overall.

Compared to a one-time discovery + manual refresh command:

* users do not need to remember an extra command
* discovery can still stay lazy/on-demand
* repeated scans can be naturally throttled/deduplicated
* it feels more ergonomic, especially in large repos where test structure changes frequently

In other words, this shifts the complexity from the user to the implementation, which is usually a worthwhile tradeoff for developer tooling.
