path = require 'path'
ImageEditor = require '../lib/image-editor'
ImageEditorView = require '../lib/image-editor-view'
{WorkspaceView} = require 'atom'

describe "ImageEditor", ->
	describe ".deserialize(state)", ->
		it "returns undefined if no file exists at the given path", ->
			spyOn(console, 'warn') # suppress logging in spec
			editor = new ImageEditor(path.join(__dirname, 'fixtures', 'binary-file.png'))
			state = editor.serialize()
			expect(ImageEditor.deserialize(state)).toBeDefined()
			state.filePath = 'bogus'
			expect(ImageEditor.deserialize(state)).toBeUndefined()

	describe ".activate()", ->
		it "registers a project opener that handles image file extension", ->
			atom.workspaceView = new WorkspaceView()
			atom.workspace = atom.workspaceView.model

			waitsForPromise ->
				atom.packages.activatePackage('paint')

			runs ->
				atom.workspaceView = new WorkspaceView()
				atom.workspaceView.open(path.join(__dirname, 'fixtures', 'binary-file.png'))

			waitsFor ->
				atom.workspace.getActivePaneItem() instanceof ImageEditor

			runs ->
				expect(atom.workspace.getActivePaneItem().getTitle()).toBe 'binary-file.png'
				atom.workspaceView.destroyActivePaneItem()
				atom.packages.deactivatePackage('paint')

				atom.workspaceView.open(path.join(__dirname, 'fixtures', 'binary-file.png'))

			waitsFor ->
				atom.workspace.getActivePaneItem()?

			runs ->
				expect(atom.workspace.getActivePaneItem() instanceof ImageEditor).toBe false
