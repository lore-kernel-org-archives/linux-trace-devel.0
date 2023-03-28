Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3540EC6FD18
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Mar 2023 15:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbjC1PEi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Mar 2023 11:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbjC1PEh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Mar 2023 11:04:37 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C543BDBF6
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 08:03:20 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id x3so50902533edb.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 08:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680015793;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GUiWUZIPwhqzEkv/SiMQ0nv48iqdObmEtzEKQgOhI4I=;
        b=RiFiJe6x+Ki+feFWAlkcGswk10riJxKy3OSc27RGmwzLjtdRVO2WwzZO36Os+R9edf
         uzo5RVjPIpfjveocfdqVErKKlpFZrEwsNeL86tgg84/XZGew6FfUPS6k3oNxXp9osNnh
         QXuy/e0VyiSrOytEGEWDoEwHcx0e4J8zXIGa5IGnIjCyr+EALNv/qwc3Os2tHGyDATnC
         0OtzmDHa04Ei33ISEHZ5JWRHDDPD4NIs98arXXu2nE+ILC7cQdXcCWyrqvFz0hFhi3q5
         mUCLAu0GlwuKBprhOzJVTXTvltSv6iiDS/1zUIQfa/NLbTTKlDiZA05D8OBvf/I7T6T0
         933A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680015793;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GUiWUZIPwhqzEkv/SiMQ0nv48iqdObmEtzEKQgOhI4I=;
        b=Xk6HacfIS78/7zBggQ7T5KsaaZwrPLYlnxRroA39vZObOncd1AXW7D+zfbyeIVL7zn
         vaUfrursJF/8XagWUzKTUmOn9pXAVOjmNVXVV5RXZY3hghnFmgftYMwi7HwvO4Tmnrcv
         kel2NKxk8FmC8GWYV+6U1W/t6RIP2cQjNtLRYcAjVSz77bPfAWMPDudsRFfXCvCOfaWv
         inWIhikQOxzpYIn2+OKOFWctKnGLoPBk33OPmy8Le303ym2P+U4khwny8kBQvyMu+wbO
         6z01FobitRovb8jLWKws+h79lL0DeyuzciZL8fEtbdYGQvokqzFOsoYNWSgbbvIYKw+Q
         m8VQ==
X-Gm-Message-State: AAQBX9fGKgxAM9a7KeSJ4UUIynwXx+lGNGtbwDZgynMd9QnCtQcsgsRr
        dHRIg5gevT87Z2zRUJC8mcr1unzB3rk=
X-Google-Smtp-Source: AKy350YT56voEZg7ltg0w9sUtR3wMG88c7BIdtV8XYOOSwKqw7Vr5PCRMWO7E/xVhWBG+ci3Td0ijg==
X-Received: by 2002:a17:907:7f86:b0:926:9c33:ea4 with SMTP id qk6-20020a1709077f8600b009269c330ea4mr17776807ejc.27.1680015793279;
        Tue, 28 Mar 2023 08:03:13 -0700 (PDT)
Received: from oberon.zico.biz (77-85-190-39.ip.btc-net.bg. [77.85.190.39])
        by smtp.gmail.com with ESMTPSA id c16-20020a170906925000b009327f9a397csm14799009ejx.145.2023.03.28.08.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 08:03:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] libtracefs: Unit test for tracefs_instance_reset()
Date:   Tue, 28 Mar 2023 18:03:08 +0300
Message-Id: <20230328150308.34783-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230328150308.34783-1-tz.stoyanov@gmail.com>
References: <20230328150308.34783-1-tz.stoyanov@gmail.com>
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
index e0e3c07..5866339 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1618,6 +1618,187 @@ static void test_instance_file(void)
 	free(inst_dir);
 }
 
+static bool test_check_file_contetnt(struct tracefs_instance *instance, char *file,
+				     char *content, bool full_match, bool ignore_comments)
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
+			len = strlen(buf)-1;
+			while (buf[len] == '\n' || buf[len] == '\r') {
+				buf[len] = '\0';
+				len = strlen(buf)-1;
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
+static bool test_check_event_file_contetnt(struct tracefs_instance *instance,
+					   char *system, char *event, char *file,
+					   char *content, bool full_match, bool ignore_comments)
+{
+	char *efile;
+	int ret;
+
+	ret = asprintf(&efile, "events/%s/%s/%s", system, event, file);
+	if (ret <= 0)
+		return false;
+	ret = test_check_file_contetnt(instance, efile, content, full_match, ignore_comments);
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
+	return test_check_file_contetnt(instance, "tracing_cpumask", buf, true, false);
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
+	if (!test_check_file_contetnt(instance, "current_tracer", "nop", true, false))
+		return false;
+	if (!test_check_file_contetnt(instance, "events/enable", "0", true, false))
+		return false;
+	if (!test_check_file_contetnt(instance, "set_ftrace_pid", "no pid", true, false))
+		return false;
+	if (!test_check_file_contetnt(instance, "trace", "", true, true))
+		return false;
+	if (!test_check_file_contetnt(instance, "error_log", "", true, false))
+		return false;
+	if (!test_check_file_contetnt(instance, "trace_clock", "[local]", false, false))
+		return false;
+	if (!test_check_file_contetnt(instance, "set_event_pid", "", true, false))
+		return false;
+	if (!test_check_file_contetnt(instance, "tracing_max_latency", "0", true, false))
+		return false;
+	if (!test_check_file_contetnt(instance, "set_ftrace_filter", "", true, true))
+		return false;
+	if (!test_check_file_contetnt(instance, "set_ftrace_notrace", "", true, true))
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
+				if (!test_check_event_file_contetnt(instance, systems[i], events[j],
+								    "enable", "0", true, false))
+					break;
+				if (!test_check_event_file_contetnt(instance, systems[i], events[j],
+								    "filter", "none", true, false))
+					break;
+				if (!test_check_event_file_contetnt(instance, systems[i], events[j],
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

