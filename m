Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:38570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727349AbeKIMQM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Nov 2018 07:16:12 -0500
Date: Thu, 8 Nov 2018 21:37:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 8/8] kernel-shark-qt: Update Sched Events plugin
Message-ID: <20181108213740.4d638565@vmware.local.home>
In-Reply-To: <20181108213527.78b5cba3@vmware.local.home>
References: <20181107161410.22507-1-ykaradzhov@vmware.com>
        <20181107161410.22507-9-ykaradzhov@vmware.com>
        <20181108213527.78b5cba3@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 8 Nov 2018 21:35:27 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 7 Nov 2018 16:14:40 +0000
> Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> 
> > This patch updates the Sched Events plugin to use the recently
> > introduced "Missed events" entries and tot_count field of the
> > Visualization model descriptor in its plotting logic.
> >   
> 
> I also noticed that it appears that you are drawing the red box for
> every sched switch. The red box is only suppose to be drawn if the
> previous state is R. The red box should not be drawn for any other
> state (because they were blocked, and not preempted).
> 

In other words, a red box should never connect to a green one.

-- Steve
