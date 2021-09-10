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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6536C43217
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 16:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D064E611CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 16:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhIJQkX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 12:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhIJQkU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 12:40:20 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841CEC061764
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 09:39:09 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id dc3so5416330ejb.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 09:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XmA317lK1vX1gIDGP8ql5chCEV7TO4+vs27Aepi/bQ0=;
        b=JQuPPn+AeTz0IgkdBkAwv3egTw3+ctd/UV4nOXoR3S6yb4LJNzJ8/DUNc+IMClzAwb
         6Y3+C5ol1Zh1LFusZohq9QMKNM70utmPWfTeoWlnshl2MJ2Uxj1LI7fPa6B3My+FVJlw
         vDYp9kkF+8Di4EArZQ887UfWBanpi+b3vjqMDrOEkGXuSf/7JwZfoUG98Cmt2zVAHco+
         b/vLJCqnGmnh8z9MeFOJ1qn31rJIwUzMqClFmnw2rz6cxfNTJet6t1/nPes0NZOz+Oh7
         c115hcwPSfsAi15x8Qux2OsEcbIC6X62pmmsjxAqW3xuZMudAaOlB6WMTSxORVdV4ntW
         tdsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XmA317lK1vX1gIDGP8ql5chCEV7TO4+vs27Aepi/bQ0=;
        b=4OljLJpS4ReN4VKG2GBPFyBoU4yfUgaAze0a7Iq/lGHpMD8KvIGiNGqLCdXgtapKhA
         zFa5Y5NZa9AD9tV+N6XvDjMUHJacsY0Us8Jo5nmBRTGzdBk2J/Lf4LIfA9L3X4roCDDG
         AWgXgG1rphkabn9GcRjnvLBht8aXhNMHuiYOJmndclNUIeKg9meLPbywRkWMNiQe+RoZ
         8TgHyAnIefZ8inUgw80gPVGreApuvIamRAaMCmgdMSwG19iBjTpWJ0f/2WesGDbSLfkm
         IMaNWR6yq+d+wRNAV8rX0YhOc5htviPeqzgV5Xx1xXsHHYBn8bntBs5mUsYqwElBJ0cR
         NxPQ==
X-Gm-Message-State: AOAM530PeY7YK9gbD6YOTjZyIgV+O83zodjhn6B9r5v8RQhBk4mPmtTW
        wPtoxDxSGZlm+0yACegqGUKC69nZedE=
X-Google-Smtp-Source: ABdhPJyMhMEeq7LGNDvg4l8omZyU29Aw+gvhcLlb4DCFUuN+NRocFzm+SgoeAqsdlLgaEXfwSjz7vQ==
X-Received: by 2002:a17:907:98ce:: with SMTP id kd14mr10452363ejc.440.1631291948034;
        Fri, 10 Sep 2021 09:39:08 -0700 (PDT)
Received: from crow.. ([95.87.199.93])
        by smtp.gmail.com with ESMTPSA id g9sm3095290edk.54.2021.09.10.09.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 09:39:07 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC PATCH 2/4] libtracefs: Transform tracefs_hist_add_sort_key()
Date:   Fri, 10 Sep 2021 19:38:55 +0300
Message-Id: <20210910163857.324696-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910163857.324696-1-y.karadz@gmail.com>
References: <20210910163857.324696-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The current version of the API makes it hard to add multiple sort keys
to a histogram. The only way to do this is to use the variadic arguments,
however in order to do this the caller have to know the number of sort
keys at compile time, because the method overwrite all previously added
keys. The problem is addressed by splitting tracefs_hist_add_sort_key()
into two methods - one that overwrite and one that does not.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h  |  4 +++-
 src/tracefs-hist.c | 21 +++++++++++++++++++--
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 64fbb3f..c3fa1d6 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -303,7 +303,9 @@ int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
 			 enum tracefs_hist_key_type type);
 int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
 int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
-			      const char *sort_key, ...);
+			      char *sort_key);
+int tracefs_hist_sort_key(struct tracefs_hist *hist,
+			  const char *sort_key, ...);
 int tracefs_hist_sort_key_direction(struct tracefs_hist *hist,
 				    const char *sort_key,
 				    enum tracefs_hist_sort_direction dir);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 8501d64..2ea90d9 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -453,6 +453,23 @@ add_sort_key(struct tracefs_hist *hist, const char *sort_key, char **list)
 	return tracefs_list_add(list, sort_key);
 }
 
+int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
+			      char *sort_key)
+{
+	char **list = hist->sort;
+
+	if (!hist || !sort_key)
+		return -1;
+
+	list = add_sort_key(hist, sort_key, hist->sort);
+	if (!list)
+		return -1;
+
+	hist->sort = list;
+
+	return 0;
+}
+
 /**
  * tracefs_hist_add_sort_key - add a key for sorting the histogram
  * @hist: The histogram to add the sort key to
@@ -464,8 +481,8 @@ add_sort_key(struct tracefs_hist *hist, const char *sort_key, char **list)
  *
  * Returns 0 on success, -1 on error.
  */
-int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
-			      const char *sort_key, ...)
+int tracefs_hist_sort_key(struct tracefs_hist *hist,
+			  const char *sort_key, ...)
 {
 	char **list = NULL;
 	char **tmp;
-- 
2.30.2

