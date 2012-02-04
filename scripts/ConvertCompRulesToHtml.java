
// NOTES:
//
// Don't forget to do both main Comp Rules and Glossary
//


import java.io.*;
import java.util.*;

public class ConvertCompRulesToHtml
{

	public static void main(String[] args) throws IOException
	{

        // Toggle these comments:  (run with one pair of lines commented out the first time, then the second pair the second time to convert both files).
        
		//BufferedReader in = new BufferedReader(new FileReader("CompRules_PreConvert.txt"));
		//PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter("CompRules.txt")));

		BufferedReader in = new BufferedReader(new FileReader("CompRulesGlossary_PreConvert.txt"));
		PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter("CompRulesGlossary.txt")));


		String line = in.readLine();
		while(line != null)
		{
			//System.out.println("\n" + line);

			for(int i = 1; i < line.length(); i++)
			{
				int len = -1;

				if(isNum(line.charAt(i)) && isNum(line.charAt(i+1)) && isNum(line.charAt(i+2)))
				{
					if(line.length() <= i+4) len = 3;

					else if(line.charAt(i+3) != '.' || !isNum(line.charAt(i+4))) len = 3;

					else if(line.length() <= i+5) len = 5;

					else if(!isNum(line.charAt(i+5)) && !isLetter(line.charAt(i+5))) len = 5;

					else if(isLetter(line.charAt(i+6))) len = 7;

					else len = 6;
				}


				if(len != -1)
				{
					//System.out.println("Found len " + len + " in position " + i);

					String line2 = line.substring(0,i) + "<a href=mtgjudge://" + line.substring(i, i+len) + ">" + line.substring(i,i+len) + "</a>" + line.substring(i+len,line.length());
					//System.out.println(line2);
					line = line2;
					i += (24 + len);
				}

			}



			out.println(line);
			line = in.readLine();
		}

		out.close();

	}

	public static boolean isLetter(char c)
	{
		return (c >= 'a' && c <= 'z');
	}

	public static boolean isNum(char c)
	{
		return (c >= '0' && c <= '9');
	}
}

