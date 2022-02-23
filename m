Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB0C3C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 03:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbiBWD3x (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 22:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiBWD3w (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 22:29:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F74238DB9
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 19:29:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A7A8B81CA4
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 03:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2196C340E8;
        Wed, 23 Feb 2022 03:29:22 +0000 (UTC)
Date:   Tue, 22 Feb 2022 22:29:21 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] libtracefs: Add user_events to libtracefs
 sources
Message-ID: <20220222222921.4d9c2d70@rorschach.local.home>
In-Reply-To: <20220222232316.14640-2-beaub@linux.microsoft.com>
References: <20220222232316.14640-1-beaub@linux.microsoft.com>
        <20220222232316.14640-2-beaub@linux.microsoft.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 22 Feb 2022 15:23:14 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> The user events are scheduled to be included into Linux 5.18, which
> register a special mmapped page to denote when the user event is enabled
> (from an external source). This API adds a wrapper to the kernel
> interface that makes it easy to register user events and test if they
> are enabled and to record the event when it is.
> 
> Link:
> https://lore.kernel.org/linux-trace-devel/20220121192833.GA3128@kbox/T/#m2bcf53c373fbeaba2c46d1a053b3174171167e4e

I was afraid you would copy me ;-)

After I sent the email, I noticed that claws-mail decided to line wrap
that line putting the link on a different line than the Link tag. It
was suppose to be:

Link: https://lore.kernel.org/linux-trace-devel/20220121192833.GA3128@kbox/T/#m2bcf53c373fbeaba2c46d1a053b3174171167e4e

But claws-mail decided otherwise :-p

And worse, it did it while it was not in my editor view, so I had no
idea it did it. That's a bug in claws-mail that has been bothering me
for some time.

-- Steve

> 
> Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> ---
>
