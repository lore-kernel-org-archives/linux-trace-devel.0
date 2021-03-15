Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5505BC433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 13:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F32B64E83
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 13:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhCONkB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 09:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhCONji (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 09:39:38 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E78F464E83;
        Mon, 15 Mar 2021 13:39:37 +0000 (UTC)
Date:   Mon, 15 Mar 2021 09:39:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, amikhak@wirelessfabric.com
Subject: Re: [PATCH] libtraceevent: Fix build warning on 32-bit arches
Message-ID: <20210315093936.0d9c851c@gandalf.local.home>
In-Reply-To: <20210311103622.1962839-1-tz.stoyanov@gmail.com>
References: <20210311103622.1962839-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Mar 2021 12:36:22 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Fixed a compilation warning for casting to pointer from integer of
> different size on 32-bit platforms.
> 
> Reported-by: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Cc: linux-trace-devel@vger.kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Reported-by: Alan Mikhak  <amikhak@wirelessfabric.com>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
> [
>    Backport from kernel into the libtraceevent repo.
> ]
>

Applied. Thanks Tzvetomir!

-- Steve
