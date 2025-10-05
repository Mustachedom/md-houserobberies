Lang = {}
Lang.Info = {
    currency = '€',
}

Lang.Warn = {
    fence = {
        wrongItem = '%s tente d’exploiter l’événement de vente de butin | Objet : %s',
    },
    faileddistChecks = '%s tente d’exploiter l’événement MD HouseRobbery, a échoué 2 vérifications de distance à la porte d’entrée et de sortie',
    takeLootEvent = {
        main = ' %s tente d’exploiter l’événement de prise de butin | Raisons :',
        dist = 'Trop loin du butin',
        notSpawn = 'Cette maison n’est pas chargée',
        lootDoesntExist = 'Ce butin n’existe pas',
        lootTaken = 'Ce butin a déjà été pris',
        notInHouse = 'Pas à l’intérieur de la maison',
        lootBusy = 'Ce butin n’est pas en cours de vol',
        notEnoughCops = 'Pas assez de policiers',
    },
    lockhouse = {
        dist = 'Trop loin de la maison',
        notSpawn = 'Cette maison n’est pas chargée',
        notCop = 'Tu n’es pas policier',
    },
    minigame = {
        failed = '%s tente d’exploiter l’événement d’échec du mini-jeu | Avait l’objet côté client mais pas côté serveur | Objet : %s',
        exploit = 'Tu tentes d’exploiter le mini-jeu',
    },
}
Lang.Error = {
    noGame = 'Tu n’as pas sélectionné correctement un mini-jeu ! Contacte le propriétaire du serveur !',
    noDispatch = 'Tu n’as pas sélectionné correctement un système de dispatch ! Contacte le propriétaire du serveur !',
    notEnoughCops = 'Pas assez de policiers – ce n’est pas censé être si facile !',
    dontHaveItem = 'Tu as besoin d’un %s pour faire cela',
    dontHaveLoot = 'Tu n’as aucun butin à vendre',
    dontHaveSale = 'Tu n’as pas de %s à vendre',
    robbed = 'Mince ! Tu viens de te faire voler tout ton %s !',
}
Lang.Targets = {
    search = 'Fouiller %s',
    searchIcon = 'fa-solid fa-box-open',
    hideBody = 'Cacher le corps',
    hideBodyIcon = 'fa-solid fa-box-open',
    robHouse = 'Cambrioler la maison',
    robHouseIcon = 'fa-solid fa-house',
    enterHome = 'Entrer dans la maison fracturée',
    enterHomeIcon = 'fa-solid fa-door-open',
    lockDoor = 'Verrouiller la porte',
    lockDoorIcon = 'fa-solid fa-lock',
    smokeBomb = 'Utiliser une bombe fumigène',
    smokeBombIcon = 'fa-solid fa-smog',
    leaveHouse = 'Quitter la maison',
    leaveHouseIcon = 'fa-solid fa-door-closed',
    sellLoot = 'Vendre le butin',
    sellLootIcon = 'fa-solid fa-hand-holding-dollar',
}

Lang.Progress = {
    searching = 'Je vole tout ce que je trouve',
    hidingBody = 'Je cache le corps du propriétaire',
}

Lang.Menu = {
    fence = 'Clan du cambriolage',
}
return Lang