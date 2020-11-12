Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 966F6C55ABD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 09:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40CD0216FD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 09:11:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ubQHMLFA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgKLJLS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 04:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgKLJLQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 04:11:16 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017FBC0613D4
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 01:11:16 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id p22so4573828wmg.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 01:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dFNyqLDNyi5pBsrCf75JFu1EQCx1dd+DrmyYj+UD1p4=;
        b=ubQHMLFAMyHrXCEjNAa9ARfhX+t9Mf5z0mOXrwfaXEsLQ+DsW041jfTpY3zF7BSGFJ
         rF7x0gG6zdlAx+MW1DHyI/51aau5hBTGH75G2NR3Pf7cNig4l9Zfl+p+ioAwcYTLpXOZ
         bJJQlpmmXbkUGKHs43v0tj/mXXleHOx2vsyWi3xtmBMKjIol7VYG7L6mEZyRTsATCEwN
         D7BLePld1sZSYM31L2hB6s7/iLu0NOCyl+HGVUP9XZ6uISU5/TaNwC6tGVh7IyWkMEgl
         L6yQjSa6lY+ko4cIfILEM9dmtMj+z2O1QoH6ht/XnWSUPi77eCLdEVceKeNNGHebX5js
         wISw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dFNyqLDNyi5pBsrCf75JFu1EQCx1dd+DrmyYj+UD1p4=;
        b=agaxvB8V1ksovpVd9T64z85NdpALoj6B2pLdvnXMFgpLQvfeY14KWWUSIJSvfuIWsj
         zpCnaJ+amyP7wCKSVCaS8fHBndQ/eWtbbBGkNH7GFWxPC1nib9psvzzWHvH4GnYp6kcc
         N7VNuWtA7+jluXr5EhJlzg3Altdpce8CPxBpVLM81Yg046UaWGvC37QE09PNqByI88fc
         js9Gcklsq8SC0qGBpallZ3PDBq+cKskad1IyHjNrsEVPGIbGtGbk1qpZU1cTeHl1QfKl
         DAf0ZPkZqDzAZRRt0E3CETqL70dO6tVznln59ZXqeiqyk97yDCV9ugqP5sZMRFCoAziT
         PRDQ==
X-Gm-Message-State: AOAM531plp8DzFdMxLOr4bxP5eKhCl5Rc6ohzbabMJ5RgSWgcTunUsRH
        st1kQ5usS28xzuzExReeNB8=
X-Google-Smtp-Source: ABdhPJw0wbMrupFl9gbg1amiYAHrBochzfCUpu8yrkFkOAOUQofSXl6Ep4CljDjPWI1iDyKJDKYxYQ==
X-Received: by 2002:a1c:35c7:: with SMTP id c190mr8147146wma.7.1605172274796;
        Thu, 12 Nov 2020 01:11:14 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r18sm6705718wrj.50.2020.11.12.01.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 01:11:14 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 3/6] libtracefs: Add new API to check if instance exists
Date:   Thu, 12 Nov 2020 11:11:06 +0200
Message-Id: <20201112091109.1239169-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201112091109.1239169-1-tz.stoyanov@gmail.com>
References: <20201112091109.1239169-1-tz.stoyanov@gmail.com>
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
index 1cf8de48..ef806d3c 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -33,6 +33,7 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
 char *tracefs_instance_file_read(struct tracefs_instance *instance,
 				 char *file, int *psize);
 
+bool tracefs_instance_exists(const char *name);
 bool tracefs_file_exists(struct tracefs_instance *instance, char *name);
 bool tracefs_dir_exists(struct tracefs_instance *instance, char *name);
 
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index e37d93d1..06f33c35 100644
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
index b5296963..2febdb88 100644
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

