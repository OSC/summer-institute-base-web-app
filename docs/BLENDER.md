# Blender App to render Movies

This document walks through the different stages you'll need to go through
to create a web app that can render frames and movies.

It attempts to break features out into stages where each stage is a
single commit.  You can use any given commit as an reference point
for your own implementation.

Each section has a link to the reference commit as well as the commit
message.

## New Frame Render

First, we'll add this web page and it's route.

It should start out as a very simple webform that submits a very
simple batch job.

**Start the new projects page**

This commit gives us a very simple page to create projects
and the controller to accept a POST.

`add a simple page for new projects`

https://github.com/OSC/summer-institute-base-web-app/commit/c4370557a41e39d9bebf5882210fcfd0ca21928d

**Actually create the project directory**

This commit actually creats the project directory and starts a
`projects#show` page.  Note that `/projects/new` changes to `/projects/:dir`
(`:dir` being a variable) and there's a special case when `:dir` is `new`.

`actually create the directory and add a project#show`

https://github.com/OSC/summer-institute-base-web-app/commit/96af7461ca4bdee433b6befabb204a392693c599


**Update the index to list all the projects**

This commit updates the index to list out all the projects.

`update the index to list out all the projects`

https://github.com/OSC/summer-institute-base-web-app/commit/d01a292340fed0fa362263a5b07fc5f356f1f7ff


**Start the frame render form and the controller action**

This commit starts the form on the `job` page to start a rendering job.
it also adds a very simple controller to accept a POST request.

`add a project form to render frames and the post method`

https://github.com/OSC/summer-institute-base-web-app/commit/7649c6578684f3297339e05a1cc018e2900945a4


**Run the job to render frames**

This commit adds the ability to actually submit the job that renders
frames.

`submit the job to render frames`

https://github.com/OSC/summer-institute-base-web-app/commit/2d04f44f8efd52fe45a002ba55502a71144ad8e7

**Add Image Carousel**

This commit adds a carousel of images to the project page. The images
are from the frame render jobs.

`enhance project#show to have an image carousel`

https://github.com/OSC/summer-institute-base-web-app/commit/1a0b706bee372881e21f750857bfa88fed1c8b40


**Automatically update carousel**

This commit adds javascript to automatically update the image carousel
as the job runs.

`add javascript to update carousel automatically`

https://github.com/OSC/summer-institute-base-web-app/commit/745aa97451bcd05fb0accb04b01b76fccb7b79e2


**Render a Video**

This commit adds adds the ability to submit a job that will take all the
images you have and generate an `mp4` video file.

`add ability to render a video`

https://github.com/OSC/summer-institute-base-web-app/commit/61bbf9c1bd91c5a86d23113e4cfe6337d6813967
