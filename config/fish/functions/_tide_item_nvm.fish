
function _tide_item_nvm

    set --function tide_nvm_icon 
    # test -q nvm ||
        test -n "$PYENV_ROOT" ||
        test -f .python-version ||
        test -f requirements.txt ||
        test -f pyproject.toml ||
        test (count *.py) -gt 0 &&
        _tide_print_item nvm $tide_nvm_icon' ' (nvm current 2>/dev/null)
end
