Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48D7C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A181320936
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgLWEfP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 23:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgLWEfP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 23:35:15 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57E4C061793
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:34:34 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id t16so17342004wra.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2A3Wc9f8hLtGVJ3l1/ajqu2NiZDBm3z5GCAXR9PgX74=;
        b=CLNhVz6tIAoxLoUR4lhtJ2D2vcB4NGrguF7NoJqy1k0yy0JtqV6BjjgA26jlBT2HWT
         Br7qXPbpGF4RL5k+PHT+K8MinDj7eMhAb6Neylnb6vKXwN6erZUeMtikaEpr4Z1lt2wK
         SZHKF4e7PdUYirSmCoQsrzXLbMiW2BCXUO21+PbZ4foNkaaj8MP3vAKvBWETQtbZ/+t+
         doyy40JmC8oHhu3ZPCqPHjcYhmVKcqzky2XIBH6Fer69Iyu/MMyBZhsFcccwgyVuyiZn
         y87ZKjWLlZHtMBWPgjX/P61TFjwQLz4gFTE9E/I7IOoe8COMNag+AaJF+88G+VhEQG31
         bD/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2A3Wc9f8hLtGVJ3l1/ajqu2NiZDBm3z5GCAXR9PgX74=;
        b=U1u6g46BLu5xLn+StjTZqUoKeYFxBnijAjzf3xx81lRFIMpfuBFn/ieyLM+SFClGpi
         u27jV0hUB83XlzeCxCfYTnGfD8KzhXTUOFZgzO5yZ/odFZ3WkfYA1LGdjaNHL+S8lpZY
         iYoWHkcv8XnVVCcmecCU51NsJcfulBkS5BuSF4eJHNvYQrZXVoIF27dsCSjHRxtIlmQ3
         3vAeATr442sG59/h/3vfbGX0fcpQwgpRsDAuQKP/upv4p+hcJs/4WaaVK6cdEz3mb87c
         saos6bS/nI7CMPLummsZQ5Kju40GAfsor8Ww8sabI2nYV4cyXX3ohZlYl6+nIfGTPWIC
         q8rA==
X-Gm-Message-State: AOAM532xJ9KDJFg1rfSJ+BxufD3SvRW+qmGW8pMh8LwgjlmveznCl5CR
        ujojZjt0NB1jejJbk5wE6qeeHH7+HrN/3EEE
X-Google-Smtp-Source: ABdhPJxsvp0doEC7DdkgKXtqmVz6i0gYDPBbvXRdIljZAtBjMRABy+qFKRmnWPSnmAuWSCHYgBSjdQ==
X-Received: by 2002:a05:6000:1d2:: with SMTP id t18mr16526747wrx.412.1608698073237;
        Tue, 22 Dec 2020 20:34:33 -0800 (PST)
Received: from oberon.vmware.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s13sm28909095wmj.28.2020.12.22.20.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 20:34:32 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/6] trace-cmd: Update the RESOURCES section of the trace-cmd man pages
Date:   Wed, 23 Dec 2020 06:34:25 +0200
Message-Id: <20201223043429.586162-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201223043429.586162-1-tz.stoyanov@gmail.com>
References: <20201223043429.586162-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

