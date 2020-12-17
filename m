Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E306C3526D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F829238D7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgLQJql (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 04:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbgLQJqW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 04:46:22 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6033AC061794
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:45:41 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id m5so25868118wrx.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=prmc/6v3iqnTUltnwXExJCKa1iklEIgn1tbOxrwCg1A=;
        b=IvIl/CSSoGBUztN3MtDCEvNlkQISxWDKUnLjDOrksgS3nxrjpwuXdUBd8Tn/rQzpCx
         byvuAvWN5WXxzh5tEeGBN4k0QTm8hl8yBtINBIMzOU0Gwugxyp0Oh1sIbx1S/VOwe+V/
         6wWRPqhBC1AWm7yHHliHMueLvJVRHVuX3ngXlOAFSY/azLK8I4Xp5h8ZdTD/RCtaKSLu
         AqswYDRzxh9Cqa3nLPL/0pZMTIpRyTWscNIwYb9mzYwxkEvXDByueve8sSisi4ljSAiW
         4XcZYHIvATRbyJUujG3bTSW0BeHc6wVG5A4B2HhAlpsgot5PRupkEljuS1XUbWxt52bq
         m4bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=prmc/6v3iqnTUltnwXExJCKa1iklEIgn1tbOxrwCg1A=;
        b=purOIuFTRYrDYeWmj0gszcg9jRJ9MRgeBAwEOEjCqasPMBxj8JqI3D6O1nmgTnhvXk
         geVCoYsJQ87URNgf+L/DaXWNPmcOS5pPXYjizzufof8yNoF401iiluB/5zfr+yQu2Rz7
         6VTQ8Bmg9gs7amFiJrszlZhdIJYuA80S+7ZL6QT5W4/I+0fORWnrRHXq5CT5cYnLGGI7
         mButp7QpAlWYFqe2wAZRyA4zQS98ij5If1NaQmzqvLC+prBk++dVDgOpqoshJLTtTyZA
         V3CwFOnJuORczxyoSyIbLW3XhOIVaSll5+uO9qDrJJDXxWsIbEAnyb4L7SAweJAtgcoZ
         ProA==
X-Gm-Message-State: AOAM531eZGooygX/JDpWtEq63fcaXM3WBC10okkVq3RxgDJRHDGRjA0I
        pjYhj9VDWc6/mRTR/fgdXHiCi/cVb1gmaA==
X-Google-Smtp-Source: ABdhPJy5n7LuE6g3YkJlOYs05+verpKY1X4s+xx6o/yfKRrGm+fySijHiJvrak9JRzPfl06MgTFbiw==
X-Received: by 2002:a5d:61c4:: with SMTP id q4mr42700304wrv.304.1608198340088;
        Thu, 17 Dec 2020 01:45:40 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c4sm8642172wrw.72.2020.12.17.01.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 01:45:39 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtraceevent: Update the RESOURCES section of the man pages
Date:   Thu, 17 Dec 2020 11:45:22 +0200
Message-Id: <20201217094522.1401640-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The libtraceevent has a new official repository, the RESOURCES
section of the man pages should point to it. Updated with
https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtraceevent-commands.txt          | 2 +-
 Documentation/libtraceevent-cpus.txt              | 2 +-
 Documentation/libtraceevent-endian_read.txt       | 2 +-
 Documentation/libtraceevent-event_find.txt        | 2 +-
 Documentation/libtraceevent-event_get.txt         | 2 +-
 Documentation/libtraceevent-event_list.txt        | 2 +-
 Documentation/libtraceevent-event_print.txt       | 2 +-
 Documentation/libtraceevent-field_find.txt        | 2 +-
 Documentation/libtraceevent-field_get_val.txt     | 2 +-
 Documentation/libtraceevent-field_print.txt       | 2 +-
 Documentation/libtraceevent-field_read.txt        | 2 +-
 Documentation/libtraceevent-fields.txt            | 2 +-
 Documentation/libtraceevent-file_endian.txt       | 2 +-
 Documentation/libtraceevent-filter.txt            | 2 +-
 Documentation/libtraceevent-func_apis.txt         | 2 +-
 Documentation/libtraceevent-func_find.txt         | 2 +-
 Documentation/libtraceevent-handle.txt            | 2 +-
 Documentation/libtraceevent-header_page.txt       | 2 +-
 Documentation/libtraceevent-host_endian.txt       | 2 +-
 Documentation/libtraceevent-long_size.txt         | 2 +-
 Documentation/libtraceevent-page_size.txt         | 2 +-
 Documentation/libtraceevent-parse_event.txt       | 2 +-
 Documentation/libtraceevent-parse_head.txt        | 2 +-
 Documentation/libtraceevent-plugins.txt           | 2 +-
 Documentation/libtraceevent-record_parse.txt      | 2 +-
 Documentation/libtraceevent-reg_event_handler.txt | 2 +-
 Documentation/libtraceevent-reg_print_func.txt    | 2 +-
 Documentation/libtraceevent-set_flag.txt          | 2 +-
 Documentation/libtraceevent-strerror.txt          | 2 +-
 Documentation/libtraceevent-tseq.txt              | 2 +-
 Documentation/libtraceevent.txt                   | 2 +-
 31 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/Documentation/libtraceevent-commands.txt b/Documentation/libtraceevent-commands.txt
index bec5520..add9185 100644
--- a/Documentation/libtraceevent-commands.txt
+++ b/Documentation/libtraceevent-commands.txt
@@ -150,4 +150,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-cpus.txt b/Documentation/libtraceevent-cpus.txt
index 5ad70e4..f3d04df 100644
--- a/Documentation/libtraceevent-cpus.txt
+++ b/Documentation/libtraceevent-cpus.txt
@@ -74,4 +74,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-endian_read.txt b/Documentation/libtraceevent-endian_read.txt
index e64851b..cf21e39 100644
--- a/Documentation/libtraceevent-endian_read.txt
+++ b/Documentation/libtraceevent-endian_read.txt
@@ -75,4 +75,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-event_find.txt b/Documentation/libtraceevent-event_find.txt
index 7bc062c..185880e 100644
--- a/Documentation/libtraceevent-event_find.txt
+++ b/Documentation/libtraceevent-event_find.txt
@@ -100,4 +100,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-event_get.txt b/Documentation/libtraceevent-event_get.txt
index 6525092..b1f3d8e 100644
--- a/Documentation/libtraceevent-event_get.txt
+++ b/Documentation/libtraceevent-event_get.txt
@@ -96,4 +96,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-event_list.txt b/Documentation/libtraceevent-event_list.txt
index fba350e..736d993 100644
--- a/Documentation/libtraceevent-event_list.txt
+++ b/Documentation/libtraceevent-event_list.txt
@@ -119,4 +119,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-event_print.txt b/Documentation/libtraceevent-event_print.txt
index 2c6a618..c729a87 100644
--- a/Documentation/libtraceevent-event_print.txt
+++ b/Documentation/libtraceevent-event_print.txt
@@ -127,4 +127,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-field_find.txt b/Documentation/libtraceevent-field_find.txt
index 0896af5..fa3066b 100644
--- a/Documentation/libtraceevent-field_find.txt
+++ b/Documentation/libtraceevent-field_find.txt
@@ -115,4 +115,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-field_get_val.txt b/Documentation/libtraceevent-field_get_val.txt
index 6324f0d..29f6583 100644
--- a/Documentation/libtraceevent-field_get_val.txt
+++ b/Documentation/libtraceevent-field_get_val.txt
@@ -119,4 +119,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-field_print.txt b/Documentation/libtraceevent-field_print.txt
index 9a9df98..2c2cf6c 100644
--- a/Documentation/libtraceevent-field_print.txt
+++ b/Documentation/libtraceevent-field_print.txt
@@ -123,4 +123,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-field_read.txt b/Documentation/libtraceevent-field_read.txt
index 64e9e25..96de895 100644
--- a/Documentation/libtraceevent-field_read.txt
+++ b/Documentation/libtraceevent-field_read.txt
@@ -78,4 +78,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-fields.txt b/Documentation/libtraceevent-fields.txt
index 1ccb531..a081690 100644
--- a/Documentation/libtraceevent-fields.txt
+++ b/Documentation/libtraceevent-fields.txt
@@ -102,4 +102,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-file_endian.txt b/Documentation/libtraceevent-file_endian.txt
index f401ad3..197954c 100644
--- a/Documentation/libtraceevent-file_endian.txt
+++ b/Documentation/libtraceevent-file_endian.txt
@@ -88,4 +88,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-filter.txt b/Documentation/libtraceevent-filter.txt
index 4a9962d..052e745 100644
--- a/Documentation/libtraceevent-filter.txt
+++ b/Documentation/libtraceevent-filter.txt
@@ -206,4 +206,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-func_apis.txt b/Documentation/libtraceevent-func_apis.txt
index f6aca0d..89e307a 100644
--- a/Documentation/libtraceevent-func_apis.txt
+++ b/Documentation/libtraceevent-func_apis.txt
@@ -180,4 +180,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-func_find.txt b/Documentation/libtraceevent-func_find.txt
index 04840e2..b7e324b 100644
--- a/Documentation/libtraceevent-func_find.txt
+++ b/Documentation/libtraceevent-func_find.txt
@@ -85,4 +85,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-handle.txt b/Documentation/libtraceevent-handle.txt
index 45b2017..5696b62 100644
--- a/Documentation/libtraceevent-handle.txt
+++ b/Documentation/libtraceevent-handle.txt
@@ -98,4 +98,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-header_page.txt b/Documentation/libtraceevent-header_page.txt
index 615d117..f8f72e5 100644
--- a/Documentation/libtraceevent-header_page.txt
+++ b/Documentation/libtraceevent-header_page.txt
@@ -99,4 +99,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-host_endian.txt b/Documentation/libtraceevent-host_endian.txt
index d5d375e..7fdfaed 100644
--- a/Documentation/libtraceevent-host_endian.txt
+++ b/Documentation/libtraceevent-host_endian.txt
@@ -101,4 +101,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-long_size.txt b/Documentation/libtraceevent-long_size.txt
index 01d78ea..a651438 100644
--- a/Documentation/libtraceevent-long_size.txt
+++ b/Documentation/libtraceevent-long_size.txt
@@ -75,4 +75,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-page_size.txt b/Documentation/libtraceevent-page_size.txt
index 452c0cf..ff60921 100644
--- a/Documentation/libtraceevent-page_size.txt
+++ b/Documentation/libtraceevent-page_size.txt
@@ -79,4 +79,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-parse_event.txt b/Documentation/libtraceevent-parse_event.txt
index f248114..dfbdeda 100644
--- a/Documentation/libtraceevent-parse_event.txt
+++ b/Documentation/libtraceevent-parse_event.txt
@@ -87,4 +87,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-parse_head.txt b/Documentation/libtraceevent-parse_head.txt
index c90f16c..c20a41d 100644
--- a/Documentation/libtraceevent-parse_head.txt
+++ b/Documentation/libtraceevent-parse_head.txt
@@ -79,4 +79,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-plugins.txt b/Documentation/libtraceevent-plugins.txt
index 4d63943..f06dc9c 100644
--- a/Documentation/libtraceevent-plugins.txt
+++ b/Documentation/libtraceevent-plugins.txt
@@ -119,4 +119,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-record_parse.txt b/Documentation/libtraceevent-record_parse.txt
index e9a6911..73a9654 100644
--- a/Documentation/libtraceevent-record_parse.txt
+++ b/Documentation/libtraceevent-record_parse.txt
@@ -134,4 +134,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-reg_event_handler.txt b/Documentation/libtraceevent-reg_event_handler.txt
index 53d37d7..1e5ec0e 100644
--- a/Documentation/libtraceevent-reg_event_handler.txt
+++ b/Documentation/libtraceevent-reg_event_handler.txt
@@ -153,4 +153,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-reg_print_func.txt b/Documentation/libtraceevent-reg_print_func.txt
index 708dce9..c3b3849 100644
--- a/Documentation/libtraceevent-reg_print_func.txt
+++ b/Documentation/libtraceevent-reg_print_func.txt
@@ -152,4 +152,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-set_flag.txt b/Documentation/libtraceevent-set_flag.txt
index b059978..b75426b 100644
--- a/Documentation/libtraceevent-set_flag.txt
+++ b/Documentation/libtraceevent-set_flag.txt
@@ -101,4 +101,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-strerror.txt b/Documentation/libtraceevent-strerror.txt
index ee4062a..f1cef05 100644
--- a/Documentation/libtraceevent-strerror.txt
+++ b/Documentation/libtraceevent-strerror.txt
@@ -82,4 +82,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-tseq.txt b/Documentation/libtraceevent-tseq.txt
index 8ac6aa1..066f5e0 100644
--- a/Documentation/libtraceevent-tseq.txt
+++ b/Documentation/libtraceevent-tseq.txt
@@ -155,4 +155,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index d530a7c..3365455 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -189,4 +189,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
-- 
2.28.0

