
###
> PACKAGE MANAGER
###

module.exports = class UIControlsPackageManager

	###
	> DOCPAD READY HANDLER
	###

	docpadReady:(opts)->
		{docpad} = opts

		###
		> ADD CUSTOM COLLECTIONS
		###

		docpad.setCollection "controls", docpad.getCollection("documents").findAllLive({isControl:true})

		###
		> CONTROL TYPES
		###

		# Descriptions took from Feathers UI Docs.
		@controlTypes =
			# A push (or optionally, toggle) button control.
			Button:
				controlPackage = "feathers.controls"
			# A set of related buttons with layout, customized using a data provider.
			ButtonGroup:
				controlPackage = "feathers.controls"
			# A pop-up container that points at (or calls out) a specific region of the application (typically a specific control that triggered it).
			Callout:
				controlPackage = "feathers.controls"
			# A toggle control that contains a label and a box that may be checked or not to indicate selection.
			Check:
				controlPackage = "feathers.controls"
			# Displays a list of items divided into groups or sections.
			GroupedList:
				controlPackage = "feathers.controls"
			# A header that displays an optional title along with a horizontal regions on the sides for additional UI controls.
			Header:
				controlPackage = "feathers.controls"
			# Displays an image, either from a Texture or loaded from a URL.
			ImageLoader:
				controlPackage = "feathers.controls"
			# Displays text.
			Label:
				controlPackage = "feathers.controls"
			# Displays a one-dimensional list of items.
			List:
				controlPackage = "feathers.controls"
			# Displays a selected index, usually corresponding to a page index in another UI control, using a highlighted symbol.
			PageIndicator:
				controlPackage = "feathers.controls"
			# A combo-box like list control.
			PickerList:
				controlPackage = "feathers.controls"
			# Displays the progress of a task over time.
			ProgressBar:
				controlPackage = "feathers.controls"
			# A toggleable control that exists in a set that requires a single, exclusive toggled item.
			Radio:
				controlPackage = "feathers.controls"
			# Provides useful capabilities for a menu screen displayed by ScreenNavigator.
			Screen:
				controlPackage = "feathers.controls"
			# A "view stack"-like container that supports navigation between screens (any display object) through events.
			ScreenNavigator:
				controlPackage = "feathers.controls"
			# Data for an individual screen that will be used by a ScreenNavigator object.
			ScreenNavigatorItem:
				controlPackage = "feathers.controls"
			# Select a value between a minimum and a maximum by dragging a thumb over a physical range or by using step buttons.
			ScrollBar:
				controlPackage = "feathers.controls"
			# A generic container that supports layout and scrolling.
			ScrollContainer:
				controlPackage = "feathers.controls"
			# Allows horizontal and vertical scrolling of a viewport.
			Scroller:
				controlPackage = "feathers.controls"
			# Displays long passages of text in a scrollable container using the runtime's software-based flash.text.TextField as an overlay above Starling content.
			ScrollText:
				controlPackage = "feathers.controls"
			# Select a value between a minimum and a maximum by dragging a thumb over a physical range.
			SimpleScrollBar:
				controlPackage = "feathers.controls"
			# Select a value between a minimum and a maximum by dragging a thumb over the bounds of a track.
			Slider:
				controlPackage = "feathers.controls"
			# A line of tabs (vertical or horizontal), where one may be selected at a time.
			TabBar:
				controlPackage = "feathers.controls"
			# A text entry control that allows users to enter and edit a single line of uniformly-formatted text.
			TextInput:
				controlPackage = "feathers.controls"
			# Similar to a light switch with on and off states.
			ToggleSwitch:
				controlPackage = "feathers.controls"

	###
	> CALLED FOR EACH PACKAGE ADDED
	###

	packageAdded:(pkgProps,classes)->
		c = classes




