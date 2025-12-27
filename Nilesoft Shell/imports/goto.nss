menu(type='*' where=window.is_taskbar||sel.count mode=mode.multiple title=title.go_to sep=sep.both image=\uE14A){

	menu(title='Folder' image=\uE1F4){
		item(title='Program Files' image=inherit cmd=sys.prog)
		item(title='Program Files x86' image=inherit cmd=sys.prog32)
		item(title='ProgramData' image=inherit cmd=sys.programdata)
		item(title='Applications' image=inherit cmd='shell:appsfolder')
		item(title='Users' image=inherit cmd=sys.users)
		separator
		item(title='@user.name@@@sys.name' vis=label)
		item(title='Desktop' image=inherit cmd=user.desktop)
		item(title='Downloads' image=inherit cmd=user.downloads)
		item(title='Pictures' image=inherit cmd=user.pictures)
		item(title='Documents' image=inherit cmd=user.documents)
		item(title='Profile' image=inherit cmd=user.dir)
		item(title='Temp' image=inherit cmd=user.temp)
	}

	item(title=title.control_panel image=\uE0F3 cmd='shell:::{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}')
	item(title='All Control Panel Items' image=\uE0F3 cmd='shell:::{ED7BA470-8E54-465E-825C-99712043E01C}')

	menu(where=sys.ver.major >= 10 title=title.settings sep=sep.before image=\uE0F3){
		item(title='system' image=inherit cmd='ms-settings:')
		item(title='about' image=inherit cmd='ms-settings:about')
		item(title='your-info' image=inherit cmd='ms-settings:yourinfo')
		item(title='system-info' image=inherit cmd-line='/K systeminfo')

		menu(title='network' image=inherit){
			item(title='status' image=inherit cmd='ms-settings:network-status')
			item(title='ethernet' image=inherit cmd='ms-settings:network-ethernet')
			item(title='connections' image=inherit cmd='shell:::{7007ACC7-3202-11D1-AAD2-00805FC1270E}')
		}
	}
}
