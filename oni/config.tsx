
import * as React from "/opt/oni/resources/app/node_modules/react"
import * as Oni from "/opt/oni/resources/app/node_modules/oni-api"

export const activate = (oni: Oni.Plugin.Api) => {
    [   'C-p', 'S-C-p', 'C-Enter', 'C-t', 'S-C-t',
        'C-Tab', 'S-C-f', 'C-c', 'C-v', 'C-/',
        'C-g', 'F2', 'F3', 'F12'
    ].forEach( key => oni.input.unbind(`<${key}>`) )
    const isNormalMode =
        () => oni.editors.activeEditor.mode === "normal"
    oni.input.bind("<C-:>", "commands.show", isNormalMode)
}

export const configuration = {
    activate,
    "autoClosingPairs.enabled": false,
    "commandline.mode": false,
    "editor.clipboard.enabled": false,
    "editor.completions.mode": "native",
    "editor.errors.slideOnForce": true,
    "editor.fontFamily": "Cica, Ubuntu Mono",
    "editor.fontLigatures": false,
    "editor.fontSize": "11px",
    "editor.linePadding": 1,
    "editor.quickInfo.enabled": false,
    "editor.scrollBar.visible": false,
    "oni.loadInitVim": true,
    "oni.hideMenu": true,
    "oni.useDefaultConfig": false,
    "oni.useExternalPopupMenu": false,
    "sidebar.enabled": false,
    "statusbar.enabled": false,
    "tabs.mode": "native",
    "ui.animations.enabled": true,
    "ui.colorscheme": "onedark",
    "ui.fontFamily": "Source Han Sans JP",
    "ui.fontSmoothing": "auto",
    "wildmenu.mode": false,
}

