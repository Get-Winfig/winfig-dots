// -----------------------------------------------------------------------------
// Nilesoft Shell Main Settings
// -----------------------------------------------------------------------------
// General configuration for menu behavior, appearance, and performance.

settings{
    priority=1
    exclude.where = !process.is_explorer
    showdelay = 200
    modify.remove.duplicate=1
    tip.enabled=true
}

// -----------------------------------------------------------------------------
// Import Themes Based on System Theme
// -----------------------------------------------------------------------------
// Uncomment the desired theme import based on your system theme preference.
// import 'themes/catppuccin-mocha-blue.nss'
import 'themes/catppuccin-macchiato-blue.nss'
// import 'themes/catppuccin-latte-blue.nss'

// -----------------------------------------------------------------------------
// Custom Menus for Nilesoft Shell
// -----------------------------------------------------------------------------

menu(mode="multiple" title="Pin/Unpin" image=icon.pin){
    // Menu for pinning or unpinning items
    // Add pin/unpin actions here
}

menu(mode="multiple" title=title.more_options image=icon.more_options){
    // Menu for additional options
    // Add more actions or submenus here
}

// -----------------------------------------------------------------------------
// Import custom resources and configuration modules for Nilesoft Shell
// -----------------------------------------------------------------------------
import 'imports/themes.nss'        // Theme detection and application logic
import 'imports/images.nss'        // SVG icons and color variables for menus and UI
import 'imports/modify.nss'        // Menu and item modification rules and helpers
import 'imports/terminal.nss'      // Terminal integration and related commands
import 'imports/file-manage.nss'   // File management actions and context menus
import 'imports/develop.nss'       // Developer tools and programming utilities
import 'imports/goto.nss'          // Quick navigation and jump-to-folder actions
import 'imports/taskbar.nss'       // Taskbar-related menu items and actions
