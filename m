Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4767EC48BCF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Jun 2021 11:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24D1C6139A
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Jun 2021 11:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbhFILJN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Jun 2021 07:09:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238062AbhFILJM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Jun 2021 07:09:12 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3171A61364;
        Wed,  9 Jun 2021 11:07:18 +0000 (UTC)
Date:   Wed, 9 Jun 2021 07:07:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2] libtraceevent: Handle parsing of "(REC)->" case
Message-ID: <20210609070716.5f7d4a4e@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.22.394.2106090741080.2930@hadrien>
References: <20210608172744.796e93b7@gandalf.local.home>
        <alpine.DEB.2.22.394.2106090741080.2930@hadrien>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 9 Jun 2021 07:43:08 +0200 (CEST)
Julia Lawall <julia.lawall@inria.fr> wrote:

> > If a trace event wraps the special __entry variable to dereference it with
> > parenthesis, it shows up in the trace event format file wrapping the
> > "(REC)" as well. For example, the "func_repeats" event passed the __entry
> > into a helper macro in the TP_printk() portion, and the macro correctly
> > wrapped its parameter in parenthesis. This caused the output to show:
> >
> >  "(((u64)(REC)->top_delta_ts << 32) | (REC)->bottom_delta_ts)"
> >
> > The parser then failed to parse the "(REC)->" portion, as it expected the
> > "->" to appear directly after the "REC". This is not a requirement, and
> > the parser should be able to handle such cases.
> >
> > When this occurred, trace-cmd would error with the following message:
> >
> > trace-cmd: No such file or directory
> >   Error: expected type 4 but read 5  
> 
> For the record, I have tried tracing two programs with Linux v5.13-rc4 or
> rc5 and both of them had this problem, while they didn't have this problem
> when traced with the same arguments with earlier Linux versions.  So it
> may be systematic for Linux v5.13.

The event mentioned in the change log was added in 5.13. But it is a valid
pattern, and not a bug in the 5.13 kernel.

-- Steve
