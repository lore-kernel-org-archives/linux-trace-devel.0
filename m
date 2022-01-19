Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC17C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352410AbiASIZg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352406AbiASIZf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:35 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD627C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:34 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id b13so7811652edn.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MrWAMP2oQHHiOnTleQUOJe78e7qQgzHgXpbKW6Vk8cU=;
        b=AVLbp8OMAQj/8ROn0q1KvJeZBMCJ1iBzkWfTOaC80/9uBKL1j4diaD3Mchws5HecIn
         VAreJSvNlLwVuApZw1I6wQoBC4GL0YMO2qOa4Kfmr3zxmxFWmVVCDwQft+0bwuEYDxZR
         DV/0bX3loqKOLipMyTlk1Nl+kPVIUrg1E9tgyPLn5/qxzqQxgGg6wwdeuBu5xs2iw2uz
         hZPrx4Tx6t3QXmyArgG+BgTMzGLu/h9/J4y8g5CBOW8+lki9hK+XbcYFQ1jC5sRWcPlU
         N9HQEG6g2f5OdOv+mKMr0zLX6xGynPXYIWkvkc9w1ZYLchsSqO/TPIGx99sllqBxragZ
         zSjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MrWAMP2oQHHiOnTleQUOJe78e7qQgzHgXpbKW6Vk8cU=;
        b=LyX618sX9f3ypZIngIBu/c5B7yt0sD7H2aoPvDAC9SIPzr2v2Hn/8bENNj1J1uo1jJ
         m0/uDQhjCYu176x+rYpjrYDNpV4fpP4jT+g16XbULZM/d8BmHLkqKpRxRRcy2TPkTdJ4
         d+reAsQAW1/uF7ANKNJfmd6DD4v9s1hignXjfknXgUq4xF5yAH5mcmeDGwoyGLLQ2T3U
         25uv4P5+xlGUt5z4dfA8D0/Io3cACn57VFmkEwKea4ev63jvxteVbPfszbwackCVB/Rq
         bwqZFOsHvqprZ1Sb/ZmQg+CM+v9HqGjoE27AFML6QHLtvFNglzJJNbFF6jr8qPbKXPW+
         BZQg==
X-Gm-Message-State: AOAM531pafO0gtSxDrldyEZXVW5xtxgeYlQP4b4G9FptTYPhmyfc8k9d
        wBie6bNVa6wGw4R7zD/jWEjheJTLepo=
X-Google-Smtp-Source: ABdhPJwR6a6Rdsur0LRRKAJZuSF75eZsgN59zurOk6w+1/Zoy1/yfU75l0kWwVgsQPBGcfFlDAo28w==
X-Received: by 2002:a17:906:3103:: with SMTP id 3mr21271527ejx.289.1642580733465;
        Wed, 19 Jan 2022 00:25:33 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:33 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 23/25] trace-cmd report: Use the new latency API to read data
Date:   Wed, 19 Jan 2022 10:25:05 +0200
Message-Id: <20220119082507.245600-24-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading latency trace data, use the new API
 tracecmd_latency_data_read()
It handles reading latency trace data from both version 6 and 7 trace
files.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 4b27740a..24177c44 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -951,18 +951,20 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 	printf("\n");
 }
 
-static void read_rest(void)
+static void read_latency(struct tracecmd_input *handle)
 {
-	char buf[BUFSIZ + 1];
+	char *buf = NULL;
+	size_t size = 0;
 	int r;
 
 	do {
-		r = read(input_fd, buf, BUFSIZ);
-		if (r > 0) {
-			buf[r] = 0;
-			printf("%s", buf);
-		}
+		r = tracecmd_latency_data_read(handle, &buf, &size);
+		if (r > 0)
+			printf("%.*s", r, buf);
 	} while (r > 0);
+
+	printf("\n");
+	free(buf);
 }
 
 static int
@@ -1246,7 +1248,7 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		if (ret > 0) {
 			if (multi_inputs)
 				die("latency traces do not work with multiple inputs");
-			read_rest();
+			read_latency(handles->handle);
 			return;
 		}
 
-- 
2.34.1

