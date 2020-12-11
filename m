Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07A7C4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 22:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 935BA2065D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 22:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390485AbgLKV6I (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 16:58:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393178AbgLKV51 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 16:57:27 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2759B23B85;
        Fri, 11 Dec 2020 21:56:45 +0000 (UTC)
Date:   Fri, 11 Dec 2020 16:56:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 18/32] kernel-shark: Complete the stream integration
Message-ID: <20201211165643.566e4c46@gandalf.local.home>
In-Reply-To: <20201211165106.78f5c44d@gandalf.local.home>
References: <20201211150756.577366-1-y.karadz@gmail.com>
        <20201211150756.577366-19-y.karadz@gmail.com>
        <20201211165106.78f5c44d@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 11 Dec 2020 16:51:06 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> > +/**
> > + * Register to the data stream all default plugins for FTRACE (trace-cmd) data.
> > + */
> > +int kshark_tep_handle_plugins(struct kshark_context *kshark_ctx, int sd)
> > +{
> > +	int i, n_tep_plugins = ARRAY_SIZE(tep_plugin_names);  
> 
> Note, ARRAY_SIZE() isn't defined when this patch is applied, and the build
> fails.

I see later it is removed by patch 30. Best to fold that into this one.

-- Steve
