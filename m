Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69351C001DE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Aug 2023 22:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjHBWvo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 18:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjHBWvn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 18:51:43 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19ED213F
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Aug 2023 15:51:42 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-77a62a84855so12526639f.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Aug 2023 15:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691016702; x=1691621502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SuNQsfEUTS5Rfqzvm8vzbQA9pvZAlHPrNANpRpnXizY=;
        b=rnxmNMvr/BhdcVniCtxnDdTC4o1sqBl14Gj89Sbdv0TIIhhLxQaeGwxrF4Sxc/Puj8
         vnzlpvXUzFfKul9fgDi20QR20G7dHRe1onu7ZHqBxWevcc7FO6lwgclS7JHPZP3bTXyJ
         ObsPqUj2LpA4jJDDAzNb+D251tju6d2jZEtKLpEdb+Y9iRufaQbW7qVd4YEnfa7YM6tn
         tcI5ydWxh4MZws/ecYkjT4VZvbGaynh87EebwcQTc0RLos8do1zaw5t1KKnNVbu1aFWa
         1SdBU47tsGuOf3RTYchQWd1anzI9JWnGF2Ptqal8SwtZeGA7/1YtAMBJUjOm9iOQMB3T
         PLbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691016702; x=1691621502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SuNQsfEUTS5Rfqzvm8vzbQA9pvZAlHPrNANpRpnXizY=;
        b=D7lncpz49Ej13SxMX+c1j2Dv08bW9okooUD3kBd6UYkVXLTa9kEEEmc5/iq0teMIHK
         /k29QpsiDB81iQaOwImPk94eSqSjxO6Lm3tWy63drCLpbnAmiSY9qzTEUo3wh+wldgzl
         y/o4pPyskKPIT1D5UnfTxtjKSTyJLhXkUP+0Z5FDZz0GZuR6VsNx10hayQSY9yNFomhp
         2DgckonCoxyhrMyhUpW0MfUE47cH8omhzFq+qvP5mhD0fWPugnUXhcq/4S2fKgM1WUC0
         +n+4VwLRXYsELc5EfDaj6211C8rkRmt8lG7tdFy4WDDQgO1zK07EUsFP147cV8ahMsnG
         sB7g==
X-Gm-Message-State: ABy/qLaltSaIyzeWeArbl9m2r6ru8PNeUU7HgG0zKSrC2xxgkA+nziA/
        QmyYi9yTLwx6bnc0+14QdFU7cQcJRrHDtUHLdbu/xw==
X-Google-Smtp-Source: APBJJlFyrn6vCpYYOu1972JxjN/A5ugWbD6rl8F1gJ5Xm+3momkonQpDOHE6vJpeQTdiLiycioACLg==
X-Received: by 2002:a5e:a510:0:b0:790:ca22:8d7d with SMTP id 16-20020a5ea510000000b00790ca228d7dmr4946519iog.10.1691016702019;
        Wed, 02 Aug 2023 15:51:42 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:ed66:72dd:1728:767d])
        by smtp.gmail.com with ESMTPSA id i15-20020a6bf40f000000b007791e286fdbsm5144538iog.21.2023.08.02.15.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 15:51:41 -0700 (PDT)
Date:   Wed, 2 Aug 2023 16:51:36 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/5] histograms: traceeval compare
Message-ID: <20230802225136.GD2416079@google.com>
References: <20230728190515.23088-1-stevie.6strings@gmail.com>
 <20230728190515.23088-4-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728190515.23088-4-stevie.6strings@gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Jul 28, 2023 at 03:04:39PM -0400, Stevie Alvarez wrote:
> From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>
> 
> traceeval_compare() compares two struct traceeval instances for
> equality. This suite of comparitors was made for testing purposes.
> 
> Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> ---
>  src/histograms.c | 178 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 176 insertions(+), 2 deletions(-)
> 
> diff --git a/src/histograms.c b/src/histograms.c
> index f46a0e0..5f1c7ef 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -20,6 +20,19 @@
>  #define for_each_key(i, keys)	\
>  	for (i = 0; (keys)[(i)].type != TRACEEVAL_TYPE_NONE; (i)++)
>  
> +/**
> + * Compare two integers of variable length.
> + *
> + * Return 0 if @a and @b are the same, 1 if @a is greater than @b, and -1
> + * if @b is greater than @a.
> + */
> +#define compare_numbers_return(a, b)	\
> +do {					\
> +	if ((a) < (b))			\
> +		return -1;		\
> +	return (a) != (b);		\
> +} while (0)				\
> +
>  /** A key-value pair */
>  struct entry {
>  	union traceeval_data	*keys;
> @@ -56,10 +69,171 @@ static void print_err(const char *fmt, ...)
>  	fprintf(stderr, "\n");
>  }
>  
> -// TODO
> +/**
> + * Return 0 if @orig and @copy are the same, 1 otherwise.
> + */
> +static int compare_traceeval_type(struct traceeval_type *orig,
> +		struct traceeval_type *copy)
> +{
> +	int o_name_null;
> +	int c_name_null;
> +
> +	// same memory/null
> +	if (orig == copy)
> +		return 0;
> +
> +	size_t i = 0;

Best practice is to put all the variable definitions at the top of the
function.

> +	do {
> +		if (orig[i].type != copy[i].type)
> +			return 1;
> +		if (orig[i].type == TRACEEVAL_TYPE_NONE)
> +			return 0;
> +		if (orig[i].flags != copy[i].flags)
> +			return 1;
> +		if (orig[i].id != copy[i].id)
> +			return 1;
> +		if (orig[i].dyn_release != copy[i].dyn_release)
> +			return 1;
> +		if (orig[i].dyn_cmp != copy[i].dyn_cmp)
> +			return 1;
> +
> +		// make sure both names are same type
> +		o_name_null = !orig[i].name;
> +		c_name_null = !copy[i].name;
> +		if (o_name_null != c_name_null)
> +			return 1;
> +		if (o_name_null)
> +			continue;
> +		if (strcmp(orig[i].name, copy[i].name) != 0)
> +			return 1;
> +	} while (orig[i++].type != TRACEEVAL_TYPE_NONE);
> +
> +	return 0;
> +}

<snip>

> +/**
> + * Return 0 if struct hist_table of @orig and @copy are the same, 1 if not,
> + * and -1 on error.
> + */
> +static int compare_hist(struct traceeval *orig, struct traceeval *copy)
> +{
> +	struct hist_table *o_hist = orig->hist;
> +	struct hist_table *c_hist = copy->hist;
> +	int cnt = !(o_hist->nr_entries == c_hist->nr_entries);
> +	if (cnt)
> +		return 1;
> +
> +	for (size_t i = 0; i < o_hist->nr_entries; i++) {
> +		// cmp each entry
> +		compare_entries(&o_hist->map[i], &c_hist->map[i], orig);

Need to check the return value of 'compare_entries()' and return it if it's
nonzero.

> +	}
> +	return 0;	
> +}
> +
> +/**
> + * Return 0 if @orig and @copy are the same, 1 if not, -1 if error.
> + */
>  int traceeval_compare(struct traceeval *orig, struct traceeval *copy)
>  {
> -	return -1;
> +	if ((!orig) || (!copy))

No need for parens, this can just be:

  if (!orig || !copy)
    return -1;

> +		return -1;
> +
> +	int keys = compare_traceeval_type(orig->def_keys, copy->def_keys);
> +	int vals = compare_traceeval_type(orig->def_vals, copy->def_vals);
> +	int hists = compare_hist(orig, copy);
> +
> +	return (keys || vals || hists);
>  }
>  
>  /**
> -- 
> 2.41.0
> 
