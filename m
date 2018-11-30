Return-Path: <SRS0=EnxC=OJ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:46590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726644AbeLADWM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Nov 2018 22:22:12 -0500
Date: Fri, 30 Nov 2018 11:12:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Make Sched event plugin use its own data
 collections
Message-ID: <20181130111221.3823978e@gandalf.local.home>
In-Reply-To: <20181130154211.4575-1-ykaradzhov@vmware.com>
References: <20181130154211.4575-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 30 Nov 2018 15:42:35 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> These two patches aim to restore the log(n) time complexity of
> the latency plotting, by adding Data Collections for Sched events.
> 
> Steven, please try playing with this modification before applying it.
> If you can test this, when doing some real work this would be great.

This works awesomely!

Check out this screenshot:

  http://rostedt.org/private/ks-latency.png

The old way I could not see that huge wake up latency. Also, I noticed
that fsync got preempted (see the red square to the left).

I have to ask, how hard is it to click on the wakeup (the start of
the green box) and get the marker to go there? I can find it difficult
to measure because I can't get the marker to set to the start without
doing a search for the wakeup.

-- Steve


> 
> Yordan Karadzhov (2):
>   kernel-shark-qt: Add a method for adding a new collection to a list
>   kernel-shark-qt: Make Sched event plugin use its own data collections
> 
>  kernel-shark-qt/src/libkshark-collection.c  | 45 ++++++++++++++++++++-
>  kernel-shark-qt/src/libkshark.c             |  1 +
>  kernel-shark-qt/src/libkshark.h             |  9 +++++
>  kernel-shark-qt/src/plugins/SchedEvents.cpp | 33 ++++++---------
>  kernel-shark-qt/src/plugins/sched_events.c  | 21 ++++++++++
>  kernel-shark-qt/src/plugins/sched_events.h  |  6 +++
>  6 files changed, 93 insertions(+), 22 deletions(-)
> 
