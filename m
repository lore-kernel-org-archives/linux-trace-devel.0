Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D28EB64DA
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 Jul 2023 00:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbjGFANM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 20:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjGFANE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 20:13:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C4519A6
        for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jul 2023 17:13:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C6D7617CF
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jul 2023 00:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44194C433C8;
        Thu,  6 Jul 2023 00:13:02 +0000 (UTC)
Date:   Wed, 5 Jul 2023 20:13:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     avidanborisov@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] trace-cmd record: Add --daemonize
Message-ID: <20230705201300.006a5a14@gandalf.local.home>
In-Reply-To: <20230626091635.3002827-2-avidanborisov@gmail.com>
References: <20230530045119.30c8d973@rorschach.local.home>
        <20230626091635.3002827-1-avidanborisov@gmail.com>
        <20230626091635.3002827-2-avidanborisov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 26 Jun 2023 12:16:32 +0300
avidanborisov@gmail.com wrote:

> +		if (do_daemonize) {
> +			daemonize_finish();
> +			printf("Send SIGINT to pid %d to stop recording\n", getpid());

I wonder if we should also add SIGTERM, as that's the default signal used by "kill".

It would suck to have a nice trace going and then execute "kill $pid" only
to find out it killed the process and didn't finish processing it.

-- Steve


> +		} else {
> +			/* sleep till we are woken with Ctrl^C */
> +			printf("Hit Ctrl^C to stop recording\n");
> +		}
