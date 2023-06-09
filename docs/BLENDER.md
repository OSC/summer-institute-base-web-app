# Blender App to render Movies

This document walks through the different stages you'll need to go through
to create a web app that can render frames and movies.

It attempts to break features out into stages where each stage is a
single commit.  You can use any given commit as an reference point
for your own implementation.

Each section has a link to the reference commit as well as the commit
message.

## 1. Start the new projects page.

The first step is to create a `projects#new` page for creating
new projects.

The action to create a project doesn't do anything yet, this simply
lays the groundwork for that action.

`add a simple page for new projects`

https://github.com/OSC/summer-institute-base-web-app/commit/4e9844272f9938b66fbaf2fcfa3c2100aed74693

## 2. Actually create the project directory.

Now that we have the groundwork for creating projects - this
step actually creates the project directories on the file system.

It also starts a `projects#show` page that will be the base for other
steps.

Note that `/projects/new` changes to `/projects/:dir`
(`:dir` being a variable) and there's a special case when `:dir` is `new`.

`actually create the directory and add a project#show`

https://github.com/OSC/summer-institute-base-web-app/commit/26cdb8ec4430653af431f70f2b3a3859a245797d


## 3. Update the index to list all the projects.

Now that we can create projects, we need `projects#index` to list
them all out so that we can navigate to and from them.

This step does just that - it updates `projects#index` to show
all the projects that have been created up to this point.

`update the index to list out all the projects`

https://github.com/OSC/summer-institute-base-web-app/commit/097140de409f9496e3ad4e142dd276d85b0ab349


## 4. Start the frame render form and the controller action.

Now that we can create projects and can navigate to and from them,
this is where the real work of the app starts.  We need to actually
submit a job that will render frames from a blend file.

This step starts that work. It provides a page that users can fill out
to submit a job with various settings like how many frames they want to
render from which blend file and so on.

It does not submit the job, only starts the form that will submit the
job in the next step.

`add a project form to render frames and the post method`

https://github.com/OSC/summer-institute-base-web-app/commit/c7af82875a19cd09d1e606734a101102890dea5f


## 5. Run the job to render frames.

With step 4 complete, step 5 is to actually submit a job that will
render frames.

`submit the job to render frames`

https://github.com/OSC/summer-institute-base-web-app/commit/02419155944ef8479872aaadfddade841c667ada

## 6. Add image carousel.

Now that we can submit jobs, step 6 adds an image carousel to the `projects#show`
page so that users can see the output of the render job.

`enhance project#show to have an image carousel`

https://github.com/OSC/summer-institute-base-web-app/commit/e0fd971505860eb1723443c2f9f7cb19203f30dc


## 7. Automatically update carousel.

Having the carousel is great, but in step 6 to update it users have to
refresh the page. This is a poor user experience, so step 7 adds some javascript
to query the filesystem for new images. When there are new images from the rendering
job, the javascript will fetch it and add it to the page automatically without
having to refresh the page.

`add javascript to update carousel automatically`

https://github.com/OSC/summer-institute-base-web-app/commit/2d1f6b9190c1abe3a433a49e5ffd03107277e5b3


## 8. Render a video.

Now we have facilities to render frames which is great! However, frames
(images) are not the result we want. We want to bundle these frames into
a movie.

Step 8 creates another form for users to fill out to that will submit
another job that will create an `mp4` video file out of all the images
you've created.

`add ability to render a video`

https://github.com/OSC/summer-institute-base-web-app/commit/3320ba8665a371cf8a81d1c89f79512f45147f79

## 9. Extra credit and beyond.

Congratulations! At this point you're done. But, like anything else, there's always
more to do. Here are a couple examples of things you can add to this application.

* Add the ability to request multiple nodes instead of just 1.  This way rendering
  frames can go much quicker becuase you'll be able to use more cores than any one
  machine has.
    * Hint: Break the problem up! Instead of rendering `1..100` frames on a single
      machine, get the program to render `1..50` on one machine and `51..100` on
      the other.  The environment variable `SLURM_ARRAY_TASK_ID` will be a different
      number for each machine you've requested.
* Add the ability to change the project icon. Right now, every project icon in `projects#index`
  is a camera (it's an icon - `i` - tag with `fas fa-fw fa-camera fa-5x` CSS classes).
  Make this configurable so that when you create a new project, you get to choose the icon.
    * Hint: google fontawesome for the entire list of icons you can use.