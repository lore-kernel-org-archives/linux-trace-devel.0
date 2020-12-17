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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1761C2BB48
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9917523603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbgLQJrN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 04:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727767AbgLQJrL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 04:47:11 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F2AC061248
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:30 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id a12so25864776wrv.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M42Oik9qEiGU0kYEVyRqw70B360ZmiwtGKtLv1o1IG4=;
        b=XQgPOvAcwjw4rf+ZzQiVjK3HuL6A3igHIl8Jsxsl52nzCSrv2DGHhenV2klpASGpNs
         VJJMAwZIxTcKiMoGhFFCikGFLIUj7tYRwx+qRQ2qRL1mLWTUuhmvOIcsTVRIsX78QEGM
         zRrBR5k+U8KnPq3FMC9E4hmOnN4Aj5kKSt7OTMxkV7UZ6jeHZh18KvCtklbyXpLIMk9Q
         Q+wu+UVFnfKkfSRScPbUfTe1ygB745x7i/5Df+JMK5HJrY1tBFDMSxxewufWysL4ufrr
         eZMYmlwmXvZeZF+BF6W7eDUvEq/HynmewntkmfNZuP2P5vWqJhTlCIfY10TKH8EwB2IX
         cIsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M42Oik9qEiGU0kYEVyRqw70B360ZmiwtGKtLv1o1IG4=;
        b=AW2zr76FeZcu2JJoZGOpXwoF6iQREM0hFzOgiGoGtbenBsm5fSZ7Rfbuzgr4PrGHpn
         Fg8fnPXjPujczZONR2Jrxu+6vF3TMyyhENJgJIwjUGTv2dz6DmejH2tHDC3vp73Okb2+
         kxxLkPO+EdM6GOAC1tL/gPHn7/1qnJoQw/VcC3CJgWKIyGjHQWv88rDhPloMykq26hI6
         J1DXx2OjK69oM/jBnIoJx83avOrE7qOBxm+4oIpmBdK1A/BgbeP3dYCy3pFGn57kC2kt
         MQeb6if3u2aoNS7ahsWyRjnT3xAdINkp7avsseGVc3FnykdYgXJ0s1HUxkIAfNzvBBU1
         0ygg==
X-Gm-Message-State: AOAM532lLlhFmg8rt3lHikuxj/7Meo/0DaENpiE/gVjPYtXs4KsEVW6L
        LOHX+aT6k8SB4NbuaxVsehM=
X-Google-Smtp-Source: ABdhPJyVC4sF5iREmtXVwnW3bAWZyFRZmqKskGKOXZeSNGUjRYvxyW0wj33aS5YtYvG3P3HBNGM+2A==
X-Received: by 2002:a5d:6a4f:: with SMTP id t15mr11705237wrw.62.1608198389616;
        Thu, 17 Dec 2020 01:46:29 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id o125sm6773164wmo.30.2020.12.17.01.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 01:46:29 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/9] libtracefs: Remove doc_gui targets
Date:   Thu, 17 Dec 2020 11:46:18 +0200
Message-Id: <20201217094626.1402191-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There is no gui in libtracefs, removed forgotten targets for building
gui documentation.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Makefile | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/Makefile b/Makefile
index a7d5808..7460d4d 100644
--- a/Makefile
+++ b/Makefile
@@ -255,19 +255,10 @@ install_pkgconfig: $(PKG_CONFIG_FILE)
 
 doc:
 	$(MAKE) -C $(src)/Documentation all
-doc_gui:
-	$(MAKE) -C $(kshark-dir)/Documentation all
-
-
 doc_clean:
 	$(MAKE) -C $(src)/Documentation clean
-doc_gui_clean:
-	$(MAKE) -C $(kshark-dir)/Documentation clean
-
 install_doc:
 	$(MAKE) -C $(src)/Documentation install
-install_doc_gui:
-	$(MAKE) -C $(kshark-dir)/Documentation install
 
 define build_uninstall_script
 	$(Q)mkdir $(BUILD_OUTPUT)/tmp_build
-- 
2.28.0

