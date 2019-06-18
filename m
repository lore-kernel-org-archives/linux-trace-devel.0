Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F5FFC31E5B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 17:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 568D6205F4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 17:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbfFRRyP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 13:54:15 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:44620 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729586AbfFRRyO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 13:54:14 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hdIJ8-0003hC-LD; Tue, 18 Jun 2019 19:54:10 +0200
Message-ID: <5e7dc4f8b24431a0a6e417d64ed9c30d8cf19cb7.camel@sipsolutions.net>
Subject: Re: [PATCH v2 1/2] trace-cmd: Fix crash when trace-cmd is executed
 with args "profile -F sleep 1"
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Date:   Tue, 18 Jun 2019 19:54:05 +0200
In-Reply-To: <20190618122009.0998021e@gandalf.local.home>
References: <20190605111937.17894-1-tstoyanov@vmware.com>
         <20190618122009.0998021e@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 2019-06-18 at 12:20 -0400, Steven Rostedt wrote:

> Heads up. Johannes found a regression that this code above causes
> reading a 1.7G file where the above code makes it go from reading it in
> 5 seconds, to over 2 minutes!

Actually, I didn't even let it finish ... It was something like 4.5
seconds to not finishing in 4.5 minutes, then I gave up. My prior
version was commit 1ad32c24746.

The file is 1.7G, but that's perhaps not the interesting part? A little
under 620k events - by my standards, that's a small file :-)

> I bisected it down to this commit (saw a small, but not so drastic
> performance issue it my tests). I asked Johannes to revert the commit,
> and he said that it removed the regression.

With that reverted I actually see ~2 seconds now, which is 2x faster
than before :-)

> He said he'll report this in the Bugzilla, but we should be looking at
> changing the realloc() logic.

https://bugzilla.kernel.org/show_bug.cgi?id=203927

johannes

