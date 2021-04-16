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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709E3C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 16:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53FC8610CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 16:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhDPQrs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 12:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234774AbhDPQrs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 12:47:48 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DEFC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Apr 2021 09:47:23 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id s15so33067015edd.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Apr 2021 09:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4kEuLPZgTDUwopO4CgfnZ2tbOMsYbagQ5qdO4lsnboo=;
        b=Hwz+5X20AD6WaaQ2j5XJEkaU/0aQQL2gGIZmn8yzV3HqU3zV41hb9dnmLdNUrn0et3
         RgIjM5FQDAV7rtfX5YJROvqUr/ik7pRvSPukp+1N2e4dQhPh+kdWPc8AJDGYXJOa+ErW
         4Wwe2eFotk5ZKh/QQhKuFZm//xEH/b1ispDyKP9MnSxEbpy530FNBVHPUid2uJGmw/VQ
         QyHtkqRiFbPRQoaVcSo/J4wyC2ko706aw+68jNVYr21yxbQNydnVqWAmJ+xNz3W7NPGg
         Ad7aYkR3b3Qf9vjsFLAYw6zGJcwtgjJdoct7LezHy6xItt0s0dFb3hBdsZ+cLIa6Rd/n
         Sn2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4kEuLPZgTDUwopO4CgfnZ2tbOMsYbagQ5qdO4lsnboo=;
        b=IvZrIVzfEEpkLoXXmf8h0mwoVNC6gu324q4kvbo7MxY7cUL1hyi5/71GZi1ulkvWwL
         xGlJQP4rZ2aYuDWgN/o+XMVTAaua0wwRag2li3UkxHO8TtnlHPJnY1rEsbsP+YZvyLx4
         3rYSjvLkTrCkD2+fVS2RgEXVOQ5QDuvI4m0NkcHbcMO313Vg1RfKPeilYuPYV0gn0Nme
         90vxEHSZBUmAdFMl9oYTgaplE/bqQ7efAs34hqjwZu/NxIqEUAyQoF7XZTR9JDXs1WNs
         WvneZ2oJMoxtvJSiVQXfMchoYu9JZqJA8gBXADIWOQVNjK7YQlKjBm7Mh4VgqXYdL/OD
         R2qQ==
X-Gm-Message-State: AOAM530RTWM4c/ySTOcJpiE67DDvwquRP/ywNIHAeccD/Mv1KAgYwjV8
        qsedRJex/1xeCfHd+EQysgw=
X-Google-Smtp-Source: ABdhPJyKi9oqeDkhGQvWTO2Uve6HYQX4qmK8dL7/cDIPlauoaG9t0ZPIeEL0L2+9bdCOX/FvaG0hzg==
X-Received: by 2002:aa7:d9d7:: with SMTP id v23mr11219778eds.281.1618591641808;
        Fri, 16 Apr 2021 09:47:21 -0700 (PDT)
Received: from DESKTOP-140QBK5.Home ([151.32.127.129])
        by smtp.gmail.com with ESMTPSA id m14sm2110830edc.18.2021.04.16.09.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 09:47:21 -0700 (PDT)
From:   Stefano De Venuto <stefano.devenuto99@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, dfaggioli@suse.com,
        Stefano De Venuto <stefano.devenuto99@gmail.com>
Subject: [RFC] Simple tool for VMEnters/VMExits matching and trace validation
Date:   Fri, 16 Apr 2021 18:46:53 +0200
Message-Id: <20210416164653.2949-1-stefano.devenuto99@gmail.com>
X-Mailer: git-send-email 2.30.2
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

Signed-off-by: Stefano De Venuto <stefano.devenuto99@gmail.com>
---
 examples/checker.c | 202 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 202 insertions(+)
 create mode 100644 examples/checker.c

diff --git a/examples/checker.c b/examples/checker.c
new file mode 100644
index 0000000..0b04343
--- /dev/null
+++ b/examples/checker.c
@@ -0,0 +1,202 @@
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
+int is_guest(int stream_id,
+	      struct kshark_host_guest_map* mapping,
+	      int n_mapping, int* host)
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
+void print_entry(struct kshark_entry* entry)
+{
+	struct kshark_data_stream* stream;
+	char* event_name;
+	int stream_id;
+
+	stream = kshark_get_stream_from_entry(entry);
+	event_name = kshark_get_event_name(entry);
+
+	stream_id = stream->stream_id;
+	printf("%d: %s-%d, %lld [%03d]:%s\t%s\n",
+		stream->stream_id,
+		kshark_get_task(entry),
+		kshark_get_pid(entry),
+		entry->ts,
+		entry->cpu,
+		event_name,
+		kshark_get_info(entry));
+
+}
+
+void print_entries(struct kshark_entry **entries, ssize_t n_entries)
+{
+	for (int i = 0; i < n_entries; ++i
+		print_entry(entries[i]);
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
+
+	kshark_close_all(kshark_ctx);
+	kshark_free(kshark_ctx);
+}
+
+int main(int argc, char **argv)
+{
+
+	struct kshark_host_guest_map* host_guest_mapping;
+	struct custom_stream** custom_streams;
+	struct custom_stream* custom_stream;
+	struct custom_stream* host_stream;
+	struct kshark_data_stream* stream;
+	struct kshark_context* kshark_ctx;
+	struct kshark_entry** entries;
+	struct kshark_entry* current;
+	ssize_t n_entries;
+	char* event_name;
+	char* token;
+	int n_guest;
+	char* info;
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
+	  printf("Failed mapping: %d\n", n_guest);
+	  return 1;
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
+			if (!strcmp(event_name, KVM_ENTRY)) {
+
+				/*
+				 * The recovering process of the vCPU field of the kvm_entry event
+				 * is done by splitting the info field.
+				 */
+				info = kshark_get_info(current);
+
+				token = strtok(info, " ");
+				token = strtok(NULL, " ");
+
+				/* Removing the last comma */
+				token[strlen(token) - 1] = '\0';
+
+				custom_stream->cpus[current->cpu] = atoi(token);
+
+				free(info);
+			} else {
+				custom_stream->cpus[current->cpu] = -1;
+			}
+
+		} else {
+
+			/*
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
+				if (v_i == host_stream->original_stream->n_cpus) {
+					printf("%d G out:\t", i);
+					print_entry(entries[i]);
+				}
+
+			/*
+			* If the event comes from a host, recover the CPU that executed the event
+			* and check if it's NOT INSIDE a kvm_entry/kvm_exit block.
+			*/
+			} else {
+				if (custom_stream->cpus[current->cpu] != -1) {
+					printf("%d H in:\t", i);
+					print_entry(entries[i]);
+				}
+			}
+		}
+	}
+
+	free_data(kshark_ctx, custom_streams, entries, n_entries, host_guest_mapping, n_guest);
+}
-- 
2.30.2

