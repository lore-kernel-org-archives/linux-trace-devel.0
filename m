Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 580A1C6369E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 050F122201
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgLBWn7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 17:43:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728934AbgLBWn6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 17:43:58 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE5C7221F7;
        Wed,  2 Dec 2020 22:43:17 +0000 (UTC)
Date:   Wed, 2 Dec 2020 17:43:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v25 01/16] trace-cmd: Replace time sync protocol ID with
 string
Message-ID: <20201202174316.33a24c92@gandalf.local.home>
In-Reply-To: <20201029111816.247241-2-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
        <20201029111816.247241-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Oct 2020 13:18:01 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> +static int make_trace_req_protos(char **buf, int *size, char **tsync_protos)
>  {
> +	int protos_size = 1;
>  	size_t buf_size;
> +	char **protos;
>  	char *nbuf;
>  	char *p;
>  
> +	protos = tsync_protos;
> +	while (*protos) {
> +		protos_size += strlen(*protos) + 1;
> +		protos++;
> +	}
> +
>  	buf_size = TRACE_REQ_PARAM_SIZE + protos_size;
>  	nbuf = realloc(*buf, *size + buf_size);
>  	if (!nbuf)
> @@ -867,7 +875,13 @@ static int make_trace_req_protos(char **buf, int *size,
>  	*(unsigned int *)p = htonl(protos_size);
>  	p += sizeof(int);
>  
> -	memcpy(p, tsync_protos, protos_size);
> +	protos = tsync_protos;
> +	while (*protos) {
> +		memcpy(p, *protos, strlen(*protos) + 1);

The above can be replaced with:

		strcpy(p, *protos);

-- Steve

> +		p += strlen(*protos) + 1;
> +		protos++;
> +	}
> +	p = NULL;
>  
> 
