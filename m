Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5335CC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 16:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20C7E61130
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 16:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343955AbhDGQTp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Apr 2021 12:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344170AbhDGQTj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Apr 2021 12:19:39 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BC7261279;
        Wed,  7 Apr 2021 16:19:29 +0000 (UTC)
Date:   Wed, 7 Apr 2021 12:19:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: Implement tracefs_warning()
Message-ID: <20210407121928.464045ee@gandalf.local.home>
In-Reply-To: <20210407051154.2422172-1-tz.stoyanov@gmail.com>
References: <20210407051154.2422172-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  7 Apr 2021 08:11:54 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The warning() function is used in a lot of places in the libracefs
> library, and it is implemented as a dummy weak function. There is a
> weak implementation of the same function in traceevent library, which
> could cause a problem when both are used in an application.
> Replaced warning() with tracefs_warning() and implemented it as a
> weak function, specific to this library.
> Added a __weak define in the library internal header file.

I've been thinking about this more, and I think we only want one function
to override, and that would be:

void __weak tep_vwarning(const char *name, const char *fmt, va_list ap)
{
	if (errno)
		perror(name);
	
	fprintf(stderr, "  ");
	vfprintf(stderr, fmt, ap);
	fprintf(stderr, "\n");
}


And simply have:

void tep_warning(const char *fmt, ...)
{
	va_list ap;

	va_start(ap, fmt);
	tep_vwarning("libtraceevent", fmt, ap);
	va_end(ap)
}

and

void tracefs_warning(const char *fmt, ...)
{
	va_list ap;

	va_start(ap, fmt);
	tep_vwarning("libtracefs", fmt, ap);
	va_end(ap)
}

and

void tracecmd_warning(const char *fmt, ...)
{
	va_list ap;

	va_start(ap, fmt);
	tep_vwarning("libtracecmd", fmt, ap);
	va_end(ap)
}

Then the application only needs to overwrite one function if they want
full control of the output. And it can use the name field to know if it
wants to do something different with different libraries.

Thus, trace-cmd could do:

void tep_vwarning(const char *name, const char *fmt, va_list ap)
{
	if (errno)
		perror("trace-cmd");

	fprintf(stderr, "  ");
	vfprintf(stderr, fmt, ap);
	fprintf(stderr, "\n");
}

and this will make all the warning messages from all the libraries print
the error from "trace-cmd" (we want the tool not the library), just like it
does today.

We could also have kernelshark have:

void tep_vwarning(const char *name, const char *fmt, va_list ap)
{
	char buf[BUFSIZ + 1];
	char *p = &buf[0];
	int r, left = BUFSIZ;

	if (errno) {
		r = snprintf(p, left, "kernelshark: %s\n", strerror(errno));
		left -= r;
		p += r;
	}

	if (left > 0) {
		r = snprintf(p, left, " ");
		p += r;
		left -= r;
	}

	if (left > 0) {
		r = vsnprintf(p, left, fmt, ap);
		left -= r;
		p += r;
	}

	if (left > 0)
		snprintf(p, left, "\n");

	gui_popup(buf);
}

Doing the above with a single function tep_vprintf() means that the
application doesn't need to define multiple functions.

-- Steve
