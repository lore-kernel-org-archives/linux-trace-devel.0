Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B7EC7618B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5C83218DA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:57:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ba7InO9r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389859AbfGYK5g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 06:57:36 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46276 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390154AbfGYK5g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 06:57:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id z1so50246052wru.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jul 2019 03:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tdDQhHb+xp7ClUdZDm99YoRRflL+HzrGkfo7lDIr9fI=;
        b=ba7InO9r+tHTuGOi/FIJn1lq9o9rkh0LDg0tpEAGLLv5g+63feW31zz+oRci4k3xia
         kliTvnOqdv4jzW/Lnv+EzWn5H8/4X5sHSRtfuMwi+txzVvP+aOMCnmI80eoFEQw9m0As
         mRefzgxqwWxeN73wiC9dm6dRgBgsuWVWJxwFLscJHKURuXWlu+lX5AutpbHLfuyd29pv
         2aw+JVWt9XHOlr2FHyupKvXLbG9Hopp2PldvaElmjc3i2MdEbBhOcVhI0Vx0yoqmPHVK
         8WnrEsFWCzytVr0uIoEeXN711IKuTow5R+tRCghNl+8JuRTWsffNWqthud0sbVdSzXIX
         Ae5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tdDQhHb+xp7ClUdZDm99YoRRflL+HzrGkfo7lDIr9fI=;
        b=I9MTaxwgnBTYgrxQbaEWdJxleqknfapZCXae3WOMZObQYTgThjIKsqkB/IFdQfB/dA
         Gid1hNz2N0iQ88TkxHkRd78bkmcpDlEyrBM6wuxSL2R4v+QRbwyyCFOs4WQ2b6S4K2gg
         D15v7zjM87RfVz8ly+OJadstzopuWQNrvuV6j+zFpKDQ1R8w2l6T8UdBhAarrSWIBrT+
         vxqoZijDVLXYFOtxUh/FU2RyKy7OMqt6PTzo09WNP3C/A9wSvYnkIX2L358AQos5UCL3
         6QjHyv04a9hn227NLEGGm4ggoj273cIlPGAc/Ll7HsZ8AO7sYgGrZkHCS2diPYxVicIt
         pJLg==
X-Gm-Message-State: APjAAAWHqefGg8NIq5eUldjH9ReZX3tYuNDBnGwJ65YNs0X/BuHvm1aR
        oNi0OU7KW/Bb40U26nArfLdToFqixVw=
X-Google-Smtp-Source: APXvYqw9UaPulcupQ1izKhETFVf7hRl7IrqUOPJAkfZV+rPV0r4KOwDUOflXD1cYPkeGA2UbNslUpw==
X-Received: by 2002:adf:a341:: with SMTP id d1mr46007456wrb.260.1564052254283;
        Thu, 25 Jul 2019 03:57:34 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id n3sm43769644wrt.31.2019.07.25.03.57.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 03:57:33 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Fix a typo in warning messages
Date:   Thu, 25 Jul 2019 13:57:31 +0300
Message-Id: <20190725105731.28782-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

There is a typo in few trace-cmd warning messages:
 "cound not" -> "could not"

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 lib/trace-cmd/trace-util.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 7c74bae..d3bb333 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -608,7 +608,7 @@ static int load_plugin(struct tep_handle *pevent, const char *path,
 
 	handle = dlopen(plugin, RTLD_NOW | RTLD_GLOBAL);
 	if (!handle) {
-		warning("cound not load plugin '%s'\n%s\n",
+		warning("could not load plugin '%s'\n%s\n",
 			plugin, dlerror());
 		goto out_free;
 	}
@@ -629,7 +629,7 @@ static int load_plugin(struct tep_handle *pevent, const char *path,
 
 	func = dlsym(handle, TEP_PLUGIN_LOADER_NAME);
 	if (!func) {
-		warning("cound not find func '%s' in plugin '%s'\n%s\n",
+		warning("could not find func '%s' in plugin '%s'\n%s\n",
 			TEP_PLUGIN_LOADER_NAME, plugin, dlerror());
 		goto out_free;
 	}
@@ -1525,7 +1525,7 @@ static int read_options(struct tep_handle *pevent, const char *path,
 
 	handle = dlopen(plugin, RTLD_NOW | RTLD_GLOBAL);
 	if (!handle) {
-		warning("cound not load plugin '%s'\n%s\n",
+		warning("could not load plugin '%s'\n%s\n",
 			plugin, dlerror());
 		goto out_free;
 	}
-- 
2.21.0

