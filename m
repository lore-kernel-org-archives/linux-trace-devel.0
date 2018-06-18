Return-Path: <SRS0=txqx=JE=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:39380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752835AbeFRPYa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Jun 2018 11:24:30 -0400
Date: Mon, 18 Jun 2018 11:24:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/4] trace-filter: Change the naming convention used in
 trace-filter-hash
Message-ID: <20180618112427.4a5c318e@gandalf.local.home>
In-Reply-To: <20180615212131.28121-4-y.karadz@gmail.com>
References: <20180615212131.28121-1-y.karadz@gmail.com>
        <20180615212131.28121-4-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


Hi Yordan,

I pulled in the first two patches.

On Sat, 16 Jun 2018 00:21:30 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> trace-filter-hash implements a set of hashing tools, used when
> filtering the trace data. So far these tools are used for a task
> filtering exploiting the unique Id of the task (pid). The same
> instruments can be used by an application for event filtering,
> using the unique Id of the trace event. In this patch the naming
> convention used in trace-filter-hash is changed, in order to avoid
> confusion in the case when the tools are used for event filtering.
> 

I'm not against this patch, and it makes sense. The change log could
use a little improvement though. I had to read it twice to figure out
what you were trying to do. What about something like this:

===
The trace-filter-hash code implements a set of hashing utilities for
filtering the trace data. Currently, only tasks are filtered with this
utility via its pid. To use this tool for filtering other items such as
events, a name change is required for the structures and functions
used. Instead of using the term "task", use the term "id", which is
more generic, and will be less confusing when using the
trace-filter-hash for filtering events and such.
===

Or something similar to the above. Again, the patch is fine, just the
change log was hard to understand.

-- Steve


> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>
