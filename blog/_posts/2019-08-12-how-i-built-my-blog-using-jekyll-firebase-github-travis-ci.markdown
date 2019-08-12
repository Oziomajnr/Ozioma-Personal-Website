---
layout:	post
title:	"How I built my blog using Jekyll, Firebase, Github and Travis CI"
date:	2019-08-12
---

I recently decided to write my technical content on my personal blog instead of on Medium,
 but to write on your blog you need to have a blog 😀. So I decided to build one with the following requirements, 

1. I can easily manage the content and churn out new articles without having to write some HTML.
2. Free hosting (you cannot pay for everything 😁).
3. Custom domain name.
4. Should have TLS and certificate should be free.
5. Deploying new content should be easy.

I searched around some possible options like Wordpress, Drupal, etc... 
 they did not really meet my expectations so I decided to check out the personal blog of some developers, 
 I found  [Jake Whartson's Blog](https://jakewharton.com/blog/) and [Chris Bane's blog](https://chris.banes.dev) 
 interesting because of the simple style and then I saw an article on how Chris had built his using a tool called 
 [Jekyll](https://jekyllrb.com) which is a tool that builds your blog as static web pages, this sounded cool because 
 I had built my business card web page [http://oziomaogbe.com](http://oziomaogbe.com) as a simple static site and I hosted it on 
 [Firebase Hosting](https://firebase.google.com/docs/hosting) for free and I was able to get free SSL certificates too,
  building the blog would not be any different, so I decided to go with that option. 
  I would build the blog using [Jekyll](https://jekyllrb.com/), host it on [Firebase](https://firebase.google.com/docs/hosting), 
  host the code for the website on Github (I could have used any Git service, like Bitbucket on Gitlab but
   I wanted to see my contributions grow on my public profile 😉). I had used [Tavis CI](http://travis-ci.org) for
    my  business card too so I decided to use it for deploying the blog to firebase anytime I push my changes to Github. 
<br/> <br/>
Lets get to the fun stuff
<br/><br/>
<p align="center">
 <img src="https://media1.giphy.com/media/mGuuaZ84ou7KM/giphy.gif" alt="Let's get to the fun">
</p>

<br/> <br/> <br/>
 <h2 align = "center"> Building the blog</h2>

1. ### Setting up Jekyll: 
	  The downside to Jekyll is that you have it know some coding to modify the layout of your blog,
	   but there are many [free Jekyll themes](https://jekyllthemes.io/free) available and this site is using one of them, 
	   also you have to write your blog posts as [Markdown](https://en.wikipedia.org/wiki/Markdown)
	    but with markdown editing tools like [Stack Edit](https://stackedit.io/app#) 
	     this is not any different than writing in Medium.com. 
	  To setup Jekyll you have to install it using [Ruby](https://www.ruby-lang.org/en/downloads/) 
	   you can do so by running the following commands 
	  ```bash
	  $  gem install bundler jekyll
      $  jekyll new my-awesome-site
      $  cd my-awesome-site
      $  bundle exec jekyll serve
      ```
      this would install Jekyll and build a sample jekyll site  and serve it at  http://localhost:4000
  you can create and edit your blog posts as markdown in the folder **_posts** in your website's home directory. 
  Here is a sample of what your website folder would look like  
  [Ozioma's Blog](https://github.com/Oziomajnr/Ozioma-Personal-Website/tree/master/blog), 
     you can edit metadata to your site using the config file in the home folder of the website.

2. ### Github:
	The code for the jekyll website is hosted in a
	 [Github Repository](https://github.com/Oziomajnr/Ozioma-Personal-Website/tree/master/blog).

3. Firebase: 
	I used [firebase hosting](https://firebase.google.com/docs/hosting) for hosting the blog since it is 
	just static content and firebase hosting is free and also gives you free SSL certificate, also deploying to 
	firebase hosting is quite easy, for information on how to set up firebase hosting you can check out the 
	[Docs](https://firebase.google.com/docs/hosting/quickstart).

4. Travis-CI: 
	I wanted easy and quick deployment of new content for the blog so I used  [Travis CI](http://travis-ci.org/) 
	hooked to the Github repository. Here is my travis `yaml` file
	
	```yaml
    language: ruby
    rvm: 2.4.1
    before_script:
      - cd blog
   script:
    - gem update --system
    - gem install bundler
    - bundler update --bundler
   - gem install jekyll bundler
   - JEKYLL_ENV=production bundle exec jekyll build --verbose
   - cd ..
    - ls
    deploy:
      skip_cleanup: true
      provider: firebase
	  token:
	    secure: "FIREBASE_CI_TOKEN"
    ```

This deployment setup handles both deploying to my business card website [http://oziomaogbe.com](http://oziomaogbe.com) 
and the blog 
[http://blog.oziomaogbe.com](http://blog.oziomaogbe.com) but since they are both hosted on the same Firebase 
project their deployment process is the same, we only had to make sure the Jekyll blog is built correctly and 
that is why we had the scripts 
```bash
cd blog
gem update --system
gem install bundler
bundler update --bundler
gem install jekyll bundler
JEKYLL_ENV=production bundle exec jekyll build --verbose
```
Travis handles the firebase deployment so I did not  have to explicitly  run the firebase deployment commands, 
I only had to supply the firebase json file 
[https://github.com/Oziomajnr/Ozioma-Personal-Website/blob/master/firebase.json](https://github.com/Oziomajnr/Ozioma-Personal-Website/blob/master/firebase.json) 
and generate a a CI token using 
```bash
firebase login:ci
```
and then encrypt the generated token using 

```bash
travis encrypt "GENERATED_FIREBASE_TOKEN" --add
```
this encrypts the firebase CI key and gives you a public key that you can use in your travis yaml file since that 
file is kind of public.

So that is it, next I would write about how I migrated my content from medium to my Jekyll blog.
<p align="center">
 <img src="https://media3.giphy.com/media/RJzYCmfSZt1CmiUyuU/giphy-downsized.gif" alt="It's over">
</p>

Let me know in the comments below if you tried it out and also if you had any issues in the comments below.
