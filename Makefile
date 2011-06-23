all: opacms.exe

opacms.exe: OpaCms.editor.opx OpaCms.user.opx OpaCms.page.opx src/main.opa
	opa $^ -o opacms.exe --autobuild

OpaCms.user.opx: src/user.opa
	opa $^  --no-server --autobuild --api

OpaCms.page.opx: src/page.data.opa src/page.client.opa src/page.server.opa
	opa $^ --no-server --autobuild --api

OpaCms.editor.opx: editor.opp editor/editor.opa
	opa $^ --no-server --autobuild --api

editor.opp: editor/editor.js
	opa-plugin-builder $^ -o $@


clean:
	rm -rf _build _tracks
	rm -rf *.exe
	rm -rf *.log
	rm -rf *.opp
	rm -rf *.opx
