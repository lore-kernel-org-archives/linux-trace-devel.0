Return-Path: <SRS0=+svU=DH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FBAC4727F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 08:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FB082184D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 08:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbgI3IbK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 04:31:10 -0400
Received: from foss.arm.com ([217.140.110.172]:59436 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgI3IbK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 04:31:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 48C74D6E;
        Wed, 30 Sep 2020 01:31:09 -0700 (PDT)
Received: from e120877-lin.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CDBAA3F6CF;
        Wed, 30 Sep 2020 01:31:08 -0700 (PDT)
Date:   Wed, 30 Sep 2020 09:31:02 +0100
From:   Vincent Donnefort <vincent.donnefort@arm.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: fix extract output option
Message-ID: <20200930083102.GA90046@e120877-lin.cambridge.arm.com>
References: <1601401766-54400-1-git-send-email-vincent.donnefort@arm.com>
 <20200929163152.4c2606a1@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929163152.4c2606a1@gandalf.local.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Sep 29, 2020 at 04:31:52PM -0400, Steven Rostedt wrote:
> On Tue, 29 Sep 2020 18:49:26 +0100
> vincent.donnefort@arm.com wrote:
> 
> > From: Vincent Donnefort <vincent.donnefort@arm.com>
> > 
> > During the introduction of instance's output_file copy:
> > 
> >   3a206ca ("trace-cmd: Have instances include a copy of its output file")
> > 
> > The extract path has been omitted, leading to a broken output option:
> > 
> >   $ trace-cmd extract -o /foo/bar.dat # Will fallback to ./trace.dat
> 
> When I tried this it worked fine to me. But then I walked through the logic
> via gdb and found that the intermediate step (the one that writes the
> individual buffers directly), which can be an issue if you happen to
> execute this in a directory that you can not write to, or doesn't have
> enough space to hold all the data. Thus your patch is correct, but the
> change log is not.
> 
> Do you really see "trace.dat" at the end of that command? Because I
> see /foo/bar.dat.
> 
> But if I try to run the extract in /sys/kernel/tracing, it will fail
> because it will try to write "(null).cpuX" where X is the CPU number.
> 
> But the creation of the actual file uses ctx->output, which is what we want.
> 
> Anyway, I'll update the change log to this:
> 
>     During the introduction of instance's output_file copy:
> 
>       3a206ca ("trace-cmd: Have instances include a copy of its output file")
> 
>     The extract path has been omitted, causing the temp files created to be
>     written in the same directory using the null "output_file" of the
>     instance, to create "(null).cpuX" files. If this is executed in a
>     directory that is not writable (like /sys/kernel/tracing) or does not
>     have enough space to hold the temp files, then it will fail to write.
> 
> Fair?
> 
> -- Steve

Apologies, the description (... and my testing) was indeed incorrect. The
output is working fine, the problem being only the temporary files.

No problem with the updated commit description. We probably need to update
the short description as well:

  "trace-cmd: Fix extract temporary files path" ?

-- 
Vincent

