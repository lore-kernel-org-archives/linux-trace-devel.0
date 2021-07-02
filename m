Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287CCC11F68
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0476E6141C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhGBLhn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 07:37:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231899AbhGBLhn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 07:37:43 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B44461402;
        Fri,  2 Jul 2021 11:35:11 +0000 (UTC)
Date:   Fri, 2 Jul 2021 07:35:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 5/7] libtracefs: Implement tracefs_kprobe_clear_all()
 to remove all kprobes
Message-ID: <20210702073509.1b1d8b59@rorschach.local.home>
In-Reply-To: <e01fb2ef-a51f-f573-3869-829dd93f777d@gmail.com>
References: <20210702035443.154729-1-rostedt@goodmis.org>
        <20210702035443.154729-6-rostedt@goodmis.org>
        <e01fb2ef-a51f-f573-3869-829dd93f777d@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 2 Jul 2021 14:15:44 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> > diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
> > index e875d6e8a65f..fe61a25baa10 100644
> > --- a/src/tracefs-kprobes.c
> > +++ b/src/tracefs-kprobes.c
> > @@ -169,3 +169,106 @@ char **tracefs_get_kprobes(void)
> >   	list = NULL;
> >   	goto out;
> >   }
> > +
> > +struct instance_list {
> > +	struct instance_list	*next;
> > +	struct tracefs_instance	*instance;
> > +};  
> 
> This is not used in this source file. I see that it was moved to 
> tracefs-instance.c

Internally, this was my fourth iteration between v2 and v3, and I kept
finding "better" ways to write this code. This was left over from one
of those iterations.

I'll nuke it. Thanks!

-- Steve
