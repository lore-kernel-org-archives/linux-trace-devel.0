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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40454C33CB7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10BDF20708
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pNlu/Xdb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgA2Jyg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 04:54:36 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37365 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgA2Jyf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 04:54:35 -0500
Received: by mail-lf1-f68.google.com with SMTP id b15so11437655lfc.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 29 Jan 2020 01:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uyMC3iMuzLjNFxayaNgTkdaIyXwq8suHB2zITIyfC0o=;
        b=pNlu/Xdbua7hrx1O5BiOqRxHCmpPaMJcbsmRcp4fwDRVm4EdyVnYN6ctFfBv6ox3t8
         OLs6JizIG3DsBzecqrls8UiYU7RBmfd9T1yY6V3O5JEi0Pd+aW5gK6NaPD4MbcA34Z57
         slD8KOeDUfeZZIixPcgYm6CjrJOmTTFnZ8A9SjuEyMrZb3MK1OozEdn2dMTd+HamqfoI
         W+EQSyGjM486BCv08PznOubMM3K1p5gBguKILM3/lJxcWcwj4clzkbueP20ugOGPzY4D
         yxbipJMnUeiwpSTPXpX/O5QVcFO1CdAbi59FR+QZ6259ySbWED8GMArW4vlBYM2kBBxd
         7KgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uyMC3iMuzLjNFxayaNgTkdaIyXwq8suHB2zITIyfC0o=;
        b=BggmGw03AbmnvALA38XsPkf8mneNHbnxIFxULrmKzmcmXgclncOGK7ASIVuCKhCRDQ
         BiBTrUlSzfIdClVnQTzbNgYLir+FOhajeBcjuOs/jab6ElVJTzuHlynClcmT/KHs0otQ
         1Xi8rrIBIwnngYhiminF7wfSd8PI74qf0M5vkN3APmG+6/LF3JLg6afVXrUDB0I2OmfE
         Xqxm4Uy0tTXLudRMeaupv2R59GK6VnGWAINNWhwqCmE0yQAGD3AQAMdWzoCvMz4POVGU
         1w2kvmsP42Fypl7Vh/GAybIXmScuSZqb4u5D4G1nRfLxHDIoQaGbi9mNce3LSM30Y/z3
         8txQ==
X-Gm-Message-State: APjAAAUK94AFwtDpQGR6uXDKKZne79goY9QsRgVklyGhdY9JzzqfYSfS
        IuqIgtfTJdHu8ZHI5tsvJec=
X-Google-Smtp-Source: APXvYqxl4e7aKJDUGHfFrDRkw4uz9n1y6mCgWIJhrKWv0f6fJfpis/V6bpYZbXitddvM2n07vX+Nnw==
X-Received: by 2002:a19:4a:: with SMTP id 71mr5113740lfa.50.1580291674038;
        Wed, 29 Jan 2020 01:54:34 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q10sm648584ljj.60.2020.01.29.01.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 01:54:33 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 9/9] trace-cmd: Unit tests for libtracefs APIs related to allocating a tep handler based on local events
Date:   Wed, 29 Jan 2020 11:54:21 +0200
Message-Id: <20200129095421.881786-10-tz.stoyanov@gmail.com>
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
  tracefs_local_events()
  tracefs_local_events_system()
  tracefs_fill_local_events()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 92 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 1fd7f09..2473e89 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -351,6 +351,96 @@ static void test_tracers(void)
 	free(tfile);
 }
 
+static void test_check_events(struct tep_handle *tep, char *system, bool exist)
+{
+	struct dirent *dent;
+	char file[PATH_MAX];
+	char buf[1024];
+	char *edir = NULL;
+	const char *tdir;
+	DIR *dir;
+	int fd;
+
+	tdir  = tracefs_get_tracing_dir();
+	CU_TEST(tdir != NULL);
+
+	asprintf(&edir, "%s/events/%s", tdir, system);
+	dir = opendir(edir);
+	CU_TEST(dir != NULL);
+
+	while ((dent = readdir(dir))) {
+		if (dent->d_name[0] == '.')
+			continue;
+		sprintf(file, "%s/%s/id", edir, dent->d_name);
+		fd = open(file, O_RDONLY);
+		if (fd < 0)
+			continue;
+		CU_TEST(read(fd, buf, 1024) > 0);
+		if (exist) {
+			CU_TEST(tep_find_event(tep, atoi(buf)) != NULL);
+		} else {
+			CU_TEST(tep_find_event(tep, atoi(buf)) == NULL);
+		}
+
+		close(fd);
+	}
+
+	closedir(dir);
+	free(edir);
+
+}
+
+static void test_local_events(void)
+{
+	struct tep_handle *tep;
+	const char *tdir;
+	char **systems;
+	char *lsystems[3];
+	int i;
+
+	tdir  = tracefs_get_tracing_dir();
+	CU_TEST(tdir != NULL);
+
+	tep = tracefs_local_events(tdir);
+	CU_TEST(tep != NULL);
+
+	systems = tracefs_event_systems(tdir);
+	CU_TEST(systems != NULL);
+
+	for (i = 0; systems[i]; i++)
+		test_check_events(tep, systems[i], true);
+	tep_free(tep);
+
+	memset(lsystems, 0, sizeof(lsystems));
+	for (i = 0; systems[i]; i++) {
+		if (!lsystems[0])
+			lsystems[0] = systems[i];
+		else if (!lsystems[2])
+			lsystems[2] = systems[i];
+		else
+			break;
+	}
+
+	if (lsystems[0] && lsystems[2]) {
+		tep = tracefs_local_events_system(tdir,
+						  (const char * const *)lsystems);
+		CU_TEST(tep != NULL);
+		test_check_events(tep, lsystems[0], true);
+		test_check_events(tep, lsystems[2], false);
+	}
+	tep_free(tep);
+
+	tep = tep_alloc();
+	CU_TEST(tep != NULL);
+	CU_TEST(tracefs_fill_local_events(tdir, tep, NULL) == 0);
+	for (i = 0; systems[i]; i++)
+		test_check_events(tep, systems[i], true);
+
+	tep_free(tep);
+
+	tracefs_list_free(systems);
+}
+
 static int test_suite_destroy(void)
 {
 	tracefs_instance_destroy(test_instance);
@@ -396,4 +486,6 @@ void test_tracefs_lib(void)
 		    test_iter_raw_events);
 	CU_add_test(suite, "tracefs_tracers API",
 		    test_tracers);
+	CU_add_test(suite, "tracefs_local events API",
+		    test_local_events);
 }
-- 
2.24.1

