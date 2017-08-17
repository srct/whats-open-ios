

What's Open for iOS
===

Simple iOS app to ingest the What's Open API, cache its contents in a local datastore and display it in a user friendly way. Plans to take advantage of iPhone specific technologies not available to the web.



On Contributing
---

WhatsOpeniOS welcomes all the help it can get. Even if you don't feel like you can be helpful the more technical aspects, we definitely need designers, technical writers, and testers.

There are many things that can be done with this project (see the "To Do" section), but sometimes it's the small things that count, so don't be afraid of contributing just a small spelling mistake.

If you need help at all please contact and SRCT member. We want people to contribute, so if you are struggling, or just want to learn we are more than willing to help.

The project manager for this project is **Eyad Hasan**. *ehasan3@gmu.edu*

Please visit the [SRCT Wiki](http://wiki.srct.gmu.edu/) for more information on this and other SRCT projects, along with other helpful links and tutorials.


Setup
---

Requirements: 

To get started, you'll need the following installed:
* [Git](http://git-scm.com/book/en/Getting-Started-Installing-Git)

* The latest **public** build of [Xcode](https://developer.apple.com/xcode/) (and a compatible Mac). *Currently Xcode 8* (You can get this from the [Mac App Store](https://itunes.apple.com/us/app/xcode/id497799835?mt=12) if you want easy updates)

* The latest **public** release of Swift. *Currently Swift 3.0* (bundled with Xcode)

* Cocoapods, for dependency management. You can install this by running `sudo gem install cocoapods` in your terminal. (Dependency management may change in the future)


Open a terminal window and type in the following commands. This will create a local, workable copy of the project.
  ``bash``  
  ``git clone [url]`` where the URL is the one listed at the top of the git repository for this project (preferrably using SSH)
  
Install the needed dependencies by running
  ``pod install``
inside the the WhatsOpen directory.

To work on the project, you will need to make sure to use the WhatsOpen.xcworkspace file, and NOT the .xcodeproj file. This allows us to use the dependencies that you installed.

You may need to choose your personal development team inside of Xcode on the project settings page. If you are not a registered Apple developer, you can do so at [developer.apple.com](https://developer.apple.com/)

Troubleshooting
---
* If you recieve and error similar to ``ld: framework not found Pods
clang: error: linker command failed with exit code 1 (use -v to see invocation)`` then check to make sure you opened ``WhatsOpen.xcworkspace`` and not ``WhatsOpen.xcodeproj``

To-do
---

Note-- this should also be on the wiki

About GMU SRCT
---
**S**tudent - **R**un **C**omputing and **T**echnology (*SRCT*, pronounced "circuit") is a student organization at George Mason University which enhances student computing at Mason. SRCT establishes and maintains systems which provide specific services for Mason's community.
