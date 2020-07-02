Return-Path: <SRS0=hXpH=AN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97DBCC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C70C20702
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:49:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uPuJMCEQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgGBRt4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jul 2020 13:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbgGBRtz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jul 2020 13:49:55 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E06FC08C5C1
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Jul 2020 10:49:55 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id f18so29266110wml.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Jul 2020 10:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZL9wck4hxQX7CTyDJQW7jLLwSa1LayNeEecIS+qfNKo=;
        b=uPuJMCEQJdeyECFR3bb6vfNDrYWanvAxM6KEsTF6lyGaIEHZns5GRXJS7/fJ7eucHe
         HMdC9HDxc62ioClljt48CkEQ9IRjlKCka746rxW4rI69tJkGxjQKLPeFtxxedeoXP1EY
         qAr8dzDTM0r094asja9RHR73fiYpCTGIfytxVv530hzdnCht1p3xrprmPHUI9K7s67Bh
         Sdnh52ZbEsEvJX7pVojtgOQUqyz42b/T/a1gVBGmkpoTD1JRhNABDrfy4tSw2W6CUaVw
         wMp7SCRYEkR4zb0nWq0cG+0KCAMNj0WpvJYT4nVLx9GbLGIA0iofZCoG25kr9HbLYWJC
         oKzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZL9wck4hxQX7CTyDJQW7jLLwSa1LayNeEecIS+qfNKo=;
        b=NuWSdhUDZv0nCDAPfB9RR9ROM4jea/y6OtnmesicLI64SGO8Jndh6GP2xkviVAWgbQ
         8EzYz504TatxFj/xkKzEtO7eRD/w7bCILLOYsgtVOmUW1eZ5A/UKM6SRKFg5UWm8WX+r
         t5OdcO554lJ65yOdb1I99vvqkihvuRj5h6/l2ayqCGFTNUMAm7SBy/LIaBQsmGcpwo5b
         oEx78Tlm6eDoQQVVleEPdymZVpqoXHTTDp3WcaB7KgbxRcoLF/TMemN07Fw0GwfnLIar
         c/HIUoPYTeXzAm6B3APObNbcZALFd9Q5iBSBp2Qa0HJmpfMhdySRX0L7jJ5xHN7Bfi6y
         9YJw==
X-Gm-Message-State: AOAM530zFHl6wKBJ4w0DvQk6M6QCSaOCosENMJ0UFSL52KiKtSU6xQJM
        0QxUvUzwsmq2qovadzA21cuvRQTwGnM=
X-Google-Smtp-Source: ABdhPJygio8QohlDLedI8BB4Ub6mbNYvN9m8vWF84puOsMBm/iFCKq3XX0PgrnwFhvbK0O4yEQDKng==
X-Received: by 2002:a1c:1f54:: with SMTP id f81mr32645084wmf.4.1593712193568;
        Thu, 02 Jul 2020 10:49:53 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g82sm9289319wma.37.2020.07.02.10.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:49:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 00/15] Synchronize libtraceevent with trace-cmd
Date:   Thu,  2 Jul 2020 20:49:44 +0300
Message-Id: <20200702174950.123454-1-tz.stoyanov@gmail.com>
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

