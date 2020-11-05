Return-Path: <SRS0=ZY51=EL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE37C00A89
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 09:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2AE620825
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 09:34:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jng7xet6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbgKEJeE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 04:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730933AbgKEJeE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 04:34:04 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002A9C0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Nov 2020 01:34:03 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id q3so527290edr.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Nov 2020 01:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZCaXfC9bAFsWhp/F+Cok4+r6l6pigKOO6lV5zVTECOc=;
        b=jng7xet6bWh6Y+bFJkjDgGoIWPpZEtRPqgSOE+4tQXcvpcQL6oB7PO85SyKoDqpaV2
         CpL3njNvJFSCalXOUC0njnIvPeCmv2lz2flIfVaCbT1m6pjZopCIQCcCmyusoboyvlkx
         rTv6RSQDG4xFmiC8RDPHibB+YJy/I94iDQGGhlONpAQ0dWvGZsygMH7bGU+peXjVE6BL
         mAOpdzscM/TprqdMapJOTkEF4/gq2eO1QUYkYBCwI+0yI34gWHNNnTENWoEye9REV6Uj
         kkS75Eag+tpFpClTYNFkEtO/dqphUDFbJgUojRg51q9ZfEd0N/rH5eXAo9fO7DV/nNHl
         b6uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZCaXfC9bAFsWhp/F+Cok4+r6l6pigKOO6lV5zVTECOc=;
        b=XvgyxhTX9rhnLoVkmZBcP1VNukl/Z0xQbBNcb1Bn0nrmqwVs76Im/pUDNdfkUEr0Yt
         YuVPhKUg+5RV236NolCt9KSSuJxRKKif/bWt0bDEkMI6XmiYgzGMDjXCW44Neyvq4tAu
         23g9jPkKGzn4IVwDGI4JoyYc1ab9h7rd/tsFsLpKICykQr3SvrdIWZD5tSMSLWNhEo9/
         2I134bzpGF0E2O1NL859tU+CT2uywbg5tNzvJVapkRhvPbmMyr353zk5y8VnKeuLF4iW
         1Zyrjf8FXpMT/1sBLlDMMD6loG9Kfy92eZOEgGllxJ1zOq/H80V/LxTqEsgD/40kojxt
         mPag==
X-Gm-Message-State: AOAM531CcTzrf8QJtu8WnBlugqORpKBGPa0WpzyzJLPIKd+q49hR1ck6
        DRCyDTPIjyBmP5brJuMlh6k=
X-Google-Smtp-Source: ABdhPJzas748hp51V3//mc3/hoblbwNboSCUYKyXBPrMFl9UvSFgiCSf0XcHb0VICdLE0+v61qcRFQ==
X-Received: by 2002:a50:eb45:: with SMTP id z5mr1622078edp.144.1604568842779;
        Thu, 05 Nov 2020 01:34:02 -0800 (PST)
Received: from localhost.localdomain ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 1sm586725ejt.107.2020.11.05.01.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 01:34:02 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/6] libtracefs: Add new API to check if instance exists
Date:   Thu,  5 Nov 2020 11:33:51 +0200
Message-Id: <20201105093354.532742-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201105093354.532742-1-tz.stoyanov@gmail.com>
References: <20201105093354.532742-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new API is implemented:
 tracefs_instance_exists()
which can be used to check if ftrace instance with given name exists in
the system.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs/tracefs.h      |  1 +
 lib/tracefs/tracefs-instance.c | 22 +++++++++++++++++++++-
 utest/tracefs-utest.c          |  2 ++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index 8d193853..e5bf3df4 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -33,6 +33,7 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
 char *tracefs_instance_file_read(struct tracefs_instance *instance,
 				 char *file, int *psize);
 
+bool tracefs_instance_exists(const char *name);
 bool tracefs_file_exists(struct tracefs_instance *instance, char *name);
 bool tracefs_dir_exists(struct tracefs_instance *instance, char *name);
 
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index e9ec3401..c19dd3b4 100644
--- a/lib/tracefs/tracefs-instance.c
+++ b/lib/tracefs/tracefs-instance.c
@@ -257,7 +257,10 @@ static bool check_file_exists(struct tracefs_instance *instance,
 	int ret;
 
 	path = tracefs_instance_get_dir(instance);
-	snprintf(file, PATH_MAX, "%s/%s", path, name);
+	if (name)
+		snprintf(file, PATH_MAX, "%s/%s", path, name);
+	else
+		snprintf(file, PATH_MAX, "%s", path);
 	tracefs_put_tracing_file(path);
 	ret = stat(file, &st);
 	if (ret < 0)
@@ -266,6 +269,23 @@ static bool check_file_exists(struct tracefs_instance *instance,
 	return !dir == !S_ISDIR(st.st_mode);
 }
 
+/**
+ * tracefs_instance_exists - Check an instance with given name exists
+ * @name: name of the instance
+ *
+ * Returns true if the instance exists, false otherwise
+ *
+ */
+bool tracefs_instance_exists(const char *name)
+{
+	char file[PATH_MAX];
+
+	if (!name)
+		return false;
+	snprintf(file, PATH_MAX, "instances/%s", name);
+	return check_file_exists(NULL, file, true);
+}
+
 /**
  * tracefs_file_exists - Check if a file with given name exists in given instance
  * @instance: ftrace instance, can be NULL for the top instance
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 31a700ff..292bcab0 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -197,6 +197,7 @@ static void test_instance_file(void)
 	CU_TEST(asprintf(&inst_dir, "%s/instances/%s", tdir, name) > 0);
 	CU_TEST(stat(inst_dir, &st) != 0);
 
+	CU_TEST(tracefs_instance_exists(name) == false);
 	instance = tracefs_instance_alloc(name);
 	CU_TEST(instance != NULL);
 	CU_TEST(stat(inst_dir, &st) != 0);
@@ -205,6 +206,7 @@ static void test_instance_file(void)
 	CU_TEST(strcmp(inst_name, name) == 0);
 
 	CU_TEST(tracefs_instance_create(instance) == 0);
+	CU_TEST(tracefs_instance_exists(name) == true);
 	CU_TEST(stat(inst_dir, &st) == 0);
 	CU_TEST(S_ISDIR(st.st_mode));
 
-- 
2.28.0

