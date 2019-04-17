Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554A1C282DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 16:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3015F2173C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 16:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732007AbfDQQTL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 12:19:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732634AbfDQQTL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 12:19:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BECC20674;
        Wed, 17 Apr 2019 16:19:10 +0000 (UTC)
Date:   Wed, 17 Apr 2019 12:19:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, pauld@redhat.com,
        ykaradzhov@vmware.com, jbacik@fb.com, tstoyanov@vmware.com,
        slavomir.kaslev@gmail.com
Subject: Re: [PATCH v4 2/2] trace-cmd: Document record --no-filter option in
 record's man page
Message-ID: <20190417121908.2e244706@gandalf.local.home>
In-Reply-To: <20190417130959.10064-3-kaslevs@vmware.com>
References: <20190417130959.10064-1-kaslevs@vmware.com>
        <20190417130959.10064-3-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 17 Apr 2019 16:09:59 +0300
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> Add a section about the new --no-filter argument of `trace-cmd record`
> to its man page.
> 
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> ---
>  Documentation/trace-cmd-record.1.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
> index 68afa16..b230aa8 100644
> --- a/Documentation/trace-cmd-record.1.txt
> +++ b/Documentation/trace-cmd-record.1.txt
> @@ -83,6 +83,10 @@ OPTIONS
>  
>      The above are usually safe to use to compare fields.
>  
> +*--no-filter*::
> +    Do not set any event filters, including the default one which ignores events
> +    caused by trace-cmd itself.

Actually, this is wrong and so is the help message.

It should be:

  *--no-filter*::
	Do not filter out the trace-cmd threads. By default, the
	threads are filtered out to not be traced by events. This
	option will have the trace-cmd threads also be traced.

And the help message should be:

 # trace-cmd record -h
  [..]
  --no-filter include trace-cmd threads in the trace

Want to resend this patch and also fix the help message (assume it is
applied).

Thanks!

-- Steve

> +
>  *-R* 'trigger'::
>      Specify a trigger for the previous event. This must come after a *-e*. 
>      This will add a given trigger to the given event. To only enable the trigger

