Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBF6C38145
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Sep 2022 14:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbiIBOOF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Sep 2022 10:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238808AbiIBONZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Sep 2022 10:13:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D19117AAF
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Sep 2022 06:41:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1899B82AC5
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Sep 2022 12:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F46C433D6;
        Fri,  2 Sep 2022 12:56:08 +0000 (UTC)
Date:   Fri, 2 Sep 2022 08:56:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     lijiazi <jqqlijiazi@gmail.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        "Jiazi.Li" <jiazi.li@transsion.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] ring-buffer: Add barrire in rb_move_tail
Message-ID: <20220902085641.32ba1651@gandalf.local.home>
In-Reply-To: <20220902031717.GA27303@Jiazi.Li>
References: <20220830120854.7545-1-jiazi.li@transsion.com>
        <20220901111320.04b57cb7@gandalf.local.home>
        <20220902031717.GA27303@Jiazi.Li>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 2 Sep 2022 11:47:58 +0800
lijiazi <jqqlijiazi@gmail.com> wrote:

> Yes, I'm thinking this may be a race issue too.
> But I didn't find race point through code review.

I think I may have found it. Can you test this patch?

[ Disclaimer, I did not even try to compile it ]

-- Steve

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d59b6a328b7f..0f47e68fee9b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4580,6 +4580,10 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	goto again;
 
  out:
+	/* If the commit is past the end of page, a writer is still updating it */
+	if (reader && rb_page_size(reader) > BUF_PAGE_SIZE)
+		reader = NULL;
+
 	/* Update the read_stamp on the first event */
 	if (reader && reader->read == 0)
 		cpu_buffer->read_stamp = reader->page->time_stamp;
