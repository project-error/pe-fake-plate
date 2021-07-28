# Project Error Discord

- Join the [**Discord**](https://discord.gg/HYwBjTbAY5) to follow current development of the project and seek support.

# Description

*Pe-Fake-Plate* is a **standalone** resource and is not dependent on any framework. This was made due to the absence of a **free** reliable fake plate system that was optimized and didn't contain any exploits. There is **no database changes** within this resource. **Players will have to set their old plate on their vehicle before storing.** If requested, I can add an additional config option for this, but it defeats the purpose of a "Fake Plate". Resource currently runs at `0.0` ms.

![image](https://user-images.githubusercontent.com/55056068/118578285-e06acc80-b759-11eb-8adf-3abca2c784f1.png)


# Preview
[**Click Me!**](https://streamable.com/p388xb)

# Features

- Standalone resource with **optional** ESX integration (Usuable item and item removal/adding).
- Distance check server side to prevent exploiting.
- Changing of plate with animation.
- Fake plate contains a string of 8 letters/numbers so it looks authentic and not `XXXXXXXX`/blank plate like some resources chose to do. (See [**here**](https://i.imgur.com/bEVyXzU.png))
- Debug prints to help with any issues you may have.
- Version checker to ensure you're on the latest version.

*Any configuration is set within ether the [**cl_config.lua**](https://github.com/project-error/pe-fake-plate/blob/main/config/cl_config.lua) or the [**sv_config.lua**](https://github.com/project-error/pe-fake-plate/blob/main/config/sv_config.lua).*

- Config option to change the identifier that is being used easily.
- Config option for [**Mysql-Async**](https://github.com/brouznouf/fivem-mysql-async) **or** [**Ghmattisql**](https://github.com/GHMatti/ghmattimysql).
- Config option for multiple notification systems. ([**T-Notify**](https://github.com/TasoOneAsia/t-notify), [**Mythic-Notify**](https://github.com/FlawwsX/mythic_notify), [**pNotify**](https://forum.cfx.re/t/release-pnotify-in-game-js-notifications-using-noty/20659) and **ESX Notifications**.)
- Config option for [**Mythic Progress Bar**](https://github.com/ONyambura/mythic_progbar) .
- Config option to restrict it to the vehicle owner. (Requires you to set [**Mysql-Async**](https://github.com/brouznouf/fivem-mysql-async) **or** [**Ghmattisql**](https://github.com/GHMatti/ghmattimysql) to true.)
- Config option to allow the player to apply multiple fake plates.

# Dependencies (Optional)

- [Mysql-Async](https://github.com/brouznouf/fivem-mysql-async) **or** [**Ghmattisql**](https://github.com/GHMatti/ghmattimysql) You will need to set the config to `true`/`false` within the [**sv_config.lua**](https://github.com/project-error/pe-fake-plate/blob/main/config/sv_config.lua). 
If using `Ghmattisql`, be sure to comment out `'@mysql-async/lib/MySQL.lua',` within the [**fxmanifest**](hhttps://github.com/project-error/pe-fake-plate/blob/faa27fd64019a21f88665af9859f1f4e95204fa0/fxmanifest.lua#L12).

# Supported Notifications

*Pe-Fake-Plate* supports the following notification resources by default:
- [**T-Notify**](https://github.com/TasoOneAsia/t-notify) **(Recomended)** T-Notify offers numerous advantages over any other notification system and has well written [Docs](https://docs.tasoagc.dev/#/). This is the suggested notification system to be used. Please ensure you're on the latest version.
- [**Mythic-Notify**](https://github.com/FlawwsX/mythic_notify) This resource uses `SendAlert` and not the old way of `DoHudText` so this version is **required** if you want to use `Mythic-Notify`.
- [**pNotify**](https://forum.cfx.re/t/release-pnotify-in-game-js-notifications-using-noty/20659) GTA Online styled notification system.
- **ESX Notifications** Basic ESX notifications.

# Supported Progress Bars (Optional)

*Pe-Fake-Plate* supports the following prgress bar resources by default:
- [**Mythic Progress Bar**](https://github.com/ONyambura/mythic_progbar)

If you would like more supported please follow the same code style and PR it.

# How it works

- Player gets inside the vehicle they want to change and gets out.
- Player does `/fakePlate` to apply the fake plate and `/returnPlate` to reset it back to the original plate.
- If esx is being used then the player can use the item instead. **The config option has to be set to true first.**

# Contributing

Please make all pull request towards the [**Dev Branch**](https://github.com/project-error/new-fakeplate-who-dis/tree/dev). If you have any suggestions for improvements please contact `ROCKY_southpaw#6771` on **Discord** or in the [**Project Error Discord**](https://discord.gg/HYwBjTbAY5) or open an issue.
