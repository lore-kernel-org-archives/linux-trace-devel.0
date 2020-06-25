Return-Path: <SRS0=vwyE=AG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1375C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBD29206B7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:05:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hppOUCSw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390025AbgFYKFV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jun 2020 06:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390020AbgFYKFU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jun 2020 06:05:20 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAFCC061573
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:05:19 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id o2so5303626wmh.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZL9wck4hxQX7CTyDJQW7jLLwSa1LayNeEecIS+qfNKo=;
        b=hppOUCSwa2NExyfok4v7KAP+sfK02XFQWGnK0YTLJEfFcuj/Pz+aCi9ypWGLMxdzRO
         R2N3lmjRR1a/9OEqoyfEkXKZkuOYWnX7I3My0OrDszODp4lO/u7JNtbHPQTG+hzJ9/+c
         fFR90O8OQiNTTs5MktLZwRoEv5IVp48TZcsB/6zW0q8xC0W01aVzvqgLzGK+P3CSjKxz
         FHCIgtFZkevFW8qioSf9agkUlk5+8bACysdJjV//MdvN6eXmC+7ncmBSyIl9k0kfHAHw
         7kpd7DpNuNfqokC1g10Mz3TsJDLQmdRsGdmawWptyezXoX6bxmqYws+1qV22ohLaDdZz
         seEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZL9wck4hxQX7CTyDJQW7jLLwSa1LayNeEecIS+qfNKo=;
        b=AsprEbDMANHQLIqIyCMxk7uLMi6BMXx52yCk3DSVLHfQjBJIPI5ST2gtPCMzm15s62
         wQEtEbJsYbSmDDHa1fXctk0WFAgSKE57UnIVrDti1cOZB1AJLGM8l8owWtURm62fzXAr
         zuQi49Wp3iKdytOGKPkWuRUJAcF//WV+t8zoeLuC8VZxj/7tfWhHQm2k2vApYu+lq7uM
         mlRJrx3Xv4/RI5aU3fbzyudJFvYwKea6Psv86z5C//7+yJ9pPUHlgqy98WPumyP+kgji
         uD+pIo6mK+e/DCqfUpEDcVnCre7tQ0Cnqwn6RsmAvgcd4hIXWAowgQBsP+zSl32d8OF9
         tVzQ==
X-Gm-Message-State: AOAM531PaYzcYa/c5HjSqjJo719huN/Mlk+zAmw+EjNVxdXkMlJlWbRW
        S/ZhbIE0BddO7Vq2uRX2nu4=
X-Google-Smtp-Source: ABdhPJzeFNet1S8GiqqqgtcSRkQkU48kBgo+T/OQi2dPahK41mX2HnlTkfZUOupVf2x+FU4C2buvLQ==
X-Received: by 2002:a1c:bc8a:: with SMTP id m132mr1811547wmf.1.1593079518335;
        Thu, 25 Jun 2020 03:05:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v7sm31268204wrp.45.2020.06.25.03.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 03:05:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 00/15] Synchronize libtraceevent with trace-cmd
Date:   Thu, 25 Jun 2020 13:05:07 +0300
Message-Id: <20200625100516.365338-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Backported traceevent library patches from trace-cmd lib/traceevent

Jan Kiszka (2):
  tools lib traceevent: Add more SVM exit reasons
  tools lib traceevent: Fix reporting of unknown SVM exit reasons

Julia Cartwright (1):
  tools lib traceevent: Add plugin for decoding syscalls/sys_enter_futex

Steven Rostedt (Red Hat) (2):
  tools lib traceevent: Add --debug to trace-cmd report
  tools lib traceevent: Add plugin for tlb_flush

Steven Rostedt (VMware) (3):
  tools lib traceevent: Add -O offset for function plugin
  tools lib traceevent: Add builtin handler for trace_marker_raw
  tools lib traceevent: Change to SPDX License format

Tom Zanussi (1):
  tools lib traceevent: Add proper KBUFFER_TYPE_TIME_STAMP handling

Tzvetomir Stoyanov (VMware) (6):
  tools lib traceevent: Remove trace-cmd plugin handling routines
  tools lib traceevent: Move plugin options from trace-cmd to
    libtraceevent.
  tools lib traceevent: Introduced new traceevent API, for adding new
    plugins directories.
  tools lib traceevent: Add support for more printk format specifiers
  tools lib traceevent: Optimize pretty_print() function
  tools lib traceevent: Move kernel_stack event handler to "function"
    plugin.

 tools/lib/traceevent/event-parse-local.h      |   22 +-
 tools/lib/traceevent/event-parse.c            | 1004 ++++++++++++-----
 tools/lib/traceevent/event-parse.h            |   34 +-
 tools/lib/traceevent/event-plugin.c           |  261 ++++-
 tools/lib/traceevent/kbuffer-parse.c          |   43 +-
 tools/lib/traceevent/kbuffer.h                |   19 +-
 tools/lib/traceevent/plugins/Build            |    2 +
 tools/lib/traceevent/plugins/Makefile         |    2 +
 .../lib/traceevent/plugins/plugin_function.c  |  123 +-
 tools/lib/traceevent/plugins/plugin_futex.c   |  123 ++
 tools/lib/traceevent/plugins/plugin_hrtimer.c |   17 +-
 tools/lib/traceevent/plugins/plugin_jbd2.c    |   17 +-
 tools/lib/traceevent/plugins/plugin_kmem.c    |   17 +-
 tools/lib/traceevent/plugins/plugin_kvm.c     |   42 +-
 .../lib/traceevent/plugins/plugin_mac80211.c  |   17 +-
 .../traceevent/plugins/plugin_sched_switch.c  |   17 +-
 tools/lib/traceevent/plugins/plugin_tlb.c     |   66 ++
 17 files changed, 1406 insertions(+), 420 deletions(-)
 create mode 100644 tools/lib/traceevent/plugins/plugin_futex.c
 create mode 100644 tools/lib/traceevent/plugins/plugin_tlb.c

-- 
2.26.2

