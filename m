Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E24DBC43603
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF3BB61285
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbhENMT6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 08:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbhENMT4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 08:19:56 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C32CC061763
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:18:44 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id b25so44315972eju.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BnoEnZS3w88xtGosGlgdepOl60qxJWhr2OKhUZWO20Y=;
        b=r8imbmeLezFq7r9LKiBeC86NAzrww8qdSnoTSPriL5FzUXaWaM62UTx3z8ajfpUpzh
         tVp6nE0suWnsSKv5oU1c0HZ2uJreuIvsxZumme3HVfWhzDHdPrNrIzMHa+le47RMFB9G
         yz0pawChpqjejBHFRLakqUR86fNTmjvt4wtXDrDtsPJ2srQnWOXTlkrLDY67WEXA/i6C
         UOzGbNvIObhOJ9c7J2LbD8iOypJBzVM2nj0wckL1yAdeAHqXA/vv9/+JmOQbSJrU7DsX
         v94G0y7obQLdoQn2Vcs0pXd1ANzGTKxEmAgxfnD2aEC5EU82dTFY3AljcRJHG70Uu3FH
         5A/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BnoEnZS3w88xtGosGlgdepOl60qxJWhr2OKhUZWO20Y=;
        b=PDjP2YOHlsuSL/ski81VryIuWOnsQTge26ezvuVb12A2cyIBfrCd60tCz1OnZaP98L
         ApBCuqQgZzg/sPjj8aNl3UX4Kx5TQdIXc243p7ZtIyhp3VJadxRwB50bO3TV9M0R5cre
         pSS+ZX1leSvhilhVfpO+O6LJnl4QX+oVAOH5sh0cvinKwRw7WS0VCzy2YqIM/dexw0xf
         3NwftjpFNEeJcNYCXX3VFFYwBKFcHe5fP22p/QOfRZhFONJAwYQQnDB6Q9Eggb50Ve4q
         8QUUWI+neJ2affffj8rhFeQ5mtS2HLHbV92pWrhCy45hR0vh8qUp5UC1Z91B2b/LywzY
         +9dw==
X-Gm-Message-State: AOAM5305Q8ohsOYl5ZMifF1qdyDEbc93NveNjlELxcfcoPmkH0W/NaaA
        wVW4fo010MKwumuYuALYcK1m/XAgE2U=
X-Google-Smtp-Source: ABdhPJwItGzKGr5yw1E0GILrfr7mp/Yh/4C8CeTtieZ5iWsQuijRcjIGB33wlUlmFpnb6IkTqB+z+A==
X-Received: by 2002:a17:907:248c:: with SMTP id zg12mr1176418ejb.268.1620994722645;
        Fri, 14 May 2021 05:18:42 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id cr21sm3435157ejc.2.2021.05.14.05.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 05:18:42 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 7/7] kernel-shark: Quiet the warning printing from libtraceevent
Date:   Fri, 14 May 2021 15:18:26 +0300
Message-Id: <20210514121826.161749-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210514121826.161749-1-y.karadz@gmail.com>
References: <20210514121826.161749-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All those warning messages are not really relevant for the users
of the GUI.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-tepdata.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 4a84141..323383f 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -45,6 +45,14 @@ static bool init_thread_seq(void)
 	return seq.buffer != NULL;
 }
 
+//! @cond Doxygen_Suppress
+
+void tep_warning(const char *fmt, ...) {}
+
+void pr_stat(const char *fmt, ...) {}
+
+//! @endcond
+
 /** Structure for handling all unique attributes of the FTRACE data. */
 struct tepdata_handle {
 	/** Page event used to parse the page. */
-- 
2.27.0

