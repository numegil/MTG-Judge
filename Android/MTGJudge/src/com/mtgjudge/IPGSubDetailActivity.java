package com.mtgjudge;

import java.util.Arrays;

import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class IPGSubDetailActivity extends ListActivity {

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle icicle) {
		super.onCreate(icicle);

		Bundle b = getIntent().getExtras();

		int root = b.getInt("root", -1);

		// Create an array of Strings, that will be put to our ListActivity
		String[] names;

		if (root > 1 && root < 5) {
			names = new String[] { "Definition", "Examples", "Philosophy",
					"Penalty" };
		} else if (root == 5) // Cheating
		{
			names = new String[] { "Definition", "Examples", "Penalty" };
		} else
			names = new String[] { "ERROR" };

		// Create an ArrayAdapter, that will actually make the Strings above
		// appear in the ListView
		this.setListAdapter(new ArrayAdapter<String>(this,
				android.R.layout.simple_list_item_1, names));
	}

	@Override
	protected void onListItemClick(ListView l, View v, int position, long id) {
		super.onListItemClick(l, v, position, id);

		Intent myIntent = new Intent(v.getContext(), IPGDisplayActivity.class);

		// Pass data to new activity
		Bundle b1 = getIntent().getExtras();
		Bundle b2 = new Bundle();
		int root = b1.getInt("root", -1);
		String biginfo = b1.getString("information");
		String info = "";
		String beginning = "";
		int endindex = biginfo.length() - 1;
		int def, ex, phi, pen;
		def = biginfo.indexOf("Definition\n");
		ex = biginfo.indexOf("Examples\n");
		phi = biginfo.indexOf("Philosophy\n");
		pen = biginfo.indexOf("Penalty\n");
		
		int[] order = {def, ex, phi, pen};
		Arrays.sort(order);

		if (root > 1 && root < 5) {
			//Definition, Examples, Philosophy, Penalty

			
			switch (position) {
			case 0:
				beginning = "Definition\n";
				for (int i = 0; i < order.length - 1; i++)
				{
					if(order[i] == def)
					{
						endindex = order[i+1];
						break;
					}
				}
				info = biginfo.substring(
						def + beginning.length(),
						endindex);
				break;
			case 1:
				beginning = "Examples\n";
				for (int i = 0; i < order.length - 1; i++)
				{
					if(order[i] == ex)
					{
						endindex = order[i+1];
						break;
					}
				}
				info = biginfo.substring(
						ex + beginning.length(),
						endindex);
				break;
			case 2:
				beginning = "Philosophy\n";
				for (int i = 0; i < order.length - 1; i++)
				{
					if(order[i] == phi)
					{
						endindex = order[i+1];
						break;
					}
				}
				info = biginfo.substring(
						phi + beginning.length(),
						endindex);
				break;
			case 3:
				beginning = "Penalty\n";
				for (int i = 0; i < order.length - 1; i++)
				{
					if(order[i] == pen)
					{
						endindex = order[i+1];
						break;
					}
				}
				info = biginfo.substring(
						pen + beginning.length(),
						endindex);
				break;
			default:
				info ="ERROR";
				break;
			}
		} 
		else
		{
			//Definition, Examples, Penalty
			switch (position) {
			case 0:
				beginning = "Definition\n";
				for (int i = 0; i < order.length - 1; i++)
				{
					if(order[i] == def)
					{
						endindex = order[i+1];
						break;
					}
				}
				info = biginfo.substring(
						def + beginning.length(),
						endindex);
				break;
			case 1:
				beginning = "Examples\n";
				for (int i = 0; i < order.length - 1; i++)
				{
					if(order[i] == ex)
					{
						endindex = order[i+1];
						break;
					}
				}
				info = biginfo.substring(
						ex + beginning.length(),
						endindex);
				break;
			case 2:
				beginning = "Penalty\n";
				for (int i = 0; i < order.length - 1; i++)
				{
					if(order[i] == pen)
					{
						endindex = order[i+1];
						break;
					}
				}
				info = biginfo.substring(
						pen + beginning.length(),
						endindex);
				break;
			default:
				info ="ERROR";
				break;
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
