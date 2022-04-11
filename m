Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04EECC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Apr 2022 15:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244798AbiDKPUP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Apr 2022 11:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238081AbiDKPUP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Apr 2022 11:20:15 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2AFD326CC
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Apr 2022 08:18:00 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z99so10253006ede.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Apr 2022 08:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OVAcQKlhbG6CW9HL0Y9R8dGb1SN0GZHF1cI9ZN5wH1Y=;
        b=C69vkHKz0WjRW9rRPB2RucmGsbnBTE2vpryo/w8bswpef8IZjdKKiXqX2nseNlM6I7
         sXidqWMBOhG+ZO3muV8aA/DtXE/OAg78FtiNUhzpwucB/hwlOQYx6Y7mr2Ep2qd+MsVH
         IuUn4roeFogBu4SNNhay7EWHLcyUxRVAkmLeOjzQcLxZHGi69aQqfeacABw7qTYPIqJd
         Gt54oA4TwdNyEEIzFynBJTxKiejZdiCkRzvcMR7rkvCy2c3aFLc4WW1PKqtwfzEU5a39
         5KNCrjrTC+oASOqpl7VAoy4FpT9JgQhyaY2y+9YYOVZoynpzmN3159QAQZRXDoWffJ8p
         AC3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OVAcQKlhbG6CW9HL0Y9R8dGb1SN0GZHF1cI9ZN5wH1Y=;
        b=d5VZvK1L5PHDET0oi0vGwFbxmeVdpK3t/0Teg6OvICr4GTROrVO5XLdkK17dc+ByQ4
         ZoqkgKddwXyG2zCcE3joVK41+cqwpaa2IqjH+MM2VmRkLVOhLjtXXuBiIBRYKVUXtX/c
         O3VUj7xnyrx+dVooiwMHPj+P3g0a/sY7hnjMAe1J1oHJZ03NHPIm8jhvM+6l65BWidSb
         FhyDEefZXf64B6YlIH+w8BUHqeYL+PqhUFvjvZw3ThL2wK9HFGZdYTppIKXWw5o2rSGd
         X0LAYCSqLcFd1kU4bhOUqvAz1G+QfXgGSNAucoG4qVoNQQWAgce/hCddUZARQNbvE23f
         RzgA==
X-Gm-Message-State: AOAM532/Db/OQPaZPKq2MSZ1N6nQOBf1wDFVm4AgeTKTBeHd7RnMKzeV
        upW8/5trghsZHXFofYW7nl3ekAXLz6A=
X-Google-Smtp-Source: ABdhPJy+cqtSG5C/6ByFrYrHDIQZBaKPO0c6HW5JR8ZmfNWxAQ0NPdLdv4GBzbPSSFgp20EH8o4Tyw==
X-Received: by 2002:a05:6402:1b07:b0:41d:7abf:8337 with SMTP id by7-20020a0564021b0700b0041d7abf8337mr5997239edb.185.1649690278974;
        Mon, 11 Apr 2022 08:17:58 -0700 (PDT)
Received: from crow.. (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id s12-20020a1709062ecc00b006e8558c9a5csm3867262eji.94.2022.04.11.08.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 08:17:58 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        yinkui.zhang@xedge.ai
Subject: [PATCH 2/2] kernel-shark: Fix memory corruption in KsCaptureDialog
Date:   Mon, 11 Apr 2022 18:17:44 +0300
Message-Id: <20220411151744.445930-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220411151744.445930-1-y.karadz@gmail.com>
References: <20220411151744.445930-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The list of local plugins, returned by tracefs_tracers() must be freed using tracefs_list_free().

Reported-by: yinkui.zhang@xedge.ai
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsCaptureDialog.cpp | 6 ++----
 src/libkshark-tepdata.c | 5 +++++
 src/libkshark-tepdata.h | 2 ++
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/src/KsCaptureDialog.cpp b/src/KsCaptureDialog.cpp
index ca4c2bc..651f811 100644
--- a/src/KsCaptureDialog.cpp
+++ b/src/KsCaptureDialog.cpp
@@ -222,12 +222,10 @@ QStringList KsCaptureControl::_getPlugins()
 	if (!all_tracers)
 		return pluginList;
 
-	for (int i = 0; all_tracers[i]; ++i) {
+	for (int i = 0; all_tracers[i]; ++i)
 		pluginList << all_tracers[i];
-		free(all_tracers[i]);
-	}
 
-	free(all_tracers);
+	kshark_tracecmd_plugin_list_free(all_tracers);
 	std::sort(pluginList.begin(), pluginList.end());
 
 	return pluginList;
diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 08aca09..b435a29 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -1724,6 +1724,11 @@ char **kshark_tracecmd_local_plugins()
 	return tracefs_tracers(tracefs_tracing_dir());
 }
 
+void kshark_tracecmd_plugin_list_free(char **list)
+{
+	tracefs_list_free(list);
+}
+
 /**
  * @brief Free an array, allocated by kshark_tracecmd_get_hostguest_mapping() API
  *
diff --git a/src/libkshark-tepdata.h b/src/libkshark-tepdata.h
index 1b955be..c67c06b 100644
--- a/src/libkshark-tepdata.h
+++ b/src/libkshark-tepdata.h
@@ -51,6 +51,8 @@ void kshark_tep_filter_reset(struct kshark_data_stream *stream);
 
 char **kshark_tracecmd_local_plugins();
 
+void kshark_tracecmd_plugin_list_free(char **list);
+
 struct tep_handle;
 
 struct tep_handle *kshark_get_tep(struct kshark_data_stream *stream);
-- 
2.32.0

