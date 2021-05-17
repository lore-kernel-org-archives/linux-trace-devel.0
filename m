Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D201C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 23:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 237E661353
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 23:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhEQXWY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 19:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231318AbhEQXWX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 19:22:23 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B30C611BD;
        Mon, 17 May 2021 23:21:06 +0000 (UTC)
Date:   Mon, 17 May 2021 19:21:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Final fixes before KS 2.0
Message-ID: <20210517192104.0272eb84@gandalf.local.home>
In-Reply-To: <20210517142140.286153-1-y.karadz@gmail.com>
References: <20210517142140.286153-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 17 May 2021 17:21:33 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> v2 changes:
>  - Still showing all CPU plots from the new trace file when
>    appending [PATCH kernel-shark: Preserve open graphs when
>    appending data].
>  - Setting "seq.buffer" to NULL after calling trace_seq_destroy()
>    in [PATCH kernel-shark: Fix the checking if "trace_seq" was destroyed]
>  - [PATCH kernel-shark: No slash at the end of KS_PLUGIN_INSTALL_PREFIX]
>    is new.

Hi Yordan,

I was playing a bit with kernelshark, and found that if I load a file and
append one, exit, load them again, then click:

  File -> Sessions -> Restore Last Session

It crashes.

Looks to be something is freed and then reused, because when I ran it under
gdb, it crashed in allocation of memory (asprintf). That usually means that
something was freed twice, someplace else. Or freed and then used.

-- Steve
