Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3138FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Mar 2022 01:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbiCCBKv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 20:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbiCCBKv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 20:10:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1961168ED
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Mar 2022 17:10:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6A4E611A5
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Mar 2022 01:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E2CC004E1;
        Thu,  3 Mar 2022 01:10:05 +0000 (UTC)
Date:   Wed, 2 Mar 2022 20:10:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     sebastian@breakpoint.cc, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 4/5] trace-cmd: Add context to compression hooks
Message-ID: <20220302201004.4c19f84f@gandalf.local.home>
In-Reply-To: <20220302045131.387658-5-tz.stoyanov@gmail.com>
References: <20220302045131.387658-1-tz.stoyanov@gmail.com>
        <20220302045131.387658-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  2 Mar 2022 06:51:30 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -453,6 +460,8 @@ struct tracecmd_compression *tracecmd_compress_alloc(const char *name, const cha
>  void tracecmd_compress_destroy(struct tracecmd_compression *handle)
>  {
>  	tracecmd_compress_reset(handle);
> +	if (handle->proto->free_context)
> +		handle->proto->free_context(handle->context);
>  	free(handle);
>  }
>  

I segfaulted here with:

	# trace-cmd restore -c -o /tmp/head

Need to test handle is NULL or not.

Perhaps even just exit normally at the start?

	if (!handle)
		return;

Which makes it not crash.

-- Steve
