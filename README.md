# Megaphone Server

The server-side code for [Megaphone Magazine's App](https://github.com/denimandsteel/megaphone-app-public), helps customers find and pay vendors on the streets of Vancouver and Victoria, BC. You can use this code under MIT license and make the necessary changes to make it work with your street paper and your city.

This backend service is built with Ruby on Rails.

## Prerequisites

You will need the following things properly installed on your computer or set up:

* [Git](http://git-scm.com/)
* [Ruby on Rails](http://rubyonrails.org/)
* [Stripe](https://stripe.com) Account
* [Amazon AWS](https://aws.amazon.com)
* [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging/)

## Installation

* `git clone <repository-url>` this repository
* change into the new directory
* `bundle install`

## Running / Development

* `rails server`

### Environment Variables
Make sure you have the following environment variables set up:

* Stripe: `STRIPE_PUBLISHABLE_KEY` and `STRIPE_SECRET_KEY`
* AWS and S3: `ACCESS_KEY_ID`, `SECRET_ACCESS_KEY`, `S3_REGION` and `S3_BUCKET`
* FCM: `FCM_ACCESS_TOKEN`

## Further Reading / Useful Links

* [Megaphone Magazine](http://www.megaphonemagazine.com/)
