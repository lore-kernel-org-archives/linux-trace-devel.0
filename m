Return-Path: <SRS0=27yZ=PX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3370FC43387
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Jan 2019 13:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FCBB20651
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Jan 2019 13:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbfAONJe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Jan 2019 08:09:34 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56086 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729050AbfAONJe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Jan 2019 08:09:34 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gjOTE-0007Lj-2X; Tue, 15 Jan 2019 14:09:32 +0100
Message-ID: <b8e933bd8fc5f6a1aac94beced2ee75b8729975b.camel@sipsolutions.net>
Subject: Re: trace-cmd python
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Date:   Tue, 15 Jan 2019 14:09:30 +0100
In-Reply-To: <20190109153650.0261951b@gandalf.local.home>
References: <1524143246.3024.21.camel@sipsolutions.net>
         <20190103224300.418e002b@vmware.local.home>
         <20190109153650.0261951b@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 2019-01-09 at 15:36 -0500, Steven Rostedt wrote:
> On Thu, 3 Jan 2019 22:43:00 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> 
> > I just checked, and this is still an issue today. I'll make sure that
> > this gets fixed soon.
> > 
> > Thanks for reporting! (even though it got lost in my INBOX :-( )
> > 
> 
> OK, I finally got around to looking at this. It was a bit of a pain to
> figure out. It was caused by the shuffling of the files around, as that
> was needed to do because trace-cmd was getting bigger. This caused the
> python ctracecmd.so to lose linking with the proper libraries and
> caused the undefined symbols.
> 
> I just fixed it and pushed it to the repo. Want to give it a try and
> see if it works for you?

Seems to work more or less.

Not sure how I managed to install it into a custom subdirectory of my
$HOME before, and make it load plugins - I can't seem to figure out the
right combination of prefix= and DESTDIR= anymore.

If I symlink it to a place where trace-cmd actually looks for it then I
get errors in python saying pevent_record_data_get() is not defined, but
could be that I'm not importing something right ...

What's a good way to install it into a custom directory without
affecting the whole machine?

johannes

