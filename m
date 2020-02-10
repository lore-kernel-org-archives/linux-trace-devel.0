Return-Path: <SRS0=56ke=36=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEDD6C3B184
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 Feb 2020 08:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADEBD21739
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 Feb 2020 08:50:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hLyMi+0Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbgBJIu1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 03:50:27 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42567 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbgBJIuO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 03:50:14 -0500
Received: by mail-lj1-f195.google.com with SMTP id d10so6146191ljl.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 Feb 2020 00:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LsVbX7qnbD0NR4wbJb0dlzjSRzpBheyaxWE84es4MJw=;
        b=hLyMi+0YTrxkejEbsVJnZSexBJ2LGvaFcdBdvbaHnA6iRVRG2bNVjTpN3TsQOF3aiT
         5cWL1IHI4Gyri4vJ/ScHdt77bmd5f27BoRCS9vjRt6vLtpICVFVMEKp3/Vku8bB5v9E8
         hh8Ze7tX5+/O009O4vri5zSkDrGvTbCXG03nvyILRwwwits55o6+yKGVYisR4rividS7
         0DrHkRP/Mz2sU/8TrzCmK5k7jN+X50GqdcY2woRgyW5SDJHtyfAquUmbNVUmPmSqcwUY
         h7lUmew5qzhx6m71mtbiJQiiCFen5Niz/0f8GhSSRvWM6CYQp9FB6gvuxI/7M6o0TiVT
         xVVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LsVbX7qnbD0NR4wbJb0dlzjSRzpBheyaxWE84es4MJw=;
        b=CEMzmIjK0bTKg+xXeHQf9YRhnUty/o6TYDmCbP2vTuSTZSWMWaLdFKWbSw8j8LAT/l
         QnPN1xNHVdOgXAD/m9IK+mAuxX3kE+Thh7SV7MQlmgB7uMMuWa/KmTuh2h2q2bCqjNs9
         F3CEbX7EeHuLxFmBOT6byWvFOfWkbAjtyjvjG919z6/pNnXpvzpf9yRycRXzzUY6VM6W
         hfXJwFKf5yP5P6h6yJAzEjBnOzGMFNi/KXp+4ffo4GwgqOAuxQArVLVjk5fNnnlb+sGi
         KHD3hqyQx4dXTR28V+5g1B1c0hz90dWQfxnHpXeuY4TfWC8ZFLL2emWbFFczO7oFbCHV
         MZ8Q==
X-Gm-Message-State: APjAAAXK6c2efAaVPZ30ZBmnEFoYoR2PIXDzc93SlUlOTsgampD6b5y3
        m0hpykHA77TJTPkLRyHv3E2jPqfY
X-Google-Smtp-Source: APXvYqwaMgEZ2wy1s01tHlz+T5GxQKvELkYTPMW6sV0f2XeUbXfelcGByYsKvLdq8FwNrFH1J55q3A==
X-Received: by 2002:a2e:965a:: with SMTP id z26mr246083ljh.104.1581324612951;
        Mon, 10 Feb 2020 00:50:12 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u19sm4907063lfu.68.2020.02.10.00.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 00:50:12 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Fix "multiple definition" compiler errors
Date:   Mon, 10 Feb 2020 10:50:10 +0200
Message-Id: <20200210085010.7974-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When compiling with gcc and option "-fno-common", there are
errors because of multiple global variables with the same names.
The "-fno-common" gcc option is turned on by default on gcc 10, so
trace-cmd build fails on this compiler.
Problem in reported by Ziqian SUN (Zamir):
  https://bugzilla.kernel.org/show_bug.cgi?id=206467

Proposed solution: set the variables to be static, as their scope is
only the current C file.

Reported-by: Ziqian SUN (Zamir) <sztsian@gmail.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-hist.c | 40 ++++++++++++++++++++--------------------
 tracecmd/trace-mem.c  | 38 +++++++++++++++++++-------------------
 2 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index c451826..fdfd4a1 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -27,26 +27,26 @@ static int kernel_stack_type;
 
 static int long_size;
 
