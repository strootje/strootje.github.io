---
title: About Me
categories: personal
---

Hi, as can be read in [this][post:an-introductory-of-myself] post, I'm Bas. A Software engineer with a clear vision on software and how a team should operate. My friends would tell you that I'm very much focused on furthering my personal development and that I'm a life hacker. I believe this is backed up by my sense of curiosity and drive to explore and engage in new activities wherever I can in life. I love sharing my findings with others and helping them improve as well, nothings beats seeing that *click* in someones eyes just as they get something right.

{{< tag-cloud categories="devlog" caption="My skills as seen through this blog" >}}

{{< timeline >}}

	{{< timeline-stop title="present" >}}

		{{< timeline-plot title="Lead Developer @ PGGM" class="is-primary" >}}
			My resposibilities range from helping my team in architectual design decisions, rebooting a server when needed and even helping resolve quarrels between us and other teams over code review comments. As Lead, I mainly help the team improve in their CI and CD goals.
		{{< /timeline-plot >}}

	{{< timeline-stop title="2017" >}}

		{{< timeline-plot title="Senior Engineer @ DotControl" >}}
			Responsible for the development of the [Eventler][eventler] ticketing software. This included the online web system as well as the offline ticket scan module. I used my knowledge of GIT to help DotControl get a better grip on on their releasing strategy by using a simplified version of githubflow. This also enabled my to, with the help of jenkins en later bitbucket pipelines, to setup an simple CI street with automated testing. To facilitate more regular releases we used an Microsoft Azure environment with a live instance and a staging instance which we could swap around at any point
		{{< /timeline-plot >}}

		{{< timeline-plot title="Intern @ DotControl" >}}
			My assignment was to R&D an offline ticketing module that could be used to handle large volumes of guests at once without an internet connection. The modules use the local network to communicate with eachother in order to keep track of which instance handled which guests. They are also capable of sending their data back to a single central server.
		{{< /timeline-plot >}}

{{< /timeline >}}

[post:an-introductory-of-myself]: {{< relref "posts/an-introductory-of-myself.md" >}}
[eventler]: https://eventler.nl
