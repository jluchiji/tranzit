# Tranzit Client Application
There are a few things you need to note when working on the client application.

 + The root of Angular.js module tree is in the `ng/app.coffee`. Whenever you make a module
 make sure to add it there.

 + Every script file must be an Angular.js module. This helps us avoid load order problems
 which are sometimes hard to debug.

 + Whenever you add a file, make sure to add it to the `targets.yml` so that build script
 can recognize it. You only need to add it to the development target, since production
 target will bundle all script files together.

## Sub-directories
| Name     | Module  | Description                         |
|----------|---------|-------------------------------------|
| `api`    | `logic` | Tranzit API Client.                 |
| `ng`     | `logic` | Various non-UI application modules. |
| `views`  | `ui`    | Application views.                  |
| `shared` | `ui`    | UI-related                          |

## Style Guide
** As we make progress on development, I'll be adding more stuff here **

 + Do not use pure black (#000) and pure white (#FFF). Use dark gray (#111) and off-white (#FBFBFB) instead.
 


### Color Scheme

 + Primary Color: `#ED2939`
