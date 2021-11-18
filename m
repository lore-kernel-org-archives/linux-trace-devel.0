Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63276C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Nov 2021 01:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A92E61221
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Nov 2021 01:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239516AbhKRBzW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 20:55:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233128AbhKRBzV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 20:55:21 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E3FC61221;
        Thu, 18 Nov 2021 01:52:21 +0000 (UTC)
Date:   Wed, 17 Nov 2021 20:52:20 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     mhiramat@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 12/12] user_events: Validate user payloads for size
 and null termination
Message-ID: <20211117205220.6d49f5b9@gandalf.local.home>
In-Reply-To: <20211116211150.GA2337@kbox>
References: <20211116005047.1808-1-beaub@linux.microsoft.com>
        <20211116005047.1808-13-beaub@linux.microsoft.com>
        <20211116211150.GA2337@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 16 Nov 2021 13:11:50 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> On Mon, Nov 15, 2021 at 04:50:47PM -0800, Beau Belgrave wrote:
> > +static int user_event_validate(struct user_event *user, void *data, int len)
> > +{
> > +	struct list_head *head = &user->validators;
> > +	struct user_event_validator *validator;
> > +	void *pos, *end = data + len;
> > +	u16 *val, offset, size;
> > +
> > +	list_for_each_entry(validator, head, link) {
> > +		pos = data + validator->offset;
> > +		val = pos;
> > +
> > +		/* Already done min_size check, no bounds check here */
> > +		offset = *val++;
> > +		size = *val++;  
> 
> I believe I have these backwards, size should come first for both dyn
> and rel data. Is this correct?

it's size << 16 | offset;


> 
> > diff --git a/tools/testing/selftests/user_events/ftrace_test.c b/tools/testing/selftests/user_events/ftrace_test.c
> > index 9d53717139e6..bea694e9df8c 100644
> > --- a/tools/testing/selftests/user_events/ftrace_test.c
> > +++ b/tools/testing/selftests/user_events/ftrace_test.c
> > @@ -21,6 +21,11 @@ const char *status_file = "/sys/kernel/debug/tracing/user_events_status";
> >  const char *enable_file = "/sys/kernel/debug/tracing/events/user_events/__test_event/enable";
> >  const char *trace_file = "/sys/kernel/debug/tracing/trace";
> >  
> > +struct rel_loc {
> > +	__u16 offset;
> > +	__u16 size;
> > +} __packed;
> > +  
> 
> Same here.

I would not use pointer arithmetic or the above structure, as I'm not sure
they work the same for both big and little endian. It's best to just use
u32 and '|' (or) the two unsigned shorts into one integer.

-- Steve
