Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 622D4C77B7C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Apr 2023 04:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjDZELf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Apr 2023 00:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239173AbjDZELd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Apr 2023 00:11:33 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD34783
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Apr 2023 21:11:31 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-304935cc79bso1138161f8f.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Apr 2023 21:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682482290; x=1685074290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TCKOPaMP4q9P/VNYovFPbb/y5w02ooNr3lYu2DBlEqk=;
        b=ezh6YMBmeDx8nddZOYcXz4O41QtlncTQl8DPuWPhERj+Q55t6lv0Le5AjaSWl7RMb+
         IAWhOXNaOPSEVO4TDGQqD/WgUl6KcTzxYidU8bJIEPjJzQOL9qQTfmg1oAaH+tSbME3q
         N/7DfypKrdYRYa3PUKVGd+1kFCdkkcFqw41ZInQ2fBCf5pS/7mXK78aL40NXKtJ8fGzi
         lbkbiZ6WXzXcGJYcSTug2TZSB5xh+Rwx7v4K1AMFS8cbgE3sk2tPfixUK2duH+etwMZ7
         v6EEti6nXKd8uR0oVa6dSV9R5tJLI2WR5SIxEI+Te/jy4VPD4JnzhvU541htxKd5SRyZ
         4bbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682482290; x=1685074290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TCKOPaMP4q9P/VNYovFPbb/y5w02ooNr3lYu2DBlEqk=;
        b=inn3CWs0cEaIYAv3fX4gEKh/ZlE9DFQvq8ibHfg5v/HJTDCSm2wko+kdoYz3Y7ETSr
         LTTXVyDC1rIbt5JY+MwpDIGVwJDs9nRXznh63PtIDYY2zI9vUaI7VORSZzr9F8NzmYza
         Ph8c/wONb97c8et42RG2GoAETQChs1CoGHxVKV5KrsGOY3U+DkMKUpOzJ/ouXdxlWqyF
         sglIrce6jtH3Xf1hoJK+HBsA5UzMuiyu253ELy5XMRqCAmmxSqAJJFb2MxvvsWq5uhtu
         KRCMMfdXSr8pWi16xcbkRASkzjIqUDbPckt6jCbxF5aicjexC1ay3zGshmaOb2w8sdBE
         7x9g==
X-Gm-Message-State: AAQBX9dov0Vyv7vsKtAaSjW4PA1hWhRdmrPI7wgV3tn8Y+tye4tzwzsy
        yoZtF40adAbINatJJfbtu/mxVpHJYcmthw==
X-Google-Smtp-Source: AKy350YAHvunf6DLXziOQaDOrlXXHkthy88bSejNs8UkYFEsQZaEdMAa8kvij6WHOdZGGrxampqUSg==
X-Received: by 2002:a5d:5381:0:b0:304:794c:1534 with SMTP id d1-20020a5d5381000000b00304794c1534mr7158751wrv.4.1682482289915;
        Tue, 25 Apr 2023 21:11:29 -0700 (PDT)
Received: from oberon.zico.biz (77-85-190-39.ip.btc-net.bg. [77.85.190.39])
        by smtp.gmail.com with ESMTPSA id m5-20020a5d6a05000000b002f01e181c4asm14648107wru.5.2023.04.25.21.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 21:11:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/3] libtracefs: Unit test for tracefs_instance_reset()
Date:   Wed, 26 Apr 2023 07:11:24 +0300
Message-Id: <20230426041124.69544-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230426041124.69544-1-tz.stoyanov@gmail.com>
References: <20230426041124.69544-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The logic of the tracefs_instance_reset() is complex and should be
covered by the unit tests of the tracefs library.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 183 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 183 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index e0e3c07..47f65cb 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1618,6 +1618,187 @@ static void test_instance_file(void)
 	free(inst_dir);
 }
 
