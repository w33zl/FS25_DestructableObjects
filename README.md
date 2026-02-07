![FS25_WZLModding_DestructibleObjects_Screenshots1](https://github.com/user-attachments/assets/64ce04ce-6727-4160-a468-250eff53193b)

Destructable Objects adds placeable destructible objects that can be placed anywhere on the map. These objects can be broken into pieces (e.g using the jackhammer), doing so will drop material (stones) to the ground. They work just as the default crushable rocks on the base game maps. 

Using this specialization, additional types of destructible objects can be added in other mods, see below for instructions. These custom destructable objects can have different properties (e.g. harder materials taking longer time to crush) and can drop other materials than stone.

---

# Want to make your own destructable objects?

You can use the destructable object specialization from this mod in your own mod . Just follow these simple steps:

## 1. Edit modDesc.xml

To be able to use the `placeableDestructibleObject` specialization from Destructable Objects you first need to add the following to your modDesc.xml:

```xml
<placeableSpecializations>
    <specialization name="placeableDestructibleObject" className="PlaceableDestructibleObject" filename="../FS25_DestructableObjects/scripts/specializations/PlaceableDestructibleObjectSpecialization.lua"/>
</placeableSpecializations>
```

The you need a placeable type that supports this new `placeableDestructibleObject` specialization, either you can use this generic placeable type:
```xml
<placeableTypes>
    <type name="placeableDestructibleObject" parent="simplePlaceable" filename="$dataS/scripts/placeables/Placeable.lua">
        <specialization name="placeableDestructibleObject"/>
    </type>
</placeableTypes>
```

Or, you can define your own:
```xml
<placeableTypes>
    <type name="YOUR_CUSTOM_TYPE" parent="simplePlaceable" filename="$dataS/scripts/placeables/Placeable.lua">
        <specialization name="placeableDestructibleObject"/>
        <!-- Add additional specializations as needed below -->
    </type>
</placeableTypes>
```

Finally, add _Destructiable Objects_ as a dependency (this ensures the mod is available and active to avoid errors):
```xml
<dependencies>
    <dependency>FS25_DestructableObjects</dependency>
</dependencies>
```


## 2. Add your custom placeable

In the placeable XML of choice, change the `type` attribute of your <placeable> node to any type that supports the `placeableDestructibleObject` specialization.

Now assuming your current placeable looks like this:

```xml
<placeable type="simplePlaceable" ... />
```
Then we change to this:
```xml
<placeable type="placeableDestructibleObject" ... />
```


## 3. Edit the i3d file

In order for the script to properly recognize the actual crushable 3D object, the following _User Attributes_ should be set on a node in the i3d file. Normally, this is set on a transform group containing the visible crushable object(s). 

| Name | Type | Value |
|-|-|-|
| onFinalize | Script Callback | Always `DestructibleMapObjectSystem.onCreateGroup`
| destructibleType| String | Which type of tool is needed to break the object. E.g. `ROCK`.
| destructionVolume| Float | E.g. `100`. Affects how much effort/time is needed to break the object (different tools can have .different destruction power). 
| dropAmount| Float | E.g. `1000`. The amount (in liters) to drop.
| dropFillTypeName| String | E.g. `WHEAT`. The filltype to drop. 
| groupId | Integer | Should be `-1` |

<img width="70%" alt="image" src="https://github.com/user-attachments/assets/f8a09689-6418-4e1f-8852-73dfcc10f777" />


Note: It is possible to have multiple visual crushable objects per "group" (as defined by the user attributes above), which means that you define a "group" by these attributes and then you can have e.g. ten different stones in that group, each dropping the same filltype and amount.

---

# About WZL Modding

## Download my mods
To download my mods, please visit my FS19, FS22 or FS25 page on the official Giants ModHub page:

[![My FS22 Mods](https://raw.githubusercontent.com/w33zl/w33zl/main/GitHubIcons_MH_FS19.png)](https://www.farming-simulator.com/mods.php?title=fs2019&filter=org&org_id=140742)
[![My FS22 Mods](https://raw.githubusercontent.com/w33zl/w33zl/main/GitHubIcons_MH_FS22.png)](https://www.farming-simulator.com/mods.php?title=fs2022&filter=org&org_id=140742)
[![My FS25 Mods](https://raw.githubusercontent.com/w33zl/w33zl/main/GitHubIcons_MH_FS25.png)](https://www.farming-simulator.com/mods.php?title=fs2025&filter=org&org_id=140742)


## Open Modding Alliance
I'm a contributor and co-founder of the [Open Modding Alliance](https://github.com/open-modding-alliance) (OMA). The core of OMA is collaboration and knowledge sharing for the greater good of the Farming Simulator community. If you are a modder or create assets for FS I can recommend paying this page a visit:

[![Open Modding Alliance](https://raw.githubusercontent.com/w33zl/w33zl/main/GitHubIcons_OMA.png)](https://github.com/open-modding-alliance)


## Connect with me
📫 Want to get in touch? If you have bugs to report or want to suggest improvements, it is easiest to send a ticket here on GitHub (see projects above). Otherwise you can find me on Facebook, Patreon and Discord:


[![WZL Modding on Facebook](https://raw.githubusercontent.com/maurodesouza/profile-readme-generator/master/src/assets/icons/social/facebook/default.svg)](https://fb.com/w33zl) *&nbsp;* [![WZL Modding on Patreon](https://raw.githubusercontent.com/maurodesouza/profile-readme-generator/master/src/assets/icons/social/patreon/default.svg)](https://www.patreon.com/wzlmodding) *&nbsp;* [![https://discordapp.com/users/w33zl](https://raw.githubusercontent.com/maurodesouza/profile-readme-generator/master/src/assets/icons/social/discord/default.svg)](https://discordapp.com/users/w33zl)


## Like the work I do?
I love to hear you feedback so please check out my [Facebook](https://www.facebook.com/w33zl). If you want to support me you can become my [Patron](https://www.patreon.com/wzlmodding) or buy me a [Ko-fi](https://ko-fi.com/w33zl) :heart:

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/X8X0BB65P) [![Support me on Patreon](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fshieldsio-patreon.vercel.app%2Fapi%3Fusername%3Dwzlmodding%3F%26type%3Dpatrons&style=for-the-badge)](https://patreon.com/wzlmodding?)

> _By interacting with me and supporting me on these platforms, you help me stay motivated to create new mods and make them publicly available for you to enjoy. This support also enables me to lear new techniques, invest in tools, and spend more time creating high quality mods, tools and assets for the Farming Simulator community._
