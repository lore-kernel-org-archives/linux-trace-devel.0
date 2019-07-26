Return-Path: <SRS0=W4op=VX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A14C7618B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 15:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0050B218D4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 15:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbfGZPXC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 11:23:02 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51114 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbfGZPXC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 11:23:02 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hr23f-0005c4-KB; Fri, 26 Jul 2019 17:22:59 +0200
Message-ID: <32793aced94148751699879d77380d4c0f8475b5.camel@sipsolutions.net>
Subject: Re: [PATCH 3/3] trace-cmd: Use PyLong_AsLong() for Python 3
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Darren Hart <dvhart@infradead.org>, troyengel@gmail.com
Date:   Fri, 26 Jul 2019 17:22:58 +0200
In-Reply-To: <20190726111814.3a29472c@gandalf.local.home>
References: <20190719224613.207069107@goodmis.org>
         <20190719225030.507227790@goodmis.org>
         <076f6cad8adf6fd8eec78dfe7c8a76ed7d5914ae.camel@sipsolutions.net>
         <20190726111814.3a29472c@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

> Thanks for the review (unfortunately, due to the rush to get
> KernelShark 1.0 out, I already applied them, I should have Cc'd you on
> them too).

> 
> Should we make any of the above changes you mentioned to any of these
> patches? I'm looking at releasing trace-cmd 2.8.4 with all these
> changes and will hold off if you think it would be better to update
> them.

I don't think it matters.

The PyLong thing was just really cosmetic, could've saved some lines of
code.

The bytes vs. unicode - well, python assumes that you give it a utf-8
string, so even if we start using non-ASCII identifiers (which I think
is highly unlikely!), we'll likely use utf-8 in the kernel, and it would
either way not be an issue.

johannes

