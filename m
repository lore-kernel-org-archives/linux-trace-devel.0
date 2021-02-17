Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 460B2C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Feb 2021 19:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1576864DF0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Feb 2021 19:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbhBQTrt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 14:47:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232854AbhBQTrZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 14:47:25 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 484A664DF0;
        Wed, 17 Feb 2021 19:46:45 +0000 (UTC)
Date:   Wed, 17 Feb 2021 14:46:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] trace-cmd: Fix broken listener and add error checks
Message-ID: <20210217144643.2f692e57@gandalf.local.home>
In-Reply-To: <20210217042341.1675546-3-tz.stoyanov@gmail.com>
References: <20210217042341.1675546-1-tz.stoyanov@gmail.com>
        <20210217042341.1675546-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


> @@ -634,11 +638,12 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
>  	stop_msg_handle = msg_handle;
>  
>  	/* Now we are ready to start reading data from the client */
> -	if (msg_handle->version == V3_PROTOCOL)
> -		tracecmd_msg_collect_data(msg_handle, ofd);
> -	else
> +	if (msg_handle->version == V3_PROTOCOL) {
> +		ret = tracecmd_msg_collect_data(msg_handle, ofd);
> +	} else {
>  		collect_metadata_from_client(msg_handle, ofd);
> -
> +		ret = 0;
> +	}

We should have collect_metadata_from_client() return an error too, and keep
the if statement simple (no need for brackets);

	if (msg_handle->version == V3_PROTOCOL)
		ret = tracecmd_msg_collect_data(msg_handle, ofd);
	else
		ret = collect_metadata_from_client(msg_handle, ofd);

There's a few "pdie"s in that function that should be converted to error
returns.

-- Steve


>  	stop_msg_handle = NULL;
>  
>  	/* wait a little to let our readers finish reading */
