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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9CBC4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3272B61053
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhG2FKr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbhG2FKq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:46 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1423BC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:44 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id h8so6415330ede.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c3OjbWftgycABFbfOFENpRXx6bmt4MF8AsP7gDBMwBU=;
        b=bqreP39q7pjSt1Ighothur/1O8nffMhQu6u/dlEe9aniUFOJIJ7tgiMATGV/AD7tU8
         6RdQ6bTebalk0JoVQ0sRJbxa/8RQisy9Pw0qYZh5Jq9gCiUi80IZKogMVCNGF/8DAhCP
         Va8bx59TjD1QykUyz1+y1MIeXUPmc9X56b8OTt1jzQW87cn50CXq6eH7vCRabVlIyyhZ
         kFlpKSdfgnJ9jDP51rbZZNeM+byisaSB6Katamp7XEuQ+nHbb/OjXMIF2gFoRRslvIkF
         IGbHJ0VOyYjEBTk0uW7TKjDhxRDWeX6mMOLnCGlXG+N6oRzlrMsxzQcKTHH0xJR6vyy8
         9o/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c3OjbWftgycABFbfOFENpRXx6bmt4MF8AsP7gDBMwBU=;
        b=ujxv0z3Radl6zj6pCmnE4K4x44FN1H4dD5ouTrbrieA3WlfrrehNd/Dwwq0zjlPboz
         PoMEUVmALbR5qxq9RZehx5xqfXrSNLZfY1QGyc5B0TLSTMNaJBoFi2jVUk+r/7wvZJR0
         WaPZTeN0CUDS8A1dM04Hu1vrxocZZq0aRrYFgvr95kqGyfe+vaQh3bW90Tv+Dak5GSzC
         fvn/bZ+gTfR1auKtS1P2HmNQ89YMe+G0MlL0zfCaVYIjWm1EUJrlEG5X+krRW0sfXFTR
         C7ubj5p2DpB3u3oT9DUs8Lm/yY9oxWsvwZomHPP1l6gstkhKTB97X6V+Mg8fAnF9zkSf
         /xJw==
X-Gm-Message-State: AOAM5301Vuf2urf7gsJulYhiw4OucBKRH6nCzkPt/+qyOw4bPtvGZPfU
        jfJAGsBeLsAgIxzjOHIfH18=
X-Google-Smtp-Source: ABdhPJxUgSDiWgpqqf0lj2vqwDbtJu47PXNTp/dYtdvGtNgqbaMQnNQ90Y6tpVpP8m9kTNrK6KWC+w==
X-Received: by 2002:a05:6402:10d7:: with SMTP id p23mr3975818edu.74.1627535442752;
        Wed, 28 Jul 2021 22:10:42 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:42 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 42/87] trace-cmd library: Fix possible memory leak in read_and_parse_cmdlines()
Date:   Thu, 29 Jul 2021 08:09:14 +0300
Message-Id: <20210729050959.12263-43-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
index 5557e772..4324259a 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3122,7 +3122,8 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = handle->pevent;
 	unsigned long long size;
-	char *cmdlines;
+	char *cmdlines = NULL;
+	int ret;
 
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CMD_LINES))
 		return 0;
@@ -3131,15 +3132,20 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 		add_section(handle, TRACECMD_OPTION_CMDLINES, 0, 0,
 			    lseek64(handle->fd, 0, SEEK_CUR));
 
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

