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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B4EBC43460
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 14:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60010613B5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 14:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241303AbhDEOVe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 10:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241296AbhDEOVd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 10:21:33 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B974C061756
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 07:21:27 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id p4so2475876edr.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 07:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gP2DpfxDfv80POi+Qp5LcuyBFIT37XBV5K0BjuhcS68=;
        b=M5bMQQrKSLEDQwfncSJsxwZnv8tdbpe+mjPGKZay6aUBNlpvgvr7n+na/xdvWfY4h8
         Iojq7t6Ab5cDiGgYsEDqpq16X6MqfZsXSz8PfGlTgnGqu7IclFSX9aOlIyKH7YBrQhGW
         85u1npehGEzDTYHkj0mo4NsxT+GeAYpvF6p4NZkvSsXTV2G5tSKHmOImRLFd7yFEz98X
         re24zrpKBhozHEdF8Zex4OlxuhgnBJ/68QLS32OUzWNSQS9xaCOBPmPISJivH/4Cjral
         64DLvAM6/PZcseDxZC9zfF5bxJvHy0AVuE3krwGDlfSCIW1Twv9gSUU3Na5NbABq0dA/
         Cl2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gP2DpfxDfv80POi+Qp5LcuyBFIT37XBV5K0BjuhcS68=;
        b=VH6ZuhMuSwxZisLrXVXoIe3GrHxhikv85XGX11rK3inI0PWrznRQKtd0xfeBX6SzNy
         +dYEzh+T5IIbUQpJiDg/Zgd2HxB/oUFQ4ffDM5w6Cpoma26iTcU6sgrxLyh70Q2xomWY
         qr2HQbufLhdI8ZNnlvdpkaj9qD9WAsHft5XGnvkDtCc5nKZOHuk5S3lofATwEbcWTuwb
         b54SE4OydSnuhR94nIlo1TJeoY3/ZlgwFGNHyIn05Tv5R/cQxfsMby5PZKHkxgc1L+Ow
         v1TgRqKLXMyaNp1mJCiYba4qArNwj7BYhbHNYm3PXn4dS7rYEVqjBjwOOrWERxDonLiG
         fjtw==
X-Gm-Message-State: AOAM532qXEYl1I2YaNs9nHIXxAH0bNXJ7wNOMS9qc0jrmJ0x/ugXrotT
        xD3ThFNPx3xsG/JZrMJ4rcg=
X-Google-Smtp-Source: ABdhPJxgWuMiZjS/PSBCVECfgxutqiVNXTSZOxZcYpurQgLJs/cVMr6TZyo4jWqOvnI5WqCkZIHRAQ==
X-Received: by 2002:a05:6402:3da:: with SMTP id t26mr6235344edw.84.1617632486214;
        Mon, 05 Apr 2021 07:21:26 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id e5sm3156972edr.64.2021.04.05.07.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 07:21:25 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 5/5] libtracefs: Rename tracefs_option_is_set()
Date:   Mon,  5 Apr 2021 17:21:07 +0300
Message-Id: <20210405142107.507711-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210405142107.507711-1-y.karadz@gmail.com>
References: <20210405142107.507711-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The old name of the function is potentially confusing. Indeed
the function do not check anything about the option itself (is it
supported or is it enabled). The function only check if inside
the mask the bit that corresponds to a given option is set.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h   | 4 ++--
 src/tracefs-tools.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 6e9cf55..dd46eca 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -132,8 +132,8 @@ enum tracefs_option_id {
 #define TRACEFS_OPTION_MAX (TRACEFS_OPTION_VERBOSE + 1)
 
 struct tracefs_options_mask;
-bool tracefs_option_is_set(const struct tracefs_options_mask *options,
-			   enum tracefs_option_id id);
+bool tracefs_option_mask_is_set(const struct tracefs_options_mask *options,
+				enum tracefs_option_id id);
 struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
 bool tracefs_option_is_supported(struct tracefs_instance *instance, enum tracefs_option_id id);
 struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance);
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 980ad47..496053f 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -357,14 +357,14 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
 }
 
 /**
- * tracefs_option_is_set - Check if given option is set in the bitmask
+ * tracefs_option_mask_is_set - Check if given option is set in the bitmask
  * @options: Options bitmask
  * @id: trace option id
  *
  * Returns true if an option with given id is set in the bitmask,
  * false if it is not set.
  */
-bool tracefs_option_is_set(const struct tracefs_options_mask *options,
+bool tracefs_option_mask_is_set(const struct tracefs_options_mask *options,
 			   enum tracefs_option_id id)
 {
 	if (id > TRACEFS_OPTION_INVALID)
-- 
2.27.0

