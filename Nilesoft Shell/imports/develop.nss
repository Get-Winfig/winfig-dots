// 'C:\Program Files\Nilesoft Shell\scripts'

menu(mode="multiple" title='&Develop' sep=sep.bottom image=\uE26E){

	item(title='LazyGit' image=\uE22B cmd='lazygit')

	//  Default Editors
	menu(mode="single" title='editors' image=\uE10F){
		item(title='Notepad' 			image='C:\Program Files\WindowsApps\Microsoft.WindowsNotepad_11.2508.38.0_x64__8wekyb3d8bbwe\Assets\NotepadAppList.scale-200.png' cmd='notepad.exe' args='"@sel.path"')
		item(title='Visual Studio Code' image=[\uE272, #22A7F2] cmd='code' args='"@sel.path"')
		item(title='Sublime Text' 		image='C:\Program Files\Sublime Text\sublime_text.exe' cmd='C:\Program Files\Sublime Text\subl.exe' args='"@sel.path"')
		item(title='Nvim' 				image='C:\Program Files\Neovim\bin\nvim.exe' cmd='C:\Program Files\Neovim\bin\nvim.exe' args='"@sel.path"')
		item(title='Neovide' 			image='C:\Program Files\Neovide\neovide.exe' cmd='C:\Program Files\Neovide\neovide.exe' args='"@sel.path"')
		separator
		item(type='file' mode="single" title='Windows notepad' image cmd='@sys.bin\notepad.exe' args='"@sel.path"')
	}

	// Git menu
	menu(mode="multiple" title='git' image=\uE22A){
		item(title='init'       image=\uE114  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\git.bat" init"')
		item(title='add all'    image=\uE160  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\git.bat" add ."')
		item(title='clone repo' image=\uE0BD  cmd-line='/C "C:\Program Files\Nilesoft Shell\scripts\git-clone.bat"')
		item(title='commit'     image=\uE115  cmd-line='/C "C:\Program Files\Nilesoft Shell\scripts\git.bat" commit"')
		item(title='amend' 	    image=\uE0AD  cmd-line='/C "C:\Program Files\Nilesoft Shell\scripts\git.bat" commit --amend"')
		separator
		item(title='push' 	  image=\uE09C   cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\git.bat" push" & pause')
		item(title='fetch' 	  image=\uE093   cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\git.bat" fetch" & pause')
		item(title='pull'     image=\uE09D   cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\git.bat" pull" & pause')
		separator
		item(title='status'	  image=\uE043  cmd-line='/C tig status' )
		item(title='tig' 	  image=\uE0D6  cmd-line='/C tig')
		item(title='Logs'     image=\uE0DD  cmd-line='/C tig log')
		item(title='Branches' image=\uE180  cmd-line='/C powershell -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File "C:\Program Files\Nilesoft Shell\scripts\show-branches.ps1"')
		item(title='Remotes'  image=\uE15A  cmd-line='/C powershell -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File "C:\Program Files\Nilesoft Shell\scripts\show-remotes.ps1"')
	}

	// Npm menu
	menu(mode="multiple" title='npm' image=\uE229){
		item(title='init'      image=\uE114  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\npm.bat" init"')
		item(title='install'   image=\uE0BC  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\npm.bat" install"')
		item(title='start'     image=\uE292  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\npm.bat" start"')
		item(title='build'     image=\uE0FB  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\npm.bat" run build"')
		separator
		item(title='lint'      image=\uE0CE  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\npm.bat" lint"')
		item(title='serve' 	   image=\uE0A0  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\npm.bat" serve"')
		item(title='watch' 	   image=\uE126  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\npm.bat" watch"')
		separator
		item(title='view outdated' image=\uE14C  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\npm.bat" outdated"')
		item(title='view list' 	   image=\uE15C  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\npm.bat" list"')
	}

	// Uv menu
	menu(mode="multiple" title='Uv' image=\uE230){
		item(title='init'  image=\uE114  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\uv.bat" init"')
		item(title='sync'  image=\uE1E8  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\uv.bat" sync"')
		item(title='lock'  image=\uE10B  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\uv.bat" lock"')
		item(title='venv'  image=\uE0FA  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\uv.bat" venv"')
		item(title='build' image=\uE0FB  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\uv.bat" build"')
	}

	// Hugo menu
	menu(mode="multiple" title='Hugo' image=\uE225){
		item(title='new site' image=\uE120  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\hugo.bat" new site my-site"')
		item(title='new post' image=\uE16D  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\hugo.bat" new post \"My New Post.md\""')
		item(title='server'   image=\uE0A0  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\hugo.bat" server"')
		item(title='build'   image=\uE0FB   cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\hugo.bat" build"')
	}

	// NVM menu
    menu(mode="multiple" title='nvm' image=\uE229){
		item(title='list' image=\uE15C  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\nvm.bat" list"')
		item(title='on'   image=\uE13C  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\nvm.bat" on"')
		item(title='off'  image=\uE139  cmd-line='/C ""C:\Program Files\Nilesoft Shell\scripts\nvm.bat" off"')
	}

	item(title='Universal Run File'  image=\uE148  cmd-line='/C "C:\Program Files\Nilesoft Shell\scripts\run.bat"')
}
