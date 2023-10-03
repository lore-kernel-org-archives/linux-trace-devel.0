Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390ED36AF1
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Oct 2023 15:39:26 +0000 (UTC)
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7980E95
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Oct 2023 08:39:24 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-79545e141c7so27785039f.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Oct 2023 08:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696347564; x=1696952364; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lxdcIJXO5SRNAl5hRcBYPCG+SqkiITgJyWsDIsH5RiY=;
        b=Yfh00nNu+EIV4kFvSKrlyxY1wIQP7/l+geaaQfDhcmUz/qdlFYWQbnpN8WaiSCm9HL
         /Nf3VxoKOTsAlZIF0l9prtv0OHR8AuAU7EVb+UlZa8a/oNz/Sjk6yHSGYOSpKr80Sdy4
         u0OKhVdkLrZ0U31s0D4tZSL2quUtDGMU5zK1FmUCY//sUG5hASmVwlbS4X81wDld3/hx
         TtkL+M7Kt5gFgd3eJRwY81hwzT5uUr8GToMqOwb/zF1jlEKmGtsvDKEAapWHScBtLWGg
         eScrQiMUGb4SamMWzsBqVHDr2/QFy0VL3No6AScrufF1srO5xttmcD1WwVhRuUlBVqGQ
         HYsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696347564; x=1696952364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lxdcIJXO5SRNAl5hRcBYPCG+SqkiITgJyWsDIsH5RiY=;
        b=sT5Xl3+oNV75OXl9EO6APtn8/U0oj6rEGXiyCBw60Wl3yjgUZtkdqHrKIfm6Rwv/jw
         yU55dlkMjg6mYiWjYlgNnXzhd1zUJZlUrtZCEib28UEfVfNCFloVxBI0H1xRSXEFZvAg
         gqTmJax2rnHzNZJrRdCVAlhofhPMsnw+KwxxywfYJ9xEuoerwVUHZIeFfTSk7Naqnl9g
         O7tliGrA2JdKw5nxJzGuRhyDwRTL31IxfpzrVyfbxG6z8ts6GJwFnt5komrcZgw9IWt6
         GvJimzj8pMItrmf1rTSFTOxZRWvP/28rEIIqGvpHHHdRjw6PudFmFzvZ8T4ay56FdV/F
         Ls1g==
X-Gm-Message-State: AOJu0YwBLRIOcCiNElRlbznGPKFAdOvFOXiOr317Z7kL9KZ+5LLvTuOk
	ZdbftCLzH8Xsh/vsk9JWB3cBgTdY404mWDoF3NGm0w==
X-Google-Smtp-Source: AGHT+IHLj8HOqm4inKn6z8vVE72BL2RN2s+vKS8/wmTF+sgJk6vpXyCHKpY3KUv+6Vg7ABZzy7zf2w==
X-Received: by 2002:a6b:7907:0:b0:790:b44f:b9ee with SMTP id i7-20020a6b7907000000b00790b44fb9eemr2033305iop.10.1696347563637;
        Tue, 03 Oct 2023 08:39:23 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:d5ff:6f50:bbbd:a922])
        by smtp.gmail.com with ESMTPSA id c7-20020a5e8f07000000b00790b6b9d14bsm400008iok.49.2023.10.03.08.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 08:39:23 -0700 (PDT)
Date: Tue, 3 Oct 2023 09:39:20 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 1/2] libtraceeval: Remove need to use
 TRACEEVAL_TYPE_NONE in keys and vals
Message-ID: <20231003153920.GC1935474@google.com>
References: <20231003140802.1139616-1-rostedt@goodmis.org>
 <20231003140802.1139616-2-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231003140802.1139616-2-rostedt@goodmis.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Oct 03, 2023 at 10:08:01AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Currently, the size of the keys and vals are determined by the
> requirement that the traceeval_type array end with an empty element of
> type TRACEEVAL_TYPE_NONE.
> 
> To make the API be able to handle changes of the size of that structure,
> the traceeval_init() was converted to a macro to pass in the sizeof of
> that structure. This also means it can calculate the size of the array
> with the TRACEEVAL_ARRAY_SIZE() macro.
> 
> Remove the need to have the initialization of traceeval keys and vals
> have to add the NONE element at the end. It can still do so and this
> will work just the same (the size will be determined by either the size
> passed in or the first NONE element, which ever is smaller).
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

IMO trying to support both types of inputs (ending with TRACEEVAL_TYPE_NONE
and just relying on the element count) is probably bad long term because one
or the other will break and we may not notice, and we'll have to make sure we
keep up both.

As we don't really have users yet (do we?) can we just move fully over to the
count way and give on the other?

In either case, we probably need to still update the comments above
type_alloc(), traceeval_init_data_size() and traceeval_insert_size() which
talk about how we rely on TRACEEVAL_TYPE_NONE to terminate our element lists.

What we have here though is correct:
Reviewed-by: Ross Zwisler <zwisler@google.com>

