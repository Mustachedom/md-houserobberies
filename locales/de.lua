Lang = {}
Lang.Info = {
    currency = '€',
}

Lang.Warn = {
    fence = {
        wrongItem = '%s versucht, das Beute-Verkaufs-Event auszunutzen | Gegenstand: %s',
    },
    faileddistChecks = '%s versucht, das MD HouseRobbery-Event auszunutzen, hat 2 Standortprüfungen für Eingangs- und Ausgangstür nicht bestanden',
    takeLootEvent = {
        main = ' %s versucht, das Beute-Entnahme-Event auszunutzen | Gründe:',
        dist = 'Zu weit von der Beute entfernt',
        notSpawn = 'Dieses Haus ist nicht geladen',
        lootDoesntExist = 'Diese Beute existiert nicht',
        lootTaken = 'Diese Beute wurde bereits genommen',
        notInHouse = 'Nicht im Haus',
        lootBusy = 'Diese Beute wird gerade nicht ausgeraubt',
        notEnoughCops = 'Nicht genug Polizisten',
    },
    lockhouse = {
        dist = 'Zu weit vom Haus entfernt',
        notSpawn = 'Dieses Haus ist nicht geladen',
        notCop = 'Du bist kein Polizist',
    },
    minigame = {
        failed = '%s versucht, das Minispiel-Fehlschlag-Event auszunutzen | Hatte Gegenstand clientseitig, aber nicht serverseitig | Gegenstand: %s',
        exploit = 'Du versuchst, das Minispiel auszunutzen',
    },
}
Lang.Error = {
    noGame = 'Du hast kein Minispiel richtig ausgewählt! Bitte kontaktiere den Serverbesitzer!',
    noDispatch = 'Du hast kein Dispatch-System richtig ausgewählt! Bitte kontaktiere den Serverbesitzer!',
    notEnoughCops = 'Nicht genug Polizisten – soll ja nicht zu einfach sein!',
    dontHaveItem = 'Du brauchst ein %s dafür',
    dontHaveLoot = 'Du hast keine Beute zum Verkaufen',
    dontHaveSale = 'Du hast keine %s zum Verkaufen',
    robbed = 'Verdammt! Du wurdest gerade um all dein %s ausgeraubt!',
}
Lang.Targets = {
    search = '%s durchsuchen',
    searchIcon = 'fa-solid fa-box-open',
    hideBody = 'Leiche verstecken',
    hideBodyIcon = 'fa-solid fa-box-open',
    robHouse = 'In Haus einbrechen',
    robHouseIcon = 'fa-solid fa-house',
    enterHome = 'In ausgebrochenes Haus betreten',
    enterHomeIcon = 'fa-solid fa-door-open',
    lockDoor = 'Tür abschließen',
    lockDoorIcon = 'fa-solid fa-lock',
    smokeBomb = 'Rauchbombe benutzen',
    smokeBombIcon = 'fa-solid fa-smog',
    leaveHouse = 'Haus verlassen',
    leaveHouseIcon = 'fa-solid fa-door-closed',
    sellLoot = 'Beute verkaufen',
    sellLootIcon = 'fa-solid fa-hand-holding-dollar',
}

Lang.Progress = {
    searching = 'Alles klauen, was ich finden kann',
    hidingBody = 'Leiche des Hausbesitzers verstecken',
}

Lang.Menu = {
    fence = 'Hehler für Hausraub',
}
return Lang