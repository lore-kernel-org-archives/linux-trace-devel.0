Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3FF5C11F68
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEEAA61402
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhGBLwi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 07:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231992AbhGBLwh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 07:52:37 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E8CB61402;
        Fri,  2 Jul 2021 11:50:05 +0000 (UTC)
Date:   Fri, 2 Jul 2021 07:50:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 1/7] libtracefs: Implement tracefs_instances()
Message-ID: <20210702075004.097d5edc@rorschach.local.home>
In-Reply-To: <97c4e671-5ee9-3c1a-b957-1d0b6fbc0eb3@gmail.com>
References: <20210702035443.154729-1-rostedt@goodmis.org>
        <20210702035443.154729-2-rostedt@goodmis.org>
        <4335f4d8-73eb-a2e4-f439-95cbe69acff2@gmail.com>
        <20210702073332.357ca775@rorschach.local.home>
        <97c4e671-5ee9-3c1a-b957-1d0b6fbc0eb3@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 2 Jul 2021 14:39:48 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> > as you stated, but I'll keep it one line.
> >   
> >> 	if (!instances)
> >> 		goto out;
> >>
> >> 	instances[list->size + 1] = NULL;  
> 
> but you still need to make sure it is NULL terminated.

Ah I missed that part of your comment (I'm still sleeping), will send
a v2 ;-)

-- Steve
