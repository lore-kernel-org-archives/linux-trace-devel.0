Return-Path: <SRS0=uRrw=ID=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 633E8C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 14:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2517665085
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 14:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhCEOys (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 09:54:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhCEOyl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 09:54:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01F2165085;
        Fri,  5 Mar 2021 14:54:40 +0000 (UTC)
Date:   Fri, 5 Mar 2021 09:54:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
Message-ID: <20210305095439.10321303@gandalf.local.home>
In-Reply-To: <20210305093946.1c3f4ad7@gandalf.local.home>
References: <1615029625-9749-1-git-send-email-sameeruddin.shaik8@gmail.com>
        <CAPpZLN6A+5pmCnOCJfg-eV1+1UR_MbwgvzhW-bd-ZZJ1F-dC=A@mail.gmail.com>
        <20210305093946.1c3f4ad7@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 5 Mar 2021 09:39:46 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> > > + * The @filters is an array of strings, where each string will be used to set
> > > + * a function or functions to be traced.
> > > + *
> > > + * If @reset is true, then all functions in the filter are cleared before
> > > + * adding functions from @filter. Otherwise, the functions set by @filter
> > > + * will be appended to the filter file
> > > + *
> > > + * The @errs is an array of strings, where each string is a failed function
> > > + * name
> > > + *
> > > + * returns -x (where x is number of failed filter srtings or it can be
> > > + * 1 for general errors), or 0 if there are no errors.
> > > + */


We should for the return statement:

 * returns -x on filter errorrs (where x is number of failed filter strings)
 *         and @errs if non-NULL will be an allocated string array pointing
 *         to the strings in @filter that failed, and must be freed with
 *         free().
 *
 * returns 1 on general errors not related to setting the filter.
 *         @errs is not set, even if supplied.
 *
 * returns 0 on success, and @errs is not set.

-- Steve
