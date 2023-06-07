Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD819C7EE25
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jun 2023 17:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjFGRYz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jun 2023 13:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbjFGRYx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jun 2023 13:24:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390A41FE2
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jun 2023 10:24:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47BD0616A8
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jun 2023 17:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7DDC433D2;
        Wed,  7 Jun 2023 17:24:28 +0000 (UTC)
Date:   Wed, 7 Jun 2023 13:24:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Add Makefie target for memory test
Message-ID: <20230607132426.1ddc7fce@gandalf.local.home>
In-Reply-To: <20230607120202.86447-1-tz.stoyanov@gmail.com>
References: <20230607120202.86447-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  7 Jun 2023 15:02:02 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Having an automated test for memory problems is a useful functionality.
> Combined with the trace-cmd unit test, it can be used to detect any
> memory issues in the application. New Makefile target is added, which
> runs the trace-cmd unit test on valgrind, to check for memory allocation
> errors.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

Thanks Tzvetomir!

I'll queue this up, along with a few patches to fix up some of the reports.
Basically caused by the test, not what it was testing.

-- Steve

