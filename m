Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45134C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 20:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2946A611CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 20:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbhIJUCO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 16:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232310AbhIJUCO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 16:02:14 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14974611EF;
        Fri, 10 Sep 2021 20:01:03 +0000 (UTC)
Date:   Fri, 10 Sep 2021 16:01:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] libtracefs: Transform
 tracefs_hist_add_sort_key()
Message-ID: <20210910160101.2ef82513@gandalf.local.home>
In-Reply-To: <20210910163857.324696-3-y.karadz@gmail.com>
References: <20210910163857.324696-1-y.karadz@gmail.com>
        <20210910163857.324696-3-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 10 Sep 2021 19:38:55 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The current version of the API makes it hard to add multiple sort keys
> to a histogram. The only way to do this is to use the variadic arguments,
> however in order to do this the caller have to know the number of sort
> keys at compile time, because the method overwrite all previously added
> keys. The problem is addressed by splitting tracefs_hist_add_sort_key()
> into two methods - one that overwrite and one that does not.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  include/tracefs.h  |  4 +++-
>  src/tracefs-hist.c | 21 +++++++++++++++++++--
>  2 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 64fbb3f..c3fa1d6 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -303,7 +303,9 @@ int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
>  			 enum tracefs_hist_key_type type);
>  int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
>  int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
> -			      const char *sort_key, ...);
> +			      char *sort_key);

Why did you remove the const? The add_sort_key() takes a const and makes a
copy of it.

> +int tracefs_hist_sort_key(struct tracefs_hist *hist,
> +			  const char *sort_key, ...);
>  int tracefs_hist_sort_key_direction(struct tracefs_hist *hist,
>  				    const char *sort_key,
>  				    enum tracefs_hist_sort_direction dir);
> diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
> index 8501d64..2ea90d9 100644
> --- a/src/tracefs-hist.c
> +++ b/src/tracefs-hist.c
> @@ -453,6 +453,23 @@ add_sort_key(struct tracefs_hist *hist, const char *sort_key, char **list)
>  	return tracefs_list_add(list, sort_key);
>  }
>  

Needs a kerneldoc documentation header.

> +int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
> +			      char *sort_key)
> +{
> +	char **list = hist->sort;
> +
> +	if (!hist || !sort_key)
> +		return -1;
> +
> +	list = add_sort_key(hist, sort_key, hist->sort);
> +	if (!list)
> +		return -1;
> +
> +	hist->sort = list;
> +
> +	return 0;
> +}
> +
>  /**
>   * tracefs_hist_add_sort_key - add a key for sorting the histogram

The above name needs to be updated.

>   * @hist: The histogram to add the sort key to
> @@ -464,8 +481,8 @@ add_sort_key(struct tracefs_hist *hist, const char *sort_key, char **list)
>   *
>   * Returns 0 on success, -1 on error.
>   */
> -int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
> -			      const char *sort_key, ...)
> +int tracefs_hist_sort_key(struct tracefs_hist *hist,

How about if we call this:

	tracefs_hist_replace_sort_keys()

I think that would be a more intuitive name.

-- Steve

> +			  const char *sort_key, ...)
>  {
>  	char **list = NULL;
>  	char **tmp;

