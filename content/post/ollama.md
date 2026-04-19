---
title: "Ollama - A Game In Just A Week"
date: 2017-05-02T00:00:00+02:00
showonlyimage: true
draft: false
categories: ["Games"]
tags: ["unity", "games", "csharp"]
image: "https://res.cloudinary.com/jose-villegas/image/upload/v1731416002/68747470733a2f2f692e696d6775722e636f6d2f4e6745337962662e706e67_i3wlsd.png"
---

For this instance I was asked to create a game, alone, in a single week as part of a test. I ended up making an isometric platform game, you have to complete levels and collect coins along the way. 
<!--more-->

# Overview

In Ollama you play as a ball in an isometric world, you have to get to certain point and try to collect all the coins in a level avoiding all sorts of obstacles.

As a programmer getting art right can be hard so I tried to keep the style simple, the colors more pastel, and the character is just a ball. 

While I'm no artist I did have a short introduction course on Graphic Design when I was a teenager, to this day some of the things I learned there, I still apply today. The game still pretty much programmer-art but I think it is not-so-bad looking.

The world is filled with enemies that will shot at the player when he is in range. Ollama has multiple abilities. It has the ability to squeeze itself in tight spots, you need to use this ability to get past certain areas and avoid the enemies, by pressing down the ball compresses. Ollama can also attack by jumping and pressing down to create a shoc-kwave that will knock out the enemies, the higher the jump the greater the shoc-kwave. And last Ollama can float, when you enter floating mode the ball will keep going up until you deflate, you combine this with Ollama's attack to create a really powerful shoc-kwave.

The player movement is also bound to the orientation of the world, the player only moves in two axis, horizontal and vertical, you need to rotate the world so the player can move in a rotated horizontal axis.

The game was made with Unity 5.5.3 at the time so it's quite old. But the source code can be found on my GitHub [here](https://github.com/jose-villegas/1week-game):

Some screenshots of the game:

<img src="https://res.cloudinary.com/jose-villegas/image/upload/v1595364395/WebPage/intro.gif" style="width: 100%;"/>

Creating a shockwave
<img src="https://res.cloudinary.com/jose-villegas/image/upload/v1595365108/WebPage/shock.gif" style="width: 100%;"/>

Floating
<img src="https://res.cloudinary.com/jose-villegas/image/upload/v1595364725/WebPage/floating.gif" style="width: 100%;"/>

Squeezing
<img src="https://res.cloudinary.com/jose-villegas/image/upload/v1595365054/WebPage/squeeze.gif" style="width: 100%;"/>

