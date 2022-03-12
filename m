Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B41C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Mar 2022 03:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiCLDTh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Mar 2022 22:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiCLDTg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Mar 2022 22:19:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADE71CB0E
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Mar 2022 19:18:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C39AB82462
        for <linux-trace-devel@vger.kernel.org>; Sat, 12 Mar 2022 03:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C4BC340E9;
        Sat, 12 Mar 2022 03:18:27 +0000 (UTC)
Date:   Fri, 11 Mar 2022 22:18:25 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Issue with trace-cmd 3 and kernelshark
Message-ID: <20220311221825.536d849e@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I just tried the following with trace-cmd 3 on both the host and guest:

 guest> trace-cmd agent

 host> trace-cmd record -e kvm -A guest -e all ssh guest

[ logged in, did an 'ls' then logged out ]

I ended up with a trace.dat and trace-guest.dat

But when I did:

 kernelshark trace.dat -a trace-guest.dat

I ended up with a segfault here (in trace-input.c)

static struct page *allocate_page(struct tracecmd_input *handle,
				  int cpu, off64_t offset)
{
	struct cpu_data *cpu_data = &handle->cpu_data[cpu];
	struct page **pages;
	struct page *page;
	int index;

	index = (offset - cpu_data->file_offset) / handle->page_size;
	if (index >= cpu_data->nr_pages) {
		pages = realloc(cpu_data->pages, (index + 1) * sizeof(*cpu_data->pages));
		if (!pages)
			return NULL;
		memset(pages + cpu_data->nr_pages, 0,
		       (index + 1 - cpu_data->nr_pages) * sizeof(*cpu_data->pages));
		cpu_data->pages = pages;
		cpu_data->nr_pages = index + 1;
	}
	if (cpu_data->pages[index]) {
		cpu_data->pages[index]->ref_count++;  <<---- seg fault here!
		return cpu_data->pages[index];
	}

	page = malloc(sizeof(*page));
	if (!page)
		return NULL;


It appears that it doesn't like the fact that the file is compressed. This
was my worry about compressing date :-/

-- Steve
