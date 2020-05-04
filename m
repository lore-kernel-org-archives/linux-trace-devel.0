Return-Path: <SRS0=47nt=6S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB6EDC3A5A9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 08:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B887720735
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 08:20:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kxnX7QgG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgEDIUt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 04:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727100AbgEDIUt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 04:20:49 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C59C061A0E
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 May 2020 01:20:48 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id g10so8908934lfj.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 May 2020 01:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L0BizLxNn0YVIkRDWitsRZN+gGOeGgBut2DgzNeJGxU=;
        b=kxnX7QgGwO0cUo6vo9BQ/6U9Lh4zq2CFtdF1HxqQeI5i5JUhd4p5PwiBfrT9TFurtK
         8ZaU8Ep4zE641IrbN5fY9knd/QaKa67Ib2pwI8WoNywKlhIJHT1RqpnHz11TgTtFn9rh
         1oCiqTkTDQLUvbDzXsO8Phxp/uZGN9maCFtUvqeY9aZ5l5z2alCl41Skaumtj2rubAe0
         /JimntnVxmw5u13p5tVFXvCOpepFlxGqOJ4XXvf0tRjoGa0m/PL4MHwFNo9cZsAEyeMM
         n5qyf0OVIuHmPvnaK9AA59f0/FaJKuqVOdjb07IYaaPB6wWgRW1aHj59AicNkOFlVZH1
         lIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L0BizLxNn0YVIkRDWitsRZN+gGOeGgBut2DgzNeJGxU=;
        b=kTCTNrFL27/tNEG64qWcZZtI3c+IrK+1r1rapXqjB2OxHO6Qd6l5azImuGN+Ag7Dko
         WDopI83otgTur4rZgTr3dnz41qlQrL44f+jbWQdih7szzh9eucnXOKmE2jdMAkIRo74o
         +e8WvkXPpK6sbXv+N+BqgQ/sSiIFFXfXyYLrZaHpCTSd+KVi4I+G2r6ecNUM168x76Ua
         DVVKRqJaYXSK/EBscvk/h+SqnyHoQrKgO45wc/GVwl7Y7o0qJU8/QuuSd3njgTc7GfFQ
         8z8S1cQI+EDLokAz1FVFS+YD6UCgWtdpVHmEJEdG1Qa7U2i2vSDcyOipK9HXDlpcXKkW
         0IkA==
X-Gm-Message-State: AGi0PuYJJDU6NfqXlZHVfUXBGmDWEvzDfuHiFzmx5sRBBmkHyzGT8qFU
        aWBfw14PJH4eFh56OrbKqypMP70oDAM=
X-Google-Smtp-Source: APiQypKv/nS7UPYdfNQjeTOovzajhEuXs9JMRO/F35a8uIXQrY1e0VfD3nj1goWoxoIqj87QmQDYUQ==
X-Received: by 2002:ac2:4d18:: with SMTP id r24mr862872lfi.51.1588580447277;
        Mon, 04 May 2020 01:20:47 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z23sm7535437ljm.46.2020.05.04.01.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 01:20:46 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Update "trace-cmd list" man page
Date:   Mon,  4 May 2020 11:20:45 +0300
Message-Id: <20200504082045.117541-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Man page of "trace-cmd list" command is updated to describe the new option "-s".
This option lists available event systems.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd-list.1.txt | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace-cmd-list.1.txt b/Documentation/trace-cmd-list.1.txt
index ea6bd86b..bba45ea4 100644
--- a/Documentation/trace-cmd-list.1.txt
+++ b/Documentation/trace-cmd-list.1.txt
@@ -13,7 +13,7 @@ DESCRIPTION
 -----------
 The trace-cmd(1) list displays the available plugins, events or Ftrace options
 that are configured on the current machine.  If no option is given, then it
-lists all plugins, events and Ftrace options to standard output.
+lists all plugins, event systems, events and Ftrace options to standard output.
 
 OPTIONS
 -------
@@ -34,6 +34,9 @@ OPTIONS
 *-R*::
     Used with *-e* 'regex' to show those events triggers.
 
+*-s*::
+    This option will list the available event systems.
+
 *-t*::
     This option will list the available tracers that are enabled on the
     local system.
-- 
2.26.2

