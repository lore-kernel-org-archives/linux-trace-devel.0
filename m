Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 775E0C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 18:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241435AbhKXSOo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 13:14:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243572AbhKXSOl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 13:14:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7EDE6101C;
        Wed, 24 Nov 2021 18:11:29 +0000 (UTC)
Date:   Wed, 24 Nov 2021 13:11:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 01/25] trace-cmd library: Define trace file version 7
Message-ID: <20211124131128.172d5490@gandalf.local.home>
In-Reply-To: <20211111150840.86532-1-tz.stoyanov@gmail.com>
References: <20211111150840.86532-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Nov 2021 17:08:40 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

>  
>  static void add_reset_file(const char *file, const char *val, int prio)
> @@ -5974,6 +5975,7 @@ static void init_common_record_context(struct common_record_context *ctx,
>  	ctx->instance = &top_instance;
>  	ctx->curr_cmd = curr_cmd;
>  	local_cpu_count = tracecmd_count_cpus();
> +	ctx->file_version = FILE_VERSION_DEFAULT;

This should not be exposed to the users of the API.

-- Steve

>  	init_top_instance();
>  }
>  

