Return-Path: <SRS0=JRVv=X5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F77C4360C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 13:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 120ED20700
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 13:36:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K7SCXnGb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388341AbfJDNgy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:36:54 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:35445 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388244AbfJDNgy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Oct 2019 09:36:54 -0400
Received: by mail-wr1-f45.google.com with SMTP id v8so7279949wrt.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 04 Oct 2019 06:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nE68qNa1t73uyWgyc8Wd3klMPfsWRimBqKPD2QGEToE=;
        b=K7SCXnGbzfWZUbHAaP0TZn8l9iRP84ZE5IHObhkJeqx2dMLodPfnPeQN1mKxJD8rK7
         elzZaXjY1FQLQnTSo+iscVJUhGcQxxGS8v4wOZqUbRszVl46NuZ5Knc1CXCA3qHTJI+T
         PaD4aV/JylR76zhjmk6OGOQYhwQji6X53dPxvvSu1wpLFHmNS8tl6CWAnlqRRp9y7xCm
         bu9E2EBkGiAvclNVk5zgXh1QqV41zEnIPnW2aSuJRUSzjWNqCWeAPNN3rUpeRF8svLe0
         bZg1jaQLmU+B2UG1d0Ulz2MHQO19m2NouWM4GD6lauDCFMFlp4vy7hFqWfVe2DmOavLw
         grmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nE68qNa1t73uyWgyc8Wd3klMPfsWRimBqKPD2QGEToE=;
        b=O3qrizhlPvumITs1FEvAgMiCpWXS4MGp7rz/xNAtPLwYcq59dCTnqy2F/EKJBmf/6y
         r01Wxx+CPaPNynN7/DE3u2JyPBt4zFeBlZN46fn9PphfQlohEglHQMd1d67KPJkr/BvY
         bHF0zMiOic8YlZ2ulgZVHWPcKRKFAfm9ipdU/bXETJpDm64njrCv/zqp0V5bC/Lbx0qH
         Q8NEsWdDHfN7rV2X2HbrEmqXOI2qXcn8S6+ny8DXnpItXAa3LCcVD1/7xL8rATsoc3lS
         Wau2OWJ+9zfq7oMZBlEBwPueOQBGlmELzNK62XpBurbc2ReElAaq8EjRSSjB7D3I0PnI
         dPyA==
X-Gm-Message-State: APjAAAWiAMDrA8/UiTaZDV8ycy+XproL8tEQjKBTpK9y2sPmdpNV9r9k
        bIEGNpi+z9ysc6Ox6qd86FJ4ilOZ
X-Google-Smtp-Source: APXvYqwRhGme1R5+zG5HjS/3+19dAoqXZ8sjDOT1dYwR7h8AQkWfzRodKrDmdPDR3RfDhG6ye+l8Ug==
X-Received: by 2002:adf:fe11:: with SMTP id n17mr5211407wrr.221.1570196210736;
        Fri, 04 Oct 2019 06:36:50 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a10sm7029988wrm.52.2019.10.04.06.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 06:36:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 0/5] Remove redundant trace-cmd plugin handling logic
Date:   Fri,  4 Oct 2019 16:36:42 +0300
Message-Id: <20191004133647.27759-1-tz.stoyanov@gmail.com>
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
new lib/trace-cmd/plugins directory and an initial set of APIs
for working with trace-cmd plugins.

Tzvetomir Stoyanov (1):
  trace-cmd: Change plugin install directories

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd: Move libtraceevent plugins in its own directory.
  trace-cmd: Rename plugin_python to plugin_python_loader.
  trace-cmd: Load libtraceevent plugins from build folder, if exists.
  trace-cmd: Add initial infrastructure for trace-cmd specific plugins.

 .gitignore                                    |   3 +-
 Makefile                                      |  83 +++--
 include/trace-cmd/trace-cmd.h                 |  43 +++
 include/traceevent/event-parse.h              |   3 +
 lib/trace-cmd/Makefile                        |   3 +-
 lib/trace-cmd/plugins/Makefile                |  58 ++++
 lib/trace-cmd/trace-input.c                   |   7 +-
 lib/trace-cmd/trace-plugin.c                  | 313 ++++++++++++++++++
 lib/trace-cmd/trace-util.c                    |  46 +++
 lib/traceevent/event-plugin.c                 |  44 ++-
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
 tracecmd/trace-check-events.c                 |   7 +-
 tracecmd/trace-list.c                         |  14 +-
 27 files changed, 569 insertions(+), 71 deletions(-)
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

