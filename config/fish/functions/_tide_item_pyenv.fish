function _tide_item_pyenv
    test -n "$PYENV_VERSION" ||
        test -n "$PYENV_ROOT" ||
        test -f .python-version ||
        test -f requirements.txt ||
        test -f pyproject.toml ||
        test (count *.py) -gt 0 &&
        _tide_print_item pyenv $tide_pyenv_icon' ' (pyenv version-name 2>/dev/null)
end
