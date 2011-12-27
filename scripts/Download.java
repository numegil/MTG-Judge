import java.net.*;
import java.io.*;

public class Download {
    public static void main(String[] args) throws Exception {
        
        // IMPORTANT:  Fill this in with the source of where you're getting the oracle data from.
        String base_url = "http://google.com"
        
        URL url = new URL(base_url + "/Pages/Search/Default.aspx?action=advanced&output=spoiler&method=text&set=+![%22bogusexpansion%22]");
        URLConnection yc = url.openConnection();
        BufferedReader in = new BufferedReader(
                                new InputStreamReader(
                                yc.getInputStream()));
        String inputLine;





        while ((inputLine = in.readLine()) != null)
            System.out.println(inputLine);
        in.close();
    }
}