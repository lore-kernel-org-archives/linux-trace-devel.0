Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55389C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 22:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24DDF23609
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 22:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbhAGW1J (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 17:27:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728295AbhAGW1J (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 17:27:09 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03109233A0;
        Thu,  7 Jan 2021 22:26:28 +0000 (UTC)
Date:   Thu, 7 Jan 2021 17:26:27 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] kernel-shark: Visualization plugin tools
Message-ID: <20210107172627.25233ee1@gandalf.local.home>
In-Reply-To: <20210107161547.207270-1-y.karadz@gmail.com>
References: <20210107161547.207270-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  7 Jan 2021 18:15:41 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> We implement a general purpose instruments, that can be used to
> implement efficient (fast) visualization plugins. We also use
> the new instrumentation to optimize the sched_events plugin.
> 
> Changes in v2:
>  * KS_DOUBLE_SIZE macro was simplified, based on the suggestion made by
>    Steven in his review. A dedicated test case for the macro has been added.
>  * Bug fix in kshark_free_data_container().
>  * Bug fix in kshark_data_container_append().

The only change you need to make is to fix a couple of typos (there's a
couple more "Intput") and add your signed-off-by.

I originally just fixed the typos myself and added a comment about it in
the change log, but when I saw the missing SOB, that's something I can't
fix.

Please send a v3.

Thanks!

-- Steve


> 
> 
> Yordan Karadzhov (VMware) (6):
>   kernel-shark: Add KS_DOUBLE_SIZE macro
>   kernel-shark: Add kshark_data_container to libkshark
>   kernel-shark: Add KS_DEFINE_PLUGIN_CONTEXT macro
>   kernel-shark: Start using C++17
>   kernel-shark: Add plotting methods to KsPlugins
>   kernel-shark: Speed-up the sched_events plugin
> 
>  CMakeLists.txt              |   8 +-
>  src/CMakeLists.txt          |   5 +-
>  src/KsPlugins.cpp           | 416 ++++++++++++++++++++++++++++++++++++
>  src/KsPlugins.hpp           |  48 +++++
>  src/libkshark-plugin.h      |  59 +++++
>  src/libkshark-tepdata.c     |  34 +++
>  src/libkshark-tepdata.h     |   7 +
>  src/libkshark.c             | 158 +++++++++++++-
>  src/libkshark.h             |  43 ++++
>  src/plugins/CMakeLists.txt  |  11 +-
>  src/plugins/SchedEvents.cpp | 310 +++++++--------------------
>  src/plugins/sched_events.c  | 393 +++++++++++-----------------------
>  src/plugins/sched_events.h  |  50 ++---
>  tests/libkshark-tests.cpp   |  89 ++++++++
>  14 files changed, 1071 insertions(+), 560 deletions(-)
>  create mode 100644 src/KsPlugins.cpp
> 

