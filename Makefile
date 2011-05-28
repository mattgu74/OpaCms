all: editor opacms.exe

opacms.exe: OpaCms.opack
	opa $^ -o opacms.exe

editor: editor.opp editor/editor.opa
	opa $^ --no-server

editor.opp: editor/editor.js
	opa-plugin-builder $^ -o $@


clean:
	rm -rf _build _tracks
	rm -rf *.exe
	rm -rf *.log
	rm -rf *.opp
	rm -rf *.opx