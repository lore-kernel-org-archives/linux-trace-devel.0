Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28852C2BB55
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 14:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE49A2083E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 14:25:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X+LtrvJ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgDIOZR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 10:25:17 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37981 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgDIOZR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 10:25:17 -0400
Received: by mail-lf1-f67.google.com with SMTP id l11so8046086lfc.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Apr 2020 07:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z/wXcUmxU9FUxsKqNRxJ1eGbIBu9SXt+a1ux8DnDl6g=;
        b=X+LtrvJ9Eabj+hWXMaWjYp/kw4zDXsmi5MIel7aWP0bY9G1EXP43X5Whs/cedE1X0L
         mEyKuD1GNuw4o2Mdo97zgOjVhPGgGpn20uQx+DiV5MW69tzz0tMi+jiOxRPUDo7wj/tz
         rKLLeb94GGiFmMzWijsBCrn/C6E5u8/djl0Q0jCvRGqYlEMP7WOLIdLhjI3hnkuYLAPr
         Tv/C9704k05FU51n+JMT1gY3uFba4ZiZjs9eVg0KRJulihBNiMf1NePMQUtU7zOqsZkE
         Gpn+9n9ydqQn+1pF0CRzrAmVHuzhWjAvPg9TtF4f6cs99hjTwzkSI7JpKctA9vnaKRM/
         i1rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z/wXcUmxU9FUxsKqNRxJ1eGbIBu9SXt+a1ux8DnDl6g=;
        b=uFV3zC1EiCOSIBuulfTtnZ9N/FQPIZeNxw/bVssPKbYxxHnOSNxt0zfLAJ0E34hqFV
         tnd55g57xJZQK0EIsmtxlh2gkVQtiwZ/Urhgk2MVqTEo9CHiBZ6WDrQ59WOwmOAs7R69
         u2C7Ew91Agvmz9kxZzwDxzGPn6fv7A88KevFGZ1DWFNs9q/TiwidxyorzvMnqHGNDDHi
         Zac7lpIHFWbF87c88QTUeQ1AUrxECa3sWrlMwHDP5eobtxoSpM4XpjD48G1X1rNqcVc4
         hzuv201X30/dnmc5akTMLaBKc0OR9R5uteiHomSto3n7d8u0+JPoXBw1tVl3lwzXPA5T
         mOdQ==
X-Gm-Message-State: AGi0PuaLbGvTrCGd92DIIEzuhMIYXFBmFcLnW5wR67vAu0MrvxNwsO3a
        7WC1fStYl8IRiaLT1TZtqjLFvgG+7XQ=
X-Google-Smtp-Source: APiQypIt+g+KUVCgo0rFU+RBTew9IQ+E9431KpURAT2C1QAsH0OyXeWyZonNB5SQ805MwxyOYgYk4g==
X-Received: by 2002:ac2:51c9:: with SMTP id u9mr2119736lfm.184.1586442315710;
        Thu, 09 Apr 2020 07:25:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e7sm181230lfc.72.2020.04.09.07.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 07:25:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] kernel-shark-2.alpha: Print the plugin's file name in case of loading error
Date:   Thu,  9 Apr 2020 17:25:08 +0300
Message-Id: <20200409142511.82228-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200409142511.82228-1-tz.stoyanov@gmail.com>
References: <20200409142511.82228-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

When dlopen() fails to load the plugin, "plugin->file" is still not initialized.
It is useful to print the file name of the problematic plugin, "file", instead of not
yet initialized "plugin->file".

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 src/libkshark-plugin.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/libkshark-plugin.c b/src/libkshark-plugin.c
index f9a721f..1cea87b 100644
--- a/src/libkshark-plugin.c
+++ b/src/libkshark-plugin.c
@@ -331,8 +331,7 @@ kshark_register_plugin(struct kshark_context *kshark_ctx,
 	return plugin;
 
  fail:
-	fprintf(stderr, "cannot load plugin '%s'\n",
-		plugin->file);
+	fprintf(stderr, "cannot load plugin '%s'\n", file);
 
 	if (plugin->handle)
 		dlclose(plugin->handle);
-- 
2.25.1

