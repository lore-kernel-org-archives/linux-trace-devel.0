Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77DCC004D4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Jan 2023 22:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjASWOK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Jan 2023 17:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjASWNc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Jan 2023 17:13:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCD85F394
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Jan 2023 13:53:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3FB30CE25B2
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Jan 2023 21:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373D6C433F2;
        Thu, 19 Jan 2023 21:53:05 +0000 (UTC)
Date:   Thu, 19 Jan 2023 16:53:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd record: Verify that splice works before using
 it
Message-ID: <20230119165303.357351b9@gandalf.local.home>
In-Reply-To: <d1ab88e414c66197163b80951fcf8639fb3d8f89.camel@sipsolutions.net>
References: <20220608130527.26e50cba@gandalf.local.home>
        <d1ab88e414c66197163b80951fcf8639fb3d8f89.camel@sipsolutions.net>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 19 Jan 2023 22:03:27 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Wed, 2022-06-08 at 13:05 -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > Add a test to make sure that splice works on the source directory before
> > using it, and if not automatically switch over to read/write method.
> > 
> > Suggested-by: Johannes Berg <johannes@sipsolutions.net>
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213659
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > ---
> > Johannes, can you test this?
> > I want to make sure that it fixes the issue.
> >   
> 
> Umm, yeah, long time ago. Sorry, I've been meaning to do that, but it
> isn't easy, so I kept pushing it off.
> 
> My use case for this was UML with hostfs, which I've since fixed (kernel
> upstream commit 1568cb0e6d97 ("hostfs: support splice_write"); I can
> revert that easily of course, but then I still have to build my own
> trace-cmd with that patch... But that needs libtracefs 1.6 which even
> Fedora doesn't ship.

They should ;-)

> 
> Given that you've merged the patch already, I think I'll just give up on
> testing it, sorry about that.

No worries. I'll just close the bug. Thanks, for responding.

-- Steve
