Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FEDCC433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Mar 2021 16:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 380EF61A32
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Mar 2021 16:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhCZQuk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Mar 2021 12:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230198AbhCZQuP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Mar 2021 12:50:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4959C61A28
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Mar 2021 16:50:15 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lPpf4-0026SK-5S
        for linux-trace-devel@vger.kernel.org; Fri, 26 Mar 2021 12:50:14 -0400
Message-ID: <20210326164843.976844292@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 26 Mar 2021 12:48:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] trace-cmd: Start 3.0 development and remove libraries
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Now that trace-cmd has started 3.0 development and will rely on
the external repositories of libtraceevent and libtracefs, remove
the local versions of the code.

KernelShark will soon be removed as well, but not before libtracecmd
is officially released.


Steven Rostedt (VMware) (3):
      trace-cmd: Start on development of v3.0
      trace-cmd: Remove libtraceevent code
      trace-cmd: Remove libtracefs code

----
 Makefile                                      |   85 +-
 lib/traceevent/Makefile                       |   72 -
 lib/traceevent/event-parse-api.c              |  333 --
 lib/traceevent/event-parse-local.h            |  123 -
 lib/traceevent/event-parse.c                  | 7651 -------------------------
 lib/traceevent/event-plugin.c                 |  712 ---
 lib/traceevent/include/event-utils.h          |   67 -
 lib/traceevent/kbuffer-parse.c                |  813 ---
 lib/traceevent/parse-filter.c                 | 2278 --------
 lib/traceevent/parse-utils.c                  |   62 -
 lib/traceevent/plugins/Makefile               |   83 -
 lib/traceevent/plugins/plugin_blk.c           |  375 --
 lib/traceevent/plugins/plugin_cfg80211.c      |   43 -
 lib/traceevent/plugins/plugin_function.c      |  282 -
 lib/traceevent/plugins/plugin_futex.c         |  125 -
 lib/traceevent/plugins/plugin_hrtimer.c       |   70 -
 lib/traceevent/plugins/plugin_jbd2.c          |   63 -
 lib/traceevent/plugins/plugin_kmem.c          |   82 -
 lib/traceevent/plugins/plugin_kvm.c           |  526 --
 lib/traceevent/plugins/plugin_mac80211.c      |  188 -
 lib/traceevent/plugins/plugin_python_loader.c |  108 -
 lib/traceevent/plugins/plugin_sched_switch.c  |  145 -
 lib/traceevent/plugins/plugin_scsi.c          |  434 --
 lib/traceevent/plugins/plugin_tlb.c           |   66 -
 lib/traceevent/plugins/plugin_xen.c           |  138 -
 lib/traceevent/tep_strerror.c                 |   53 -
 lib/traceevent/trace-seq.c                    |  249 -
 lib/tracefs/Makefile                          |   70 -
 lib/tracefs/include/tracefs-local.h           |   30 -
 lib/tracefs/tracefs-events.c                  |  626 --
 lib/tracefs/tracefs-instance.c                |  455 --
 lib/tracefs/tracefs-utils.c                   |  230 -
 32 files changed, 33 insertions(+), 16604 deletions(-)
 delete mode 100644 lib/traceevent/Makefile
 delete mode 100644 lib/traceevent/event-parse-api.c
 delete mode 100644 lib/traceevent/event-parse-local.h
 delete mode 100644 lib/traceevent/event-parse.c
 delete mode 100644 lib/traceevent/event-plugin.c
 delete mode 100644 lib/traceevent/include/event-utils.h
 delete mode 100644 lib/traceevent/kbuffer-parse.c
 delete mode 100644 lib/traceevent/parse-filter.c
 delete mode 100644 lib/traceevent/parse-utils.c
 delete mode 100644 lib/traceevent/plugins/Makefile
 delete mode 100644 lib/traceevent/plugins/plugin_blk.c
 delete mode 100644 lib/traceevent/plugins/plugin_cfg80211.c
 delete mode 100644 lib/traceevent/plugins/plugin_function.c
 delete mode 100644 lib/traceevent/plugins/plugin_futex.c
 delete mode 100644 lib/traceevent/plugins/plugin_hrtimer.c
 delete mode 100644 lib/traceevent/plugins/plugin_jbd2.c
 delete mode 100644 lib/traceevent/plugins/plugin_kmem.c
 delete mode 100644 lib/traceevent/plugins/plugin_kvm.c
 delete mode 100644 lib/traceevent/plugins/plugin_mac80211.c
 delete mode 100644 lib/traceevent/plugins/plugin_python_loader.c
 delete mode 100644 lib/traceevent/plugins/plugin_sched_switch.c
 delete mode 100644 lib/traceevent/plugins/plugin_scsi.c
 delete mode 100644 lib/traceevent/plugins/plugin_tlb.c
 delete mode 100644 lib/traceevent/plugins/plugin_xen.c
 delete mode 100644 lib/traceevent/tep_strerror.c
 delete mode 100644 lib/traceevent/trace-seq.c
 delete mode 100644 lib/tracefs/Makefile
 delete mode 100644 lib/tracefs/include/tracefs-local.h
 delete mode 100644 lib/tracefs/tracefs-events.c
 delete mode 100644 lib/tracefs/tracefs-instance.c
 delete mode 100644 lib/tracefs/tracefs-utils.c
