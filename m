Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D8AC433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 13:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BB8061460
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 13:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhENN65 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 09:58:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhENN64 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 09:58:56 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F35E3613E9;
        Fri, 14 May 2021 13:57:44 +0000 (UTC)
Date:   Fri, 14 May 2021 09:57:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 6/7] kernel-shark: Check if "trace_seq" was destroyed
 before using it
Message-ID: <20210514095743.4f265de0@gandalf.local.home>
In-Reply-To: <29e3a3e1-26fe-a7e2-fec0-605794e2f353@gmail.com>
References: <20210514121826.161749-1-y.karadz@gmail.com>
        <20210514121826.161749-7-y.karadz@gmail.com>
        <20210514093133.504d1008@gandalf.local.home>
        <29e3a3e1-26fe-a7e2-fec0-605794e2f353@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 14 May 2021 16:45:51 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> On 14.05.21 г. 16:31, Steven Rostedt wrote:
> > On Fri, 14 May 2021 15:18:25 +0300
> > "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> >   
> >> When closing a "tep" data stream we destroy the "trace_seq" object.
> >> However, trace_seq_destroy() sets the buffer to "TRACE_SEQ_POISON"
> >> which is different from NULL.
> >>
> >> It is unfortunate that TRACE_SEQ_POISON is an internal definition
> >> of libtraceevent, so we have to redefine it here, but this can be
> >> fixed in the future.  
> > 
> > It's not unfortunate. It can change in the future without breaking API.
> > 
> > Redefining it here is not robust, and if trace-seq decides to do something
> > different with that poison value, this will break, and it can't be blamed
> > on API (using internal knowledge to implement code is not protected by
> > being backward compatible).
> > 
> > The correct solution is to NULL the buffer after calling destroy.
> > 
> > 	if (seq.buffer) {
> > 		trace_seq_destroy(&seq);
> > 		seq.buffer = NULL;
> > 	}  
> 
> This was the first fix I did when I found the problem, but I don't like 
> it because it looks like a hack the the user of the library is doing to 
> trick the internal logic of the library.

It's not a hack. seq.buffer is exposed via the API (it's in the header) and
is allowed to be used (we use it all the time).

The trace_seq_destroy() function is only to clean up everything that
trace_seq_init() had done, and the seq is no longer valid, and the user is
free to do whatever they want with it afterward. Like set seq.buffer to
NULL.

This is a perfectly valid use case.


> 
> Why not just moving the definition of TRACE_SEQ_POISON to the header or 
> adding

Because TRACE_SEQ_POISON is an internal API that I never want to expose,
because I may even change it in the future. After destroy is called, the
trace_seq code is done. If you want to use the trace_seq again, you need to
call init.

Technically, if you want to do it prim and proper (but I don't actually
recommend this), you need to have another variable that keeps track of the
seq if it was allocated or not. That's not the responsibility of the
trace_seq API to do so. All the trace_seq API cares about is the time
trace_seq_init() is called till trace_seq_destroy() is called. Before or
after that, the seq is of no use to it.

You would need to have:

bool seq_is_init;

	if (!seq_is_init) {
		trace_seq_init(&seq);
		seq_is_init = true;
	}

and later

	if (seq_is_init) {
		trace_seq_destroy(&seq);
		seq_is_init = false;
	}

that's if you don't want to use seq.buffer == NULL to do that for you.

-- Steve
