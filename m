Return-Path: <SRS0=JSNI=DI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB43C4727E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Oct 2020 16:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08B3220872
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Oct 2020 16:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732107AbgJAQa3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Oct 2020 12:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732104AbgJAQa3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Oct 2020 12:30:29 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F070520848;
        Thu,  1 Oct 2020 16:30:28 +0000 (UTC)
Date:   Thu, 1 Oct 2020 12:30:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     vincent.donnefort@arm.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] trace-cmd: Fix "trace-cmd extract" temp files path
Message-ID: <20201001123027.3903321f@gandalf.local.home>
In-Reply-To: <1601542769-443324-1-git-send-email-vincent.donnefort@arm.com>
References: <1601542769-443324-1-git-send-email-vincent.donnefort@arm.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  1 Oct 2020 09:59:29 +0100
vincent.donnefort@arm.com wrote:

> From: Vincent Donnefort <vincent.donnefort@arm.com>
> 
> During the introduction of instance's output_file copy:
> 
>   3a206ca ("trace-cmd: Have instances include a copy of its output file")
> 
> The extract path has been omitted, causing the temp files created to be
> written in the same directory using the null "output_file" of the
> instance, to create "(null).cpuX" files. If this is executed in a
> directory that is not writable (like /sys/kernel/tracing) or does not
> have enough space to hold the temp files, then it will fail to write.
> 
> Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index bd00457..72a5c8c 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -6622,6 +6622,9 @@ void trace_extract(int argc, char **argv)
>  
>  	/* Save the state of tracing_on before starting */
>  	for_all_instances(instance) {
> +		instance->output_file = strdup(ctx.output);
> +		if (!instance->output_file)
> +			die("Failed to allocate output file name for instance");
>  
>  		if (!ctx.manual && instance->flags & BUFFER_FL_PROFILE)
>  			enable_profile(ctx.instance);

Applied. Thanks Vincent!

-- Steve