trace-cmd has a new official repository, the RESOURCES
section of the man pages should point to it. Updated with
https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-check-events.1.txt | 2 +-
 Documentation/trace-cmd/trace-cmd-clear.1.txt        | 2 +-
 Documentation/trace-cmd/trace-cmd-dump.1.txt         | 2 +-
 Documentation/trace-cmd/trace-cmd-extract.1.txt      | 2 +-
 Documentation/trace-cmd/trace-cmd-hist.1.txt         | 2 +-
 Documentation/trace-cmd/trace-cmd-list.1.txt         | 2 +-
 Documentation/trace-cmd/trace-cmd-listen.1.txt       | 2 +-
 Documentation/trace-cmd/trace-cmd-mem.1.txt          | 2 +-
 Documentation/trace-cmd/trace-cmd-options.1.txt      | 2 +-
 Documentation/trace-cmd/trace-cmd-profile.1.txt      | 2 +-
 Documentation/trace-cmd/trace-cmd-record.1.txt       | 2 +-
 Documentation/trace-cmd/trace-cmd-report.1.txt       | 2 +-
 Documentation/trace-cmd/trace-cmd-reset.1.txt        | 2 +-
 Documentation/trace-cmd/trace-cmd-restore.1.txt      | 2 +-
 Documentation/trace-cmd/trace-cmd-set.1.txt          | 2 +-
 Documentation/trace-cmd/trace-cmd-show.1.txt         | 2 +-
 Documentation/trace-cmd/trace-cmd-snapshot.1.txt     | 2 +-
 Documentation/trace-cmd/trace-cmd-split.1.txt        | 2 +-
 Documentation/trace-cmd/trace-cmd-stack.1.txt        | 2 +-
 Documentation/trace-cmd/trace-cmd-start.1.txt        | 2 +-
 Documentation/trace-cmd/trace-cmd-stat.1.txt         | 2 +-
 Documentation/trace-cmd/trace-cmd-stop.1.txt         | 2 +-
 Documentation/trace-cmd/trace-cmd-stream.1.txt       | 2 +-
 Documentation/trace-cmd/trace-cmd.1.txt              | 2 +-
 Documentation/trace-cmd/trace-cmd.dat.5.txt          | 2 +-
 25 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-check-events.1.txt b/Documentation/trace-cmd/trace-cmd-check-events.1.txt
