Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B103C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239447AbhLJK6r (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232982AbhLJK6r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:47 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F46C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:12 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id e3so29035609edu.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p6n5UGo8cvzQJMCUxMqNNP1ASY8Aus1iY0wR9rHoRm0=;
        b=XDohHr/suMZsXqvn9diaQGgNJCFNj08hONwy8b8JFVAodP6aZgCq5YnD4usZxsNRtF
         8okFu6PZd8IxrUUhJXaCcLI0gZOf5d7edPZclO5pB68hwGpJnMuwhyz7W1QJAfkpbI4I
         q4M231ZRUj5CHwods8mZyTnc8d0X4g52qPrbRUuYFuI0gI/ZUFagQkycmudzXPjgiFV2
         LH+g8p1HNrQp9evArs/S5Q3+F9LechsRhuwLMwI2dSNruPRb74HQxTrm+GYTxHAZv4qT
         mRHDHtxxypc0U8Htka7syyMEmja/LDEW5T46krUOeIj+1YTdOFCY/6ySXNUR9GIzG7Q5
         G3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p6n5UGo8cvzQJMCUxMqNNP1ASY8Aus1iY0wR9rHoRm0=;
        b=eDgCg/kR6Z09aWjo3+BnVgN7PMqSfRTzbDTs0AbRJI1QVlwqC1J8WpRRw9XsKRVfEK
         +gQjCm2UHhC5M9iIDah7qxQR1OY04wFs2Atniurfc4dxCBwTKDqtzNyV5nQz05rq6rGl
         NuN8Hy5bD4HFqJAa1SmGJAO7WrYRO9fTx+8AgzlB/8mT9O+mqBOiA75EhVlHVNyGEI/n
         QAmAisLRcY1nT16R21SHcH648rTnm6vI5zOKundEjeVNY8MnxHBhvQLHaob6qlWrwd91
         Q96h6mERCsXwkD/uk5yz5G9iNFeNss812Bxb1ZF4Ucp6Sa+uEdv5MSXkrAjkRsfcyUP0
         An5g==
X-Gm-Message-State: AOAM530Yhvk7OYNaXvkcezWBIvjcrhTk53Hm/665zB/JG9cG23AmlTjb
        rlDmQIPOxIB+HtiWrDEnQ0ZwgatqS1U=
X-Google-Smtp-Source: ABdhPJzCs2lPmuvH8gyqP1yIbFUQpUCmBkvd65XgIq+MaLPOMb3cxSAxnJqtTGSBtJaPftFjCJhZ3Q==
X-Received: by 2002:a17:907:6ea1:: with SMTP id sh33mr23601429ejc.150.1639133710922;
        Fri, 10 Dec 2021 02:55:10 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:55:10 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 23/25] trace-cmd report: Use the new latency API to read data
Date:   Fri, 10 Dec 2021 12:54:46 +0200
Message-Id: <20211210105448.97850-24-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
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
2.33.1

