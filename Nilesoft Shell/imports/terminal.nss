menu(type='*' where=(sel.count or wnd.is_taskbar or wnd.is_edit) title=title.terminal sep=sep.top image=icon.run_with_powershell) {
	$tip_run_admin=["\xE1A7 Press SHIFT key to run " + this.title + " as administrator", tip.warning, 1.0]
	$has_admin=key.shift() or key.rbutton()

	// Command Prompt entry
	item(title=title.command_prompt tip=tip_run_admin admin=has_admin image cmd-prompt=`/K TITLE Command Prompt &ver& PUSHD "@sel.dir"`)

	// Windows PowerShell entry
	item(title=title.windows_powershell admin=has_admin tip=tip_run_admin image cmd='powershell.exe' args='-noexit -command Set-Location -Path "@sel.dir\."')

	// Powershell Core
	item(title="Powershell Core" admin=has_admin tip=tip_run_admin image cmd='pwsh.exe' args='-noexit -command Set-Location -Path "@sel.dir\."')

	// Windows Terminal entry
	item(where=package.exists("WindowsTerminal") title=title.Windows_Terminal tip=tip_run_admin admin=has_admin image='@package.path("WindowsTerminal")\WindowsTerminal.exe' cmd="wt.exe" arg=`-d "@sel.path\."`)

	// Git Bash
    item(title='Git Bash' image='%USERPROFILE%\.Dotfiles\winfig-terminal\Assets\Git.ico' cmd='C:\Program Files\Git\git-bash.exe')

	// WSL
	item(title="Open Wsl" image='%USERPROFILE%\.Dotfiles\winfig-terminal\Assets\Linux.ico' cmd="wt.exe" arg='-d "@sel.path\." -- wsl')
}
