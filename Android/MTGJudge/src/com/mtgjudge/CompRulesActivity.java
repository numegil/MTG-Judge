package com.mtgjudge;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Stack;
import java.util.regex.Pattern;

import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;

public class CompRulesActivity extends ListActivity {

	String contents = "";
	String eol = System.getProperty("line.separator");
	int contentcounter;
	private EditText edit;
	private Button glossary, rules, cancel;
	private ArrayList<String> nl = new ArrayList<String>();
	private ArrayList<String> result = new ArrayList<String>(); // the search result String arrylist which will be sent to display activity
	private Stack<String> glossary_search_string_stack = new Stack<String>();
	private Stack<String> rules_search_string_stack = new Stack<String>();
	private Stack< ArrayList<String> > glossary_search_list_stack = new Stack< ArrayList<String> >(); //the list for display on listview
	private Stack< ArrayList<String> > rules_search_list_stack = new Stack< ArrayList<String> >();
	private Stack< ArrayList<String> > glossary_search_result_stack = new Stack< ArrayList<String> >();
	private Stack< ArrayList<String> > rules_search_result_stack = new Stack< ArrayList<String> >();	
	private ArrayAdapter<String> searchAdapter;
	private String searchString = "";
	private int mode = 0; //this indicate the current mode {lookup, glossarySearch, rulesSearch} for the list item onclick to know what to do
	
	@Override
	public void onCreate(Bundle icicle) {
		super.onCreate(icicle);
		setContentView(R.layout.comp_rules);
		edit = (EditText) findViewById(R.id.CompRulesSearchText);
		glossary = (Button) findViewById(R.id.glossary_button);
		rules = (Button) findViewById(R.id.rules_button);
		cancel = (Button) findViewById(R.id.cancel_button);
		

		lookUpModeSetup();

		// Create an ArrayAdapter
		// appear in the ListView
		searchAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, nl);
		setListAdapter(searchAdapter);
		
