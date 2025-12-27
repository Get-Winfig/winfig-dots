menu(type="taskbar" vis=key.shift() or key.lbutton() pos=0 title=app.name image=\uE249){
	item(title="config" image=\uE10A cmd='"@app.cfg"')
	item(title="manager" image=\uE0F3 admin cmd='"@app.exe"')
	item(title="directory" image=\uE0E8 cmd='"@app.dir"')
}

menu(where=@(this.count == 0) type='taskbar' image=icon.settings expanded=true){
	menu(title="Apps" image=\uE254){
		item(title='Calculator' image=\uE1E7 cmd='calc.exe')
		item(title='Regedit' image cmd='regedit.exe')
		item(title='ShareX' image cmd='"C:\Program Files\ShareX\ShareX.exe"')
		item(title='System Properties' image cmd='SystemPropertiesAdvanced.exe')
	}

	item(title=title.settings image=icon.settings(auto, image.color1) cmd='ms-settings:')
    item(title=title.task_manager sep=both image=icon.task_manager cmd='taskmgr.exe')
    item(title=title.taskbar_Settings sep=both image=inherit cmd='ms-settings:taskbar')
	item(vis=key.shift() title=title.exit_explorer cmd=command.restart_explorer)
}
