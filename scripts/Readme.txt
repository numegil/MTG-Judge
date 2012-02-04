To Update Oracle text:

1) Fill in "base_url" variable in Download.java (I can't include it for legal reasons)
2) Compile all .java files
3) run "java Download > spoiler.txt" from command prompt (this will take a minute or two to run)
4) run "java Convert"
5) manually fix everything listed below


To Fix after Convert.java is done:

Replace all instances of — with -
Replace all instances of á with a
Replace all instances of Æ with Ae
Replace all instances of o with o

Fix Individual Cards:

1) Delete "Ach! Hans! Run!" and "___________" (from oracle_0 and namesonly only)
2) Look at top AND bottom of each array file and fix all cards that are out of alphabetical order by putting them back in alphabetical order (this will be the split cards, Kamigawa flip cards and a few random wackos).
3) Get rid of ampersands from R&D Secret Lair and Look at Me I'm R&D and Punctuate
4) Fix XXCall of the Herd and XXValor and Aerathi Berserker, Butcher's Cleaver

A few useful test cases:

One for each letter
S.N.O.T.
Tabernacle
Big Furry Monster
R+D's Secret Lair
Pyromancy
Great Furnace


To Update Comprehensive Rules:

1) Copy and paste portions of the new version of the rules (from the .txt version of the Comp Rules) into the relevant files:  Glossary goes in "GlossaryPre.txt", main bulk of rules goes in "CompRules_PreConvert.txt"
2) Compile and run ConvertCompRulestoHtml.java
3) Toggle the comments in ConvertCompRulesToHtml.java (see source code)
4) Compile and run it again