# Regression Tests #

There are some basic Selenium regression tests that can be run using the Ant 'test' task in http://code.google.com/p/bodgeit/source/browse/trunk/build.xml

# Security Regression Tests #

Of more interest are likely to be the related security regression tests.

The security regression tests show you how you can use the [Zed Attack Proxy](https://code.google.com/p/zaproxy/downloads/list) (ZAP) to wrap your existing functional tests in order to perform automated security tests.

Note that no automated security tests will find all of the vulnerabilities in your applications.

However using ZAP in this way means that you can include basic security tests in your continuous integration framework and be alerted to potential security vulnerabilities within hours of checking your code in.

In order to run these you need to
  1. Download and install Eclipse (if you havnt already)
  1. Checkout the Bodge It Store as an Eclipse project (TODO: describe in more detail;)
  1. Download and install the [Zed Attack Proxy](https://code.google.com/p/zaproxy/downloads/list)
  1. Download the ZAP Client API (same directory as above), it will be named like ZAP\_Client\_API_`<version>`.zip
  1. Extract all of the jars from it and add them to the 'Ant Home Entries'.
    * To get there: Windows / Preferences / Ant / Runtime
  1. Install the bodgeit.war file in your servlet engine
  1. Start your servlet engine
  1. Run the 'zap-test' task in http://code.google.com/p/bodgeit/source/browse/trunk/build.xml_

Please note that these tests are at a very early stage.

If you have any problems, questions or suggestions then please report them via the [Issues](https://code.google.com/p/bodgeit/issues/list) page.