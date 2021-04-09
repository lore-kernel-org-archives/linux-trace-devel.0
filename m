Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4B7C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 374FD610D1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhDIS03 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 14:26:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234508AbhDIS03 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 14:26:29 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCE18610E5;
        Fri,  9 Apr 2021 18:26:15 +0000 (UTC)
Date:   Fri, 9 Apr 2021 14:26:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com
Subject: Re: [PATCH v4 0/5] Refactor the APIs for tracing options
Message-ID: <20210409142614.03adf601@gandalf.local.home>
In-Reply-To: <20210409180423.72497-1-y.karadz@gmail.com>
References: <20210409180423.72497-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  9 Apr 2021 21:04:18 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Yordan Karadzhov (VMware) (5):
>   libtracefs: Fix issues with tracefs_option_id()
>   libtracefs: Modify the arguments of tracefs_option_is_set()
>   libtracefs: Encapsulate "struct tracefs_options_mask"
>   libtracefs: Option's bit masks to be owned by the instance
>   libtracefs: Rename tracefs_option_is_set()
> 
>  Documentation/libtracefs-option-bits.txt |  10 +--
>  Documentation/libtracefs-option-get.txt  |   7 +-
>  include/tracefs-local.h                  |  12 +++
>  include/tracefs.h                        |  11 +--
>  src/tracefs-instance.c                   |  15 ++++
>  src/tracefs-tools.c                      | 103 +++++++++--------------
>  utest/tracefs-utest.c                    |  12 +--
>  7 files changed, 81 insertions(+), 89 deletions(-)
> 

Bah, I just noticed this patch series after sending out my own.

OK, I'll use this one and see if it covers everything.

Thanks!

-- Steve

