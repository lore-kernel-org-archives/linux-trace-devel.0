Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 536CAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 13:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38CD5611EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 13:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhKDNYC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 09:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231136AbhKDNYB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 09:24:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B17C611EE;
        Thu,  4 Nov 2021 13:21:23 +0000 (UTC)
Date:   Thu, 4 Nov 2021 09:21:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 08/10] libtracefs: Use the internal dynamic events
 API when creating synthetic events
Message-ID: <20211104092122.4eae7e46@gandalf.local.home>
In-Reply-To: <256b3fba-49a1-3082-608a-53c9d35f8757@gmail.com>
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
        <20211104111047.302660-9-tz.stoyanov@gmail.com>
        <256b3fba-49a1-3082-608a-53c9d35f8757@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 4 Nov 2021 14:47:34 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> > @@ -1919,7 +1911,6 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
> >   int tracefs_synth_create(struct tracefs_instance *instance,  
> 
> I wonder is it really necessary this function to take 'tracefs_instance' as argument?
> 
> I remember from conversations with Steven that setting the histograms/triggers in the top instance will have the same 
> effect. Or maybe I am wrong? The same question applies for the 'destroy' API.

Good point.

Yeah, let's make the events global, and just use the top level for creation
and destruction. As events added to the system affect all instances, they
should only be done at the top level.

-- Steve
