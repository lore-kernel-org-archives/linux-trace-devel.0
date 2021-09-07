Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56835C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Sep 2021 14:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B16C61101
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Sep 2021 14:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344752AbhIGO6b (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Sep 2021 10:58:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242343AbhIGO6b (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Sep 2021 10:58:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD383610FE;
        Tue,  7 Sep 2021 14:57:24 +0000 (UTC)
Date:   Tue, 7 Sep 2021 10:57:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] libtracefs: Fix sometimes uninitialized warning.
Message-ID: <20210907105723.327be286@gandalf.local.home>
In-Reply-To: <20210902224840.2518539-1-irogers@google.com>
References: <20210902224840.2518539-1-irogers@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  2 Sep 2021 15:48:40 -0700
Ian Rogers <irogers@google.com> wrote:

> The warning with clang looks like:
> 
> src/tracefs-sqlhist.c:1107:2: error: variable 'cmp' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
>         default:
>         ^~~~~~~
> third_party/libtracefs/src/tracefs-sqlhist.c:1112:35: note: uninitialized use occurs here
>                             filter->lval->field.field, cmp, val);
>                                                        ^~~
> third_party/libtracefs/src/tracefs-sqlhist.c:1033:2: note: variable 'cmp' is declared here
>         enum tracefs_compare cmp;
> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  src/tracefs-sqlhist.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
> index 6224677..f4dc004 100644
> --- a/src/tracefs-sqlhist.c
> +++ b/src/tracefs-sqlhist.c
> @@ -1105,7 +1105,7 @@ static int build_filter(struct tep_handle *tep, struct sqlhist_bison *sb,
>  	case FILTER_BIN_AND:	cmp = TRACEFS_COMPARE_AND; break;
>  	case FILTER_STR_CMP:	cmp = TRACEFS_COMPARE_RE; break;
>  	default:
> -		break;
> +		abort();

Hmm, I wonder if we should do something different than call abort().

Although this should never happen, I think it's rather rude of a library
function to call abort() when it fails.

I'd like to see this simply return an error. At most, a warning can be
printed.

Thanks!

-- Steve


>  	}
>  
>  	ret = append_filter(synth, TRACEFS_FILTER_COMPARE,

