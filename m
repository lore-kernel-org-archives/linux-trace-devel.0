Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CE0C11F65
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 19:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F2D561477
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 19:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbhF3T40 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 15:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233740AbhF3T4Z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 15:56:25 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FF4761285;
        Wed, 30 Jun 2021 19:53:55 +0000 (UTC)
Date:   Wed, 30 Jun 2021 15:53:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] libtracefs: Implement tracefs_kprobe_raw()
Message-ID: <20210630155354.5f58d68b@oasis.local.home>
In-Reply-To: <83cee0b8-b9c6-849b-291e-b750815de69e@gmail.com>
References: <20210630154729.129873-1-rostedt@goodmis.org>
        <20210630154729.129873-3-rostedt@goodmis.org>
        <83cee0b8-b9c6-849b-291e-b750815de69e@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 30 Jun 2021 22:46:19 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> > +int tracefs_kprobe_raw(const char *system, const char *event,
> > +		       const char *addr, const char *format)
> > +{
> > +	char *str;
> > +	int ret;
> > +
> > +	errno = EBADMSG;
> > +	if (!addr || !format)
> > +		return -1;
> > +
> > +	if (!event)
> > +		event = addr;
> > +
> > +	if (system)
> > +		ret = asprintf(&str, "p:%s/%s %s %s\n",
> > +			       system, event, addr, format);
> > +	else
> > +		ret = asprintf(&str, "p:%s %s %s\n",
> > +			       event, addr, format);  
> 
> I wonder what will be the way to register a "return value" ("r:") 
> kprobe. Do you consider having a separate API for them?

Yes, I was thinking about having a "tracefs_kretprobe_raw()" as well.

I also thought of adding a flag in the parameter, but thought that a
separate function would be better instead.

I wanted to play with this interface before creating the retprobe one.
If you are happy with the current design, I can add that too.

-- Steve
