package ;

import cpp.Lib;
import sys.io.File;
import haxe.io.Eof;

/**
 * ...
 * @author nicotroia
 */

class Main {
    static function main() {
    	//Starting cpp
    	//Xcode preferences > downloads > install commandline tools
    	//haxelib install hxcpp
    	//haxelib upgrade hxcpp
    	//sudo cp /usr/lib/haxe/lib/nme/3,5,5/ndll/Mac/tls.ndll /usr/lib/neko/tls.ndll

        trace("hello world");
		
		//var finTxt = "assets/pantone_chart.txt";
		//var foutTxt = "assets/pantone_chart_clean.txt";
		var finTxt = "assets/crayola.txt";
		var foutTxt = "assets/crayola_clean.txt";
		
		var fin = File.read(finTxt, true);
		var fout = File.write(foutTxt, false);

   		var pantoneRegEx = ~/(([0-9]+)|([0-9]+ 2X))([ ]+)([0-9]+)([ ]+)([0-9]+)([ ]+)([0-9]+)([ ]+)#([0-9a-fA-F]{6})/; 
		var crayolaRegEx = ~/([ a-zA-Z''()]+)([ \t]+)([A-F0-9]{6})([ ]+)(([0-9]+),([0-9]+),([0-9]+))/;

		try { 
			var lineNum = 0;
			while ( true ) { 
				var str = fin.readLine();

				if ( str == '' ) continue;

				lineNum++;

				//match the string
				//pantoneRegEx.match(str);
				crayolaRegEx.match(str);

				//Lib.println((lineNum) + " Id: " + pantoneRegEx.matched(1) + " R: " + pantoneRegEx.matched(5) + " G: " + pantoneRegEx.matched(7) + " B: " + pantoneRegEx.matched(9) + " hex: " + pantoneRegEx.matched(11)); 
				Lib.println((lineNum) + " Name: " + crayolaRegEx.matched(1) + " hex: " + crayolaRegEx.matched(3) + " r: " + crayolaRegEx.matched(6) + " g: " + crayolaRegEx.matched(7) + " b: " + crayolaRegEx.matched(8));

				//write proper csv output
				//fout.writeString(pantoneRegEx.matched(1) +","+ pantoneRegEx.matched(5) +","+ pantoneRegEx.matched(7) +","+ pantoneRegEx.matched(9) +","+ pantoneRegEx.matched(11) +"\r");
				fout.writeString(crayolaRegEx.matched(1) +","+ crayolaRegEx.matched(3) +","+ crayolaRegEx.matched(6) +","+ crayolaRegEx.matched(7) +","+ crayolaRegEx.matched(8) +"\r");
			}
		}
		catch ( ex:Eof ) { 
			
		}
		
		fin.close();
		fout.close();
    }
}