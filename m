Return-Path: <SRS0=PpJY=X3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7322C352AA
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Oct 2019 11:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98A2721929
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Oct 2019 11:41:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wx32HEiL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfJBLl5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Oct 2019 07:41:57 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38591 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfJBLl5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Oct 2019 07:41:57 -0400
Received: by mail-wm1-f66.google.com with SMTP id 3so6645751wmi.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Oct 2019 04:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E8kDCvFUCfLV3V+jGNKj2xKU+mXfuFS41PMM2UtFHIs=;
        b=Wx32HEiLjiBU+YX038MObyEdMp4+IkS4Mc5o0E8ATDH7dSVOqsHE8giciWw7ZSHQK/
         CUqPpSBvlFunyx23qzRldjjysHP29weqDPIKd/zIg+bam/asPJRgfIrVHavhdJE6KcXl
         mW6Yvp6Jdp+cgouWUS0PmdUa0eRd1gxsn5bPhfdLa8xmXXAzgV56XRmNYoTakl8x3pxJ
         onr7Qrhi4saZX6lOcjcaH0AxN75VbzRHv0+Jgz6saNepvbzQeBO6raRs9PTtCEl4ib7X
         IE7DRehc15gPNE4na29Nd1jK6VKGyAn9jJDFe5cjriHHqIPzljaCNZ2P7Wp1WhkQCl2j
         mQsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E8kDCvFUCfLV3V+jGNKj2xKU+mXfuFS41PMM2UtFHIs=;
        b=TgDTk6A+nDw0CE6oG87nFVp97hGCHKJGLTXjQzWwC+Ku7G7laACnMAuswdSbWSJ3xn
         3QfJdUxNXk5bnf3rHsjJu4F4K6Y8DdYwfA1yIYOI5QVcfIPX0Ua2Ig7EhV4m15EprS1K
         Qd9rk4cgo5B1e7c4IKsVAqemFgWw1NXtmpKRXDvAGAoQPu+GFWU7Tlvn8ahqRbx76jNA
         uzMyAGrYwbMzQ0y4uVcvzFu5mOOcqZM+M1wKZvqTpyVyQt94h6AW6cF+cF6M0bLyyQ3q
         SnuHDPVo0bXpyy288kr3FOOr6WiYiJhkHB9JLPskX0W2A0jcu9soPfsGMlBkCOtUTkzW
         8ZAQ==
X-Gm-Message-State: APjAAAUCzqdX1DBl4FUjdF+NTH8LUC8MvZ4/V7024EseTPsnUMHTCj0A
        gQI27tMQAZfR7UGnZXktRVV2E77b
X-Google-Smtp-Source: APXvYqzyZa8BQJfF6gHkKhArWF/jvMncxck4WAWxZ3sX+tc/Zs4cx9YKfkTK+JrMNROTKm05c+e3mw==
X-Received: by 2002:a1c:3281:: with SMTP id y123mr2398185wmy.34.1570016514767;
        Wed, 02 Oct 2019 04:41:54 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l4sm3004658wrw.6.2019.10.02.04.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 04:41:53 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/5] Remove redundant trace-cmd plugin handling logic
Date:   Wed,  2 Oct 2019 14:41:47 +0300
Message-Id: <20191002114152.30048-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently there are no trace-cmd related plugins, all of them
are designed to be used with libtraceeevnt. As both libtraceevent
and trace-cmd have logic for managing plugins, the one in trace-cmd
is redundant. Those redundant code is removed and replaced with calls
to libtraceeevnt plugin APIs. When trace-cmd has to load any plugins,
it uses libtraceeevnt to do the job.

All existing plugins are moved from plugins/ to lib/traceevent/plugins
directory, as all of them are designed to be used with the traceevent
library.

An initial infrastructure for trace-cmd specific plugins is added - 
new lib/trace-cmd/plugins directory and initial set of APIs
for working with trace-cmd plugins.

Tzvetomir Stoyanov (1):
  trace-cmd: Change plugin install directories

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd: Move libtraceevent plugins in its own directory.
  trace-cmd: Rename plugin_python to plugin_python_loader.
  trace-cmd: Load libtraceevent plugins from build folder, if exists.
  trace-cmd: Add initial infrastructure for trace-cmd specific plugins.

 .gitignore                                    |   4 +-
 Makefile                                      |  83 +++--
 include/trace-cmd/trace-cmd.h                 |  44 ++-
 lib/trace-cmd/Makefile                        |   3 +-
 lib/trace-cmd/plugins/Makefile                |  58 ++++
 lib/trace-cmd/trace-plugin.c                  | 313 ++++++++++++++++++
 lib/traceevent/event-plugin.c                 |  34 +-
 {plugins => lib/traceevent/plugins}/Makefile  |  16 +-
 .../traceevent/plugins}/plugin_blk.c          |   0
 .../traceevent/plugins}/plugin_cfg80211.c     |   0
 .../traceevent/plugins}/plugin_function.c     |   0
 .../traceevent/plugins}/plugin_futex.c        |   0
 .../traceevent/plugins}/plugin_hrtimer.c      |   0
 .../traceevent/plugins}/plugin_jbd2.c         |   0
 .../traceevent/plugins}/plugin_kmem.c         |   0
 .../traceevent/plugins}/plugin_kvm.c          |   0
 .../traceevent/plugins}/plugin_mac80211.c     |   0
 .../traceevent/plugins/plugin_python_loader.c |   0
 .../traceevent/plugins}/plugin_sched_switch.c |   0
 .../traceevent/plugins}/plugin_scsi.c         |   0
 .../traceevent/plugins}/plugin_tlb.c          |   0
 .../traceevent/plugins}/plugin_xen.c          |   0
 22 files changed, 505 insertions(+), 50 deletions(-)
 create mode 100644 lib/trace-cmd/plugins/Makefile
 create mode 100644 lib/trace-cmd/trace-plugin.c
 rename {plugins => lib/traceevent/plugins}/Makefile (81%)
 rename {plugins => lib/traceevent/plugins}/plugin_blk.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_cfg80211.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_function.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_futex.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_hrtimer.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_jbd2.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_kmem.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_kvm.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_mac80211.c (100%)
 rename plugins/plugin_python.c => lib/traceevent/plugins/plugin_python_loader.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_sched_switch.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_scsi.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_tlb.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_xen.c (100%)

-- 
2.21.0

