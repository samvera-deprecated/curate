We want your help to make Curate great.
There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things.

* [Reporting Issues](#reporting-issues)
  * [What is a well written issue?](#what-is-a-well-written-issue)
* [Git Flow Branching Strategy](#git-flow-branching-strategy)
  * [Why Git Flow?](#why-git-flow)
* [Making Changes](#making-changes)
  * [Where to Engage for Help](#where-to-engage-for-help)
* [Submitting Changes](#submitting-changes)
  * [As a Developer](#as-a-developer)
    * [Hydra Project Intellectual Property Licensing and Ownership](#hydra-project-intellectual-property-licensing-and-ownership)
  * [As a ProjectHydra Contributor](#as-a-projecthydra-contributor)
  * [Well Written Commit Messages](#well-written-commit-messages)
    * [Hooks into JIRA](#hooks-into-jira)
      * [Valid Transition Commands](#valid-transition-commands)
    * [Hooks into other Subsystems](#hooks-into-other-subsystems)
* [Reviewing Changes](#reviewing-changes)
  * [Assigning the Pull Request](#assigning-the-pull-request)
* [Merging Changes](#merging-changes)
  * [As the Submitter](#as-the-submitter)
  * [As a Reviewer](#as-a-reviewer)
  * [As the Person doing the Merge](#as-the-person-doing-the-merge)

# Reporting Issues

Submit a [well written issue](#what-is-a-well-written-issue) to [Github's issue tracker](./issues).
This will require a [GitHub account](https://github.com/signup/free) *(its free)*.

## What is a well written issue?

* Provide a descriptive summary
* Reference the Curate gem version in which you encountered the problem
* Explain the expected behavior
* Explain the actual behavior
* Provide steps to reproduce the actual behavior

# Git Flow Branching Strategy

Curate uses [Git Flow](https://github.com/nvie/gitflow) as its branching procedure.
We acknowledge that this adds additional complexities to the branching process.
It is our belief that the project's code health is better for these complexities.

## Why Git Flow?

The **master** branch should **always be deployable**…
And therefore anyone cloning the Curate repository will have a vetted version of Curate to work against.

**Urgent fixes** should be quick to apply…
And therefore anyone that has adopted Curate can quickly apply those fixes.

**Completed features** should be released as one unit…
And therefore an adopter does not see portions of an incomplete feature in their latest point release.

The git-flow process **is a well defined procedure**…
And therefore anyone contributing to the project can reference excellent 3rd party resources on the procedure.

The git-flow process **is encoded in a [Git extension](https://github.com/nvie/gitflow)**…
And therefore anyone contributing to the project can use the plugin to adhear to the branching procedure.

And best of all, **we don't have to write our own procedure** that would require additional vetting.

# Making Changes

Curate is an open source project, released under the [APACHE 2 license](LICENSE).
You are free to clone or [fork the repository](https://help.github.com/articles/fork-a-repo) and modify the code as you see fit.

## Coding Guidelines

Will be brought in from [README](README)

## Where to Engage for Help

Curate is part of ProjectHydra, so you can [connect via the usual ProjectHydra channels](https://wiki.duraspace.org/display/hydra/Connect).

# Submitting Changes

## As a Developer

### Hydra Project Intellectual Property Licensing and Ownership
All code contributors must have an Individual Contributor License Agreement (iCLA) on file with the Hydra Project Steering Group.
If the contributor works for an institution, the institution must have a Corporate Contributor License Agreement (cCLA) on file.

https://wiki.duraspace.org/display/hydra/Hydra+Project+Intellectual+Property+Licensing+and+Ownership

## As a ProjectHydra Contributor

## Well Written Commit Messages

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

### Hooks into other Subsystems

**[log skip]**: If your commit is not relevant to a change log, you can add `[log skip]` to your commit message.
Relevance is subjective, though extremely minor changes need not be part of the change log (i.e. spelling correction, decomposing a private method into multiple private methods, etc.)

**[ci skip]**: If your commit does not need to go through the Continuous Integration server, add `[ci skip]` to your commit message.
This is typically used for updates to the documentation and stylesheet changes.

# Reviewing Changes

*If your changes are languishing without attention please notify [@jeremyf](https://github.com/jeremyf) via a comment on the pull request.*

## Assigning the Pull Request

As either the submitter or reviewer, feel free to assign the Pull Request to a Curate contributor.
This is a way of indicating that you want that contributor to review the change.

When you do assign someone to the Pull Request, please make sure to add a comment stating why you assigned it to them.

# Merging Changes

*If a pull request has received at least one Thumbs Up, but has still not been merged, please notify [@jeremyf](https://github.com/jeremyf) via a comment on the pull request.*

## As the Submitter

## As a Reviewer

## As the Person doing the Merge
