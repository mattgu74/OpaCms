
OPA=opa
OPADOC=opadoc
EXE=opacms.exe

all: $(EXE)

opacms.exe: OpaCms.editor.opx OpaCms.user.opx OpaCms.page.opx OpaCms.admin.opx src/main.opa
	$(OPA) $^ -o $(EXE)

OpaCms.user.opx: src/user.opa
	$(OPA) $^  --no-server --autocompile

OpaCms.page.opx: src/page.data.opa src/page.client.opa src/page.server.opa src/page.css.opa src/config.opa src/theme.opa
	$(OPA) $^ --no-server --autocompile

OpaCms.admin.opx: OpaCms.page.opx src/admin.opa
	$(OPA) $^ --no-server --autocompile

OpaCms.editor.opx: editor.opp editor/editor.opa
	$(OPA) $^ --no-server --autocompile

editor.opp: editor/editor.js
	opa-plugin-builder $^ -o $@

doc:    all
	$(OPA) src/*.opa --api
	$(OPADOC) src -o doc

new-db:	all
	./$(EXE) --db-force-upgrade

run: 	all
	./$(EXE)

clean:
	rm -rf _build _tracks
	rm -rf *.exe
	rm -rf *.log
	rm -rf *.opp
	rm -rf *.opx
	rm -rf *.opx.broken

