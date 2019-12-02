Return-Path: <SRS0=ia4w=ZY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3158C432C0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Dec 2019 21:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D18E2068E
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Dec 2019 21:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfLBVTR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 16:19:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbfLBVTR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 16:19:17 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F8EE2068E;
        Mon,  2 Dec 2019 21:19:16 +0000 (UTC)
Date:   Mon, 2 Dec 2019 16:19:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] trace-cmd: Load libtraceevent plugins from build
 folder, if exists.
Message-ID: <20191202161914.6d20622e@gandalf.local.home>
In-Reply-To: <CAPpZLN4hxVZEJyY5f4FZin+B34HMk5V4=K49ixkpFki5sJB7TA@mail.gmail.com>
References: <20191007114947.17104-1-tz.stoyanov@gmail.com>
        <20191007114947.17104-3-tz.stoyanov@gmail.com>
        <CAPpZLN4hxVZEJyY5f4FZin+B34HMk5V4=K49ixkpFki5sJB7TA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 2 Dec 2019 09:54:09 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> Ping.
> 
> I think this will be useful in avoiding problems like
> https://bugzilla.kernel.org/show_bug.cgi?id=205643
> 

Thanks for the ping, I thought I was waiting on a new version, but
obviously you already sent it out.

-- Steve

