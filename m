Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D1FC6379D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D865D20872
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388662AbgKXNwl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Nov 2020 08:52:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388660AbgKXNwl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Nov 2020 08:52:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9084F20872;
        Tue, 24 Nov 2020 13:52:40 +0000 (UTC)
Date:   Tue, 24 Nov 2020 08:52:38 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] tracefs utils: Do not free a the buffer on a zero size
 str_read_file()
Message-ID: <20201124085238.09a97d50@gandalf.local.home>
In-Reply-To: <CAPpZLN7W6KY_wUaGre1iTqx04cvuG90Nrbai+0MiZ17yafgrmw@mail.gmail.com>
References: <20201123153447.2e24c678@gandalf.local.home>
        <CAPpZLN7W6KY_wUaGre1iTqx04cvuG90Nrbai+0MiZ17yafgrmw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 24 Nov 2020 07:44:14 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > index 326b455..690506c 100644
> > --- a/tracefs-utils.c
> > +++ b/tracefs-utils.c
> > @@ -220,7 +220,7 @@ __hidden int str_read_file(const char *file, char **buffer)
> >         } while (r > 0);
> >
> >         close(fd);
> > -       if (r == 0 && size > 0) {
> > +       if (r == 0) {
> >                 buf[size] = '\0';  
> 
> If size is 0, in case of an empty file, then buf should also be NULL
> and this assignment
> will be on invalid memory.

I quickly realized that, and sent out a v2 ;-)

 https://lore.kernel.org/r/20201123154607.5e43e1ff@gandalf.local.home

-- Steve

> 
> >                 *buffer = buf;
> >         } else
> > --
