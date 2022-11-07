//
//  PlaylistText.swift
//  Pumpy Playlist ManagerTests
//
//  Created by Jack Vanderpump on 30/10/2022.
//

import Foundation

struct PlaylistTextHelper {
    
    let mock =
"""
Dancing in the street - Martha Reeves and the Vandellas
Do you love me - the contours
how will i know - whitney houston
i wanna dance with somebody - whitney houston
all night long  - lionel richie
i want you back - jackson 5
aint no mountain high enough - marvin gaye and tammi tyrell
escape (the pina colada song) - rupert holmes
heard it through the grapevine - marvin gaye
billie jean - michael jackson
beat it - michael jackson
jump - van halen
hungry like the wolf - duran duran
like a prayer - madonna
all star - smashmouth
steal my sunshine - LEN
i want it that way - backstreet boys
juicy - notorious BIG
little less converstaion - elvis
hey ya - outkast
crazy in love - beyonce
take me out - franz ferdinand
toxic - britney
shake it off - taylor swift
freedom - george michael
faith - george michael
walk like an egyptioan - the bangles
africa - toto
lets hear it for the boy - derice williams
dr beat - miami sound machine
loco down in acapulco - 4 tops
footloose - kenny loggins
dead ringer for love - meatloaf and cher
jump - kriss kross
regulate - nate dogg and warren g
mama said knock you out - ll cool j
nuthin but a g thang - snoop and dre
gin and juice - snoop dogg
summertime - will smith
miami - will smith
opp - naughty by nature
still dre - dr dre
creep - tlc
say my name - destinys child
cruel summer - bananrama
round round - sugababes
s&m  - Rihanna
cheers - rihanna
raise your glass - pink
get the party started - Pink
candyman - xtina
genie in a bottle - xtina
whenever wherever - shakira
hips dont lie - shakira
london bridge - fergie
rockstar - nickelback
glamorous - fergie
ridin solo - jason derulo
get ugly - jason derulo
cooler than me - mike posner
drive by - train
too close - alex
teenage dream - katy perry
starstrukk - 3OH3
the boy does nothing - alesha dixon
starry eyed - ellie goulding
grace kelly - mika
classic - mkto
party in the usa - miley
thats what i want - lil nas x
superbass - nicki minaj
chasing high - alma
body - loud luxury
Trumpets - jason derulo
down with the trumpets - rizzle kicks
mama do the hump - rizzle kicks
fill me in - craig david
7 days - craig david
walking away - craig david
rendezvous - craig david
LDN - lily allen
lady gaga - poker face
i dont feel like dancin - scissor sisters
911 - sean kingston
break your heart - tao cruz
what did you say - jason derulo
valerie - amy whinehouse
one love - blue
about you now - sugababes
these words - natasha bedingfield
sound of the underground - girls aloud
carry out - justin timberlake ft timbaland
rehab - amy winehouse
SOS - Rihanna
Crazy - Gnarles Berkley
buttons - PCD
when i grow up - PCD
heaven takes you home - SHM
Ferrari - james hype
fast lane - bad meets evil
no diggity - blackstreet
mo money mo problems - notorious BIG
doo wop that thing - lauryn hill
heartbreaker - mariah carey
gravel pit - wutang clan
electric avenue - refugee cvamp all stars ft Praz
murder she wrote - chakademus and pliers
perfect gentleman - wyclef jean
u remind me - usher
bootylicious - destinys child
good luck - basement jaxx
lady marmalade - xtina, mya, pink, missy elliot
family affair mary j blige
i kissed a girl - katy perry
california gurls - katy perry
sex bomb - tom jones
teenage dirtbag - weezer
moves like jagger - maroon 5
thrift shop - mackelmore
rude! - Magic
everybody - backstreet boys
ugly heart - GRL
cheerleader - omi
uptown funk - bruno mars
cant stop the feeling - justin timberlake
i like it - cardi b
superstar - jamelia
all about tonight - pixie lott
higher - saturdays
horny - mouse t vs hot n juicy
crazy stupid love - cheryl cole
keep on movin - 5
replay - iyaz
spinning around - kylie
holiday - dizzee rascal
dance with me - dizee rascal
ooh wee - Mark ronson ft ghostface killa
"""
    
