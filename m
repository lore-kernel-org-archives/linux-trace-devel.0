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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E58C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 568FF64EA2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhBARZF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhBARY5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:24:57 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC89AC0613D6
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:15 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id w1so25566650ejf.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ab+XjHrH4Ui6GgJS/A079C+sGotYarCnpXyXG3/dzSw=;
        b=uahrmy9rLO/it4LPyFBVhJzAItiMovvPrUuEaxEcplTOls822pjAPzl4CYfDmHuP82
         WQ5WovbO/epIn+lxFroIga5zPoYtupRRBGVYS3ZJT7YJSQ0OUCOCujVmbU1DR1Oti3as
         FyoD7LZuRn9q5NXq2PMqS09xCQcQAz5tRT6SJ9l+cc8WcTyE4qCoInaIf4LSEHNAC2zc
         2aHUJ5v5E9vNqWE9RVVmzjx2Q65+71hJ5XDg714sSIZkNXrVxKwyGSb3KExKCRsTzopD
         L278u7W9XdYnresthQpJzBDdYX4/QLXwtEeAm4UQpyJyh+of50vYEwHYmGl6khgcX+v2
         7gew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ab+XjHrH4Ui6GgJS/A079C+sGotYarCnpXyXG3/dzSw=;
        b=aW4DjsVZ7uolm6Bkap8/pmL28E4QUUav9HgjTwgBrG/5TpsMjYIQLYJm0FFDrSTSyX
         f2vsnzn4Ylzh8FeNiZCI6myRXuW9jeIn3tc+ae339s8aoYt8nPBKMi/0USJeheGtwpTY
         tEr6upmAOtc8f8HWKZadp0DG+1g5cQGXjZou/Wdqql2Xf5vEHwtuSY6U4pG6H/cn+JYs
         Dmkx12p3ybbr6XAaj6cElkyp0QjQdMuWahQLcaZjJzUIENOUQiHwuXK5TXffyt1/mhbi
         PXaqfq0U9cOJDkAJcm5lvhtVYgE4HKxStcR8cYsHCAbQnWvHKA02h8jSwWUBC6i6P+4o
         ytsA==
X-Gm-Message-State: AOAM532M9rqHl7JJSd3/11ARi2NUDbCdGF6+8CHL+r0UoDRfFPOayajq
        5OtWq3+lRmQ5BmWyTZge67Q=
X-Google-Smtp-Source: ABdhPJxEx4NF2IVddKswKP1UC0prQeVOnMJ6B216anCGZi4+As5k4HPfDdx+j/IhTkJFQeujzGWMdw==
X-Received: by 2002:a17:906:3a13:: with SMTP id z19mr19476008eje.317.1612200254682;
        Mon, 01 Feb 2021 09:24:14 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:14 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 03/24] kernel-shark: Restore the counting of event handlers
Date:   Mon,  1 Feb 2021 19:23:37 +0200
Message-Id: <20210201172358.175407-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
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

