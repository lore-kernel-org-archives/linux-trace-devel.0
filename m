Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B001C4743C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 01:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3785760FF2
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 01:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhFVB32 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Jun 2021 21:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230311AbhFVB32 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Jun 2021 21:29:28 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 015CB60FF2;
        Tue, 22 Jun 2021 01:27:12 +0000 (UTC)
Date:   Mon, 21 Jun 2021 21:27:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 06/40] trace-cmd: Add APIs for library initialization
 and free
Message-ID: <20210621212711.4f7469bc@oasis.local.home>
In-Reply-To: <20210610113426.257931-7-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
        <20210610113426.257931-7-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 10 Jun 2021 14:33:52 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The trace-cmd library has no APIs for initialization and free of the
> whole library. Added these new APIs:
>  tracecmd_lib_init()
>  tracecmd_lib_free()

This isn't a very use friendly API.

The reason I see you added this was for zlib, which I don't think is
necessary.

-- Steve



> and call them in trace-cmd main function.
> 
