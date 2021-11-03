Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A01C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5E0D61076
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbhKCPq7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 11:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbhKCPq5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 11:46:57 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E39FC061203
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Nov 2021 08:44:21 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id z200so2325111wmc.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Nov 2021 08:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0uk2gejzeKHe49nSsOKmHh3Q2ahbhHxf+65IY4JzrTw=;
        b=EwBOU1t99W/AHyca04iDCGYeBbTW8tJ1uJpnuas8SHZP3c1eOUiiERhWIV8prgVZLO
         iPJYrwLof/7ZK9IsoS6uJeHvieL+9Oywx7fftkpC2grnH7D353BZKOjDWR7SYNuuIRey
         2JNiHpnhLuTdlTtCjK+4OIAPy4+GepRrAIYQ4rbLdILpeVzutVc34DgbQ1Boz4e8RYGT
         rSnEzDXj8jOZmObumCrfcl/TzOL8HM/gHsl8Vr/F5Fr5eMgNbQtChksiZBrYo+jmvdPo
         s/qzdJ3k3jL5nuOn93W8vFSN5njGx0vbU14txEJyKaTZjPgsIs68m6qXdkDqQxPVGAuq
         Ymug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0uk2gejzeKHe49nSsOKmHh3Q2ahbhHxf+65IY4JzrTw=;
        b=d/nlgwbAs7tbyLp+yR+8A0xngFQyYttwCxpMDFGZq3eoHcAqL9MiJTCWR7nrKeAuFf
         XF5DwXmnBpBxI0nqc5SkqtmQVlOfPRN66oJ+0qCeyzcRS13ISRKXP7x1I1zvJK2HGYXb
         mDfMvEH3ugXP9zsqbZxY/ZJnwFZ0Xj02Rb42azmksko2iGD6KVCKpeCvfiN1MwY+C7V0
         Mq2BQ6Ij28fFP7f4ceyxOhy5vN5sb78G4+GD7DcAb3xPzYTnc5EPI1KvCnPk1mfh0wjU
         8NAr9ehn4GYta8WqaUG8B2ginoo2k3NdZJW2NklesxxdYF6D4OI/bUXjTgwx4YFzGA1i
         YzSA==
X-Gm-Message-State: AOAM533aXIVT3e969+YjfIZ2eUZDUoqhwfxEH9tLyY77SYVF5DkJIwZR
        nGyfmWqw72Mh5UHOVwdyjC4=
X-Google-Smtp-Source: ABdhPJywz0yvE2xDkg0rzinpy9j/qJJtAW5Q6ExRJMj+dYUApB5m1KtLUbJ0v4REIizQBK/cGUAEig==
X-Received: by 2002:a05:600c:19d0:: with SMTP id u16mr16239878wmq.111.1635954259914;
        Wed, 03 Nov 2021 08:44:19 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p12sm2767866wrr.10.2021.11.03.08.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 08:44:19 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 00/11] libtracefs dynamic events support
Date:   Wed,  3 Nov 2021 17:44:06 +0200
Message-Id: <20211103154417.246999-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The libtracefs logic that works with ftrace dynamic events is unified
and capsulated into a new set of dynamic events APIs. This change makes
the code more consistent and reusable. Also, adding future libtracefs
support for uprobes and eprobes dynamic events is simplified.
The existing library APIs for kprobes and synthetic events are
reimplemented using the new dynamic events helpers.

Suggested-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

v3 changes:
 - Exposed dynamic events API as official tracefs APIs.
 - Removed kprobe specific APIs, that duplicate corresponding dynamic events
   APIs.
 - Updated unit tests and man pages with the new dynamic events APIs.
 - Fixed typos, found by Yordan. 

v2 changes:
 - Removed triple pointer from the APIs.
 - Reimplement dynamic events parsing using strtok_r instead of strchr.
 - Coding style fixes.

Tzvetomir Stoyanov (VMware) (11):
  libtracefs: Add new public macros for bits manipulations
  libtracefs: New APIs for dynamic events
  libtracefs: New APIs for kprobe allocation
  libtracefs: Remove redundant kprobes APIs
  libtracefs: Change tracefs_kprobe_info API
  libtracefs: Reimplement kprobe raw APIs
  libtracefs: Extend kprobes unit test
  libtracefs: Rename tracefs_synth_init API
  libtracefs: Use the internal dynamic events API when creating
    synthetic events
  libtracefs: Update kprobes man pages
  libtracefs: Document dynamic events APIs

 Documentation/libtracefs-dynevents.txt | 257 +++++++++++
 Documentation/libtracefs-kprobes.txt   | 111 +++--
 Documentation/libtracefs-synth.txt     |  20 +-
 Documentation/libtracefs-synth2.txt    |  10 +-
 Documentation/libtracefs.txt           |  17 +
 include/tracefs-local.h                |  18 +
 include/tracefs.h                      |  58 ++-
 src/Makefile                           |   1 +
 src/tracefs-dynevents.c                | 601 +++++++++++++++++++++++++
 src/tracefs-hist.c                     | 125 +++--
 src/tracefs-kprobes.c                  | 545 +++++++---------------
 src/tracefs-sqlhist.c                  |   6 +-
 utest/tracefs-utest.c                  | 417 ++++++++++-------
 13 files changed, 1479 insertions(+), 707 deletions(-)
 create mode 100644 Documentation/libtracefs-dynevents.txt
 create mode 100644 src/tracefs-dynevents.c

-- 
2.31.1

