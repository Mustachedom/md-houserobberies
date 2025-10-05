Lang = {}
Lang.Info = {
    currency = '€',
}

Lang.Warn = {
    fence = {
        wrongItem = '%s está intentando explotar el evento de vender botín | Objeto: %s',
    },
    faileddistChecks = '%s está intentando explotar el evento MD HouseRobbery, falló 2 comprobaciones de ubicación en puerta principal y puerta de salida',
    takeLootEvent = {
        main = ' %s está intentando explotar el evento de tomar botín | Razones:',
        dist = 'Demasiado lejos del botín',
        notSpawn = 'Esta casa no está generada',
        lootDoesntExist = 'Este botín no existe',
        lootTaken = 'Este botín ya fue tomado',
        notInHouse = 'No estás dentro de la casa',
        lootBusy = 'Este botín no está siendo robado',
        notEnoughCops = 'No hay suficientes policías',
    },
    lockhouse = {
        dist = 'Demasiado lejos de la casa',
        notSpawn = 'Esta casa no está generada',
        notCop = 'No eres policía',
    },
    minigame = {
        failed = '%s está intentando explotar el evento de fallo del minijuego | Tenía objeto en cliente pero no en servidor | Objeto: %s',
        exploit = 'Estás intentando explotar el minijuego',
    },
}
Lang.Error = {
    noGame = '¡No seleccionaste un minijuego correctamente! ¡Contacta al dueño del servidor!',
    noDispatch = '¡No seleccionaste un sistema de despacho correctamente! ¡Contacta al dueño del servidor!',
    notEnoughCops = 'No hay suficientes policías, ¡no queremos que sea tan fácil!',
    dontHaveItem = 'Necesitas un %s para hacer esto',
    dontHaveLoot = 'No tienes botín para vender',
    dontHaveSale = 'No tienes %s para vender',
    robbed = '¡Rayos! ¡Acabas de ser robado de todo tu %s!',
}
Lang.Targets = {
    search = 'Registrar %s',
    searchIcon = 'fa-solid fa-box-open',
    hideBody = 'Esconder el cuerpo',
    hideBodyIcon = 'fa-solid fa-box-open',
    robHouse = 'Entrar a robar casa',
    robHouseIcon = 'fa-solid fa-house',
    enterHome = 'Entrar a casa forzada',
    enterHomeIcon = 'fa-solid fa-door-open',
    lockDoor = 'Cerrar puerta con llave',
    lockDoorIcon = 'fa-solid fa-lock',
    smokeBomb = 'Usar bomba de humo',
    smokeBombIcon = 'fa-solid fa-smog',
    leaveHouse = 'Salir de la casa',
    leaveHouseIcon = 'fa-solid fa-door-closed',
    sellLoot = 'Vender botín',
    sellLootIcon = 'fa-solid fa-hand-holding-dollar',
}

Lang.Progress = {
    searching = 'Robando todo lo que encuentro',
    hidingBody = 'Escondiendo el cuerpo del dueño',
}

Lang.Menu = {
    fence = 'Receptor de robos de casas',
}
return Lang