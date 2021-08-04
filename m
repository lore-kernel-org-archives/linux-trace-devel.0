Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6678C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Aug 2021 00:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EFC060E96
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Aug 2021 00:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhHDAvC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 20:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhHDAvC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 20:51:02 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D43E60EE8;
        Wed,  4 Aug 2021 00:50:49 +0000 (UTC)
Date:   Tue, 3 Aug 2021 20:50:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Claire Jensen <cjense@google.com>
Subject: Re: [PATCH 1/2] libtracefs: Silence non-literal-null-conversion
 warning
Message-ID: <20210803205048.2e7e44be@rorschach.local.home>
In-Reply-To: <20210804004109.1476661-1-irogers@google.com>
References: <20210804004109.1476661-1-irogers@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  3 Aug 2021 17:41:08 -0700
Ian Rogers <irogers@google.com> wrote:

> diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
> index 63bb413..a502c2d 100644
> --- a/src/tracefs-utils.c
> +++ b/src/tracefs-utils.c
> @@ -470,7 +470,7 @@ int tracefs_list_pop(char **list)
>  	size--;
>  	*list = (char *)size;
>  	list++;
> -	list[size] = '\0';
> +	list[size] = NULL;

Regardless of a clang warning, that code was an oops.

Thanks for the fix.

-- Steve


>  	return 0;
>  }
>  
