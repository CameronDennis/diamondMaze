# diamondMaze
diamondMaze is a program that allows you to navigate through a maze using wasd controls. The walls act as blockers as well as the bounds of the program. Upon finishing the maze, it will restart, allowing you to go again.

To run this program, download the files rain.asm, p3os.asm, and PennSim.jar into their own directory (folder). Run PennSim. 
In the top text box beneath the buttons "Next, Continue...", enter the following commands:

`as p3os.asm`

`as diamond.asm`

`ld p3os.obj`

`ld diamond.obj`

After you've entered these commands, press the continue button at the top, then click inside of the white box under the large black box on the bottom left. This is the interface for sending text to the program. You may then interact with the program.

The commands you can use to interact with the program are as follows:

Keys | Function
---- | ----
r | changes the color of the diamond to red
g | changes the color of the diamond to green
b | changes the color of the diamond to blue
y | changes the color of the diamond to yellow
space | changes the color of the diamond to white
w | moves the diamond up two pixels
a | moves the diamond right two pixels
s | moves the diamond down two pixels
d | moves the diamond right two pixels
q | stops the simulation
