# "Journal"

While making *Jostle Parent* I maintained a journal in Evernote to keep track of my thoughts a little. Here are the entries. Many of these are just lists of things I needed to do or had done. With some reflection about what was going on at the time.

## Jostle Parent: On Tasks and Goals and Shit Like That (n.d.)

So I’m at a point where you can, technically, take a shower, get up the kids, take them to get breakfast, take them outside to mow the lawn, and then take them outside.

Which means that I need to actually put in a structure for recognizing that the player has done these things.

Which means something like:

* Be able to know what the current task is
* Be able to display the current task to the user
* Be able to know when the current task is completed
* Be able to switch to the next task

One option is to have a specialist class that does task tracking. So it would, for example, be able to know what the task is and know when it’s done. BUT note that check when a task is done means needing access to the “stuff” in the world that would indicate that (like how long a player has been under the shower or how many kids have eaten food…) SO it can’t really be separate from the main game loop very successfully.

One option is “just” to have a set of ENUMS that one switches between one after the next and each one can be checked in a big switch that calls the appropriate task stuff. All in the same megafile. Which is a bit gross, but I also don’t entirely know how else to do it.

## Jostle Parent : Fresh Thoughts / Big Plans (17 July 2014)

The idea is to sit my ass down in this chair and make a plan of every single scene in the game (including inventing/cutting them as necessary) and to decide one what’s going to happen.

Point: the entire game can be viewed as a series of “levels” in which you practice the single mechanic of maintaining some objects (kids) in a safe zone while avoiding hazards (other people, etc.) and occasionally performing “special moves” (probably?)

**MECHANIC SEMANTICS**

Point: in what ways can one use the basic mechanics?

\* Jostle kids to a specific location

​     Table, bus

\* Jostle kids away from a specific location

​     “Lost”, water, road

\* Jostle something to/away from a specific location (avoiding the kids)

​     Lawnmower

\* Jostle something to the kids

​     Icecream

\* Jostle something away from the kids

​     Dog,

Some way of always having one “normal” task and one “death prevention” task to encourage split attention? Sending text messages?

**PRE-GAME**

Do we need some way of giving a narrative setting? E.g. that you’re a person who can only jostle etc.? That this is your special day of looking after the kids?

**THE GAME AS A SEQUENCE OF GOALS IN PLACES**

**GOAL: GET UP**

\* PLACE: Home / bedroom

\* ACTION: Just hit any of the movement keys to get out of the bed

\* TUTORIAL: This could tell you how to move around the room

\* TUTORIAL: Warning about home hazards (electrocution)

\* NEW CODE: ability to display GOAL TEXT

\* NEW CODE: ability to display TUTORIAL TEXT / DIALOG

**GOAL: SHOWER**

\* PLACE: Home / bedroom

\* ACTION: Walk into the shower and hard-jostle the shower on/off

\* TUTORIAL: This could be the tutorial bit for jostle/hard jostle



**GOAL: WAKE UP THE KIDS**

\* PLACE: Home / kids’ room

\* ACTION: Jostle their beds to get them up (hard jostle vs. soft?)

**GOAL: GET SOME BREAKFAST OUT OF THE FRIDGE**

**GOAL: FEED THE KIDS**

\* PLACE: Home / kitchen

\* ACTION: Jostle the fridge/cupboards to eject food

\* ACTION: Jostle the food to the kids or the kids to the food

\* ACTION: Take the kids to the back yard to play while you mow the lawn

\* **DANGER**: Choking

**GOAL: TAKE THE KIDS TO THE GARDEN**

**GOAL: MOW THE LAWN**

**GOAL: TAKE THE KIDS INSIDE**

\* PLACE: Home / back yard

\* ACTION: Jostle the lawnmower around until the lawn is mowed

\* ACTION: Get the kids back inside

\* **DANGER**: Pesticide

**GOAL: GET THE KIDS OUTSIDE**

\* PLACE: Home

\* ACTION: Jostle the kids to the front door

\* **DANGER**: Choking

**GOAL: GET THE KIDS ON THE BUS**

\* PLACE: Street

\* ACTION: Wait for the bus

\* ACTION: Jostle the kids to the doors

\* **DANGER**: Hit by car / bus

**GOAL: MAKE SURE THE KIDS DON’T WANDER OFF**

