Return-Path: <SRS0=4zaN=V4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C307C32751
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Jul 2019 12:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 603B920693
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Jul 2019 12:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387577AbfGaM1U (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 31 Jul 2019 08:27:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387423AbfGaM1U (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 31 Jul 2019 08:27:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6672620693;
        Wed, 31 Jul 2019 12:27:19 +0000 (UTC)
Date:   Wed, 31 Jul 2019 08:27:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] tools/lib/traceevent, tools/perf: Changes in
 tep_print_event_* APIs
Message-ID: <20190731082717.1846993b@gandalf.local.home>
In-Reply-To: <CAPpZLN7NAnDuvF08B6qAab83cudaEVa=aE=9=oL5pNkUmig5wA@mail.gmail.com>
References: <20190730125028.24789-1-tz.stoyanov@gmail.com>
        <20190730125028.24789-2-tz.stoyanov@gmail.com>
        <20190730121245.2d14b2b6@gandalf.local.home>
        <CAPpZLN7NAnDuvF08B6qAab83cudaEVa=aE=9=oL5pNkUmig5wA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 31 Jul 2019 15:16:13 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > > @@ -5413,18 +5419,20 @@ int tep_cmdline_pid(struct tep_handle *tep, struct tep_cmdline *cmdline)
> > >  /**
> > >   * tep_event_info - parse the data into the print format
> > >   * @s: the trace_seq to write to
> > > + * @format: printf format string. If any precision is specified in the string,
> > > + *       print in raw data format  
> >
> > I'm curious to why this is needed?
> >
> > We can use a temp trace_seq like I mentioned above, and then apply the
> > format to it at the end.
> >  
> We need a way to keep the tep_set_print_raw() functionality with the
> new tep_print_event() API.
> The user should have an option to print TEP_PRINT_INFO in raw format.
> The only way to pass some
> extra parameters to tep_print_event() is to use the printf format
> string, "%s" in this case.
> I choose to use "%s" width specifier to force TEP_PRINT_INFO in raw format.
> The other possible solution could be to define a new
> TEP_PRINT_INFO_RAW type for this use case.

I like the idea of adding a new TEP_PRINT_INFO_RAW, as the other seems
more of a "hack" to get that. It also removes the ability to pass in a
string precision for a normal TEP_PRINT_INFO.

Thanks!

-- Steve
