# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class DocpadSupply extends BasePlugin
		# Plugin name
		name: 'as-supply'

		config:
			actionsript: 'associated-files'

		docpadReady: (opts,next) ->
			{docpad} = opts
			{DocumentModel} = docpad
			@docpad = docpad

			plugin = @

			@templateData = docpad.config.templateData
			@classFiles = @templateData.generateClassFiles
			@classData = {}
			@importTypes = @templateData.importTypes

			# returns import statements for classes
			DocumentModel::getImportsForClasses = (collection)->
				imports = []
				for cls, i in collection
					cls = collection.at(i)
					imports.push "import " + cls.get("classId") + ";"

				return imports

			DocumentModel::getModelImportsForTypes = (model,types)->
				results = []
				for type in types
					typeHandler = plugin.importTypes[type]
					# handle vector different
					if type.indexOf("Vector.<") == 0
						vectorOfType = plugin.importTypes["Vector"]( type )
						# don't handle 2d Vectors for now.
						if vectorOfType != "Vector"
							results = results.concat( @getModelImportsForTypes( model,[vectorOfType] ))
					else if typeof(typeHandler) == "string" and typeHandler != ""
						results.push typeHandler
					else if not typeHandler and typeHandler != ""
						plugin.docpad.log "Unsupported type specified for Model(#{model}) field type(#{type})."

					# any other primitive type allowed will have null as a handler
				results2 = []
				found = {}
				for result in results
					# remove any types coming from model itself. a better solution could be used.
					# But this will do for now.
					if found[result] == undefined and result.indexOf(model) == -1
						results2.push result
						found[result] = true

				return results2

			DocumentModel::getDataForClass = (classId)->
				return plugin.classData[classId]

			@generateClassFiles(@classFiles)
			next()

		generateBefore: (opts) ->
			{docpad} = opts

		# generates all view .as files
		generateClassFiles:(classPackages) ->
			@docpad.log "Generating Actionscript Preprocess Documents.."

			# properties found in the class object are added as
			# metadata to the as files. excluding these properties.
			ignoredProperties =
				classes:true
				prependAppName:true

			fs = require("fs")
			path = require("path")
			extension = ".as"

			# source path is the preprocess folder.
			documentsPath = @docpad.config.documentsPaths[0].split(path.sep)
			for classPackage in classPackages
				if classPackage.pkg and classPackage.pkg.replace(" ", "").length
					pkg = @templateData.app.rootPackage + "." + classPackage.pkg.replace(" ", "")
				else
					pkg = @templateData.app.rootPackage

				pkgPath = pkg.split "."

				# Create package directories. iterate down the package path
				# and create each folder.
				mkdirPaths = documentsPath.slice(0)
				for mkdirPath in pkgPath
					mkdirPaths.push mkdirPath
					if not fs.existsSync( mkdirPaths.join(path.sep) )
						fs.mkdirSync( mkdirPaths.join(path.sep) )

				pkgPath = path.join( documentsPath.concat(pkgPath).join(path.sep) )

				# now generate each file.
				for cls of classPackage.classes
					if classPackage.prependAppName
						cls = @templateData.app.name + cls

					fileName = cls + extension
					filePath = path.join(pkgPath,fileName)
					fileExists = fs.existsSync( filePath )
					layout = classPackage.layout
					id = pkg + "." + cls

					# append extra to cls object.
					classPackage.classId = id
					classPackage.pkg = pkg
					classPackage.class = cls

					# store the class data objects.
					@classData[ id ] = classPackage.classes[cls]

					# update import types
					if classPackage.isModel
						@importTypes[cls] = classPackage.classId


					if not fileExists or @templateData.app.generateAlways
						@docpad.log "Writing Actionscript Preprocess File : " + id.split(".").join(path.sep)
						output =
							"""
							---

							"""
						for prop of classPackage
							if ignoredProperties[prop] != true
								if typeof(classPackage[prop]) == "string"
									output+=
										"""
										#{ prop }: "#{ classPackage[prop] }"

										"""
								else
									output+=
										"""
										#{ prop }: #{ classPackage[prop] }

										"""

						output +=
							"""
							---
							"""
						fs.writeFileSync(filePath,output)








