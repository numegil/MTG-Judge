import java.util.*;
import java.io.*;

public class Convert{

	public static void main(String[] args) throws Exception{

		BufferedReader in = new BufferedReader(new FileReader("spoiler.txt"));

		PrintWriter[] out = new PrintWriter[26];

		for(int i = 0; i < 26; i++)
		{
			out[i] = new PrintWriter(new BufferedWriter(new FileWriter(("oracle_" + i + ".array"))));
		}

		PrintWriter outNames = new PrintWriter(new BufferedWriter(new FileWriter("oracle_names_only.array")));

		for(int i = 0; i < 26; i++)
		{
			out[i].println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">\n<array>");
		}

		outNames.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">\n<array>");


		boolean cardsStarted = false;

		int partOfCard = 0; // 1-Name, 2-Cost, 3-Type, 4-Pow/Tgh, 5-Rules Text, 6-Set/Rarity

		String name = "", cost = "", type = "", pt = "", rules = "", set = "";

		String line = in.readLine();
		while(line != null){

			line = line.trim();
			//System.out.println(line);
			if(cardsStarted)
			{

				if(line.equals("</table>")) break;

				if(line.indexOf("<td colspan=") != -1) // new card
				{
					rules = rules.replaceAll("<br />","\n");
					rules = rules.replaceAll("\n\n","\n");
					rules = rules.replaceAll("�","-");
					type = type.replaceAll("�","-");


					int firstLetter = (int)name.charAt(0) - 65;
					if(firstLetter == 49 || firstLetter == 150 || firstLetter == 130 || firstLetter == -31 || firstLetter == 30 || firstLetter == 8665) firstLetter = 0;

					out[firstLetter].println("\t<array>");
					out[firstLetter].println("\t\t<string>" + name + "</string>");
					if(!cost.equals("")) out[firstLetter].println("\t\t<string>" + cost + "</string>");
					out[firstLetter].println("\t\t<string>" + type + "</string>");
					out[firstLetter].println("\t\t<string>" + pt + "</string>");
					out[firstLetter].println("\t\t<string>" + rules + "</string>");
					out[firstLetter].println("\t\t<string>" + set + "</string>");
					out[firstLetter].println("\t</array>");
					outNames.println("\t<string>" + name + "</string>");

					partOfCard = 0;
					rules = "";
					cost = "";
					set = "";
					name = "";
					pt = "";

					line = in.readLine();
					continue;
				}

				if(line.indexOf("<tr>") == -1 && line.indexOf("<td>") == -1 && line.indexOf("</td>") == -1 && line.indexOf("</tr>") == -1 && line.indexOf("<table>") == -1)
				if(line.indexOf("<tr id=") == -1 && line.indexOf("<td colspan=") == -1 && line.length() != 0 && !line.equals("<br />"))
				{

					if(line.indexOf("Name:") != -1) partOfCard = 1;
					else if(line.indexOf("Cost:") != -1) partOfCard = 2;
					else if(line.indexOf("Type:") != -1) partOfCard = 3;
					else if(line.indexOf("Pow/Tgh:") != -1 || line.indexOf("Loyalty:") != -1) partOfCard = 4;
					else if(line.indexOf("Rules Text:") != -1) partOfCard = 5;
					else if(line.indexOf("Set/Rarity:") != -1) partOfCard = 6;



					else{

						//System.out.println(partOfCard + " --> " + line);

						switch(partOfCard)
						{
							case 1: // name
							{
								int index1 = line.lastIndexOf("\">");
								int index2 = line.lastIndexOf("</");
								name = line.substring(index1 + 2, index2);
							}
							break;

							case 2:
							cost = line;
							break;

							case 3:
							type = line;
							break;

							case 4:
							pt = line;
							break;

							case 5:
							//if(line.indexOf("<br />") != -1) partOfCard--;
							rules = rules + line;
							break;

							case 6: set = line;
							break;

							default:
							System.out.println("ERROR!  (something went wrong)");
						}
					}




				}


			} // if cardsStarted

			else if(line.indexOf("textspoiler") != -1) cardsStarted = true;

			line = in.readLine();
		}

		for(int i = 0; i < 26; i++)
		{
			out[i].println("</array>\n</plist>");
			out[i].close();
		}

		outNames.println("</array>\n</plist>");
		outNames.close();
	}


}