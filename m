Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10189C3A5A2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E096620B7C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387870AbfITPCz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 11:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387693AbfITPCz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 11:02:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 622002086A;
        Fri, 20 Sep 2019 15:02:54 +0000 (UTC)
Date:   Fri, 20 Sep 2019 11:02:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/5] trace-cmd: Move extract trace_clock into
 trace-input.c
Message-ID: <20190920110252.3224e22a@gandalf.local.home>
In-Reply-To: <CACqStofGsn5mTaT=+K1VSxPeHcfow5NHk3Jo54QBiwYA=79uAQ@mail.gmail.com>
References: <20190918020334.344561631@goodmis.org>
        <20190918020530.344889398@goodmis.org>
        <CACqStofGsn5mTaT=+K1VSxPeHcfow5NHk3Jo54QBiwYA=79uAQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 20 Sep 2019 14:55:21 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:


> >
> > +static void extract_trace_clock(struct tracecmd_input *handle, char *line)
> > +{
> > +       char *data;
> > +       char *clock;  
> 
> I would recommend to initialize clock with NULL, so in case sscanf fails due to
> broken line or mem alloc, handle->trace_clock will not point to random memory.

Good catch! Thanks, I'll update.

-- Steve

> 
> > +       char *next = NULL;
> > +
> > +       data = strtok_r(line, "[]", &next);
> > +       sscanf(data, "%ms", &clock);
> > +       /* TODO: report if it fails to allocate */
> > +       handle->trace_clock = clock;
> > +}
> > +
