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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B96AC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 507E464E6F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhBKKfb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhBKKdF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:33:05 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8791C061788
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:24 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id lg21so9280310ejb.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ab+XjHrH4Ui6GgJS/A079C+sGotYarCnpXyXG3/dzSw=;
        b=Yw5LqZBo4WSvEnF/UEAiX8cGwfWPw285FuGewMhTGQUvfAUJpHjI3ZQw2JKe/ZyLuy
         a8ARGqUE09Pwtgt12x8PU1QnSigurfZT+vz8EmJ5jqxUmvmoxm06EbE9IN3HIF7Gi3nJ
         qCiTVde5AQCu1Yhq42ZjlpFKflHfmWFFmGdIi5HnlUOfvJJ0fo6yhz9PH9Ef6OQ7J0bi
         oIkXRVQAqD8Kj/HvS+18AiVsd68Sa/myfG5QGSMdelsn/4RjbekOPr54avjuXXwgxbHK
         0sZYZPSnh64Wf7CmzEnMbuTsJhf5swWAs19AS4y+xMxuwPGVWkJc7L4dP0XBrSKw5Z6H
         /77g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ab+XjHrH4Ui6GgJS/A079C+sGotYarCnpXyXG3/dzSw=;
        b=Cm56FXr+ieU22peuocPnW9kYrUUlt4oOGjXD9mudGIEM1Lzde2L2AmziR1WHrO4RZL
         gunEz+BEnj6DRMWZNceAArSnGUVQ/UZ5Pi4SRVXJ2vK2Dg2/GOb++7uL2YLry1+7m+7S
         KR1vW3jkhXVYdYOBvF+41OXx6vZiIArtNkVAPYahPVcS64eMyvRQfzZvbsDPN02lX40Q
         44oorp2SSSATs3vOeazdK8ZeIo4BlIuv21tnr/XKFjwy6OA2xWCnBhqpVbeex2RSJ9lX
         jz4aTbtpQbe2Cm/B0n/ygTyiuFeQKJ7nuLWmUjreqX+xcchbKXx3vVnNcWrQPzGlduFO
         DFyg==
X-Gm-Message-State: AOAM533cB3SlMVUsDS3JkNzU3PomAwpa/H4A6LAWAtbQRv5WRsqbqQ7s
        yAlkrg1dKbXi386/fCNhq9bN4RSIQV4=
X-Google-Smtp-Source: ABdhPJw4CulKiUgj0oI/3hmMRRoVA/X9tFZZiac2TCN4Y+bn0Bzt2xYAtX/1GnAXLw6mWc7U6YOWrw==
X-Received: by 2002:a17:906:73c2:: with SMTP id n2mr7933772ejl.224.1613039543683;
        Thu, 11 Feb 2021 02:32:23 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:23 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 03/27] kernel-shark: Restore the counting of event handlers
Date:   Thu, 11 Feb 2021 12:31:41 +0200
Message-Id: <20210211103205.418588-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The number of the event handlers, successfully registered by the
plugins is supposed to be counted and returned by the functions
kshark_handle_dpi() and kshark_handle_all_dpis(). Although this is
not used by the GUI, we want the API to support this feature. In
this patch we fix a regression that was introduced during the
transformation of the API for KernelShark v2.0.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-plugin.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/src/libkshark-plugin.c b/src/libkshark-plugin.c
index 74a5862..b85d0e9 100644
--- a/src/libkshark-plugin.c
+++ b/src/libkshark-plugin.c
@@ -457,7 +457,6 @@ kshark_register_input(struct kshark_context *kshark_ctx,
 	input->interface = plugin;
 	input->next = kshark_ctx->inputs;
 	kshark_ctx->inputs = input;
-
 	return input;
 
  conflict:
@@ -635,7 +634,7 @@ void kshark_unregister_plugin_from_stream(struct kshark_data_stream *stream,
 	}
 }
 
-static void plugin_init(struct kshark_data_stream *stream,
+static int plugin_init(struct kshark_data_stream *stream,
 			struct kshark_dpi_list *plugin)
 {
 	int handler_count = plugin->interface->init(stream);
@@ -660,13 +659,18 @@ static void plugin_init(struct kshark_data_stream *stream,
 		plugin->status |= KSHARK_PLUGIN_FAILED;
 		plugin->status &= ~KSHARK_PLUGIN_LOADED;
 	}
+
+	return handler_count;
 }
 
-static void plugin_close(struct kshark_data_stream *stream,
+static int plugin_close(struct kshark_data_stream *stream,
 			 struct kshark_dpi_list *plugin)
 {
-	plugin->interface->close(stream);
+	int handler_count = plugin->interface->close(stream);
+
 	plugin->status &= ~KSHARK_PLUGIN_LOADED;
+
+	return handler_count;
 }
 
 /**
@@ -689,24 +693,24 @@ int kshark_handle_dpi(struct kshark_data_stream *stream,
 	switch (task_id) {
 	case KSHARK_PLUGIN_INIT:
 		if (plugin->status & KSHARK_PLUGIN_ENABLED)
-			plugin_init(stream, plugin);
+			handler_count += plugin_init(stream, plugin);
 
 		break;
 
 	case KSHARK_PLUGIN_UPDATE:
 		if (plugin->status & KSHARK_PLUGIN_LOADED)
-			plugin_close(stream, plugin);
+			handler_count -= plugin_close(stream, plugin);
 
 		plugin->status &= ~KSHARK_PLUGIN_FAILED;
 
 		if (plugin->status & KSHARK_PLUGIN_ENABLED)
-			plugin_init(stream, plugin);
+			handler_count += plugin_init(stream, plugin);
 
 		break;
 
 	case KSHARK_PLUGIN_CLOSE:
 		if (plugin->status & KSHARK_PLUGIN_LOADED)
-			plugin_close(stream, plugin);
+			handler_count -= plugin_close(stream, plugin);
 
 		plugin->status &= ~KSHARK_PLUGIN_FAILED;
 		break;
-- 
2.25.1

