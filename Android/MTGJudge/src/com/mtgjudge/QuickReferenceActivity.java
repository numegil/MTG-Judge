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

public class QuickReferenceActivity extends ListActivity {
	
	
    /** Called when the activity is first created. */
    @Override
	public void onCreate(Bundle icicle) {
		super.onCreate(icicle);
		// Create an array of Strings, that will be put to our ListActivity
		String[] names = new String[] { "Penalties", "Missed Triggers", "Layers / Casting Spells",
				"Resolving Spells / Copiable Characteristics", "Types of Information", "Head Judge Announcement", "Reviews / Feedback"};
		// Create an ArrayAdapter, that will actually make the Strings above
		// appear in the ListView
		this.setListAdapter(new ArrayAdapter<String>(this,
				android.R.layout.simple_list_item_1, names));
	}
    
	@Override
	protected void onListItemClick(ListView l, View v, int position, long id) {
		super.onListItemClick(l, v, position, id);
		
        Intent myIntent = new Intent(v.getContext(), QuickReferenceDetailActivity.class);
        
        // Pass data to new activity
        Bundle b = new Bundle();
        b.putInt("id", position);
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