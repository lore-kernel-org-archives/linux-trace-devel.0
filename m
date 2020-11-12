Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8FD2C388F9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 01:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 765412074B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 01:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgKLBbC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Nov 2020 20:31:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:53014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728247AbgKLB0d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Nov 2020 20:26:33 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 929CF2067D;
        Thu, 12 Nov 2020 01:26:32 +0000 (UTC)
Date:   Wed, 11 Nov 2020 20:26:30 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] libtracefs: Combine allocate and create APIs
 into one
Message-ID: <20201111202630.18e3dd35@oasis.local.home>
In-Reply-To: <20201110122249.911664-5-tz.stoyanov@gmail.com>
References: <20201110122249.911664-1-tz.stoyanov@gmail.com>
        <20201110122249.911664-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 10 Nov 2020 14:22:47 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>  tracefs_instance_get_file(struct tracefs_instance *instance, const char *file);
> diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
> index 35a41394..397487e5 100644
> --- a/lib/trace-cmd/trace-timesync.c
> +++ b/lib/trace-cmd/trace-timesync.c
> @@ -235,16 +235,15 @@ static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *lport,
>  static struct tracefs_instance *
>  clock_synch_create_instance(const char *clock, unsigned int cid)
>  {
> -	struct tracefs_instance *instance;
> +	struct tracefs_instance *instance = NULL;

Why set instance to NULL? It gets assigned a value in the second line.

-- Steve

>  	char inst_name[256];
>  
>  	snprintf(inst_name, 256, "clock_synch-%d", cid);
>  
> -	instance = tracefs_instance_alloc(inst_name);
> +	instance = tracefs_instance_create(inst_name);
>  	if (!instance)
>  		return NULL;
>  
> -	tracefs_instance_create(instance);
>  	tracefs_instance_file_write(instance, "trace", "\0");
>  	if (clock)
>  		tracefs_instance_file_write(instance, "trace_clock", clock);
