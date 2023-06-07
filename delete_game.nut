function generatePath(val, fileEntry){
    local path = "";
    local index = fileEntry.find(val);

    if (index != null) {
        path = fileEntry.slice(index + val.len());
        local index2 = path.find("\n");
        path = path.slice(0, index2) + "\\" + fe.game_info(Info.Name) + ".*";
    }
    
    return path;
}

local options = ["Si", "No"];
local res = fe.overlay.list_dialog(options, "Eliminar juego [" + fe.game_info(Info.Title) + "]?");
if (res == 1) return;

if (OS == "Windows") {
    local currentIndex = fe.list.display_index;
    local cfgPath = "C:\\Attract\\emulators\\" + fe.game_info(Info.Emulator) + ".cfg"; //Modificar si letra de tu disco y/o directorio es distinto.
    local _f = file(cfgPath, "r");
    local _blb = _f.readblob(100000);
    local fileEntry = "";

    for (local i = 0; i < _blb.len(); i++) {
        local binChar = _blb.readn('b');
        local curChar = binChar.tochar();
        fileEntry += curChar;
    }
    
    // Generar rutas de archivos
    local romPath = generatePath("rompath", fileEntry);
    local snapsPath = generatePath("snaps", fileEntry);
    local snapPath = generatePath("snap", fileEntry);
    local wheelPath = generatePath("wheel", fileEntry);
    local marqueePath = generatePath("marquee", fileEntry);
    local flyerPath = generatePath("flyer", fileEntry)
  
    // Ejecutar los comandos para eliminar los archivos  
    fe.plugin_command("cmd", "/c del /s /q " + romPath);
    fe.set_display( currentIndex);
    
    settimeout(function(){
        fe.plugin_command("cmd", "/c del /s /q " + wheelPath);
        fe.plugin_command("cmd", "/c del /s /q " + marqueePath);
        fe.plugin_command("cmd", "/c del /s /q " + flyerPath);
        fe.plugin_command("cmd", "/c del /s /q " + snapPath);
        fe.plugin_command("cmd", "/c del /s /q " + snapsPath);
    }, 500);  

}
