Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79867C4320E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 21:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 538D860EBC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 21:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhGVUoQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Jul 2021 16:44:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232222AbhGVUoI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Jul 2021 16:44:08 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B66A260C41;
        Thu, 22 Jul 2021 21:24:42 +0000 (UTC)
Date:   Thu, 22 Jul 2021 17:24:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 4/4] trace-cruncher: Allow for detachable kprobes
Message-ID: <20210722172435.3d8f434c@oasis.local.home>
In-Reply-To: <20210712123242.223500-4-y.karadz@gmail.com>
References: <20210712123242.223500-1-y.karadz@gmail.com>
        <20210712123242.223500-4-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 12 Jul 2021 15:32:42 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:


> @@ -1617,8 +1622,9 @@ PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
>  		return NULL;
>  	}
>  
> -	if (!store_new_kprobe(event))
> -		return NULL;
> +	if (!detached)
> +		if (!store_new_kprobe(event))
> +			return NULL;

I wonder if it would be more consistent and helpful if we created a
structure for kprobes like we do for instances, and this way we can
save the "detached" field in that structure, and not free it on destroy.

This way, even though the kprobes are detached it may still be needed
in the future to list all kprobes that were created by the application,
regardless if they are detached or not.

-- Steve
