We want your help to make our project great.
There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things.

* [The Hydra Way](#the-hydra-way)
* [Reporting Issues](#reporting-issues)
  * [What is a well written issue?](#what-is-a-well-written-issue)
* [Git Flow Branching Strategy](#git-flow-branching-strategy)
  * [Git Flow Resources](#git-flow-resources)
  * [Why Git Flow?](#why-git-flow)
  * [Possible Gotchas](#possible-gotchas)
* [Making Changes](#making-changes)
  * [Where to Engage for Help](#where-to-engage-for-help)
* [Submitting Changes](#submitting-changes)
  * [Contributor License Agreement](#contributor-license-agreement)
  * [Coding Guidelines](#coding-guidelines)
    * [Writing Your Specs](#writing-your-specs)
      * [Custom Rspec Matchers](#custom-rspec-matchers)
    * [Writing Your Code](#writing-your-code)
    * [Ruby File Structure](#ruby-file-structure)
  * [Well Written Commit Messages](#well-written-commit-messages)
    * [Hooks into JIRA](#hooks-into-jira)
    * [Hooks into other Subsystems](#hooks-into-other-subsystems)
* [Reviewing Changes](#reviewing-changes)
  * [Responsibilities of a Reviewer](#responsibilities-of-a-reviewer)
  * [Responsibilities of the Submitter](#responsibilities-of-the-submitter)
* [Merging Changes](#merging-changes)

# The Hydra Way

We strive to…

* Provide a [harassment-free community experience](https://wiki.duraspace.org/display/hydra/Anti-Harassment+Policy)
* Adhere to our [Hierarchy of Promises](https://wiki.duraspace.org/display/hydra/Hydra+Stack+-+The+Hierarchy+of+Promises)
* Operate under [Lazy Consensus](http://rave.apache.org/docs/governance/lazyConsensus.html)
* Encourage community participation as guided by [our community principles](https://wiki.duraspace.org/display/hydra/Hydra+Community+Principles)

# Reporting Issues

Submit a [well written issue](#what-is-a-well-written-issue) to [Github's issue tracker](./issues).
This will require a [GitHub account](https://github.com/signup/free) *(its free)*.

## What is a well written issue?

* Provide a descriptive summary
* Reference the gem version in which you encountered the problem
* Explain the expected behavior
* Explain the actual behavior
* Provide steps to reproduce the actual behavior

# Git Flow Branching Strategy

We use [Git Flow](https://github.com/nvie/gitflow) as our branching procedure.
We acknowledge that this adds additional complexities to the branching process.
It is our belief that the project's code health is better for these complexities.

## Preparing My Local Repository

Assuming you are using the [git-flow extension to git command line tools](https://github.com/nvie/gitflow), you will need to append the following to your `.git/config` file in your local repository.

```git
[gitflow "branch"]
  master = master
  develop = develop
[gitflow "prefix"]
  feature = feature/
  release = release/
  hotfix = hotfix/
  support = support/
  versiontag = v
```

The above was generated via `$ git flow init`

## Git Flow Resources

* [Initial proposal for Git Flow at nvie.com's blog](http://nvie.com/posts/a-successful-git-branching-model/)
* [Install git-flow extension for command line git](https://github.com/nvie/gitflow#installing-git-flow)
* [git-flow cheatsheet](http://danielkummer.github.io/git-flow-cheatsheet/) - a nice infographic style cheatsheet
* [Atlassian's SourceTree](http://www.sourcetreeapp.com/) - a free Git GUI that supports git-flow

## Why Git Flow?

The **master** branch should **always be deployable**…
And therefore anyone cloning the repository will have a vetted version of the project to work against.

**Urgent fixes** should be quick to apply…
And therefore anyone that has adopted this repository can quickly apply those fixes.

**Completed features** should be released as one unit…
And therefore an adopter does not see portions of an incomplete feature in their latest point release.

The git-flow process **is a well defined procedure**…
And therefore anyone contributing to the project can reference excellent 3rd party resources on the procedure.

The git-flow process **is encoded in a [Git extension](https://github.com/nvie/gitflow)**…
And therefore anyone contributing to the project can use the plugin to adhear to the branching procedure.

And best of all, **we don't have to write our own procedure** that would require additional vetting.

## Possible Gotchas

With Git Flow, releases are minted on the master branch.
It is likely that releases may need to be minted relative to a past release (i.e. need to back port an urgent fix).
At that point we will need to create a version stable branch to apply urgent fix.

# Making Changes

Hydra is an open source project, released under the [APACHE 2 license](LICENSE).
You are free to clone or [fork the repository](https://help.github.com/articles/fork-a-repo) and modify the code as you see fit.

## Where to Engage for Help

This gem is part of ProjectHydra, so you can [connect via the usual ProjectHydra channels](https://wiki.duraspace.org/display/hydra/Connect).

# Submitting Changes

## Contributor License Agreement

**Note: You can submit a pull request before you've signed the Contributor License Agreement, but we won't merge your changes until we have your CLA on file.**

Before any [ProjectHydra project](https://github.com/projecthydra) can accept your contributions we must have a [Contributor License Agreement on file](https://wiki.duraspace.org/display/hydra/Hydra+Project+Intellectual+Property+Licensing+and+Ownership).

All code contributors must have an Individual Contributor License Agreement (iCLA) on file with the Hydra Project Steering Group.
If the contributor works for an institution, the institution must have a Corporate Contributor License Agreement (cCLA) on file.

[More on the Contributor License Agreements](https://wiki.duraspace.org/display/hydra/Hydra+Project+Intellectual+Property+Licensing+and+Ownership)

## Coding Guidelines

The [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide) is an excellent resource for how to craft your Ruby code, in particular the [Naming section](https://github.com/bbatsov/ruby-style-guide#naming).

Your code changes should include support tests.

**Can I break these guidelines?** Yes. But you may need to convince the person merging your changes.

### Writing Your Specs

Before you begin writing code, think about the test that will verify the code you plan to write.
A [well written story with Gherkin syntax](http://pivotallabs.com/well-formed-stories/) can help formulate the pre-conditions (Given), invocation (When), and post-conditions (Then).

*This is the first step of Test Driven Development, and something that we strongly encourage.*

Now write that test; It should be your guidepost for any changes you plan on making.
Ideally the test you just wrote will be executable code.
However, a well formed Gherkin-syntax story is a suitable proxy; Especially if you are uncomfortable with where to put the executable code.

*Think of your written test as a statement of intent.*
*The statement of intent can then be used when asking for help or clarity; Either from another developer or a stakeholder.*
*Someone helping you can then see both what you are trying to do and how you are doing it; And that helper may know of a "better" way to do it.*

#### Custom Rspec Matchers

We encourage the use of [custom rspec matchers](https://www.relishapp.com/rspec/rspec-expectations/v/2-3/docs/custom-matchers/define-matcher) as this helps our specs better convey what is going on.

To find the existing Rspec matchers in this project, you can run `rake spec:show_matchers`.
Below is the sample output.

```shell
be                 /path/to/bundled/gem/rspec-expectations-2.14.4/lib/rspec/matchers.rb:221
be_a               /path/to/bundled/gem/rspec-expectations-2.14.4/lib/rspec/matchers.rb:227
be_a_kind_of       /path/to/bundled/gem/rspec-expectations-2.14.4/lib/rspec/matchers.rb:253
be_a_new           /path/to/bundled/gem/rspec-rails-2.14.0/lib/rspec/rails/matchers/be_a_new.rb:73
be_an              /path/to/bundled/gem/rspec-expectations-2.14.4/lib/rspec/matchers.rb:227
be_an_instance_of  /path/to/bundled/gem/rspec-expectations-2.14.4/lib/rspec/matchers.rb:240
...
```

### Writing Your Code

We are going to do our best to follow [Sandi Metz' Rules for Developers](http://robots.thoughtbot.com/post/50655960596/sandi-metz-rules-for-developers)

> Here are the rules:
>
> * Classes can be no longer than one hundred lines of code.
> * Methods can be no longer than five lines of code.
> * Pass no more than four parameters into a method. Hash options are parameters.
> * Controllers can instantiate only one object. Therefore, views can only know about one instance variable and views should only send messages to that object (@object.collaborator.value is not allowed).

### Ruby File Structure

* Use soft-tabs with a two space indent.
* Never leave trailing whitespace (unless it is meaningful in the language)
* End each file with a blank newline.
* Please do your best to keep lines to 80 characters or fewer.

## Well Written Commit Messages

**TL;DR**

* First line is < 50 characters
* The message body explains what the code changes are about
* Reference any JIRA or Github issues on new lines.

### Terse Example

```
    Removing Document title validation

    We thought we wanted title validation but that was too complicated.

    HYDRASIR-12 #close
```

### Verbose Example

```
    Present tense short summary (50 characters or less)

    More detailed description, if necessary. It should be wrapped to 72
    characters. Try to be as descriptive as you can, even if you think that
    the commit content is obvious, it may not be obvious to others. You
    should add such description also if it's already present in bug tracker,
    it should not be necessary to visit a webpage to check the history.

    Description can have multiple paragraphs and you can use code examples
    inside, just indent it with 4 spaces:

        class PostsController
          def index
            respond_with Post.limit(10)
          end
        end

    You can also add bullet points:

    - you can use dashes or asterisks

    - also, try to indent next line of a point for readability, if it's too
      long to fit in 72 characters
```

> When appropriate, please squash your commits into logical units of work.
> This simplifies future cherry picks, and also keeps the git log clean.

### Hooks into JIRA

Our [JIRA Scrum Story Tracker at Duraspace](https://jira.duraspace.org/secure/RapidBoard.jspa?rapidView=16) has been setup to interact with GitHub.

First, make sure that [your JIRA Profile's](https://jira.duraspace.org/secure/ViewProfile.jspa) email address is the same as is in your Git config email address – run `git config user.email`

Then when writing your commit message, add the identifiers of any related tasks (i.e. HYDRASIR-12) in the body of the commit message.

You can also transition a JIRA task via your commit message.
Assume the following was part of the commit message:

```bash
HYDRASIR-12 #close "Append the quoted text as a comment on the task"
```

This would:

* Transition, if valid, the HYDRASIR-12 task to the Closed state.
* Add "Append the quoted text as a comment on the task" as a comment on HYDRASIR-12


#### Valid Transition Commands

* start-work
* start-review
* stop-work
* close
* reopen

[Additional information about processing JIRA issues with commit messages](https://confluence.atlassian.com/display/BITBUCKET/Processing+JIRA+issues+with+commit+messages)

### Hooks into other Subsystems

**[log skip]**: If your commit is not relevant to a change log, you can add `[log skip]` to your commit message.
Relevance is subjective, though extremely minor changes need not be part of the change log (i.e. spelling correction, decomposing a private method into multiple private methods, etc.)

**[ci skip]**: If your commit does not need to go through the Continuous Integration server, add `[ci skip]` to your commit message.
This is typically used for updates to the documentation and stylesheet changes.

# Reviewing Changes

The review process is a conversation between the submitter and the team as a whole.
Please feel free to bring other people into the conversation as necessary.

As either the submitter or reviewer, feel free to assign the Pull Request to a repository contributor.
This is a way of indicating that you want that repository contributor to review the change.

When you do assign someone to the Pull Request, please make sure to add a comment stating why you assigned it to them.

## Responsibilities of a Reviewer

As a reviewer, it is important that the pull request:

* Has a (well written commit message)[#well-written-commit-messages]
* Has (well written code)[#coding-guidelines]
* The test suite successfully builds
* Any questions regarding the pull request are answered
* Adjucate if the Pull Request should be squashed into a smaller number of commits

## Responsibilities of the Submitter

**As the submitter**, you should be responsive to the review process: answering questions, making refinements, providing clarification, and rebasing your commits.
*If your changes are gridlocked please notify [@jeremyf](https://github.com/jeremyf) via a comment on the pull request.*

# Merging Changes

*If a pull request has received at least one Thumbs Up, but has still not been merged, please notify [@jeremyf](https://github.com/jeremyf) via a comment on the pull request.*

**As the submitter,** you should not merge your own pull request. That is bad form.

**As the reviewer,** if you are comfortable merge the pull request. Otherwise feel free to assign the pull request to another contributor for final merging.

**As the merger,** once you have merged the pull request, go ahead and delete the pull request's topic branch. You are now on the hook for any breaking of the build.