> ---
>  include/traceeval-hist.h | 11 +++++++++--
>  src/histograms.c         | 23 +++++++++++++----------
>  2 files changed, 22 insertions(+), 12 deletions(-)
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index 65a905034773..cd089b28b852 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
> @@ -171,12 +171,19 @@ struct traceeval;
>  
>  /* Histogram interfaces */
>  
> -#define traceeval_init(keys, vals) \
> -	traceeval_init_data_size(keys, vals, sizeof(struct traceeval_type), \
> +#define traceeval_init(keys, vals)					\
> +	traceeval_init_size(keys, vals,					\
> +			    TRACEEVAL_ARRAY_SIZE(keys),			\
> +			    (void *)vals == NULL ?  0 : TRACEEVAL_ARRAY_SIZE(vals))
> +
> +#define traceeval_init_size(keys, vals, nr_keys, nr_vals)		\
> +	traceeval_init_data_size(keys, vals, nr_keys, nr_vals,		\
> +				 sizeof(struct traceeval_type),		\
>  				 sizeof(struct traceeval_data))
>  
>  struct traceeval *traceeval_init_data_size(struct traceeval_type *keys,
>  					   struct traceeval_type *vals,
> +					   size_t nr_keys, size_t nr_vals,
>  					   size_t sizeof_type, size_t sizeof_data);
>  
>  void traceeval_release(struct traceeval *teval);
> diff --git a/src/histograms.c b/src/histograms.c
> index d8ee373be705..0f20d76b5e04 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -151,7 +151,8 @@ static void type_release(struct traceeval_type *defs, size_t len)
>   * Returns the size of the array pointed to by @copy, or -1 on error.
>   */
>  static size_t type_alloc(const struct traceeval_type *defs,
> -			 struct traceeval_type **copy)
> +			 struct traceeval_type **copy,
> +			 size_t cnt)
>  {
>  	struct traceeval_type *new_defs = NULL;
>  	size_t size;
> @@ -162,7 +163,8 @@ static size_t type_alloc(const struct traceeval_type *defs,
>  	if (!defs)
>  		return 0;
>  
> -	for (size = 0; defs && defs[size].type != TRACEEVAL_TYPE_NONE; size++)
> +	for (size = 0; defs && size < cnt &&
> +		     defs[size].type != TRACEEVAL_TYPE_NONE; size++)
>  		;
>  
>  	if (!size)
> @@ -198,9 +200,9 @@ fail:
>  	return -1;
>  }
>  
> -static int check_keys(struct traceeval_type *keys)
> +static int check_keys(struct traceeval_type *keys, int cnt)
>  {
> -	for (int i = 0; keys[i].type != TRACEEVAL_TYPE_NONE; i++) {
> +	for (int i = 0; i < cnt && keys[i].type != TRACEEVAL_TYPE_NONE; i++) {
>  		/* Define this as a key */
>  		keys[i].flags |= TRACEEVAL_FL_KEY;
>  		keys[i].flags &= ~TRACEEVAL_FL_VALUE;
> @@ -220,9 +222,9 @@ static int check_keys(struct traceeval_type *keys)
>  	return 0;
>  }
>  
> -static int check_vals(struct traceeval_type *vals)
> +static int check_vals(struct traceeval_type *vals, int cnt)
>  {
> -	for (int i = 0; vals[i].type != TRACEEVAL_TYPE_NONE; i++) {
> +	for (int i = 0; i < cnt && vals[i].type != TRACEEVAL_TYPE_NONE; i++) {
>  		/* Define this as a value */
>  		vals[i].flags |= TRACEEVAL_FL_VALUE;
>  		vals[i].flags &= ~TRACEEVAL_FL_KEY;
> @@ -269,6 +271,7 @@ static int check_vals(struct traceeval_type *vals)
>   */
>  struct traceeval *traceeval_init_data_size(struct traceeval_type *keys,
>  					   struct traceeval_type *vals,
> +					   size_t nr_keys, size_t nr_vals,
>  					   size_t sizeof_type, size_t sizeof_data)
>  {
>  	struct traceeval *teval;
> @@ -290,25 +293,25 @@ struct traceeval *traceeval_init_data_size(struct traceeval_type *keys,
>  		goto fail;
>  	}
>  
> -	ret = check_keys(keys);
> +	ret = check_keys(keys, nr_keys);
>  	if (ret < 0)
>  		goto fail_release;
>  
>  	if (vals) {
> -		ret = check_vals(vals);
> +		ret = check_vals(vals, nr_vals);
>  		if (ret < 0)
>  			goto fail_release;
>  	}
>  
>  	/* alloc key types */
> -	teval->nr_key_types = type_alloc(keys, &teval->key_types);
> +	teval->nr_key_types = type_alloc(keys, &teval->key_types, nr_keys);
>  	if (teval->nr_key_types <= 0) {
>  		err_msg = "Failed to allocate user defined keys";
>  		goto fail_release;
>  	}
>  
>  	/* alloc val types */
> -	teval->nr_val_types = type_alloc(vals, &teval->val_types);
> +	teval->nr_val_types = type_alloc(vals, &teval->val_types, nr_vals);
>  	if (teval->nr_val_types < 0) {
>  		err_msg = "Failed to allocate user defined values";
>  		goto fail_release;
> -- 
> 2.40.1
> 
