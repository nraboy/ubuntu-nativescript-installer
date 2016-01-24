[![PayPal](https://img.shields.io/badge/paypal-donate-yellow.svg)](https://paypal.me/nraboy)
[![Square](https://img.shields.io/badge/square-donate-yellow.svg)](https://cash.me/$nraboy)


# Ubuntu NativeScript Installer

Installs Android, Java JDK, Node.js, and Telerik NativeScript on Ubuntu x64 architectures.  Tested with Ubuntu 14.04 Trusty Tahr, but should work with anything greater.

## Usage

After cloning the repository or downloading the project, using your Terminal, navigate into the project directory.  You'll need to give the script execute permission in case GitHub stripped it out.  This can be done by running the following in the Terminal:

```
chmod +x ubuntu_nativescript_installer.sh
```

With the script having execute permission, execute the script by running:

```
sudo ./ubuntu_nativescript_installer.sh
```

A few things to note here:

1. It is very important you **are not** logged into the root user account of your operating system
2. You need to use sudo from your regular account
3. NativeScript will ask you two questions at the end of the script making this script not completely automated

When finished, you will be able to build NativeScript applications without additional steps required.

## Contribution Rules

All contributions must be made via the `development` branch.  This keeps the project more maintainable in terms of versioning as well as code control.

## Have a question or found a bug (compliments work too)?

Tweet me on Twitter - [@nraboy](https://www.twitter.com/nraboy)

## Resources

Telerik NativeScript - [http://www.nativescript.org](http://www.nativescript.org)

Node.js - [http://www.nodejs.org](http://www.nodejs.org)

Android - [http://developer.android.com](http://developer.android.com)
