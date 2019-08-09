Return-Path: <SRS0=Xrzw=WF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BBE4C31E40
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 15:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CBFB217D7
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 15:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407262AbfHIPCd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 11:02:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407209AbfHIPCd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 11:02:33 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90E95208C4;
        Fri,  9 Aug 2019 15:02:32 +0000 (UTC)
Date:   Fri, 9 Aug 2019 11:02:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/7] trace-cmd: Move trace-output.c into the library
 code
Message-ID: <20190809110231.3d2b106b@gandalf.local.home>
In-Reply-To: <20190809095907.429e47b5@gandalf.local.home>
References: <20190711130307.25041-1-tz.stoyanov@gmail.com>
        <20190711130307.25041-2-tz.stoyanov@gmail.com>
        <20190808193755.346da18f@gandalf.local.home>
        <CACqStocrJeq70HKFbb_epyQMV1xdtaJ2ywm77uf5ht22KAp0cw@mail.gmail.com>
        <20190809095907.429e47b5@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 9 Aug 2019 09:59:07 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> And this is created via the Makefile. Hmm, we may need to move all the
> file version logic into lib/trace-event as the only files that should

 sorry, that should have said lib/trace-cmd/

-- Steve

> ever care about this is trace-output.c and trace-input.c, which are
> both in the lib/trace-event (not something trace-cmd should worry
> about).
>
