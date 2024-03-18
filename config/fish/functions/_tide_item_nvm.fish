
function _tide_item_nvm
    test -d ~/.nvm && _tide_print_item nvm $tide_nvm_icon' ' (nvm current 2>/dev/null)
end
