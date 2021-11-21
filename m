Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8196C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sun, 21 Nov 2021 21:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhKUV2O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 21 Nov 2021 16:28:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229709AbhKUV2O (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 21 Nov 2021 16:28:14 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84E7460240;
        Sun, 21 Nov 2021 21:25:08 +0000 (UTC)
Date:   Sun, 21 Nov 2021 16:25:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, amikhak@wirelessfabric.com
Subject: Re: [PATCH] libtracefs: Use getpid instead of gettid
Message-ID: <20211121162507.69dda556@rorschach.local.home>
In-Reply-To: <20211118165727.75994-1-tz.stoyanov@gmail.com>
References: <20211118165727.75994-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 18 Nov 2021 18:57:27 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The gettid() call is not available on Jetson Nano running Ubuntu
> 18.04 for aarch64. This function is used to compose a random seed,
> replaced it with getpid().
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203871
> Reported-by: Alan Mikhak <amikhak@wirelessfabric.com>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---

I guess I hit this earlier but never applied my fix :-/

https://patchwork.kernel.org/project/linux-trace-devel/patch/20210825195300.0f15d98a@rorschach.local.home/

-- Steve
