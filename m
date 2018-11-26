Return-Path: <SRS0=Jn1h=OF=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:41200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbeK0B2Y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Nov 2018 20:28:24 -0500
Date: Mon, 26 Nov 2018 09:34:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 0/3] libtraceevent: Various API fixes
Message-ID: <20181126093404.446ca4d3@gandalf.local.home>
In-Reply-To: <20181123133946.16239-1-tstoyanov@vmware.com>
References: <20181123133946.16239-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 23 Nov 2018 13:39:58 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch series contains few unrelated changes in 
> the library APIs. It improves the consistency of the APIs
> return logic and removes a duplicated API. 
> 
> Tzvetomir Stoyanov (3):
>   tools/lib/traceevent: Remove tep_data_event_from_type() API
>   tools/lib/traceevent: Changed return logic of
>     tep_register_event_handler() API
>   tools/lib/traceevent: Changed return logic of trace_seq_printf() and
>     trace_seq_vprintf() APIs
> 
>  .../libtraceevent-reg_event_handler.txt       | 12 +++++++---
>  .../libtraceevent-tseq_print.txt              |  9 ++++----
>  .../Documentation/libtraceevent.txt           |  1 -
>  tools/lib/traceevent/event-parse.c            | 22 +++++++------------
>  tools/lib/traceevent/event-parse.h            |  6 ++++-
>  tools/lib/traceevent/trace-seq.c              | 17 +++++++++-----
>  6 files changed, 39 insertions(+), 28 deletions(-)
> 

This doesn't appear to apply on any tree.

Note, if you send a patch series, it must apply on the tree you are
sending it to. It should not depend on any patch that is pending and
has not yet been applied. If it does, then that pending patch needs to
be added to the series as well.

-- Steve
