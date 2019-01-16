Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E7B0C43387
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 03:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AAF520840
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 03:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbfAPDja (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Jan 2019 22:39:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730481AbfAPDja (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Jan 2019 22:39:30 -0500
Received: from vmware.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9935120840;
        Wed, 16 Jan 2019 03:39:29 +0000 (UTC)
Date:   Tue, 15 Jan 2019 22:39:27 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Taeung Song <treeze.taeung@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2] plugin python: Adjust the handling after
 PyRun_String() failed
Message-ID: <20190115223927.0e6aad61@vmware.local.home>
In-Reply-To: <1493261758-32597-1-git-send-email-treeze.taeung@gmail.com>
References: <1493261758-32597-1-git-send-email-treeze.taeung@gmail.com>
X-Mailer: Claws Mail 3.15.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 27 Apr 2017 11:55:58 +0900
Taeung Song <treeze.taeung@gmail.com> wrote:

> Even though PyRun_String() failed,
> just 0 will be returned but we need to return -1
> that means error status, so fix it.

Ug, I just noticed this patch floating in the flood of my INBOX.

I just applied it, and will be pushing it out soon.

Thanks, and I'm really sorry for not seeing it.

-- Steve

> 
> Signed-off-by: Taeung Song <treeze.taeung@gmail.com>
> ---
>  plugin_python.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/plugin_python.c b/plugin_python.c
> index 2997679..c283ed7 100644
> --- a/plugin_python.c
> +++ b/plugin_python.c
> @@ -55,7 +55,7 @@ static int load_plugin(struct pevent *pevent, const char *path,
>  
>  	free(load);
>  
> -	return 0;
> +	return res ? 0 : -1;
>  }
>  
>  int PEVENT_PLUGIN_LOADER(struct pevent *pevent)

