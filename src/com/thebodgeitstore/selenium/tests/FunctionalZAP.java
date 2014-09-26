/*
 * The BodgeIt Store and its related class files.
 *
 * The BodgeIt Store is a vulnerable web application suitable for pen testing
 *
 * Copyright 2011 psiinon@gmail.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.thebodgeitstore.selenium.tests;

import org.openqa.selenium.Proxy;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.remote.CapabilityType;
import org.openqa.selenium.remote.DesiredCapabilities;

public class FunctionalZAP extends FunctionalTest {

	public void setUp() throws Exception {
		String target = System.getProperty("zap.targetApp");
		if (target != null && target.length() > 0) {
			// Theres an override
			setSite(target);
		}

		Proxy proxy = new Proxy();
		proxy.setHttpProxy(System.getProperty("zap.proxy"));
		
		// We use firefox as an example here.
		DesiredCapabilities capabilities = DesiredCapabilities.firefox();
		capabilities.setCapability(CapabilityType.PROXY, proxy);

		// You could use any webdriver implementation here
		WebDriver driver = new FirefoxDriver(capabilities);
		this.setDriver(driver);
	}

	public static void main(String[] args) throws Exception {
		FunctionalZAP test = new FunctionalZAP();
		test.setUp();
		test.testAll();
		test.tearDown();
		
	}


}
