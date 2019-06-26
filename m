Return-Path: <SRS0=TDtF=UZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A26C4646B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 06:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB00120665
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 06:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbfFZGvU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 02:51:20 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:59472 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfFZGvU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 02:51:20 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hg1lz-0004ex-De; Wed, 26 Jun 2019 08:51:15 +0200
Message-ID: <fe27a8ed9bb297894ce97c0cfe6c801e07cf6a2c.camel@sipsolutions.net>
Subject: Re: [PATCH] trace-cmd: Do not free pages from the lookup table in
 struct cpu_data in case trace file is loaded.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     tz.stoyanov@gmail.com, linux-trace-devel@vger.kernel.org
Date:   Wed, 26 Jun 2019 08:51:14 +0200
In-Reply-To: <20190625183245.38d63750@gandalf.local.home>
References: <20190619114922.3169-1-tz.stoyanov@gmail.com>
         <c456ec4152a3cce13e875666ad080b755a3d39fb.camel@sipsolutions.net>
         <20190625183245.38d63750@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 2019-06-25 at 18:32 -0400, Steven Rostedt wrote:
> On Wed, 19 Jun 2019 13:52:14 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > Seems to work, more or less. I now see ~6.5 seconds which is slower than
> > it was, and in particular comparing to just a revert (which was ~2
> > seconds), but it's usable :-)
> 
> I'm totally confused. Unless it is a cache miss thing, the only thing
> it did was add two branches that should basically follow the old path
> with the revert.
> 
> Can you run perf comparing this patch against the revert and see where
> the difference lies?

I tried, but it looks the same. Then I tried to reproduce and now I see
it also fairly consistently just under 2 seconds with the patch, so
perhaps CPU scaling or something was throwing me a curve ball before.

Sorry for the noise, patch works great.

Tested-by: Johannes Berg <johannes@sipsolutions.net>

johannes

