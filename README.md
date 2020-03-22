# RogueMine
Roguelike x Minesweeper

__Random generated grids added. Press space to generate a new grid.__

Build 5: https://tehandrew.github.io/RogueMine/

## Todo list
- ~Before grid class~
  - ~Grid objects should be childnodes of grid nodes instead of the grid.~
- ~Make player movable in the grid~
- ~Create a tileset for the nodes two states, covered and uncovered.~
- ~Grid generation~
  1. ~Create grid generator that can generate empty grids with just a player in them~
  2. ~Generate mines~
  3. ~Prepare Grid and Grid generation for the algorithm below~
  4. ~Create the node uncover algorithm (bfs)~ dfs was used instead
- ~Create basic level generator~
  1. ~Random mine placement~
  2. ~Random character placement~
- Make mine count resizable
- Create basic gameplay
  1. Player dies in contact with mines
  2. Can generate new maps during gameplay
  
## Fix list 
- ~Sprite should only be resized one time, not at every place_object~
- ~Solve sub scene object creation problem for code consistency~
- Clean up Grid class
