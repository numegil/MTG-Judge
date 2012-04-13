package com.mtgjudge;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Stack;

import org.xmlpull.v1.XmlPullParserException;

import android.app.ListActivity;
import android.content.Intent;
import android.content.res.XmlResourceParser;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;

public class OracleActivity extends ListActivity {
	/** Called when the activity is first created. */
	private ListView lv1;
	private EditText ed;
	private String[] lv_arr;
	private ArrayList<String> arr_sort= new ArrayList<String>();
	private Stack< ArrayList<String> > search_stack;
	int textlength=0;
	String previousSearch;
	@Override
	public void onCreate(Bundle icicle)
	{
		super.onCreate(icicle);
		setContentView(R.layout.oracle);
		
		// Load card names
		final ArrayList<String> cardNames = getCardNamesFromXml(R.xml.oracle_names_only_1);
		cardNames.addAll(getCardNamesFromXml(R.xml.oracle_names_only_2));
		
		// Setup list and search
		lv1=getListView();
		ed=(EditText)findViewById(R.id.OracleSearchText);
		// By using setAdpater method in listview we an add string array in list.
		lv_arr = (String[]) cardNames.toArray(new String[0]);
		lv1.setAdapter(new ArrayAdapter<String>(this,android.R.layout.simple_list_item_1 , lv_arr));
		
		// Setup search stack and push first object
		search_stack = new Stack< ArrayList<String> >();
		search_stack.push(cardNames);
		Log.d("MTGJUDGE", "Search stack size after init: " + search_stack.size());
		
		ed.addTextChangedListener(new TextWatcher() {

			public void afterTextChanged(Editable s) {
			}

			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
			}

			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
				
				boolean changed = true;
				
				// If search text is getting longer, we don't need to search through the entire list, only the latest search results
				textlength=ed.getText().length();
				if(previousSearch != null && textlength >= previousSearch.length())
				{
					// If search text length is < 3, don't bother. (performance is terrible)
					if(s.length() < 3)
						return;
					
					ArrayList<String> new_arr_sort= new ArrayList<String>();
					
					for(int i=0; i<arr_sort.size(); i++)
					{
						if(textlength<=arr_sort.get(i).length())
						{
							// If search text is contained in the card name (case insensitive)
							if(((String)arr_sort.get(i)).toLowerCase().contains(ed.getText().toString().toLowerCase()))
							{
								new_arr_sort.add(arr_sort.get(i));
							}
						}
					}
					
					arr_sort = new_arr_sort;
					
					// Push it onto the search stack
					search_stack.push(new_arr_sort);
					Log.d("MTGJUDGE", "Search stack size after push:" + search_stack.size());
				}
				
				// First search
				else if(previousSearch == null)
				{
					// If search text length is < 3, don't bother. (performance is terrible)
					if(s.length() < 3)
						return;
					
					arr_sort.clear();
					for(int i=0; i<lv_arr.length; i++)
					{
						if(textlength<=lv_arr[i].length())
						{
							// If search text is contained in the card name (case insensitive)
							if(((String)lv_arr[i]).toLowerCase().contains(ed.getText().toString().toLowerCase()))
							{
								arr_sort.add(lv_arr[i]);
							}
						}
					}
					
					search_stack.push(arr_sort);
				}
				
				else
				{
					// Pop it off the search stack and make the top of the stack the live search results
					Log.d("MTGJUDGE", "Search stack size before pop: " + search_stack.size());
					
					if(search_stack.size() > 0 && s.length() > 1)
					{
						search_stack.pop();
						arr_sort = search_stack.peek();
					}
					
					// If there's nothing to pop off, display the full search results.
					else
					{
						lv1.setAdapter(new ArrayAdapter<String>(OracleActivity.this,android.R.layout.simple_list_item_1 , lv_arr));
						changed = false;
					}
					/*
					arr_sort.clear();
					for(int i=0;i<lv_arr.length;i++)
					{
						if(textlength<=lv_arr[i].length())
						{
							// If search text is contained in the card name (case insensitive)
							if(((String)lv_arr[i]).toLowerCase().contains(ed.getText().toString().toLowerCase()))
							{
								arr_sort.add(lv_arr[i]);
							}
						}
					}
					*/
				}
					
				if(changed)
					lv1.setAdapter(new ArrayAdapter<String>(OracleActivity.this,android.R.layout.simple_list_item_1 , arr_sort));
				
				previousSearch = ed.getText().toString();
			}
		});
	}
	
	@Override
	protected void onListItemClick(ListView l, View v, int position, long id) {
		super.onListItemClick(l, v, position, id);
		
		Log.v("MTGJUDGE", "Oracle: Clicked on " + lv1.getItemAtPosition(position));
		
        Intent myIntent = new Intent(v.getContext(), OracleDetailActivity.class);
        
        // Pass data to new activity
        Bundle b = new Bundle();
        b.putString("name", lv1.getItemAtPosition(position).toString());
        myIntent.putExtras(b);
        
        startActivity(myIntent);
        
	}
	
	public ArrayList<String> getCardNamesFromXml(int fileId) {
		ArrayList<String> cardNames = new ArrayList<String>();
		XmlResourceParser cardNamesXml = getResources().getXml(fileId);

		int eventType = -1;
		while (eventType != XmlResourceParser.END_DOCUMENT) {
			if (eventType == XmlResourceParser.START_TAG) {

				// If we hit the "array" near the beginning of the xml
				String strNode = cardNamesXml.getName();
				if (strNode.equals("array")) {

					while(eventType != XmlResourceParser.END_DOCUMENT)
					{
						// If we hit a card name
						if(eventType == XmlResourceParser.TEXT)
						{
							// Append lots of spaces to the end in order to make it look like the list item is full screen when clicked.
							// I'm sure there's a better way to do this, but I don't feel like looking for it.
							String cardname = cardNamesXml.getText();
							if(cardname != null)
							{
								cardname = cardname + "                                                          ";
								cardNames.add(cardname);
							}
						}
						
						// Retrieve the next element
						try
						{
							eventType = cardNamesXml.next();
						}
						catch(Exception e)
						{
							e.printStackTrace();
						}
					}
				}
			}

			try {
				eventType = cardNamesXml.next();
			} catch (XmlPullParserException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		return cardNames;
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