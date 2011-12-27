package com.mtgjudge;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;

import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class MTRActivity extends ListActivity {

	String contents = "";
	ArrayList<String> nl = new ArrayList<String>();

	@Override
	public void onCreate(Bundle icicle) {
		super.onCreate(icicle);
		String readLine = "";
		String previousLine = "";
		String eol = System.getProperty("line.separator");
		// Create an array of Strings, that will be put to our ListActivity
		

		// read the content file into String contents also setup the Arraylist
		// for display
		try {

			InputStream is = this.getResources().openRawResource(
					R.raw.mtr_contents);
			BufferedReader br = new BufferedReader(new InputStreamReader(is));

			while ((readLine = br.readLine()) != null) {
				contents = contents + readLine + eol;
				if (previousLine.equals("")) {
					nl.add(readLine);
				}
				previousLine = readLine;
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

		String[] names = nl.toArray(new String[0]);
		// Create an ArrayAdapter, that will actually make the Strings above
		// appear in the ListView
		this.setListAdapter(new ArrayAdapter<String>(this,
				android.R.layout.simple_list_item_1, names));
	}

	@Override
	protected void onListItemClick(ListView l, View v, int position, long id) {
		super.onListItemClick(l, v, position, id);

		Intent myIntent;

		// Pass data to new activity
		Bundle b = new Bundle();
		

		// start loading the txt file into a string
		String content = "";
		String rules = "";
		String readLine = "";
		String eol = System.getProperty("line.separator");
		String chosenContent = nl.get(position);
		int beginningIndex = contents.indexOf(eol, contents.indexOf(chosenContent));
		int endingIndex = contents.indexOf(eol + eol, beginningIndex);
		
		if(beginningIndex != endingIndex && endingIndex != -1)
		{
			myIntent = new Intent(v.getContext(), MTRDetailActivity.class);
			if(endingIndex != -1)
				content = contents.substring(beginningIndex + 1, endingIndex);
			else
				content = contents.substring(beginningIndex + 1);
			b.putString("content", content);
		}
		else
		{
			myIntent = new Intent(v.getContext(), MTRDisplayActivity.class);
		}
		
		try {

			InputStream is = this.getResources().openRawResource(R.raw.mtr_detail);
			
			BufferedReader br = new BufferedReader(
					new InputStreamReader(is));

			while ((readLine = br.readLine()) != null)
			{
				if(readLine.equals(chosenContent))
				{
					readLine = br.readLine(); //skip a line
					while ((readLine = br.readLine()) != null )
					{
						if(position != nl.size() - 1)
						{
							if(readLine.equals(nl.get(position + 1)))
							{
								break;
							}
						}
						rules = rules + readLine + eol;
					}
					break;
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

		b.putString("rules", rules);
		myIntent.putExtras(b);

		startActivity(myIntent);
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