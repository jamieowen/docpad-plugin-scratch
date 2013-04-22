# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class Scratch extends BasePlugin
		# Plugin name
		name: 'scratch'

		constructor:()->
			super

			# package properties will automatically added as metadata
			# to the generated docpad document.
			# except the following...
			@ignoredPackageProperties =
				classes:true
				prependAppName:true
				pkg:true

			@fileExtension = ".as"

			@packages = []
			@packageManagers = []

			pmMain = require("./main")
			pmContextConfig = require("./contextConfig")
			pmContextView = require("./contextView")
			pmGeneral = require("./general")
			pmModels = require("./models")
			pmEvents = require("./events")
			pmMediators = require("./mediators")
			pmViews = require("./views")
			pmControls = require("./controls")

			@registerPackageManager new pmMain()
			@registerPackageManager new pmContextConfig()
			@registerPackageManager new pmContextView()
			@registerPackageManager new pmGeneral()
			@registerPackageManager new pmModels()
			@registerPackageManager new pmEvents()
			@registerPackageManager new pmMediators()
			@registerPackageManager new pmViews()
			@registerPackageManager new pmControls()

		###
		> REGISTER A PACKAGE MANAGER
  	Allows a seperate class to define docpad DocumentModel methods
  	and docpad collections.
		###

		registerPackageManager:(manager)->
			@packageManagers.push manager

		###
		> DOCPAD READY EVENT
		###

		docpadReady: (opts,next) ->
			{docpad} = opts
			@docpad = docpad

			###
			> BUILD PACKAGE INDEX
			Format the package list into a usuable format with absolute
  		package name and easy access to class data.
			###

			rootPackage = docpad.config.templateData.app.rootPackage || ""
			packageList = docpad.config.templateData.packageList || []
			for pkgRaw in packageList
				absPackage = if pkgRaw.pkg == "" then rootPackage else rootPackage + "." + pkgRaw.pkg
				# build the list of properties to add as metadata to generate documents.
				pkgProps = {}
				for prop of pkgRaw
					if @ignoredPackageProperties[prop] != true
						pkgProps[prop] = pkgRaw[prop]

				# override normal package with absolute package
				pkgProps["packageName"] = absPackage

				# build class index for package
				classes = []
				for cls of pkgRaw.classes
					clsNew =
						classProps:
							className: cls
							classAbsName: absPackage + "." + cls
							classImport: "import " + absPackage + "." + cls + ";"
						classData:pkgRaw.classes[cls]

					classes.push clsNew

				# add the newly formatted package and class information to be generated.
				@packages.push { pkg:absPackage, pkgClasses:classes, pkgProps:pkgProps }

			###
			> GENERATE PACKAGE FOLDERS
			###

			fsUtil = require("fs")
			pathUtil = require("path")

			documentsPath = @docpad.config.documentsPaths[0].split(pathUtil.sep)
			for pkg in @packages
				pkgFolders = pkg.pkg.split(".")
				pkgFoldersH = []
				for pkgFolder in pkgFolders
					pkgFoldersH.push( pkgFolder )
					folderPath = documentsPath.concat(pkgFoldersH).join( pathUtil.sep )
					if not fsUtil.existsSync( folderPath )
						fsUtil.mkdirSync( folderPath )

			###
			> PASS CONTROL TO PACKAGE MANAGERS FOR ADDITIONAL SETUP AND FORMATTING OF METADATA
			###

			#
			# DOC READY
			for pm in @packageManagers
				pm.docpadReady(opts)

			#
			# PACKAGE ADDED
			for pm in @packageManagers
				for pkg in @packages
					pm.packageAdded(pkg.pkgProps,pkg.pkgClasses)

			###
			> GENERATE DOCPAD DOCUMENTS WITH META DATA
			###
			yamlUtil = require("yamljs")

			for pkg in @packages
				for cls in pkg.pkgClasses
					fileWritePath = documentsPath.concat( pkg.pkg.split(".")).join( pathUtil.sep )
					fileWritePath += pathUtil.sep + cls.classProps.className + @fileExtension

					meta = "---\n"
					meta += yamlUtil.stringify(pkg.pkgProps)
					meta += yamlUtil.stringify(cls.classProps)
					meta += yamlUtil.stringify({classData:cls.classData})
					meta += "---"

					fsUtil.writeFileSync(fileWritePath,meta)



			next()
			return

		###
		> GENERATE BEFORE DOCPAD HANDLER
		###

		generateBefore: () ->
			c = null






