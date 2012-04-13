package com.mtgjudge;

import android.app.Activity;
import android.content.Intent;
import android.content.res.XmlResourceParser;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.TextView;

public class OracleDetailActivity extends Activity {

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	    setContentView(R.layout.oracle_detail);
	
	    // Get card name
	    Bundle b = getIntent().getExtras();
	    String name = b.getString("name").trim();
	    if(name.equals(""))
	    {
	    	Log.e("MTGJUDGE", "OracleDetail: ERROR! Name is empty.  Something went very, very wrong...");
	    }
	    
	    // Echo card name
	    TextView textbox = (TextView) findViewById(R.id.oracleDetailTextView);
	    textbox.setText(getOracleFromXml(name));
	}
	
	public String getOracleFromXml(String name)
	{
		return getOracleFromXml(name, false);
	}
	
	// name is card name. if trigger is true, get the triggers data.  otherwise, get the full oracle info (including calling triggers recursively).
	public String getOracleFromXml(String name, boolean trigger) {
		String oracle = "";
		
		// Load XML file.
		XmlResourceParser xmlFile = getResources().getXml(getOracleXmlId(name));
		if(trigger)
			xmlFile = getResources().getXml(R.xml.triggers);

		int eventType = -1;
		while (eventType != XmlResourceParser.END_DOCUMENT) {
			if (eventType == XmlResourceParser.START_TAG)
			{
				// If we hit the "array" near the beginning of the xml  (master array of all cards)
				if (xmlFile.getName().equals("array"))
				{
					do
					{
						// Advance parser
						eventType = advanceXml(xmlFile);
						
						// If we hit a new card
						if(xmlFile.getName().equals("array"))
						{
							// Advance parser
							eventType = advanceXml(xmlFile);
							
							// If we hit the card name
							if(xmlFile.getName().equals("string"))
							{
								// Advance parser
								eventType = advanceXml(xmlFile);
								
								// If it's the card we're looking for
								if(xmlFile.getText().toLowerCase().equals(name.toLowerCase()))
								{
									String[] cardParts = new String[6];
									cardParts[0] = name;
									int index = 0;
									
									// This is checked for later
									cardParts[5] = "nothing";
									
									// Iterate through the xml until we get two end tags in a row (end of card)
									int previousEvent;
									do
									{
										previousEvent = eventType;
										// Advance parser
										eventType = advanceXml(xmlFile);
										
										// If we hit some text, store it
										if(eventType == XmlResourceParser.TEXT)
										{
											index++;
											cardParts[index] = xmlFile.getText();
										}
										
									} while(eventType != XmlResourceParser.END_TAG || previousEvent != XmlResourceParser.END_TAG);
									
									// If we're looking for triggers
									if(trigger)
									{
										String triggers = "";
										// Iterate through the triggers and append them to the output. (skipping i=0 because that's the card name)
										for(int i = 1; i < cardParts.length-1; i++)
										{
											// If there's no more triggers, stop.
											if(cardParts[i] == null)
												break;
											
											String num_label = "";
											switch(i)
											{
											case 1:
												num_label = "first";
												break;
											case 2:
												num_label = "second";
												break;
											case 3:
												num_label = "third";
												break;
											default:
												num_label = "fourth";
												break;
											}
											
											triggers = triggers + "The " + num_label + " trigger is " + cardParts[i] + ".\n";
										}
										
										return triggers;
									}
									
									// If it's not a land
									else if(cardParts[5] != "nothing")
									{
										// Name and CMC on the same line
										oracle = "\n" + cardParts[0] + " " + cardParts[1];
										// Card type next
										oracle = oracle + "\n" + cardParts[2];
										// Blank line followed by card text.
										oracle = oracle + "\n\n" + cardParts[3];
										// Blank line followed by P/T or Loyalty
										oracle = oracle + "\n\n" + cardParts[4];
										// Blank line followed by set info
										oracle = oracle + "\n\n" + cardParts[5];
									}
									else // It's a land (has no CMC)
									{
										// Name and CMC on the same line
										oracle = "\n" + cardParts[0];
										// Card type next
										oracle = oracle + "\n" + cardParts[1];
										// Blank line followed by card text.
										oracle = oracle + "\n\n" + cardParts[2];
										// Blank line followed by P/T or Loyalty
										oracle = oracle + "\n\n" + cardParts[3];
										// Blank line followed by set info
										if(cardParts[4] != null)
											oracle = oracle + "\n\n" + cardParts[4];
									}
									
									// Recursively get trigger data
									if(!trigger)
									{
										String triggers = getOracleFromXml(name, true);
										
										oracle += ("\n\n" + triggers);
									}

									return oracle;
								}
								
								// Not the droids, err, card we're looking for
								else
								{
									// Iterate through the xml until we get two end tags in a row (end of card)
									int previousEvent;
									do
									{
										previousEvent = eventType;
										// Advance parser
										eventType = advanceXml(xmlFile);
									} while(eventType != XmlResourceParser.END_TAG || previousEvent != XmlResourceParser.END_TAG);
								}
							}
						}
					} while(eventType != XmlResourceParser.END_DOCUMENT);
				}
			}
			
			eventType = advanceXml(xmlFile);
		}

		return "NOT FOUND";
	}
	
	// Helper function to advance the state of the xml parser and return whatever the parser found
	public int advanceXml(XmlResourceParser xmlFile)
	{		
		int eventType = -1;
		
		// Retrieve the next element
		try
		{
			eventType = xmlFile.next();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		return eventType;
	}
	
	// Returns an id to the correct oracle file based on the first letter of the card name.
	// Again, I'm sure there's a way to do this that doesn't suck this much, but I don't want to waste time looking for it.
	public int getOracleXmlId(String name)
	{
		int firstLetterId = name.toLowerCase().charAt(0) - 'a';
		
		switch(firstLetterId)
		{
		case 0:
			return R.xml.oracle_0;
		case 1:
			return R.xml.oracle_1;
		case 2:
			return R.xml.oracle_2;
		case 3:
			return R.xml.oracle_3;
		case 4:
			return R.xml.oracle_4;
		case 5:
			return R.xml.oracle_5;
		case 6:
			return R.xml.oracle_6;
		case 7:
			return R.xml.oracle_7;
		case 8:
			return R.xml.oracle_8;
		case 9:
			return R.xml.oracle_9;
		case 10:
			return R.xml.oracle_10;
		case 11:
			return R.xml.oracle_11;
		case 12:
			return R.xml.oracle_12;
		case 13:
			return R.xml.oracle_13;
		case 14:
			return R.xml.oracle_14;
		case 15:
			return R.xml.oracle_15;
		case 16:
			return R.xml.oracle_16;
		case 17:
			return R.xml.oracle_17;
		case 18:
			// Special case for the letter 's' (the only file over the size limit):
			// Subdivide all the 's's in half between the second letter 'l' and 'm'
			char secondLetterId = name.toLowerCase().charAt(1);
			if(secondLetterId <= 'l')
				return R.xml.oracle_18_1;
			else
				return R.xml.oracle_18_2;
		case 19:
			return R.xml.oracle_19;
		case 20:
			return R.xml.oracle_20;
		case 21:
			return R.xml.oracle_21;
		case 22:
			return R.xml.oracle_22;
		case 23:
			return R.xml.oracle_23;
		case 24:
			return R.xml.oracle_24;
		case 25:
			return R.xml.oracle_25;
			
		// Something went wrong
		default:
			return -1;

		}
	}

	@Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.menu, menu);
        return true;
    }
    
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle item selection
    	Intent intent = new Intent(Intent.ACTION_VIEW);
        switch (item.getItemId()) {
        case R.id.quick_ref:
        {
        	intent.setClassName(this, QuickReferenceActivity.class.getName());
        	startActivity(intent);
            return true;
        }
        case R.id.oracle:
        {
        	intent.setClassName(this, OracleActivity.class.getName());
        	startActivity(intent);
            return true;
        }
        case R.id.ipg:
        {
        	intent.setClassName(this, IPGActivity.class.getName());
        	startActivity(intent);
            return true;
        }
        case R.id.comp_rules:
        {
        	intent.setClassName(this, CompRulesActivity.class.getName());
        	startActivity(intent);
            return true;
        }
        case R.id.dl_counter:
        {
        	intent.setClassName(this, DeckListCounterActivity.class.getName());
        	startActivity(intent);
            return true;
        }
        case R.id.mtr:
        {
        	intent.setClassName(this, MTRActivity.class.getName());
        	startActivity(intent);
            return true;
        }
        default:
            return super.onOptionsItemSelected(item);
        }
    }
}