\* PLACE: Park / play area

\* ACTION: Jostle the kids away from the edges of the screen

\* **DANGER**: Lost and abducted

**GOAL: GO FOR A WALK**

**GOAL: KEEP THE DOG AWAY FROM YOUR CHILDREN UNTIL ITS OWNER COMES BACK**

\* PLACE: Walking path

\* ACTION: Jostle the dog away from the kids (who will move slowly away from it?)

\* **DANGER**: Dog gets a kid and mauls them to death

**GOAL: APPRECIATE THE VIEW**

\* PLACE: Cliff top

\* ACTION: Jostle the kids away from the edge of the cliff so they don’t fall to their death

\* **DANGER**: Death by falling

**GOAL: ENJOY THE POOLSIDE / BEACH**

**GOAL: MAKE SURE THE KIDS DON’T GO TOO DEEP**

\* PLACE: Swimming pool / beach

\* ACTION: Jostle the kids away from deep water

(Could be in a pool and just happens at times, so have to wade in and push them to a ladder before they drown - they could start thrashing. Maybe you should have another simultaneous task that gets points of some kind?)

\* **DANGER**: Drowning

**GOAL: GET THE KIDS INSIDE**

\* PLACE: Outside house after got off bus

\* ACTION: Jostle kids back to the front door

\* **DANGER**: Hit by car

**GOAL: MAKE THE KIDS DO THEIR HOMEWORK**

\* PLACE: Home / Living room / dining room

\* ACTION: Jostle kids to the table where they do homework

\* **DANGER**: Choking [from breakfast food on floor]

\* **DANGER**: Electrocution [Faulty wiring in socket]

**GOAL: GET DINNER FROM THE FRIDGE**

**GOAL: FEED THE KIDS DINNER**

**GOAL: STOP CHILD X FROM CHOKING**

\* PLACE: Kitchen / dining room

\* ACTION: Jostle the fridge for dinner

\* ACTION: Jostle the food to the kids or the kids to the food

\* ACTION: Hard jostle choking kid

\* **DANGER**: Choking

\* **DANGER**: Electrocution

**GOAL: PUT THE KIDS TO BED**

\* PLACE: Home / kids’ room

\* ACTION: Jostle the kids to their room

\* ACTION: Jostle the kids against their (correct) beds

\* **DANGER**: Choking

\* **DANGER**: Electrocution

**GOAL: GO TO BED**

\* PLACE: Home / bedroom

\* ACTION: Go to your room and go to the bed

**CURRENT DEATHS**

[Choking on toy in bedroom?]

[Eating pills in bathroom?]

Choking on food in kitchen

Eating pesticide in garden

Hit by car outside house

Lost in park

Mauled by dog

Drowned in pool / at beach

Electrocuted in living room

[Falling off… what?]

**CURRENT PLACES**

Bedroom

Hallway

kids’ room

Main bathroom

Kitchen/living room

Back yard

Front yard/street

Park

Path

Cliff(?)

Pool/beach

**SUMMARY OF KEY ACTIVITIES**

Mow the lawn (don’t hit the kids)

Get the kids on the bus (don’t let them get hit by a car)

Enjoy the park (don’t let the kids wander off) [Timer]

<Something about drowning>

<Something about shopping>

Keep the kids away from the fire

Put the kids to bed

JOSTLE KIDS AWAY FROM X

JOSTLE KIDS TOWARD X

JOSTLE X AWAY FROM KIDS

JOSTLE X TOWARD KIDS

JOSTLE X AWAY FROM Y

JOSTLE X TOWARDS Y

JOSTLE X [to cause something to happen]

## Jostle Parent Dev Todos (25 September 2014)

**Uh,**

I’m more than a little perplexed at the moment because I’m really quite sure that I had written an updated todo list quite recently, just before going to Cologne, and now it just doesn’t seem to exist at all. So I’m going to do it again because I had quite a tidy little list of things to do all nicely laid out. I’ll do it again.

**Task UI**

\* ~~Add general ability to display a task at top-right (or somewhere) in white on black background (sized according to length of the text, look at other games for reminders on how to do this).~~

\* ~~Add indication of a task being completed (e.g. crossed out, a tick, something)~~

\* ~~Add tweening-in and out of tasks (slide in from side, say)~~

