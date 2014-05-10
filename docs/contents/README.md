
# Koding Framework Documentation: Source

Welcome to the source for the [Koding][0] Framework Documentation. This is the
*source* for the Koding Framework Documentation. This is generally only
interesting for contributors.

If you're looking for the documentation, it is available in the
[https://koding.com/APPNAME][1] App.

## Contributing

Contributing to the documentation is encouraged! We do ask that you adhere to
the following guidelines so that everything works properly when loaded into
APPNAME.

## Formatting

The formatting of the documentation is subject to change since the viewing
application is not done yet, however the basic points are as follows.

### Directory Index

All directories should come with an index page, which effectively serves as the
`index.html` page.

### Local URLs

Because these markdown files will be loaded into a Koding Application and viewed
from Koding, your URLs to documents within this document should not include a
full path to this repository. Below are two examples.

#### Bad

```markdown
... the
[KDObject](https://github.com/koding/kdfdocs/blob/master/api/core/object.coffee)
object is the base ...
```

In this example, if a user clicked the *KDObject* link they would be sent from
Koding, to Github. This navigation away from Koding is undesired in the UX.

#### Good

```markdown
... the [KDObject](./api/core/object.coffee) object is the base ...
```

In this example we got rid of all the http junk, so the link is local to
Koding. Now if a user clicks it, they'll go to the item that they wanted to,
rather than going to the raw source for the document. Huzzah!

### Static Resources

Because Koding uses HTTPS for all users, if you link to plain HTTP images on
Koding they will fail to load and throw warnings about unsafe content.

So, for now, link all embedded images to their absolute paths on Github,
**with HTTPS**. This ensures that the image is secure, and everything is happy.



[0]: https://koding.com
[1]: https://koding.com/APPNAME
