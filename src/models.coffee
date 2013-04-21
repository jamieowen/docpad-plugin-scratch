
###
> PACKAGE MANAGER
###

module.exports = class ModelPackageManager

	###
	> DOCPAD READY HANDLER
	###
	docpadReady:(opts)->
		{docpad} = opts

		###
		> ADD CUSTOM COLLECTIONS
		###

		docpad.setCollection "models", docpad.getCollection("documents").findAllLive({isModel:true})

		###
		> SETUP DEFAULT AND CUSTOM MODEL FIELD TYPES
		###

		customFieldTypes = docpad.config.templateData.customFieldTypes || {}

		@fieldTypes =
			int:""
			uint:""
			Number:""
			Boolean:""
			String:""
			Array:""
			Date:""
			XML:""
			# for type like vector specify a function that strips the type from the string.
			# the getImportsForType will check the existence of 'Vector' in the type string.
			Vector: (vectorString) ->
				vectorString.replace("Vector.<","").replace(">","")

		for fieldType of customFieldTypes
			@fieldTypes[fieldType] = customFieldTypes[fieldType]

		###
		> EXTEND DOCUMENT MODEL
		###

		{DocumentModel} = docpad
		fieldTypes = @fieldTypes

		###
		> RETURN THE IMPORTS REQUIRED FOR A MODELS FIELDS
		###
		DocumentModel::getImportsForModelClass = (modelDocument) ->
			if modelDocument.isModel
				types = {}
				for field of modelDocument.classData
					typeImport = fieldTypes[ modelDocument.classData[field] ]
					if typeof(typeImport) == "function"
						typeImport = typeImport( modelDocument.classData[field] )

					if typeof(typeImport) == "string" and typeImport.length > 0 and typeImport != modelDocument.classAbsName
						types[ typeImport ] = true

					else if not typeImport and typeof(typeImport) != "string"
						docpad.log "An unrecognised type was specified in Model[#{modelDocument.className}], Field(#{field}), Type(#{modelDocument.classData[field]})"
					# else, this would be a native type.

				results = []
				results.push type for type of types
				return results
			else
				return []

		return

	###
	> CALLED FOR EACH PACKAGE ADDED
	###
	# Update the field types with any defined models.
	packageAdded:(pkgProps,classes)->
		if pkgProps.isModel
			for cls in classes
				@fieldTypes[ cls.classProps.className ] = cls.classProps.classAbsName





