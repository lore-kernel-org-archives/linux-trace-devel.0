Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E30C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 14:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98A91613B2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 14:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237234AbhDEOXZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 10:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237153AbhDEOXY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 10:23:24 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6794A6139E;
        Mon,  5 Apr 2021 14:23:18 +0000 (UTC)
Date:   Mon, 5 Apr 2021 10:23:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Implement warning() in the library
Message-ID: <20210405102316.5d28cc58@gandalf.local.home>
In-Reply-To: <20210405095920.526d8922@gandalf.local.home>
References: <20210405093357.870395-1-tz.stoyanov@gmail.com>
        <20210405095920.526d8922@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 5 Apr 2021 09:59:20 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon,  5 Apr 2021 12:33:57 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> 
> > The warning() function is used in a lot of places in the trace-cmd
> > library, but there is no implementation. The function is implemented in
> > the trace-cmd application. Added a weak implementation in the library, in
> > case the function in not implemented in the application, using that
> > library.
> >   
> 
> Isn't the "warning()" function implemented in libtraceevent? That's where
> it would be used as it is weak there.
> 
> But honestly, I think we should change the libtraceveent warning to
> "tep_warning()" if we haven't already done so.
> 
> /me goes to look at the code.

OK, so what I think we need to do is have this:


void __weak tep_print_error(const char *fmt, const char *app, va_list ap)
{
	if (errno)
		perror(app);
	fprintf(stderr, " ");
	vfprintf(stderr, fmt, ap);
	fprintf(stderr, "\n");
}

That gets the format and a va_list, and this is the weak function that
anything can overwrite (like KernelShark to have a pop up on error?).

Then we can have functions:

void __weak tep_vwarning(const char *fmt, va_list ap)
{
	tep_print_error(fmt, "libtraceevent", ap);
}
	
void __weak tep_warning(const char *fmt, ...)
{
	va_list ap;

	va_start(ap, fmt);
	tep_vwarning(fmt, ap);
	va_end(ap);
}


And the same for libtracefs and libtracecmd.

where it will have a tracefs_warning() and a tracecmd_warning() functions
defined. Then an app can overwrite how tep_print_error() works, as well as
tep_vwarning works (or tracefs_vwarning() etc).

Hmm, thinking about this, there's no reason to have tep_warning() weak,
because by overwriting tep_vwarning(), you have full control of
tep_warning().

-- Steve
