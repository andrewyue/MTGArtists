# MTGArtists
Python script and R commands used to pull out select information, scrub redundancies, and plot information about Magic the Gathering card artists.

The <a href="http://mtgjson.com">MTGJSON</a> database contains essentailly all relevant information about every Magic the Gathering card printed up through Modern Masters 2015.  The CardParse script was written to pull the card name, color/type (e.g. Land, Red, Colorless, etc.) artist, set, and print date from this database.  The information was used to determine the most prolific card artists, and any color/type tendencies in their commissions.

Card artwork was often reused between card sets (especially basic lands), and, where algorithmically possible, it was removed for this study. The R file MTGArtists takes the raw output and performs several reductions:
<ol>
<li>Determines basic land cards (e.g. Forest).</li>
<li>Determines non-basic land duplicates by looking for repeated combinations of card name and card artist.</li>
<li>Determines the combined set of all basic lands and unique non-land cards.
<li>Identifies known duplicate basic lands (e.g. Beta, Unlimited, Revised, 4th ed. are all reprints of the Alpha lands).</li>
<li>Determines the set of "unique" cards by removing the known duplicate basic lands.</li>
</ol>

There exist additional basic land reprints (e.g. <a href="http://magiccards.info/m10/en/231.html">Plains #231 in Magic 2010</a> and <a href="http://magiccards.info/m11/en/230.html">Plains #230 in Magic 2011</a>) that must be removed by hand.  This feature is not currently added to the code posted here.
