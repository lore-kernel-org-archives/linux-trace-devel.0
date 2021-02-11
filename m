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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BDC2C433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 12:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BA3E64E79
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 12:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbhBKMLM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbhBKMJA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 07:09:00 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A27C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 04:08:20 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id v14so3920367wro.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 04:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IM7kAXcSxzK4mFOS925yBXrOauCoChruKbCJY2RE0Do=;
        b=SS2O3DoqOmB6AegHmWF8kkqRYt0FGlApvSf3SMvACA2FDWgwkF2luxDoELSZIss3bm
         T+zNAWH+7vOukSkqlQJPfwbLYZ/GYqYCj3RuW5HvJLGe09clje6DRGz2OJL60OyD5spn
         HLM3YuL+JWre4cVNLRDi/5pF6k+/sTv5uDbFug1u851L0KPqL/VAx/Ys8eiX6bf4Zt6T
         JP1AwQGbrqNM+TRvswBY5Jy0hkiUWCW2fvXDVA4G8l/PMO4POh+bKba0FnXQ6IqJ14ge
         dEzOCwRYL/S7pmFMB0m3hhVy5KbMDY8A2kRDgBVaI0GKmNjLMXWA0vll6G/nH3DEl44t
         /SfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IM7kAXcSxzK4mFOS925yBXrOauCoChruKbCJY2RE0Do=;
        b=nUp6O08NPD5t8ZmONnglhBxv6ZxnS+Pr5/Pb9UW40Wuq0n6M7smC2ucku45gaamDIr
         /62x6TH4sbxl9JkUa30Pr4duUp5ydeh1OzkN2nV72bzQLEIGybUHjsNy5CX0AwmuKBs4
         6luZzHy6xmSBba7NCZYFyl3pgjUHEoLExBAje/hQgRndjTg4AR4GOV+oLLF196/cu93U
         KW/pSlNWElspLtOmYWKm8ou37+j5PSE+uDE9Y7b6drZHlEc+m7hf1o7DJtBais4+y9oF
         twSqPbuFZ1biNFAgQdf0RtkYLxHn4uQnc6wQfzmyad1hDSSQfKESdP3pEX7AQd+M/6As
         T22g==
X-Gm-Message-State: AOAM53384mY0/jJ9mz1o0DTVFnGnjIstEGmZikSMcSoYstLm4yERg1uK
        ON7FuEL3X/QaAYx/jhJb0r/ecwNIPgs=
X-Google-Smtp-Source: ABdhPJyePa3ez75g3D0a7wBcMH0Ks7mPYd0GdUi51KumTru6SGQ/EHvGNMa1jS+UtHBmew3qFWodeg==
X-Received: by 2002:a5d:5283:: with SMTP id c3mr5268210wrv.319.1613045299185;
        Thu, 11 Feb 2021 04:08:19 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id x11sm529507wrv.83.2021.02.11.04.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 04:08:18 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark: Adopt modifications in the API of libtracecmd
Date:   Thu, 11 Feb 2021 14:08:05 +0200
Message-Id: <20210211120805.423085-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New flag parameter has been added to tracecmd_open_head() to control
how the trace file is opened and parsed. A corresponding change at
the caller side is needed as well.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-tepdata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index d4be052..d29e98b 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -1587,7 +1587,7 @@ int kshark_tep_init_input(struct kshark_data_stream *stream)
 	tep_plugin_add_option("ftrace:parent", "1");
 	tep_plugin_add_option("ftrace:indent", "0");
 
-	input = tracecmd_open_head(stream->file);
+	input = tracecmd_open_head(stream->file, 0);
 	if (!input)
 		return -EEXIST;
 
-- 
2.25.1

