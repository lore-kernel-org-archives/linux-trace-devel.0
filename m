Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870F4C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 09:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5551C61008
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 09:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbhEEJ4S (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 May 2021 05:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231769AbhEEJ4Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 May 2021 05:56:16 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E20C6611AC;
        Wed,  5 May 2021 09:55:19 +0000 (UTC)
Date:   Wed, 5 May 2021 05:55:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/4] libtraceevent: Add logs with severity info
Message-ID: <20210505055517.70b552ee@oasis.local.home>
In-Reply-To: <CAPpZLN4opBm_OQm2HYH73PmpBOmV9VMaV1vt+Wx_EzjOOAPWcw@mail.gmail.com>
References: <20210428073001.755905-1-tz.stoyanov@gmail.com>
        <20210428073001.755905-3-tz.stoyanov@gmail.com>
        <20210504162425.5cced88c@gandalf.local.home>
        <CAPpZLN4opBm_OQm2HYH73PmpBOmV9VMaV1vt+Wx_EzjOOAPWcw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 5 May 2021 07:45:44 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Tue, May 4, 2021 at 11:24 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Wed, 28 Apr 2021 10:29:59 +0300
> > "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> >
> > And let the tep_vprint() decide to print it or not.  
> 
> The tep_vprint() is used also by libtacecmd and libtracefs for
> printing logs. Each library has its own log_level local variable,
> that's why I check the log level in the library specific log
> functions.

But tep_vprint() looks like this:

int __weak tep_vprint(const char *name, enum tep_loglevel level, const char *fmt, va_list ap)
{
        int ret = errno;

        if (errno && level <= TEP_LOG_WARNING)
                perror(name);

        fprintf(stderr, "  ");
        vfprintf(stderr, fmt, ap);
        fprintf(stderr, "\n");

        return ret;
}

That check of the log level is confusing. Just remove it. In fact, we
should add a boolean on whether to print the errno message or not.

Like this:

int __weak tep_vprint(const char *name, bool print_errno, const char *fmt, va_list ap)
{
        int ret = errno;

        if (errno && print_errno)
                perror(name);

        fprintf(stderr, "  ");
        vfprintf(stderr, fmt, ap);
        fprintf(stderr, "\n");

        return ret;
}

That would make a lot more sense, and let the callers of it decide to
print it or not, and not have the internal level of libtraceevent
decide.

-- Steve
