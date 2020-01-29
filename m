Return-Path: <SRS0=ilnn=3S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B2DC35240
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9DD320720
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b3nQzOeb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgA2Jyd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 04:54:33 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46077 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgA2Jyd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 04:54:33 -0500
Received: by mail-lf1-f66.google.com with SMTP id 203so11408082lfa.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 29 Jan 2020 01:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uts4suM7LY1xI8V7E+dXpEnUTc66uIwgsYyNjau4Mto=;
        b=b3nQzOebmZQzdXagslkpK2/4auxGuyQ1k0jMh+dEpB/M4snv6mIXXxwLJUkrin7399
         YT8sJ2ZhvHEBIizMKP26lG9r2pg7FCaveC5GRvUWcPaouegGihWHgklt7vydMtnSdTaZ
         jFZK2pREjxSSpxw9WVXMMt/JAtcRasejvYiOe2RN68rZBWnTT94vs9GhCvd03ieBnYZd
         AlqPH0yPGCy0uTOAgysbhQtAuRkbl+KRO673gEgRieBCqDE5fuTDvbFo4D+gfEcg5Rgt
         xgqLf6bXsIyeF3A00903ac2V0/VRZchyJlNnsCIu1emYtYBi8RkUouMYTmj6tCT0dXPZ
         QYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uts4suM7LY1xI8V7E+dXpEnUTc66uIwgsYyNjau4Mto=;
        b=Qvx0f4AOGMW2MVvQzUfF1GZtr+I2zh5SD1QcvSixOlM1aaqG0SyiAu3t36ikB9pQ/q
         Dl+vevVsU554COW8vfPUfq/crRoBwj0MKWooC3kj6lsSdpm1qno74fD++FO5CcRbbln7
         YU59dA/dG2OFp+jjW7rmphDOP7UjDQPq8bbhMvAtqF3G0IovxJ4mlTTkeVJH/mBLwta4
         4JEbhneFPSKpYIsgqt34aUl9nkwOHoOrTGuXQu2Uw0JHEEd9AYty9uPE9gjvO0cBKM0k
         FhRfnOe9zU6X6eVoS0fbBrGrREHAzdaM32peGZnoKY/J2rzoSloTvY4Wj3iH8imxrMaO
         lhgA==
X-Gm-Message-State: APjAAAWwQKXQrVqCIs90dKdkWG8+dxk5VAtB7sz6dTCJIoDNDNQzSatR
        W+xTs4Oj1r/YZMC/Pg6I1l0=
X-Google-Smtp-Source: APXvYqyeinPVqQcGEq8zcXKjrzkKucnKRXeFWoVPSQcWtOzvFUwj4NSfT4E7HN+XgFOfaGR5U0NetA==
X-Received: by 2002:a19:4849:: with SMTP id v70mr5232732lfa.30.1580291671506;
        Wed, 29 Jan 2020 01:54:31 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q10sm648584ljj.60.2020.01.29.01.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 01:54:30 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 7/9] trace-cmd: Unit tests for libtracefs APIs related to ftrace events and systems
Date:   Wed, 29 Jan 2020 11:54:19 +0200
Message-Id: <20200129095421.881786-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129095421.881786-1-tz.stoyanov@gmail.com>
References: <20200129095421.881786-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added unit tests for these APIs:
  tracefs_event_systems()
  tracefs_system_events()
  tracefs_list_free()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 66 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 7930c64..e4ab64f 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -9,6 +9,7 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <time.h>
+#include <dirent.h>
 
 #include <CUnit/CUnit.h>
 #include <CUnit/Basic.h>
@@ -258,6 +259,69 @@ static void test_instance_file(void)
 	free(inst_dir);
 }
 
+static void exclude_string(char **strings, char *name)
+{
+	int i;
+
+	for (i = 0; strings[i]; i++) {
+		if (strcmp(strings[i], name) == 0) {
+			free(strings[i]);
+			strings[i] = strdup("/");
+			return;
+		}
+	}
+}
+
+static void test_check_files(const char *fdir, char **files)
+{
+	struct dirent *dent;
+	DIR *dir;
+	int i;
+
+	dir = opendir(fdir);
+	CU_TEST(dir != NULL);
+
+	while ((dent = readdir(dir)))
+		exclude_string(files, dent->d_name);
+
+	closedir(dir);
+
+	for (i = 0; files[i]; i++)
+		CU_TEST(files[i][0] == '/');
+}
+
+static void test_system_event(void)
+{
+	const char *tdir;
+	char **systems;
+	char **events;
+	char *sdir = NULL;
+
+	tdir  = tracefs_get_tracing_dir();
+	CU_TEST(tdir != NULL);
+
+	systems = tracefs_event_systems(tdir);
+	CU_TEST(systems != NULL);
+
+	events = tracefs_system_events(tdir, systems[0]);
+	CU_TEST(events != NULL);
+
+	asprintf(&sdir, "%s/events/%s", tdir, systems[0]);
+	CU_TEST(sdir != NULL);
+	test_check_files(sdir, events);
+	free(sdir);
+	sdir = NULL;
+
+	asprintf(&sdir, "%s/events", tdir);
+	CU_TEST(sdir != NULL);
+	test_check_files(sdir, systems);
+
+	tracefs_list_free(systems);
+	tracefs_list_free(events);
+
+	free(sdir);
+}
+
 static int test_suite_destroy(void)
 {
 	tracefs_instance_destroy(test_instance);
@@ -297,6 +361,8 @@ void test_tracefs_lib(void)
 		    test_trace_file);
 	CU_add_test(suite, "instance file / directory APIs",
 		    test_instance_file);
+	CU_add_test(suite, "systems and events APIs",
+		    test_system_event);
 	CU_add_test(suite, "tracefs_iterate_raw_events API",
 		    test_iter_raw_events);
 }
-- 
2.24.1

