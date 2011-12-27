package com.mtgjudge;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.ImageView;

public class QuickReferenceDetailActivity extends Activity {

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.quick_reference_detail);
        
        ImageView image = (ImageView) findViewById(R.id.quick_ref_image);
        
        Bundle b = getIntent().getExtras();
        
        // Default is -1 (not found), +1 is to account for it being 0 based, as opposed to 1 based for the images
        int imageId = b.getInt("id", -1) + 1;
        
        // I'm sure there's a better way to do this, but I don't care enough :P
        switch(imageId)
        {
        case 1:
        	image.setImageResource(R.drawable.guide_1);
        	break;
        case 2:
        	image.setImageResource(R.drawable.guide_2);
        	break;
        case 3:
        	image.setImageResource(R.drawable.guide_3);
        	break;
        case 4:
        	image.setImageResource(R.drawable.guide_4);
        	break;
        case 5:
        	image.setImageResource(R.drawable.guide_5);
        	break;
        case 6:
        	image.setImageResource(R.drawable.guide_6);
        	break;
        case 7:
        	image.setImageResource(R.drawable.guide_7);
        	break;	
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