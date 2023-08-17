# CameraTok

![](https://badges.fyi/github/license/AndresR173/camera-tok)
![GitHub Build Status](https://github.com/AndresR173/camera-tok/workflows/Main/badge.svg)
[![codecov](https://codecov.io/gh/AndresR173/camera-tok/branch/main/graph/badge.svg?token=8H3F0HWP4M)](https://codecov.io/gh/AndresR173/camera-tok)

**Rediscover Your Memories Through Time**

## Getting Started

Clone the repo by running `git clone https://github.com/AndresR173/camera-tok.git` and build the project using Xcode 14.3.1

## Project details

The idea behind this project is to show your videos in an interesting way, like TikTok or Instagram Reels.

Following an approach of writing clean a readable code, this project tries to follow Protocol Oriented Programming for the services layer, and Domain Driven Design in the View Models, following these approaches we can write testable and maintainable code.

### Architecture

This project uses MVVM as architectural design pattern.

SwiftUI relies on the reactive paradigm, where the View Models are responsible for handling the business logic and emitting the different states that the views are listening to.

The View Model is the one that can connect with the different services provided by the app, such as GalleryService or PersistenceService.

#### Services

The project implements some services required for the app in order to present different videos to the user. Those services conform protocols that help the project test different layers like View Models.

- **AVPlayer:** This service returns a new instance of the AVPlayer component from AVFoundation framework
- **AVService:**  This service listens to AVSession in order to notify changes related to hardware controls, e.g: Volume up
- **GalleryService:** Responsible for requesting permissions to the user and fetch the videos from the gallery.
- **PersistenceService:** Used to store some value in the preferences of the app

## Third party dependencies

### [Lottie](https://github.com/airbnb/lottie-ios)

Used to show friendly messages and animations to the user
### [Dependencies](https://github.com/pointfreeco/swift-dependencies)

Dependency Injection is a concept that is being used to provide the dependencies that a component needs, providing modularity, testability and flexibility.
## Demo

https://github.com/AndresR173/camera-tok/assets/5528401/8eb59420-13fc-420c-8720-72420dfe8fad


License
 ----
MIT License

Copyright (c) 2023 Andres Rojas

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