+static bool test_check_file_content(struct tracefs_instance *instance, char *file,
+				    char *content, bool full_match, bool ignore_comments)
+{
+	char *save = NULL;
+	char *buf, *line;
+	bool ret = false;
+	int len;
+
+	if (!tracefs_file_exists(instance, file))
+		return false;
+
+	buf = tracefs_instance_file_read(instance, file, NULL);
+	if (strlen(content) == 0) {
+		/* check for empty file */
+		if (!buf)
+			return true;
+		if (!ignore_comments) {
+			if (strlen(buf) > 0)
+				goto out;
+		} else {
+			line = strtok_r(buf, "\n", &save);
+			while (line) {
+				if (line[0] != '#')
+					goto out;
+				line = strtok_r(NULL, "\n", &save);
+			}
+		}
+	} else {
+		if (!buf || strlen(buf) < 1)
+			return false;
+		if (full_match) {
+			/* strip the newline */
+			len = strlen(buf) - 1;
+			while (buf[len] == '\n' || buf[len] == '\r') {
+				buf[len] = '\0';
+				len = strlen(buf) - 1;
+				if (len < 0)
+					goto out;
+			}
+			if (strcmp(buf, content))
+				goto out;
+		} else {
+			if (!strstr(buf, content))
+				goto out;
+		}
+	}
+
+	ret = true;
+out:
+	free(buf);
+	return ret;
+}
+
+static bool test_check_event_file_content(struct tracefs_instance *instance,
+					  char *system, char *event, char *file,
+					  char *content, bool full_match, bool ignore_comments)
+{
+	char *efile;
+	int ret;
+
+	ret = asprintf(&efile, "events/%s/%s/%s", system, event, file);
+	if (ret <= 0)
+		return false;
+	ret = test_check_file_content(instance, efile, content, full_match, ignore_comments);
+	free(efile);
+	return ret;
+}
+
+static bool check_cpu_mask(struct tracefs_instance *instance)
+{
+	int cpus = sysconf(_SC_NPROCESSORS_CONF);
+	int fullwords = (cpus - 1) / 32;
+	int bits = (cpus - 1) % 32 + 1;
+	int len = (fullwords + 1) * 9;
+	char buf[len + 1];
+
+	buf[0] = '\0';
+	sprintf(buf, "%x", (unsigned int)((1ULL << bits) - 1));
+	while (fullwords-- > 0)
+		strcat(buf, ",ffffffff");
+
+	return test_check_file_content(instance, "tracing_cpumask", buf, true, false);
+}
+
+static bool test_instance_check_default_state(struct tracefs_instance *instance)
+{
+	char **systems;
+	char **events;
+	int i, j;
+	int ok;
+
+	if (tracefs_trace_is_on(instance) != 1)
+		return false;
+	if (!test_check_file_content(instance, "current_tracer", "nop", true, false))
+		return false;
+	if (!test_check_file_content(instance, "events/enable", "0", true, false))
+		return false;
+	if (!test_check_file_content(instance, "set_ftrace_pid", "no pid", true, false))
+		return false;
+	if (!test_check_file_content(instance, "trace", "", true, true))
+		return false;
+	if (!test_check_file_content(instance, "error_log", "", true, false))
+		return false;
+	if (!test_check_file_content(instance, "trace_clock", "[local]", false, false))
+		return false;
+	if (!test_check_file_content(instance, "set_event_pid", "", true, false))
+		return false;
+	if (!test_check_file_content(instance, "tracing_max_latency", "0", true, false))
+		return false;
+	if (!test_check_file_content(instance, "set_ftrace_filter", "", true, true))
+		return false;
+	if (!test_check_file_content(instance, "set_ftrace_notrace", "", true, true))
+		return false;
+	if (!check_cpu_mask(instance))
+		return false;
+
+	ok = 1;
+	systems = tracefs_event_systems(NULL);
+	if (systems) {
+		for (i = 0; systems[i]; i++) {
+			events = tracefs_system_events(NULL, systems[i]);
+			if (!events)
+				continue;
+			for (j = 0; events[j]; j++) {
+				if (!test_check_event_file_content(instance, systems[i], events[j],
+								    "enable", "0", true, false))
+					break;
+				if (!test_check_event_file_content(instance, systems[i], events[j],
+								    "filter", "none", true, false))
+					break;
+				if (!test_check_event_file_content(instance, systems[i], events[j],
+								    "trigger", "", true, true))
+					break;
+			}
+			if (events[j])
+				ok = 0;
+			tracefs_list_free(events);
+			if (!ok)
+				return false;
+		}
+		tracefs_list_free(systems);
+	}
+
+	return true;
+}
+
+static void test_instance_reset(void)
+{
+	struct tracefs_instance *instance = NULL;
+	const char *name = get_rand_str();
+
+	CU_TEST(tracefs_instance_exists(name) == false);
+	instance = tracefs_instance_create(name);
+	CU_TEST(instance != NULL);
+
+	CU_TEST(test_instance_check_default_state(instance) == true);
+
+	CU_TEST(tracefs_tracer_set(instance, TRACEFS_TRACER_HWLAT) == 0);
+	CU_TEST(tracefs_event_enable(instance, "bridge", "fdb_delete") == 0);
+	CU_TEST(tracefs_instance_file_write(instance, "set_ftrace_pid", "5") > 0);
+	CU_TEST(tracefs_instance_file_write(instance, "trace_clock", "global") > 0);
+	CU_TEST(tracefs_instance_file_write(instance, "set_event_pid", "5") > 0);
+	CU_TEST(tracefs_instance_file_write(instance, "set_ftrace_filter",
+						      "schedule:stacktrace") > 0);
+	CU_TEST(tracefs_instance_file_write(instance, "set_ftrace_notrace",
+						      "schedule:stacktrace") > 0);
+	CU_TEST(tracefs_instance_file_write(instance, "tracing_cpumask", "0f") > 0);
+	CU_TEST(tracefs_instance_file_write(instance, "events/syscalls/sys_exit_read/trigger",
+						      "enable_event:kmem:kmalloc:1") > 0);
+	CU_TEST(tracefs_instance_file_write(instance, "events/bridge/fdb_delete/filter",
+						      "common_pid == 5") > 0);
+
+	CU_TEST(test_instance_check_default_state(instance) == false);
+
+	tracefs_instance_reset(instance);
+	CU_TEST(test_instance_check_default_state(instance) == true);
+
+	CU_TEST(tracefs_instance_destroy(instance) == 0);
+	tracefs_instance_free(instance);
+}
+
 static bool check_fd_name(int fd, const char *dir, const char *name)
 {
 	char link[PATH_MAX + 1];
@@ -2354,6 +2535,8 @@ void test_tracefs_lib(void)
 		    test_file_fd);
 	CU_add_test(suite, "instance file descriptor",
 		    test_instance_file);
+	CU_add_test(suite, "instance reset",
+		    test_instance_reset);
 	CU_add_test(suite, "systems and events APIs",
 		    test_system_event);
 	CU_add_test(suite, "tracefs_iterate_raw_events API",
-- 
2.39.2