index 73ec1a8b..c98ff3c6 100644
--- a/Documentation/trace-cmd/trace-cmd-check-events.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-check-events.1.txt
@@ -36,7 +36,7 @@ Written by Vaibhav Nagarnaik, <vnagarnaik@google.com>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-clear.1.txt b/Documentation/trace-cmd/trace-cmd-clear.1.txt
index a0ae36e9..74236960 100644
--- a/Documentation/trace-cmd/trace-cmd-clear.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-clear.1.txt
@@ -48,4 +48,4 @@ GNU Public License (GPL).
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git
\ No newline at end of file
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
\ No newline at end of file
diff --git a/Documentation/trace-cmd/trace-cmd-dump.1.txt b/Documentation/trace-cmd/trace-cmd-dump.1.txt
index e29bfe86..71b8e655 100644
--- a/Documentation/trace-cmd/trace-cmd-dump.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-dump.1.txt
@@ -123,7 +123,7 @@ AUTHOR
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-extract.1.txt b/Documentation/trace-cmd/trace-cmd-extract.1.txt
index 917a6371..4444733d 100644
--- a/Documentation/trace-cmd/trace-cmd-extract.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-extract.1.txt
@@ -80,7 +80,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-hist.1.txt b/Documentation/trace-cmd/trace-cmd-hist.1.txt
index b17936d0..169f8d7b 100644
--- a/Documentation/trace-cmd/trace-cmd-hist.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-hist.1.txt
@@ -41,7 +41,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-list.1.txt b/Documentation/trace-cmd/trace-cmd-list.1.txt
index bba45ea4..0ad62643 100644
--- a/Documentation/trace-cmd/trace-cmd-list.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-list.1.txt
@@ -80,7 +80,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-listen.1.txt b/Documentation/trace-cmd/trace-cmd-listen.1.txt
index a242c49e..8697328c 100644
--- a/Documentation/trace-cmd/trace-cmd-listen.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-listen.1.txt
@@ -49,7 +49,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-mem.1.txt b/Documentation/trace-cmd/trace-cmd-mem.1.txt
index 9e811b91..90e430b8 100644
--- a/Documentation/trace-cmd/trace-cmd-mem.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-mem.1.txt
@@ -65,7 +65,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-options.1.txt b/Documentation/trace-cmd/trace-cmd-options.1.txt
index e7faf320..bcdf0533 100644
--- a/Documentation/trace-cmd/trace-cmd-options.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-options.1.txt
@@ -26,7 +26,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-profile.1.txt b/Documentation/trace-cmd/trace-cmd-profile.1.txt
index 3ffce86b..0d1dd8e8 100644
--- a/Documentation/trace-cmd/trace-cmd-profile.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-profile.1.txt
@@ -667,7 +667,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 99d1a156..643659ad 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -461,7 +461,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-report.1.txt b/Documentation/trace-cmd/trace-cmd-report.1.txt
index de616cf4..766c9a57 100644
--- a/Documentation/trace-cmd/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-report.1.txt
@@ -487,7 +487,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-reset.1.txt b/Documentation/trace-cmd/trace-cmd-reset.1.txt
index bff45300..eee86751 100644
--- a/Documentation/trace-cmd/trace-cmd-reset.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-reset.1.txt
@@ -107,7 +107,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-restore.1.txt b/Documentation/trace-cmd/trace-cmd-restore.1.txt
index 290b0acd..ebcbb1b6 100644
--- a/Documentation/trace-cmd/trace-cmd-restore.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-restore.1.txt
@@ -96,7 +96,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-set.1.txt b/Documentation/trace-cmd/trace-cmd-set.1.txt
index 2f95e07f..931d3abd 100644
--- a/Documentation/trace-cmd/trace-cmd-set.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-set.1.txt
@@ -255,7 +255,7 @@ Written by Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-show.1.txt b/Documentation/trace-cmd/trace-cmd-show.1.txt
index b17851ef..ea2fda28 100644
--- a/Documentation/trace-cmd/trace-cmd-show.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-show.1.txt
@@ -91,7 +91,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-snapshot.1.txt b/Documentation/trace-cmd/trace-cmd-snapshot.1.txt
index 6d94ada0..0a34bcd9 100644
--- a/Documentation/trace-cmd/trace-cmd-snapshot.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-snapshot.1.txt
@@ -56,7 +56,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-split.1.txt b/Documentation/trace-cmd/trace-cmd-split.1.txt
index b8308bbc..25385796 100644
--- a/Documentation/trace-cmd/trace-cmd-split.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-split.1.txt
@@ -98,7 +98,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-stack.1.txt b/Documentation/trace-cmd/trace-cmd-stack.1.txt
index 6b5f0c08..a00c6900 100644
--- a/Documentation/trace-cmd/trace-cmd-stack.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-stack.1.txt
@@ -36,7 +36,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-start.1.txt b/Documentation/trace-cmd/trace-cmd-start.1.txt
index 07f2ed3a..03c5d127 100644
--- a/Documentation/trace-cmd/trace-cmd-start.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-start.1.txt
@@ -42,7 +42,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-stat.1.txt b/Documentation/trace-cmd/trace-cmd-stat.1.txt
index 2f1a9c8b..e5fccce9 100644
--- a/Documentation/trace-cmd/trace-cmd-stat.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-stat.1.txt
@@ -57,7 +57,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-stop.1.txt b/Documentation/trace-cmd/trace-cmd-stop.1.txt
index 1955fa71..313192c3 100644
--- a/Documentation/trace-cmd/trace-cmd-stop.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-stop.1.txt
@@ -54,7 +54,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd-stream.1.txt b/Documentation/trace-cmd/trace-cmd-stream.1.txt
index 10094028..f83652b8 100644
--- a/Documentation/trace-cmd/trace-cmd-stream.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-stream.1.txt
@@ -41,7 +41,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd.1.txt b/Documentation/trace-cmd/trace-cmd.1.txt
index 5548ed27..b330b4fe 100644
--- a/Documentation/trace-cmd/trace-cmd.1.txt
+++ b/Documentation/trace-cmd/trace-cmd.1.txt
@@ -80,7 +80,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
diff --git a/Documentation/trace-cmd/trace-cmd.dat.5.txt b/Documentation/trace-cmd/trace-cmd.dat.5.txt
index d849439b..8d285353 100644
--- a/Documentation/trace-cmd/trace-cmd.dat.5.txt
+++ b/Documentation/trace-cmd/trace-cmd.dat.5.txt
@@ -258,7 +258,7 @@ Written by Steven Rostedt, <rostedt@goodmis.org>
 
 RESOURCES
 ---------
-git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 
 COPYING
 -------
-- 
2.28.0

