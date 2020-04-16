Return-Path: <SRS0=rfvd=6A=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BF0C2BB55
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Apr 2020 16:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65B8D217D8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Apr 2020 16:01:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lyOMrVW2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636498AbgDPQBD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Apr 2020 12:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636465AbgDPQAz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Apr 2020 12:00:55 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D34C061A41
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Apr 2020 09:00:54 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id m2so5972353lfo.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Apr 2020 09:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z/wXcUmxU9FUxsKqNRxJ1eGbIBu9SXt+a1ux8DnDl6g=;
        b=lyOMrVW2WykxgHhbG+V0xT9hUMy2UbAbR8kCHwzowj9XzTbQxg38d1n+EvplhogPQe
         8AkrwFRaDaEh+rSx4VU+xJEnhZ/K0O5xQ3qHK1HzxwGSLzZFspkOpuHpbTnfTO/upQQY
         HkiXHhbLse/Bs4cBZBK/LzagNGgQG/XYVhS3KfhCO/1xT7fEFt80qUfX4LVPOeBFkeOJ
         uJ03ywB24pR7FXkN59Acg+jxG/3lLsxJx/XhYN2Pv0QsKVl9zldr0c7QXEHLPxNs4e6L
         gdx1Zec0zyNzfI4JpxFyGsZNH0IGd5b/TI2Y9R+Z6wIRgTN1+1iqiUrJJ3dtgwk6UhtL
         C7KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z/wXcUmxU9FUxsKqNRxJ1eGbIBu9SXt+a1ux8DnDl6g=;
        b=P9/G0S1SdC+MuWajrdFldbQMv2n4BOcb/IGJhgXDv6Blw6An3pzLqqTA45fwLbJAaS
         xVwDn0e3rNYv7xPP4nLBDjyiEM/xWXTV07rfHVCpMB9NMVK0b/2ibixRzkGTva+LAU1Y
         jYru+23ktjfhaSoL6N0slgCt8+RJSSBK2n21DOB365AoLsys8p0L0w1x+Q7UgGLCEFoe
         f8xtGPlE2/NGRWMfM1P0COBjErQcCP3RFiewBUIYUiH+qy7+wv0nTTtwNVKCz1PTMqnT
         6etjBelqZ6f4ZFxOF8CcZhTybecHNtCoZOi624FFIdXr1z1Xm+hpmyMdEnHjNhfk6Fku
         9izw==
X-Gm-Message-State: AGi0PuanI0rtDP8iFX60fj5WIvuHXzOrwj6Gaksr3KutY5F+iwGRANGy
        XMRGSQgG2Y2Jll2SL4ghzBo=
X-Google-Smtp-Source: APiQypLhdprFN6spqTEADe+kez+JNUBtvbfwrUKiEDcvKKQqgdiZymT6EP+vTLHllrWIsq06Jwfrsw==
X-Received: by 2002:a19:43:: with SMTP id 64mr6246789lfa.67.1587052853306;
        Thu, 16 Apr 2020 09:00:53 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u2sm9030413lfk.67.2020.04.16.09.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 09:00:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 3/5] kernel-shark-2.alpha: Print the plugin's file name in case of loading error
Date:   Thu, 16 Apr 2020 19:00:45 +0300
Message-Id: <20200416160047.77118-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200416160047.77118-1-tz.stoyanov@gmail.com>
References: <20200416160047.77118-1-tz.stoyanov@gmail.com>
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

