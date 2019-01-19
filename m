Return-Path: <SRS0=psbM=P3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16AB8C61CE8
	for <linux-trace-devel@archiver.kernel.org>; Sat, 19 Jan 2019 09:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E49582087E
	for <linux-trace-devel@archiver.kernel.org>; Sat, 19 Jan 2019 09:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbfASJMx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 19 Jan 2019 04:12:53 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:48378 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbfASJMx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 19 Jan 2019 04:12:53 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gkmgM-0000n5-NA; Sat, 19 Jan 2019 10:12:50 +0100
Message-ID: <5b9bab6a1749682b80f4642e53567d032b3e4e69.camel@sipsolutions.net>
Subject: Re: trace-cmd python
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Date:   Sat, 19 Jan 2019 10:12:49 +0100
In-Reply-To: <20190115094451.119784d5@gandalf.local.home>
References: <1524143246.3024.21.camel@sipsolutions.net>
         <20190103224300.418e002b@vmware.local.home>
         <20190109153650.0261951b@gandalf.local.home>
         <b8e933bd8fc5f6a1aac94beced2ee75b8729975b.camel@sipsolutions.net>
         <20190115094451.119784d5@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

> DESTDIR is where you want to install it for moving it to another
> machine. If you plan on running trace-cmd on the same machine, but
> having it look elsewhere, then just using prefix should be enough.

Ok. I think it was partially installed due to bash completion failing,
but I see how I can work around that :)

> > If I symlink it to a place where trace-cmd actually looks for it then I
> > get errors in python saying pevent_record_data_get() is not defined, but
> 
> Looks to be an old object that it's linking with, as we replaced all
> "pevent_" with "tep_".

No - you forgot to replace it in a few places in the python files :-)

You also forgot to include the new trace-seq.h file into python, so it
was again failing on that.

Patch coming.

johannes

