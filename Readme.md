<h1>Overview</h1>
The game contract for making your own unique cocktails.

<h1>Requirement Description</h1>
1. Players can bartend to get a random cocktail at the first visit.<br>
2. Players must collect five stars to get an another random cocktail by making a toast.<br>
3. Players can make a toast with a number which they picked.<br>
4. The picked number to bartend must be minimum 1 and maximum 100.<br>

<h1>Development Environment</h1>
- MacOS Mojave 10.14.2
- Remix - solidity IDE
- Pragma solidity 0.5.0

<h1>Methods</h1>
<pre><code>
event NewCocktail(uint id, string name);
</code></pre>