**Tutorial UI**

\* ~~Add general ability to display a tutorial element bottom-left (or somewhere) in white on black background (sized according to length of the text)~~

\* ~~Add fade-out of a tutorial element that has been “succeeded” at.~~

\* ~~Think about how you trigger and dismiss tutorial elements~~

**Danger UI**

\* ~~Make the word appear in white on black box centred above the child’s head and flashing~~

**Interactions with children**

\* ~~Add a knocked-down frame to child sheet~~

\* ~~Add a “waving for attention” frame to child sheet~~

\* ~~Hard-jostle always knocks a child down~~

\* Knock-down always has a (pretty high) chance of killing child (with the exception of the first time, when you can’t kill them) and otherwise they get up

\* (Killing a child sends you to jail.)

\* Make choking quite unlikely (it’s the one thing you can’t prevent)

\* Make them freeze to the spot if electrocuting? (electrocuting has been a bit of a pain so far.)



**Shower**

\* ~~Fix it so that shower stays on for a while after first jostle~~

**OMG**

\* Remember you need variable checks for numbers of children

**Thing**: Sketching further scenes for the game outside.

## Jostle Parent Development List (2014-10-10)

**Interactions with children**

\* ~~Knock-down always has a (pretty high) chance of killing child (with the exception of the first time, when you can’t kill them) and otherwise they get up~~

\* ~~Make them freeze to the spot if electrocuting? (electrocuting has been a bit of a pain so far.)~~

\* ~~Work out how to make them mobile again post hit, because right now it crashes for some reason~~

\* ~~Make choking quite unlikely (it’s the one thing you can’t prevent)~~

\* ~~Alternating the children between aimless wandering and following, so that there’s more of a personality?~~

 ~~(Also weird that you have to knock them *into* something to knock them down, though maybe that’s okay - allows for the risk of sweeping them around at speed)~~

\* Killing a child sends you to jail.

   \* ~~Get jail from Jostle Bastard~~

   \* ~~Implement jail~~

   \* ~~Implement kill child->jail~~

\* Play around with making knockdowns FEEL a bit more interesting?… right now they feel quite “light” perhaps?

**Child death**

\* ~~Implement some kind of state or other way for the game to notice child death and transition~~

\* ~~Fade out the screen (actually we can go to a brand new state because we don’t need to worry about remaking the world - oh except for the mess… so maybe we do… think about this) - need another group that can sit on top of everything for fade-outs and ins.~~

\* ~~Sketch graveside~~

\* ~~Implement basic graveside~~

\* ~~Handle multiple child deaths? I guess you can check if there are any “mortal threats” in action on one child’s death and only resolve death when they’re all done. (But could this lead to all children dying at once?!)~~

\* ~~Display text about how the child died (means writing their reason for death somewhere)~~

\* ~~Implement number of gravestones based on number of dead kids (requires death implementation)~~

\* ~~Implement ability to leave (have the kids follow you)~~

\* Restart the game (but keep the mess!)

**Child state**

\* ~~It’s getting too complicated. Think about how to track and display state more nicelier. The “obvious” thing would be a prioritized list of problems - e.g. electrocution supersedes hungry. But once the electrocution stopped they’re hungry again? (That would need to be in the update loop? Ugh.)~~

**Overall control**

\* Remember you need variable checks for numbers of children

**Menu**

\* ~~Make the menu come up after you leave the graveyard~~

