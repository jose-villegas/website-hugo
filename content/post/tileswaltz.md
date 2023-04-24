---
title: "Tile's Waltz - Quarantine Project"
date: 2020-06-22T18:03:51-04:00
showonlyimage: true
draft: false
categories: ["Games"]
tags: ["unity", "games", "csharp"]
image: "https://res.cloudinary.com/jose-villegas/image/upload/v1599493070/WebPage/mess.png"
---

Tile's Waltz is a game I started developing alone during quarantine for the COVID-19 crisis. It's a match-3 puzzle game with focus on memorization, you remove pieces from the level, when that piece is removed other pieces move to take their place, you need to combine pieces of the same color to get combos or power ups.
<!--more-->

The idea for the game came to me while I was watching a wristband my mom bought me long ago, a bit of quarantine boredom basically, this wristband is made of little pieces that look like the tiles in the game. So I started to imagine what kind of game I could make with this shape. 

<table class="table">
<thead>
<tr>
</tr>
</thead>
<tbody>
<tr>
<td align="center"><img src="https://res.cloudinary.com/jose-villegas/image/upload/v1608681898/IMG_20201222_210227_2_hcmmgk.jpg" alt="alt text" width="300"></td>
</tr>
</tbody>
</table>

I was itching to come up with a game idea since I wanted to practice some Unity frameworks, so once I got the core gameplay draft written I started developing the game.

In Tile's Waltz you play in a isometric perspective environment with a level made of tiles that are interconnected with each other, verticality is added through the tiles orientation, a tile can be connected to another in the four cardinal directions, but when connected I can also be oriented as going up, down or just staying plain. As seen here: 

<table class="table">
<thead>
<tr>
</tr>
</thead>
<tbody>
<tr>
<td align="center"><img src="https://res.cloudinary.com/jose-villegas/image/upload/v1595457147/WebPage/tt.png" style="width: 300px;"/></td>
</tr>
</tbody>
</table>

When you remove a tile from the structure by pressing on it, the structure needs to "fill" that space again. For this the shortest path algorithm is used, when a tile is removed the shortest path to a "leaf" tile is found, a "leaf" tile is a tile that only has one connection. The tiles in this path will move to take the place of the removed tile, the first in the path will take the place of the removed, the second will take the place of the first, the third will take the place of the second and so on; and for the last position a new tile is added. This ends with a lot of possible combinations and ways to move tiles around in a level.

<table class="table">
<thead>
<tr>
</tr>
</thead>
<tbody>
<tr>
<td align="center">
    <video width="100%" autoplay loop>
    <source src="https://res.cloudinary.com/jose-villegas/video/upload/v1627428464/WebPage/summary.webm" type="video/webm">
    Your browser does not support the video tag.
    </video>
</td>
</tr>
</tbody>
</table>

## Power Ups

* Combine 4 in a straight line:

If you combine 4 in a straight line you get a directional power in the orthogonal direction of that line, when the tile with this power up is clicked, all the tiles in that direction will be removed. It's important to position properly the tile to make the best use of this power.

<table class="table">
<thead>
<tr>
</tr>
</thead>
<tbody>
<tr>
<td align="center"><img src="https://res.cloudinary.com/jose-villegas/image/upload/v1627428035/WebPage/dir1.gif" alt="alt text" width="200"></td>
</tr>
</tbody>
</table>

* Combine 5 or more tiles:

If you combine 5 of more tiles you get a color power up, when you click the tile with this power up it will the remove all the tiles that have this same color, it's important to look at the map to make the best use of it.

<table class="table">
<thead>
<tr>
</tr>
</thead>
<tbody>
<tr>
<td align="center"><img src="https://res.cloudinary.com/jose-villegas/image/upload/v1627428035/WebPage/color1.gif" alt="alt text" width="300"></td>
</tr>
</tbody>
</table>

## Level Editor

You can make your own levels in this game, it provides a level editor that lets you make your own levels. You can also share your levels with other users, as the levels are converted to a code that can be imported in the game, another option is to use QR codes, the game can read a QR code with the map information and import that map.

<table class="table">
<thead>
<tr>
</tr>
</thead>
<tbody>
<tr>
<td align="center"><img src="https://res.cloudinary.com/jose-villegas/image/upload/v1627428035/WebPage/build1.gif" alt="alt text" width="300"></td>
</tr>
</tbody>
</table>

## Content

{{< youtube _tPDQQVZXuU>}}

The game currently contains:

* 13 playable maps.
* Two Power ups for Bigger Combos.
* Level Editor
* Sharing and Importing through Text or QR
* Basic Tutorial
* Spanish and English Localization
* GPGPS integration and Cloud Save

## In Progress

I have taken this as a little hobby project, there are some future improvements and updates I hope to make in the future.