# MTGArtists
Python and R scripts used to pull out select information, scrub redundancies, and plot information about Magic the Gathering card artists.

The <a href="http://mtgjson.com">MTGJSON</a> database contains essentially all relevant information about every Magic the Gathering card printed up through Modern Masters 2015.  The CardParse script was written to pull the card name, color/type (e.g. Land, Red, Colorless, etc.) artist, set, and print date from this database.  The information was used to determine the most prolific card artists, and any color/type tendencies in their commissions.

Card artwork was often reused between card sets (especially basic lands), and, where algorithmically possible, it was removed for this study. The R script MTGArtists takes the raw output and performs several reductions:
<ol>
<li>Determines basic land cards (e.g. Forest).</li>
<li>Determines non-basic land duplicates by looking for repeated combinations of card name and card artist.</li>
<li>Determines the combined set of all basic lands and unique non-land cards.</li>
<li>Identifies known duplicate basic lands (e.g. Beta, Unlimited, Revised, 4th ed. are all reprints of the Alpha lands).</li>
<li>Determines the set of "unique" cards by removing the known duplicate basic lands.</li>
</ol>

There exist additional basic land reprints (e.g. <a href="http://magiccards.info/m10/en/231.html">Plains #231 in Magic 2010</a> and <a href="http://magiccards.info/m11/en/230.html">Plains #230 in Magic 2011</a>) that must be removed by hand.  This feature is not currently added to the code posted here.

The R script outputs two plots.  The top plot is a stacked bar graph that allows for comparisons between the total pieces of art each artist created, with additional absolute information in the color/type breakdown.  In the bottom plot, the color/type breakdown for each artist is shown relative to their total volume of work.  This allows the viewer to quickly determine if an artist is, for example, more frequently chosen to create art for land cards.

The plot generated can be seen below.  The font used for all labels is MPlantin, which can be found at any number of font websites.

<img src="http://i.imgur.com/fnOY1ZG.jpg">
