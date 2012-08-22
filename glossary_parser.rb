require 'rubygems'
require 'httparty'
require 'oauth2'
require 'fileutils'
require 'tempfile'

#https://spreadsheets.google.com/feeds/download/spreadsheets/Export?key=0AsAb9hApGR2qdFh6VlpQeFhGQ2R1d0dNWjI5SjVzVnc&exportFormat=csv
#So I didn't want to take the time to worry about authenticating into google. Just cp the above link into the browser and navigate to the home directory
def csv_to_arrays filename
	File.open(filename,'r+') do |f|
	  rows = []
	  f.each_line("\n") do |line|
	  	columns = line.split(",")
	  	rows.push(columns)
	  end
	  rows
	end
end

def turn_array_to_html
  csv = csv_to_arrays("../../Downloads/Glossary.csv")
  %x[touch glossary.html] unless File.exist?("glossary.html")
  File.open("glossary.html", 'w+') do |f|
  	f.write("<html>\n<body>\n<table border='1'>\n<tr>")
  	f.write("\n<th> #{csv[0][0]}</th>\n<th>#{csv[0][1]}</th>\n</tr>")
    csv.each do |column|
    	if column != csv[0]
  	    f.write("\n<tr>\n<td>#{column[0]}</td>\n<td>#{column[1]}</td>\n</tr>")
  	  end
    end
    f.write("\n</table>\n</body>\n</html>")
  end
end

def turn_to_markdown
  csv = csv_to_arrays("../../Downloads/Glossary.csv")
  %x[touch README.md] unless File.exist?("README.md")
  File.open("README.md", "w+") do |f|
    f.write("Medivo Glossary\n")
    f.write("===============\n")
    csv.each do |column|
      if column != csv[0]
        f.write("- *#{column[0]}*...........#{column[1]}\n")
      end
    end
  end
end

def push_to_github
  system("git add .")
  system("git commit -m #{rand(0..1098)}")
  system("git push origin master")
end




turn_array_to_html
turn_to_markdown
push_to_github