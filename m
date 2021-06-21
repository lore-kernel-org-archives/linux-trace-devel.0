Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94DF0C48BE5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jun 2021 08:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7567161164
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jun 2021 08:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhFUIvn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Jun 2021 04:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhFUIvm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Jun 2021 04:51:42 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8455AC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Jun 2021 01:49:28 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id nb6so27346079ejc.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Jun 2021 01:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XBkyVf8LdsX1dzi9PDOmC1HVc/nHCdtgoNE2nHvIqnY=;
        b=oKmJTiwzma9U1B4sWDwdqHRNPhKJaDWIyaHRIFwXSQFhO4uEWJvwD9vG9NwOX33pNu
         af5jgHPUmRsm/MhSo0zJbsJZX8oRF820n0F4L3dlkQL01evu3WInTT1XCGR2+Xvov9O9
         FPQh7NO9DldT9G2WiYahpzmHVPgxcyuo65hsDPihfxXY5BoJCimlW4WLhGpQDsk+6vOu
         OoY7Qluvc+BWmFuq7Yf16youudydu6381SYtNaLHhcaToO6JjqLHnWNcvMmbXfXK0YgL
         qn9RrEAX4x0EihlrKH7zL2pGa9oOFn2qs8XPFxotAHEiFxfcoV2RCazYZPlSJTDHWK24
         MHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XBkyVf8LdsX1dzi9PDOmC1HVc/nHCdtgoNE2nHvIqnY=;
        b=Btluo+/BrT4PDM+zEc9BlV8PMxrj9AdoIYqNxtl4Dd1K6gdaL1j+pLPhNQiBnL5gNU
         ErXJbS1+qrMetw+Zd2RKp0yE6gGZrxdIb88CxJsZIVNWYyBZr9+AEcJPKHwQeX4bbAoJ
         kx97uUCKID3k/V+oz0I4gBWmZKKXGD1zBOmVZwP5PaumpOC+YXPiI5veExMxElpFXcz0
         0lyURtWVe+e3sJKi2t3DMr8UEu7zJkl6wfNGzHBTEl+Ghp5bjlbBqs5X68YIv2yzEXG6
         sHdmSO3RWkXUvnBUsv9z7R9T2WwkW5Qiy17zLDAVHbopGW233R6HVBPTFWeVZMeScJs2
         g4WA==
X-Gm-Message-State: AOAM531q2bQEUaoJ47CgO8jI21RA74Euypr7ByrgPKPF2s+hg5hCD6Ra
        7Fh8NgYXuyAgaJ85EypLSospUbFZeRY=
X-Google-Smtp-Source: ABdhPJw+QfhO7+8j19nA6HuSNI41GFOwL/Vpfi2j1lmdkIuHJUbWFF72Yk/9pn2IehKIcapV27JKsg==
X-Received: by 2002:a17:906:4fc6:: with SMTP id i6mr15249603ejw.472.1624265367119;
        Mon, 21 Jun 2021 01:49:27 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.164])
        by smtp.gmail.com with ESMTPSA id s11sm9608656edd.65.2021.06.21.01.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 01:49:26 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] libtracefs: Fix typo in documentation
Date:   Mon, 21 Jun 2021 11:49:13 +0300
Message-Id: <20210621084914.336821-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The typo in the name of the API was fixed already, but we need
to change/fix the documentation as well.

Fixes: 5c013e7 (libtracefs: New APIs for trace options)
Fixes: f415871 (libtracefs: Fix typo in function name)
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Documentation/libtracefs-option-misc.txt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/libtracefs-option-misc.txt b/Documentation/libtracefs-option-misc.txt
index 1cd7c88..4258910 100644
--- a/Documentation/libtracefs-option-misc.txt
+++ b/Documentation/libtracefs-option-misc.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_option_enable, tracefs_option_diasble, tracefs_option_name -
+tracefs_option_enable, tracefs_option_disable, tracefs_option_name -
 Various trace option functions.
 
 SYNOPSIS
@@ -13,7 +13,7 @@ SYNOPSIS
 *#include <tracefs.h>*
 
 int *tracefs_option_enable*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
-int *tracefs_option_diasble*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
+int *tracefs_option_disable*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
 const char pass:[*]*tracefs_option_name*(enum tracefs_option_id _id_);
 --
 
@@ -24,7 +24,7 @@ This set of APIs can be used to enable and disable ftrace options and to get the
 The _tracefs_option_enable()_ function enables the option with _id_ in the given _instance_. If
 _instance_ is NULL, the option is enabled in the top trace instance.
 
-The _tracefs_option_diasble()_ function disables the option with _id_ in the given _instance_. If
+The _tracefs_option_disable()_ function disables the option with _id_ in the given _instance_. If
 _instance_ is NULL, the option is disabled in the top trace instance.
 
 The _tracefs_option_name()_ function returns a string, representing the option with _id_. The string
@@ -33,7 +33,7 @@ must *not* be freed.
 
 RETURN VALUE
 ------------
-The _tracefs_option_enable()_ and _tracefs_option_diasble()_ functions return 0 if the state of the
+The _tracefs_option_enable()_ and _tracefs_option_disable()_ functions return 0 if the state of the
 option is set successfully, or -1 in case of an error.
 
 The _tracefs_option_name()_ function returns string with option name, or "unknown" in case of an
@@ -49,7 +49,7 @@ if (tracefs_option_enable(NULL, TRACEFS_OPTION_ANNOTATE)) {
 	/* Failed to enable annotate option in top trace instance */
 }
 ...
-if (tracefs_option_diasble(NULL, TRACEFS_OPTION_CONTEXT_INFO)) {
+if (tracefs_option_disable(NULL, TRACEFS_OPTION_CONTEXT_INFO)) {
 	/* Failed to disable context info option in top trace instance */
 }
 ...
-- 
2.27.0

