Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 834CAC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 15:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241438AbiBWPSB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Feb 2022 10:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241476AbiBWPRr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Feb 2022 10:17:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598981C910
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 07:17:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA50F6173E
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 15:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D61C340E7;
        Wed, 23 Feb 2022 15:17:16 +0000 (UTC)
Date:   Wed, 23 Feb 2022 10:17:15 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] libtracefs: Add unit tests for user_events
Message-ID: <20220223101715.1009bd6f@gandalf.local.home>
In-Reply-To: <20220222232316.14640-4-beaub@linux.microsoft.com>
References: <20220222232316.14640-1-beaub@linux.microsoft.com>
        <20220222232316.14640-4-beaub@linux.microsoft.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 22 Feb 2022 15:23:16 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> Adds unit tests for user_events when available. Ensures APIs are working
> correctly and appropriate errors are being returned.
> 
> Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> ---
>  utest/tracefs-utest.c | 233 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 233 insertions(+)
> 

OK, so I couldn't get the selftest working because I didn't have
user_events.h. I then worked to get that, but the selftest still failed
with:

After thinking about this a bit, I've decided that I'll release 1.3 without
this patch series.

The reason being, I want 1.3 to get into distros ASAP. As adding this patch
series will put a dependency on user_events.h (yes it builds without it,
but distros want everything that it can build applied), then that puts a
dependency on 1.3 to having user_events.h available, which may be a while
as it has to get into 5.18, and then slowly move to the distro kernels.

If distros did build it without user_events.h and then later on with
user_evnets.h then we have two versions of 1.3 where one supports
user_events and one does not. And you can not use versioning to determine
if your application will link to the library or not.

With all this in mind, I've decided to hold off this to libtracefs 1.4, and
when user_events is solidly in the kernel.

But I'm very excited to have this work in both the kernel and libtracefs. I
just want it properly done though.

Thanks for all your work and I'll keep these patches in my queue for 1.4.

Cheers,

-- Steve
