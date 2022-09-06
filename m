Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B60ECAAD5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Sep 2022 16:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbiIFQpo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Sep 2022 12:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233681AbiIFQp0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Sep 2022 12:45:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D863D40E19
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Sep 2022 09:25:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A006614A7
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Sep 2022 16:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475EAC433D6;
        Tue,  6 Sep 2022 16:25:04 +0000 (UTC)
Date:   Tue, 6 Sep 2022 12:25:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     lijiazi <jqqlijiazi@gmail.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        "Jiazi.Li" <jiazi.li@transsion.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] ring-buffer: Add barrire in rb_move_tail
Message-ID: <20220906122542.1bab4663@gandalf.local.home>
In-Reply-To: <20220905030209.GA5577@Jiazi.Li>
References: <20220830120854.7545-1-jiazi.li@transsion.com>
        <20220901111320.04b57cb7@gandalf.local.home>
        <20220902031717.GA27303@Jiazi.Li>
        <20220902085641.32ba1651@gandalf.local.home>
        <20220905030209.GA5577@Jiazi.Li>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 5 Sep 2022 11:23:14 +0800
lijiazi <jqqlijiazi@gmail.com> wrote:

> >From ramdump, current reader page's commit is 0xff0, not bigger than  
> BUF_PAGE_SIZE:
> crash> struct buffer_page 0xffffffd10b599580 -x  
> struct buffer_page {
>   list = {
>     next = 0xffffffd10b599500,
>     prev = 0xffffffd10b599680
>   },
>   write = {
>     a = {
>       counter = 0x100ff0
>     }
>   },
>   read = 0xfd4,
>   entries = {
>     a = {
>       counter = 0x100053
>     }
>   },
>   real_end = 0xfd4,
>   page = 0xffffffd10b553000
> }
> crash> struct buffer_data_page 0xffffffd10b553000 -x  
> struct buffer_data_page {
>   time_stamp = 0xe2679ca0cd3d,
>   commit = {
>     a = {
>       counter = 0xff0
>     }
>   },
>   data = 0xffffffd10b553010 "\b"
> }
> I also can extrace trace log from ramdump by crash-trace extension tool:
> bsp: <...>-32191 [006] 249032.606401: signal_generate:      sig=17 errno=0 code=1 comm=WifiDiagnostics pid=1535 grp=1 res=1
> bsp: <...>-32183 [006] 249032.625192: sched_process_exit:   comm=osi_bin pid=32183 prio=120
> bsp: <...>-32196 [006] 249033.677333: sched_process_exit:   comm=ip pid=32196 prio=120
> bsp: <...>-32196 [006] 249033.677562: signal_generate:      sig=17 errno=0 code=1 comm=sh pid=32195 grp=1 res=0
> Above logs is on reader page, reader task try to read PADDING event
> after this event and lead to crash.

Ah, it's not an issue with the commit value but the write value.

Can you test this patch.

-- Steve

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d59b6a328b7f..6bf7706bb33b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2608,6 +2608,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 		/* Mark the rest of the page with padding */
 		rb_event_set_padding(event);
 
+		/* Make sure the padding is visible before the write update */
+		smp_wmb();
+
 		/* Set the write back to the previous setting */
 		local_sub(length, &tail_page->write);
 		return;
@@ -4580,6 +4583,13 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	goto again;
 
  out:
+	/* If the write is past the end of page, a writer is still updating it */
+	if (reader && reader->write > BUF_PAGE_SIZE)
+		reader = NULL;
+
+	/* Make sure we see any padding after the write update */
+	smp_rmb();
+
 	/* Update the read_stamp on the first event */
 	if (reader && reader->read == 0)
 		cpu_buffer->read_stamp = reader->page->time_stamp;
