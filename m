Return-Path: <SRS0=6JDs=3K=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F1B4C32771
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Jan 2020 02:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE3C524125
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Jan 2020 02:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgAUCSc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 21:18:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:44880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726890AbgAUCSc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 21:18:32 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A793F2253D;
        Tue, 21 Jan 2020 02:18:31 +0000 (UTC)
Date:   Mon, 20 Jan 2020 21:18:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Marcelo Diop-Gonzalez <marcgonzalez@google.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: free kbuf on malloc err in
 tracecmd_read_page_record()
Message-ID: <20200120211829.4f9e94af@rorschach.local.home>
In-Reply-To: <20200115200515.207711-1-marcgonzalez@google.com>
References: <20200115200515.207711-1-marcgonzalez@google.com>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 15 Jan 2020 15:05:15 -0500
Marcelo Diop-Gonzalez <marcgonzalez@google.com> wrote:

> This fixes an unlikely but possible leak

Applied, thanks Marcelo!

-- Steve

> 
> Signed-off-by: Marcelo Diop-Gonzalez <marcgonzalez@google.com>
> ---
>  lib/trace-cmd/trace-input.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index ac30a60..68da3a7 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -1746,7 +1746,7 @@ tracecmd_read_page_record(struct tep_handle *pevent, void *page, int size,
>  
>  	record = malloc(sizeof(*record));
>  	if (!record)
> -		return NULL;
> +		goto out_free;
>  	memset(record, 0, sizeof(*record));
>  
>  	record->ts = ts;

