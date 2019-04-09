Return-Path: <SRS0=eAkL=SL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B87C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 07:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6050B20857
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 07:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfDIHu2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 03:50:28 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54629 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbfDIHu2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 03:50:28 -0400
Received: by mail-wm1-f66.google.com with SMTP id c1so793133wml.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Apr 2019 00:50:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VVPZtLgdWVqvheifFT/iAD3mdAoeuBLtyRxEHQdP2/w=;
        b=PGaAbz5hcq+rJosLKG/8ilFeCRaW0k4dpY4xItdajOa2NPmmNeqXTH59qYEGdzZgsQ
         4RfcANsfumFpnZ4RVIOO+yuhyhjxmzeWLo85dL7BEr/Ud6zULACichfZXY9ikfk4AKMV
         ogwo0u8RpYSkGPkwArDqELbjJMIGmNtd1ZUZUFiJA14SabHa12+763ckM4zFH3q7wG5k
         unFB6mgZMYO6HEbiHHKsuRe26ChnpJj+OafkcNORT3lwvTc0Hy0QzDFF0ARaKif6tuOJ
         +Huwasn7yRIwit3IWQDop9jqiESRyXeQyc2R9vuoFJuS+vonlPEh1OltnRsAcfE/Iw16
         JX2A==
X-Gm-Message-State: APjAAAWeegbIs88EGbbg4HVRGQmmD50ayRMLCyoCIN5CnDKXmYsTM1yr
        MTte3tPCs+gRr0C9mqNzXM75V4KM
X-Google-Smtp-Source: APXvYqwjfWa8izXeCZ/NR5qBosCKc+I4qAUSVaCv1uGixkSaSMtlcnefYZ7M7Qt9bkip0GDgrbIjTA==
X-Received: by 2002:a1c:ed12:: with SMTP id l18mr5497601wmh.13.1554796226095;
        Tue, 09 Apr 2019 00:50:26 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d14sm51766944wro.79.2019.04.09.00.50.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Apr 2019 00:50:25 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/5] Backport of traceevent APIs cleanup changes from kernel tree to trace-cmd
Date:   Tue,  9 Apr 2019 10:50:19 +0300
Message-Id: <20190409075024.30512-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
 v3 changes:
  Fixed broken Kernelshark compilation
  Excluded already merged patches from the series:
    tools lib traceevent: Removed unneeded !! and return parenthesis
    tools lib traceevent: Change description of few APIs
    tools lib traceevent: Implement new traceevent APIs for accessing
      struct tep_handler fields
    tools lib traceevent: Remove tep filter trivial APIs
    tools lib traceevent: Remove call to exit() from tep_filter_add_filter_str()

 v2 changes:
  Fixed broken links in the patches descriptions.
]

A set of patches which aligns kernel libtraceevent implementation to trace-cmd 
one:
 - Got rid of "pevent" in library APIs and internal code, replaced it with "tep"
 - Made the API more consistent: aligned all "tep_is ... " APIs to return bool

Tzvetomir Stoyanov (5):
  tools tools, tools lib traceevent: Make traceevent APIs more
    consistent
  tools lib traceevent: Rename input arguments of libtraceevent APIs
    from pevent to tep
  perf tools, tools lib traceevent: Rename "pevent" member of struct
    tep_event to "tep"
  perf tools, tools lib traceevent: Rename "pevent" member of struct
    tep_event_filter to "tep"
  tools lib traceevent: Rename input arguments and local variables of
    libtraceevent from pevent to tep

 include/traceevent/event-parse.h        | 132 ++--
 kernel-shark/src/libkshark.c            |   2 +-
 kernel-shark/src/plugins/sched_events.c |   2 +-
 lib/trace-cmd/trace-ftrace.c            |  16 +-
 lib/trace-cmd/trace-input.c             |  10 +-
 lib/traceevent/event-parse-api.c        | 148 ++---
 lib/traceevent/event-parse-local.h      |   6 +-
 lib/traceevent/event-parse.c            | 790 ++++++++++++------------
 lib/traceevent/event-plugin.c           |  32 +-
 lib/traceevent/parse-filter.c           |  44 +-
 plugins/plugin_blk.c                    |   8 +-
 plugins/plugin_cfg80211.c               |   8 +-
 plugins/plugin_function.c               |  22 +-
 plugins/plugin_hrtimer.c                |  13 +-
 plugins/plugin_jbd2.c                   |  12 +-
 plugins/plugin_kmem.c                   |  34 +-
 plugins/plugin_kvm.c                    |  49 +-
 plugins/plugin_mac80211.c               |   6 +-
 plugins/plugin_sched_switch.c           |  18 +-
 plugins/plugin_scsi.c                   |   8 +-
 plugins/plugin_xen.c                    |   8 +-
 python/ctracecmd.i                      |   4 +-
 python/tracecmd.py                      |   2 +-
 tracecmd/trace-output.c                 |   2 +-
 tracecmd/trace-profile.c                |   4 +-
 tracecmd/trace-read.c                   |   4 +-
 tracecmd/trace-split.c                  |   2 +-
 27 files changed, 694 insertions(+), 692 deletions(-)

-- 
2.20.1

