# Application icon

You must provide two icons in `PNG` format: one for large sizes and other small sizes, which can be the same. It's highly recommended that you provide square icons, with a size of `512x512` or `1024x1024`.

## Build

### Requirements

* ***Windows icon:*** Can be built from Linux. The `convert` tool, from *ImageMagick* must be provided. Note that Windows already has a `convert` tool than can conflict with the one provided by *ImageMagick*, so you may want to edit the `Makefile` and make the `CONVERT` variable to point to the absolute path to the appropriate `convert` tool.

* ***macOS icon:*** Uses the `iconutil` tool provided by *Apple*.

* ***Linux icon:*** *ELF* executables do not support icons.

To build the icons just type `make` in this directory.

## Setting the application icon

* For ***Windows*** you must create a `.rc` file that contains a line like this one:

`IDI_ICON1	ICON	DISCARDABLE	"relative_or_absolute/path/to/appIcon.ico"`

Then, compile it with `winres` tool. This generates an object file that must be linked it to the executable.

* For ***macOS*** you must create a `.plist` file.

* For ***Linux*** you can use a *desktop entry* inside an *AppImage*. In such case, many image formats are supported, including `PNG` and `SVG`. You can also use a *desktop entry* inside the folder you want to deploy.