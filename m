Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:36532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936936AbdLRRwd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Dec 2017 12:52:33 -0500
Date: Mon, 18 Dec 2017 12:52:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: David Hildenbrand <david@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v1] trace-cmd: introduce --initital-delay for record
 command
Message-ID: <20171218125231.445d8fa2@gandalf.local.home>
In-Reply-To: <7b89f63f-3a6f-4182-c26a-934514ba5670@redhat.com>
References: <20171218112412.11898-1-david@redhat.com>
        <20171218104158.22519a7e@gandalf.local.home>
        <7b89f63f-3a6f-4182-c26a-934514ba5670@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon, 18 Dec 2017 17:23:24 +0100
David Hildenbrand <david@redhat.com> wrote:

> What I need: Start tracing and flush all buffers when exiting. (e.g.

Why don't you use "trace-cmd start" and "trace-cmd extract"?

"trace-cmd record" is all about not losing events. If you are creating
a big buffer, then I think you want to use this.

# trace-cmd start -p <tracer> -e <events> -b <big-buffer-size>
# run test
# trace-cmd stop
# trace-cmd extract

Wouldn't that work for you?

-- Steve

> after 30 seconds). Never wakeup in between, so the real trace overhead
> in that period of time is purely storing the tracepoints to the buffer
> in the kernel. Of course we could implement something like that ("copy
> from the buffer only when exiting") or try to see if we can fix the
> existing "-s" flag in a way that allows it.
