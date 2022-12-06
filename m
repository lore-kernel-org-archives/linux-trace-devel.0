Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD59C3A5A7
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Dec 2022 20:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiLFUKO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Dec 2022 15:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiLFUJz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Dec 2022 15:09:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB692E9DF
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Dec 2022 12:08:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83796618BF
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Dec 2022 20:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB2BC433D6;
        Tue,  6 Dec 2022 20:08:15 +0000 (UTC)
Date:   Tue, 6 Dec 2022 15:08:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: Re: [PATCH v2 1/2] libtraceevent: Add boiler-plate code for cpumask
 types
Message-ID: <20221206150813.35b5aa48@gandalf.local.home>
In-Reply-To: <20221116144154.3662923-2-vschneid@redhat.com>
References: <20221116144154.3662923-1-vschneid@redhat.com>
        <20221116144154.3662923-2-vschneid@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Nov 2022 14:41:53 +0000
Valentin Schneider <vschneid@redhat.com> wrote:

> diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
> index f749cc2..2bb0f3e 100644
> --- a/include/traceevent/event-parse.h
> +++ b/include/traceevent/event-parse.h
> @@ -242,6 +242,7 @@ enum tep_print_arg_type {
>  	TEP_PRINT_OP,
>  	TEP_PRINT_FUNC,
>  	TEP_PRINT_BITMASK,
> +	TEP_PRINT_CPUMASK,
>  	TEP_PRINT_DYNAMIC_ARRAY_LEN,
>  	TEP_PRINT_HEX_STR,
>  };

I was about to apply this when I realized that this enum is exposed to
applications. Any new enum must go at the end.

-- Steve
