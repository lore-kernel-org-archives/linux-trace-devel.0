Return-Path: <SRS0=YrCp=AD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7959C433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 13:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADAB920679
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 13:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgFVNoL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 09:44:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbgFVNoL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 09:44:11 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3E7820738;
        Mon, 22 Jun 2020 13:44:10 +0000 (UTC)
Date:   Mon, 22 Jun 2020 09:44:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/4] Synchronize libtraceevent with kernel tree
Message-ID: <20200622094409.0c8f8895@oasis.local.home>
In-Reply-To: <20200622074554.151747-1-tz.stoyanov@gmail.com>
References: <20200622074554.151747-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Jun 2020 10:45:50 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Backported few traceevent library patches from kernel's tools/lib/traceevent
> 
> He Zhe (1):
>   trace-cmd: traceevent: Take care of return value of asprintf
> 
> Hewenliang (1):
>   trace-cmd traceevent: Fix memory leakage in filter_event
> 
> Paolo Bonzini (1):
>   trace-cmd traceevent: update KVM plugin
> 
> Zou Wei (1):
>   trace-cmd libtraceevent: Remove unneeded semicolon
> 

Hi Tzvetomir,

Thanks for doing this, but as you did the backporting, it is still
required that you add your "Signed-off-by" to the bottom of each patch.

Cheers!

-- Steve
