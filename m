Return-Path: <SRS0=ilnn=3S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 937FBC33CB2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62E3A20708
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RThB2WRG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgA2Jyb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 04:54:31 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41435 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgA2Jya (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 04:54:30 -0500
Received: by mail-lj1-f195.google.com with SMTP id h23so17740746ljc.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 29 Jan 2020 01:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rmkk2JEl22fRSi1s8b6GcuP+e1SZHld0EhT6lHuep4I=;
        b=RThB2WRGJQPcsi89skR6B5m9kgE+G39C5g/rqowP1mLEQM1M0Dinth5FL+t3Wel4xD
         NvDeEbD5l/hAwujUgfBZN9j22tmI9U5qIaFMhbh6osWw8yA5E75K47UU18i7bI9WMgbz
         IH7+qVgz8JgVo8eJcyb8ozScUKSOFQWUIxbXHNTH0uWMeUjCRFcBHpzgwVBj2u9y+3PE
         W68D4XLPivkKgRQNvKpj6C2jHQARnyzm96MwVvqXvbCqbvKec7yo9bvYvUDzDBrbdkXj
         OqMi0C3hw8Gb07/xQrWjq1fQ0IKTthwanr1XxQuT6xNkDkaWRk3suWhRo8a+7HE6HLFl
         nXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rmkk2JEl22fRSi1s8b6GcuP+e1SZHld0EhT6lHuep4I=;
        b=sSjpgeJlXOsPZ/rstYVbn1uzQmgvCqRlTlEpgQ3Ku17EtJidoox+AmIHKBEV2W7Ah5
         RiuMEbsyqwq7A3n5/UN1ut/f1pZ19VDm41tdx/9LTjeZUfcox42FxDe9iwnmi3XdcUFz
         IDxjo71H0cOyeAJx6RPRjox5+hs9ebN2GIRPeqXYtGQN0Mb+gmC9e7/+hyT3tDn5k+S6
         T/7gb7G4Vtt+BnJLjpU8WIGjvq0xmbaTMNRDX8S+AEzoXBtvLSp8lzq1A+8uY+mBgYVu
         t582aHd4/ycBBpzeYB7YfLwZkWX6Awfi07xDSpy+l8Gq90+FB1+NIfhEA426towjP6sf
         xdXA==
X-Gm-Message-State: APjAAAVPqTL5Wx1f5bN6wtiSgE1xKAidJGPA6QT5QwvNN/WG7sv8/tHK
        yJzlZQlXB2WDb1zyLUTdNW4=
X-Google-Smtp-Source: APXvYqwI8/q1js37HlI3pxGQmR1trk5NrxRA9XR7kFGX2PkWxgYBtkh0kr/CeEoTmNA3GlI4/HqPDA==
X-Received: by 2002:a2e:9e55:: with SMTP id g21mr16118211ljk.245.1580291669128;
        Wed, 29 Jan 2020 01:54:29 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q10sm648584ljj.60.2020.01.29.01.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 01:54:28 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/9] trace-cmd: Unit tests for libtracefs APIs related to tracing file / directory
Date:   Wed, 29 Jan 2020 11:54:17 +0200
Message-Id: <20200129095421.881786-6-tz.stoyanov@gmail.com>
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
  tracefs_find_tracing_dir()
  tracefs_get_tracing_dir()
  tracefs_get_tracing_file()
  tracefs_put_tracing_file()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 55 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index d3ba213..2e6e96f 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -8,6 +8,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
+#include <time.h>
 
 #include <CUnit/CUnit.h>
 #include <CUnit/Basic.h>
@@ -85,6 +86,58 @@ static void test_iter_raw_events(void)
 	CU_TEST(test_found == TEST_ARRAY_SIZE);
 }
 
+#define RAND_STR_SIZE 20
+#define RAND_ASCII "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
+static const char *get_rand_str()
+{
+	static char str[RAND_STR_SIZE];
+	static char sym[] = RAND_ASCII;
+	struct timespec clk;
+	int i;
+
+	clock_gettime(CLOCK_REALTIME, &clk);
+	srand(clk.tv_nsec);
+	for (i = 0; i < RAND_STR_SIZE; i++)
+		str[i] = sym[rand() % (sizeof(sym) - 1)];
+
+	str[RAND_STR_SIZE - 1] = 0;
+	return str;
+}
+
+static void test_trace_file(void)
+{
+	const char *tmp = get_rand_str();
+	const char *tdir;
+	struct stat st;
+	char *file;
+	char *dir;
+
+	dir = tracefs_find_tracing_dir();
+	CU_TEST(dir != NULL);
+	CU_TEST(stat(dir, &st) == 0);
+	CU_TEST(S_ISDIR(st.st_mode));
+
+	tdir  = tracefs_get_tracing_dir();
+	CU_TEST(tdir != NULL);
+	CU_TEST(stat(tdir, &st) == 0);
+	CU_TEST(S_ISDIR(st.st_mode));
+
+	CU_TEST(strcmp(dir, tdir) == 0);
+	free(dir);
+
+	file = tracefs_get_tracing_file(NULL);
+	CU_TEST(file == NULL);
+	file = tracefs_get_tracing_file(tmp);
+	CU_TEST(file != NULL);
+	CU_TEST(stat(file, &st) != 0);
+	tracefs_put_tracing_file(file);
+
+	file = tracefs_get_tracing_file("trace");
+	CU_TEST(file != NULL);
+	CU_TEST(stat(file, &st) == 0);
+	tracefs_put_tracing_file(file);
+}
+
 static int test_suite_destroy(void)
 {
 	tracefs_instance_destroy(test_instance);
@@ -120,6 +173,8 @@ void test_tracefs_lib(void)
 		fprintf(stderr, "Suite \"%s\" cannot be ceated\n", TRACEFS_SUITE);
 		return;
 	}
+	CU_add_test(suite, "tracing file / directory APIs",
+		    test_trace_file);
 	CU_add_test(suite, "tracefs_iterate_raw_events API",
 		    test_iter_raw_events);
 }
-- 
2.24.1

