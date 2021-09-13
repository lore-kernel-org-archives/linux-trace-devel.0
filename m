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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB0DC4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2D5B60555
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239946AbhIMM3g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240006AbhIMM3f (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:35 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1070C061760
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:19 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id u15so8358031wru.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vFXaQI/G0HHdHdRSAHOmVE4YjkrR1Z9WT14pKr2Ncd0=;
        b=CTKCTJFiBM4XtajodQtQLZFImECHmaXCT6yZPsF/Wo8Z/oJdfAbWE+re3ZUt2iZI1d
         CQacv/0HKJWJVI0Ojz/7AALDNtkXi+h27lgcIkycj8BNDKFUK+65d3zvJkTDCXNjqAdA
         gztMG955AZoZ9AiAoyywuEGQzXmw2NVyyVUXT8kcBB1oPt2REa0z4f94u4JnLt+seqeH
         rqO6Tktwbxilwpo+0RtLj/4V5OcmPc2GZpPP8zR8zrtmPwYXKnfLte1wNmVMih9yBfVq
         c5NTq6LCY7oGCVLC3pUh7KB+kdz0zfH7JcPOO97R925xYcyfdj5b54mVDcP0xseEUUym
         IDfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vFXaQI/G0HHdHdRSAHOmVE4YjkrR1Z9WT14pKr2Ncd0=;
        b=JiR44daP1EWj6JqfYPL5CyXlWIR1eC2jwgDB3yuAvYTOPrdMMffKBkhzSIyCeVrPlG
         cwF2QPVBhcZYdLzWv4Qk7NZVhhi2TtvY5iO6ZKq7SnhmqvxzMHtcHzC1/uTIp/FVPr4O
         T+tDrVvKJytoQ8tz/DSrLHu5GuX4a0tRhkxHdwE7VBmev+xwraentL22mZWq7aPmaECE
         UTdfKhdKGMZHvEkefMe+QdbHcVZazzf2R6aZaBJuFbL17RtV1AWlPMI6jACuRhM0H/dD
         HV1dGg8d60PRJRRAVPrNGF1WXMKG7gurFex1qu8w3NyX63Tvrq8j7M4NyzsSdX5Wcysk
         aSow==
X-Gm-Message-State: AOAM5319AvPqTRg9puJH4/TwjoJS3xblB3TGrk8cDVHumUWm3vSIwLdW
        6ipIY7Q+tE9cHRvlbccKgMw=
X-Google-Smtp-Source: ABdhPJzqxqyRx+73yYSq6MvfbH2EP3rkkbBBXNpii/aOXjW6Y5SczDojY61r3LE4i4bj+uFCxijA5g==
X-Received: by 2002:a5d:58c9:: with SMTP id o9mr12466951wrf.279.1631536098277;
        Mon, 13 Sep 2021 05:28:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 17/21] trace-cmd report: Do not print empty buffer name
Date:   Mon, 13 Sep 2021 15:27:55 +0300
Message-Id: <20210913122759.3672494-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This clean up is needed for the design of the next version of the trace
file, where the top buffer is saved with its empty file name, string "".

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 4261088d..02f75cb9 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1173,7 +1173,7 @@ static void print_handle_file(struct handle_list *handles)
 	/* Only print file names if more than one file is read */
 	if (!multi_inputs && !instances)
 		return;
-	if (handles->file)
+	if (handles->file && *handles->file != '\0')
 		printf("%*s: ", max_file_size, handles->file);
 	else
 		printf("%*s  ", max_file_size, "");
-- 
2.31.1

