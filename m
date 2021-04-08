Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAAC2C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 12:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EF686008E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 12:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhDHM7t (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 08:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231508AbhDHM7s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 08:59:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF815610FC;
        Thu,  8 Apr 2021 12:59:36 +0000 (UTC)
Date:   Thu, 8 Apr 2021 08:59:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] libtracefs: Add new API for open trace marker file
Message-ID: <20210408085935.77e2fd4e@gandalf.local.home>
In-Reply-To: <20210408080821.3129896-1-tz.stoyanov@gmail.com>
References: <20210408080821.3129896-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  8 Apr 2021 11:08:21 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Added new APIs for opening trace_marker file of given instance:
>    tracefs_marker_init()
>    tracefs_marker_write()
>    tracefs_marker_vprint()
>    tracefs_marker_print()
>    tracefs_marker_close()

I really don't like the name as it's more about the tracefs implementation
and not what it's used for. I much rather have:

	tracefs_print_init();
	tracefs_printf();
	tracefs_vprintf();
	tracefs_print_close();

And you should never write binary into the trace_marker file, as it always
expects ascii strings. That's the trace_marker_raw file. In which case we
could have:

	tracefs_binary_init();
	tracefs_binary_write();
	tracefs_binary_close();

For binary writes.

-- Steve
