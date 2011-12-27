package com.mtgjudge;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

public class DeckListCounterActivity extends Activity {
	static int count;
	static int previous;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.decklist_counter);
        
        count = 0;
        previous = 0;
        
        updateLabel();
    }
    
    public void updateLabel()
    {
    	// Construct string to be displayed
    	String str = "Total: " + count;
    	if(previous != 0)
    	{
    		str += (" (+" + previous + ")");
    	}
    	
    	// Display string (in big font)
    	TextView t = (TextView) findViewById(R.id.textViewLabel);
    	t.setText(str);
    	t.setTextSize(36);    	
    }
    
    public void clicked1(View view)
    {
    	count += 1;
    	previous = 1;
    	updateLabel();
    }
    
    public void clicked2(View view)
    {
    	count += 2;
    	previous = 2;
    	updateLabel();    	
    }
    
    public void clicked3(View view)
    {
    	count += 3;
    	previous = 3;
    	updateLabel();    	
    }
    
    public void clicked4(View view)
    {
    	count += 4;
    	previous = 4;
    	updateLabel();    	
    }
    
    public void clickedReset(View view)
    {
    	count = 0;
    	previous = 0;
    	updateLabel();
    }
    
    public void clickedUndo(View view)
    {
    	count -= previous;
    	previous = 0;
    	updateLabel();
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