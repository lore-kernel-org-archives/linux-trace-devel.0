Return-Path: <SRS0=Gl8V=SH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92506C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 14:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69C5421850
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 14:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbfDEODh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 10:03:37 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33665 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfDEODh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 10:03:37 -0400
Received: by mail-wr1-f65.google.com with SMTP id q1so8205140wrp.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Apr 2019 07:03:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P5cUaG/OJS+v0EFBOHY1XM/rex/Q+ltZOCHjVYAWb4Q=;
        b=JmzHMaSY0hdU1ERue9t8zHnScygaJnrnYjj/jxsXbIdYmi1Pwkh9ss7gvIt418Euwk
         j/4S4huKOL+LW+WCYVXWJi/95lguSwl3DsT+QO2wAl57pzAMi/aOXDXFE0OcFetUp98M
         wObFZFM0E8RAKZLL5znfUCypVSHYh/yes45h7nSKjcIY7BEGdjBJSmYWwrqVaRIjLabQ
         7lOML8hXzC05vkW7kwhyguqB/EtT5SwwE5eP6EMxz6e9a+sKOK1bl8rwQGUF3luo7kgB
         QEaATOXrH08m26OzVhj1/Q2i8qVVUIg3imap3+kVXCfhE6XoAA/AAxuThii8bQld9k8/
         3W8Q==
X-Gm-Message-State: APjAAAWy5+yfG4atPgd7TnLB5Pb24jr979KAVI1QMR8Ji8anB/eswM5S
        p3d4vHg6YUdaJ8mzM+PfIMNGRQkK
X-Google-Smtp-Source: APXvYqx9/LRHI+/xgiXL7FwbX2lzbKtD8xJEFBiT1HXJz/2idQHbxGneA022OGNCzmljUsXan98+9g==
X-Received: by 2002:adf:ee01:: with SMTP id y1mr9045143wrn.51.1554473015147;
        Fri, 05 Apr 2019 07:03:35 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w16sm29604647wrt.84.2019.04.05.07.03.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Apr 2019 07:03:33 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 00/10] Backport of traceevent APIs cleanup changes from kernel tree to trace-cmd
Date:   Fri,  5 Apr 2019 17:03:22 +0300
Message-Id: <20190405140332.10949-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A set of patches which aligns kernel libtraceevent implementation to trace-cmd 
one:
 - Got rid of "pevent" in library APIs and internal code, replaced it with "tep"
 - Removed deprecated filter trivial API
 - Made the API more consistent: aligned all "tep_is ... " APIs to return bool
 - Changed descriptions of some APIs, in order to be more informative

Steven Rostedt (VMware) (1):
  tools lib traceevent: Removed unneeded !! and return parenthesis

Tzvetomir Stoyanov (9):
  tools lib traceevent: Change description of few APIs
  tools lib traceevent: Implement new traceevent APIs for accessing
    struct tep_handler fields
  tools lib traceevent: Remove tep filter trivial APIs
  tools lib traceevent: Remove call to exit() from
    tep_filter_add_filter_str()
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

 include/traceevent/event-parse.h   | 158 +++---
 lib/trace-cmd/trace-ftrace.c       |  16 +-
 lib/trace-cmd/trace-input.c        |  12 +-
 lib/traceevent/event-parse-api.c   | 213 ++++----
 lib/traceevent/event-parse-local.h |   6 +-
 lib/traceevent/event-parse.c       | 796 ++++++++++++++---------------
 lib/traceevent/event-plugin.c      |  32 +-
 lib/traceevent/parse-filter.c      | 216 +-------
 plugins/plugin_blk.c               |   8 +-
 plugins/plugin_cfg80211.c          |   8 +-
 plugins/plugin_function.c          |  22 +-
 plugins/plugin_hrtimer.c           |  13 +-
 plugins/plugin_jbd2.c              |  12 +-
 plugins/plugin_kmem.c              |  34 +-
 plugins/plugin_kvm.c               |  49 +-
 plugins/plugin_mac80211.c          |   6 +-
 plugins/plugin_sched_switch.c      |  18 +-
 plugins/plugin_scsi.c              |   8 +-
 plugins/plugin_xen.c               |   8 +-
 python/ctracecmd.i                 |   4 +-
 python/tracecmd.py                 |   2 +-
 tracecmd/trace-output.c            |   2 +-
 tracecmd/trace-profile.c           |   4 +-
 tracecmd/trace-read.c              |   6 +-
 tracecmd/trace-split.c             |   2 +-
 25 files changed, 735 insertions(+), 920 deletions(-)

-- 
2.20.1

