Return-Path: <SRS0=sUNk=X2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5189BC352AA
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Oct 2019 13:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25F1D21855
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Oct 2019 13:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388156AbfJANwt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Oct 2019 09:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbfJANwt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Oct 2019 09:52:49 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E242420815;
        Tue,  1 Oct 2019 13:52:48 +0000 (UTC)
Date:   Tue, 1 Oct 2019 09:52:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Eugene Syromyatnikov <evgsyr@gmail.com>
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/2] trace-cmd: Reset CPU mask to its default value with
 "trace-cmd reset".
Message-ID: <20191001095247.6f020759@gandalf.local.home>
In-Reply-To: <CACGkJdseMqPBcM8YOUoZvssT68BFrsmriis4DaMK74cUZVpKvg@mail.gmail.com>
References: <20190925110823.1242-1-tz.stoyanov@gmail.com>
        <20190925110823.1242-3-tz.stoyanov@gmail.com>
        <20190930144444.4956dff8@gandalf.local.home>
        <CACGkJdseMqPBcM8YOUoZvssT68BFrsmriis4DaMK74cUZVpKvg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


[ Added back the list, as this is good to document ]

On Tue, 1 Oct 2019 14:17:08 +0200
Eugene Syromyatnikov <evgsyr@gmail.com> wrote:

> On Mon, Sep 30, 2019 at 11:13 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >         if (bits)
> >                 sprintf(buf, "%x", (1 << bits) - 1);
> >         while (fullwords-- > 0)
> >                 strcat(buf, "ffffffff");  
> Additional commas that split 32-bit chunks are needed here, if I read
> lib/bitmap.c:__bitmap_parse correctly.
> 

You're right. I just tested it:

 # echo fffffffff > /debug/tracing/tracing_cpumask 
-bash: echo: write error: Value too large for defined data type
 # echo f,ffffffff > /debug/tracing/tracing_cpumask 
 # 


This should work then:

	int fullwords;
	char *buf;
	int bits;
	int cpus;
	int len;

	fullwords = (cpus - 1) / 32;
	bits = (cpus - 1) % 32 + 1;
	len = (fullwords + 1) * 9;

	buf = malloc(len + 1);
	buf[0] = '\0';

	if (bits)
		sprintf(buf, "%x", (unsigned int)((1ULL << bits) - 1));
	while (fullwords-- > 0)
		strcat(buf, ",ffffffff");

-- Steve

