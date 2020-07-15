Return-Path: <SRS0=0q7s=A2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75278C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ED2E2075B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p3Cw1eqw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgGOCaQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 22:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgGOCaP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 22:30:15 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7F6C061794
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:15 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id y10so580675eje.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UUL6WRcZ5/729ymjh03S+YSwLTUvh2hCtJAWaJpRrPg=;
        b=p3Cw1eqwLd7MbCXSURxI2NTWvc/zZa5BG8vxSS5EpY5D9bYhccszHmGdTj+e7IFNoo
         Zm+2EngyyDSC0VBdjh4gK/gx17x92DfeazVZ37//2YqGBH5Yx5ZW6NE3kW3ph0wXX6L6
         CwOFBIqWULP13Y6hz1TFvhFc7+clDMNjZt4Gofo/pB102I3S1zYw2Ma+VpHoM/pOqzHh
         RbTerheD12BDDVSWnvDCnvJewpW2p1YvfsSzKGBW2ryGzdxN76tPLmxmMdGHTR2yAOFH
         6fVOGqGt+cQCO/9UVY+0JCX7j6if8lg6d19qKB7AmaCBVbby1soWs1ksTACmYPJl1Qv7
         D2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UUL6WRcZ5/729ymjh03S+YSwLTUvh2hCtJAWaJpRrPg=;
        b=Sx0LkDlfNlshLtl/oyq4TxszIQitRXONXCAZ1bmsNaRMkNF3K3MVhW0vQnna4E9MVz
         PUbW+kR1yMv+FRqYmcM+qBFUzU/5AMGUNwYX1XWzon4HG7Fri+OD2RUiplRCYjyiwco9
         65Pcql0ZcILezkj24bqW6rI27BH/YjtdVeM6HbTyZFJtxmFnLebg4HGhL+ryFzNiGSGm
         xtDYZqqdz3WxHQXAP/4NPotjpe5ksS84hxWnGhTHeKd9vWW6ihmdTFzr6vtc9E6hEZeE
         +AWKXWnV29Vd22VxWp+nFELMkJYGcj7zYh68Qlzwcbg55ltQnfhQDJGAR7WotUdl1TR5
         M6tQ==
X-Gm-Message-State: AOAM530BqmHMRl+N/uoVuk70Eb5K7wXMHALRXWF5yTCP5X5I+znBoYGX
        AB9QfxpTd5OBCG+iDOadUJf/VlgtpBk=
X-Google-Smtp-Source: ABdhPJzDNI4J3K8/5IUn2otJHCTr/YkuSDbYjqojYDiIDXL6YtPoq+5XvYOfkfQAuV/JrXChmA5eZQ==
X-Received: by 2002:a17:906:2b54:: with SMTP id b20mr7211779ejg.366.1594780214132;
        Tue, 14 Jul 2020 19:30:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d24sm576474edp.83.2020.07.14.19.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 19:30:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH v2 1/8] trace-cmd libtraceevent: Document tep_load_plugins_hook()
Date:   Wed, 15 Jul 2020 05:30:02 +0300
Message-Id: <20200715023009.2503879-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
References: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add description of tep_load_plugins_hook() traceevent API.

Link: https://lore.kernel.org/linux-trace-devel/CAM9d7cgLBWCrEHwz+Lhv5x5EXGcNWB0QQoeGh3OKh2JfR=dV9Q@mail.gmail.com/
Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-plugin.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 30c1526d..c11636ce 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -544,6 +544,22 @@ load_plugins_dir(struct tep_handle *tep, const char *suffix,
 	closedir(dir);
 }
 
+/**
+ * tep_load_plugins_hook - call a user specified callback to load a plugin
+ * @tep: handler to traceevent context
+ * @suffix: filter only plugin files with given suffix
+ * @load_plugin: user specified callback, called for each plugin file
+ * @data: custom context, passed to @load_plugin
+ *
+ * Searches for traceevent plugin files and calls @load_plugin for each
+ * The order of plugins search is:
+ *  - Directories, specified in @tep->plugins_dir and priority TEP_PLUGIN_FIRST
+ *  - Directory, specified at compile time with PLUGIN_TRACEEVENT_DIR
+ *  - Directory, specified by environment variable TRACEEVENT_PLUGIN_DIR
+ *  - In user's home: ~/.local/lib/traceevent/plugins/
+ *  - Directories, specified in @tep->plugins_dir and priority TEP_PLUGIN_LAST
+ *
+ */
 void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 			   void (*load_plugin)(struct tep_handle *tep,
 					       const char *path,
-- 
2.26.2

