
# Imahen - iOS Image Filter App

## Overview



*Imahen* -- Tagalog for "image" or "visual representation" of something

I created this app to explore the uses of common image effects used in CoreImage. I also leverage Metal kernels to perform popular image processing techniques on the device's GPU. Along the way, I also intend to make the user experience intuitive, similar to Instagram's photo editing interface.

## Product Spec

### User Stories (Required and Optional)

**Required Must-have Stories**

- [x] User can use photos taken from camera or photo library for filtering
- [x] User can apply a filter or image processing technique to a given image
- [ ] User can apply multiple filters one after the other
- [ ] User can compare original and filtered images when pressing on the preview
- [ ] User can adjust filter intensity when applying to image
- [ ] User can save to gallery or share to third-party apps

**Optional Nice-to-have Stories**

- [ ] User can see a history of which filters they've applied (sort of like a copy/paste clipboard or previously visited browser pages in a tab)

### Supported and Planned Filters
#### Filters
- [x] Grayscale Noir
- [x] Sepia
#### Enhance
- [ ] Brightness
- [ ] Contrast (using histogram equalization)
- [ ] Smoothing (using Gaussian blurring)
- [ ] Sharpening
#### Advanced (using Metal shaders)
- [ ] Gradient w.r.t. x-axis
- [ ] Gradient w.r.t. y-axis
- [x] Sobel edge detection filter
- [ ] Canny edge detection filter
- [ ] Otsu binarization

### GIF Demo Walkthrough

![imahen-demo-1](https://i.imgur.com/gLSCpPU.gif)


### Data Model
`Imahen Filter`

| Property | Data Type | Desc|
| -------- | -------- | -------- |
| name    | String?  | name of filter / img proc. scheme    |
| filter     | CIFilter?     |    |
| key     | String?     | Specifies which property to change in CIFilter     |
| threshold     | CGFloat?     | 0.0 to 1.0,  typically used for filter intensity     |
| filterType     | FilterType     | `.coreImage` or `.metal`     |


### Some things I learned along the way
I anticipated for this app to be super simple in complexity, however I found it very useful to tap into my OOP knowledge. Even though by nature UIKit is object-oriented based and relies on keeping track of parent/children classes like Views and ViewControllers, it was interesting to practice it on the very classes I made for my specific use case. Not only was it super helpful to utilize structs/classes to create data models, but also keeping in mind *inheritance/subclassing* and *method overriding* when creating the user experience for applying filters.  