    let smallMock =
"""
Dancing in the street - Martha Reeves and the Vandellas
Do you love me - the contours
how will i know - whitney houston
"""
    
    let smallMockAfterEdit =
"""
Dancing in the street - Martha Reeves and the Vandellas
Do you love me
how will i know - whitney houston
"""
   
    let mockAfterEdit =
"""
Dancing in the street - Martha Reeves and the Vandellas
Do you love me
how will i know - whitney houston
i wanna dance with somebody - whitney houston
all night long  - lionel richie
i want you back - jackson 5
aint no mountain high enough - marvin gaye and tammi tyrell
escape (the pina colada song) - rupert holmes
heard it through the grapevine - marvin gaye
billie jean - michael jackson
beat it - michael jackson
jump - van halen
hungry like the wolf - duran duran
like a prayer - madonna
all star - smashmouth
steal my sunshine - LEN
i want it that way - backstreet boys
juicy - notorious BIG
little less converstaion - elvis
hey ya - outkast
crazy in love - beyonce
take me out - franz ferdinand
toxic - britney
shake it off - taylor swift
freedom - george michael
faith - george michael
walk like an egyptioan - the bangles
africa - toto
lets hear it for the boy - derice williams
dr beat - miami sound machine
loco down in acapulco - 4 tops
footloose - kenny loggins
dead ringer for love - meatloaf and cher
jump - kriss kross
regulate - nate dogg and warren g
mama said knock you out - ll cool j
nuthin but a g thang - snoop and dre
gin and juice - snoop dogg
summertime - will smith
miami - will smith
opp - naughty by nature
still dre - dr dre
creep - tlc
say my name - destinys child
cruel summer - bananrama
round round - sugababes
s&m  - Rihanna
cheers - rihanna
raise your glass - pink
get the party started - Pink
candyman - xtina
genie in a bottle - xtina
whenever wherever - shakira
hips dont lie - shakira
london bridge - fergie
rockstar - nickelback
glamorous - fergie
ridin solo - jason derulo
get ugly - jason derulo
cooler than me - mike posner
drive by - train
too close - alex
teenage dream - katy perry
starstrukk - 3OH3
the boy does nothing - alesha dixon
starry eyed - ellie goulding
grace kelly - mika
classic - mkto
party in the usa - miley
thats what i want - lil nas x
superbass - nicki minaj
chasing high - alma
body - loud luxury
Trumpets - jason derulo
down with the trumpets - rizzle kicks
mama do the hump - rizzle kicks
fill me in - craig david
7 days - craig david
walking away - craig david
rendezvous - craig david
LDN - lily allen
lady gaga - poker face
i dont feel like dancin - scissor sisters
911 - sean kingston
break your heart - tao cruz
what did you say - jason derulo
valerie - amy whinehouse
one love - blue
about you now - sugababes
these words - natasha bedingfield
sound of the underground - girls aloud
carry out - justin timberlake ft timbaland
rehab - amy winehouse
SOS - Rihanna
Crazy - Gnarles Berkley
buttons - PCD
when i grow up - PCD
heaven takes you home - SHM
Ferrari - james hype
fast lane - bad meets evil
no diggity - blackstreet
mo money mo problems - notorious BIG
doo wop that thing - lauryn hill
heartbreaker - mariah carey
gravel pit - wutang clan
electric avenue - refugee cvamp all stars ft Praz
murder she wrote - chakademus and pliers
perfect gentleman - wyclef jean
u remind me - usher
bootylicious - destinys child
good luck - basement jaxx
lady marmalade - xtina, mya, pink, missy elliot
family affair mary j blige
i kissed a girl - katy perry
california gurls - katy perry
sex bomb - tom jones
teenage dirtbag - weezer
moves like jagger - maroon 5
thrift shop - mackelmore
rude! - Magic
everybody - backstreet boys
ugly heart - GRL
cheerleader - omi
uptown funk - bruno mars
cant stop the feeling - justin timberlake
i like it - cardi b
superstar - jamelia
all about tonight - pixie lott
higher - saturdays
horny - mouse t vs hot n juicy
crazy stupid love - cheryl cole
keep on movin - 5
replay - iyaz
spinning around - kylie
holiday - dizzee rascal
dance with me - dizee rascal
ooh wee - Mark ronson ft ghostface killa
"""
}
