Return-Path: <SRS0=4yZ8=US=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E42A0C31E49
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jun 2019 11:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB1952054F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jun 2019 11:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfFSLwU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 07:52:20 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34042 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfFSLwU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 07:52:20 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hdZ8T-0008Cm-6R; Wed, 19 Jun 2019 13:52:17 +0200
Message-ID: <c456ec4152a3cce13e875666ad080b755a3d39fb.camel@sipsolutions.net>
Subject: Re: [PATCH] trace-cmd: Do not free pages from the lookup table in
 struct cpu_data in case trace file is loaded.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     tz.stoyanov@gmail.com, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Date:   Wed, 19 Jun 2019 13:52:14 +0200
In-Reply-To: <20190619114922.3169-1-tz.stoyanov@gmail.com> (sfid-20190619_134925_746058_C0571D59)
References: <20190619114922.3169-1-tz.stoyanov@gmail.com>
         (sfid-20190619_134925_746058_C0571D59)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 2019-06-19 at 14:49 +0300, tz.stoyanov@gmail.com wrote:
> From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
> 
> A major speed regression in trace-cmd v2.8 is reported by Johannes Berg
> when parsing a huge trace.dat file:
> 
> "I have a ~1.7G file with just under 620k events (not exactly big by our standards),
> and parsing speed (with -N to disable plugins) goes from ~4.5 seconds on commit
> 1ad32c24746 to >>4.5 minutes (I aborted there) on master.
> I was talking to Steven about another issue, and he pointed me to
> commit c2fc2bc296f7. Reverting that on master makes it take ~2 seconds,
> so that'd actually be an improvement."
> 
> Proposed solution: do not free pages from "struct page **pages" lookup table
> in struct cpu_data, in case a trace file is loaded. This reverts the behavior
> for this use case, as it was before commit c2fc2bc296f7.

Seems to work, more or less. I now see ~6.5 seconds which is slower than
it was, and in particular comparing to just a revert (which was ~2
seconds), but it's usable :-)

johannes

