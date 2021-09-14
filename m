Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 662C6C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ED97610E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbhINNQ2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbhINNQ2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:16:28 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC9AC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:15:11 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id g16so20192732wrb.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3tPykFm2R2AzWLPxwlstSRNlrsQRpaeRcBxHgbq+Eck=;
        b=RctipOVnAUP+9V7fYfAOBcUeLNiynBoIllWnwF6lsB+jAMjdYHAIabx0fqS7fNCjnx
         omR/47z1WE4H/2Pv0dy701THvdqNOkPDo0lbFfsgGtZRVRdmIR2jFOjPW7TCpddI1D8u
         wVkbQ7TlL2qL7vd4gIcI6akdyqf7BJgciuJt0jBL5ZsYsaH+gYtMKGebYkoVT2/5S+/v
         6jMamebR4T2jNnEKycYca45aKWgeXmQrr1CcRL+ZI0lbllBvhPkAwKE0wJidvwOPwJng
         OopxaiT8lsOERaTU4iVeFnhCZo4eJs8S5hsCw0U+EZsIiWMsdv+zkGFAuRKNSFJlOvA+
         Z2Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3tPykFm2R2AzWLPxwlstSRNlrsQRpaeRcBxHgbq+Eck=;
        b=GZXMxM8buXtb4KGbdz4ZDYNry+xSKNhZpeelJYBvC1LrGy8eFKW2vozaiVwPHGAUkE
         EBlMxNN1JavG06lu7/NXz9B8uG9UUgLoDOwAkRnM9TmiBRsCCu34gfSe9fgFucOyDZyA
         8Mhx0mlDxVpg7zjkFATYGH6I49/7x1hJGQTS67KIX8FHdR4m7C61jw0QZO6Qwa+iDJ1h
         IjwI4hEtA9vGISg637+jflHSEuOMjBrSqhYKiGurm/rJx7G5Ay9sxef+lAT1E675JNAq
         fiEts/KgcdYRhW/gwq04LgiHvZl22A6u8mXIET9pbIkNf9jLnmt4ZwTrHx1mJGnAbiIK
         92jw==
X-Gm-Message-State: AOAM5325L2C78IMAi26tiYWQlSkFPErfTQDjvsxd14hAq9nmSp9hWxLB
        qZ4bfG5l3ADNybhWezNyzkxc9N2G8SU=
X-Google-Smtp-Source: ABdhPJyEmANJqVxuxvOiu5jEfbvT7HO8qzBK2dxrghBzIRI2VsscA+wf1E+vrlIYeKWttD2TrPu0hg==
X-Received: by 2002:adf:d1b2:: with SMTP id w18mr19406251wrc.6.1631625309586;
        Tue, 14 Sep 2021 06:15:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y9sm1274760wmj.36.2021.09.14.06.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:15:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 23/25] trace-cmd report: Use the new latency API to read data
Date:   Tue, 14 Sep 2021 16:14:36 +0300
Message-Id: <20210914131438.3965484-24-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
References: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
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
index f7ffb89e..cafceffe 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -948,18 +948,20 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
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
@@ -1243,7 +1245,7 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		if (ret > 0) {
 			if (multi_inputs)
 				die("latency traces do not work with multiple inputs");
-			read_rest();
+			read_latency(handles->handle);
 			return;
 		}
 
-- 
2.31.1

