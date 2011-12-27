package com.mtgjudge;

import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class IPGDetailActivity extends ListActivity {

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle icicle) {
		super.onCreate(icicle);

		Bundle b = getIntent().getExtras();

		int root = b.getInt("root", -1);

		// Create an array of Strings, that will be put to our ListActivity
		String[] names;

		switch (root) {
		case 0:
			names = new String[] { "Introduction", "Common Errors",
					"General Unwanted Behaviors", "Serious Problems",
					"Resources" };
			break;
		case 1:
			names = new String[] { "Introduction", "Definition of REL",
					"Definition of Penalties", "Applying Penalties" };
			break;
		case 2:
			names = new String[] { "Introduction", "Missed Trigger",
					"Failure to Reveal", "Looking at Extra Cards",
					"Drawing Extra Cards", "Improper Drawing at Start of Game",
					"Game Rule Violation", "Failure to Maintain Game State" };
			break;
		case 3:
			names = new String[] { "Introduction", "Tardiness",
					"Outside Assistance", "Slow Play",
					"Insufficient Shuffling",
					"Failure to Follow Official Announcements",
					"Draft Procedure Violation",
					"Player Communication Violation", "Marked Cards",
					"Deck/Decklist Problem" };
			break;
		case 4:
			names = new String[] { "Introduction",
					"Unsporting Conduct - Minor", "Unsporting Conduct - Major",
					"Improperly Determining a Winner", "Bribery and Wagering",
					"Aggressive Behavior", "Theft of Tournament Material" };
			break;
		case 5:
			names = new String[] { "Introduction", "Stalling", "Fraud",
					"Hidden Information Violation",
					"Manipulation of Game Materials" };
			break;

		default:
			names = new String[] { "ERROR" };
			break;

		}

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
		Bundle b1 = getIntent().getExtras();

		Bundle b2 = new Bundle();
		int root = b1.getInt("root", -1);
		String beginning = "";
		String end = "";
		String biginfo = b1.getString("information");
		String info = "";
		b2.putInt("root", root);
		b2.putInt("subRoot", position);

		if (root == 0 || root == 1) {
			myIntent = new Intent(v.getContext(), IPGDisplayActivity.class);
			switch (position) {
			case 0:
				beginning = "Stop - 0\n";
				end = "Stop - 1";
				info = biginfo.substring(
						biginfo.indexOf(beginning) + beginning.length(),
						biginfo.indexOf(end));
				break;
			case 1:
				beginning = "Stop - 1\n";
				end = "Stop - 2";
				info = biginfo.substring(
						biginfo.indexOf(beginning) + beginning.length(),
						biginfo.indexOf(end));
				break;

			case 2:
				beginning = "Stop - 2\n";
				end = "Stop - 3";
				info = biginfo.substring(
						biginfo.indexOf(beginning) + beginning.length(),
						biginfo.indexOf(end));
				break;

			case 3:
				beginning = "Stop - 3\n";
				end = "Stop - 4";
				info = biginfo.substring(
						biginfo.indexOf(beginning) + beginning.length(),
						biginfo.indexOf(end));
				break;

			case 4:
				beginning = "Stop - 4\n";
				info = biginfo.substring(biginfo.indexOf(beginning)
						+ beginning.length());
				break;

			default:
				info = "ERROR";
				break;
			}
		}
		else
		{
			if(position == 0)
			{
				myIntent = new Intent(v.getContext(), IPGDisplayActivity.class);
				info = biginfo.substring(0, biginfo.indexOf("\n"+ (root + 1) + ".1."));
			}
			else
			{
				myIntent = new Intent(v.getContext(), IPGSubDetailActivity.class);
				beginning = (root + 1) +"."+ (position) +".";
				end = (root + 1) +"."+ (position + 1) +".";
				if(biginfo.indexOf(end) != -1)
					info = biginfo.substring(biginfo.indexOf("\n", biginfo.indexOf(beginning)) + 1,biginfo.indexOf(end));
				else
					info = biginfo.substring(biginfo.indexOf("\n", biginfo.indexOf(beginning)) + 1);
			}
		}

		b2.putString("information", info);

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
			intent.setClassName(this,QuickReferenceActivity.class.getName());
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
