Return-Path: <SRS0=a1Iv=2B=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D05EC43603
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Dec 2019 17:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 392C8222C4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Dec 2019 17:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730830AbfLKRAy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Dec 2019 12:00:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:42046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730618AbfLKRAx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Dec 2019 12:00:53 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D886B214AF;
        Wed, 11 Dec 2019 17:00:52 +0000 (UTC)
Date:   Wed, 11 Dec 2019 12:00:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tom Zanussi <zanussi@kernel.org>
Cc:     Sven Schnelle <svens@stackframe.org>,
        linux-trace-devel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ftrace histogram sorting broken on BE architecures
Message-ID: <20191211120051.711582ee@gandalf.local.home>
In-Reply-To: <1576082238.2833.8.camel@kernel.org>
References: <20191211123316.GD12147@stackframe.org>
        <20191211103557.7bed6928@gandalf.local.home>
        <20191211110959.2baeb70f@gandalf.local.home>
        <1576082238.2833.8.camel@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 11 Dec 2019 10:37:18 -0600
Tom Zanussi <zanussi@kernel.org> wrote:

> > Tom,
> > 
> > Correct me if I'm wrong, from what I can tell, all sums and keys are
> > u64 unless they are a string. Thus, I believe this patch should not
> > have any issues.  
> 
> The sums are u64, but the keys may not be.  I'll take a look and see,

Are they? I see in create_key_field:

	key_size = ALIGN(key_size, sizeof(u64));

Which to me seems that we'll have nothing smaller than sizeof(u64).

> but I'm out today and won't be able to look into it until tomorrow, if
> that's ok.

No rush.

I'll start the testing of this patch if you come back and say its
fine ;-) That takes a full day.

-- Steve
