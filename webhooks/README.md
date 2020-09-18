# Webhooks

This script will listen for POST requests to the url: `/github/push-event`.

The Github repo has been configured with a webhook to POST to the above url
when a push event happens. This script then needs to trigger a new Docker image
build for the app.

//above has now been replaced with Docker Hub auto builds.
