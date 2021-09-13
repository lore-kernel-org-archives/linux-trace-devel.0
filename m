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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBAEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59BDB60FDA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbhIMMbO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239998AbhIMMbN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:13 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D9AC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:29:57 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id d207-20020a1c1dd8000000b00307e2d1ec1aso695669wmd.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3DsKmbUl6RCSpu9xYkSPL4TVjHhcbTIKRd2pnRC2KRg=;
        b=Pcnjox6bkUB6CPPWfuXNnPCAsDW0kPdDbzyslLsD/Y+tNuSbdNEnIxF5j1gWKlP0im
         gMbh6YFnqoPcqi6kQzja6sIZ6OpI11Kepn2uuOn7q5jtSz6mTnFGmvqbIzo486x+yCus
         vMYJ59mnD9WJCoZ8Hcv0LAhn6ntxYo8ThXSI3+ZxnjxeLsqQk9BuyCLGV5EsbnhawagF
         0qD7xCA4a7GeTxr9SMA1V9NhceZX92+sB5BY/WAUIsaH79E4seA0cHgEmP5ngfDsymye
         wgRt2h0uCzWgrjl6qu1QrAi5RXU1oFqQr9Mj5tRuxQ20dfqU7O9OCiNh0KH/myGOcHz1
         L0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3DsKmbUl6RCSpu9xYkSPL4TVjHhcbTIKRd2pnRC2KRg=;
        b=WIytQZ4j9dGTCZV3j7D1HqkNV5YXc7AdlL5XeuV069lbtPnnItlCf8a0qANwyzHNP1
         h1a5jQQ7/0D+TyjffcuUVsSyNZxy7SCubI8CZ7avv/wCfc58GOASCmPk67vYt1sqRYHp
         1rhnKzN95owtaCskTuDMGYc3s4gt7h8LhsN80jEdG9xlOGGyy0RjjT2znNCbRRonxwrs
         dbvdi2jyH2MQPSKlu83MsJEKTfHj3DXDs3S3IQV3jgqroUi8W+QOK2FD0COq5p8Tx0Qy
         2QGVOLw/zfX+OtoDpAyVGFEwQDYWfUypFwCp8x8VEfmvjFf6y5r/91g5ZTD/YoqqAVvd
         gLkw==
X-Gm-Message-State: AOAM531dWPQXKezNkOR9CbsoOOCAs6IQyZHHWnN/maYn53fwWlNZSJd0
        7L9jSwUpEyTW2/JoOl8q4JPSzjoOyv0=
X-Google-Smtp-Source: ABdhPJyXqY2vUaZZQJSfhUnt8P+HAeeX6nEbnSXRm91RfBrXYwi73NIulw8GvxSQKPkJhXHseklSTQ==
X-Received: by 2002:a7b:cf09:: with SMTP id l9mr10847876wmg.115.1631536196592;
        Mon, 13 Sep 2021 05:29:56 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:29:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 07/25] trace-cmd library: Do not write CPU count section in trace files version 7
Date:   Mon, 13 Sep 2021 15:29:29 +0300
Message-Id: <20210913122947.3673239-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Writing CPU count as a separate section in the trace file is redundant,
as there is already an option for that. Use that option in trace files
version 7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index ee06b00f..5ca27026 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1398,10 +1398,16 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 				 handle->file_state);
 		return -1;
 	}
-	cpus = convert_endian_4(handle, cpus);
-	ret = do_write_check(handle, &cpus, 4);
-	if (ret < 0)
-		return ret;
+
+	if (!HAS_SECTIONS(handle)) {
+		cpus = convert_endian_4(handle, cpus);
+		ret = do_write_check(handle, &cpus, 4);
+		if (ret < 0)
+			return ret;
+	} else {
+		tracecmd_add_option(handle, TRACECMD_OPTION_CPUCOUNT, sizeof(int), &cpus);
+	}
+
 	handle->file_state = TRACECMD_FILE_CPU_COUNT;
 	return 0;
 }
-- 
2.31.1

