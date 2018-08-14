Return-Path: <SRS0=HiQF=K5=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:49984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbeHOAy2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Aug 2018 20:54:28 -0400
Date: Tue, 14 Aug 2018 18:05:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 05/14] tools/lib/traceevent: Add prefix TEP_ to all
 members of nameless enum EVENT_FL_*
Message-ID: <20180814180513.457b128d@gandalf.local.home>
In-Reply-To: <20180810131732.24677-6-tz.stoyanov@gmail.com>
References: <20180810131732.24677-1-tz.stoyanov@gmail.com>
        <20180810131732.24677-6-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


FYI,

I renamed the subject to:

 tools/lib/traceevent: Add prefix TEP_ to all EVENT_FL_* flags

-- Steve


On Fri, 10 Aug 2018 16:17:23 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> In order to make libtraceevent into a proper library, variables, data
> structures and functions require a unique prefix to prevent name space
> conflicts. That prefix will be "tep_". This adds prefix TEP_
> to all members of nameless enum EVENT_FL_*
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tools/lib/traceevent/event-parse.c | 42 +++++++++++++++---------------
>  tools/lib/traceevent/event-parse.h | 18 ++++++-------
>  2 files changed, 30 insertions(+), 30 deletions(-)
> 
