import json
import csv

# replace path with location of the MTGJSON file on your computer
mtgjson = 'c:/Users/Andrew/Documents/Python Scripts/CardParse/AllSets.json' 
# replace output path with desired output location and name
outputname = 'c:/Users/Andrew/Documents/Python Scripts/CardParse/allcards.txt'

def cardsort(cardfile,set,card):
# cardsort inspects a card to determine the name, artist, color,
# print date, and set
    try:     
# check the card type first
       cardtype = cardfile[set]['cards'][card]['types']
# if it's not a land, we have to determine its color
       if cardtype != [u'Land']:
            try:
                cardcolor = cardfile[set]['cards'][card]['colors']
# colors is a list, if it has more than one element, the card is multicolored
                if len(cardcolor) >= 2:
                    cardcolor = 'Multi'
                else:
# if it has just one color, convert the Unicode to ASCII
                    cardcolor = cardcolor[0].encode('ascii','ignore') 
# if there's an error, it implies a colorless card
            except KeyError:
                cardcolor = 'Colorless'
       else:
# if it's a land, label it as such
            cardcolor = 'Land'
# generate the relevant outputs
       cardname = cardfile[set]['cards'][card]['name']    
       carddate = cardfile[set]['releaseDate']
       artist = cardfile[set]['cards'][card]['artist']
       cardset = cardfile[set]['name']
# one card in the database doesn't play nice, and I remove it
    except KeyError:
       cardname = 'Error'
       artist = 'Error'
       cardcolor = 'Error'        
       carddate = '1900-01-01'
       cardset = 'Error'
    return cardname, artist, cardcolor, carddate, cardset


allsets = json.load(open(mtgjson))
with open(outputname,'w') as csvfile:
    fieldnames= ['cardname', 'artist', 'color', 'date', 'set']
    writer = csv.DictWriter(csvfile, delimiter = '\t', 
        lineterminator='\n', fieldnames = fieldnames)
    writer.writeheader()
# loop through sets and cards, writing out the requested card attributes
    for set in allsets:
        totalcards = len(allsets[set]['cards'])
        for card in range(totalcards):
            cardname, artist, cardcolor, carddate, cardset = cardsort(allsets,
                                                                      set,card)
            writer.writerow({'cardname' : cardname, 'artist': artist,
                             'color' : cardcolor, 'date': carddate,
                             'set' : cardset})
