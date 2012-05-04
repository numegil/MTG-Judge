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
Replace all instances of ’ with '
Replace all instances of û with u
Replace all instances of é with e
Replace all instances of Ž with e
Replace all instances of ‰ with a
Replace all instances of ‰ with a (Dand‰n and El-Hajj‰j)

Fix Individual Cards:

1) Delete "Ach! Hans! Run!" and "___________" (from oracle_0 and namesonly only)
2) Look at top AND bottom of each array file and fix all cards that are out of alphabetical order by putting them back in alphabetical order (this will be the split cards, Kamigawa flip cards and a few random wackos).
3) Get rid of ampersands from R&D Secret Lair and Look at Me I'm R&D and Punctuate
4) Fix XXCall of the Herd and XXValor and Aerathi Berserker
5) Run oracle_fix.py to fix yet another class of errors.

To Update Comprehensive Rules:

1) Copy and paste portions of the new version of the rules (from the .txt version of the Comp Rules) into the relevant files:  Glossary goes in "CompRulesGlossary_PreConvert.txt", main bulk of rules goes in "CompRules_PreConvert.txt"
2) Compile and run ConvertCompRulestoHtml.java
3) Toggle the comments in ConvertCompRulesToHtml.java (see source code)
4) Compile and run it again


Notes specific for updating Android version:

1) Don't forget the MTR
2) oracle files need to be renamed to .xml
	command line: for i in *; do mv "$i" "`basename $i .array`.xml"; done
2) oracle_names_only.xml needs to have <string> and </string> replaced by <s> and </s>
3) oracle_names_only.xml needs to be split into oracle_names_only_1.xml and oracle_names_only_2.xml (split just after "Lyzolda")
4) oracle_names_18.xml (the 's' file) needs to be split (after 'slumbering tora') (the specific card is important because it's the cutoff between "sl" and "sm")
5) get rid of "mtgjudge://" html links in comp rules and glossary  (Notepad++ RegEx:  replace "<a href=mtgjudge://.*?>(.*?)</a>" with "\1")

Stuff to update:

iOS:
1) Oracle
2) IPG
3) Banned List
4) Comp Rules
5) Missed Triggers

Android:
1) Oracle
2) IPG
3) Comp Rules
4) MTR
5) Missed Triggers


A few useful test cases:

Oracle: One card for each first letter
S.N.O.T.
Tabernacle
Big Furry Monster
R+D's Secret Lair
Pyromancy
Great Furnace

Quick reference pictures are ok
Banned Lists by format work
Comp. Rules search works
Comp. Rules has links to rules


