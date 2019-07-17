Return-Path: <SRS0=BCkm=VO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79CAEC76186
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 12:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D64A20880
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 12:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfGQMhM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 08:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfGQMhM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 08:37:12 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFC3620880;
        Wed, 17 Jul 2019 12:37:10 +0000 (UTC)
Date:   Wed, 17 Jul 2019 08:37:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] kernel-shark: Initialize the data-related fields of
 the model
Message-ID: <20190717083709.4a56867c@gandalf.local.home>
In-Reply-To: <20190717085306.12393-2-y.karadz@gmail.com>
References: <20190717085306.12393-1-y.karadz@gmail.com>
        <20190717085306.12393-2-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 17 Jul 2019 11:53:05 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> It is particularly important to initialize to zero the "data_size" field
> because its value is used when doing operations like scroll or zoom to
> check if data has been loaded or not. Not having "data_size" set to zero
> can cause segfault (as reported by Steven).
> 
> Reported-By: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204195
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark/src/libkshark-model.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
> index 18f9c69..fd4d876 100644
> --- a/kernel-shark/src/libkshark-model.c
> +++ b/kernel-shark/src/libkshark-model.c
> @@ -36,6 +36,9 @@ void ksmodel_init(struct kshark_trace_histo *histo)
>  	 * Initialize an empty histo. The histo will have no bins and will
>  	 * contain no data.
>  	 */
> +	histo->data_size = 0;
> +	histo->data = NULL;
> +
>  	histo->bin_size = 0;
>  	histo->min = 0;
>  	histo->max = 0;

Are we just trying to set all fields of histo to NULL or zero? If so,
why not just do:

	memset(histo, 0, sizeof(*histo));

?

This will make sure ksmodel_init() zeros all of histo when/if we add new
fields.

-- Steve