-struct tep_format_field *common_type_field;
-struct tep_format_field *common_pid_field;
-struct tep_format_field *sched_wakeup_comm_field;
-struct tep_format_field *sched_wakeup_new_comm_field;
-struct tep_format_field *sched_wakeup_pid_field;
-struct tep_format_field *sched_wakeup_new_pid_field;
-struct tep_format_field *sched_switch_prev_field;
-struct tep_format_field *sched_switch_next_field;
-struct tep_format_field *sched_switch_prev_pid_field;
-struct tep_format_field *sched_switch_next_pid_field;
-struct tep_format_field *function_ip_field;
-struct tep_format_field *function_parent_ip_field;
-struct tep_format_field *function_graph_entry_func_field;
-struct tep_format_field *function_graph_entry_depth_field;
-struct tep_format_field *function_graph_exit_func_field;
-struct tep_format_field *function_graph_exit_depth_field;
-struct tep_format_field *function_graph_exit_calltime_field;
-struct tep_format_field *function_graph_exit_rettime_field;
-struct tep_format_field *function_graph_exit_overrun_field;
-struct tep_format_field *kernel_stack_caller_field;
+static struct tep_format_field *common_type_field;
+static struct tep_format_field *common_pid_field;
+static struct tep_format_field *sched_wakeup_comm_field;
+static struct tep_format_field *sched_wakeup_new_comm_field;
+static struct tep_format_field *sched_wakeup_pid_field;
+static struct tep_format_field *sched_wakeup_new_pid_field;
+static struct tep_format_field *sched_switch_prev_field;
+static struct tep_format_field *sched_switch_next_field;
+static struct tep_format_field *sched_switch_prev_pid_field;
+static struct tep_format_field *sched_switch_next_pid_field;
+static struct tep_format_field *function_ip_field;
+static struct tep_format_field *function_parent_ip_field;
+static struct tep_format_field *function_graph_entry_func_field;
+static struct tep_format_field *function_graph_entry_depth_field;
+static struct tep_format_field *function_graph_exit_func_field;
+static struct tep_format_field *function_graph_exit_depth_field;
+static struct tep_format_field *function_graph_exit_calltime_field;
+static struct tep_format_field *function_graph_exit_rettime_field;
+static struct tep_format_field *function_graph_exit_overrun_field;
+static struct tep_format_field *kernel_stack_caller_field;
 
 static int compact;
 
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index 37046fd..5caeeb6 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -30,31 +30,31 @@ static int kmem_cache_alloc_type;
 static int kmem_cache_alloc_node_type;
 static int kmem_cache_free_type;
 
-struct tep_format_field *common_type_field;
+static struct tep_format_field *common_type_field;
 
-struct tep_format_field *kmalloc_callsite_field;
-struct tep_format_field *kmalloc_bytes_req_field;
-struct tep_format_field *kmalloc_bytes_alloc_field;
-struct tep_format_field *kmalloc_ptr_field;
+static struct tep_format_field *kmalloc_callsite_field;
+static struct tep_format_field *kmalloc_bytes_req_field;
+static struct tep_format_field *kmalloc_bytes_alloc_field;
+static struct tep_format_field *kmalloc_ptr_field;
 
-struct tep_format_field *kmalloc_node_callsite_field;
-struct tep_format_field *kmalloc_node_bytes_req_field;
-struct tep_format_field *kmalloc_node_bytes_alloc_field;
-struct tep_format_field *kmalloc_node_ptr_field;
+static struct tep_format_field *kmalloc_node_callsite_field;
+static struct tep_format_field *kmalloc_node_bytes_req_field;
+static struct tep_format_field *kmalloc_node_bytes_alloc_field;
+static struct tep_format_field *kmalloc_node_ptr_field;
 
-struct tep_format_field *kfree_ptr_field;
+static struct tep_format_field *kfree_ptr_field;
 
-struct tep_format_field *kmem_cache_callsite_field;
-struct tep_format_field *kmem_cache_bytes_req_field;
-struct tep_format_field *kmem_cache_bytes_alloc_field;
-struct tep_format_field *kmem_cache_ptr_field;
+static struct tep_format_field *kmem_cache_callsite_field;
+static struct tep_format_field *kmem_cache_bytes_req_field;
+static struct tep_format_field *kmem_cache_bytes_alloc_field;
+static struct tep_format_field *kmem_cache_ptr_field;
 
-struct tep_format_field *kmem_cache_node_callsite_field;
-struct tep_format_field *kmem_cache_node_bytes_req_field;
-struct tep_format_field *kmem_cache_node_bytes_alloc_field;
-struct tep_format_field *kmem_cache_node_ptr_field;
+static struct tep_format_field *kmem_cache_node_callsite_field;
+static struct tep_format_field *kmem_cache_node_bytes_req_field;
+static struct tep_format_field *kmem_cache_node_bytes_alloc_field;
+static struct tep_format_field *kmem_cache_node_ptr_field;
 
-struct tep_format_field *kmem_cache_free_ptr_field;
+static struct tep_format_field *kmem_cache_free_ptr_field;
 
 static void *zalloc(size_t size)
 {
-- 
2.24.1

