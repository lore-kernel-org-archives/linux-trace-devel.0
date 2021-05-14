Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39089C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 13:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 058FB6121E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 13:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhENNNS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 09:13:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhENNNS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 09:13:18 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A31361406;
        Fri, 14 May 2021 13:12:06 +0000 (UTC)
Date:   Fri, 14 May 2021 09:12:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] trace-cmd: Trace timesync to find pids that map
 vCPUs
Message-ID: <20210514091205.6b269474@gandalf.local.home>
In-Reply-To: <CAPpZLN6p2UgghB16=eqpacica6XEOLuCqTds+SdhFbZkPUZ0Hw@mail.gmail.com>
References: <20210513204315.1206204-1-rostedt@goodmis.org>
        <20210513204315.1206204-3-rostedt@goodmis.org>
        <CAPpZLN6p2UgghB16=eqpacica6XEOLuCqTds+SdhFbZkPUZ0Hw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 14 May 2021 07:10:51 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > @@ -3250,10 +3282,18 @@ static char *parse_guest_name(char *gname, int *cid, int *port)
> >         } else if (is_digits(gname))
> >                 *cid = atoi(gname);
> >
> > -       read_qemu_guests();
> > +       if (*cid < 0)
> > +               read_qemu_guests();
> > +
> > +       if (*cid < 0)
> > +               return NULL;  
> 
> This check is not needed. If cid is not part of the string, let
> read_qemu_guests() to try discover the VMs, instead of returning NULL.

I'm confused. That's basically what the above does.

	*cid = -1;

	if (<cid is in name>) {
		*cid = look_for_cid_via_tracing();
	}

	if (*cid < -1)
		read_qemu_guests();

That is, if the cid isn't part of the name, then it will call
read_qemu_guests().

The second check is in case the read_qemu_guests() fails to find the cid
either.

What am I missing?

-- Steve
