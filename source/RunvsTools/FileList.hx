package;
import haxe.macro.Expr;
import sys.FileSystem;
using StringTools;
/**
 * ...
 * @author 
 */
class FileList
{
	public static macro function getFileList ( folder :String, extension: String) : Expr
	{
		
		var list = [];
		
		var content = FileSystem.readDirectory(folder);
		
		for (s in content)
		{
			if (s.endsWith(extension))
			{
				var path = folder + s;
				list.push(macro $v{path});
			}
		}
		return macro $a{list};
		
	}
	
}