Return-Path: <SRS0=576e=A3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0295BC433EB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D39B0207F9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:19:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VWdMvNXs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgGPJTg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgGPJTg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 05:19:36 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1222AC061755
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:19:36 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id n26so5853794ejx.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Afnm1XJPghycfFBTXXC1c4C7hw4aUgP2Ne/OsI1KDuU=;
        b=VWdMvNXsrn9BESNBrYhUv4jvGO8Ovu3/idtmJcgzwvt/aVEptOn7Y43WRhGlbhf6Ez
         ZQ5kkZdDfsSoUWBRsZvtGYibzIyXFGKttOMNY/LS+gQWT2GVqNmkSdjWB1Lm5unN0OQb
         UZHr/l1bf97T+Y/B3+XWqBOzAKIpIm48KjkGu+6u4889+yTKYokophcXtfi0UUeREpVw
         iAkwZBuTzImiiyCTV/glx3Una5N1JOH8BAxuhO2uE5ke9aQEQNXJsObEO4am7WybGi4T
         jBi/i8S73GskkbYWiyQAkn86PBUvz4fy3pd9oXOJINI4P4ooDBSoQrTbxbIjr4mPUxao
         jqyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Afnm1XJPghycfFBTXXC1c4C7hw4aUgP2Ne/OsI1KDuU=;
        b=UQS336oPPjT6mY63b3ytq4Nxefa3SdaPtqxthTDmkvKBPydARse1sCQvIlMWSqERmn
         ExRm3KDsNFcx7MpatLlwoQlbitu4wLA0xqww3xQaHloTKd2WVh6ra2b2Z7kQUhRVIw+R
         NAUB8Ud1HJ3aZdOXVFmkxYD2yemOQBnKq2swRQQoEkbmWlG691G8gz9eASTUACRAK/6+
         FsvKgHW1AkUA404se244WL7evb5T3tVZXLpGSuXM5VvWCNMIwsfIEprC9tBHTWe9KYf1
         6Yt+FIl0XfxUwKu0RdjuTgRpkIgJIO31sF5ClQm3Xlu5ulZ3RlbAHg4hQgCTmjhRReex
         D8jQ==
X-Gm-Message-State: AOAM531fMd/lZ+Wq4W64H4XivAPWoHh2VAGDye68IOHFKMEaSx8SgbyV
        qyUqi6ahKDGwKN4pItLkgGZGPDUpEsk=
X-Google-Smtp-Source: ABdhPJya+cZjxfPOo6s5JRFMXW2aekI4ELwGsNAzH9GWMm0w9WwsNbe2Z/4zsTSHkcDQUHA6viqkRg==
X-Received: by 2002:a17:906:3b83:: with SMTP id u3mr2746116ejf.207.1594891174814;
        Thu, 16 Jul 2020 02:19:34 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x9sm4431534ejw.28.2020.07.16.02.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 02:19:34 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 7/8] tools lib traceevent: Fixed description of tep_add_plugin_path() API
Date:   Thu, 16 Jul 2020 12:19:22 +0300
Message-Id: <20200716091923.2613228-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716091923.2613228-1-tz.stoyanov@gmail.com>
References: <20200716091923.2613228-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Changed the description of tep_add_plugin_path() API to reflect the
logic of the function. The suffix of plugin files is not hardcoded
to ".so", it depends on the custom plugin loader callback.

Link: https://lore.kernel.org/CAM9d7cgMgqFDvKhs6xwdBSMsaG=3ZG0RtxwgQDCTLGkML1MY4Q@mail.gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200714103027.2477584-8-tz.stoyanov@gmail.com

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-plugin.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index 6b84b9c4e6ba..f0877a7e3e8d 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -646,8 +646,8 @@ tep_load_plugins(struct tep_handle *tep)
 /**
  * tep_add_plugin_path - Add a new plugin directory.
  * @tep: Trace event handler.
- * @path: Path to a directory. All files with extension .so in that
- *	  directory will be loaded as plugins.
+ * @path: Path to a directory. All plugin files in that
+ *	  directory will be loaded.
  *@prio: Load priority of the plugins in that directory.
  *
  * Returns -1 in case of an error, 0 otherwise.
-- 
2.26.2

