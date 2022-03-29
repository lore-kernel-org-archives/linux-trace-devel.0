Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114AEC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Mar 2022 19:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbiC2TTv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Mar 2022 15:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234102AbiC2TTv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Mar 2022 15:19:51 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761F324BC6
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Mar 2022 12:18:07 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id s11so16201522qtc.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Mar 2022 12:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/5JT098dR5sJ8vRsuBwbrbhxc7aDb5G8/8q7du5r6j4=;
        b=BgXyY9ykcVIsF4Sad1kyZDDWqOeVWCKXwL/W3gV6TvjWFqvrk3E3KpoHE7kGtR/cAo
         gNXyK1KTUvo84kHvlOq4k43VRFFvGO1H6UAOUGMZjCa7UF/AwU9cTYMlVnmmslV3DjOl
         nNWsCIBzQXY3R7GJZmo61nIf6t+aUChdRBZnA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/5JT098dR5sJ8vRsuBwbrbhxc7aDb5G8/8q7du5r6j4=;
        b=m5yFcoj8/DqRWTsVlD50HyVfASMWnd01gevtPIMg61KG58gTNeG12Ig9hMr5Q7MYDb
         gqHmFLKIvrclJW9jR3ixNyTijv7L6HQDg+/QESkLGSd9FRDIzBXZWYyE+8G++aYbm2n0
         6WROeq6hzMKU6g3SNntVMlhaSpiCYSOSa/kuQ5neQD8Kx+4ILzZPcE9XfTlFD0jTs9FM
         G7OJTWwFkPkn55LKwfkeODprG6xoqreTtN6yqTM6yXy/koWqcqx0+9RO3CTuVZoa/2pC
         j1yF5UsWQa03jNRtR7Mlwg2A+JwhwIr35au84yQOsYR18dXGzRPac/azu4/ll6v2K+5t
         Nduw==
X-Gm-Message-State: AOAM531AhsP6o64kuDCWMCmaY9CSdqth8j0JuUhZUK1CJy6aJFk2p7RP
        UnGEDACN0dn4q4pr8RIkPxJY54ZZLcubXw==
X-Google-Smtp-Source: ABdhPJz0I5f653SyVW4rZDY7Up7SgMZeqGZShnlPjcuCUS0yNDb5gBhlMlTf1qNODwXHF/9KP1zyHA==
X-Received: by 2002:a05:622a:11c5:b0:2e1:b9fd:ec28 with SMTP id n5-20020a05622a11c500b002e1b9fdec28mr28840647qtk.258.1648581486339;
        Tue, 29 Mar 2022 12:18:06 -0700 (PDT)
Received: from joelboxx.c.googlers.com.com (228.221.150.34.bc.googleusercontent.com. [34.150.221.228])
        by smtp.gmail.com with ESMTPSA id bm1-20020a05620a198100b0047bf910892bsm10601544qkb.65.2022.03.29.12.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 12:18:05 -0700 (PDT)
From:   Joel Fernandes <joel@joelfernandes.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     vineethrp@google.com, rostedt@google.com,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH] trace-cmd: Try alternate path for message cache
Date:   Tue, 29 Mar 2022 19:18:01 +0000
Message-Id: <20220329191801.429691-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

For some systems like Android, /tmp/ does not exist. Use the /data/
directory for message cache.

With this, host guest tracing works on Android VM running on ChromeOS.

Cc: Vineeth Pillai <vineethrp@google.com>
Signed-off-by: Joel Fernandes <joel@joelfernandes.org>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  3 ++-
 lib/trace-cmd/trace-msg.c                         | 10 ++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 6934376..492ad9c 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -377,7 +377,8 @@ enum tracecmd_msg_flags {
 };
 
 /* for both client and server */
-#define MSG_CACHE_FILE "/tmp/trace_msg_cacheXXXXXX"
+#define MSG_CACHE_FILE  "/tmp/trace_msg_cacheXXXXXX"
+#define MSG_CACHE_FILE2 "/data/trace_msg_cacheXXXXXX"
 struct tracecmd_msg_handle {
 	int			fd;
 	short			cpu_count;
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 03b853e..91dac77 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -595,8 +595,14 @@ int tracecmd_msg_handle_cache(struct tracecmd_msg_handle *msg_handle)
 	if (msg_handle->cfd < 0) {
 		strcpy(msg_handle->cfile, MSG_CACHE_FILE);
 		msg_handle->cfd = mkstemp(msg_handle->cfile);
-		if (msg_handle->cfd < 0)
-			return -1;
+		if (msg_handle->cfd < 0) {
+			/* Try an alternate path. */
+			strcpy(msg_handle->cfile, MSG_CACHE_FILE2);
+			msg_handle->cfd = mkstemp(msg_handle->cfile);
+			if (msg_handle->cfd < 0) {
+				return -1;
+			}
+		}
 		unlink(msg_handle->cfile);
 	}
 	msg_handle->cache = true;
-- 
2.35.1.1021.g381101b075-goog

