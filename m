Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7633C43457
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BE6920E65
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391066AbgJLOF6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 10:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391000AbgJLOFk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 10:05:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B62BF2074D;
        Mon, 12 Oct 2020 14:05:39 +0000 (UTC)
Date:   Mon, 12 Oct 2020 10:05:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 03/20] kernel-shark: Introduce libkshark-hash
Message-ID: <20201012100538.2fb029cd@gandalf.local.home>
In-Reply-To: <20201012100516.29b3f99c@gandalf.local.home>
References: <20201012133523.469040-1-y.karadz@gmail.com>
        <20201012133523.469040-4-y.karadz@gmail.com>
        <20201012100516.29b3f99c@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 12 Oct 2020 10:05:16 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 12 Oct 2020 16:35:06 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
> > So far KernelShark have been using an implementation of a hash table
> > from trace-cmd/include/trace-cmd/trace-filter-hash.h. However it turns
> > that KernelShark is the only user of trace-filter-hash, which means
> > that it make more sense to make this implementation of the hash table
> > part of KernelShark. In this patch we adapt the original trace-cmd
> > implementation and change the naming convention used.
> > 
> > Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> > ---  
> 
> I feel at least the first two patches do not need to be in the "disabled"
> section. Can we move them before patch 1?

I meant patch 2 and 3 before patch 1.

-- Steve

