package com.mtgjudge;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class IPGActivity extends ListActivity {
	
	@Override
	public void onCreate(Bundle icicle) {
		super.onCreate(icicle);
		// Create an array of Strings, that will be put to our ListActivity
		String[] names = new String[] { "Judging at Regular REL", "1 - General Philosophy", "3 - Game Play Errors",
				"4 - Tournament Errors", "5 - Unsporting Conduct", "6 - Cheating"};
		// Create an ArrayAdapter, that will actually make the Strings above
		// appear in the ListView
		this.setListAdapter(new ArrayAdapter<String>(this,
				android.R.layout.simple_list_item_1, names));
	}
	
	@Override
	protected void onListItemClick(ListView l, View v, int position, long id) {
		super.onListItemClick(l, v, position, id);
		
        Intent myIntent = new Intent(v.getContext(), IPGDetailActivity.class);
        
        // Pass data to new activity
        Bundle b = new Bundle();
        b.putInt("root", position);
        
        //start loading the txt file into a string
        String information = "";
        String readLine = "";
        String eol = System.getProperty("line.separator");
        
        switch(position)
        {
        case 0:
    		try {
    			
    			InputStream is = this.getResources().openRawResource(R.raw.fce);
    		    BufferedReader br = new BufferedReader(new InputStreamReader(is));
    		    
    		    while((readLine = br.readLine())!= null)
    		    	information = information + readLine + eol;

    		    is.close();
    			br.close();
    			
    		} catch (FileNotFoundException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		} catch (IOException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}
        	break;
        case 1:
    		try {
    			
    			InputStream is = this.getResources().openRawResource(R.raw.ipg);
    		    BufferedReader br = new BufferedReader(new InputStreamReader(is));
    		    
    		    while((readLine = br.readLine())!= null && !readLine.equals("Start - 3"))    		    	
    		    	information = information + readLine + eol;
    			    		    
    		    is.close();
    			br.close();
    			
    		} catch (FileNotFoundException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		} catch (IOException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}
        	break;
        case 2:
    		try {
    			
    			InputStream is = this.getResources().openRawResource(R.raw.ipg);
    		    BufferedReader br = new BufferedReader(new InputStreamReader(is));

    		    while((readLine = br.readLine())!= null)
    		    {
    		    	if(readLine.equals("Start - 3"))
    		    	{
    		    		while((readLine = br.readLine())!= null && !readLine.equals("Start - 4"))
    		    			information = information + readLine + eol;
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
        	break;
        case 3:
    		try {
    			
    			InputStream is = this.getResources().openRawResource(R.raw.ipg);
    		    BufferedReader br = new BufferedReader(new InputStreamReader(is));

    		    while((readLine = br.readLine())!= null)
    		    {
    		    	if(readLine.equals("Start - 4"))
    		    	{
    		    		while((readLine = br.readLine())!= null && !readLine.equals("Start - 5"))
    		    			information = information + readLine + eol;
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
        	break;
        case 4:
    		try {
    			
    			InputStream is = this.getResources().openRawResource(R.raw.ipg);
    		    BufferedReader br = new BufferedReader(new InputStreamReader(is));

    		    while((readLine = br.readLine())!= null)
    		    {
    		    	if(readLine.equals("Start - 5"))
    		    	{
    		    		while((readLine = br.readLine())!= null && !readLine.equals("Start - 6"))
    		    			information = information  + readLine + eol;
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
        	break;
        case 5:
    		try {
    			
    			InputStream is = this.getResources().openRawResource(R.raw.ipg);
    		    BufferedReader br = new BufferedReader(new InputStreamReader(is));

    		    while((readLine = br.readLine())!= null)
    		    {
    		    	if(readLine.equals("Start - 6"))
    		    	{
    		    		while((readLine = br.readLine())!= null && !readLine.equals("Start - 7"))
    		    			information = information + readLine + eol;
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
        	break;
        default:
        	information = "ERROR";
        	break;
        }
        
        b.putString("information", information);
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