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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF2AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E59660F0F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240003AbhIMM3c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240002AbhIMM3b (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:31 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71AEC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:15 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id d6so14389821wrc.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=glIMpG3HAPgkuiI7fGRy4IPowDQe4caybI6/I/n9b08=;
        b=XlIDzqG3pv0HpGcWNKHxFynKKupwP/6i5iNS0Fzars+SfNuj68psCN+ILynT1Am1cj
         dgokO5tMq41RN6/Lpg683lu8a/Y+R9NdDnIqpeoTlrNiwCTX5KY4nRaE3m0eqDp7Ugiy
         8RFLttwGgSRotKy7yW3/YdeAndXlU40SfhfVteYyfcm0u9WmRm9q+Kf7ug/ST1uJKhoY
         kdzj+GjzZJyVAaDYD5mRNDC7UhIzg7voHrwgolkCD//PC6XhQmX66GXWqHtFNe5ViCIy
         JOIVgPvm025yTtXMaNOICRLrFUckObgloA48zSzaSwjeNLcZzatuM9UoSN7fu88VcDyw
         6sCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=glIMpG3HAPgkuiI7fGRy4IPowDQe4caybI6/I/n9b08=;
        b=2R4PO4g+DNufUvqlVB1+2jM/jFNN78cJizOTiU87qCCbDJtldhxORFR5UCgdbx8IcT
         +0rlb3BMIcYH6/YEMr9nXhMSz3dfWvNsqBB3/0NcJeAKCZcde9DwU1C63IwaSWYLG6Sc
         Y5hgETcabjEfR5IUdgV9Nk+2OR26teZ7rmHqtFmw420rZ13wmnbXqJCUVt4+KGU/BI8N
         KEbzGM+UT2eccsgeRSk6eUdBHFTFo3zDicMUkqx2V4xrx2WUYVHHkRA8oo+NwcFDNjYr
         g3XcOp5LbczMv/eDxN+SQXfif+EqmuGuTgMo7JwjWgG86gIl5ltA3aYairTr+K5asNKk
         +Wog==
X-Gm-Message-State: AOAM531+FXUh5pmPDCI6skn9gGX5BxF1evgazeBqVjaE4xFluGdODNwf
        pFfGjuhpXYOrj0qeriJ+/MhfpwLhOMQ=
X-Google-Smtp-Source: ABdhPJx+LZQE7ewEQ4PrErQ1h13QGBHV9IJzdOIKYazQu6W5oDb38LpjEprMbBmE1RosWLjwRrM83w==
X-Received: by 2002:adf:f48d:: with SMTP id l13mr6582705wro.94.1631536094492;
        Mon, 13 Sep 2021 05:28:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 13/21] trace-cmd library: Fix possible memory leak in read_and_parse_cmdlines()
Date:   Mon, 13 Sep 2021 15:27:51 +0300
Message-Id: <20210913122759.3672494-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some error paths in read_and_parse_cmdlines() may lead to a memory leak.
Improved the error handling of this internal function to avoid it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 60d75d47..9fd7e6e8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2999,20 +2999,26 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = handle->pevent;
 	unsigned long long size;
-	char *cmdlines;
+	char *cmdlines = NULL;
+	int ret;
 
 	if (handle->file_state >= TRACECMD_FILE_CMD_LINES)
 		return 0;
 
-	if (read_data_and_size(handle, &cmdlines, &size) < 0)
-		return -1;
+	ret = read_data_and_size(handle, &cmdlines, &size);
+	if (ret < 0)
+		goto out;
+	if (!size) {
+		handle->file_state = TRACECMD_FILE_CMD_LINES;
+		goto out;
+	}
 	cmdlines[size] = 0;
 	tep_parse_saved_cmdlines(pevent, cmdlines);
-	free(cmdlines);
-
 	handle->file_state = TRACECMD_FILE_CMD_LINES;
-
-	return 0;
+	ret = 0;
+out:
+	free(cmdlines);
+	return ret;
 }
 
 static void extract_trace_clock(struct tracecmd_input *handle, char *line)
-- 
2.31.1

