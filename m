Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F25B3218D
	for <linux-trace-devel@vger.kernel.org>; Tue, 10 Oct 2023 19:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SOM3BQaE"
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BB4B6
	for <linux-trace-devel@vger.kernel.org>; Tue, 10 Oct 2023 12:28:08 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-9b2d64c9307so233787666b.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Oct 2023 12:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696966086; x=1697570886; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=I7BxrGokL/Q/BifzXSRkFc4iJL+MgUPsTlM9wxAQ70I=;
        b=SOM3BQaElhGSAIqavULskxhdClbHkFnN0MtqyDjrRaXg+PcZk6zYfy5HwXPw0PTPsm
         d8nngdNSu5PO/oD5LyRZofmZLcFOUZLM6KmyCJeH5mAnpAxxsvSGJjx/2Quv3JiFeDFN
         XEyz+g1v+n91UnecYtKIOwLtk/FphKY0zN8Ahlu3odcgwX9yUG34ktwwRIr4arS2Lg85
         ujq3Bgw9wMZ7AG0cAcnxZFjT9JusTgxiYBU0Fp1mPwrGOjyvPUO/Y3tlhMS5gK3xuKDx
         SwNrijFZKdyV/VtjgBpFUiGWl4osio+os7rCza8lT2lihYe78simnEtvA9epPka1nxqW
         wJDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696966086; x=1697570886;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I7BxrGokL/Q/BifzXSRkFc4iJL+MgUPsTlM9wxAQ70I=;
        b=Urt4qUyTirQoG/BP45agCxucuIup/gdO9iT1RK38Go3uYkiG2wtRgB2qfiR/rVin3G
         3JFV788nyXd0OO7NR0ZZLQYjDNg6AO06fkWEg+kVY6VEBEpiRLNKJ1ndPLI1I1wpMT5Z
         JKI327AWsUl1XxVSPXGmsNBpNms9xbSmQqe5QcudyekCqr3laeB6uq6+kLOjeTV7+W3r
         ONicgO3NMhK2sXNQ+R9pU4vuuw49xgEwmpNCzXZXAX6dcBQDqb8LeoGidMaUTrsAOMky
         Cje41A8IgHrogf+jTfCD7uCnZfrl9fN7ey34p+QI+XzZEdFZFMZMwWkSKYo7t3yvG+GX
         Vgug==
X-Gm-Message-State: AOJu0YyyngpwMuein0hbXlw/tnpYP+OrdBy4+VG+ru9dAtbkMhDx2wgW
	t9cWSOWRYWuPPlwPewPLONcWkWRpg1SCUg==
X-Google-Smtp-Source: AGHT+IHq5JJVqoL7rACOKXztGFqkQl0OmXHbsToBMbvtKtW6dPut1iOYMskJpXWdsDX+3k8zKWDKcA==
X-Received: by 2002:a17:906:5308:b0:9b2:b532:d8d7 with SMTP id h8-20020a170906530800b009b2b532d8d7mr15828509ejo.5.1696966085812;
        Tue, 10 Oct 2023 12:28:05 -0700 (PDT)
Received: from devel.lxd ([103.210.134.108])
        by smtp.googlemail.com with ESMTPSA id qb40-20020a1709077ea800b009b9af27d98csm7401120ejc.132.2023.10.10.12.28.03
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 12:28:05 -0700 (PDT)
From: Brahmajit Das <brahmajit.xyz@gmail.com>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/1] Fix incompatible function pointer types assigning to stream_find_id_func
Date: Tue, 10 Oct 2023 19:26:33 +0000
Message-ID: <20231010192738.166989-1-brahmajit.xyz@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Newer compilers such as Clang 16 and GCC 14 enables certain errors by
default, -Werror=incompatible-function-pointer-types being one of them
(-Werror=incompatible-pointer-types is the equivalent in GCC). This
resutls in build errors such as

error: incompatible function pointer types assigning to 'stream_find_id_func' (aka 'int (*)(struct kshark_data_stream *, const char *)') from 'const int (struct kshark_data_stream *, const char *)' [-Wincompatible-function-pointer-types]
 1204 |         interface->find_event_id = tepdata_find_event_id;
      |                                  ^ ~~~~~~~~~~~~~~~~~~~~~

My patch is not the best fix/a proper fix but for now silences the error
and lets me build kernelshark with clang.

I've also added some other misc. fixes that helps building kernelshark
on musl libc.

Bug: https://bugs.gentoo.org/895838
Signed-off-by: Brahmajit Das <brahmajit.xyz@gmail.com>
---
 src/kernelshark.cpp        | 1 +
 src/libkshark-tepdata.c    | 6 +++---
 src/libkshark.h            | 1 +
 src/plugins/sched_events.c | 1 +
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/src/kernelshark.cpp b/src/kernelshark.cpp
index 1ad15f4..d795492 100644
--- a/src/kernelshark.cpp
+++ b/src/kernelshark.cpp
@@ -7,6 +7,7 @@
 // C
 #include <sys/stat.h>
 #include <getopt.h>
+#include <libgen.h>
 
 // Qt
 #include <QApplication>
diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index b780957..236a858 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -1201,13 +1201,13 @@ static void kshark_tep_init_methods(struct kshark_generic_stream_interface *inte
 	interface->get_event_name = tepdata_get_event_name;
 	interface->aux_info= tepdata_get_latency;
 	interface->get_info = tepdata_get_info;
-	interface->find_event_id = tepdata_find_event_id;
+	interface->find_event_id = (stream_find_id_func) tepdata_find_event_id;
 	interface->get_all_event_ids = tepdata_get_event_ids;
 	interface->dump_entry = tepdata_dump_entry;
 	interface->get_all_event_field_names = tepdata_get_field_names;
 	interface->get_event_field_type = tepdata_get_field_type;
-	interface->read_record_field_int64 = tepdata_read_record_field;
-	interface->read_event_field_int64 = tepdata_read_event_field;
+	interface->read_record_field_int64 = (stream_read_record_field)tepdata_read_record_field;
+	interface->read_event_field_int64 = (stream_read_event_field) tepdata_read_event_field;
 	interface->load_entries = tepdata_load_entries;
 	interface->load_matrix = tepdata_load_matrix;
 }
diff --git a/src/libkshark.h b/src/libkshark.h
index 1514f33..c477c70 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -17,6 +17,7 @@
 #include <string.h>
 #include <pthread.h>
 #include <errno.h>
+#include <sys/types.h>
 
 // Json-C
 #include <json-c/json.h>
diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
index c3a4f47..fc5dc54 100644
--- a/src/plugins/sched_events.c
+++ b/src/plugins/sched_events.c
@@ -14,6 +14,7 @@
 #include <stdio.h>
 
 // trace-cmd
+#define _GNU_SOURCE             /* See feature_test_macros(7) */
 #include <trace-cmd.h>
 
 // KernelShark
-- 
2.42.0

