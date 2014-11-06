//Lokidottir
//05/10/2014

import java.util.regex.Pattern;
import java.util.regex.Matcher;

//The string input, this text will be parsed for words
String str;

void setup() {
    str = loadFileAsString("hash_highlighting.pde");
    size(int(40 + textWidth(str)),40 + (numberOfMatches("(\\n)",str) * 20));
    background(255);
    highlightPrint(str,20,20,true);
    saveFrame("out.png");
}

void highlightPrint(final String content, final int x, final int y, final boolean print_out) {
    /*
        Set up regular expressions
    */
    Pattern p = Pattern.compile("([a-zA-Z_]+)");
    Matcher m = p.matcher(content);
    /*
        Set up variables
    */
    int wrk_index = 0;
    int wrk_x = x;
    int wrk_y = y;
    while(m.find()) {
        /*
            If the working index is less than the next match, then all characters
            need to be printed up until then as black
        */
        while (wrk_index < m.start()) {
            fill(0); //Fill black, as this segment isn't being highlighted.
            if (content.charAt(wrk_index) == '\n') {
                /*
                    Newline resets x, adds to y
                */
                wrk_x = x;
                wrk_y += 20;
            }
            else {
                /*
                    Print single char, add length to working x coordinate.
                */
                text(content.charAt(wrk_index),wrk_x,wrk_y);
                wrk_x += textWidth(content.charAt(wrk_index));
            }
            //Increment index
            wrk_index++;
        }
        int colour_hash = colourHash(m.group());
        fill(colour_hash);
        if (print_out) println("the string: \"" + m.group() + "\" hashes to r: " + str(red(colour_hash)) + " g: " + str(green(colour_hash)) + " b: " + str(blue(colour_hash)));
        text(m.group(),wrk_x,wrk_y);
        wrk_x += textWidth(m.group());
        wrk_index = m.end();
    }
    if (wrk_index < content.length()) {
        fill(0);
        for (wrk_index = wrk_index; wrk_index < content.length(); wrk_index++) {
            if (content.charAt(wrk_index) == '\n') {
                wrk_x = x;
                wrk_y += 20;
            }
            else {
                text(content.charAt(wrk_index),wrk_x,wrk_y);
                wrk_x += textWidth(content.charAt(wrk_index));
            }
        }
    }
}


color colourHash(final String word) {
    /*
        Iterating twice on a string for colours with excessively arbitrary
        multipliers!
    */
    final int total_spend = int(200 * 3);
    int r = 0;
    int g = 0;
    int b = 0;
    for (int i = 0; i < word.length(); i++) {
        r += int(int(word.charAt(i)) * 15632.7);
    }
    r = r % 200;
    for (int i = 0; i < word.length(); i++) {
        b += int(int(word.charAt(i)) * 27723.996);
    }
    b = b % 200;
    /*
        The output of red and blue weigh on what green will be, as their values
        are subracted from total_spent.
    */
    g = int((total_spend - (r + b)) * 991991.999221) % 200;
    return color(r,g,b);
}

int numberOfMatches(String regex, String text) {
    /*
        Returns the number of matches found for a regular expression. Used for formatting.
    */
    Pattern p = Pattern.compile(regex);
    Matcher m = p.matcher(text);
    int count = 0;
    while(m.find()) count++;
    return count;
}

String loadFileAsString(String path) {
    String[] str_arr = loadStrings(path);
    String str = "";
    for (int i = 0; i < str_arr.length; i++) str += str_arr[i] + "\n";
    return str;
}
