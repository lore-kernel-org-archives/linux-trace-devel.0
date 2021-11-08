Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00FF6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 23:04:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D073B610CB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 23:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237245AbhKHXHk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 18:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234561AbhKHXHj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 18:07:39 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53AEA619BB;
        Mon,  8 Nov 2021 23:04:54 +0000 (UTC)
Date:   Mon, 8 Nov 2021 18:04:52 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     mhiramat@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/10] user_events: Optimize writing events by only
 copying data once
Message-ID: <20211108180452.3ec1f4ec@gandalf.local.home>
In-Reply-To: <20211108230034.GB1452@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
        <20211104170433.2206-10-beaub@linux.microsoft.com>
        <20211108174542.39c255e1@gandalf.local.home>
        <20211108230034.GB1452@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 8 Nov 2021 15:00:34 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> > > -	memcpy(entry + 1, data, datalen);
> > > +	if (unlikely(!copy_nofault(entry + 1, i->count, i)))  
> > 
> > Need:
> > 		__trace_event_discard_commit(event_buffer.buffer, event_buffer.event);
> > 
> > Because the trace_event_buffer_reserve() will not only allocate space on
> > the ring buffer, but may also disable preemption.
> > 
> > -- Steve
> >   
> 
> Ah, thank you!

Which reminds me that trace_event_buffer_reserve() expects to be called
with preemption disabled. And I'm guessing that may not be the case for you.

I'll change this so that it always disables preemption even if it uses the
filter buffer, and *always* disables preemption on return.

-- Steve
