assetLibrary-as3
================


AssetLibrary - file management tool. (Preloading, unloading, storing in local storadge )

Features :
  * manages asset using assetId
    * support file definition.
    * support path definition for easer management of files in same folders.
    * support group definition, an array of files.  (used for group pre-loading or unloading)
    * in XML : paths can be nested in groups, or groups can be nested in paths.
  * files has these properties :
    * id
    * file name and path
    * file type can be defined if not standard file extension is used.
    * urlParams can be added for version control.
    * files can be permanent or temporal. Permanent files can be downloaded only once, can't be unloaded, and only permanent files can be instantly retrieved.
  * allows to add files in 2 ways: dynamic with code, load from XML.
  * allows 2 ways of getting files: instant, send to handling function.
  * permanent file protection can be removed. (not recommended)
  * it's possible to pre-load single or group of files. (with progress tracking)
  * it's possible to unload single or group of files.
  * all errors are handled through one function. It can be changed to custom function.

  * allows to use local object as file storadge mechanizm.

  * Supported files:
    * swf
    * jpg, png, gif
    * mp3
    * xml

  * control over amount of simultaneous loads.

  * allows to set time for asset to expire automatical. (time for asset to be removed from cashe) {in progress}

In plans.

*xml stored as object.