# How to import bodgeit.zip in Eclipse on Windows Vista #

Some people have had problems adding bodgeit to Eclipse directly from svn.

These notes are c/o Neville Jones :)

## Steps ##
1) Download the bodgeit.zip file from:
http://code.google.com/p/bodgeit/downloads/detail?name=bodgeit.zip

2) Extract the zip to a folder, I recommend using simple folder names as I seen some warnings, please read my notes below "Simple Folder Notes", make a note where you put the extracted file; eg c:\xampp\java\bodgeit\ or c:\eclipse\java\bodgeit\

3) Create a new project.
Select File >> New >> Java Project, give it a project name (I used "bodgeit store") and click finish.

4) Import contents of bodgeit.zip in to project root.
If the bodgeit.zip was just a library of Java classes then we could add it to the build path, however in this case we want to import this in to our project as this contains a few script that we want to run and test (FunctionalTest.java and FunctionalZAP.java).

To do this right click on the new project (must me on the project name and not on ./src/ or any other folder) and select "import".

In the general folder select to option "File System" then click on next, then click browse button to locate and select the extracted bodgeit store files and click ok.

You would need to select the files to import and in this case click "Select All" and finally click on the finish button.

5) Test by building the project

Assuming you have ANT installed and you have set up JAVA\_HOME and ANT\_HOME, see this forum:
http://stackoverflow.com/questions/1288343/how-to-change-java-home-for-eclipse-ant

Assuming you have Java SDK (aka JDK or Java [Software](Software.md) Development kit) installed, Note: Java RE (Runtime Edition) will not work with Ant (need tools.jar in the JDK).

To build this project and hence test that it is OK after an import select the build.xml for this project, right click and choose Run as...  >> Ant build

On the first attempt I did get one warning:
```
Buildfile: C:\Users\neville\workspace\bodgeit Store\build.xml
compile:
    [javac] C:\Users\neville\workspace\bodgeit Store\build.xml:22: warning: 'includeantruntime' was not set, defaulting to build.sysclasspath=last; set to false for repeatable builds
BUILD SUCCESSFUL
Total time: 531 milliseconds
```
Again using stackoverflow.com (this website has helped me lots!) I found I needed add includeantruntime="false"

first find the line (was on line 22):
```
<javac target="1.5" destdir="build/WEB-INF/classes" srcdir="src" classpathref="java.classpath" />
```
and add the code above so it should look like:
```
<javac includeantruntime="false" target="1.5" destdir="build/WEB-INF/classes" srcdir="src" classpathref="java.classpath" />
```
If the build works I think it is safe to say the import has worked!

## Simple Folder Notes ##

I have seen some notes (I think in Ant) explaining some incompatibilities with some MS Windows versions where long path names do not work!  As I use Xampp, which also recommended installing outside /Program Files/, I created a Java folder in Xampp, and put the bodgeit store it there, the full path I used is c:\xampp\java\bodgeit\.  You must keep it simple; just letters and numbers, under 8 characters long and no space.  This should only effect some windows systems and should not be a problems for imports, however now aware of this potential problems,  I personally would like to play it safe as I can imagine wasting a bit of time if it does effect me.