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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF303C433B4
	for <linux-trace-devel@archiver.kernel.org>; Sat,  1 May 2021 06:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8588A613F8
	for <linux-trace-devel@archiver.kernel.org>; Sat,  1 May 2021 06:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhEAGKN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 1 May 2021 02:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhEAGKM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 1 May 2021 02:10:12 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B738AC06174A
        for <linux-trace-devel@vger.kernel.org>; Fri, 30 Apr 2021 23:09:22 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id c22so494210edn.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 30 Apr 2021 23:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Fl35m226M6Cs3YVt9c0AZ0Dt/PXltLsKOIMJfJU7gA=;
        b=syTvaRketN6Jpd9IAxla7Ns0vRFEeYXeLXmnJ3QyJRO1P1vTNJZWKefROlrt3ExMz2
         R8lA+2Y/8HssVE8t0y7/31dFQXuN+uzYf9HS5bcbNNMDCBTajhL5TlE0uQPbJHndDEin
         1icDavONt1FdjEbm9Zf6SAKIvlz8yotitMhl4nQh629jI7AdrAwKpTaMa+KelI3SjTdU
         7MYUAvcpShXqPx7r41O2qoI0c66xCw4x9diCyq563l0R2g8vFcZLHUgkLixjC5k6LPv3
         ShsdlDtnUrE5osFHpRMnkI6khggbRdX+BYexrXFTc+aILEuwcuEezlkdVLJxjOlv2Oh3
         uDWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Fl35m226M6Cs3YVt9c0AZ0Dt/PXltLsKOIMJfJU7gA=;
        b=I3RexZojxXr+sE9XAx734/3cChcqpQ1mWV8RiyfosIkyl4TB9Wcxfml0VQDtP8SDuw
         0pMABaW9u/P/03KN1uVw7HApWvRl40A7YS4kVS9NdbZnqcMaW0yaIPRr6zPT0SHIxCNc
         m+kgVwdlZuLujj/MU1b3y8IZU5f140pK+i7+T1Vx3/r1OHoU/v0mdeaoKDgDyO+5usWH
         qt+w/5HFdzlwKTDttTtnv+cRAEEA9Vy9XTeJaGGtm/UoeUGsLRLphb/k/+VJtK0Ul7HK
         FNm+i6ywLRqKDhuWBuiR/7Tk99K0V3IPr6MSCZtRssfokT62rFvwzx/5xzDUDzxLzJbX
         FF/A==
X-Gm-Message-State: AOAM533bBQIa7RD3sKBomyS1mrPAUBMPVCfDIieN7WiNw9fT2QdL8FRU
        KkpgG1//a20acS9p0Cpp2vOmpb23HNM=
X-Google-Smtp-Source: ABdhPJyoouQk2fezHxnzwq2hM5V/otfk1H/EXnC2D66Cgpwsl5kM6N0uyOEPPOYM3c2xkiZapbNQug==
X-Received: by 2002:a05:6402:1056:: with SMTP id e22mr9851532edu.279.1619849360017;
        Fri, 30 Apr 2021 23:09:20 -0700 (PDT)
Received: from localhost.localdomain.Home ([151.32.59.148])
        by smtp.gmail.com with ESMTPSA id go38sm4178659ejc.40.2021.04.30.23.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 23:09:19 -0700 (PDT)
From:   Stefano De Venuto <stefano.devenuto99@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, dfaggioli@suse.com,
        Stefano De Venuto <stefano.devenuto99@gmail.com>
Subject: [RFC v2] Simple tool for VMEnters/VMExits matching and trace validation
Date:   Sat,  1 May 2021 08:07:44 +0200
Message-Id: <20210501060744.5053-1-stefano.devenuto99@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add a tool in examples/ that scans a merged host + guest trace and
search for host events that are inside a vmentry/vmexit block (and
vice-versa for guest events ouside the block) and report the found
ones.

It can be useful as a starting point for identifying issues of for
checking the effectiveness of host/guest traces synchronization, or
even for improving the placing of the tracepoints in the kernel.

v2 changes:
 - Addressed Yordan's comments.
 - Added a way to not mark as invalid the initial guests event.
 - Used kshark_read_event_field_int() for the vCPU field recovering.

