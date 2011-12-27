package com.mtgjudge;

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

public class MTRDetailActivity extends ListActivity {

	ArrayList<String> nl = new ArrayList<String>();

	@Override
	public void onCreate(Bundle icicle) {
		super.onCreate(icicle);
		Bundle b = getIntent().getExtras();
		String content = b.getString("content");
		String eol = System.getProperty("line.separator");
		// Create an array of Strings, that will be put to our ListActivity
		
		int endindex = 0;
		int beginningindex = 0;
		

		// read the content file into String contents also setup the Arraylist
		// for display
		while((endindex = content.indexOf(eol, beginningindex)) != -1)
		{
			nl.add(content.substring(beginningindex, endindex));
			beginningindex = endindex + 1;
		}
		nl.add(content.substring(beginningindex));

		String[] names = nl.toArray(new String[0]);
		// Create an ArrayAdapter, that will actually make the Strings above
		// appear in the ListView
		this.setListAdapter(new ArrayAdapter<String>(this,
				android.R.layout.simple_list_item_1, names));
	}

	@Override
	protected void onListItemClick(ListView l, View v, int position, long id) {
		super.onListItemClick(l, v, position, id);

		Intent myIntent = new Intent(v.getContext(), MTRDisplayActivity.class);

		// Pass data to new activity
		Bundle b1 = getIntent().getExtras();

		Bundle b2 = new Bundle();
		String bigrules = b1.getString("rules");
		String rules = "";
		
		if(position != (nl.size() - 1))
		{
			String test = nl.get(position + 1);
			rules = bigrules.substring(bigrules.indexOf("\n", bigrules.indexOf(nl.get(position))) + 1, bigrules.indexOf(nl.get(position + 1)) -1 );
		}
		else
		{
			rules = bigrules.substring(bigrules.indexOf("\n", bigrules.indexOf(nl.get(position))) + 1);
		}
		

		b2.putString("rules", rules);
		myIntent.putExtras(b2);

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