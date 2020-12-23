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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF766C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A61942168B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgLWEiK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 23:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgLWEiK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 23:38:10 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB78BC0613D3
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:37:29 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id g25so660188wmh.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vZ9qwwiziAwIcPEajSzRnH9oEnPakVP/7KZJjJOWl0A=;
        b=urpHyOK03WGqPJURgmR6RQprLUr4SWC+4S1ym7tFqOhmVYgefm1gTPdR0aEtKyizjj
         BMfiPVQ2vDu+clQuHIhIgspgcMpmiFJA1I9Cs/AR9dA29Jk0BriAW5U9UiveQ3Q/2v8g
         9JvvNkQtV0tdp60bCatZX11yfQkOo3LiGqzG1FEnsflmNhRewG/XeOjnbATU53CP7OYt
         KCgWGgAouSetklOMpwRQJ9JBee6Rq3c8Gt9Q7D/5tHYmyLT4VukGX0Wermc6kBvgZXFw
         hUd1+gHwCJ5bLgP08y2oTRRLVDgmuJdbRg4ai/x/UaCJPlW8Cni4JBnKQqVXANr0nJKR
         u0gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vZ9qwwiziAwIcPEajSzRnH9oEnPakVP/7KZJjJOWl0A=;
        b=hZGog69qZRnGdSokQPFsN0WmIF2N9CFB5+FmBmGRZXXT4PkH98M6GlMtyOpwNuxNN5
         7OTp3ZHFTpvaKrl5+0JdPpaBtMapa+OizqECXbuhwZppEh8rbdHNFnYvZ3CP3Uj7IzQL
         id7K7M9ws9sa+S55t+5GVjQFJBcwDLo+hfBc21q7riqxpPW0vOrWg29p7E/k6/zteFvV
         NmU5cfuH2tqPVANA7hb1NRpt5OtShdvQ0S14IrSTfP4TVshETILB6VZ0iKW7ZEsr2oJ4
         DytIoUgdDNote+HdiNg+hpFGSsiz+c/oD/rEreIIPuE6xcZxD+CoExHq51upcPUwSblW
         uhGQ==
X-Gm-Message-State: AOAM532azxhz6z045q4lTT2lB0jQQy5vaxPwP6oqQJ0e2xY5fqytS3AA
        S4mBQs/mib8+zd77U3KxOqBfvZsDkNcXbhkM
X-Google-Smtp-Source: ABdhPJy4QCncH61PMssJbvr8OeSrTLhoGLss+HWnByDnjlZkyHA98HwHTreW5dbIYI0j39fr4ARaTg==
X-Received: by 2002:a1c:9d8b:: with SMTP id g133mr24886913wme.189.1608698248394;
        Tue, 22 Dec 2020 20:37:28 -0800 (PST)
Received: from oberon.vmware.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a17sm34548836wrs.20.2020.12.22.20.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 20:37:27 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Add COPYING section to man pages
Date:   Wed, 23 Dec 2020 06:37:26 +0200
Message-Id: <20201223043726.587033-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A COPYING with VMware Copyright \(C) was added to all libtracefs man
pages.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-events-tep.txt       | 7 ++++++-
 Documentation/libtracefs-events.txt           | 5 +++++
 Documentation/libtracefs-files.txt            | 7 ++++++-
 Documentation/libtracefs-instances-files.txt  | 7 ++++++-
 Documentation/libtracefs-instances-manage.txt | 5 +++++
 Documentation/libtracefs-instances-utils.txt  | 7 ++++++-
 Documentation/libtracefs-utils.txt            | 7 ++++++-
 Documentation/libtracefs.txt                  | 7 ++++++-
 8 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/Documentation/libtracefs-events-tep.txt b/Documentation/libtracefs-events-tep.txt
index f7d7a61..e0be02c 100644
--- a/Documentation/libtracefs-events-tep.txt
+++ b/Documentation/libtracefs-events-tep.txt
@@ -127,4 +127,9 @@ libtracefs is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
\ No newline at end of file
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs-events.txt b/Documentation/libtracefs-events.txt
index 685dbd2..9608a12 100644
--- a/Documentation/libtracefs-events.txt
+++ b/Documentation/libtracefs-events.txt
@@ -141,3 +141,8 @@ libtracefs is Free Software licensed under the GNU LGPL 2.1
 RESOURCES
 ---------
 https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs-files.txt b/Documentation/libtracefs-files.txt
index 8bf9d75..dc85f2d 100644
--- a/Documentation/libtracefs-files.txt
+++ b/Documentation/libtracefs-files.txt
@@ -94,4 +94,9 @@ libtracefs is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
\ No newline at end of file
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs-instances-files.txt b/Documentation/libtracefs-instances-files.txt
index 7f9d381..9b18b73 100644
--- a/Documentation/libtracefs-instances-files.txt
+++ b/Documentation/libtracefs-instances-files.txt
@@ -157,4 +157,9 @@ libtracefs is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
\ No newline at end of file
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs-instances-manage.txt b/Documentation/libtracefs-instances-manage.txt
index 1601c5b..a831ef2 100644
--- a/Documentation/libtracefs-instances-manage.txt
+++ b/Documentation/libtracefs-instances-manage.txt
@@ -109,3 +109,8 @@ libtracefs is Free Software licensed under the GNU LGPL 2.1
 RESOURCES
 ---------
 https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs-instances-utils.txt b/Documentation/libtracefs-instances-utils.txt
index aa5efbd..3bd54a5 100644
--- a/Documentation/libtracefs-instances-utils.txt
+++ b/Documentation/libtracefs-instances-utils.txt
@@ -109,4 +109,9 @@ libtracefs is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
\ No newline at end of file
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs-utils.txt b/Documentation/libtracefs-utils.txt
index 03bc39b..41544ab 100644
--- a/Documentation/libtracefs-utils.txt
+++ b/Documentation/libtracefs-utils.txt
@@ -100,4 +100,9 @@ libtracefs is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
\ No newline at end of file
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index bd40f1f..ddbf783 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -81,4 +81,9 @@ libtracefs is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
\ No newline at end of file
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
-- 
2.28.0

