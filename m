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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97727C63798
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 07:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3294924655
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 07:46:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="URVIK9mi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgKQHqG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 02:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgKQHqF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 02:46:05 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE91C0617A6
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:46:05 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id c17so22104218wrc.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dFNyqLDNyi5pBsrCf75JFu1EQCx1dd+DrmyYj+UD1p4=;
        b=URVIK9mifzhzFKe/SPzZRtnNdfJCoTJEOfGiyEjvrLyTVeJK16K4Hga1/zbmJWS8T+
         hyI7+k0H7Swv2burqqaboZFsuEKgK0UfKWL9p54N1j/CYkM/qvthkn4DelA9HUznyTmc
         1V7G69NcTUAiYybWAKoFh5JmIEoJ4vmncQnLvbQ4oEvAvjdH5Kzhv0gzLAXDTBYCDi/2
         14VS0seBS8aMq9QVvR5zKi6ygPglPy/dJ+Kez9cJ/jESRagErZAI1vJ1UN8b+I+8HgYS
         7dkT+ysDDAISIrlVCqLK3HkOOTMsnCrBr4c+8/5NibiY7FW9Xo43rW3SNmE01rrAW0In
         sdVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dFNyqLDNyi5pBsrCf75JFu1EQCx1dd+DrmyYj+UD1p4=;
        b=oCWfkTmS1fhlIbMXRpVvx5EjzGmPVHto4I2q24wAeYw6FlFA1eLB0TGNbUFnRmU4aV
         ISQx1Ot+B9TCV4zdR1UwIXU5de1AgtRr9rX8GwP8yndBk+fEkuxPMJMG9CkBAgRuq/EH
         hTP1CMssidu0AJSNR5WUiMk3v1I6+3q1+njIcVYyG3yaev8ITR/KUiLxUKjWqEbLpko/
         EoM41bsexg53P5j4foJk5WQQvXYmylh/RH1OSMdvpD04rDmAHS1oQQ7hbUEr+BENEls0
         ERXYvqAjkdcx/dK1pFLpKVFoDY4uKyNo9CLeExV+DNNX6sOGJW6xk/W5uSRM0HsBTiQG
         1jJQ==
X-Gm-Message-State: AOAM53140MD0XdPlIG9RtMR3Vu7GSnaj+mN+SLCnqsKlMCjfx2fNEEdW
        Q5AVPwnbWqjfvVDmXawMSok=
X-Google-Smtp-Source: ABdhPJxG5/eLwYiKjrMi6ntErYwH+GrE/yZDbltXwpHIxdJfnMRSW2LiQlbnHJLDtOPoSDlRpGiQbA==
X-Received: by 2002:adf:fcc8:: with SMTP id f8mr23571483wrs.331.1605599164247;
        Mon, 16 Nov 2020 23:46:04 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d3sm25752046wre.91.2020.11.16.23.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 23:46:03 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 4/8] libtracefs: Add new API to check if instance exists
Date:   Tue, 17 Nov 2020 09:45:53 +0200
Message-Id: <20201117074557.180602-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117074557.180602-1-tz.stoyanov@gmail.com>
References: <20201117074557.180602-1-tz.stoyanov@gmail.com>
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

