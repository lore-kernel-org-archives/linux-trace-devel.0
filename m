Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 942A4C3DA6F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Aug 2023 22:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243800AbjHXWDH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 18:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243815AbjHXWCz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 18:02:55 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C825A1BE6
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 15:02:49 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-7927f241772so5802639f.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 15:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692914569; x=1693519369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FM7SYfrI/+KFijNFhpyer5yIkwLtVlNI9FctK9/Fg+M=;
        b=T1HTZNsasQeoLHx3+H+cmKB/rnDXqujHcUh5alGvGGTINTqFxQrPhG8ggLgrNmSwB1
         1SNLvmXoeM4PTtFD1sAB27NgHj7lmZLseyvWzyXhzbuLXv65V/JqcUom56pbFYzi1xEh
         GEy7iEIo9oOTVHTLUO27739J/WkNtnSKe/o0opP0jax5bY4lM+H09TTqkOIftJuVkUDP
         YXoviFx+3adf29XD9ARCuRCzoYVP+ir51+lgpNS2sglN1nsqM+kazjH4BXVEiR58vevd
         6rZ0H3BCAavxB0dBO7ttkqFgDLV/c1o4Tvs3b33HLEptYLjpCRIcjMCHtTB1bcieCHmu
         tLVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692914569; x=1693519369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FM7SYfrI/+KFijNFhpyer5yIkwLtVlNI9FctK9/Fg+M=;
        b=F1qsyxiXEI5b75Z8T9K5MCtPW2590VTrAgL+rJkAjx1bzqmy69n1lmvAI53vpPkFqj
         /jpKWyaX9T1Fz/4eAObhhdCA6kpgVCEB8uLFvB9OQsCHf/TbrpmCNEAaQ0z7hNxQ1sBn
         JvBwHzJO4zdvkQDZoV28Yi976x9Ncs+qnl+V4ysqvw4hr07xr/hZlCB1U0zXuVPWM/mx
         Pc2Is3Atz9FlrLr+UiiAOGK4YlIHKqs4Z+hfvIJkNnl7R217jMw+uGqfPIQCzKDzuZGN
         zxnAyq7UzgmXUYLsNu8Q/zL3UqPqZjvyaCqMewhXEr0wTxsBlvXDS3CB+BcqSK7bXdbg
         VTvg==
X-Gm-Message-State: AOJu0YyADe1rfIMPshb79qAX9eTVQAzMFKMugQgn48L8GKc1VtltLqTI
        H9FYfnwZ9KivyrMOO9iLcRupt2kOV0DEcgTCP1Zm5A==
X-Google-Smtp-Source: AGHT+IGL2SROu9KBEHg8ZNeDYM0iGqsyNj7qkxh1/FVnnhUG/nz7hSVoNbxRk840o2MgxfrjrR55Sg==
X-Received: by 2002:a05:6602:210f:b0:790:c461:6f34 with SMTP id x15-20020a056602210f00b00790c4616f34mr8092927iox.3.1692914569090;
        Thu, 24 Aug 2023 15:02:49 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:12f4:1fa1:277e:6e17])
        by smtp.gmail.com with ESMTPSA id dp22-20020a056602069600b00791e6ae3aa4sm68144iob.23.2023.08.24.15.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 15:02:48 -0700 (PDT)
Date:   Thu, 24 Aug 2023 16:02:44 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH 9/9] libtraceeval: Only do stats on values marked with
 the STAT flag
Message-ID: <20230824220244.GH110858@google.com>
References: <20230817222422.118568-1-rostedt@goodmis.org>
 <20230817222422.118568-10-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817222422.118568-10-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Aug 17, 2023 at 06:24:22PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Add TRACEEVAL_FL_STAT to perform stats on the value, otherwise ignore it.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/traceeval-hist.h | 1 +
>  samples/task-eval.c      | 1 +
>  src/histograms.c         | 2 +-
>  3 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index 81fe805e691d..34f01a51a334 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
> @@ -36,6 +36,7 @@ enum traceeval_flags {
>  	TRACEEVAL_FL_VALUE		= (1 << 1),
>  	TRACEEVAL_FL_SIGNED		= (1 << 2),
>  	TRACEEVAL_FL_TIMESTAMP		= (1 << 3),
> +	TRACEEVAL_FL_STAT		= (1 << 3),

	TRACEEVAL_FL_STAT		= (1 << 4),

>  };
>  
>  /*
> diff --git a/samples/task-eval.c b/samples/task-eval.c
> index ed3a1a95f097..0e3acb7644ef 100644
> --- a/samples/task-eval.c
> +++ b/samples/task-eval.c
> @@ -147,6 +147,7 @@ static struct traceeval_type delta_vals[] = {
>  	{
>  		.type	= TRACEEVAL_TYPE_NUMBER_64,
>  		.name	= "delta",
> +		.flags = TRACEEVAL_FL_STAT,
>  	},
>  	{
>  		.type	= TRACEEVAL_TYPE_NONE,
> diff --git a/src/histograms.c b/src/histograms.c
> index 973bf3ad279c..8f1cf4187713 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -571,7 +571,7 @@ static int copy_traceeval_data(struct traceeval_type *type,
>  		return 0;
>  	}
>  
> -	if (!stat)
> +	if (!stat || !(type->flags & TRACEEVAL_FL_STAT))

I think we actually want to check the TRACEEVAL_FL_STAT flag in is_stat_type()
and then use that check here.  This will help cover other cases where the type
means we can keep stats (values which are numbers) but we can bail if the flag
isn't set.

This will cover traceeval_stat() and traceeval_iterator_stat().

>  		return 0;
>  
>  	if (!stat->count++) {
> -- 
> 2.40.1
> 
