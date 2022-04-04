Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05FA9C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 21:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382453AbiDDV37 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379695AbiDDRxb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 13:53:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E47245BD
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 10:51:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 27BEBCE17C5
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 17:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D0AC2BBE4;
        Mon,  4 Apr 2022 17:51:28 +0000 (UTC)
Date:   Mon, 4 Apr 2022 13:51:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] libtracefs: Document uprobes APIs
Message-ID: <20220404135127.1eb8831b@gandalf.local.home>
In-Reply-To: <20220328090347.107849-3-tz.stoyanov@gmail.com>
References: <20220328090347.107849-1-tz.stoyanov@gmail.com>
        <20220328090347.107849-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 28 Mar 2022 12:03:46 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +	do {
> +		tracefs_load_cmdlines(NULL, tep);
> +		tracefs_iterate_raw_events(tep, instance, NULL, 0, callback, NULL);
> +	} while (waitpid(pid, NULL, WNOHANG) != pid);
> +
> +	/* disable and destroy the events */
> +	tracefs_dynevent_destroy(uprobe, true);
> +	tracefs_dynevent_destroy(uretprobe, true);
> +	tracefs_dynevent_free(uprobe);
> +	tracefs_dynevent_free(uretprobe);
> +	tracefs_instance_destroy(instance);
> +
> +	return 0;

I added the missing brace here.

-- Steve

> +--
> +
> +FILES
> +-----
> +[verse]
