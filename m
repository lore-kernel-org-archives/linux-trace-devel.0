Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:46228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbeJPTdk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 15:33:40 -0400
Date: Tue, 16 Oct 2018 07:43:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ceco <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] Introduce new libtracevent API: tep_override_comm()
Message-ID: <20181016074334.25a13802@gandalf.local.home>
In-Reply-To: <CAPpZLN6bvSTVq6NBXHPKqH4cMXTxSKeTxk0VMiTAZJpt4mY_5Q@mail.gmail.com>
References: <20180830150900.27412-1-tz.stoyanov@gmail.com>
        <20180831062718.3436-1-tz.stoyanov@gmail.com>
        <CAPpZLN6bvSTVq6NBXHPKqH4cMXTxSKeTxk0VMiTAZJpt4mY_5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 16 Oct 2018 09:46:07 +0300
Ceco <tz.stoyanov@gmail.com> wrote:

> ping
> Hi Steven, is there a problem with this patch ? Yordan needs these
> changes, he wants to use the new API in KernelShark.

Just woke up, so I haven't had a chance to look at the patch. But the
one thing that is wrong with it, is that a v2 shouldn't be a reply to a
v1. That is, it should start a new thread. With thousands of emails in
my Inbox, I look at email threads (as do many kernel developers), and
if there's a patch within the thread, it is commonly missed.

I will say that I did mark it to look at it, so I did see it. But other
patches came in during that time, and I sorted my inbox by thread, which
did hide the patch again.

I'll take a look at it later today.

Also, don't be afraid to send a ping if there's no response for a week,
as that usually means it was lost in the flood.

Thanks!

-- Steve


> 
> On Fri, Aug 31, 2018 at 9:27 AM Tzvetomir Stoyanov (VMware)
> <tz.stoyanov@gmail.com> wrote:
> >
