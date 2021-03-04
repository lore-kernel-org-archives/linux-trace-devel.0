Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB75C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Mar 2021 18:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12FC164F11
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Mar 2021 18:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhCDSeU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Mar 2021 13:34:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:59466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234729AbhCDSeL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Mar 2021 13:34:11 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD2DE64F60;
        Thu,  4 Mar 2021 18:33:29 +0000 (UTC)
Date:   Thu, 4 Mar 2021 13:33:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Dario Faggioli <dfaggioli@suse.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: trace-cmd and host-guest tracing
Message-ID: <20210304133328.56b99adc@gandalf.local.home>
In-Reply-To: <CAPpZLN4mySHF=z03gqGv1ZEa_a5Q4su6aP1F_MsG22e=GATyHQ@mail.gmail.com>
References: <CAPpZLN4mySHF=z03gqGv1ZEa_a5Q4su6aP1F_MsG22e=GATyHQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 4 Mar 2021 17:52:58 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> Hi Dario,
> We decided to simplify opening trace files with host and guest trace data
> and changed a little bit the logic and the APIs. Now the timestamps in the
> guest file are recalculated by default, when the file is opened. Even if
> the file is opened standalone. This makes the logic, described in Bugzilla
> issue obsolete:
>     https://bugzilla.kernel.org/show_bug.cgi?id=211657

Tzvetomir,

Can you add this information into that bugzilla too?

Thanks!

-- Steve

> and the issue is not relevant any more. Moreover, the APIs described there
> are removed, as not needed any more.
> I hope that no one started working on that yet.
> 

