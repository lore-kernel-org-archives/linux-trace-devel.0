Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C7A0C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 13:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F258260FEE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 13:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235533AbhDPN7f (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 09:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229804AbhDPN7e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 09:59:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23F886117A;
        Fri, 16 Apr 2021 13:59:10 +0000 (UTC)
Date:   Fri, 16 Apr 2021 09:59:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Suppress trace library warnings
Message-ID: <20210416095908.258d4c96@gandalf.local.home>
In-Reply-To: <CAPpZLN7ZvgSKoNVek+msCHarKY7F-dYUhKSuoKt_DF2qaE_rwg@mail.gmail.com>
References: <20210415080316.3482986-1-tz.stoyanov@gmail.com>
        <20210415093428.1a3a1678@gandalf.local.home>
        <CAPpZLN7ZvgSKoNVek+msCHarKY7F-dYUhKSuoKt_DF2qaE_rwg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 16 Apr 2021 13:14:01 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> I can fix "-q" to suppress warnings from all trace libraries, but the
> problem is that "-q" is not set by default. These "Not being able to
> parse" messages could be very annoying in some cases and as I
> understood they are not critical ? The other problem is that not all
> trace-cmd commands have the "-q" option, but almost all of them need a
> tep handler that could cause printing of these messages.
> Yodan found one more issue, the pr_stat() libtraceevent function is
> not affected by tep_vwarning() redefine. It prints statistics on
> KernelShark startup. I think we should add some kind of priorities of
> all those library messages and decide which of them when will be
> printed.  It makes sense only for fatal library messages to be printed
> by default, if the "-q" option is not set. All others should be
> visible only if trace-cmd runs in debug mode.

In principle I agree, but I have mixed feelings about this, because these
messages have helped me in the past to fix something. And not that I was
debugging it. I would trace an event and this would warn on it, and then I
would know the event had issues.

But I do find that they are more annoying when it's showing too much,
especially on "-e all" runs. Personally, I would love to only show those
warnings if the record was on a subset of events, and not all of them.
Because when I specify events, and it fails to parse, then I really do care
about that.

I wonder if we should do the following:

On record, if its not "-e all" then add an option that tells report that
not all events are traced. And it will allow for showing of failed to parse
events by default, and quieted by "-q". If that option does not exist, then
only show the failed parsings if "--debug" is set.

That is, if the user specified events, they should care if they parse or
not. But if they just said "-e all" then they probably do not care, because
there's going to be events that do not parse.

Thoughts?


As for pr_stat(), I think we should rename it to tep_info() and tep_vinfo()
that acts just like tep_warning(), except it is for informational output
(stdout instead of stderr). This is similar to what the kernel has.

Since tep_vwarning() takes a name, so can tep_vinfo(), and I was thinking
that we should expose this string to the application.

extern const char *tep_name;

As well for libtracefs:

extern const char *tracefs_name;

Then in tep_warning(), we could do things like:

	if (name == tep_name) {
		/* do something for libtraceevent errors */
	} else if (name == tracefs_name) {
		/* do something for libtracefs errors */
	}

Instead of doing the error prone:

	if (!strcmp(name, "libtraceevent")) {
		[..]
	} else if (!strcmp(name, "libtracefs")) {
		[..]
	}

-- Steve
