Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ECAFC7EE43
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Aug 2023 21:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbjHXVKF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 17:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242721AbjHXVJl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 17:09:41 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98851BC9
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 14:09:39 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-79233311de2so8748539f.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 14:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692911379; x=1693516179;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zsukliciXaQmc1PwDcQx7pQaQbNFnLQSfYSjTkO4wHI=;
        b=kiuqy4gMjU0FaQjK253whBAd7taBTfqYEnoB0eDlj66cLE+jlODgpFYPfd+QeP6c/C
         i6a0h0op2/o/YPQfxztdZ5lU9q+n+grIFzJzYHVFM4cpd2DAA/n9dmRFSIYBEsS+YiBK
         qBh9iRN7lATTGfcq4krDFqkj81u44OKLcsRZCnD5hoVrKqMJbtzDmc9+fE7p/wT99nS7
         eXAdq5WjrfcFxmGXCV2IsNLo5FtpKTX+MVh5cwHHc9LMGBZUChVJH89UWzHAgMjxcUmj
         rRslmALboyjLduSTAWrKq1zYWkDIDgsS+zbDJv8v78QUhIuvBVMtNCD/FC3cgox9c4Ms
         PK6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692911379; x=1693516179;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zsukliciXaQmc1PwDcQx7pQaQbNFnLQSfYSjTkO4wHI=;
        b=k3Tty5WlJm+6BcCYhmqmyvOoxiK5T8Ab4XptarJ1cwiOqg62mmF9ZxWC+WJM/r3KQc
         5MAdsw+mvTgu/6LNCZhGUbhuqlkZd0/D96cZPPdYLlH5aMSGYVQ2EDatRN0KOSMT8YjQ
         MWRnmSixQYW8KtnHx4BJB/yvySy+0cG+LLhQBY2Akdq8ASjIEp/q9zxub6g6wmdEP0vv
         xND0DiRhqHSbIdmzsU04WrBGAp0MnXPqCQ2jq+MblQHjndMPZvWhSneIaplTfRbtkhrE
         Y0+3Utq8ArEAmQq/qbQ2gOXmeDR7LNTbqeLQv3m0Pf1OtNiar8IT1emQQYlHYzIcdLmc
         N2xQ==
X-Gm-Message-State: AOJu0YyAMwwOc3tuKWXo2mkLoPBI3Lo4QMbUcfuR9JeNciv4jf0zUEBp
        KTeam5TwrARRd2JGsPIyUn79HA==
X-Google-Smtp-Source: AGHT+IGxGtg1n9Y5p+JiEdYABFJ3gvRiCFOB7EsY2kCX+XBX+gF3mp9IsEcQqXgqLIE4tjeZDLrodw==
X-Received: by 2002:a6b:620d:0:b0:787:34d:f223 with SMTP id f13-20020a6b620d000000b00787034df223mr7197037iog.11.1692911378982;
        Thu, 24 Aug 2023 14:09:38 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:12f4:1fa1:277e:6e17])
        by smtp.gmail.com with ESMTPSA id a12-20020a029f8c000000b0042b0f3f9367sm88975jam.129.2023.08.24.14.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 14:09:38 -0700 (PDT)
Date:   Thu, 24 Aug 2023 15:09:34 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH 5/9] libtraceeval histogram: Add type to traceeval_data
 and make it a structure
Message-ID: <20230824210934.GF110858@google.com>
References: <20230817222422.118568-1-rostedt@goodmis.org>
 <20230817222422.118568-6-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817222422.118568-6-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Aug 17, 2023 at 06:24:18PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Having a straight union for passing in the data that must match the types
> is dangerous and prone for buggy code. If some data doesn't match its
> type, there's nothing to catch it.
> 
> Instead of having a union traceeval_data of each type, have it be a
> structure with a "type" field follow by a union, where the type defines
> what kind of data it is.
> 
> Add helper macros to make it easy to define the data when using it.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/traceeval-hist.h |  88 ++++++++++++++++---------
>  samples/task-eval.c      | 137 ++++++++++++++++-----------------------
>  src/eval-local.h         |   4 +-
>  src/histograms.c         |  68 +++++++++----------
>  4 files changed, 150 insertions(+), 147 deletions(-)
> 
<>
> @@ -802,13 +779,9 @@ static void display_process_stats(struct traceeval *teval,
>  {
>  	struct traceeval_stat *stat;
>  	unsigned long long delta;
> -	union traceeval_data keys[] = {
> -		{
> -			.cstring = comm,
> -		},
> -		{
> -			.number = RUNNING,
> -		}
> +	struct traceeval_data keys[] = {
> +		DEFINE_TRACEEVAL_CSTRING(	comm		),
> +		DEFINE_TRACEEVAL_NUMBER(	RUNNING		),
>  	};
>  
>  	for (int i = 0; i < OTHER; i++) {

Just after this in display_process_stats we have:

> 	for (int i = 0; i < OTHER; i++) {
> 		keys[1].number = i;

Which I think we want to set with the new macro TRACEEVAL_SET_NUMBER().

                TRACEEVAL_SET_NUMBER(keys[1], i)

Other than that you can add:

Reviewed-by: Ross Zwisler <zwisler@google.com>
