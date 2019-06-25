Return-Path: <SRS0=sGTW=UY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7059C48BD6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Jun 2019 22:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C32C82054F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Jun 2019 22:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFYWcs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 18:32:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbfFYWcs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 18:32:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26DCD2053B;
        Tue, 25 Jun 2019 22:32:47 +0000 (UTC)
Date:   Tue, 25 Jun 2019 18:32:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     tz.stoyanov@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Do not free pages from the lookup table in
 struct cpu_data in case trace file is loaded.
Message-ID: <20190625183245.38d63750@gandalf.local.home>
In-Reply-To: <c456ec4152a3cce13e875666ad080b755a3d39fb.camel@sipsolutions.net>
References: <20190619114922.3169-1-tz.stoyanov@gmail.com>
        <c456ec4152a3cce13e875666ad080b755a3d39fb.camel@sipsolutions.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 19 Jun 2019 13:52:14 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> Seems to work, more or less. I now see ~6.5 seconds which is slower than
> it was, and in particular comparing to just a revert (which was ~2
> seconds), but it's usable :-)

I'm totally confused. Unless it is a cache miss thing, the only thing
it did was add two branches that should basically follow the old path
with the revert.

Can you run perf comparing this patch against the revert and see where
the difference lies?

Thanks!

-- Steve