Signed-off-by: Stefano De Venuto <stefano.devenuto99@gmail.com>
---
 examples/CMakeLists.txt |   4 +
 examples/checker.c      | 224 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 228 insertions(+)
 create mode 100644 examples/checker.c

diff --git a/examples/CMakeLists.txt b/examples/CMakeLists.txt
index c2f4c01..91badb8 100644
--- a/examples/CMakeLists.txt
+++ b/examples/CMakeLists.txt
@@ -12,6 +12,10 @@ message(STATUS "multibufferload")
 add_executable(mbload          multibufferload.c)
 target_link_libraries(mbload   kshark)
 
+message(STATUS "checker")
+add_executable(checker          checker.c)
+target_link_libraries(checker   kshark)
+
 message(STATUS "datahisto")
 add_executable(dhisto          datahisto.c)
 target_link_libraries(dhisto   kshark)
diff --git a/examples/checker.c b/examples/checker.c
new file mode 100644
index 0000000..425de58
--- /dev/null
+++ b/examples/checker.c
@@ -0,0 +1,224 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "libkshark.h"
+#include "libkshark-tepdata.h"
+
+#define KVM_ENTRY "kvm/kvm_entry"
+#define KVM_EXIT "kvm/kvm_exit"
+
+struct custom_stream
+{
+	struct kshark_data_stream* original_stream;
+	int* cpus;
+};
+
+/**
+ * Checks if a stream_id represents a guest.
+ * If so, @host contains the corresponding host stream_id
+ */
+int is_guest(int stream_id,
+	     struct kshark_host_guest_map* mapping,
+	     int n_mapping, int* host)
+{
+	for (int i = 0; i < n_mapping; i++) {
+		if (mapping[i].guest_id == stream_id) {
+			*host = mapping[i].host_id;
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * Recover guest stream_id from host VMentry/VMexit event.
+ * In case of success, @guest_id will contain the guest stream_id.
+ */
+int guest_id_from_host_entry_exit(struct kshark_host_guest_map* mapping,
+				  int n_mapping, int* guest_id,
+				  struct kshark_entry* entry)
+{
+	struct kshark_data_stream* stream;
+	int pid;
+
+	stream = kshark_get_stream_from_entry(entry);
+	pid = kshark_get_pid(entry);
+
+	for (int i = 0; i < n_mapping; i++)
+		if (mapping[i].host_id == stream->stream_id)
+			for (int j = 0; j < mapping[i].vcpu_count; j++)
+				if (mapping[i].cpu_pid[j] == pid) {
+					*guest_id = mapping[i].guest_id;
+					return 1;
+				}
+
+	return 0;
+}
+
+void print_entry(struct kshark_entry* entry)
+{
+	struct kshark_data_stream* stream;
+	char* event_name;
+
+	stream = kshark_get_stream_from_entry(entry);
+	event_name = kshark_get_event_name(entry);
+
+	printf("      %d: %s-%d, %" PRId64 " [%03d]:%s\t%s\n",
+		stream->stream_id,
+		kshark_get_task(entry),
+		kshark_get_pid(entry),
+		entry->ts,
+		entry->cpu,
+		event_name,
+		kshark_get_info(entry));
+}
+
+void free_data(struct kshark_context *kshark_ctx,
+	       struct custom_stream** custom_streams,
+	       struct kshark_entry** entries, int n_entries,
+	       struct kshark_host_guest_map* host_guest_mapping,
+	       int n_guest)
+{
+	struct custom_stream* custom_stream;
+
+	for (int i = 0; i < kshark_ctx->n_streams; i++) {
+		custom_stream = custom_streams[i];
+
+		free(custom_stream->cpus);
+		free(custom_stream);
+	}
+	free(custom_streams);
+
+	for (int i = 0; i < n_entries; i++)
+		free(entries[i]);
+	free(entries);
+
+	kshark_tracecmd_free_hostguest_map(host_guest_mapping, n_guest);
+}
+
+int main(int argc, char **argv)
+{
+	struct kshark_host_guest_map* host_guest_mapping;
+	struct custom_stream** custom_streams;
+	struct custom_stream* custom_stream;
+	struct custom_stream* guest_stream;
+	struct custom_stream* host_stream;
+	struct kshark_data_stream* stream;
+	struct kshark_context* kshark_ctx;
+	struct kshark_entry** entries;
+	struct kshark_entry* current;
+	ssize_t n_entries;
+	char* event_name;
+	int64_t vcpu;
+	int guest_id;
+	int n_guest;
+	int host;
+	int v_i;
+	int sd;
+
+	kshark_ctx = NULL;
+	if (!kshark_instance(&kshark_ctx))
+		return 1;
+
+	custom_streams = malloc(sizeof(*custom_streams) * (argc-1));
+
+	for (int i = 1; i < argc; i++) {
+		sd = kshark_open(kshark_ctx, argv[i]);
+		if (sd < 0) {
+			kshark_free(kshark_ctx);
+			return 1;
+		}
+
+		kshark_tep_init_all_buffers(kshark_ctx, sd);
+
+		/**
+		 * Creating custom streams in order to keep track if a
+		 * pCPU is executing code of a vCPU and, if so, which vCPU.
+		 */
+		custom_stream = malloc(sizeof(*custom_stream));
+		custom_stream->original_stream = kshark_get_data_stream(kshark_ctx, sd);
+		custom_stream->cpus = malloc(custom_stream->original_stream->n_cpus * sizeof(int));
+		memset(custom_stream->cpus, -1, custom_stream->original_stream->n_cpus * sizeof(int));
+
+		custom_streams[i-1] = custom_stream;
+	}
+
+	host_guest_mapping = NULL;
+	n_guest = kshark_tracecmd_get_hostguest_mapping(&host_guest_mapping);
+	if (n_guest < 0) {
+		printf("Failed mapping: %d\n", n_guest);
+		return 1;
+	}
+
+	entries = NULL;
+	n_entries = kshark_load_all_entries(kshark_ctx, &entries);
+
+	for (int i = 0; i < n_entries; ++i) {
+		current = entries[i];
+
+		stream = kshark_get_stream_from_entry(current);
+		event_name = kshark_get_event_name(current);
+
+		custom_stream = custom_streams[stream->stream_id];
+
+		if (!strcmp(event_name, KVM_ENTRY) || !strcmp(event_name, KVM_EXIT)) {
+			if (kshark_read_event_field_int(current, "vcpu_id", &vcpu)) {
+				printf("Error on recovering the vCPU field\n");
+				return 1;
+			}
+
+			if (!guest_id_from_host_entry_exit(host_guest_mapping, n_guest, &guest_id, current)) {
+				printf("Error on recovering guest stream ID\n");
+				return 1;
+			}
+
+			/**
+			 * Mark the vCPU upcoming events as checkable.
+			 * Workaround implemented in order to not mark as invalid initial guests events.
+			 * Done in this way since we can't know if we'll find a kvm_exit (consistent state)
+			 * or a kvm_entry.
+			 */
+			guest_stream = custom_streams[guest_id];
+			guest_stream->cpus[vcpu] = 1;
+
+			if (!strcmp(event_name, KVM_ENTRY))
+				custom_stream->cpus[current->cpu] = vcpu;
+			else
+				custom_stream->cpus[current->cpu] = -1;
+
+		} else {
+
+			/**
+			 * If the event comes from a guest, recover the pCPU where the event was executed
+			 * and check if it's NOT OUTSIDE a kvm_entry/kvm_exit block.
+			 */
+			if (is_guest(stream->stream_id, host_guest_mapping, n_guest, &host)) {
+				host_stream = custom_streams[host];
+
+				for (v_i = 0; v_i < host_stream->original_stream->n_cpus; v_i++) {
+					if (current->cpu == host_stream->cpus[v_i])
+					break;
+				}
+
+				if (v_i == host_stream->original_stream->n_cpus && custom_stream->cpus[current->cpu] != -1)
+					printf("%d G out:\t", i);
+
+			/**
+			 * If the event comes from a host, recover the CPU that executed the event
+			 * and check if it's NOT INSIDE a kvm_entry/kvm_exit block.
+			 */
+			} else {
+				if (custom_stream->cpus[current->cpu] != -1)
+					printf("%d H in:\t", i);
+			}
+		}
+
+		print_entry(entries[i]);
+	}
+
+	free_data(kshark_ctx, custom_streams, entries, n_entries, host_guest_mapping, n_guest);
+
+	kshark_free(kshark_ctx);
+}
-- 
2.31.1

