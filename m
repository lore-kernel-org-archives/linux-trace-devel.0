Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC94ECAAD4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Aug 2022 12:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiH3MJi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Aug 2022 08:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiH3MJg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Aug 2022 08:09:36 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBD3FE352
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Aug 2022 05:09:33 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id x23so10904722pll.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Aug 2022 05:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc;
        bh=W1aI8vURAkCObV17VJYryoSMpfco8L6VqWQa8GIymhM=;
        b=jyymt5JeytZWqSq60uj7EiWfBEbbN0H5mO5PVsUaaFyGr9X2e8HvKHCXiKI7AdKnGI
         PHZ5ONvje99j3ZZUgr5rreyxjVYiYNqUPTvKmhnaJcbnIkOLkLY1v/d1H+IvIzEyRiol
         r2NtKT8qNUoLxy9A4n9HlynliOD0QbHs6fLEe4wgWp5I+u8tRh/nUjSupxHEURKJwBf8
         LbRwZUgUeOiC5n/Kkv//4WJ9X/yQmyUYo1y6e9J0dmLPoEi/ryE0nna/xYDxIyRsy0xd
         xS82bIzOqdRsD5yFnI6IpnnwCC97adJ7Rj1gw8GcRSeCVD4Z6QvFvqMF2Y5uvo/BNEYj
         sKUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=W1aI8vURAkCObV17VJYryoSMpfco8L6VqWQa8GIymhM=;
        b=vPfKWz4/VaT/hwniVy8QIJm4sZ1+NdT7/GW1HmJwSJTw48XCubSQCz7vvoCfZM8p6b
         nrxlcIZFDZljAzPBv3w6dY6srAGIfnzd99UPAkHuhtlUjbFRwP+eW4jVSSO6LoJ5P48W
         zneSe4I4GleBqGkuCknjtDL1ab7pThw2xIijdyYHUBDWByCfi1fiTVBpU09TRRWSE+5Q
         cjsXC9aUelzvNCLHzG4PI2429AdKgIVxuB7D/odEI6tUI8rsyosFaC/DvXU6txpRZxT/
         OUJ0Qt72J6r7n7faJDZnkyzhGGbx5DIQIO8jDonJreaiLMYcje8SS5ATku4zo6E9Bdvi
         avWg==
X-Gm-Message-State: ACgBeo1EOVl+TrOl4FKeTo73IytqdpB7YkxD8gZiixErRqSn9LEKfUrU
        /GmFCiokVRp3qBRD8mmW4fA=
X-Google-Smtp-Source: AA6agR5knCo2IAZ4MVJFJJlgGaV3PbB/BHZbfwj9JZHI7H6R3C2ZBVlwqZrI10IJk+nx0AFqmTFdjg==
X-Received: by 2002:a17:902:c402:b0:175:3786:aac0 with SMTP id k2-20020a170902c40200b001753786aac0mr499642plk.130.1661861372713;
        Tue, 30 Aug 2022 05:09:32 -0700 (PDT)
Received: from localhost ([58.34.94.196])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090340cd00b00174923afa8asm5810461pld.3.2022.08.30.05.09.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Aug 2022 05:09:31 -0700 (PDT)
From:   "Jiazi.Li" <jqqlijiazi@gmail.com>
X-Google-Original-From: "Jiazi.Li" <jiazi.li@transsion.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Cc:     "Jiazi.Li" <jiazi.li@transsion.com>,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH] ring-buffer: Add barrire in rb_move_tail
Date:   Tue, 30 Aug 2022 20:08:54 +0800
Message-Id: <20220830120854.7545-1-jiazi.li@transsion.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The following crash issue was encountered several times when read
trace_pipe:

1. in ring_buffer_event_data, found event's type is bigger than
RINGBUF_TYPE_DATA_TYPE_LEN_MAX, print WARNING:
[249033.677658]WARNING: CPU: 1 PID: 9975 at ring_buffer_event_data+0x38/0x48

2. trace_read_pipe print this event resulting in crash issue:
[249033.806200] die+0xac/0x37c
[249033.806891] die_kernel_fault+0x60/0x70
[249033.807710] die_kernel_fault+0x0/0x70
[249033.808518] do_bad_area+0x30/0x130
[249033.809296] do_translation_fault+0x34/0x40
[249033.810158] do_mem_abort+0x4c/0xf8
[249033.810935] el1_da+0x1c/0xac
[249033.811647] string+0x38/0x74
[249033.812357] vsnprintf+0x430/0x65c
[249033.813122] seq_buf_vprintf+0x64/0xcc
[249033.813934] trace_seq_printf+0x70/0xd8
[249033.814755] trace_raw_output_ipi_handler+0x40/0x54
[249033.815705] print_trace_line+0x3ec/0x424
[249033.816547] tracing_read_pipe+0x28c/0x3ec
[249033.817402] __vfs_read+0x44/0x13c
[249033.818166] vfs_read+0xb8/0x150
[249033.818908] ksys_read+0x6c/0xcc
[249033.819651] __arm64_sys_read+0x18/0x20
[249033.820470] el0_svc_common+0x98/0x160
[249033.821278] el0_svc_handler+0x60/0x78
[249033.822086] el0_svc+0x8/0x300

ipi event is not enable in my device, the event tracing_read_pipe
want to print is a PADDING event generated in rb_move_tail.
array[0] of this event is 0x18, ipi entry trace event's type value
is 0x18 too in my device.
so trace_read_pipe call trace_raw_output_ipi_handler to print this
event, eventually, system crash because illegal pointers.

In ring_buffer_peek, PADDING type event will not return to caller.
So at least when ring_buffer_peek is called, this event has not
been set to PADDING.

My reader task poll on trace_pipe and other files, wakeup
by other files and found that trace ring_buffer is not empty
because of read != commit.
But maybe because of cpu out-of-order execution, new event has not
been set to PADDING type, and leads to above issue.

Can we fix this issue by add a barrier between rb_reset_tail
and rb_end_commit?
Or are there other bugs that cause this issue?

Signed-off-by: Jiazi.Li <jiazi.li@transsion.com>
---
 kernel/trace/ring_buffer.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d59b6a328b7f..20f3ef839467 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2717,6 +2717,11 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 
 	rb_reset_tail(cpu_buffer, tail, info);
 
+	/*
+	 * Add barrier to make sure tail event be set to
+	 * PADDING type before update commit.
+	 */
+	smp_mb();
 	/* Commit what we have for now. */
 	rb_end_commit(cpu_buffer);
 	/* rb_end_commit() decs committing */
-- 
2.17.1