		//set the OnTouchListener for the edittext field so it will show the buttons on touch
		edit.setOnTouchListener(new OnTouchListener() {
			
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				// TODO Auto-generated method stub
				//when it is the first time clicked
				if(glossary.getVisibility() == View.GONE)
				{
					searchModeSetup(); //setup layout for SearchMode
				}
				return false;
			}
		});

		
		//do search when the text in edit text changes
		edit.addTextChangedListener(new TextWatcher() {
            
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            	
            	//if user first time type in words without touching the edit text
            	if(glossary.getVisibility() == View.GONE && s.toString().length() != 0)
				{
            		searchModeSetup(); //setup layout for SearchMode
				}
            	searchString = s.toString();
            	doSearch(searchString);
            }
           
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count,
                            int after) {
                    // TODO Auto-generated method stub

                   
            }
           
            @Override
            public void afterTextChanged(Editable s) {
                    // TODO Auto-generated method stub

            }
    });
		
		//set the OnClickListener for buttons
		glossary.setOnTouchListener(new OnTouchListener() {
			
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				// TODO Auto-generated method stub
				glossary.setPressed(true);
				rules.setPressed(false);
				//set mode to glossary search
				mode = 1;
				doSearch(searchString);
				return true;
			}
		});
		
		rules.setOnTouchListener(new OnTouchListener() {
			
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				// TODO Auto-generated method stub
				
				glossary.setPressed(false);
				rules.setPressed(true);
				//set mode to rule search
				mode = 2;
				doSearch(searchString);
				return true;				
			}
		});
		
		cancel.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				//hide the buttons
				edit.setText("");
				glossary.setVisibility(View.GONE);
				rules.setVisibility(View.GONE);
				cancel.setVisibility(View.GONE);
				
				lookUpModeSetup();
				
				
			}
		});		
		
	}
	
	private void doSearch(String s) {
		nl.clear();
		result.clear();
		//start the search only after two characters are entered
	     if (s.trim().length() > 1) {
	    	 
	    	 //search in glossary
	    	 if(mode == 1)
	    	 {
	    		 //check search string stack
	    		 if(!glossary_search_string_stack.isEmpty())
	    		 {
	    			 
					// keep poping the stack until the top element is a substring of searchString or the stack is empty
					while (searchString.indexOf(glossary_search_string_stack.peek()) != 0) 
					{
						glossary_search_string_stack.pop();
						glossary_search_result_stack.pop();
						glossary_search_list_stack.pop();
						if(glossary_search_string_stack.isEmpty())
						{
							break;
						}
					}
						//the search can reuse the previous search result
					if(!glossary_search_string_stack.isEmpty())
					{
						//same as previous search no need to push into stack
						if(glossary_search_string_stack.peek().equals(searchString))
						{
							nl.addAll(glossary_search_list_stack.peek());
							result.addAll(glossary_search_result_stack.peek());
						}
						else
						{
							// start search through the list
							ArrayList<String> glossary_search_result = glossary_search_result_stack.peek();
							ArrayList<String> glossary_search_list = glossary_search_list_stack.peek();

							for (int i = 0; i < glossary_search_result.size(); i++) {
								if (Pattern.compile(Pattern.quote(searchString), Pattern.CASE_INSENSITIVE).matcher(glossary_search_result.get(i)).find()|| Pattern.compile(Pattern.quote(searchString), Pattern.CASE_INSENSITIVE).matcher(glossary_search_list.get(i)).find()) 
								{
									nl.add(glossary_search_list.get(i));
									result.add(glossary_search_result.get(i));
								}
							}
							
							//push result into stack
							glossary_search_result_stack.push((ArrayList<String>) result.clone());
							glossary_search_list_stack.push((ArrayList<String>) nl.clone());
							glossary_search_string_stack.push(searchString);							
						}	
					} 
	    		 }

	    		 	//non of the data in the stack can be use after check so the stack is cleared and now we need to do search from static file
	    		 if(glossary_search_string_stack.isEmpty())
	    		 {
	    			 //reline from the file and store first non empty line as title string and rest as result until empty line or end of file then search the contant if found match then add title and "content" into nl and result.
	    			 try {
	    				String readLine = "";
	 					InputStream is = this.getResources().openRawResource(
	 							R.raw.comp_rules_glossary);
	 					BufferedReader br = new BufferedReader(
	 							new InputStreamReader(is));
	 					String previousLine = "start";

	 					String title = "";
	 					StringBuilder content_st = new StringBuilder();
	 					String content = "";

	 					while ((readLine = br.readLine()) != null) {
	 						
	 						if (previousLine.equals("")) 
	 						{
	 							title = readLine;
	 						}
	 						else if(readLine.equals(""))
	 						{
	 							//if title and content string are not empty which means a set of title and content is completed
	 							if(!title.equals("") && content_st.length() != 0)
	 							{
	 								content = content_st.toString();
	 								//check if there is search string is found
	 								if(Pattern.compile(Pattern.quote(searchString), Pattern.CASE_INSENSITIVE).matcher(content).find()||Pattern.compile(Pattern.quote(searchString), Pattern.CASE_INSENSITIVE).matcher(title).find())
	 								{
	 									nl.add(title);
	 									result.add(content);
	 								}
	 								//clear content_st for next content
	 								content_st = new StringBuilder();
	 							}
	 						}
	 						else
	 						{
	 							content_st.append(readLine + eol);
	 						}
	 						
	 						previousLine = readLine;
	 					}
	 					
	 					//push result into stack
						glossary_search_result_stack.push((ArrayList<String>) result.clone());
						glossary_search_list_stack.push((ArrayList<String>) nl.clone());
						glossary_search_string_stack.push(searchString);
	 					
	 					is.close();
	 					br.close();

	 				} catch (FileNotFoundException e) {
	 					// TODO Auto-generated catch block
	 					e.printStackTrace();
	 				} catch (IOException e) {
	 					// TODO Auto-generated catch block
	 					e.printStackTrace();
	 				}
	    		 }			    		 
	    	 }
	    	 //search in rules similar to glossary search
	    	 else
	    	 {
	    		 //check search string stack
	    		 if(!rules_search_string_stack.isEmpty())
	    		 {
	    			 
					// keep poping the stack until the top element is a substring of searchString or the stack is empty
					while (searchString.indexOf(rules_search_string_stack.peek()) != 0) 
					{
						rules_search_string_stack.pop();
						rules_search_result_stack.pop();
						rules_search_list_stack.pop();
						if(rules_search_string_stack.isEmpty())
						{
							break;
						}
					}
						//the search can reuse the previous search result
					if(!rules_search_string_stack.isEmpty())
					{
						//same as previous search no need to push into stack
						if(rules_search_string_stack.peek().equals(searchString))
						{
							nl.addAll(rules_search_list_stack.peek());
							result.addAll(rules_search_result_stack.peek());
						}
						else
						{
							// start search through the list
							ArrayList<String> rules_search_result = rules_search_result_stack.peek();
							ArrayList<String> rules_search_list = rules_search_list_stack.peek();

							for (int i = 0; i < rules_search_result.size(); i++) {
								if (Pattern.compile(Pattern.quote(searchString), Pattern.CASE_INSENSITIVE).matcher(rules_search_result.get(i)).find()|| Pattern.compile(Pattern.quote(searchString), Pattern.CASE_INSENSITIVE).matcher(rules_search_list.get(i)).find()) 
								{
									nl.add(rules_search_list.get(i));
									result.add(rules_search_result.get(i));
								}
							}
							
							//push result into stack
							rules_search_result_stack.push((ArrayList<String>) result.clone());
							rules_search_list_stack.push((ArrayList<String>) nl.clone());
							rules_search_string_stack.push(searchString);							
						}	
					} 
	    		 }

	    		 	//non of the data in the stack can be use after check so the stack is cleared and now we need to do search from static file
	    		 if(rules_search_string_stack.isEmpty())
	    		 {
	    			 //reline from the file and store first non empty line as title string and rest as result until empty line or end of file then search the contant if found match then add title and "content" into nl and result.
	    			 try {
	    				String readLine = "";
	 					InputStream is = this.getResources().openRawResource(R.raw.comp_rules);
	 					BufferedReader br = new BufferedReader(new InputStreamReader(is));

	 					String title = "";
	 					String small_title = "";
	 					String previous_line = "";
	 					boolean found = false; //indicate if a title matches the search string
	 					StringBuilder content_st = new StringBuilder();
	 					StringBuilder small_content_st = new StringBuilder();
	 					int indexOfBigContent = 0;

	 					while ((readLine = br.readLine()) != null) {
	 						
	 						//if the first dot appears followed by a white space and with empty line above then it is the title
	 						if(readLine.indexOf(".")!= -1 && readLine.indexOf(".") == readLine.indexOf(". ") && previous_line.equals(""))
	 						{
	 							//add previous big content into result
	 							if(found)
	 							{
	 								result.add(indexOfBigContent, content_st.toString());
	 								content_st = new StringBuilder();
	 							}
	 							title = readLine.substring(readLine.indexOf(" ") + 1); 
	 							found = readLine.contains(searchString);
	 							
	 							if(found)
	 							{
	 								indexOfBigContent = result.size();
	 								nl.add(readLine);
	 								content_st.append(readLine + eol);
	 							}
	 						}
	 						else 
	 						{
	 							if(previous_line.equals("") && !readLine.equals(""))
	 							{
	 								small_title = readLine.substring(0,	readLine.indexOf(" ")) + " - "+ title; 
	 							}
	 								//build big content
	 							if(found)
	 							{
	 								content_st.append(readLine + eol);
	 							}
	 							
	 							 //if current line is white space then we know the small_content_st is setup
								if (readLine.equals("")) 
								{
									if(Pattern.compile(Pattern.quote(searchString), Pattern.CASE_INSENSITIVE).matcher(small_content_st.toString()).find())
									{
										// setup the display index(the part
										// before
										// first space) + title name for
										// listview
										nl.add(small_title);
										result.add(small_content_st.toString());
									}
									small_content_st = new StringBuilder(); //clear
								}
								else //build small_content_st
								{
									small_content_st.append(readLine + eol);
								}
	 						}
	 						
	 						previous_line = readLine;
	 					}
	 					
	 					//push result into stack
						rules_search_result_stack.push((ArrayList<String>) result.clone());
						rules_search_list_stack.push((ArrayList<String>) nl.clone());
						rules_search_string_stack.push(searchString);
	 					
	 					is.close();
	 					br.close();

	 				} catch (FileNotFoundException e) {
	 					// TODO Auto-generated catch block
	 					e.printStackTrace();
	 				} catch (IOException e) {
	 					// TODO Auto-generated catch block
	 					e.printStackTrace();
	 				}
	    		 }			    		 	    	  
	    	 }	    	 
	     }	    
	     searchAdapter.notifyDataSetChanged();	     
	}
	
		//a function which setup the layout of the lookUpMode
	private void lookUpModeSetup()
	{
		//set mode to lookUp
		mode = 0;
		nl.clear();
		String readLine = "";
		
		// Create an array of Strings, that will be put to our ListActivity		
		contentcounter = 1;

		// read the content file into String contents also setup the Arraylist
		// for display
		try {

			InputStream is = this.getResources().openRawResource(
					R.raw.comp_rules_contents);
			BufferedReader br = new BufferedReader(new InputStreamReader(is));

			while ((readLine = br.readLine()) != null) {
				contents = contents + readLine + eol;
				if (readLine.indexOf(contentcounter + ".") == 0) {
					nl.add(readLine);
					contentcounter++;
				}
			}
			is.close();
			br.close();

		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		nl.add("Glossary");
	}
	
		//a function which setup the layout of searchMode
	private void searchModeSetup() {
		// shows the button
		glossary.setVisibility(View.VISIBLE);
		glossary.setPressed(true);
		rules.setPressed(false);
		rules.setVisibility(View.VISIBLE);
		cancel.setVisibility(View.VISIBLE);
		// clear the list
		nl.clear();
		searchAdapter.notifyDataSetChanged();
		// set mode to search Glossary Entries by default
		mode = 1;
	}
	
	@Override
	protected void onListItemClick(ListView l, View v, int position, long id) {
		super.onListItemClick(l, v, position, id);
		
		// LookUpMode
		if (mode == 0) {
			Intent myIntent = new Intent(v.getContext(),CompRulesDetailActivity.class);

			// Pass data to new activity
			Bundle b = new Bundle();

			// start loading the txt file into a string
			String content = "";
			String rules = "";
			String readLine = "";
			String eol = System.getProperty("line.separator");		
			// not Glossary
			if (position != contentcounter - 1) {

				b.putInt("root", 0); // non Glossary
				try {

					InputStream is = this.getResources().openRawResource(
							R.raw.comp_rules);
					BufferedReader br = new BufferedReader(
							new InputStreamReader(is));

					StringBuilder st = new StringBuilder();
					while ((readLine = br.readLine()) != null) {
						if (readLine.startsWith((position + 1) + ".")) {
							while ((readLine = br.readLine()) != null) {
								if (readLine.startsWith((position + 2) + ".")) {
									break;
								}
								st.append(readLine + eol);
							}
							break;
						}
					}

					rules = st.toString();

					is.close();
					br.close();

				} catch (FileNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				int beginningindex = contents.indexOf(eol,
						contents.indexOf(eol + (position + 1) + ".") + 1) + 1;
				int endindex = contents.indexOf(eol + eol, beginningindex) + 1;
				content = contents.substring(beginningindex, endindex);
			} else {
				b.putInt("root", 1); // Glossary
				try {

					InputStream is = this.getResources().openRawResource(
							R.raw.comp_rules_glossary);
					BufferedReader br = new BufferedReader(
							new InputStreamReader(is));
					String previousLine = "start";

					StringBuilder content_st = new StringBuilder();
					StringBuilder rules_st = new StringBuilder();

					while ((readLine = br.readLine()) != null) {
						rules_st.append(readLine + eol);
						if (previousLine.equals("")) {
							content_st.append(readLine + eol);
						}
						previousLine = readLine;
					}

					content = content_st.toString();
					rules = rules_st.toString();

					is.close();
					br.close();

				} catch (FileNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			}

			b.putString("rules", rules);
			b.putString("content", content);
			myIntent.putExtras(b);

			startActivity(myIntent);
		}
		else //display result for both search mode
		{
			Intent myIntent = new Intent(v.getContext(),CompRulesDisplayActivity.class);

			// Pass data to new activity
			Bundle b = new Bundle();
			b.putString("rules", result.get(position));
			myIntent.putExtras(b);

			startActivity(myIntent);
			
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
		case R.id.quick_ref: {
			intent.setClassName(this, QuickReferenceActivity.class.getName());
			startActivity(intent);
			return true;
		}
		case R.id.oracle: {
			intent.setClassName(this, OracleActivity.class.getName());
			startActivity(intent);
			return true;
		}
		case R.id.ipg: {
			intent.setClassName(this, IPGActivity.class.getName());
			startActivity(intent);
			return true;
		}
		case R.id.comp_rules: {
			intent.setClassName(this, CompRulesActivity.class.getName());
			startActivity(intent);
			return true;
		}
		case R.id.dl_counter: {
			intent.setClassName(this, DeckListCounterActivity.class.getName());
			startActivity(intent);
			return true;
		}
		case R.id.mtr: {
			intent.setClassName(this, MTRActivity.class.getName());
			startActivity(intent);
			return true;
		}
		default:
			return super.onOptionsItemSelected(item);
		}
	}
}