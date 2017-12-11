The BodgeIt Store is a vulnerable web application which is currently aimed at people who are new to pen testing.

> ### Please note that The BodgeIt Store is no longer being worked on
> #### You are strongly recommended to use [OWASP Juice Shop](https://www.owasp.org/index.php/OWASP_Juice_Shop_Project) instead!

Note that the BodgeIt Store is now available as a Docker image: https://hub.docker.com/r/psiinon/bodgeit/ 

Some of its features and characteristics:
* Easy to install - just requires java and a servlet engine, e.g. Tomcat
* Self contained (no additional dependencies other than to 2 in the above line)
* Easy to change on the fly - all the functionality is implemented in JSPs, so no IDE required
* Cross platform
* Open source
* No separate db to install and configure - it uses an 'in memory' db that is automatically (re)initialized on start up

All you need to do is download and open the zip file, and then extract the war file into the webapps directory of your favorite servlet engine.

Then point your browser at (for example) http://localhost:8080/bodgeit

You may find it easier to find vulnerabilities using a pen test tool.

If you dont have a favourite one, I'd recommend the [Zed Attack Proxy](https://www.owasp.org/index.php/ZAP) (for which I'm the project lead).

The Bodge It Store include the following significant vulnerabilities:
* Cross Site Scripting
* SQL injection
* Hidden (but unprotected) content
* Cross Site Request Forgery
* Debug code
* Insecure Object References
* Application logic vulnerabilities If you spot any others then let me know ;)

There is also a 'scoring' page (linked from the 'About Us' page) where you can see various hacking challenges and whether you have completed them or not.

In the relatively near future I'm hoping to add things like:
* Ajax requests
* More vulnerabilities (of course)

You can now also perform automated security regression tests on the Bodge It Store - see the wiki.

Any feedback (or offers of help to develop it further;) would be appreciated.