\* Make a menu that lets you play (really it would only ever have “NEW GAME” and “CONTINUE”? and a title

**Save states**

\* Oh god do we need to be able to save everything like

   \* Number of children dead?

   \* Physical state of all rooms/objects?

   \* Where the player was up to in the task list?

   \* State of the children (maybe not, just reset to task default?)

   \* (Maybe it’s not so bad? It’s also something to add AT THE END)

**More**

\* ~~Add y-sorting~~

\* ~~Create a superclass for sorting (e.g. PhysicsSprite to inherit from it and any other FlxSprites, because we need to sort by hit y for physics sprites and not sprite y)~~

\* ~~Sketching further scenes for the game outside.~~

## Jostle Parent More Thoughts (7 August 2014)

So I said to myself that once I had “built out” the apartment rooms and implemented teleportation between rooms (in principle) I would then lean back in my chair and think about what needs to be done next in order to continue the game At A Good Clip.

~~**Thing**: An obvious thing is to add the rest of the doors to the apartment now that it actually clearly works.~~

~~**Thing**: Add kids to the kids room and allow them to wander around but not allow them to go through doors at will. (This actually sounds a bit complex I’m now realizing?! Like how do you stop them from leaving when they walk around randomly?) (And if you let them leave it seems like it could be super easy for them to die while unsupervised?!!!! Or is that okay?) (First implementation is, I guess, that they just pass through doors normally.)~~

~~**Thing**: Contemplate the issue of how to get kids through doors - push only would kind of make sense, in which case need to reimplement the concept of having been pushed. And have doors check whether the kid was pushed into them or just walked into them and respond appropriately… hm.~~

~~**Thing**: What should kids do when they’ve moved through a door? Just wait on the other side? Seems to me they should just continue on - like, you shouldn’t just let the kid wander off and it’s not going to WAIT for you, except in very special circumstances? Like maybe the transition to the outside? But even then… look after your kids!!~~

~~**Thing**: Be able to shepherd the kids around the house successfully.~~

~~**Thing**: Work out how to implement lawn mowing - mostly a question of laying FlxSprites over the lawn that can then be removed by the lawnmower when it overlaps them.~~

~~**Thing**: Make the lawn nice (what the fuck about the kids wandering back into the house while you’re outside? Guess you can just consider the door “locked”?~~

~~**Thing**: Maybe change kids to stay still for a while after you impact them… some random timer amount so that you can manage them a bit better, like they “go limp” for a bit. Don’t explain, maybe, this is just behaviour they exhibit… they could also have personalities… one a bit more adventurous etc.~~

~~**Thing**: Implement the whole “container” idea for some objects such that they can emit “things” into the scene when jostled hard enough. (Is this literally only the fridge?)~~

~~**Thing**: Implement an “impatient” stage for the kids before they start walking around again.~~

~~**Thing**: Implement “get the kids out of bed” through a hard jostle (similar to the container thing now I think about it, but it can be separate).~~

~~**Thing**: Implement kids “eating” food if it knocks into them (but not if they knock into it? (or both?))~~

~~**Thing**: Figure out why children no longer go through doors apparently!! WTF?~~

~~**Thing**: Need some kind of “task” subsystem that tracks when you’ve done “things”? Just an ENUM of tasks needed? Or… what?~~

~~**Thing**: Implement the game noticing when you’ve taken a shower.~~

~~**Thing**: Implement the game noticing when the kids are out of bed.~~

~~**Thing**: Implement the game noticing when all the grass has been mowed.~~

~~**Thing**: Implementing the concept of goals/tasks that can be active and that can be detected as having been completed by the jostler.~~

~~**Thing**: Implement the game noticing when the kids have been fed.~~

~~**Thing**: Implement the game knowing when people are in a particular room~~

~~**Thing**: Implementing indicating the current task for the parent~~

~~**Thing**: Implement garden door being “locked” until you finished mowing the lawn.~~

~~**Thing**: Implement front door being “locked” until it’s time to actually go out.~~

~~**Thing**: Implement hunger as an alpha value!!~~

~~**Thing**: Implement possible choking by a kid (plus ability to jostle them and “dislodge” the food.~~

~~**Thing**: Implement electrocution in terms of timers etc. (Think about smarter ways to handle multiple timers [e.g. electrocution while choking?!])~~

~~**Thing**: Implement a basic notification box above children’s heads that tells you about their choking, electrocution, etc.~~

**Thing**: Implementing ability to kill children if you slam them too much… warning about it first few times, then it starts to injure them. Maybe count some number of hard jostles over set time periods? Or maybe even just if you hard jostle them they fall down? (But what about choking?) And should children be hard to shift when electrocuting? E.g. need to jostle them then?

**Thing**: Sketching further scenes for the game outside.

**UNSOLVED AND MAYBE UNSOLVABLE AND MAYBE FUCK IT**

**Thing**: What happens when someone blocks a door with some piece of furniture that then won’t move? Which is totally possible by the way. **Fuck**.

**Same Thing**: Lawnmower can totally get completely stuck in the corner, really unclear on how to fix that problem because it’s the same thing as the furniture problem. Needs a solution.

**Idea**: Destructible furniture that breaks apart with enough hard jostles applied to it. If it can move, it should be destructible, basically. Conceptually speaking, it’s fair for him to get stuck behind a couch in front of a door because all he can do is jostle it (push it). Need to specify some number of particles. Need to have particles specific to different colour types.

**But**: This idea won’t work for the lawnmower…

**Thing**: Will it be possible to not be able to get a kid out of a room because you can get past them because of furniture etc.??!?!?!?!?!?!? Will destructible furniture fix this? What about if they go into the bathroom and won’t come out? Not much room in there… stupid fucking dynamic systems.

**Thing**: Thinking about that idea of goals like “tidy up” and so on, the concept of impossible tasks and what that would mean, or whether those are really needed because it’s just kind of obvious already that it’s a mess and it would be enough that the mess is still there when you return home? Yeah I mean, I’m kind of thinking about dropping everything like that, because it can just be “shown” by the game and does need to be interfaced...

## Jostle Parent Physics Problems (19 August 2014)

There are physics problems.

Specifically it is possible to “wedge” objects against walls (and each other) such that they’re perfectly aligned and can no longer be “bounced” off that surface. Which is fucking annoying when it happens, even though it’s not the “point” of the game. Some of it is fixed by reducing/removing friction and thus letting you “drag” objects by sliding along them with the jostler bastard.

But there are two major problems still:

1/ It’s possible to block a doorway such that it’s either impossible to free up or such that it would take forever with fiddly movements to free up. Meaning you can get stuck in a room or can prevent access to a room you need to get into for the game.

2/ It’s possible to wedge a key item like the lawnmower in a corner and thus no longer be able to use it easily, making it impossible to complete a goal for instance.

“Solutions”

1/ See if there is some way to make furniture always repel from walls and each other such that they would never be perfectly aligned. I have some suspicion that this isn’t possible and even that it’s somehow reducible to exactly the same problem anyway.

2/ Fix all the furniture in place so that it never moves. This may be annoying in terms of navigation and perhaps worse it doesn’t allow for “mess” which is a sort of central part of the idea of the game - that there’s entropy and things devolve into a more and more chaotic state, reflecting your abilities as a parent, particularly in the home.

3/ Don’t give a shit and if someone manages to seal themselves in a room or “lose” the lawnmower then fuck ‘em. I want to believe this is okay and that I could maybe tweak the “weight” of objects and so on sufficiently that this wouldn’t come up at random, but I just don’t know. Like maybe if everything is heavy enough that you *can* mess it up, but it would be an effort to block the doors rather than something that happens easily by mistake? And then rely on things like the food on the floor or toys on the floor in the bedroom as ways to mess up the house without causing so much trouble?

 Further to all this, moving the children themselves around is similarly painful because of the physics and furniture and room shapes because it’s possible for them to go into places that you basically then can’t get them out of properly, which is insanely annoying. The point of the game is of course meant to be somewhat annoying, but I’m worried that it’s SO annoying that it won’t actually make its point.

**FOR NOW**

Make the furniture heavy (especially anything that can manage to block the door “easily”. Then fix the child “AI” so that they’re less fucking annoying. And so that if you bump them they stay put for some amount of time. Also see what it’s like to vary their speed a bit sometimes? Like the “run” sometimes? Also why do they fucking walk into things? Fuck you, children, fuck you.

What if the children moved with you within reason while in your “area”? Or would that.. no I think that would make them annoying in a bad way. Okay forget I said that.

## Jostle Parent Development List (21 October 2014)

Interactions with children
* ~~BUG: Kids don’t seem to pause on contact anymore~~
* Play around with making knockdowns FEEL a bit more interesting? (Right now they feel quite “light” perhaps? Restitution?)

Child death
* Restart the game (but keep the mess!)

Child state

Overall control
* Remember you need variable checks for numbers of children

States
* ~~Get the basic idea of being able to “restart” the game going (e.g. just so it doesn’t explode)~~
* Get the idea of a restart that incorporates saved states

Main Menu
* ~~Make a menu that lets you play (really it would only ever have “NEW GAME” and “CONTINUE”? and a title~~


Save states
* Set up saving to FlxG.save (looks relatively “easy”…)

More
* Sketching further scenes for the game outside.
